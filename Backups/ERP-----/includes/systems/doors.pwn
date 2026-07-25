#if defined _ER_DOORS_INCLUDED
    #endinput
#endif
#define _ER_DOORS_INCLUDED

#define DOOR_OWNER_PUBLIC 0
#define DOOR_OWNER_PLAYER 1
#define DOOR_OWNER_FAMILY 2
#define DOOR_OWNER_FACTION 3
#define DOOR_OWNER_VIP 4
#define DOOR_OWNER_ADMIN 5

new ER_DoorOwnerID[MAX_PLAYERS][64];
new ER_DoorOwnerCount[MAX_PLAYERS];

stock ER_FindDoorIndexBySQLID(sqlid) { for(new i; i < DoorCount; i++) if(Doors[i][dSQLID] == sqlid) return i; return -1; }
stock ER_ClearDoorWorld()
{
    for(new i; i < DoorCount; i++) { if(Doors[i][dPickupID]) DestroyDynamicPickup(Doors[i][dPickupID]); if(Doors[i][dLabelID]) DestroyDynamic3DTextLabel(Doors[i][dLabelID]); Doors[i][dPickupID]=0; Doors[i][dLabelID]=Text3D:0; }
    return 1;
}
stock ER_FormatDoorLabel(idx, label[], size)
{
    if(Doors[idx][dLockable]) format(label, size, "%s\n%s{FFFFFF}\nDoor ID: %d", Doors[idx][dName], Doors[idx][dLocked] ? ("{FF0000}Locked") : ("{00FF00}Unlocked"), Doors[idx][dSQLID]);
    else format(label, size, "%s\nDoor ID: %d", Doors[idx][dName], Doors[idx][dSQLID]);
    return 1;
}
stock ER_CreateDoorWorld(idx)
{
    new label[144]; ER_FormatDoorLabel(idx, label, sizeof(label));
    Doors[idx][dPickupID] = CreateDynamicPickup(Doors[idx][dPickupModel], Doors[idx][dPickupType] ? Doors[idx][dPickupType] : 23, Doors[idx][dExtX], Doors[idx][dExtY], Doors[idx][dExtZ], Doors[idx][dExtVW], Doors[idx][dExtInt]);
    Doors[idx][dLabelID] = CreateDynamic3DTextLabel(label, COLOR_WHITE, Doors[idx][dExtX], Doors[idx][dExtY], Doors[idx][dExtZ] + 0.35, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Doors[idx][dExtVW], Doors[idx][dExtInt]);
    return 1;
}

stock ER_UpdateDoorLabel(idx)
{
    if(idx < 0 || idx >= DoorCount) return 0;
    if(!Doors[idx][dLabelID]) return 0;
    new label[144];
    ER_FormatDoorLabel(idx, label, sizeof(label));
    UpdateDynamic3DTextLabelText(Doors[idx][dLabelID], COLOR_WHITE, label);
    return 1;
}
stock ER_LoadDoors()
{
    ER_ClearDoorWorld(); mysql_tquery(MainPipeline, "SELECT * FROM `doors` WHERE `enabled`=1", "ER_OnDoorsLoad"); return 1;
}

stock ER_LoadDoorRowFromCache(row, idx)
{
    cache_get_value_name_int(row,"id",Doors[idx][dSQLID]); cache_get_value_name(row,"name",Doors[idx][dName],64); cache_get_value_name_int(row,"owner_type",Doors[idx][dOwnerType]); cache_get_value_name_int(row,"owner_id",Doors[idx][dOwnerID]); cache_get_value_name_int(row,"lock_rank",Doors[idx][dLockRank]); cache_get_value_name_int(row,"family_crew",Doors[idx][dFamilyCrew]); cache_get_value_name_int(row,"faction_division",Doors[idx][dFactionDivision]); cache_get_value_name_int(row,"vip_level",Doors[idx][dVipLevel]); cache_get_value_name_int(row,"admin_level",Doors[idx][dAdminLevel]);
    cache_get_value_name_float(row,"ext_x",Doors[idx][dExtX]); cache_get_value_name_float(row,"ext_y",Doors[idx][dExtY]); cache_get_value_name_float(row,"ext_z",Doors[idx][dExtZ]); cache_get_value_name_float(row,"ext_a",Doors[idx][dExtA]); cache_get_value_name_int(row,"ext_int",Doors[idx][dExtInt]); cache_get_value_name_int(row,"ext_vw",Doors[idx][dExtVW]);
    cache_get_value_name_float(row,"int_x",Doors[idx][dIntX]); cache_get_value_name_float(row,"int_y",Doors[idx][dIntY]); cache_get_value_name_float(row,"int_z",Doors[idx][dIntZ]); cache_get_value_name_float(row,"int_a",Doors[idx][dIntA]); cache_get_value_name_int(row,"int_int",Doors[idx][dIntInt]); cache_get_value_name_int(row,"int_vw",Doors[idx][dIntVW]);
    cache_get_value_name_int(row,"pickup_model",Doors[idx][dPickupModel]); cache_get_value_name_int(row,"pickup_type",Doors[idx][dPickupType]); cache_get_value_name_int(row,"lockable",Doors[idx][dLockable]); cache_get_value_name_int(row,"locked",Doors[idx][dLocked]); cache_get_value_name_int(row,"custom_ext",Doors[idx][dCustomExt]); cache_get_value_name_int(row,"custom_int",Doors[idx][dCustomInt]); cache_get_value_name_int(row,"enabled",Doors[idx][dEnabled]);
    if(Doors[idx][dPickupType] <= 0) Doors[idx][dPickupType] = 23;
    return 1;
}

stock ER_DestroyDoorWorldSlot(idx)
{
    if(idx < 0 || idx >= MAX_DOORS) return 0;
    if(Doors[idx][dPickupID]) DestroyDynamicPickup(Doors[idx][dPickupID]);
    if(Doors[idx][dLabelID]) DestroyDynamic3DTextLabel(Doors[idx][dLabelID]);
    Doors[idx][dPickupID] = 0; Doors[idx][dLabelID] = Text3D:0;
    return 1;
}

stock ER_RemoveDoorSlot(idx)
{
    if(idx < 0 || idx >= DoorCount) return 0;
    ER_DestroyDoorWorldSlot(idx);
    Doors[idx][dEnabled] = 0;
    Doors[idx][dSQLID] = 0;
    return 1;
}

stock ER_ReloadDoorBySQLID(sqlid, playerid = INVALID_PLAYER_ID)
{
    new q[128];
    mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `doors` WHERE `id`=%d LIMIT 1", sqlid);
    mysql_tquery(MainPipeline, q, "ER_OnSingleDoorReload", "ii", sqlid, playerid);
    return 1;
}

forward ER_OnSingleDoorReload(sqlid, playerid);
public ER_OnSingleDoorReload(sqlid, playerid)
{
    new rows; cache_get_row_count(rows);
    new idx = ER_FindDoorIndexBySQLID(sqlid);
    if(!rows)
    {
        if(idx != -1) ER_RemoveDoorSlot(idx);
        if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "Door reloaded: not found or removed.");
        return 1;
    }
    if(idx == -1)
    {
        if(DoorCount >= MAX_DOORS) return 0;
        idx = DoorCount++;
    }
    else ER_DestroyDoorWorldSlot(idx);
    ER_LoadDoorRowFromCache(0, idx);
    if(Doors[idx][dEnabled]) ER_CreateDoorWorld(idx);
    if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "Door reloaded.");
    return 1;
}

forward ER_OnDoorsLoad();
public ER_OnDoorsLoad()
{
    new rows; cache_get_row_count(rows); DoorCount = 0;
    for(new r; r < rows && DoorCount < MAX_DOORS; r++)
    {
        cache_get_value_name_int(r,"id",Doors[DoorCount][dSQLID]); cache_get_value_name(r,"name",Doors[DoorCount][dName],64); cache_get_value_name_int(r,"owner_type",Doors[DoorCount][dOwnerType]); cache_get_value_name_int(r,"owner_id",Doors[DoorCount][dOwnerID]); cache_get_value_name_int(r,"lock_rank",Doors[DoorCount][dLockRank]); cache_get_value_name_int(r,"family_crew",Doors[DoorCount][dFamilyCrew]); cache_get_value_name_int(r,"faction_division",Doors[DoorCount][dFactionDivision]); cache_get_value_name_int(r,"vip_level",Doors[DoorCount][dVipLevel]); cache_get_value_name_int(r,"admin_level",Doors[DoorCount][dAdminLevel]);
        cache_get_value_name_float(r,"ext_x",Doors[DoorCount][dExtX]); cache_get_value_name_float(r,"ext_y",Doors[DoorCount][dExtY]); cache_get_value_name_float(r,"ext_z",Doors[DoorCount][dExtZ]); cache_get_value_name_float(r,"ext_a",Doors[DoorCount][dExtA]); cache_get_value_name_int(r,"ext_int",Doors[DoorCount][dExtInt]); cache_get_value_name_int(r,"ext_vw",Doors[DoorCount][dExtVW]);
        cache_get_value_name_float(r,"int_x",Doors[DoorCount][dIntX]); cache_get_value_name_float(r,"int_y",Doors[DoorCount][dIntY]); cache_get_value_name_float(r,"int_z",Doors[DoorCount][dIntZ]); cache_get_value_name_float(r,"int_a",Doors[DoorCount][dIntA]); cache_get_value_name_int(r,"int_int",Doors[DoorCount][dIntInt]); cache_get_value_name_int(r,"int_vw",Doors[DoorCount][dIntVW]);
        cache_get_value_name_int(r,"pickup_model",Doors[DoorCount][dPickupModel]); cache_get_value_name_int(r,"pickup_type",Doors[DoorCount][dPickupType]); cache_get_value_name_int(r,"lockable",Doors[DoorCount][dLockable]); cache_get_value_name_int(r,"locked",Doors[DoorCount][dLocked]); cache_get_value_name_int(r,"custom_ext",Doors[DoorCount][dCustomExt]); cache_get_value_name_int(r,"custom_int",Doors[DoorCount][dCustomInt]); cache_get_value_name_int(r,"enabled",Doors[DoorCount][dEnabled]);
        ER_CreateDoorWorld(DoorCount); DoorCount++;
    }
    printf("[Doors] Loaded %d doors.", DoorCount); return 1;
}
stock ER_GetFamilyPermDoorLock(fid) { new idx = ER_FindFamilyIndexBySQLID(fid); if(idx == -1) return 6; return Families[idx][fDoorLockRank] > 0 ? Families[idx][fDoorLockRank] : 5; }
stock ER_GetFactionPermDoorLock(fid) { new idx = ER_FindFactionIndexBySQLID(fid); if(idx == -1) return 6; return Factions[idx][facDoorLockRank] > 0 ? Factions[idx][facDoorLockRank] : 5; }

stock ER_DoorHasAccess(playerid, idx)
{
    switch(Doors[idx][dOwnerType])
    {
        case DOOR_OWNER_PUBLIC: return 1;
        case DOOR_OWNER_PLAYER: return PlayerInfo[playerid][pID] == Doors[idx][dOwnerID];
        case DOOR_OWNER_FAMILY: return PlayerInfo[playerid][pFamily] == Doors[idx][dOwnerID] && PlayerInfo[playerid][pFamilyRank] >= Doors[idx][dLockRank] && PlayerInfo[playerid][pFamilyRank] >= ER_GetFamilyPermDoorLock(Doors[idx][dOwnerID]) && (Doors[idx][dFamilyCrew] == 0 || PlayerInfo[playerid][pFamilyCrew] == Doors[idx][dFamilyCrew]);
        case DOOR_OWNER_FACTION: return PlayerInfo[playerid][pFaction] == Doors[idx][dOwnerID] && PlayerInfo[playerid][pFactionRank] >= Doors[idx][dLockRank] && PlayerInfo[playerid][pFactionRank] >= ER_GetFactionPermDoorLock(Doors[idx][dOwnerID]) && (Doors[idx][dFactionDivision] == 0 || PlayerInfo[playerid][pFactionDivision] == Doors[idx][dFactionDivision]);
        case DOOR_OWNER_VIP: return PlayerInfo[playerid][pPlayerVip] >= Doors[idx][dVipLevel];
        case DOOR_OWNER_ADMIN: return ER_IsAdmin(playerid, Doors[idx][dAdminLevel]);
    }
    return 0;
}
stock ER_GetNearestDoor(playerid, bool:inside = false)
{
    new vw=GetPlayerVirtualWorld(playerid), interior=GetPlayerInterior(playerid);
    for(new i; i < DoorCount; i++)
    {
        if(!Doors[i][dEnabled]) continue;
        if(!inside && IsPlayerInRangeOfPoint(playerid, 3.0, Doors[i][dExtX], Doors[i][dExtY], Doors[i][dExtZ]) && vw == Doors[i][dExtVW] && interior == Doors[i][dExtInt]) return i;
        if(inside && IsPlayerInRangeOfPoint(playerid, 3.0, Doors[i][dIntX], Doors[i][dIntY], Doors[i][dIntZ]) && vw == Doors[i][dIntVW] && interior == Doors[i][dIntInt]) return i;
    }
    return -1;
}
stock ER_TryEnterDoor(playerid)
{
    new idx = ER_GetNearestDoor(playerid, false);
    if(idx == -1) return 0;
    if(Doors[idx][dLocked])
    {
        ER_Send(playerid, COLOR_GREY, "This door is locked.");
        return 1;
    }

    new rp[144], Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    format(rp, sizeof(rp), "* %s enters %s.", ER_GetName(playerid), Doors[idx][dName]);
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

    SetPlayerInterior(playerid, Doors[idx][dIntInt]);
    SetPlayerVirtualWorld(playerid, Doors[idx][dIntVW]);
    SetPlayerPos(playerid, Doors[idx][dIntX], Doors[idx][dIntY], Doors[idx][dIntZ]);
    SetPlayerFacingAngle(playerid, Doors[idx][dIntA]);
    if(Doors[idx][dCustomInt]) ER_StreamPrep(playerid, Doors[idx][dIntX], Doors[idx][dIntY], Doors[idx][dIntZ], Doors[idx][dIntVW], Doors[idx][dIntInt], "Door Interior");
    return 1;
}
stock ER_TryExitDoor(playerid)
{
    new idx = ER_GetNearestDoor(playerid, true);
    if(idx == -1) return 0;
    if(Doors[idx][dLocked])
    {
        ER_Send(playerid, COLOR_GREY, "This door is locked.");
        return 1;
    }

    new rp[144], Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    format(rp, sizeof(rp), "* %s exits through %s.", ER_GetName(playerid), Doors[idx][dName]);
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

    SetPlayerInterior(playerid, Doors[idx][dExtInt]);
    SetPlayerVirtualWorld(playerid, Doors[idx][dExtVW]);
    SetPlayerPos(playerid, Doors[idx][dExtX], Doors[idx][dExtY], Doors[idx][dExtZ]);
    SetPlayerFacingAngle(playerid, Doors[idx][dExtA]);
    if(Doors[idx][dCustomExt]) ER_StreamPrep(playerid, Doors[idx][dExtX], Doors[idx][dExtY], Doors[idx][dExtZ], Doors[idx][dExtVW], Doors[idx][dExtInt], "Door Exterior");
    return 1;
}
stock ER_SendDoorLockRP(playerid, idx, bool:locked)
{
    if(idx < 0 || idx >= DoorCount) return 0;
    new Float:x, Float:y, Float:z, rp[160];
    GetPlayerPos(playerid, x, y, z);
    format(rp, sizeof(rp), "* %s %s %s.", ER_GetName(playerid), locked ? ("locks") : ("unlocks"), Doors[idx][dName]);
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

stock ER_TryDoorLock(playerid)
{
    new idx = ER_GetNearestDoor(playerid, false); if(idx == -1) return 0;
    if(!Doors[idx][dLockable]) { ER_Send(playerid, COLOR_GREY, "This door is not lockable."); return 1; }
    if(!ER_DoorHasAccess(playerid, idx)) { ER_Send(playerid, COLOR_GREY, "You do not have keys to this door."); return 1; }
    Doors[idx][dLocked] = !Doors[idx][dLocked]; new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `doors` SET `locked`=%d WHERE `id`=%d", Doors[idx][dLocked], Doors[idx][dSQLID]); mysql_tquery(MainPipeline, q); ER_UpdateDoorLabel(idx); ER_SendDoorLockRP(playerid, idx, Doors[idx][dLocked] ? true : false); return 1;
}
CMD:doorlock(playerid, params[]) { if(ER_TryDoorLock(playerid)) return 1; return ER_Send(playerid, COLOR_GREY, "You are not near a lockable door."); }
CMD:createdoor(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid,COLOR_GREY,"You are not authorized."); if(isnull(params)) return ER_Send(playerid,COLOR_GREY,"USAGE: /createdoor [name]");
    new Float:x,Float:y,Float:z,Float:a; GetPlayerPos(playerid,x,y,z); GetPlayerFacingAngle(playerid,a); new q[512]; mysql_format(MainPipeline,q,sizeof(q),"INSERT INTO `doors` (`name`,`owner_type`,`owner_id`,`lock_rank`,`ext_x`,`ext_y`,`ext_z`,`ext_a`,`ext_int`,`ext_vw`,`int_x`,`int_y`,`int_z`,`int_a`,`int_int`,`int_vw`,`pickup_model`,`pickup_type`,`lockable`,`locked`,`enabled`) VALUES ('%e',0,0,0,%f,%f,%f,%f,%d,%d,%f,%f,%f,%f,%d,0,1318,1,0,0,1)",params,x,y,z,a,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),x,y,z,a,GetPlayerInterior(playerid)); mysql_tquery(MainPipeline,q,"ER_OnDoorCreated","i",playerid); return 1;
}
forward ER_OnDoorCreated(playerid);
public ER_OnDoorCreated(playerid)
{
    new did=cache_insert_id(); new q[128]; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `int_vw`=%d WHERE `id`=%d",did,did); mysql_tquery(MainPipeline,q); ER_ReloadDoorBySQLID(did, playerid); ER_Send(playerid,COLOR_GREEN,"Door created. Use /editdoor [id] to edit it."); return 1;
}
CMD:editdoor(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid,COLOR_GREY,"You are not authorized."); new did; if(sscanf(params,"d",did)) return ER_Send(playerid,COLOR_GREY,"USAGE: /editdoor [id]"); SetPVarInt(playerid,"EditingDoor",did); ShowPlayerDialog(playerid,DIALOG_DOOR_EDITOR,DIALOG_STYLE_LIST,"Door Editor","Name\nSet Exterior Position\nSet Interior Position\nSet Manual Int VW\nSet Default Int VW\nSet Owner\nToggle Lockable\nToggle Locked\nToggle CustomExt Stream Freeze\nToggle CustomInt Stream Freeze\nSet Pickup Icon\nReload This Door\nDelete Door","Select","Close"); return 1;
}
stock ER_SetDoorOwnerPlayer(playerid, accountid, const ownerName[])
{
    new did = GetPVarInt(playerid, "EditingDoor"), idx = ER_FindDoorIndexBySQLID(did);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid door.");
    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `doors` SET `owner_type`=%d,`owner_id`=%d,`lock_rank`=0,`family_crew`=0,`faction_division`=0,`vip_level`=0,`admin_level`=0,`lockable`=1,`locked`=1 WHERE `id`=%d", DOOR_OWNER_PLAYER, accountid, did);
    mysql_tquery(MainPipeline, q);
    ER_ReloadDoorBySQLID(did, playerid);
    new msg[96]; format(msg, sizeof(msg), "Door owner set to player: %s.", ownerName);
    return ER_Send(playerid, COLOR_GREEN, msg);
}

forward ER_ShowDoorOfflineOwnersCB(playerid);
public ER_ShowDoorOfflineOwnersCB(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows; cache_get_row_count(rows);
    if(!rows) return ER_Send(playerid, COLOR_GREY, "No offline accounts found.");
    new list[2048], username[24], accid;
    ER_DoorOwnerCount[playerid] = 0;
    for(new r; r < rows && r < 64; r++)
    {
        cache_get_value_name_int(r, "id", accid);
        cache_get_value_name(r, "username", username, sizeof(username));
        ER_DoorOwnerID[playerid][r] = accid;
        format(list, sizeof(list), "%s%d - %s\n", list, accid, username);
        ER_DoorOwnerCount[playerid]++;
    }
    ShowPlayerDialog(playerid, DIALOG_DOOR_OWNER_OFFLINE, DIALOG_STYLE_LIST, "Select Offline Door Owner", list, "Select", "Back");
    return 1;
}

stock ER_DoorDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_DOOR_EDITOR)
    {
        if(!response) return 1;
        new did=GetPVarInt(playerid,"EditingDoor"),idx=ER_FindDoorIndexBySQLID(did);
        if(idx==-1) return ER_Send(playerid,COLOR_GREY,"Invalid door.");
        if(listitem==0){SetPVarInt(playerid,"DoorInputField",1); return ShowPlayerDialog(playerid,DIALOG_DOOR_INPUT,DIALOG_STYLE_INPUT,"Door Name","Enter door name:","Save","Back");}
        if(listitem==1){GetPlayerPos(playerid,Doors[idx][dExtX],Doors[idx][dExtY],Doors[idx][dExtZ]);GetPlayerFacingAngle(playerid,Doors[idx][dExtA]);Doors[idx][dExtInt]=GetPlayerInterior(playerid);Doors[idx][dExtVW]=GetPlayerVirtualWorld(playerid);new q[256];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `ext_x`=%f,`ext_y`=%f,`ext_z`=%f,`ext_a`=%f,`ext_int`=%d,`ext_vw`=%d WHERE `id`=%d",Doors[idx][dExtX],Doors[idx][dExtY],Doors[idx][dExtZ],Doors[idx][dExtA],Doors[idx][dExtInt],Doors[idx][dExtVW],did);mysql_tquery(MainPipeline,q);ER_ReloadDoorBySQLID(did, playerid);return ER_Send(playerid,COLOR_GREEN,"Door exterior saved.");}
        if(listitem==2){GetPlayerPos(playerid,Doors[idx][dIntX],Doors[idx][dIntY],Doors[idx][dIntZ]);GetPlayerFacingAngle(playerid,Doors[idx][dIntA]);Doors[idx][dIntInt]=GetPlayerInterior(playerid);new q[256];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `int_x`=%f,`int_y`=%f,`int_z`=%f,`int_a`=%f,`int_int`=%d WHERE `id`=%d",Doors[idx][dIntX],Doors[idx][dIntY],Doors[idx][dIntZ],Doors[idx][dIntA],Doors[idx][dIntInt],did);mysql_tquery(MainPipeline,q);return ER_Send(playerid,COLOR_GREEN,"Door interior saved. VW was not changed.");}
        if(listitem==3){SetPVarInt(playerid,"DoorInputField",2); return ShowPlayerDialog(playerid,DIALOG_DOOR_INPUT,DIALOG_STYLE_INPUT,"Manual Door Interior VW","Enter manual interior virtual world:","Save","Back");}
        if(listitem==4){new q[128]; Doors[idx][dIntVW]=did; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `int_vw`=%d WHERE `id`=%d",did,did); mysql_tquery(MainPipeline,q); return ER_Send(playerid,COLOR_GREEN,"Door interior VW reset to door ID.");}
        if(listitem==5) return ShowPlayerDialog(playerid,DIALOG_DOOR_OWNER_TYPE,DIALOG_STYLE_LIST,"Set Door Owner","Public\nPlayer\nFamily\nFaction\nVIP\nAdmin","Select","Back");
        if(listitem==6){Doors[idx][dLockable]=!Doors[idx][dLockable];new q[160];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `lockable`=%d WHERE `id`=%d",Doors[idx][dLockable],did);mysql_tquery(MainPipeline,q);ER_ReloadDoorBySQLID(did, playerid);return ER_Send(playerid,COLOR_GREEN,"Door lockable state updated.");}
        if(listitem==7){Doors[idx][dLocked]=!Doors[idx][dLocked];new q[128];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `locked`=%d WHERE `id`=%d",Doors[idx][dLocked],did);mysql_tquery(MainPipeline,q);ER_UpdateDoorLabel(idx);new msg[128];format(msg,sizeof(msg),"Door ID: %d Name: %s %s",did,Doors[idx][dName],Doors[idx][dLocked] ? ("Locked") : ("Unlocked"));return ER_Send(playerid,COLOR_GREEN,msg);}
        if(listitem==8){Doors[idx][dCustomExt]=!Doors[idx][dCustomExt];new q[128];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `custom_ext`=%d WHERE `id`=%d",Doors[idx][dCustomExt],did);mysql_tquery(MainPipeline,q);return ER_Send(playerid,COLOR_GREEN,"Door Custom Exterior streaming toggled.");}
        if(listitem==9){Doors[idx][dCustomInt]=!Doors[idx][dCustomInt];new q[128];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `custom_int`=%d WHERE `id`=%d",Doors[idx][dCustomInt],did);mysql_tquery(MainPipeline,q);return ER_Send(playerid,COLOR_GREEN,"Door Custom Interior streaming toggled.");}
        if(listitem==11){ER_ReloadDoorBySQLID(did, playerid);return ER_Send(playerid,COLOR_GREEN,"Door reloaded.");}
        if(listitem==12){Doors[idx][dEnabled]=0;new q[128];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `enabled`=0 WHERE `id`=%d",did);mysql_tquery(MainPipeline,q);ER_ReloadDoorBySQLID(did, playerid);return ER_Send(playerid,COLOR_GREEN,"Door deleted/disabled.");}
        return ER_Send(playerid,COLOR_GREY,"This door setting is not editable from this menu yet.");
    }
    if(dialogid == DIALOG_DOOR_INPUT)
    {
        if(!response) return 1;
        new did=GetPVarInt(playerid,"EditingDoor"),idx=ER_FindDoorIndexBySQLID(did),field=GetPVarInt(playerid,"DoorInputField"),q[256];
        if(idx==-1) return ER_Send(playerid,COLOR_GREY,"Invalid door.");
        if(field==1)
        {
            mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `name`='%e' WHERE `id`=%d",inputtext,did);
            mysql_tquery(MainPipeline,q); format(Doors[idx][dName],64,"%s",inputtext); ER_UpdateDoorLabel(idx);
            return ER_Send(playerid,COLOR_GREEN,"Door name updated.");
        }
        if(field==2)
        {
            new vw=strval(inputtext); if(vw < 0) return ER_Send(playerid,COLOR_GREY,"Invalid virtual world.");
            Doors[idx][dIntVW]=vw; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `int_vw`=%d WHERE `id`=%d",vw,did); mysql_tquery(MainPipeline,q);
            return ER_Send(playerid,COLOR_GREEN,"Door interior VW updated.");
        }
        return 1;
    }
    if(dialogid == DIALOG_DOOR_OWNER_TYPE)
    {
        if(!response) return 1;
        new did = GetPVarInt(playerid, "EditingDoor"), q[256];
        if(listitem == 0)
        {
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `doors` SET `owner_type`=0,`owner_id`=0,`lock_rank`=0,`family_crew`=0,`faction_division`=0,`vip_level`=0,`admin_level`=0,`lockable`=0,`locked`=0 WHERE `id`=%d", did);
            mysql_tquery(MainPipeline, q); ER_ReloadDoorBySQLID(did, playerid); return ER_Send(playerid, COLOR_GREEN, "Door owner cleared / set public.");
        }
        if(listitem == 1) return ShowPlayerDialog(playerid, DIALOG_DOOR_OWNER_PLAYER_MODE, DIALOG_STYLE_LIST, "Select Player Door Owner", "Online Player\nOffline Player", "Select", "Back");
        if(listitem == 2)
        {
            new list[2048];
            for(new i; i < FamilyCount; i++) format(list, sizeof(list), "%s%d - %s\n", list, Families[i][fSQLID], Families[i][fName]);
            if(isnull(list)) format(list, sizeof(list), "No families found.");
            return ShowPlayerDialog(playerid, DIALOG_DOOR_OWNER_FAMILY, DIALOG_STYLE_LIST, "Select Family Door Owner", list, "Select", "Back");
        }
        if(listitem == 3)
        {
            new list[2048];
            for(new i; i < FactionCount; i++) format(list, sizeof(list), "%s%d - %s\n", list, Factions[i][facSQLID], Factions[i][facName]);
            if(isnull(list)) format(list, sizeof(list), "No factions found.");
            return ShowPlayerDialog(playerid, DIALOG_DOOR_OWNER_FACTION, DIALOG_STYLE_LIST, "Select Faction Door Owner", list, "Select", "Back");
        }
        if(listitem == 4) return ShowPlayerDialog(playerid, DIALOG_DOOR_OWNER_VIP, DIALOG_STYLE_LIST, "Select VIP Door Level", "VIP Level 1\nVIP Level 2\nVIP Level 3\nVIP Level 4\nVIP Level 5", "Select", "Back");
        if(listitem == 5) return ShowPlayerDialog(playerid, DIALOG_DOOR_OWNER_ADMIN, DIALOG_STYLE_LIST, "Select Admin Door Level", "Moderator\nJunior Admin\nSenior Admin\nLead Admin\nHead Admin\nExecutive Admin", "Select", "Back");
        return 1;
    }
    if(dialogid == DIALOG_DOOR_OWNER_PLAYER_MODE)
    {
        if(!response) return 1;
        if(listitem == 0) return ShowPlayerDialog(playerid, DIALOG_DOOR_OWNER_ONLINE, DIALOG_STYLE_INPUT, "Online Player Door Owner", "Enter online player ID or part of name:", "Save", "Back");
        new q[128]; mysql_format(MainPipeline, q, sizeof(q), "SELECT `id`,`username` FROM `accounts` ORDER BY `id` ASC LIMIT 100");
        mysql_tquery(MainPipeline, q, "ER_ShowDoorOfflineOwnersCB", "i", playerid);
        return 1;
    }
    if(dialogid == DIALOG_DOOR_OWNER_ONLINE)
    {
        if(!response) return 1;
        new target;
        if(sscanf(inputtext, "u", target) || target == INVALID_PLAYER_ID || !IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
        return ER_SetDoorOwnerPlayer(playerid, PlayerInfo[target][pID], PlayerInfo[target][pName]);
    }
    if(dialogid == DIALOG_DOOR_OWNER_OFFLINE)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= ER_DoorOwnerCount[playerid]) return 1;
        new ownerName[24]; strmid(ownerName, inputtext, 0, sizeof(ownerName)-1);
        new dash = strfind(inputtext, " - "); if(dash != -1) strmid(ownerName, inputtext, dash + 3, sizeof(ownerName)-1);
        return ER_SetDoorOwnerPlayer(playerid, ER_DoorOwnerID[playerid][listitem], ownerName);
    }
    if(dialogid == DIALOG_DOOR_OWNER_FAMILY)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= FamilyCount) return 1;
        new did = GetPVarInt(playerid, "EditingDoor"), q[256];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `doors` SET `owner_type`=%d,`owner_id`=%d,`lock_rank`=1,`family_crew`=0,`faction_division`=0,`vip_level`=0,`admin_level`=0,`lockable`=1,`locked`=1 WHERE `id`=%d", DOOR_OWNER_FAMILY, Families[listitem][fSQLID], did);
        mysql_tquery(MainPipeline, q); ER_ReloadDoorBySQLID(did, playerid); return ER_Send(playerid, COLOR_GREEN, "Door owner set to family.");
    }
    if(dialogid == DIALOG_DOOR_OWNER_FACTION)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= FactionCount) return 1;
        new did = GetPVarInt(playerid, "EditingDoor"), q[256];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `doors` SET `owner_type`=%d,`owner_id`=%d,`lock_rank`=1,`family_crew`=0,`faction_division`=0,`vip_level`=0,`admin_level`=0,`lockable`=1,`locked`=1 WHERE `id`=%d", DOOR_OWNER_FACTION, Factions[listitem][facSQLID], did);
        mysql_tquery(MainPipeline, q); ER_ReloadDoorBySQLID(did, playerid); return ER_Send(playerid, COLOR_GREEN, "Door owner set to faction.");
    }
    if(dialogid == DIALOG_DOOR_OWNER_VIP)
    {
        if(!response) return 1;
        new did = GetPVarInt(playerid, "EditingDoor"), q[256], level = listitem + 1;
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `doors` SET `owner_type`=%d,`owner_id`=0,`lock_rank`=0,`family_crew`=0,`faction_division`=0,`vip_level`=%d,`admin_level`=0,`lockable`=1,`locked`=1 WHERE `id`=%d", DOOR_OWNER_VIP, level, did);
        mysql_tquery(MainPipeline, q); ER_ReloadDoorBySQLID(did, playerid); return ER_Send(playerid, COLOR_GREEN, "Door owner set to VIP level.");
    }
    if(dialogid == DIALOG_DOOR_OWNER_ADMIN)
    {
        if(!response) return 1;
        new adminLevel;
        switch(listitem)
        {
            case 0: adminLevel = ADMIN_MOD;
            case 1: adminLevel = ADMIN_JUNIOR;
            case 2: adminLevel = ADMIN_SENIOR;
            case 3: adminLevel = ADMIN_LEAD;
            case 4: adminLevel = ADMIN_HEAD;
            case 5: adminLevel = ADMIN_EXEC;
            default: return 1;
        }
        new did = GetPVarInt(playerid, "EditingDoor"), q[256];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `doors` SET `owner_type`=%d,`owner_id`=0,`lock_rank`=0,`family_crew`=0,`faction_division`=0,`vip_level`=0,`admin_level`=%d,`lockable`=1,`locked`=1 WHERE `id`=%d", DOOR_OWNER_ADMIN, adminLevel, did);
        mysql_tquery(MainPipeline, q); ER_ReloadDoorBySQLID(did, playerid); return ER_Send(playerid, COLOR_GREEN, "Door owner set to admin level.");
    }
    return 0;
}
