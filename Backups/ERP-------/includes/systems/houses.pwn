#if defined _ER_HOUSES_INCLUDED
    #endinput
#endif
#define _ER_HOUSES_INCLUDED

#define HOUSE_OWNER_NONE 0
#define HOUSE_OWNER_PLAYER 1
#define HOUSE_OWNER_FAMILY 2
#define HOUSE_OWNER_FACTION 3

stock ER_FindHouseIndexBySQLID(sqlid)
{
    for(new i; i < HouseCount; i++) if(Houses[i][hSQLID] == sqlid) return i;
    return -1;
}
stock ER_DefaultHousePrice(const zone[])
{
    new price = 150000;
    if(strfind(zone, "Idlewood", true) != -1 || strfind(zone, "Ganton", true) != -1 || strfind(zone, "Willowfield", true) != -1) price = 90000 + random(70000);
    else if(strfind(zone, "Vinewood", true) != -1 || strfind(zone, "Richman", true) != -1 || strfind(zone, "Rodeo", true) != -1 || strfind(zone, "Mulholland", true) != -1) price = 500000 + random(600000);
    else price = 180000 + random(200000);
    return price;
}
stock ER_SetHouseInteriorDefaults(hid, &Float:x, &Float:y, &Float:z, &Float:a, &interior, &vw)
{
    vw = hid;
    switch(random(4))
    {
        case 0: { x = 223.0439; y = 1289.2598; z = 1082.1999; a = 0.0; interior = 1; }
        case 1: { x = 225.7569; y = 1240.0000; z = 1082.1499; a = 0.0; interior = 2; }
        case 2: { x = 2496.0498; y = -1695.2382; z = 1014.7422; a = 180.0; interior = 3; }
        default: { x = 2365.3149; y = -1135.6025; z = 1050.8750; a = 0.0; interior = 8; }
    }
    return 1;
}
stock ER_ClearHouseWorld()
{
    for(new i; i < HouseCount; i++)
    {
        if(Houses[i][hPickupID]) DestroyDynamicPickup(Houses[i][hPickupID]);
        if(Houses[i][hLabelID]) DestroyDynamic3DTextLabel(Houses[i][hLabelID]);
        Houses[i][hPickupID] = 0; Houses[i][hLabelID] = Text3D:0;
    }
    return 1;
}
stock ER_FormatHouseLabel(idx, label[], size)
{
    if(Houses[idx][hOwnerType] == HOUSE_OWNER_NONE || Houses[idx][hOwnerID] == 0)
    {
        format(label, size, "%s House For Sale!\nPrice: %s\nHouse ID: %d", Houses[idx][hZone], ER_FormatMoney(Houses[idx][hPrice]), Houses[idx][hSQLID]);
    }
    else if(Houses[idx][hOwnerType] == HOUSE_OWNER_PLAYER)
    {
        new owner[32]; format(owner, sizeof(owner), "%s", Houses[idx][hOwnerName]); for(new c; owner[c]; c++) if(owner[c] == '_') owner[c] = ' ';
        format(label, size, "%s's House\nOwner: %s\n%s{FFFF00}\nHouse ID: %d", owner, owner, Houses[idx][hLocked] ? ("{FF0000}Locked") : ("{00FF00}Unlocked"), Houses[idx][hSQLID]);
    }
    else
    {
        format(label, size, "%s HQ\nOwner: %s\n%s{FFFF00}\nHouse ID: %d", Houses[idx][hOwnerName], Houses[idx][hOwnerName], Houses[idx][hLocked] ? ("{FF0000}Locked") : ("{00FF00}Unlocked"), Houses[idx][hSQLID]);
    }
    return 1;
}
stock ER_CreateHouseWorld(idx)
{
    new label[192]; ER_FormatHouseLabel(idx, label, sizeof(label));
    Houses[idx][hPickupID] = CreateDynamicPickup(Houses[idx][hPickupModel], Houses[idx][hPickupType] ? Houses[idx][hPickupType] : 23, Houses[idx][hExtX], Houses[idx][hExtY], Houses[idx][hExtZ], Houses[idx][hExtVW], Houses[idx][hExtInt]);
    Houses[idx][hLabelID] = CreateDynamic3DTextLabel(label, COLOR_YELLOW, Houses[idx][hExtX], Houses[idx][hExtY], Houses[idx][hExtZ] + 0.35, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Houses[idx][hExtVW], Houses[idx][hExtInt]);
    return 1;
}

stock ER_UpdateHouseLabel(idx)
{
    if(idx < 0 || idx >= HouseCount) return 0;
    if(!Houses[idx][hLabelID]) return 0;
    new label[192];
    ER_FormatHouseLabel(idx, label, sizeof(label));
    UpdateDynamic3DTextLabelText(Houses[idx][hLabelID], COLOR_YELLOW, label);
    return 1;
}
stock ER_LoadHouses()
{
    ER_ClearHouseWorld();
    mysql_tquery(MainPipeline, "SELECT * FROM `houses` WHERE `enabled`=1", "ER_OnHousesLoad");
    return 1;
}

stock ER_LoadHouseRowFromCache(row, idx)
{
    cache_get_value_name_int(row, "id", Houses[idx][hSQLID]);
    cache_get_value_name(row, "zone", Houses[idx][hZone], 32);
    cache_get_value_name(row, "custom_name", Houses[idx][hCustomName], 64);
    cache_get_value_name_int(row, "owner_type", Houses[idx][hOwnerType]);
    cache_get_value_name_int(row, "owner_id", Houses[idx][hOwnerID]);
    cache_get_value_name(row, "owner_name", Houses[idx][hOwnerName], MAX_PLAYER_NAME_EX);
    cache_get_value_name_int(row, "price", Houses[idx][hPrice]);
    cache_get_value_name_int(row, "price_mode", Houses[idx][hPriceMode]);
    cache_get_value_name_float(row, "ext_x", Houses[idx][hExtX]);
    cache_get_value_name_float(row, "ext_y", Houses[idx][hExtY]);
    cache_get_value_name_float(row, "ext_z", Houses[idx][hExtZ]);
    cache_get_value_name_float(row, "ext_a", Houses[idx][hExtA]);
    cache_get_value_name_int(row, "ext_int", Houses[idx][hExtInt]);
    cache_get_value_name_int(row, "ext_vw", Houses[idx][hExtVW]);
    cache_get_value_name_float(row, "int_x", Houses[idx][hIntX]);
    cache_get_value_name_float(row, "int_y", Houses[idx][hIntY]);
    cache_get_value_name_float(row, "int_z", Houses[idx][hIntZ]);
    cache_get_value_name_float(row, "int_a", Houses[idx][hIntA]);
    cache_get_value_name_int(row, "int_int", Houses[idx][hIntInt]);
    cache_get_value_name_int(row, "int_vw", Houses[idx][hIntVW]);
    cache_get_value_name_int(row, "safe_balance", Houses[idx][hSafeBalance]);
    cache_get_value_name_int(row, "materials", Houses[idx][hMaterials]);
    cache_get_value_name_int(row, "pot", Houses[idx][hPot]);
    cache_get_value_name_int(row, "crack", Houses[idx][hCrack]);
    cache_get_value_name_int(row, "pickup_model", Houses[idx][hPickupModel]);
    cache_get_value_name_int(row, "pickup_type", Houses[idx][hPickupType]);
    cache_get_value_name_int(row, "locked", Houses[idx][hLocked]);
    cache_get_value_name_int(row, "custom_ext", Houses[idx][hCustomExt]);
    cache_get_value_name_int(row, "custom_int", Houses[idx][hCustomInt]);
    cache_get_value_name_int(row, "enabled", Houses[idx][hEnabled]);
    if(Houses[idx][hPickupType] <= 0) Houses[idx][hPickupType] = 23;
    if(Houses[idx][hPickupModel] <= 0) Houses[idx][hPickupModel] = 1273;
    return 1;
}

stock ER_DestroyHouseWorldSlot(idx)
{
    if(idx < 0 || idx >= MAX_HOUSES) return 0;
    if(Houses[idx][hPickupID]) DestroyDynamicPickup(Houses[idx][hPickupID]);
    if(Houses[idx][hLabelID]) DestroyDynamic3DTextLabel(Houses[idx][hLabelID]);
    Houses[idx][hPickupID] = 0;
    Houses[idx][hLabelID] = Text3D:0;
    return 1;
}

stock ER_ReloadHouseBySQLID(sqlid, playerid = INVALID_PLAYER_ID)
{
    new q[128];
    mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `houses` WHERE `id`=%d LIMIT 1", sqlid);
    mysql_tquery(MainPipeline, q, "ER_OnSingleHouseReload", "ii", sqlid, playerid);
    return 1;
}

forward ER_OnSingleHouseReload(sqlid, playerid);
public ER_OnSingleHouseReload(sqlid, playerid)
{
    new rows; cache_get_row_count(rows);
    new idx = ER_FindHouseIndexBySQLID(sqlid);

    if(!rows)
    {
        if(idx != -1)
        {
            ER_DestroyHouseWorldSlot(idx);
            Houses[idx][hEnabled] = 0;
        }
        if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "House reloaded: not found or removed.");
        return 1;
    }

    if(idx == -1)
    {
        if(HouseCount >= MAX_HOUSES) return 0;
        idx = HouseCount++;
    }
    else ER_DestroyHouseWorldSlot(idx);

    ER_LoadHouseRowFromCache(0, idx);
    if(Houses[idx][hEnabled]) ER_CreateHouseWorld(idx);
    if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "House reloaded.");
    return 1;
}
forward ER_OnHousesLoad();
public ER_OnHousesLoad()
{
    new rows; cache_get_row_count(rows); HouseCount = 0;
    for(new r; r < rows && HouseCount < MAX_HOUSES; r++)
    {
        ER_LoadHouseRowFromCache(r, HouseCount);
        ER_CreateHouseWorld(HouseCount);
        HouseCount++;
    }
    printf("[Houses] Loaded %d houses.", HouseCount); return 1;
}
CMD:createhouse(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new Float:x, Float:y, Float:z, Float:a, zone[32]; GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a); ER_GetPlayerZone(playerid, zone, sizeof(zone)); new price = ER_DefaultHousePrice(zone);
    new q[512]; mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `houses` (`zone`,`owner_type`,`owner_id`,`owner_name`,`price`,`price_mode`,`ext_x`,`ext_y`,`ext_z`,`ext_a`,`ext_int`,`ext_vw`,`pickup_model`,`pickup_type`,`locked`,`enabled`) VALUES ('%e',0,0,'Nobody',%d,0,%f,%f,%f,%f,%d,%d,1273,1,1,1)", zone, price, x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid)); mysql_tquery(MainPipeline, q, "ER_OnHouseCreated", "i", playerid); return 1;
}
forward ER_OnHouseCreated(playerid);
public ER_OnHouseCreated(playerid)
{
    new hid = cache_insert_id();
    new Float:x, Float:y, Float:z, Float:a, interior, vw;
    ER_SetHouseInteriorDefaults(hid, x, y, z, a, interior, vw);
    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `houses` SET `int_x`=%f,`int_y`=%f,`int_z`=%f,`int_a`=%f,`int_int`=%d,`int_vw`=%d WHERE `id`=%d", x, y, z, a, interior, vw, hid);
    mysql_tquery(MainPipeline, q, "ER_OnHouseCreateFinal", "ii", playerid, hid);
    return 1;
}

forward ER_OnHouseCreateFinal(playerid, hid);
public ER_OnHouseCreateFinal(playerid, hid)
{
    ER_ReloadHouseBySQLID(hid, playerid);
    ER_Send(playerid, COLOR_GREEN, "House created. Use /edithouse [id] to edit it.");
    return 1;
}
stock ER_GetNearestHouse(playerid, bool:inside = true)
{
    new vw = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);
    for(new i; i < HouseCount; i++)
    {
        if(inside && vw == Houses[i][hIntVW] && interior == Houses[i][hIntInt]) return i;
        if(IsPlayerInRangeOfPoint(playerid, 3.0, Houses[i][hExtX], Houses[i][hExtY], Houses[i][hExtZ]) && vw == Houses[i][hExtVW] && interior == Houses[i][hExtInt]) return i;
    }
    return -1;
}
stock ER_PlayerOwnsHouse(playerid, idx) { return Houses[idx][hOwnerType] == HOUSE_OWNER_PLAYER && Houses[idx][hOwnerID] == PlayerInfo[playerid][pID]; }
stock ER_TryEnterHouse(playerid)
{
    new idx = ER_GetNearestHouse(playerid, false);
    if(idx == -1) return 0;
    if(Houses[idx][hLocked])
    {
        ER_Send(playerid, COLOR_GREY, "This house is locked.");
        return 1;
    }

    new rp[144], Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if(ER_PlayerOwnsHouse(playerid, idx)) format(rp, sizeof(rp), "* %s enters his house.", ER_GetName(playerid));
    else format(rp, sizeof(rp), "* %s enters the house.", ER_GetName(playerid));
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

    SetPlayerInterior(playerid, Houses[idx][hIntInt]);
    SetPlayerVirtualWorld(playerid, Houses[idx][hIntVW]);
    SetPlayerPos(playerid, Houses[idx][hIntX], Houses[idx][hIntY], Houses[idx][hIntZ]);
    SetPlayerFacingAngle(playerid, Houses[idx][hIntA]);
    if(Houses[idx][hCustomInt]) ER_StreamPrep(playerid, Houses[idx][hIntX], Houses[idx][hIntY], Houses[idx][hIntZ], Houses[idx][hIntVW], Houses[idx][hIntInt], "House Interior");
    return 1;
}
stock ER_TryExitHouse(playerid)
{
    new idx = ER_GetNearestHouse(playerid, true);
    if(idx == -1) return 0;

    new rp[144], Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if(ER_PlayerOwnsHouse(playerid, idx)) format(rp, sizeof(rp), "* %s exits his house.", ER_GetName(playerid));
    else format(rp, sizeof(rp), "* %s exits the house.", ER_GetName(playerid));
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

    SetPlayerInterior(playerid, Houses[idx][hExtInt]);
    SetPlayerVirtualWorld(playerid, Houses[idx][hExtVW]);
    SetPlayerPos(playerid, Houses[idx][hExtX], Houses[idx][hExtY], Houses[idx][hExtZ]);
    SetPlayerFacingAngle(playerid, Houses[idx][hExtA]);
    if(Houses[idx][hCustomExt]) ER_StreamPrep(playerid, Houses[idx][hExtX], Houses[idx][hExtY], Houses[idx][hExtZ], Houses[idx][hExtVW], Houses[idx][hExtInt], "House Exterior");
    return 1;
}
CMD:buyhouse(playerid, params[])
{
    new idx = ER_GetNearestHouse(playerid, false); if(idx == -1) return ER_Send(playerid, COLOR_GREY, "You are not near a house.");
    if(Houses[idx][hOwnerType] != HOUSE_OWNER_NONE || Houses[idx][hOwnerID] != 0) return ER_Send(playerid, COLOR_GREY, "This house is already owned.");
    new owned; for(new i; i < HouseCount; i++) if(Houses[i][hOwnerType] == HOUSE_OWNER_PLAYER && Houses[i][hOwnerID] == PlayerInfo[playerid][pID]) owned++;
    if(owned >= ER_GetMaxHouses(playerid)) return ER_Send(playerid, COLOR_GREY, "You have reached your house ownership limit.");
    if(PlayerInfo[playerid][pCash] < Houses[idx][hPrice]) return ER_Send(playerid, COLOR_GREY, "You do not have enough cash.");
    PlayerInfo[playerid][pCash] -= Houses[idx][hPrice]; GivePlayerMoney(playerid, -Houses[idx][hPrice]); new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `houses` SET `owner_type`=1,`owner_id`=%d,`owner_name`='%e',`locked`=1 WHERE `id`=%d", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], Houses[idx][hSQLID]); mysql_tquery(MainPipeline, q); ER_ReloadHouseBySQLID(Houses[idx][hSQLID], playerid); return ER_Send(playerid, COLOR_GREEN, "House purchased.");
}

stock ER_ShowMyHouseMenu(playerid, hid)
{
    new idx = ER_FindHouseIndexBySQLID(hid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid house.");
    if(!ER_PlayerOwnsHouse(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You do not own this house.");
    SetPVarInt(playerid, "MyHouse", hid);
    new title[96], body[512];
    format(title, sizeof(title), "House Menu - ID %d", hid);
    format(body, sizeof(body), "House Information\nTrack House\nLock / Unlock House\nHouse Storage\nSet Spawn Here\nSell House");
    ShowPlayerDialog(playerid, DIALOG_MY_HOUSE_MENU, DIALOG_STYLE_LIST, title, body, "Select", "Close");
    return 1;
}

CMD:myhouses(playerid, params[])
{
    new list[2048], count;
    for(new i; i < HouseCount; i++) if(ER_PlayerOwnsHouse(playerid, i))
    {
        ER_BuyProductID[playerid][count] = Houses[i][hSQLID];
        format(list, sizeof(list), "%s%d - %s's House (ID %d) - %s\n", list, count + 1, ER_GetName(playerid), Houses[i][hSQLID], Houses[i][hZone]);
        count++;
    }
    if(!count) return ER_Send(playerid, COLOR_GREY, "You do not own any houses.");
    ER_BuyProductCount[playerid] = count;
    ShowPlayerDialog(playerid, DIALOG_HOUSE_LIST, DIALOG_STYLE_LIST, "My Houses", list, "Select", "Close");
    return 1;
}

CMD:managehouse(playerid, params[])
{
    new idx = ER_GetNearestHouse(playerid, true);
    if(idx == -1) idx = ER_GetNearestHouse(playerid, false);
    if(idx == -1 || !ER_PlayerOwnsHouse(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You are not at your house.");
    return ER_ShowMyHouseMenu(playerid, Houses[idx][hSQLID]);
}
CMD:house(playerid, params[])
{
    #pragma unused params
    new idx = ER_GetNearestHouse(playerid, true);
    if(idx == -1) idx = ER_GetNearestHouse(playerid, false);
    if(idx == -1 || !ER_PlayerOwnsHouse(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You are not at your house.");
    return ER_ShowMyHouseMenu(playerid, Houses[idx][hSQLID]);
}

CMD:housestorage(playerid, params[]) { return ER_ShowHouseStorage(playerid); }
stock ER_ShowHouseStorage(playerid)
{
    new idx = ER_GetNearestHouse(playerid, true); if(idx == -1 || !ER_PlayerOwnsHouse(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You are not inside your house.");
    new msg[256]; format(msg, sizeof(msg), "Cash Safe: %s\nMaterials: %d\nPot: %d\nCrack: %d\nGuns: use house weapons table", ER_FormatMoney(Houses[idx][hSafeBalance]), Houses[idx][hMaterials], Houses[idx][hPot], Houses[idx][hCrack]); ShowPlayerDialog(playerid, DIALOG_HOUSE_STORAGE, DIALOG_STYLE_MSGBOX, "House Storage", msg, "Close", ""); return 1;
}
CMD:hstorage(playerid, params[])
{
    return ER_ShowHouseStorage(playerid);
}
CMD:edithouse(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized."); new hid; if(sscanf(params, "d", hid)) return ER_Send(playerid, COLOR_GREY, "USAGE: /edithouse [id]"); SetPVarInt(playerid, "EditingHouse", hid); ShowPlayerDialog(playerid, DIALOG_HOUSE_EDITOR, DIALOG_STYLE_LIST, "House Editor", "Set Exterior Position\nSet Interior Position\nSet Interior VW Manually\nReset Interior VW To Default\nSet Pickup Icon\nToggle Locked\nToggle CustomExt Stream Freeze\nToggle CustomInt Stream Freeze\nReload This House\nDelete House", "Select", "Close"); return 1;
}
stock ER_SendHouseLockRP(playerid, idx, bool:locked)
{
    if(idx < 0 || idx >= HouseCount) return 0;
    new Float:x, Float:y, Float:z, rp[144];
    GetPlayerPos(playerid, x, y, z);
    if(ER_PlayerOwnsHouse(playerid, idx))
        format(rp, sizeof(rp), "* %s %s his house.", ER_GetName(playerid), locked ? ("locks") : ("unlocks"));
    else
        format(rp, sizeof(rp), "* %s %s the house.", ER_GetName(playerid), locked ? ("locks") : ("unlocks"));
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

CMD:lock(playerid, params[])
{
    new idx = ER_GetNearestHouse(playerid, false);
    if(idx == -1) idx = ER_GetNearestHouse(playerid, true);

    if(idx != -1 && ER_PlayerOwnsHouse(playerid, idx))
    {
        Houses[idx][hLocked] = !Houses[idx][hLocked];
        new q[128];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `houses` SET `locked`=%d WHERE `id`=%d", Houses[idx][hLocked], Houses[idx][hSQLID]);
        mysql_tquery(MainPipeline, q);
        ER_UpdateHouseLabel(idx);
        ER_SendHouseLockRP(playerid, idx, Houses[idx][hLocked] ? true : false);
        return 1;
    }

    if(ER_TryBusinessLock(playerid)) return 1;
    if(ER_TryDoorLock(playerid)) return 1;
    return ER_Send(playerid, COLOR_GREY, "You are not near something you can lock.");
}
stock ER_HouseDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_HOUSE_LIST)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= ER_BuyProductCount[playerid]) return 1;
        return ER_ShowMyHouseMenu(playerid, ER_BuyProductID[playerid][listitem]);
    }
    if(dialogid == DIALOG_MY_HOUSE_MENU)
    {
        if(!response) return 1;
        new hid = GetPVarInt(playerid, "MyHouse"), idx = ER_FindHouseIndexBySQLID(hid);
        if(idx == -1 || !ER_PlayerOwnsHouse(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You do not own this house.");
        switch(listitem)
        {
            case 0:
            {
                new msg[256];
                format(msg, sizeof(msg), "Location: %s\nPrice: %s\nSafe: %s\nMaterials: %d\nPot: %d\nCrack: %d\nStatus: %s", Houses[idx][hZone], ER_FormatMoney(Houses[idx][hPrice]), ER_FormatMoney(Houses[idx][hSafeBalance]), Houses[idx][hMaterials], Houses[idx][hPot], Houses[idx][hCrack], Houses[idx][hLocked] ? ("Locked") : ("Unlocked"));
                ShowPlayerDialog(playerid, DIALOG_MY_HOUSE_MENU + 50, DIALOG_STYLE_MSGBOX, "House Information", msg, "Back", "");
                return 1;
            }
            case 1:
            {
                SetPlayerCheckpoint(playerid, Houses[idx][hExtX], Houses[idx][hExtY], Houses[idx][hExtZ], 4.0);
                SetPVarInt(playerid, "TrackHouse", hid);
                return ER_Send(playerid, COLOR_GREEN, "House location marked on your map.");
            }
            case 2:
            {
                Houses[idx][hLocked] = !Houses[idx][hLocked];
                new q[128];
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `houses` SET `locked`=%d WHERE `id`=%d", Houses[idx][hLocked], hid);
                mysql_tquery(MainPipeline, q);
                ER_UpdateHouseLabel(idx);
                ER_SendHouseLockRP(playerid, idx, Houses[idx][hLocked] ? true : false);
                return ER_ShowMyHouseMenu(playerid, hid);
            }
            case 3: return ER_ShowHouseStorage(playerid);
            case 4: { PlayerInfo[playerid][pSpawnX]=Houses[idx][hIntX]; PlayerInfo[playerid][pSpawnY]=Houses[idx][hIntY]; PlayerInfo[playerid][pSpawnZ]=Houses[idx][hIntZ]; PlayerInfo[playerid][pSpawnA]=Houses[idx][hIntA]; PlayerInfo[playerid][pSpawnInt]=Houses[idx][hIntInt]; PlayerInfo[playerid][pSpawnVW]=Houses[idx][hIntVW]; ER_SaveLastPosition(playerid,true); return ER_Send(playerid, COLOR_GREEN, "House spawn set to this house interior."); }
            case 5:
            {
                new refund = Houses[idx][hPrice] / 2;
                PlayerInfo[playerid][pCash] += refund;
                GivePlayerMoney(playerid, refund);
                new q[256];
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `houses` SET `owner_type`=0,`owner_id`=0,`owner_name`='Nobody',`locked`=1 WHERE `id`=%d", Houses[idx][hSQLID]);
                mysql_tquery(MainPipeline, q);
                ER_ReloadHouseBySQLID(Houses[idx][hSQLID], playerid);
                return ER_Send(playerid, COLOR_GREEN, "House sold for 50 percent of its price.");
            }
        }
        return 1;
    }
    if(dialogid == DIALOG_MY_HOUSE_MENU + 50)
    {
        return ER_ShowMyHouseMenu(playerid, GetPVarInt(playerid, "MyHouse"));
    }

    if(dialogid == DIALOG_HOUSE_INPUT)
    {
        if(!response) return 1;
        new hid = GetPVarInt(playerid, "EditingHouse"), idx = ER_FindHouseIndexBySQLID(hid);
        if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid house.");
        new field = GetPVarInt(playerid, "HouseInputField"), q[128];
        if(field == 1)
        {
            new vw = strval(inputtext);
            if(vw < 0) return ER_Send(playerid, COLOR_GREY, "Invalid virtual world.");
            Houses[idx][hIntVW] = vw;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `houses` SET `int_vw`=%d WHERE `id`=%d", vw, hid);
            mysql_tquery(MainPipeline, q);
            return ER_Send(playerid, COLOR_GREEN, "House interior VW updated.");
        }
        return 1;
    }
    if(dialogid == DIALOG_HOUSE_EDITOR)
    {
        if(!response) return 1; new hid = GetPVarInt(playerid, "EditingHouse"), idx = ER_FindHouseIndexBySQLID(hid); if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid house.");
        if(listitem == 0) { GetPlayerPos(playerid, Houses[idx][hExtX], Houses[idx][hExtY], Houses[idx][hExtZ]); GetPlayerFacingAngle(playerid, Houses[idx][hExtA]); Houses[idx][hExtInt]=GetPlayerInterior(playerid); Houses[idx][hExtVW]=GetPlayerVirtualWorld(playerid); new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `houses` SET `ext_x`=%f,`ext_y`=%f,`ext_z`=%f,`ext_a`=%f,`ext_int`=%d,`ext_vw`=%d WHERE `id`=%d", Houses[idx][hExtX],Houses[idx][hExtY],Houses[idx][hExtZ],Houses[idx][hExtA],Houses[idx][hExtInt],Houses[idx][hExtVW],hid); mysql_tquery(MainPipeline,q); ER_ReloadHouseBySQLID(hid, playerid); return ER_Send(playerid,COLOR_GREEN,"House exterior saved."); }
        if(listitem == 1) { GetPlayerPos(playerid, Houses[idx][hIntX], Houses[idx][hIntY], Houses[idx][hIntZ]); GetPlayerFacingAngle(playerid, Houses[idx][hIntA]); Houses[idx][hIntInt]=GetPlayerInterior(playerid); new q[256]; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `houses` SET `int_x`=%f,`int_y`=%f,`int_z`=%f,`int_a`=%f,`int_int`=%d WHERE `id`=%d",Houses[idx][hIntX],Houses[idx][hIntY],Houses[idx][hIntZ],Houses[idx][hIntA],Houses[idx][hIntInt],hid); mysql_tquery(MainPipeline,q); return ER_Send(playerid,COLOR_GREEN,"House interior saved. VW was not changed."); }
        if(listitem == 2) { SetPVarInt(playerid, "HouseInputField", 1); return ShowPlayerDialog(playerid, DIALOG_HOUSE_INPUT, DIALOG_STYLE_INPUT, "Manual Interior VW", "Enter manual interior virtual world:", "Save", "Back"); }
        if(listitem == 3) { new q[128]; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `houses` SET `int_vw`=%d WHERE `id`=%d",Houses[idx][hExtVW],hid); mysql_tquery(MainPipeline,q); Houses[idx][hIntVW] = Houses[idx][hExtVW]; ER_ReloadHouseBySQLID(hid, playerid); return ER_Send(playerid,COLOR_GREEN,"House interior VW reset to default house VW."); }
        if(listitem == 5) { Houses[idx][hLocked]=!Houses[idx][hLocked]; new q[128]; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `houses` SET `locked`=%d WHERE `id`=%d",Houses[idx][hLocked],hid); mysql_tquery(MainPipeline,q); ER_UpdateHouseLabel(idx); ER_SendHouseLockRP(playerid, idx, Houses[idx][hLocked] ? true : false); return 1; }
        if(listitem == 6) { Houses[idx][hCustomExt]=!Houses[idx][hCustomExt]; new q[128]; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `houses` SET `custom_ext`=%d WHERE `id`=%d",Houses[idx][hCustomExt],hid); mysql_tquery(MainPipeline,q); return ER_Send(playerid,COLOR_GREEN,"House Custom Exterior streaming toggled."); }
        if(listitem == 7) { Houses[idx][hCustomInt]=!Houses[idx][hCustomInt]; new q[128]; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `houses` SET `custom_int`=%d WHERE `id`=%d",Houses[idx][hCustomInt],hid); mysql_tquery(MainPipeline,q); return ER_Send(playerid,COLOR_GREEN,"House Custom Interior streaming toggled."); }
        if(listitem == 8) { ER_ReloadHouseBySQLID(hid, playerid); return ER_Send(playerid,COLOR_GREEN,"House reloaded."); }
        return ER_Send(playerid, COLOR_GREY, "This house editor item is not active; use position, lock, or stream options.");
    }
    return 0;
}

CMD:sellhouse(playerid, params[])
{
    new idx = ER_GetNearestHouse(playerid, false);
    if(idx == -1) idx = ER_GetNearestHouse(playerid, true);
    if(idx == -1 || !ER_PlayerOwnsHouse(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You are not near your house.");
    new refund = Houses[idx][hPrice] / 2;
    PlayerInfo[playerid][pCash] += refund; GivePlayerMoney(playerid, refund);
    new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `houses` SET `owner_type`=0,`owner_id`=0,`owner_name`='Nobody',`locked`=1 WHERE `id`=%d", Houses[idx][hSQLID]); mysql_tquery(MainPipeline, q);
    ER_ReloadHouseBySQLID(Houses[idx][hSQLID], playerid); return ER_Send(playerid, COLOR_GREEN, "House sold for 50 percent of its price.");
}
