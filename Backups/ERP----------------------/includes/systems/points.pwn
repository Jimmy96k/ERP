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
    ptCapturedBy[64],
    ptSafeBalance,
    ptCaptureTime,
    ptExpireTime,
    ptCaptureSeconds,
    ptPickupID,
    Text3D:ptLabelID,
    ptEnabled
};
new Points[MAX_POINTS][E_POINT_INFO];
new PointCount;

stock ER_GetFamilyDisplayNameBySQLID(fid, dest[], size)
{
    new idx = ER_FindFamilyIndexBySQLID(fid);
    if(idx != -1) return format(dest, size, "%s", Families[idx][fName]);
    if(fid > 0) return format(dest, size, "Family %d", fid);
    return format(dest, size, "None");
}

stock ER_FormatPointStatusForMatrun(pointid, dest[], size)
{
    new idx = ER_FindPointIndexBySQLID(pointid), fam[64], hex[8], fidx;
    if(pointid <= 0 || idx == -1) return format(dest, size, "Available to Capture");
    if(Points[idx][ptOwnerFamily] > 0)
    {
        ER_GetFamilyDisplayNameBySQLID(Points[idx][ptOwnerFamily], fam, sizeof(fam));
        fidx = ER_FindFamilyIndexBySQLID(Points[idx][ptOwnerFamily]);
        if(fidx != -1) ER_ColorToDialogHex(Families[fidx][fColor], hex, sizeof(hex));
        else format(hex, sizeof(hex), "33CCFF");
        return format(dest, size, "Captured by: {%s}%s", hex, fam);
    }
    if(Points[idx][ptOwnerFaction] > 0) return format(dest, size, "Captured by: Faction %d", Points[idx][ptOwnerFaction]);
    return format(dest, size, "Available to Capture");
}

stock ER_IsPointLinkedToMatrun(pointid)
{
    if(pointid <= 0) return 0;
    for(new i; i < MatrunCount; i++)
    {
        if(!Matruns[i][mrEnabled]) continue;
        if(Matruns[i][mrPickupPointID] == pointid || Matruns[i][mrDropoffPointID] == pointid) return 1;
    }
    return 0;
}

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
    if(ER_IsPointLinkedToMatrun(Points[idx][ptSQLID])) return 1;

    new label[256], owner[128];
    ER_FormatPointStatusForMatrun(Points[idx][ptSQLID], owner, sizeof(owner));

    format(label, sizeof(label), "{FFFF00}%s\n{FFFFFF}%s\nSafe: %s\nPoint ID: %d\nUse /capture", Points[idx][ptName], owner, ER_FormatMoney(Points[idx][ptSafeBalance]), Points[idx][ptSQLID]);
    Points[idx][ptPickupID] = CreateDynamicPickup(1314, 23, Points[idx][ptX], Points[idx][ptY], Points[idx][ptZ], Points[idx][ptVW], Points[idx][ptInt]);
    Points[idx][ptLabelID] = CreateDynamic3DTextLabel(label, COLOR_YELLOW, Points[idx][ptX], Points[idx][ptY], Points[idx][ptZ] + 0.35, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Points[idx][ptVW], Points[idx][ptInt]);
    return 1;
}

stock ER_LoadPointRowFromCache(row, idx)
{
    cache_get_value_name_int(row, "id", Points[idx][ptSQLID]);
    cache_get_value_name(row, "name", Points[idx][ptName], 64);
    cache_get_value_name_float(row, "x", Points[idx][ptX]);
    cache_get_value_name_float(row, "y", Points[idx][ptY]);
    cache_get_value_name_float(row, "z", Points[idx][ptZ]);
    cache_get_value_name_int(row, "interior", Points[idx][ptInt]);
    cache_get_value_name_int(row, "vw", Points[idx][ptVW]);
    cache_get_value_name_int(row, "owner_family", Points[idx][ptOwnerFamily]);
    cache_get_value_name_int(row, "owner_faction", Points[idx][ptOwnerFaction]);
    cache_get_value_name(row, "captured_by_name", Points[idx][ptCapturedBy], 64);
    cache_get_value_name_int(row, "safe_balance", Points[idx][ptSafeBalance]);
    cache_get_value_name_int(row, "capture_time", Points[idx][ptCaptureTime]);
    cache_get_value_name_int(row, "expire_time", Points[idx][ptExpireTime]);
    cache_get_value_name_int(row, "capture_seconds", Points[idx][ptCaptureSeconds]);
    cache_get_value_name_int(row, "enabled", Points[idx][ptEnabled]);
    if(Points[idx][ptCaptureSeconds] <= 0) Points[idx][ptCaptureSeconds] = 60;
    return 1;
}

stock ER_DestroyPointWorldSlot(idx)
{
    if(idx < 0 || idx >= MAX_POINTS) return 0;
    if(Points[idx][ptPickupID]) DestroyDynamicPickup(Points[idx][ptPickupID]);
    if(Points[idx][ptLabelID]) DestroyDynamic3DTextLabel(Points[idx][ptLabelID]);
    Points[idx][ptPickupID] = 0;
    Points[idx][ptLabelID] = Text3D:0;
    return 1;
}

stock ER_RemovePointSlot(idx)
{
    if(idx < 0 || idx >= PointCount) return 0;
    ER_DestroyPointWorldSlot(idx);
    Points[idx][ptEnabled] = 0;
    Points[idx][ptSQLID] = 0;
    return 1;
}

stock ER_ReloadPointBySQLID(sqlid, playerid = INVALID_PLAYER_ID)
{
    new q[128];
    mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `points` WHERE `id`=%d LIMIT 1", sqlid);
    mysql_tquery(MainPipeline, q, "ER_OnSinglePointReload", "ii", sqlid, playerid);
    return 1;
}

forward ER_OnSinglePointReload(sqlid, playerid);
public ER_OnSinglePointReload(sqlid, playerid)
{
    new rows; cache_get_row_count(rows);
    new idx = ER_FindPointIndexBySQLID(sqlid);
    if(!rows)
    {
        if(idx != -1) ER_RemovePointSlot(idx);
        if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "Point reloaded: not found or removed.");
        ER_LoadMatruns();
        return 1;
    }
    if(idx == -1)
    {
        if(PointCount >= MAX_POINTS) return 0;
        idx = PointCount++;
    }
    else ER_DestroyPointWorldSlot(idx);
    ER_LoadPointRowFromCache(0, idx);
    if(Points[idx][ptEnabled]) ER_CreatePointWorld(idx);
    ER_LoadMatruns();
    if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "Point reloaded.");
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
        ER_LoadPointRowFromCache(r, PointCount);
        ER_CreatePointWorld(PointCount);
        PointCount++;
    }
    printf("[Points] Loaded %d capture points.", PointCount);
    ER_LoadMatruns();
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
        if(!Points[i][ptEnabled]) continue;
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
    new id = cache_insert_id(), msg[96];
    ER_ReloadPointBySQLID(id, playerid);
    format(msg, sizeof(msg), "Capture point created with ID %d.", id);
    return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:points(playerid, params[])
{
    #pragma unused params
    new body[4096], line[320], owner[96], fam[64], cap[64], hex[8], hours;
    format(body, sizeof(body), "{F6A800}____________________ Capture Points ____________________\n");
    for(new i; i < PointCount; i++)
    {
        format(hex, sizeof(hex), "FFFFFF");
        if(Points[i][ptOwnerFamily] > 0)
        {
            new fidx = ER_FindFamilyIndexBySQLID(Points[i][ptOwnerFamily]);
            ER_GetFamilyDisplayNameBySQLID(Points[i][ptOwnerFamily], fam, sizeof(fam));
            if(fidx != -1) ER_ColorToDialogHex(Families[fidx][fColor], hex, sizeof(hex));
            format(owner, sizeof(owner), "%s", fam);
        }
        else if(Points[i][ptOwnerFaction] > 0) format(owner, sizeof(owner), "Faction %d", Points[i][ptOwnerFaction]);
        else format(owner, sizeof(owner), "Available to Capture");

        if(Points[i][ptCapturedBy][0]) format(cap, sizeof(cap), "%s", Points[i][ptCapturedBy]);
        else format(cap, sizeof(cap), "None");

        hours = 0;
        if(Points[i][ptExpireTime] > gettime()) hours = (Points[i][ptExpireTime] - gettime() + 3599) / 3600;

        if(Points[i][ptOwnerFamily] > 0)
        {
            format(line, sizeof(line), "{F6A800}Name: {FFFFFF}%s {F6A800}| Owner: {%s}%s {F6A800}| Captured By: {FFFFFF}%s {F6A800}| Hours: {FFFFFF}%d {F6A800}| Safe: {FFFFFF}%s\n",
                Points[i][ptName], hex, owner, cap, hours, ER_FormatMoney(Points[i][ptSafeBalance]));
        }
        else
        {
            format(line, sizeof(line), "{F6A800}Name: {FFFFFF}%s {F6A800}| Owner: {FFFFFF}%s {F6A800}| Captured By: {FFFFFF}%s {F6A800}| Hours: {FFFFFF}%d {F6A800}| Safe: {FFFFFF}%s\n",
                Points[i][ptName], owner, cap, hours, ER_FormatMoney(Points[i][ptSafeBalance]));
        }
        strcat(body, line, sizeof(body));
    }
    return ShowPlayerDialog(playerid, DIALOG_POINTS_VIEW, DIALOG_STYLE_MSGBOX, "Capture Points", body, "Close", "");
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
    new q[384];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `points` SET `owner_family`=%d,`owner_faction`=%d,`captured_by_name`='%e',`capture_time`=%d,`expire_time`=%d WHERE `id`=%d", PlayerInfo[playerid][pFamily], PlayerInfo[playerid][pFaction], ER_GetName(playerid), gettime(), gettime()+86400, id);
    mysql_tquery(MainPipeline, q);
    TogglePlayerControllable(playerid, 1);
    DeletePVar(playerid, "CapturingPoint");
    DeletePVar(playerid, "CapturePointSeconds");
    ER_ReloadPointBySQLID(id);
    SendClientMessageToAll(COLOR_YELLOW, "A capture point has been taken over.");
    return 1;
}

stock ER_ShowPointEditor(playerid, id)
{
    new idx = ER_FindPointIndexBySQLID(id), body[512], owner[96], fam[64];
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid point."), 1;
    SetPVarInt(playerid, "EditingPoint", id);
    if(Points[idx][ptOwnerFamily] > 0) { ER_GetFamilyDisplayNameBySQLID(Points[idx][ptOwnerFamily], fam, sizeof(fam)); format(owner, sizeof(owner), "%s", fam); }
    else if(Points[idx][ptOwnerFaction] > 0) format(owner, sizeof(owner), "Faction %d", Points[idx][ptOwnerFaction]);
    else format(owner, sizeof(owner), "Available to Capture");
    format(body, sizeof(body), "Goto\nSet Position Here\nName: %s\nSafe: %s\nCapture Seconds: %d\nOwner: %s\nClear Owner\nDelete", Points[idx][ptName], ER_FormatMoney(Points[idx][ptSafeBalance]), Points[idx][ptCaptureSeconds], owner);
    return ShowPlayerDialog(playerid, DIALOG_POINT_EDITOR, DIALOG_STYLE_LIST, "Point Editor", body, "Select", "Close");
}

CMD:editpoints(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");

    new list[2048], line[128];
    for(new i; i < PointCount; i++)
    {
        format(line, sizeof(line), "%d - %s - Safe: %s\n", Points[i][ptSQLID], Points[i][ptName], ER_FormatMoney(Points[i][ptSafeBalance]));
        strcat(list, line, sizeof(list));
    }
    if(!list[0]) format(list, sizeof(list), "No points.");
    return ShowPlayerDialog(playerid, DIALOG_POINT_LIST, DIALOG_STYLE_LIST, "Capture Points", list, "Edit", "Close");
}

CMD:editpoint(playerid, params[])
{
    new id;
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "d", id)) return ER_Send(playerid, COLOR_GREY, "USAGE: /editpoint [id]");
    return ER_ShowPointEditor(playerid, id);
}

CMD:deletepoint(playerid, params[])
{
    new id, q[128];
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid,COLOR_GREY,"You are not authorized.");
    if(sscanf(params,"d",id)) return ER_Send(playerid,COLOR_GREY,"USAGE: /deletepoint [id]");
    mysql_format(MainPipeline,q,sizeof(q),"UPDATE `points` SET `enabled`=0 WHERE `id`=%d",id);
    mysql_tquery(MainPipeline,q);
    ER_ReloadPointBySQLID(id, playerid);
    return ER_Send(playerid,COLOR_GREEN,"Point deleted.");
}

stock ER_PointDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_POINT_LIST)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= PointCount) return 1;
        return ER_ShowPointEditor(playerid, Points[listitem][ptSQLID]);
    }

    if(dialogid == DIALOG_POINT_EDITOR)
    {
        if(!response) return 1;

        new id = GetPVarInt(playerid, "EditingPoint");
        new idx = ER_FindPointIndexBySQLID(id);
        new q[256];
        new Float:x, Float:y, Float:z;

        if(idx == -1) return 1;
        SetPVarInt(playerid, "PointEditAction", listitem);

        if(listitem == 0)
        {
            SetPlayerInterior(playerid, Points[idx][ptInt]);
            SetPlayerVirtualWorld(playerid, Points[idx][ptVW]);
            SetPlayerPos(playerid, Points[idx][ptX], Points[idx][ptY], Points[idx][ptZ] + 1.0);
            return 1;
        }
        if(listitem == 1)
        {
            GetPlayerPos(playerid, x, y, z);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `points` SET `x`=%f,`y`=%f,`z`=%f,`interior`=%d,`vw`=%d WHERE `id`=%d", x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), id);
            mysql_tquery(MainPipeline, q);
            ER_ReloadPointBySQLID(id, playerid);
            return ER_Send(playerid, COLOR_GREEN, "Point position saved.");
        }
        if(listitem == 2) return ShowPlayerDialog(playerid, DIALOG_POINT_INPUT, DIALOG_STYLE_INPUT, "Point Name", "Enter point name:", "Save", "Back");
        if(listitem == 3) return ShowPlayerDialog(playerid, DIALOG_POINT_INPUT, DIALOG_STYLE_INPUT, "Point Safe", "Enter point safe balance:", "Save", "Back");
        if(listitem == 4) return ShowPlayerDialog(playerid, DIALOG_POINT_INPUT, DIALOG_STYLE_INPUT, "Capture Seconds", "Enter seconds:", "Save", "Back");
        if(listitem == 5) return ER_ShowPointEditor(playerid, id);
        if(listitem == 6)
        {
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `points` SET `owner_family`=0,`owner_faction`=0,`captured_by_name`='',`capture_time`=0,`expire_time`=0 WHERE `id`=%d", id);
            mysql_tquery(MainPipeline, q);
            ER_ReloadPointBySQLID(id, playerid);
            return ER_Send(playerid, COLOR_GREEN, "Point owner cleared.");
        }
        if(listitem == 7) return ShowPlayerDialog(playerid, DIALOG_POINT_DELETE_CONFIRM, DIALOG_STYLE_MSGBOX, "Delete Point", "Delete this point?", "Delete", "Cancel");
        return 1;
    }

    if(dialogid == DIALOG_POINT_INPUT)
    {
        if(!response) return ER_ShowPointEditor(playerid, GetPVarInt(playerid, "EditingPoint"));

        new id = GetPVarInt(playerid, "EditingPoint");
        new action = GetPVarInt(playerid, "PointEditAction");
        new q[256];

        if(action == 2) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `points` SET `name`='%e' WHERE `id`=%d", inputtext, id);
        else if(action == 3) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `points` SET `safe_balance`=%d WHERE `id`=%d", strval(inputtext), id);
        else mysql_format(MainPipeline, q, sizeof(q), "UPDATE `points` SET `capture_seconds`=%d WHERE `id`=%d", strval(inputtext), id);

        mysql_tquery(MainPipeline, q);
        ER_ReloadPointBySQLID(id, playerid);
        return ER_Send(playerid, COLOR_GREEN, "Point updated.");
    }

    if(dialogid == DIALOG_POINT_DELETE_CONFIRM)
    {
        if(!response) return ER_ShowPointEditor(playerid, GetPVarInt(playerid, "EditingPoint"));

        new id = GetPVarInt(playerid, "EditingPoint");
        new q[128];

        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `points` SET `enabled`=0 WHERE `id`=%d", id);
        mysql_tquery(MainPipeline, q);
        ER_ReloadPointBySQLID(id, playerid);
        return ER_Send(playerid, COLOR_GREEN, "Point deleted.");
    }
    return 0;
}
