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
        if(!inside && IsPlayerInRangeOfPoint(playerid, 3.0, Doors[i][dExtX], Doors[i][dExtY], Doors[i][dExtZ]) && vw == Doors[i][dExtVW] && interior == Doors[i][dExtInt]) return i;
        if(inside && IsPlayerInRangeOfPoint(playerid, 3.0, Doors[i][dIntX], Doors[i][dIntY], Doors[i][dIntZ]) && vw == Doors[i][dIntVW] && interior == Doors[i][dIntInt]) return i;
    }
    return -1;
}
stock ER_TryEnterDoor(playerid)
{
    new idx = ER_GetNearestDoor(playerid, false);
    if(idx == -1) return 0;
    if(Doors[idx][dLocked] && !ER_DoorHasAccess(playerid, idx))
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
    new did=cache_insert_id(); new q[128]; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `int_vw`=%d WHERE `id`=%d",did,did); mysql_tquery(MainPipeline,q); ER_LoadDoors(); ER_Send(playerid,COLOR_GREEN,"Door created. Use /editdoor [id] to edit it."); return 1;
}
CMD:editdoor(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid,COLOR_GREY,"You are not authorized."); new did; if(sscanf(params,"d",did)) return ER_Send(playerid,COLOR_GREY,"USAGE: /editdoor [id]"); SetPVarInt(playerid,"EditingDoor",did); ShowPlayerDialog(playerid,DIALOG_DOOR_EDITOR,DIALOG_STYLE_LIST,"Door Editor","Set Exterior Position\nSet Interior Position\nSet Owner Type\nSet Owner ID\nToggle Lockable\nToggle Locked\nToggle CustomExt Stream Freeze\nToggle CustomInt Stream Freeze\nSet Pickup Icon\nReload This Door\nDelete Door","Select","Close"); return 1;
}
stock ER_DoorDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    #pragma unused inputtext
    if(dialogid == DIALOG_DOOR_EDITOR)
    {
        if(!response) return 1; new did=GetPVarInt(playerid,"EditingDoor"),idx=ER_FindDoorIndexBySQLID(did); if(idx==-1) return ER_Send(playerid,COLOR_GREY,"Invalid door.");
        if(listitem==0){GetPlayerPos(playerid,Doors[idx][dExtX],Doors[idx][dExtY],Doors[idx][dExtZ]);GetPlayerFacingAngle(playerid,Doors[idx][dExtA]);Doors[idx][dExtInt]=GetPlayerInterior(playerid);Doors[idx][dExtVW]=GetPlayerVirtualWorld(playerid);new q[256];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `ext_x`=%f,`ext_y`=%f,`ext_z`=%f,`ext_a`=%f,`ext_int`=%d,`ext_vw`=%d WHERE `id`=%d",Doors[idx][dExtX],Doors[idx][dExtY],Doors[idx][dExtZ],Doors[idx][dExtA],Doors[idx][dExtInt],Doors[idx][dExtVW],did);mysql_tquery(MainPipeline,q);ER_LoadDoors();return ER_Send(playerid,COLOR_GREEN,"Door exterior saved.");}
        if(listitem==1){GetPlayerPos(playerid,Doors[idx][dIntX],Doors[idx][dIntY],Doors[idx][dIntZ]);GetPlayerFacingAngle(playerid,Doors[idx][dIntA]);Doors[idx][dIntInt]=GetPlayerInterior(playerid);new q[256];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `int_x`=%f,`int_y`=%f,`int_z`=%f,`int_a`=%f,`int_int`=%d WHERE `id`=%d",Doors[idx][dIntX],Doors[idx][dIntY],Doors[idx][dIntZ],Doors[idx][dIntA],Doors[idx][dIntInt],did);mysql_tquery(MainPipeline,q);return ER_Send(playerid,COLOR_GREEN,"Door interior saved. VW was not changed.");}
        if(listitem==2) return ShowPlayerDialog(playerid,DIALOG_DOOR_OWNER_TYPE,DIALOG_STYLE_LIST,"Owner Type","Public\nPlayer\nFamily\nFaction\nVIP\nAdmin","Select","Back");
        if(listitem==4){Doors[idx][dLockable]=!Doors[idx][dLockable];new q[128];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `lockable`=%d WHERE `id`=%d",Doors[idx][dLockable],did);mysql_tquery(MainPipeline,q);ER_LoadDoors();return ER_Send(playerid,COLOR_GREEN,"Door lockable state updated.");}
        if(listitem==5){Doors[idx][dLocked]=!Doors[idx][dLocked];new q[128];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `locked`=%d WHERE `id`=%d",Doors[idx][dLocked],did);mysql_tquery(MainPipeline,q);ER_UpdateDoorLabel(idx);ER_SendDoorLockRP(playerid,idx,Doors[idx][dLocked] ? true : false);return 1;}
        if(listitem==6){Doors[idx][dCustomExt]=!Doors[idx][dCustomExt];new q[128];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `custom_ext`=%d WHERE `id`=%d",Doors[idx][dCustomExt],did);mysql_tquery(MainPipeline,q);return ER_Send(playerid,COLOR_GREEN,"Door Custom Exterior streaming toggled.");}
        if(listitem==7){Doors[idx][dCustomInt]=!Doors[idx][dCustomInt];new q[128];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `custom_int`=%d WHERE `id`=%d",Doors[idx][dCustomInt],did);mysql_tquery(MainPipeline,q);return ER_Send(playerid,COLOR_GREEN,"Door Custom Interior streaming toggled.");}
        if(listitem==9){ER_LoadDoors();return ER_Send(playerid,COLOR_GREEN,"Doors reloaded.");}
        if(listitem==10){Doors[idx][dEnabled]=0;new q[128];mysql_format(MainPipeline,q,sizeof(q),"UPDATE `doors` SET `enabled`=0 WHERE `id`=%d",did);mysql_tquery(MainPipeline,q);ER_LoadDoors();return ER_Send(playerid,COLOR_GREEN,"Door deleted/disabled.");}
        return ER_Send(playerid,COLOR_GREY,"This door setting is not editable from this menu yet; use owner/type fields or position options.");
    }
    if(dialogid == DIALOG_DOOR_OWNER_TYPE)
    {
        if(!response) return 1;
        new did = GetPVarInt(playerid, "EditingDoor"), owner = listitem;
        new lockrank = 0, vip = 0, admin = 0, lockable = 0, locked = 0;
        if(owner == DOOR_OWNER_FAMILY || owner == DOOR_OWNER_FACTION)
        {
            lockrank = 6;
            lockable = 1;
            locked = 1;
        }
        else if(owner == DOOR_OWNER_PLAYER)
        {
            lockable = 1;
            locked = 1;
        }
        else if(owner == DOOR_OWNER_VIP) vip = 1;
        else if(owner == DOOR_OWNER_ADMIN)
        {
            admin = ADMIN_HEAD;
            lockable = 1;
            locked = 1;
        }
        new q[256];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `doors` SET `owner_type`=%d,`owner_id`=0,`lock_rank`=%d,`family_crew`=0,`faction_division`=0,`vip_level`=%d,`admin_level`=%d,`lockable`=%d,`locked`=%d WHERE `id`=%d", owner, lockrank, vip, admin, lockable, locked, did);
        mysql_tquery(MainPipeline, q);
        ER_LoadDoors();
        return ER_Send(playerid, COLOR_GREEN, "Door owner type updated and old mixed fields cleared.");
    }
    return 0;
}
