#if defined _ER_POINTS_INCLUDED
    #endinput
#endif
#define _ER_POINTS_INCLUDED

enum E_POINT_INFO
{
    ptSQLID,
    ptName[64],
    Float:ptX,
    Float:ptY,
    Float:ptZ,
    ptInt,
    ptVW,
    ptOwnerFamily,
    ptOwnerFaction,
    ptCaptureSeconds,
    ptPickupID,
    Text3D:ptLabelID,
    ptEnabled
};
new Points[MAX_POINTS][E_POINT_INFO];
new PointCount;

stock ER_ClearPoints()
{
    for(new i; i < PointCount; i++)
    {
        if(Points[i][ptPickupID]) DestroyDynamicPickup(Points[i][ptPickupID]);
        if(Points[i][ptLabelID]) DestroyDynamic3DTextLabel(Points[i][ptLabelID]);
    }
    PointCount = 0;
    return 1;
}

stock ER_CreatePointWorld(idx)
{
    new label[192], owner[48];
    if(Points[idx][ptOwnerFamily] > 0) format(owner, sizeof(owner), "Family %d", Points[idx][ptOwnerFamily]);
    else if(Points[idx][ptOwnerFaction] > 0) format(owner, sizeof(owner), "Faction %d", Points[idx][ptOwnerFaction]);
    else format(owner, sizeof(owner), "Unowned");
    format(label, sizeof(label), "{FFFF00}%s\n{FFFFFF}Owner: %s\nPoint ID: %d\nUse /capture", Points[idx][ptName], owner, Points[idx][ptSQLID]);
    Points[idx][ptPickupID] = CreateDynamicPickup(1314, 23, Points[idx][ptX], Points[idx][ptY], Points[idx][ptZ], Points[idx][ptVW], Points[idx][ptInt]);
    Points[idx][ptLabelID] = CreateDynamic3DTextLabel(label, COLOR_YELLOW, Points[idx][ptX], Points[idx][ptY], Points[idx][ptZ] + 0.35, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Points[idx][ptVW], Points[idx][ptInt]);
    return 1;
}

stock ER_LoadPoints()
{
    ER_ClearPoints();
    mysql_tquery(MainPipeline, "SELECT * FROM `points` WHERE `enabled`=1 ORDER BY `id` ASC", "ER_OnPointsLoad");
    return 1;
}
forward ER_OnPointsLoad();
public ER_OnPointsLoad()
{
    new rows; cache_get_row_count(rows);
    for(new r; r < rows && PointCount < MAX_POINTS; r++)
    {
        cache_get_value_name_int(r, "id", Points[PointCount][ptSQLID]);
        cache_get_value_name(r, "name", Points[PointCount][ptName], 64);
        cache_get_value_name_float(r, "x", Points[PointCount][ptX]);
        cache_get_value_name_float(r, "y", Points[PointCount][ptY]);
        cache_get_value_name_float(r, "z", Points[PointCount][ptZ]);
        cache_get_value_name_int(r, "interior", Points[PointCount][ptInt]);
        cache_get_value_name_int(r, "vw", Points[PointCount][ptVW]);
        cache_get_value_name_int(r, "owner_family", Points[PointCount][ptOwnerFamily]);
        cache_get_value_name_int(r, "owner_faction", Points[PointCount][ptOwnerFaction]);
        cache_get_value_name_int(r, "capture_seconds", Points[PointCount][ptCaptureSeconds]);
        cache_get_value_name_int(r, "enabled", Points[PointCount][ptEnabled]);
        if(Points[PointCount][ptCaptureSeconds] <= 0) Points[PointCount][ptCaptureSeconds] = 60;
        ER_CreatePointWorld(PointCount);
        PointCount++;
    }
    printf("[Points] Loaded %d capture points.", PointCount);
    return 1;
}

stock ER_FindPointIndexBySQLID(id)
{
    for(new i; i < PointCount; i++) if(Points[i][ptSQLID] == id) return i;
    return -1;
}

stock ER_GetNearestPoint(playerid)
{
    for(new i; i < PointCount; i++)
    {
        if(GetPlayerVirtualWorld(playerid) == Points[i][ptVW] && GetPlayerInterior(playerid) == Points[i][ptInt] && IsPlayerInRangeOfPoint(playerid, 5.0, Points[i][ptX], Points[i][ptY], Points[i][ptZ])) return i;
    }
    return -1;
}

CMD:createpoint(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new name[64]; if(sscanf(params, "S(Capture Point)[64]", name)) return ER_Send(playerid, COLOR_GREY, "USAGE: /createpoint [name]");
    new Float:x, Float:y, Float:z, q[384]; GetPlayerPos(playerid, x, y, z);
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `points` (`name`,`x`,`y`,`z`,`interior`,`vw`,`capture_seconds`,`enabled`) VALUES ('%e',%f,%f,%f,%d,%d,60,1)", name, x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
    mysql_tquery(MainPipeline, q, "ER_OnPointCreated", "i", playerid); return 1;
}
forward ER_OnPointCreated(playerid);
public ER_OnPointCreated(playerid)
{
    new id = cache_insert_id(), msg[96]; ER_LoadPoints(); format(msg, sizeof(msg), "Capture point created with ID %d.", id); return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:points(playerid, params[])
{
    SendClientMessage(playerid, COLOR_HELP, "____________________ Capture Points ____________________");
    new line[128], owner[32];
    for(new i; i < PointCount; i++)
    {
        if(Points[i][ptOwnerFamily] > 0) format(owner, sizeof(owner), "Family %d", Points[i][ptOwnerFamily]);
        else if(Points[i][ptOwnerFaction] > 0) format(owner, sizeof(owner), "Faction %d", Points[i][ptOwnerFaction]);
        else format(owner, sizeof(owner), "Unowned");
        format(line, sizeof(line), "%d - %s - Owner: %s", Points[i][ptSQLID], Points[i][ptName], owner);
        SendClientMessage(playerid, COLOR_HELP, line);
    }
    return 1;
}

CMD:capture(playerid, params[])
{
    new idx = ER_GetNearestPoint(playerid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "You are not at a capture point.");
    if(PlayerInfo[playerid][pFamily] <= 0 && PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You must be in a family or faction to capture this point.");
    if(PlayerInfo[playerid][pFamily] > 0)
    {
        new fidx = ER_FindFamilyIndexBySQLID(PlayerInfo[playerid][pFamily]);
        if(fidx != -1 && PlayerInfo[playerid][pFamilyRank] < Families[fidx][fPointCaptureRank]) return ER_Send(playerid, COLOR_GREY, "Your family rank cannot capture points.");
    }
    if(PlayerInfo[playerid][pFaction] > 0)
    {
        new facidx = ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]);
        if(facidx != -1 && PlayerInfo[playerid][pFactionRank] < Factions[facidx][facPointCaptureRank]) return ER_Send(playerid, COLOR_GREY, "Your faction rank cannot capture points.");
    }
    SetPVarInt(playerid, "CapturingPoint", Points[idx][ptSQLID]);
    SetPVarInt(playerid, "CapturePointSeconds", Points[idx][ptCaptureSeconds]);
    TogglePlayerControllable(playerid, 0);
    GameTextForPlayer(playerid, "~y~Capturing Point...", 3000, 3);
    SetTimerEx("ER_PointCaptureTick", 1000, false, "i", playerid);
    return 1;
}
forward ER_PointCaptureTick(playerid);
public ER_PointCaptureTick(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new id = GetPVarInt(playerid, "CapturingPoint"), seconds = GetPVarInt(playerid, "CapturePointSeconds"), idx = ER_FindPointIndexBySQLID(id);
    if(idx == -1 || ER_GetNearestPoint(playerid) != idx)
    {
        TogglePlayerControllable(playerid, 1); DeletePVar(playerid, "CapturingPoint"); DeletePVar(playerid, "CapturePointSeconds");
        return ER_Send(playerid, COLOR_GREY, "Capture canceled.");
    }
    if(seconds > 0)
    {
        new gt[64]; format(gt, sizeof(gt), "~y~Capturing Point...~n~~w~%d seconds", seconds);
        GameTextForPlayer(playerid, gt, 1500, 3);
        SetPVarInt(playerid, "CapturePointSeconds", seconds - 1);
        SetTimerEx("ER_PointCaptureTick", 1000, false, "i", playerid);
        return 1;
    }
    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `points` SET `owner_family`=%d,`owner_faction`=%d WHERE `id`=%d", PlayerInfo[playerid][pFamily], PlayerInfo[playerid][pFaction], id);
    mysql_tquery(MainPipeline, q); TogglePlayerControllable(playerid, 1); DeletePVar(playerid, "CapturingPoint"); DeletePVar(playerid, "CapturePointSeconds");
    ER_LoadPoints(); SendClientMessageToAll(COLOR_YELLOW, "A capture point has been taken over.");
    return 1;
}

CMD:editpoints(playerid, params[]) { if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized."); new list[2048], line[96]; for(new i; i < PointCount; i++){format(line,sizeof(line),"%d - %s\n",Points[i][ptSQLID],Points[i][ptName]); strcat(list,line,sizeof(list));} if(!list[0]) format(list,sizeof(list),"No points."); return ShowPlayerDialog(playerid,DIALOG_POINT_LIST,DIALOG_STYLE_LIST,"Capture Points",list,"Edit","Close"); }
CMD:editpoint(playerid, params[]) { new id; if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid,COLOR_GREY,"You are not authorized."); if(sscanf(params,"d",id)) return ER_Send(playerid,COLOR_GREY,"USAGE: /editpoint [id]"); SetPVarInt(playerid,"EditingPoint",id); return ShowPlayerDialog(playerid,DIALOG_POINT_EDITOR,DIALOG_STYLE_LIST,"Point Editor","Goto\nSet Position Here\nSet Name\nSet Capture Seconds\nDelete", "Select", "Close"); }
CMD:deletepoint(playerid, params[]) { new id,q[128]; if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid,COLOR_GREY,"You are not authorized."); if(sscanf(params,"d",id)) return ER_Send(playerid,COLOR_GREY,"USAGE: /deletepoint [id]"); mysql_format(MainPipeline,q,sizeof(q),"UPDATE `points` SET `enabled`=0 WHERE `id`=%d",id); mysql_tquery(MainPipeline,q); ER_LoadPoints(); return ER_Send(playerid,COLOR_GREEN,"Point deleted."); }

stock ER_PointDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_POINT_LIST){ if(!response) return 1; if(listitem < 0 || listitem >= PointCount) return 1; SetPVarInt(playerid,"EditingPoint",Points[listitem][ptSQLID]); return ShowPlayerDialog(playerid,DIALOG_POINT_EDITOR,DIALOG_STYLE_LIST,"Point Editor","Goto\nSet Position Here\nSet Name\nSet Capture Seconds\nDelete", "Select", "Close"); }
    if(dialogid == DIALOG_POINT_EDITOR){ if(!response) return 1; new id=GetPVarInt(playerid,"EditingPoint"), idx=ER_FindPointIndexBySQLID(id), q[256], Float:x, Float:y, Float:z; if(idx==-1) return 1; SetPVarInt(playerid,"PointEditAction",listitem); if(listitem==0){SetPlayerInterior(playerid,Points[idx][ptInt]);SetPlayerVirtualWorld(playerid,Points[idx][ptVW]);SetPlayerPos(playerid,Points[idx][ptX],Points[idx][ptY],Points[idx][ptZ]+1.0);return 1;} if(listitem==1){GetPlayerPos(playerid,x,y,z);mysql_format(MainPipeline,q,sizeof(q),"UPDATE `points` SET `x`=%f,`y`=%f,`z`=%f,`interior`=%d,`vw`=%d WHERE `id`=%d",x,y,z,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),id);mysql_tquery(MainPipeline,q);ER_LoadPoints();return ER_Send(playerid,COLOR_GREEN,"Point position saved.");} if(listitem==2) return ShowPlayerDialog(playerid,DIALOG_POINT_INPUT,DIALOG_STYLE_INPUT,"Point Name","Enter point name:","Save","Back"); if(listitem==3) return ShowPlayerDialog(playerid,DIALOG_POINT_INPUT,DIALOG_STYLE_INPUT,"Capture Seconds","Enter seconds:","Save","Back"); if(listitem==4) return ShowPlayerDialog(playerid,DIALOG_POINT_DELETE_CONFIRM,DIALOG_STYLE_MSGBOX,"Delete Point","Delete this point?","Delete","Cancel"); }
    if(dialogid == DIALOG_POINT_INPUT){ if(!response) return 1; new id=GetPVarInt(playerid,"EditingPoint"), action=GetPVarInt(playerid,"PointEditAction"), q[256]; if(action==2) mysql_format(MainPipeline,q,sizeof(q),"UPDATE `points` SET `name`='%e' WHERE `id`=%d",inputtext,id); else mysql_format(MainPipeline,q,sizeof(q),"UPDATE `points` SET `capture_seconds`=%d WHERE `id`=%d",strval(inputtext),id); mysql_tquery(MainPipeline,q); ER_LoadPoints(); return ER_Send(playerid,COLOR_GREEN,"Point updated."); }
    if(dialogid == DIALOG_POINT_DELETE_CONFIRM){ if(!response) return 1; new id=GetPVarInt(playerid,"EditingPoint"),q[128]; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `points` SET `enabled`=0 WHERE `id`=%d",id); mysql_tquery(MainPipeline,q); ER_LoadPoints(); return ER_Send(playerid,COLOR_GREEN,"Point deleted."); }
    return 0;
}
