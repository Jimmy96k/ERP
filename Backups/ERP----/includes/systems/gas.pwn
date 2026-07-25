#if defined _ER_GAS_INCLUDED
    #endinput
#endif
#define _ER_GAS_INCLUDED

enum E_GAS_PUMP
{
    gpSQLID,
    gpBusinessID,
    Float:gpX,
    Float:gpY,
    Float:gpZ,
    Float:gpX2,
    Float:gpY2,
    Float:gpZ2,
    gpVW,
    gpInt,
    gpPickupID,
    Text3D:gpLabelID,
    gpEnabled
};
new GasPumps[MAX_GAS_PUMPS][E_GAS_PUMP];
new GasPumpCount;
new GasPumpDialogList[MAX_PLAYERS][MAX_GAS_PUMPS];


new bool:ER_RefuelActive[MAX_PLAYERS];
new ER_RefuelTimer[MAX_PLAYERS];
new ER_RefuelVehicleIdx[MAX_PLAYERS];
new ER_RefuelVehicleID[MAX_PLAYERS];
new ER_RefuelBusinessID[MAX_PLAYERS];
new ER_RefuelBusinessIdx[MAX_PLAYERS];
new ER_RefuelProductID[MAX_PLAYERS];
new ER_RefuelPricePerUnit[MAX_PLAYERS];
new ER_RefuelTargetAmount[MAX_PLAYERS];
new ER_RefuelAddedAmount[MAX_PLAYERS];

stock ER_ClearVehicleRefuelState(playerid)
{
    if(ER_RefuelTimer[playerid])
    {
        KillTimer(ER_RefuelTimer[playerid]);
        ER_RefuelTimer[playerid] = 0;
    }
    ER_RefuelActive[playerid] = false;
    ER_RefuelVehicleIdx[playerid] = -1;
    ER_RefuelVehicleID[playerid] = 0;
    ER_RefuelBusinessID[playerid] = 0;
    ER_RefuelBusinessIdx[playerid] = -1;
    ER_RefuelProductID[playerid] = 0;
    ER_RefuelPricePerUnit[playerid] = 0;
    ER_RefuelTargetAmount[playerid] = 0;
    ER_RefuelAddedAmount[playerid] = 0;
    return 1;
}

stock ER_FinalizeVehicleRefuel(playerid, bool:completed)
{
    #pragma unused completed
    if(!ER_RefuelActive[playerid]) return 1;

    new amount = ER_RefuelAddedAmount[playerid];
    new pricePerUnit = ER_RefuelPricePerUnit[playerid];
    new totalPrice = amount * pricePerUnit;
    new bid = ER_RefuelBusinessID[playerid];
    new bidx = ER_RefuelBusinessIdx[playerid];
    new productid = ER_RefuelProductID[playerid];

    ER_ClearVehicleRefuelState(playerid);

    if(amount <= 0)
    {
        return 1;
    }

    if(totalPrice > 0)
    {
        if(PlayerInfo[playerid][pCash] < totalPrice)
        {
            // Safety fallback: this should normally not happen because the tick stops before overcharging.
            totalPrice = PlayerInfo[playerid][pCash];
        }

        PlayerInfo[playerid][pCash] -= totalPrice;
        if(IsPlayerConnected(playerid)) GivePlayerMoney(playerid, -totalPrice);
        if(bidx >= 0 && bidx < MAX_BUSINESSES) Businesses[bidx][bSafeBalance] += totalPrice;

        new q[256];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `stock`=GREATEST(`stock`-%d,0) WHERE `id`=%d AND `business_id`=%d AND `product_key`='gas'", amount, productid, bid);
        mysql_tquery(MainPipeline, q);
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=`safe_balance`+%d WHERE `id`=%d", totalPrice, bid);
        mysql_tquery(MainPipeline, q);
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `cash`=%d WHERE `id`=%d", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pID]);
        mysql_tquery(MainPipeline, q);
    }

    if(IsPlayerConnected(playerid))
    {
        new msg[160];
        format(msg, sizeof(msg), "You refueled %d gallons for %s.", amount, ER_FormatMoney(totalPrice));
        ER_Send(playerid, COLOR_GREEN, msg);
    }
    return 1;
}

forward ER_VehicleRefuelTick(playerid);
public ER_VehicleRefuelTick(playerid)
{
    if(!ER_RefuelActive[playerid]) return 1;

    if(!IsPlayerConnected(playerid))
    {
        ER_FinalizeVehicleRefuel(playerid, false);
        return 1;
    }

    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER || GetPlayerVehicleID(playerid) != ER_RefuelVehicleID[playerid])
    {
        ER_FinalizeVehicleRefuel(playerid, false);
        return 1;
    }

    new vehicleid = ER_RefuelVehicleID[playerid];
    new idx = ER_RefuelVehicleIdx[playerid];
    if(idx < 0 || idx >= VehicleCount)
    {
        ER_FinalizeVehicleRefuel(playerid, false);
        return 1;
    }

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    ER_NormalizeVehicleParams(engine, lights, alarm, doors, bonnet, boot, objective);

    if(engine == VEHICLE_PARAMS_ON)
    {
        ER_FinalizeVehicleRefuel(playerid, false);
        return 1;
    }

    if(ER_GetNearestGasPump(playerid) == -1)
    {
        ER_FinalizeVehicleRefuel(playerid, false);
        return 1;
    }

    if(ER_RefuelAddedAmount[playerid] >= ER_RefuelTargetAmount[playerid] || VehicleInfo[idx][vFuel] >= 100.0)
    {
        ER_FinalizeVehicleRefuel(playerid, true);
        return 1;
    }

    // Stop before adding a fuel unit the player can no longer afford.
    if(PlayerInfo[playerid][pCash] < ((ER_RefuelAddedAmount[playerid] + 1) * ER_RefuelPricePerUnit[playerid]))
    {
        ER_FinalizeVehicleRefuel(playerid, false);
        return 1;
    }

    ER_RefuelAddedAmount[playerid]++;
    ER_SetVehicleFuel(idx, VehicleInfo[idx][vFuel] + 1.0);

    new td[48];
    format(td, sizeof(td), "~y~Refueling...~n~~w~Fuel: %d%%", floatround(VehicleInfo[idx][vFuel]));
    GameTextForPlayer(playerid, td, 1100, 3);

    if(ER_RefuelAddedAmount[playerid] >= ER_RefuelTargetAmount[playerid] || VehicleInfo[idx][vFuel] >= 100.0)
    {
        ER_FinalizeVehicleRefuel(playerid, true);
    }
    return 1;
}

stock ER_OnGasPlayerDisconnect(playerid)
{
    if(ER_RefuelActive[playerid]) ER_FinalizeVehicleRefuel(playerid, false);
    return 1;
}

stock ER_ClearGasPumps()
{
    for(new i; i < GasPumpCount; i++)
    {
        if(GasPumps[i][gpPickupID]) DestroyDynamicPickup(GasPumps[i][gpPickupID]);
        if(GasPumps[i][gpLabelID]) DestroyDynamic3DTextLabel(GasPumps[i][gpLabelID]);
    }
    GasPumpCount = 0;
    return 1;
}
stock ER_CreateGasPumpWorld(idx)
{
    new label[160]; format(label, sizeof(label), "{FFFF00}Fuel Pump\n{FFFFFF}Business ID: %d\nPump ID: %d\nUse /refuel", GasPumps[idx][gpBusinessID], GasPumps[idx][gpSQLID]);
    GasPumps[idx][gpPickupID] = CreateDynamicPickup(1650, 23, GasPumps[idx][gpX], GasPumps[idx][gpY], GasPumps[idx][gpZ], GasPumps[idx][gpVW], GasPumps[idx][gpInt]);
    GasPumps[idx][gpLabelID] = CreateDynamic3DTextLabel(label, COLOR_YELLOW, GasPumps[idx][gpX], GasPumps[idx][gpY], GasPumps[idx][gpZ] + 0.35, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, GasPumps[idx][gpVW], GasPumps[idx][gpInt]);
    return 1;
}
stock ER_LoadGasPumps()
{
    ER_ClearGasPumps(); mysql_tquery(MainPipeline, "SELECT * FROM `gas_pumps` WHERE `enabled`=1 ORDER BY `id` ASC", "ER_OnGasPumpsLoad"); return 1;
}
forward ER_OnGasPumpsLoad();
public ER_OnGasPumpsLoad()
{
    new rows; cache_get_row_count(rows);
    for(new r; r < rows && GasPumpCount < MAX_GAS_PUMPS; r++)
    {
        cache_get_value_name_int(r,"id",GasPumps[GasPumpCount][gpSQLID]);
        cache_get_value_name_int(r,"business_id",GasPumps[GasPumpCount][gpBusinessID]);
        cache_get_value_name_float(r,"x",GasPumps[GasPumpCount][gpX]);
        cache_get_value_name_float(r,"y",GasPumps[GasPumpCount][gpY]);
        cache_get_value_name_float(r,"z",GasPumps[GasPumpCount][gpZ]);
        cache_get_value_name_float(r,"x2",GasPumps[GasPumpCount][gpX2]);
        cache_get_value_name_float(r,"y2",GasPumps[GasPumpCount][gpY2]);
        cache_get_value_name_float(r,"z2",GasPumps[GasPumpCount][gpZ2]);
        cache_get_value_name_int(r,"vw",GasPumps[GasPumpCount][gpVW]);
        cache_get_value_name_int(r,"interior",GasPumps[GasPumpCount][gpInt]);
        cache_get_value_name_int(r,"enabled",GasPumps[GasPumpCount][gpEnabled]);
        ER_CreateGasPumpWorld(GasPumpCount); GasPumpCount++;
    }
    printf("[GasPumps] Loaded %d gas pumps.", GasPumpCount); return 1;
}
stock ER_FindGasPumpIndexBySQLID(id){for(new i;i<GasPumpCount;i++) if(GasPumps[i][gpSQLID]==id) return i; return -1;}
stock ER_GetNearestGasPump(playerid)
{
    for(new i;i<GasPumpCount;i++)
    {
        if(GetPlayerVirtualWorld(playerid)==GasPumps[i][gpVW] && GetPlayerInterior(playerid)==GasPumps[i][gpInt])
        {
            if(IsPlayerInRangeOfPoint(playerid,4.0,GasPumps[i][gpX],GasPumps[i][gpY],GasPumps[i][gpZ])) return i;
            if(IsPlayerInRangeOfPoint(playerid,4.0,GasPumps[i][gpX2],GasPumps[i][gpY2],GasPumps[i][gpZ2])) return i;
        }
    }
    return -1;
}

CMD:createpump(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid,COLOR_GREY,"You are not authorized.");
    new bid; if(sscanf(params,"d",bid)) return ER_Send(playerid,COLOR_GREY,"USAGE: /createpump [gas business id]");
    new idx=ER_FindBusinessIndexBySQLID(bid); if(idx==-1 || Businesses[idx][bType] != BUSINESS_TYPE_GAS) return ER_Send(playerid,COLOR_GREY,"Invalid gas station business.");
    new Float:x,Float:y,Float:z,q[256]; GetPlayerPos(playerid,x,y,z);
    mysql_format(MainPipeline,q,sizeof(q),"INSERT INTO `gas_pumps` (`business_id`,`x`,`y`,`z`,`x2`,`y2`,`z2`,`vw`,`interior`,`enabled`) VALUES (%d,%f,%f,%f,%f,%f,%f,%d,%d,1)",bid,x,y,z,x,y,z,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid));
    mysql_tquery(MainPipeline,q,"ER_OnGasPumpCreated","i",playerid); return 1;
}
forward ER_OnGasPumpCreated(playerid);
public ER_OnGasPumpCreated(playerid){new id=cache_insert_id(),msg[96]; ER_LoadGasPumps(); format(msg,sizeof(msg),"Gas pump created with ID %d.",id); return ER_Send(playerid,COLOR_GREEN,msg);}

stock ER_ShowGasPumpListForBusiness(playerid, bid)
{
    new list[4096], line[128], count;
    SetPVarInt(playerid, "GasPumpListMode", 1);
    for(new i; i < GasPumpCount && count < MAX_GAS_PUMPS; i++)
    {
        if(GasPumps[i][gpBusinessID] == bid)
        {
            GasPumpDialogList[playerid][count] = i;
            format(line, sizeof(line), "%d - Gas Pump - Location %.1f, %.1f, %.1f\n", GasPumps[i][gpSQLID], GasPumps[i][gpX], GasPumps[i][gpY], GasPumps[i][gpZ]);
            strcat(list, line, sizeof(list));
            count++;
        }
    }
    SetPVarInt(playerid, "GasPumpListCount", count);
    if(!count) format(list, sizeof(list), "No gas pumps linked to this business.");
    return ShowPlayerDialog(playerid, DIALOG_GAS_PUMP_LIST, DIALOG_STYLE_LIST, "Gas Pumps", list, "Edit", "Back");
}

CMD:editpumps(playerid, params[])
{
    SetPVarInt(playerid, "GasPumpListMode", 0);

    if(!ER_IsAdmin(playerid, ADMIN_SENIOR))
        return ER_Send(playerid, COLOR_GREY, "You are not authorized.");

    new list[2048], line[96];

    for(new i; i < GasPumpCount; i++)
    {
        format(line, sizeof(line), "%d - Gas Pump - Business %d Location %.1f, %.1f, %.1f\n", GasPumps[i][gpSQLID], GasPumps[i][gpBusinessID], GasPumps[i][gpX], GasPumps[i][gpY], GasPumps[i][gpZ]);
        strcat(list, line, sizeof(list));
    }

    if(!list[0])
        format(list, sizeof(list), "No gas pumps.");

    return ShowPlayerDialog(playerid, DIALOG_GAS_PUMP_LIST, DIALOG_STYLE_LIST, "Gas Pumps", list, "Edit", "Close");
}
CMD:editpump(playerid, params[])
{
    new id;

    if(!ER_IsAdmin(playerid, ADMIN_SENIOR))
        return ER_Send(playerid, COLOR_GREY, "You are not authorized.");

    if(sscanf(params, "d", id))
        return ER_Send(playerid, COLOR_GREY, "USAGE: /editpump [id]");

    SetPVarInt(playerid, "EditingPump", id);

    return ShowPlayerDialog(playerid, DIALOG_GAS_PUMP_EDITOR, DIALOG_STYLE_LIST, "Gas Pump Editor", "Goto\nSet Position 1 Here\nSet Position 2 Here\nSet Business ID\nDelete", "Select", "Close");
}
CMD:deletepump(playerid, params[])
{
    new id, q[128];

    if(!ER_IsAdmin(playerid, ADMIN_SENIOR))
        return ER_Send(playerid, COLOR_GREY, "You are not authorized.");

    if(sscanf(params, "d", id))
        return ER_Send(playerid, COLOR_GREY, "USAGE: /deletepump [id]");

    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `gas_pumps` SET `enabled`=0 WHERE `id`=%d", id);
    mysql_tquery(MainPipeline, q);
    ER_LoadGasPumps();

    return ER_Send(playerid, COLOR_GREEN, "Gas pump deleted.");
}


CMD:refillcan(playerid, params[])
{
    if(!ER_RequireJobType(playerid, JOB_TYPE_MECHANIC, "refillcan")) return 1;
    if(!PlayerInfo[playerid][pHasJerryCan]) return ER_Send(playerid, COLOR_GREY, "You do not have a Jerry Can.");

    new pump = ER_GetNearestGasPump(playerid);
    if(pump == -1) return ER_Send(playerid, COLOR_GREY, "You are not at a fuel pump.");

    new capacity = ER_GetMechanicJerryCanCapacity(playerid);
    new current = floatround(PlayerInfo[playerid][pJerryCanFuel]);
    new needed = capacity - current;
    if(needed <= 0) return ER_Send(playerid, COLOR_GREY, "Your Jerry Can is already full.");

    new amount;
    if(sscanf(params, "D(0)", amount)) amount = 0;
    if(amount <= 0 || amount > needed) amount = needed;

    new bid = GasPumps[pump][gpBusinessID], bidx = ER_FindBusinessIndexBySQLID(bid);
    if(bidx == -1 || Businesses[bidx][bType] != BUSINESS_TYPE_GAS) return ER_Send(playerid, COLOR_GREY, "This fuel pump is not linked to a valid gas station.");

    SetPVarInt(playerid, "PendingJerryCanFuel", amount);
    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "SELECT `id`,`price`,`stock`,`admin_enabled`,`owner_enabled` FROM `business_products` WHERE `business_id`=%d AND `product_key`='gas' LIMIT 1", bid);
    mysql_tquery(MainPipeline, q, "ER_OnRefillJerryCanGasProduct", "ii", playerid, bid);
    return 1;
}

forward ER_OnRefillJerryCanGasProduct(playerid, bid);
public ER_OnRefillJerryCanGasProduct(playerid, bid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(!PlayerInfo[playerid][pHasJerryCan]) return ER_Send(playerid, COLOR_GREY, "You do not have a Jerry Can.");

    new idx = ER_FindBusinessIndexBySQLID(bid);
    if(idx == -1 || Businesses[idx][bType] != BUSINESS_TYPE_GAS) return ER_Send(playerid, COLOR_GREY, "Invalid gas station.");

    new rows;
    cache_get_row_count(rows);
    if(!rows) return ER_Send(playerid, COLOR_GREY, "This gas station does not have the Gas product configured.");

    new pid, pricePerUnit, gasStock, adminEnabled, ownerEnabled, amount;
    amount = GetPVarInt(playerid, "PendingJerryCanFuel");
    cache_get_value_name_int(0, "id", pid);
    cache_get_value_name_int(0, "price", pricePerUnit);
    cache_get_value_name_int(0, "stock", gasStock);
    cache_get_value_name_int(0, "admin_enabled", adminEnabled);
    cache_get_value_name_int(0, "owner_enabled", ownerEnabled);

    if(!adminEnabled || !ownerEnabled) return ER_Send(playerid, COLOR_GREY, "This gas station is not selling gas right now.");

    new capacity = ER_GetMechanicJerryCanCapacity(playerid);
    new current = floatround(PlayerInfo[playerid][pJerryCanFuel]);
    new needed = capacity - current;
    if(needed <= 0) return ER_Send(playerid, COLOR_GREY, "Your Jerry Can is already full.");
    if(amount <= 0 || amount > needed) amount = needed;
    if(gasStock < amount) return ER_Send(playerid, COLOR_GREY, "This gas station does not have enough gas in stock.");

    new totalPrice = amount * pricePerUnit;
    if(PlayerInfo[playerid][pCash] < totalPrice || GetPlayerMoney(playerid) < totalPrice) return ER_Send(playerid, COLOR_GREY, "You do not have enough cash to refill your Jerry Can.");

    PlayerInfo[playerid][pCash] -= totalPrice;
    GivePlayerMoney(playerid, -totalPrice);
    PlayerInfo[playerid][pJerryCanFuel] += float(amount);
    if(PlayerInfo[playerid][pJerryCanFuel] > float(capacity)) PlayerInfo[playerid][pJerryCanFuel] = float(capacity);
    Businesses[idx][bSafeBalance] += totalPrice;

    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `stock`=`stock`-%d WHERE `id`=%d AND `business_id`=%d AND `product_key`='gas'", amount, pid, bid);
    mysql_tquery(MainPipeline, q);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=`safe_balance`+%d WHERE `id`=%d", totalPrice, bid);
    mysql_tquery(MainPipeline, q);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `cash`=%d, `jerry_can_fuel`=%f WHERE `id`=%d", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pJerryCanFuel], PlayerInfo[playerid][pID]);
    mysql_tquery(MainPipeline, q);

    DeletePVar(playerid, "PendingJerryCanFuel");
    new msg[160];
    format(msg, sizeof(msg), "You refilled your Jerry Can with %d fuel for %s. Jerry Can: %d/%d.", amount, ER_FormatMoney(totalPrice), floatround(PlayerInfo[playerid][pJerryCanFuel]), capacity);
    ER_Send(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:refuel(playerid, params[])
{
    if(ER_RefuelActive[playerid]) return ER_Send(playerid, COLOR_GREY, "You are already refueling this vehicle.");

    new pump = ER_GetNearestGasPump(playerid);
    if(pump == -1) return ER_Send(playerid, COLOR_GREY, "You are not at a fuel pump.");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ER_Send(playerid, COLOR_GREY, "You must be the driver of a vehicle to refuel.");

    new vehicleid = GetPlayerVehicleID(playerid);
    new vidx = ER_FindVehicleBySpawnID(vehicleid);
    if(vidx == -1) return ER_Send(playerid, COLOR_GREY, "This vehicle is not saved in the vehicle system.");
    if(VehicleInfo[vidx][vUnlimitedFuel]) return ER_Send(playerid, COLOR_GREY, "This vehicle does not need refueling.");
    if(VehicleInfo[vidx][vFuel] >= 100.0) return ER_Send(playerid, COLOR_GREY, "This vehicle already has a full tank.");

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    ER_NormalizeVehicleParams(engine, lights, alarm, doors, bonnet, boot, objective);
    if(engine == VEHICLE_PARAMS_ON) return ER_Send(playerid, COLOR_GREY, "Turn off your engine before refueling.");

    new amount;
    if(sscanf(params, "D(0)", amount)) amount = 0;
    new needed = 100 - floatround(VehicleInfo[vidx][vFuel]);
    if(needed < 1) needed = 1;
    if(amount <= 0 || amount > needed) amount = needed;
    if(amount > 100) amount = 100;

    new bid = GasPumps[pump][gpBusinessID], bidx = ER_FindBusinessIndexBySQLID(bid);
    if(bidx == -1 || Businesses[bidx][bType] != BUSINESS_TYPE_GAS) return ER_Send(playerid, COLOR_GREY, "This fuel pump is not linked to a valid gas station.");

    SetPVarInt(playerid, "PendingFuelGallons", amount);
    SetPVarInt(playerid, "PendingFuelVehicleIdx", vidx);
    SetPVarInt(playerid, "PendingFuelVehicleID", vehicleid);
    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "SELECT `id`,`price`,`stock`,`admin_enabled`,`owner_enabled` FROM `business_products` WHERE `business_id`=%d AND `product_key`='gas' LIMIT 1", bid);
    mysql_tquery(MainPipeline, q, "ER_OnRefuelGasProduct", "ii", playerid, bid);
    return 1;
}

forward ER_OnRefuelGasProduct(playerid, bid);
public ER_OnRefuelGasProduct(playerid, bid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ER_Send(playerid, COLOR_GREY, "You must be the driver of a vehicle to refuel.");

    new vehicleid = GetPVarInt(playerid, "PendingFuelVehicleID");
    new vidx = GetPVarInt(playerid, "PendingFuelVehicleIdx");
    if(vehicleid == 0 || GetPlayerVehicleID(playerid) != vehicleid || vidx < 0 || vidx >= VehicleCount) return ER_Send(playerid, COLOR_GREY, "Refuel cancelled. Invalid vehicle.");
    if(VehicleInfo[vidx][vUnlimitedFuel]) return ER_Send(playerid, COLOR_GREY, "This vehicle does not need refueling.");

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    ER_NormalizeVehicleParams(engine, lights, alarm, doors, bonnet, boot, objective);
    if(engine == VEHICLE_PARAMS_ON) return ER_Send(playerid, COLOR_GREY, "Turn off your engine before refueling.");

    new idx = ER_FindBusinessIndexBySQLID(bid);
    if(idx == -1 || Businesses[idx][bType] != BUSINESS_TYPE_GAS) return ER_Send(playerid, COLOR_GREY, "Invalid gas station.");

    new rows;
    cache_get_row_count(rows);
    if(!rows) return ER_Send(playerid, COLOR_GREY, "This gas station does not have the Gas product configured. Use /editbusiness Type Settings or rebuild products.");

    new pid, pricePerGallon, gallonsInStock, adminEnabled, ownerEnabled, amount = GetPVarInt(playerid, "PendingFuelGallons");
    cache_get_value_name_int(0, "id", pid);
    cache_get_value_name_int(0, "price", pricePerGallon);
    cache_get_value_name_int(0, "stock", gallonsInStock);
    cache_get_value_name_int(0, "admin_enabled", adminEnabled);
    cache_get_value_name_int(0, "owner_enabled", ownerEnabled);

    if(!adminEnabled || !ownerEnabled) return ER_Send(playerid, COLOR_GREY, "This gas station is not selling gas right now.");
    if(pricePerGallon < 1) pricePerGallon = 1;

    new needed = 100 - floatround(VehicleInfo[vidx][vFuel]);
    if(needed <= 0) return ER_Send(playerid, COLOR_GREY, "This vehicle already has a full tank.");
    if(amount <= 0 || amount > needed) amount = needed;
    if(amount > gallonsInStock) amount = gallonsInStock;

    new affordable = PlayerInfo[playerid][pCash] / pricePerGallon;
    if(amount > affordable) amount = affordable;

    if(amount <= 0) return ER_Send(playerid, COLOR_GREY, "You cannot afford fuel or this gas station is out of stock.");

    ER_RefuelActive[playerid] = true;
    ER_RefuelVehicleIdx[playerid] = vidx;
    ER_RefuelVehicleID[playerid] = vehicleid;
    ER_RefuelBusinessID[playerid] = bid;
    ER_RefuelBusinessIdx[playerid] = idx;
    ER_RefuelProductID[playerid] = pid;
    ER_RefuelPricePerUnit[playerid] = pricePerGallon;
    ER_RefuelTargetAmount[playerid] = amount;
    ER_RefuelAddedAmount[playerid] = 0;

    if(ER_RefuelTimer[playerid]) KillTimer(ER_RefuelTimer[playerid]);
    ER_RefuelTimer[playerid] = SetTimerEx("ER_VehicleRefuelTick", 1000, true, "i", playerid);

    GameTextForPlayer(playerid, "~y~Refueling...", 2000, 3);
    return 1;
}

stock ER_GasDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_GAS_PUMP_LIST)
    {
        if(!response) return 1;
        if(GetPVarInt(playerid, "GasPumpListMode") == 1)
        {
            if(listitem < 0 || listitem >= GetPVarInt(playerid, "GasPumpListCount")) return 1;
            listitem = GasPumpDialogList[playerid][listitem];
        }
        if(listitem < 0 || listitem >= GasPumpCount) return 1;

        SetPVarInt(playerid, "EditingPump", GasPumps[listitem][gpSQLID]);
        return ShowPlayerDialog(playerid, DIALOG_GAS_PUMP_EDITOR, DIALOG_STYLE_LIST, "Gas Pump Editor", "Goto\nSet Position 1 Here\nSet Position 2 Here\nSet Business ID\nDelete", "Select", "Close");
    }

    if(dialogid == DIALOG_GAS_PUMP_EDITOR)
    {
        if(!response) return 1;

        new id = GetPVarInt(playerid, "EditingPump");
        new idx = ER_FindGasPumpIndexBySQLID(id);
        new q[256];
        new Float:x, Float:y, Float:z;

        if(idx == -1) return 1;
        SetPVarInt(playerid, "PumpEditAction", listitem);

        if(listitem == 0)
        {
            SetPlayerInterior(playerid, GasPumps[idx][gpInt]);
            SetPlayerVirtualWorld(playerid, GasPumps[idx][gpVW]);
            SetPlayerPos(playerid, GasPumps[idx][gpX], GasPumps[idx][gpY], GasPumps[idx][gpZ] + 1.0);
            return 1;
        }
        if(listitem == 1)
        {
            GetPlayerPos(playerid, x, y, z);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `gas_pumps` SET `x`=%f,`y`=%f,`z`=%f,`vw`=%d,`interior`=%d WHERE `id`=%d", x, y, z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), id);
            mysql_tquery(MainPipeline, q);
            ER_LoadGasPumps();
            return ER_Send(playerid, COLOR_GREEN, "Pump position 1 saved.");
        }
        if(listitem == 2)
        {
            GetPlayerPos(playerid, x, y, z);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `gas_pumps` SET `x2`=%f,`y2`=%f,`z2`=%f,`vw`=%d,`interior`=%d WHERE `id`=%d", x, y, z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), id);
            mysql_tquery(MainPipeline, q);
            ER_LoadGasPumps();
            return ER_Send(playerid, COLOR_GREEN, "Pump position 2 saved.");
        }
        if(listitem == 3) return ShowPlayerDialog(playerid, DIALOG_GAS_PUMP_INPUT, DIALOG_STYLE_INPUT, "Pump Business", "Enter gas business ID:", "Save", "Back");
        if(listitem == 4) return ShowPlayerDialog(playerid, DIALOG_GAS_PUMP_DELETE_CONFIRM, DIALOG_STYLE_MSGBOX, "Delete Pump", "Delete this pump?", "Delete", "Cancel");
        return 1;
    }

    if(dialogid == DIALOG_GAS_PUMP_INPUT)
    {
        if(!response) return 1;

        new id = GetPVarInt(playerid, "EditingPump");
        new bid = strval(inputtext);
        new bidx = ER_FindBusinessIndexBySQLID(bid);
        new q[128];

        if(bidx == -1 || Businesses[bidx][bType] != BUSINESS_TYPE_GAS) return ER_Send(playerid, COLOR_GREY, "Invalid gas business.");

        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `gas_pumps` SET `business_id`=%d WHERE `id`=%d", bid, id);
        mysql_tquery(MainPipeline, q);
        ER_LoadGasPumps();
        return ER_Send(playerid, COLOR_GREEN, "Pump business updated.");
    }

    if(dialogid == DIALOG_GAS_PUMP_DELETE_CONFIRM)
    {
        if(!response) return 1;

        new id = GetPVarInt(playerid, "EditingPump");
        new q[128];

        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `gas_pumps` SET `enabled`=0 WHERE `id`=%d", id);
        mysql_tquery(MainPipeline, q);
        ER_LoadGasPumps();
        return ER_Send(playerid, COLOR_GREEN, "Pump deleted.");
    }
    return 0;
}
