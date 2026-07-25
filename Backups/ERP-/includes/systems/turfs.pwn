#if defined _ER_TURFS_INCLUDED
    #endinput
#endif
#define _ER_TURFS_INCLUDED

enum E_TURF_INFO
{
    tfSQLID,
    tfName[64],
    Float:tfMinX,
    Float:tfMinY,
    Float:tfMaxX,
    Float:tfMaxY,
    tfOwnerFamily,
    tfOwnerFaction,
    tfCaptureSeconds,
    tfEnabled
};
new Turfs[MAX_TURFS][E_TURF_INFO];
new TurfCount;

stock ER_LoadTurfs()
{
    TurfCount = 0;
    mysql_tquery(MainPipeline, "SELECT * FROM `turfs` WHERE `enabled`=1 ORDER BY `id` ASC", "ER_OnTurfsLoad");
    return 1;
}
forward ER_OnTurfsLoad();
public ER_OnTurfsLoad()
{
    new rows; cache_get_row_count(rows);
    for(new r; r < rows && TurfCount < MAX_TURFS; r++)
    {
        cache_get_value_name_int(r, "id", Turfs[TurfCount][tfSQLID]);
        cache_get_value_name(r, "name", Turfs[TurfCount][tfName], 64);
        cache_get_value_name_float(r, "min_x", Turfs[TurfCount][tfMinX]);
        cache_get_value_name_float(r, "min_y", Turfs[TurfCount][tfMinY]);
        cache_get_value_name_float(r, "max_x", Turfs[TurfCount][tfMaxX]);
        cache_get_value_name_float(r, "max_y", Turfs[TurfCount][tfMaxY]);
        cache_get_value_name_int(r, "owner_family", Turfs[TurfCount][tfOwnerFamily]);
        cache_get_value_name_int(r, "owner_faction", Turfs[TurfCount][tfOwnerFaction]);
        cache_get_value_name_int(r, "capture_seconds", Turfs[TurfCount][tfCaptureSeconds]);
        cache_get_value_name_int(r, "enabled", Turfs[TurfCount][tfEnabled]);
        if(Turfs[TurfCount][tfCaptureSeconds] <= 0) Turfs[TurfCount][tfCaptureSeconds] = 90;
        TurfCount++;
    }
    printf("[Turfs] Loaded %d turfs.", TurfCount);
    return 1;
}

stock ER_FindTurfIndexBySQLID(id)
{
    for(new i; i < TurfCount; i++) if(Turfs[i][tfSQLID] == id) return i;
    return -1;
}
stock ER_PlayerInTurf(playerid, idx)
{
    new Float:x, Float:y, Float:z; GetPlayerPos(playerid, x, y, z);
    return (x >= Turfs[idx][tfMinX] && x <= Turfs[idx][tfMaxX] && y >= Turfs[idx][tfMinY] && y <= Turfs[idx][tfMaxY]);
}
stock ER_GetPlayerTurf(playerid)
{
    for(new i; i < TurfCount; i++) if(ER_PlayerInTurf(playerid, i)) return i;
    return -1;
}

CMD:createturf(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new radius, name[64]; if(sscanf(params, "dS(Turf)[64]", radius, name)) return ER_Send(playerid, COLOR_GREY, "USAGE: /createturf [radius] [name]");
    if(radius < 10) radius = 10; if(radius > 500) radius = 500;
    new Float:x, Float:y, Float:z, q[384]; GetPlayerPos(playerid, x, y, z);
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `turfs` (`name`,`min_x`,`min_y`,`max_x`,`max_y`,`capture_seconds`,`enabled`) VALUES ('%e',%f,%f,%f,%f,90,1)", name, x-radius, y-radius, x+radius, y+radius);
    mysql_tquery(MainPipeline, q, "ER_OnTurfCreated", "i", playerid); return 1;
}
forward ER_OnTurfCreated(playerid);
public ER_OnTurfCreated(playerid)
{
    new id=cache_insert_id(), msg[96]; ER_LoadTurfs(); format(msg,sizeof(msg),"Turf created with ID %d.",id); return ER_Send(playerid,COLOR_GREEN,msg);
}

CMD:turfs(playerid, params[])
{
    SendClientMessage(playerid, COLOR_HELP, "____________________ Turfs ____________________");
    new line[128], owner[32];
    for(new i; i < TurfCount; i++)
    {
        if(Turfs[i][tfOwnerFamily] > 0) format(owner, sizeof(owner), "Family %d", Turfs[i][tfOwnerFamily]);
        else if(Turfs[i][tfOwnerFaction] > 0) format(owner, sizeof(owner), "Faction %d", Turfs[i][tfOwnerFaction]);
        else format(owner, sizeof(owner), "Unowned");
        format(line, sizeof(line), "%d - %s - %s", Turfs[i][tfSQLID], Turfs[i][tfName], owner);
        SendClientMessage(playerid, COLOR_HELP, line);
    }
    return 1;
}

CMD:turf(playerid, params[])
{
    new idx = ER_GetPlayerTurf(playerid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "You are not inside a turf.");
    new line[128], owner[32];
    if(Turfs[idx][tfOwnerFamily] > 0) format(owner, sizeof(owner), "Family %d", Turfs[idx][tfOwnerFamily]);
    else if(Turfs[idx][tfOwnerFaction] > 0) format(owner, sizeof(owner), "Faction %d", Turfs[idx][tfOwnerFaction]);
    else format(owner, sizeof(owner), "Unowned");
    format(line, sizeof(line), "Turf: %s | Owner: %s", Turfs[idx][tfName], owner);
    return ER_Send(playerid, COLOR_HELP, line);
}

CMD:captureturf(playerid, params[])
{
    new idx = ER_GetPlayerTurf(playerid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "You are not inside a turf.");
    if(PlayerInfo[playerid][pFamily] <= 0 && PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You must be in a family or faction to capture this turf.");
    if(PlayerInfo[playerid][pFamily] > 0){new fidx=ER_FindFamilyIndexBySQLID(PlayerInfo[playerid][pFamily]); if(fidx!=-1 && PlayerInfo[playerid][pFamilyRank] < Families[fidx][fTurfCaptureRank]) return ER_Send(playerid,COLOR_GREY,"Your family rank cannot capture turfs.");}
    if(PlayerInfo[playerid][pFaction] > 0){new facidx=ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]); if(facidx!=-1 && PlayerInfo[playerid][pFactionRank] < Factions[facidx][facTurfCaptureRank]) return ER_Send(playerid,COLOR_GREY,"Your faction rank cannot capture turfs.");}
    SetPVarInt(playerid, "CapturingTurf", Turfs[idx][tfSQLID]); SetPVarInt(playerid, "CaptureTurfSeconds", Turfs[idx][tfCaptureSeconds]); TogglePlayerControllable(playerid, 0); GameTextForPlayer(playerid, "~r~Capturing Turf...", 3000, 3); SetTimerEx("ER_TurfCaptureTick", 1000, false, "i", playerid); return 1;
}
forward ER_TurfCaptureTick(playerid);
public ER_TurfCaptureTick(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new id=GetPVarInt(playerid,"CapturingTurf"), seconds=GetPVarInt(playerid,"CaptureTurfSeconds"), idx=ER_FindTurfIndexBySQLID(id);
    if(idx==-1 || !ER_PlayerInTurf(playerid, idx)){TogglePlayerControllable(playerid,1);DeletePVar(playerid,"CapturingTurf");DeletePVar(playerid,"CaptureTurfSeconds");return ER_Send(playerid,COLOR_GREY,"Turf capture canceled.");}
    if(seconds > 0){new gt[64];format(gt,sizeof(gt),"~r~Capturing Turf...~n~~w~%d seconds",seconds);GameTextForPlayer(playerid,gt,1500,3);SetPVarInt(playerid,"CaptureTurfSeconds",seconds-1);SetTimerEx("ER_TurfCaptureTick",1000,false,"i",playerid);return 1;}
    new q[256]; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `turfs` SET `owner_family`=%d,`owner_faction`=%d WHERE `id`=%d",PlayerInfo[playerid][pFamily],PlayerInfo[playerid][pFaction],id); mysql_tquery(MainPipeline,q); TogglePlayerControllable(playerid,1); DeletePVar(playerid,"CapturingTurf"); DeletePVar(playerid,"CaptureTurfSeconds"); ER_LoadTurfs(); SendClientMessageToAll(COLOR_LIGHTRED,"A turf has been captured."); return 1;
}

CMD:editturfs(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");

    new list[2048], line[96];
    for(new i; i < TurfCount; i++)
    {
        format(line, sizeof(line), "%d - %s\n", Turfs[i][tfSQLID], Turfs[i][tfName]);
        strcat(list, line, sizeof(list));
    }
    if(!list[0]) format(list, sizeof(list), "No turfs.");
    return ShowPlayerDialog(playerid, DIALOG_TURF_LIST, DIALOG_STYLE_LIST, "Turfs", list, "Edit", "Close");
}
CMD:editturf(playerid, params[])
{
    new id;
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "d", id)) return ER_Send(playerid, COLOR_GREY, "USAGE: /editturf [id]");

    SetPVarInt(playerid, "EditingTurf", id);
    return ShowPlayerDialog(playerid, DIALOG_TURF_EDITOR, DIALOG_STYLE_LIST, "Turf Editor", "Set Center/Radius Here\nSet Name\nSet Capture Seconds\nDelete", "Select", "Close");
}
CMD:deleteturf(playerid, params[]) { new id,q[128]; if(!ER_IsAdmin(playerid,ADMIN_HEAD)) return ER_Send(playerid,COLOR_GREY,"You are not authorized."); if(sscanf(params,"d",id)) return ER_Send(playerid,COLOR_GREY,"USAGE: /deleteturf [id]"); mysql_format(MainPipeline,q,sizeof(q),"UPDATE `turfs` SET `enabled`=0 WHERE `id`=%d",id);mysql_tquery(MainPipeline,q);ER_LoadTurfs();return ER_Send(playerid,COLOR_GREEN,"Turf deleted."); }

stock ER_TurfDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_TURF_LIST)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= TurfCount) return 1;

        SetPVarInt(playerid, "EditingTurf", Turfs[listitem][tfSQLID]);
        return ShowPlayerDialog(playerid, DIALOG_TURF_EDITOR, DIALOG_STYLE_LIST, "Turf Editor", "Set Center/Radius Here\nSet Name\nSet Capture Seconds\nDelete", "Select", "Close");
    }

    if(dialogid == DIALOG_TURF_EDITOR)
    {
        if(!response) return 1;
        SetPVarInt(playerid, "TurfEditAction", listitem);

        if(listitem == 0) return ShowPlayerDialog(playerid, DIALOG_TURF_INPUT, DIALOG_STYLE_INPUT, "Turf Radius", "Enter radius around your current position:", "Save", "Back");
        if(listitem == 1) return ShowPlayerDialog(playerid, DIALOG_TURF_INPUT, DIALOG_STYLE_INPUT, "Turf Name", "Enter name:", "Save", "Back");
        if(listitem == 2) return ShowPlayerDialog(playerid, DIALOG_TURF_INPUT, DIALOG_STYLE_INPUT, "Capture Seconds", "Enter seconds:", "Save", "Back");
        if(listitem == 3) return ShowPlayerDialog(playerid, DIALOG_TURF_DELETE_CONFIRM, DIALOG_STYLE_MSGBOX, "Delete Turf", "Delete this turf?", "Delete", "Cancel");
        return 1;
    }

    if(dialogid == DIALOG_TURF_INPUT)
    {
        if(!response) return 1;

        new id = GetPVarInt(playerid, "EditingTurf");
        new action = GetPVarInt(playerid, "TurfEditAction");
        new q[256];

        if(action == 0)
        {
            new radius = strval(inputtext);
            if(radius < 10) radius = 10;
            if(radius > 500) radius = 500;

            new Float:x, Float:y, Float:z;
            GetPlayerPos(playerid, x, y, z);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `turfs` SET `min_x`=%f,`min_y`=%f,`max_x`=%f,`max_y`=%f WHERE `id`=%d", x - radius, y - radius, x + radius, y + radius, id);
        }
        else if(action == 1)
        {
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `turfs` SET `name`='%e' WHERE `id`=%d", inputtext, id);
        }
        else
        {
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `turfs` SET `capture_seconds`=%d WHERE `id`=%d", strval(inputtext), id);
        }

        mysql_tquery(MainPipeline, q);
        ER_LoadTurfs();
        return ER_Send(playerid, COLOR_GREEN, "Turf updated.");
    }

    if(dialogid == DIALOG_TURF_DELETE_CONFIRM)
    {
        if(!response) return 1;

        new id = GetPVarInt(playerid, "EditingTurf");
        new q[128];

        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `turfs` SET `enabled`=0 WHERE `id`=%d", id);
        mysql_tquery(MainPipeline, q);
        ER_LoadTurfs();
        return ER_Send(playerid, COLOR_GREEN, "Turf deleted.");
    }
    return 0;
}
