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
    gpVW,
    gpInt,
    gpPickupID,
    Text3D:gpLabelID,
    gpEnabled
};
new GasPumps[MAX_GAS_PUMPS][E_GAS_PUMP];
new GasPumpCount;

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
    for(new i;i<GasPumpCount;i++) if(GetPlayerVirtualWorld(playerid)==GasPumps[i][gpVW] && GetPlayerInterior(playerid)==GasPumps[i][gpInt] && IsPlayerInRangeOfPoint(playerid,4.0,GasPumps[i][gpX],GasPumps[i][gpY],GasPumps[i][gpZ])) return i;
    return -1;
}

CMD:createpump(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid,COLOR_GREY,"You are not authorized.");
    new bid; if(sscanf(params,"d",bid)) return ER_Send(playerid,COLOR_GREY,"USAGE: /createpump [gas business id]");
    new idx=ER_FindBusinessIndexBySQLID(bid); if(idx==-1 || Businesses[idx][bType] != BUSINESS_TYPE_GAS) return ER_Send(playerid,COLOR_GREY,"Invalid gas station business.");
    new Float:x,Float:y,Float:z,q[256]; GetPlayerPos(playerid,x,y,z);
    mysql_format(MainPipeline,q,sizeof(q),"INSERT INTO `gas_pumps` (`business_id`,`x`,`y`,`z`,`vw`,`interior`,`enabled`) VALUES (%d,%f,%f,%f,%d,%d,1)",bid,x,y,z,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid));
    mysql_tquery(MainPipeline,q,"ER_OnGasPumpCreated","i",playerid); return 1;
}
forward ER_OnGasPumpCreated(playerid);
public ER_OnGasPumpCreated(playerid){new id=cache_insert_id(),msg[96]; ER_LoadGasPumps(); format(msg,sizeof(msg),"Gas pump created with ID %d.",id); return ER_Send(playerid,COLOR_GREEN,msg);}
CMD:editpumps(playerid, params[]){if(!ER_IsAdmin(playerid,ADMIN_SENIOR)) return ER_Send(playerid,COLOR_GREY,"You are not authorized."); new list[2048],line[96]; for(new i;i<GasPumpCount;i++){format(line,sizeof(line),"%d - Business %d\n",GasPumps[i][gpSQLID],GasPumps[i][gpBusinessID]);strcat(list,line,sizeof(list));} if(!list[0]) format(list,sizeof(list),"No gas pumps."); return ShowPlayerDialog(playerid,DIALOG_GAS_PUMP_LIST,DIALOG_STYLE_LIST,"Gas Pumps",list,"Edit","Close");}
CMD:editpump(playerid, params[]){new id;if(!ER_IsAdmin(playerid,ADMIN_SENIOR)) return ER_Send(playerid,COLOR_GREY,"You are not authorized."); if(sscanf(params,"d",id)) return ER_Send(playerid,COLOR_GREY,"USAGE: /editpump [id]"); SetPVarInt(playerid,"EditingPump",id); return ShowPlayerDialog(playerid,DIALOG_GAS_PUMP_EDITOR,DIALOG_STYLE_LIST,"Gas Pump Editor","Goto\nSet Position Here\nSet Business ID\nDelete", "Select","Close");}
CMD:deletepump(playerid, params[]){new id,q[128];if(!ER_IsAdmin(playerid,ADMIN_SENIOR)) return ER_Send(playerid,COLOR_GREY,"You are not authorized."); if(sscanf(params,"d",id)) return ER_Send(playerid,COLOR_GREY,"USAGE: /deletepump [id]"); mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gas_pumps` SET `enabled`=0 WHERE `id`=%d",id);mysql_tquery(MainPipeline,q);ER_LoadGasPumps();return ER_Send(playerid,COLOR_GREEN,"Gas pump deleted.");}

CMD:refuel(playerid, params[])
{
    new pump=ER_GetNearestGasPump(playerid); if(pump==-1) return ER_Send(playerid,COLOR_GREY,"You are not at a fuel pump.");
    if(!IsPlayerInAnyVehicle(playerid)) return ER_Send(playerid,COLOR_GREY,"You must be in a vehicle to refuel.");
    new amount; if(sscanf(params,"D(25)",amount)) amount=25; if(amount<1) amount=1; if(amount>100) amount=100;
    new bid=GasPumps[pump][gpBusinessID], bidx=ER_FindBusinessIndexBySQLID(bid), price=amount*25;
    if(GetPlayerMoney(playerid) < price) return ER_Send(playerid,COLOR_GREY,"You do not have enough cash.");
    GivePlayerMoney(playerid, -price); PlayerInfo[playerid][pCash] -= price;
    if(bidx != -1){Businesses[bidx][bSafeBalance]+=price; new q[128];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `businesses` SET `safe_balance`=`safe_balance`+%d WHERE `id`=%d",price,bid);mysql_tquery(MainPipeline,q);}
    GameTextForPlayer(playerid,"~y~Refueling Vehicle...",3000,3);
    new msg[128]; format(msg,sizeof(msg),"You refueled your vehicle for %s.",ER_FormatMoney(price)); ER_Send(playerid,COLOR_GREEN,msg);
    return 1;
}

stock ER_GasDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid==DIALOG_GAS_PUMP_LIST){if(!response)return 1;if(listitem<0||listitem>=GasPumpCount)return 1;SetPVarInt(playerid,"EditingPump",GasPumps[listitem][gpSQLID]);return ShowPlayerDialog(playerid,DIALOG_GAS_PUMP_EDITOR,DIALOG_STYLE_LIST,"Gas Pump Editor","Goto\nSet Position Here\nSet Business ID\nDelete", "Select","Close");}
    if(dialogid==DIALOG_GAS_PUMP_EDITOR){if(!response)return 1;new id=GetPVarInt(playerid,"EditingPump"),idx=ER_FindGasPumpIndexBySQLID(id),q[256],Float:x,Float:y,Float:z;if(idx==-1)return 1;SetPVarInt(playerid,"PumpEditAction",listitem);if(listitem==0){SetPlayerInterior(playerid,GasPumps[idx][gpInt]);SetPlayerVirtualWorld(playerid,GasPumps[idx][gpVW]);SetPlayerPos(playerid,GasPumps[idx][gpX],GasPumps[idx][gpY],GasPumps[idx][gpZ]+1.0);return 1;}if(listitem==1){GetPlayerPos(playerid,x,y,z);mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gas_pumps` SET `x`=%f,`y`=%f,`z`=%f,`vw`=%d,`interior`=%d WHERE `id`=%d",x,y,z,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),id);mysql_tquery(MainPipeline,q);ER_LoadGasPumps();return ER_Send(playerid,COLOR_GREEN,"Pump position saved.");}if(listitem==2)return ShowPlayerDialog(playerid,DIALOG_GAS_PUMP_INPUT,DIALOG_STYLE_INPUT,"Pump Business","Enter gas business ID:","Save","Back");if(listitem==3)return ShowPlayerDialog(playerid,DIALOG_GAS_PUMP_DELETE_CONFIRM,DIALOG_STYLE_MSGBOX,"Delete Pump","Delete this pump?","Delete","Cancel");}
    if(dialogid==DIALOG_GAS_PUMP_INPUT){if(!response)return 1;new id=GetPVarInt(playerid,"EditingPump"),bid=strval(inputtext),bidx=ER_FindBusinessIndexBySQLID(bid),q[128];if(bidx==-1||Businesses[bidx][bType]!=BUSINESS_TYPE_GAS)return ER_Send(playerid,COLOR_GREY,"Invalid gas business.");mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gas_pumps` SET `business_id`=%d WHERE `id`=%d",bid,id);mysql_tquery(MainPipeline,q);ER_LoadGasPumps();return ER_Send(playerid,COLOR_GREEN,"Pump business updated.");}
    if(dialogid==DIALOG_GAS_PUMP_DELETE_CONFIRM){if(!response)return 1;new id=GetPVarInt(playerid,"EditingPump"),q[128];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gas_pumps` SET `enabled`=0 WHERE `id`=%d",id);mysql_tquery(MainPipeline,q);ER_LoadGasPumps();return ER_Send(playerid,COLOR_GREEN,"Pump deleted.");}
    return 0;
}
