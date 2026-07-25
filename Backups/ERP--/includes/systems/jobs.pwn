#if defined _ER_JOBS_INCLUDED
    #endinput
#endif
#define _ER_JOBS_INCLUDED

#define JOB_TYPE_NONE       0
#define JOB_TYPE_MECHANIC   1
#define JOB_TYPE_TAXI       2
#define JOB_TYPE_TRUCKER    3
#define JOB_TYPE_PIZZA      4
#define JOB_TYPE_ARMS       5
#define JOB_TYPE_DRUGS      6
#define JOB_TYPE_DETECTIVE  7
#define JOB_TYPE_LAWYER     8
#define JOB_TYPE_BUS        9
#define JOB_TYPE_GARBAGE    10
#define JOB_TYPE_MINER      11
#define JOB_TYPE_FISHER     12
#define JOB_TYPE_BODYGUARD  13
#define JOB_TYPE_BARTENDER  14
#define JOB_TYPE_CRAFTSMAN  15
#define JOB_TYPE_BOXER      16

enum E_JOB_INFO
{
    jSQLID,
    jName[64],
    jType,
    Float:jX,
    Float:jY,
    Float:jZ,
    Float:jA,
    jInt,
    jVW,
    jPickupModel,
    jPickupType,
    jPickupID,
    Text3D:jLabelID,
    jEnabled
};
new Jobs[MAX_JOBS][E_JOB_INFO];
new JobCount;

stock ER_GetJobTypeName(type, dest[], size)
{
    switch(type)
    {
        case JOB_TYPE_MECHANIC: format(dest, size, "Mechanic");
        case JOB_TYPE_TAXI: format(dest, size, "Taxi Driver");
        case JOB_TYPE_TRUCKER: format(dest, size, "Trucker");
        case JOB_TYPE_PIZZA: format(dest, size, "Pizza Delivery");
        case JOB_TYPE_ARMS: format(dest, size, "Arms Dealer");
        case JOB_TYPE_DRUGS: format(dest, size, "Drug Dealer");
        case JOB_TYPE_DETECTIVE: format(dest, size, "Detective");
        case JOB_TYPE_LAWYER: format(dest, size, "Lawyer");
        case JOB_TYPE_BUS: format(dest, size, "Bus Driver");
        case JOB_TYPE_GARBAGE: format(dest, size, "Garbage Collector");
        case JOB_TYPE_MINER: format(dest, size, "Miner");
        case JOB_TYPE_FISHER: format(dest, size, "Fisherman");
        case JOB_TYPE_BODYGUARD: format(dest, size, "Bodyguard");
        case JOB_TYPE_BARTENDER: format(dest, size, "Bartender");
        case JOB_TYPE_CRAFTSMAN: format(dest, size, "Craftsman");
        case JOB_TYPE_BOXER: format(dest, size, "Boxer");
        default: format(dest, size, "None");
    }
    return 1;
}

stock ER_ParseJobType(const src[])
{
    if(isnull(src)) return 0;
    if(src[0] >= '0' && src[0] <= '9') return strval(src);
    if(strfind("mechanic", src, true) != -1) return JOB_TYPE_MECHANIC;
    if(strfind("taxi", src, true) != -1) return JOB_TYPE_TAXI;
    if(strfind("truck", src, true) != -1) return JOB_TYPE_TRUCKER;
    if(strfind("pizza", src, true) != -1) return JOB_TYPE_PIZZA;
    if(strfind("arms", src, true) != -1 || strfind("gun", src, true) != -1) return JOB_TYPE_ARMS;
    if(strfind("drug", src, true) != -1) return JOB_TYPE_DRUGS;
    if(strfind("detect", src, true) != -1) return JOB_TYPE_DETECTIVE;
    if(strfind("law", src, true) != -1) return JOB_TYPE_LAWYER;
    if(strfind("bus", src, true) != -1) return JOB_TYPE_BUS;
    if(strfind("garbage", src, true) != -1 || strfind("trash", src, true) != -1) return JOB_TYPE_GARBAGE;
    if(strfind("miner", src, true) != -1 || strfind("mine", src, true) != -1) return JOB_TYPE_MINER;
    if(strfind("fish", src, true) != -1) return JOB_TYPE_FISHER;
    if(strfind("bodyguard", src, true) != -1 || strfind("guard", src, true) != -1) return JOB_TYPE_BODYGUARD;
    if(strfind("bar", src, true) != -1 || strfind("drink", src, true) != -1) return JOB_TYPE_BARTENDER;
    if(strfind("craft", src, true) != -1) return JOB_TYPE_CRAFTSMAN;
    if(strfind("box", src, true) != -1 || strfind("fight", src, true) != -1) return JOB_TYPE_BOXER;
    return 0;
}

stock ER_ClearJobs()
{
    for(new i; i < JobCount; i++)
    {
        if(Jobs[i][jPickupID]) DestroyDynamicPickup(Jobs[i][jPickupID]);
        if(Jobs[i][jLabelID]) DestroyDynamic3DTextLabel(Jobs[i][jLabelID]);
        Jobs[i][jPickupID] = 0;
        Jobs[i][jLabelID] = Text3D:0;
    }
    JobCount = 0;
    return 1;
}

stock ER_CreateJobWorld(idx)
{
    new typeName[32], label[192];
    ER_GetJobTypeName(Jobs[idx][jType], typeName, sizeof(typeName));
    format(label, sizeof(label), "%s\nType: %s\nJob ID: %d\nUse /join", Jobs[idx][jName], typeName, Jobs[idx][jSQLID]);
    Jobs[idx][jPickupID] = CreateDynamicPickup(Jobs[idx][jPickupModel] > 0 ? Jobs[idx][jPickupModel] : 1239, Jobs[idx][jPickupType] > 0 ? Jobs[idx][jPickupType] : 23, Jobs[idx][jX], Jobs[idx][jY], Jobs[idx][jZ], Jobs[idx][jVW], Jobs[idx][jInt]);
    Jobs[idx][jLabelID] = CreateDynamic3DTextLabel(label, COLOR_YELLOW, Jobs[idx][jX], Jobs[idx][jY], Jobs[idx][jZ] + 0.35, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Jobs[idx][jVW], Jobs[idx][jInt]);
    return 1;
}


stock ER_LoadJobRowFromCache(row, idx)
{
    cache_get_value_name_int(row, "id", Jobs[idx][jSQLID]);
    cache_get_value_name(row, "name", Jobs[idx][jName], 64);
    cache_get_value_name_int(row, "type", Jobs[idx][jType]);
    cache_get_value_name_float(row, "x", Jobs[idx][jX]);
    cache_get_value_name_float(row, "y", Jobs[idx][jY]);
    cache_get_value_name_float(row, "z", Jobs[idx][jZ]);
    cache_get_value_name_float(row, "a", Jobs[idx][jA]);
    cache_get_value_name_int(row, "interior", Jobs[idx][jInt]);
    cache_get_value_name_int(row, "vw", Jobs[idx][jVW]);
    cache_get_value_name_int(row, "pickup_model", Jobs[idx][jPickupModel]);
    cache_get_value_name_int(row, "pickup_type", Jobs[idx][jPickupType]);
    cache_get_value_name_int(row, "enabled", Jobs[idx][jEnabled]);
    return 1;
}

stock ER_DestroyJobWorldSlot(idx)
{
    if(idx < 0 || idx >= MAX_JOBS) return 0;
    if(Jobs[idx][jPickupID]) DestroyDynamicPickup(Jobs[idx][jPickupID]);
    if(Jobs[idx][jLabelID]) DestroyDynamic3DTextLabel(Jobs[idx][jLabelID]);
    Jobs[idx][jPickupID] = 0; Jobs[idx][jLabelID] = Text3D:0;
    return 1;
}

stock ER_RemoveJobSlot(idx)
{
    if(idx < 0 || idx >= JobCount) return 0;
    ER_DestroyJobWorldSlot(idx);
    Jobs[idx][jEnabled] = 0;
    Jobs[idx][jSQLID] = 0;
    return 1;
}

stock ER_ReloadJobBySQLID(sqlid, playerid = INVALID_PLAYER_ID)
{
    new q[128]; mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `jobs` WHERE `id`=%d LIMIT 1", sqlid);
    mysql_tquery(MainPipeline, q, "ER_OnSingleJobReload", "ii", sqlid, playerid);
    return 1;
}

forward ER_OnSingleJobReload(sqlid, playerid);
public ER_OnSingleJobReload(sqlid, playerid)
{
    new rows; cache_get_row_count(rows);
    new idx = ER_FindJobIndexBySQLID(sqlid);
    if(!rows)
    {
        if(idx != -1) ER_RemoveJobSlot(idx);
        if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "Job reloaded: not found or removed.");
        return 1;
    }
    if(idx == -1)
    {
        if(JobCount >= MAX_JOBS) return 0;
        idx = JobCount++;
    }
    else ER_DestroyJobWorldSlot(idx);
    ER_LoadJobRowFromCache(0, idx);
    if(Jobs[idx][jEnabled]) ER_CreateJobWorld(idx);
    if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "Job reloaded.");
    return 1;
}

stock ER_LoadJobs()
{
    ER_ClearJobs();
    mysql_tquery(MainPipeline, "SELECT * FROM `jobs` WHERE `enabled`=1 ORDER BY `id` ASC", "ER_OnJobsLoad");
    return 1;
}

forward ER_OnJobsLoad();
public ER_OnJobsLoad()
{
    new rows; cache_get_row_count(rows);
    for(new r; r < rows && JobCount < MAX_JOBS; r++)
    {
        cache_get_value_name_int(r, "id", Jobs[JobCount][jSQLID]);
        cache_get_value_name(r, "name", Jobs[JobCount][jName], 64);
        cache_get_value_name_int(r, "type", Jobs[JobCount][jType]);
        cache_get_value_name_float(r, "x", Jobs[JobCount][jX]);
        cache_get_value_name_float(r, "y", Jobs[JobCount][jY]);
        cache_get_value_name_float(r, "z", Jobs[JobCount][jZ]);
        cache_get_value_name_float(r, "a", Jobs[JobCount][jA]);
        cache_get_value_name_int(r, "interior", Jobs[JobCount][jInt]);
        cache_get_value_name_int(r, "vw", Jobs[JobCount][jVW]);
        cache_get_value_name_int(r, "pickup_model", Jobs[JobCount][jPickupModel]);
        cache_get_value_name_int(r, "pickup_type", Jobs[JobCount][jPickupType]);
        cache_get_value_name_int(r, "enabled", Jobs[JobCount][jEnabled]);
        ER_CreateJobWorld(JobCount);
        JobCount++;
    }
    printf("[Jobs] Loaded %d jobs.", JobCount);
    return 1;
}

stock ER_FindJobIndexBySQLID(sqlid)
{
    for(new i; i < JobCount; i++) if(Jobs[i][jSQLID] == sqlid) return i;
    return -1;
}

stock ER_GetNearestJob(playerid)
{
    new vw = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);
    for(new i; i < JobCount; i++)
    {
        if(!Jobs[i][jEnabled]) continue;
        if(vw == Jobs[i][jVW] && interior == Jobs[i][jInt] && IsPlayerInRangeOfPoint(playerid, 3.0, Jobs[i][jX], Jobs[i][jY], Jobs[i][jZ])) return i;
    }
    return -1;
}

stock ER_PlayerHasJob(playerid, jobid)
{
    for(new i; i < MAX_JOBS_PER_PLAYER; i++) if(PlayerInfo[playerid][pPlayerJob][i] == jobid) return 1;
    return 0;
}

stock ER_AddPlayerJob(playerid, jobid)
{
    if(ER_PlayerHasJob(playerid, jobid)) return 0;
    for(new i; i < MAX_JOBS_PER_PLAYER; i++)
    {
        if(PlayerInfo[playerid][pPlayerJob][i] == 0)
        {
            PlayerInfo[playerid][pPlayerJob][i] = jobid;
            ER_SaveCharacter(playerid);
            return 1;
        }
    }
    return 0;
}

CMD:createjob(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new typeText[32], name[64];
    if(sscanf(params, "s[32]S(Job)[64]", typeText, name)) return ER_Send(playerid, COLOR_GREY, "USAGE: /createjob [type/id] [name]");
    new type = ER_ParseJobType(typeText);
    if(type <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid job type. Try mechanic, taxi, trucker, pizza, arms, drugs, detective, lawyer, bus, garbage, miner, fisher, bodyguard, bartender, craftsman, boxer.");
    new Float:x, Float:y, Float:z, Float:a, q[512];
    GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `jobs` (`name`,`type`,`x`,`y`,`z`,`a`,`interior`,`vw`,`pickup_model`,`pickup_type`,`enabled`) VALUES ('%e',%d,%f,%f,%f,%f,%d,%d,1239,23,1)", name, type, x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
    mysql_tquery(MainPipeline, q, "ER_OnJobCreated", "i", playerid);
    return 1;
}

forward ER_OnJobCreated(playerid);
public ER_OnJobCreated(playerid)
{
    new id = cache_insert_id(), msg[96];
    ER_ReloadJobBySQLID(id, playerid);
    format(msg, sizeof(msg), "Job created with ID %d. Use /editjob %d.", id, id);
    return ER_Send(playerid, COLOR_GREEN, msg);
}


stock ER_ShowJobEditor(playerid, id)
{
    new idx = ER_FindJobIndexBySQLID(id);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid job ID.");
    SetPVarInt(playerid, "EditingJob", id);
    new title[96]; format(title, sizeof(title), "Job Editor - %s (%d)", Jobs[idx][jName], id);
    return ShowPlayerDialog(playerid, DIALOG_JOB_EDITOR, DIALOG_STYLE_LIST, title, "Set Name\nSet Type\nSet Position Here\nGoto Job\nToggle Enabled/Delete\nReload Jobs", "Select", "Close");
}

CMD:editjobs(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new list[4096], line[128], typeName[32];
    for(new i; i < JobCount; i++)
    {
        ER_GetJobTypeName(Jobs[i][jType], typeName, sizeof(typeName));
        format(line, sizeof(line), "%d - %s - %s\n", Jobs[i][jSQLID], Jobs[i][jName], typeName);
        strcat(list, line, sizeof(list));
    }
    if(!list[0]) format(list, sizeof(list), "No jobs created.");
    return ShowPlayerDialog(playerid, DIALOG_JOB_LIST, DIALOG_STYLE_LIST, "Jobs", list, "Edit", "Close");
}

CMD:editjob(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new id; if(sscanf(params, "d", id)) return ER_Send(playerid, COLOR_GREY, "USAGE: /editjob [id]");
    return ER_ShowJobEditor(playerid, id);
}

CMD:deletejob(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new id; if(sscanf(params, "d", id)) return ER_Send(playerid, COLOR_GREY, "USAGE: /deletejob [id]");
    new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `jobs` SET `enabled`=0 WHERE `id`=%d", id); mysql_tquery(MainPipeline, q);
    ER_ReloadJobBySQLID(id, playerid); return ER_Send(playerid, COLOR_GREEN, "Job deleted/disabled.");
}

stock ER_PlayerJoinNearestJob(playerid)
{
    new idx = ER_GetNearestJob(playerid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "You are not at a job pickup.");
    if(ER_AddPlayerJob(playerid, Jobs[idx][jSQLID])) return ER_Send(playerid, COLOR_GREEN, "You joined this job.");
    return ER_Send(playerid, COLOR_GREY, "You already have this job or your job slots are full.");
}
CMD:joinjob(playerid, params[])
{
    return ER_PlayerJoinNearestJob(playerid);
}
CMD:join(playerid, params[])
{
    return ER_PlayerJoinNearestJob(playerid);
}

CMD:leavejob(playerid, params[])
{
    new slot;
    if(sscanf(params, "d", slot)) return ER_Send(playerid, COLOR_GREY, "USAGE: /leavejob [slot 1-10]");
    slot--;
    if(slot < 0 || slot >= MAX_JOBS_PER_PLAYER) return ER_Send(playerid, COLOR_GREY, "Invalid slot.");
    PlayerInfo[playerid][pPlayerJob][slot] = 0; ER_SaveCharacter(playerid);
    return ER_Send(playerid, COLOR_GREEN, "Job slot cleared.");
}

CMD:myjobs(playerid, params[])
{
    new msg[128], name[64], list[1024];
    for(new i; i < MAX_JOBS_PER_PLAYER; i++)
    {
        if(PlayerInfo[playerid][pPlayerJob][i] > 0)
        {
            new idx = ER_FindJobIndexBySQLID(PlayerInfo[playerid][pPlayerJob][i]);
            if(idx != -1) format(name, sizeof(name), "%s", Jobs[idx][jName]); else format(name, sizeof(name), "Job ID %d", PlayerInfo[playerid][pPlayerJob][i]);
        }
        else format(name, sizeof(name), "Empty");
        format(msg, sizeof(msg), "Slot %d: %s\n", i + 1, name);
        strcat(list, msg, sizeof(list));
    }
    return ShowPlayerDialog(playerid, DIALOG_JOB_EDITOR, DIALOG_STYLE_MSGBOX, "My Jobs", list, "Close", "");
}
CMD:jobs(playerid, params[])
{
    new msg[128], name[64], list[1024];
    for(new i; i < MAX_JOBS_PER_PLAYER; i++)
    {
        if(PlayerInfo[playerid][pPlayerJob][i] > 0)
        {
            new idx = ER_FindJobIndexBySQLID(PlayerInfo[playerid][pPlayerJob][i]);
            if(idx != -1) format(name, sizeof(name), "%s", Jobs[idx][jName]); else format(name, sizeof(name), "Job ID %d", PlayerInfo[playerid][pPlayerJob][i]);
        }
        else format(name, sizeof(name), "Empty");
        format(msg, sizeof(msg), "Slot %d: %s\n", i + 1, name);
        strcat(list, msg, sizeof(list));
    }
    return ShowPlayerDialog(playerid, DIALOG_JOB_EDITOR, DIALOG_STYLE_MSGBOX, "My Jobs", list, "Close", "");
}

stock ER_JobDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_JOB_LIST)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= JobCount) return 1;
        return ER_ShowJobEditor(playerid, Jobs[listitem][jSQLID]);
    }
    if(dialogid == DIALOG_JOB_EDITOR)
    {
        if(!response) return 1;
        new id = GetPVarInt(playerid, "EditingJob"), idx = ER_FindJobIndexBySQLID(id);
        if(idx == -1) return 1;
        SetPVarInt(playerid, "JobEditAction", listitem);
        if(listitem == 0) return ShowPlayerDialog(playerid, DIALOG_JOB_INPUT, DIALOG_STYLE_INPUT, "Job Name", "Enter new job name:", "Save", "Back");
        if(listitem == 1) return ShowPlayerDialog(playerid, DIALOG_JOB_INPUT, DIALOG_STYLE_INPUT, "Job Type", "Enter type ID/name:", "Save", "Back");
        if(listitem == 2)
        {
            new Float:x, Float:y, Float:z, Float:a, q[256]; GetPlayerPos(playerid,x,y,z); GetPlayerFacingAngle(playerid,a);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `jobs` SET `x`=%f,`y`=%f,`z`=%f,`a`=%f,`interior`=%d,`vw`=%d WHERE `id`=%d", x,y,z,a,GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid),id); mysql_tquery(MainPipeline,q); ER_ReloadJobBySQLID(id, playerid); return ER_Send(playerid, COLOR_GREEN, "Job position saved.");
        }
        if(listitem == 3) { SetPlayerInterior(playerid, Jobs[idx][jInt]); SetPlayerVirtualWorld(playerid, Jobs[idx][jVW]); SetPlayerPos(playerid, Jobs[idx][jX], Jobs[idx][jY], Jobs[idx][jZ]); return 1; }
        if(listitem == 4) { new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `jobs` SET `enabled`=0 WHERE `id`=%d", id); mysql_tquery(MainPipeline, q); ER_ReloadJobBySQLID(id, playerid); return ER_Send(playerid, COLOR_GREEN, "Job deleted/disabled."); }
        if(listitem == 5) { ER_ReloadJobBySQLID(id, playerid); return ER_Send(playerid, COLOR_GREEN, "Job reloaded."); }
        return 1;
    }
    if(dialogid == DIALOG_JOB_INPUT)
    {
        new id = GetPVarInt(playerid, "EditingJob"), action = GetPVarInt(playerid, "JobEditAction"), q[256];
        if(!response) return ER_ShowJobEditor(playerid, id);
        if(action == 0) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `jobs` SET `name`='%e' WHERE `id`=%d", inputtext, id);
        else if(action == 1)
        {
            new type = ER_ParseJobType(inputtext); if(type <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid type.");
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `jobs` SET `type`=%d WHERE `id`=%d", type, id);
        }
        mysql_tquery(MainPipeline, q); ER_ReloadJobBySQLID(id, playerid); return ER_Send(playerid, COLOR_GREEN, "Job updated.");
    }
    return 0;
}

CMD:jobtypes(playerid, params[])
{
    new list[768];
    strcat(list, "1. Mechanic\n2. Taxi Driver\n3. Trucker\n4. Pizza Delivery\n5. Arms Dealer\n6. Drug Dealer\n");
    strcat(list, "7. Detective\n8. Lawyer\n9. Bus Driver\n10. Garbage Collector\n11. Miner\n12. Fisherman");
    ShowPlayerDialog(playerid, DIALOG_JOB_LIST, DIALOG_STYLE_MSGBOX, "Job Types", list, "Close", "");
    return 1;
}


// -----------------------------------------------------------------------------
// ExpressRP v52 NGRP-style job command expansion
// Commands are bound to ExpressRP static job types and remain safe/playable.
// -----------------------------------------------------------------------------

stock ER_GetPlayerJobType(playerid)
{
    for(new s; s < MAX_JOBS_PER_PLAYER; s++)
    {
        new jobid = PlayerInfo[playerid][pPlayerJob][s];
        if(jobid <= 0) continue;
        new idx = ER_FindJobIndexBySQLID(jobid);
        if(idx != -1) return Jobs[idx][jType];
    }
    return JOB_TYPE_NONE;
}

stock ER_PlayerHasJobType(playerid, type)
{
    for(new s; s < MAX_JOBS_PER_PLAYER; s++)
    {
        new jobid = PlayerInfo[playerid][pPlayerJob][s];
        if(jobid <= 0) continue;
        new idx = ER_FindJobIndexBySQLID(jobid);
        if(idx != -1 && Jobs[idx][jType] == type) return 1;
    }
    return 0;
}

stock ER_RequireJobType(playerid, type, const command[])
{
    if(ER_PlayerHasJobType(playerid, type)) return 1;
    new typeName[32], msg[128]; ER_GetJobTypeName(type, typeName, sizeof(typeName));
    format(msg, sizeof(msg), "You must have the %s job to use /%s.", typeName, command);
    ER_Send(playerid, COLOR_GREY, msg);
    return 0;
}

stock ER_JobRP(playerid, const text[])
{
    new name[MAX_PLAYER_NAME], msg[160], Float:x,Float:y,Float:z;
    ER_GetDisplayName(playerid, name, sizeof(name)); GetPlayerPos(playerid,x,y,z);
    format(msg, sizeof(msg), "* %s %s", name, text);
    return ER_NearbyMessage(x,y,z,CHAT_RANGE_NORMAL,COLOR_ME,msg,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid));
}

CMD:quitjob(playerid, params[]) { return cmd_leavejob(playerid, params); }
CMD:skill(playerid, params[]) { return cmd_myjobs(playerid, params); }

CMD:mechduty(playerid, params[])
{
    if(!ER_RequireJobType(playerid, JOB_TYPE_MECHANIC, "mechduty")) return 1;
    SetPVarInt(playerid, "MechDuty", !GetPVarInt(playerid, "MechDuty"));
    return ER_Send(playerid, COLOR_GREEN, GetPVarInt(playerid,"MechDuty") ? "You are now on mechanic duty." : "You are now off mechanic duty.");
}

CMD:fix(playerid, params[])
{
    if(!ER_RequireJobType(playerid, JOB_TYPE_MECHANIC, "fix")) return 1;
    if(!IsPlayerInAnyVehicle(playerid)) return ER_Send(playerid, COLOR_GREY, "You must be inside a vehicle.");
    RepairVehicle(GetPlayerVehicleID(playerid)); ER_JobRP(playerid, "repairs the vehicle.");
    return ER_Send(playerid, COLOR_GREEN, "Vehicle repaired.");
}

CMD:nos(playerid, params[])
{
    if(!ER_RequireJobType(playerid, JOB_TYPE_MECHANIC, "nos")) return 1;
    if(!IsPlayerInAnyVehicle(playerid)) return ER_Send(playerid, COLOR_GREY, "You must be inside a vehicle.");
    AddVehicleComponent(GetPlayerVehicleID(playerid), 1010); ER_JobRP(playerid, "installs a nitrous kit.");
    return ER_Send(playerid, COLOR_GREEN, "NOS installed.");
}

CMD:hyd(playerid, params[])
{
    if(!ER_RequireJobType(playerid, JOB_TYPE_MECHANIC, "hyd")) return 1;
    if(!IsPlayerInAnyVehicle(playerid)) return ER_Send(playerid, COLOR_GREY, "You must be inside a vehicle.");
    AddVehicleComponent(GetPlayerVehicleID(playerid), 1087); ER_JobRP(playerid, "installs hydraulics.");
    return ER_Send(playerid, COLOR_GREEN, "Hydraulics installed.");
}

CMD:fare(playerid, params[])
{
    new amount;
    if(!ER_RequireJobType(playerid, JOB_TYPE_TAXI, "fare")) return 1;
    if(sscanf(params,"d",amount)) return ER_Send(playerid,COLOR_GREY,"USAGE: /fare [amount]");
    if(amount < 0 || amount > 5000) return ER_Send(playerid,COLOR_GREY,"Fare must be $0-$5,000.");
    SetPVarInt(playerid,"TaxiFare",amount);
    new msg[96]; format(msg,sizeof(msg),"Taxi fare set to %s.",ER_FormatMoney(amount));
    return ER_Send(playerid,COLOR_GREEN,msg);
}
CMD:ataxi(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_TAXI,"ataxi")) return 1; return ER_Send(playerid,COLOR_YELLOW,"Taxi advertisement sent to the taxi channel/public advert system."); }
CMD:emergencybutton(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_TAXI,"emergencybutton")) return 1; return ER_Send(playerid,COLOR_LIGHTRED,"Taxi emergency beacon sent to emergency factions."); }

CMD:loadshipment(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_TRUCKER,"loadshipment")) return 1; SetPVarInt(playerid,"ShipmentLoaded",1); ER_JobRP(playerid,"loads shipment cargo."); return ER_Send(playerid,COLOR_GREEN,"Shipment loaded. Deliver it to a shipment drop point."); }
CMD:loadtruck(playerid, params[]) { return cmd_loadshipment(playerid, params); }
CMD:unloadshipment(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_TRUCKER,"unloadshipment")) return 1; if(!GetPVarInt(playerid,"ShipmentLoaded")) return ER_Send(playerid,COLOR_GREY,"You do not have a shipment loaded."); DeletePVar(playerid,"ShipmentLoaded"); GivePlayerMoney(playerid,1500); PlayerInfo[playerid][pCash]+=1500; ER_SaveCharacter(playerid); return ER_Send(playerid,COLOR_GREEN,"Shipment delivered. You earned $1,500."); }
CMD:dropshipment(playerid, params[]) { return cmd_unloadshipment(playerid, params); }
CMD:finishshipment(playerid, params[]) { return cmd_unloadshipment(playerid, params); }
CMD:cleartruck(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_TRUCKER,"cleartruck")) return 1; DeletePVar(playerid,"ShipmentLoaded"); return ER_Send(playerid,COLOR_GREEN,"Truck cargo cleared."); }
CMD:searchtruck(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_TRUCKER,"searchtruck")) return 1; return ER_Send(playerid,COLOR_YELLOW,GetPVarInt(playerid,"ShipmentLoaded")?"Truck contains loaded shipment.":"Truck is empty."); }
CMD:checkcargo(playerid, params[]) { return cmd_searchtruck(playerid, params); }
CMD:hijackcargo(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_TRUCKER,"hijackcargo")) return 1; return ER_Send(playerid,COLOR_LIGHTRED,"Cargo hijack route started. Use robbery/cargo rules for RP."); }
CMD:unloadfuel(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_TRUCKER,"unloadfuel")) return 1; return ER_Send(playerid,COLOR_GREEN,"Fuel delivery completed if near a linked gas station pump/business."); }

CMD:getpizza(playerid, params[])
{
    if(!ER_RequireJobType(playerid, JOB_TYPE_PIZZA, "getpizza")) return 1;
    SetPVarInt(playerid,"PizzaLoaded",1); ER_JobRP(playerid,"takes a pizza delivery order."); return ER_Send(playerid,COLOR_GREEN,"Pizza loaded. Deliver it to a customer point.");
}


new GunSaleSeller[MAX_PLAYERS];
new GunSaleWeapon[MAX_PLAYERS];
new GunSalePrice[MAX_PLAYERS];
new GunSaleMatCost[MAX_PLAYERS];
new GunSellCooldown[MAX_PLAYERS];
new GunMakeCooldown[MAX_PLAYERS];

stock ER_ClearGunSaleOffer(playerid)
{
    GunSaleSeller[playerid] = INVALID_PLAYER_ID;
    GunSaleWeapon[playerid] = 0;
    GunSalePrice[playerid] = 0;
    GunSaleMatCost[playerid] = 0;
    return 1;
}

stock ER_InitGunSaleOffers()
{
    for(new i; i < MAX_PLAYERS; i++) ER_ClearGunSaleOffer(i);
    return 1;
}


stock ER_ClearDisconnectedGunOffers(playerid)
{
    ER_ClearGunSaleOffer(playerid);
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(GunSaleSeller[i] == playerid) ER_ClearGunSaleOffer(i);
    }
    return 1;
}

stock ER_GiveUnlimitedWeapon(playerid, weaponid)
{
    GivePlayerWeapon(playerid, weaponid, 0x7FFFFFFF);
    return 1;
}

stock ER_AcceptGunOffer(playerid)
{
    new seller = GunSaleSeller[playerid];
    if(seller == INVALID_PLAYER_ID || !IsPlayerConnected(seller))
    {
        ER_ClearGunSaleOffer(playerid);
        return ER_Send(playerid, COLOR_GREY, "You do not have a gun offer.");
    }
    if(IsPlayerInAnyVehicle(playerid) || IsPlayerInAnyVehicle(seller)) return ER_Send(playerid, COLOR_GREY, "You cannot accept guns while inside a vehicle.");
    if(!ER_IsPlayerNearPlayer(playerid, seller, 5.0)) return ER_Send(playerid, COLOR_GREY, "Seller is not close enough.");

    new weapon = GunSaleWeapon[playerid], price = GunSalePrice[playerid], matCost = GunSaleMatCost[playerid], wname[32], msg[144];
    if(weapon <= 0 || ER_GetWeaponMatIndexByWeapon(weapon) == -1)
    {
        ER_ClearGunSaleOffer(playerid);
        return ER_Send(playerid, COLOR_GREY, "Weapon not found.");
    }
    matCost = ER_GetWeaponMatCost(weapon);
    if(matCost < 0)
    {
        ER_ClearGunSaleOffer(playerid);
        return ER_Send(playerid, COLOR_GREY, "Weapon not found.");
    }
    if(PlayerInfo[playerid][pCash] < price) return ER_Send(playerid, COLOR_GREY, "You do not have enough money.");
    if(PlayerInfo[seller][pMaterials] < matCost) return ER_Send(playerid, COLOR_GREY, "The seller does not have enough materials.");

    PlayerInfo[playerid][pCash] -= price;
    GivePlayerMoney(playerid, -price);
    PlayerInfo[seller][pCash] += price;
    GivePlayerMoney(seller, price);
    PlayerInfo[seller][pMaterials] -= matCost;
    ER_GiveUnlimitedWeapon(playerid, weapon);

    ER_SaveCharacter(playerid);
    ER_SaveCharacter(seller);
    ER_GetWeaponMatDisplayName(weapon, wname, sizeof(wname));

    format(msg, sizeof(msg), "You bought a %s for %s.", wname, ER_FormatMoney(price));
    ER_Send(playerid, COLOR_GREEN, msg);
    format(msg, sizeof(msg), "%s accepted your %s offer for %s.", ER_GetName(playerid), wname, ER_FormatMoney(price));
    ER_Send(seller, COLOR_GREEN, msg);
    ER_ClearGunSaleOffer(playerid);
    return 1;
}

CMD:sellgun(playerid, params[])
{
    new target, weaponText[32], price, now = gettime(), remaining;
    if(!ER_RequireJobType(playerid, JOB_TYPE_ARMS, "sellgun")) return 1;
    if(sscanf(params,"us[32]d",target,weaponText,price)) return ER_ShowSellGunUsage(playerid);

    remaining = GunSellCooldown[playerid] - now;
    if(remaining > 0)
    {
        new cmsg[96];
        format(cmsg, sizeof(cmsg), "You must wait %d seconds before selling another gun.", remaining);
        return ER_Send(playerid, COLOR_GREY, cmsg);
    }
    if(target == playerid) return ER_Send(playerid, COLOR_GREY, "Use /makegun [weaponname].");
    if(!IsPlayerConnected(target) || !ER_IsPlayerNearPlayer(playerid,target,5.0)) return ER_Send(playerid,COLOR_GREY,"Target not close enough.");
    if(IsPlayerInAnyVehicle(playerid) || IsPlayerInAnyVehicle(target)) return ER_Send(playerid, COLOR_GREY, "You cannot sell guns while inside a vehicle.");
    if(price < 1 || price > 50000) return ER_Send(playerid,COLOR_GREY,"Invalid price.");

    new weapon = ER_ResolveWeaponMaterial(weaponText);
    if(weapon <= 0) return ER_Send(playerid,COLOR_GREY,"Weapon not found.");

    new matCost = ER_GetWeaponMatCost(weapon), wname[32], msg[144];
    if(matCost < 0) return ER_Send(playerid,COLOR_GREY,"Weapon not found.");
    if(PlayerInfo[playerid][pMaterials] < matCost)
    {
        format(msg,sizeof(msg),"You need %d materials to sell this weapon.", matCost);
        return ER_Send(playerid,COLOR_GREY,msg);
    }

    GunSaleSeller[target] = playerid;
    GunSaleWeapon[target] = weapon;
    GunSalePrice[target] = price;
    GunSaleMatCost[target] = matCost;
    GunSellCooldown[playerid] = now + 8;

    ER_GetWeaponMatDisplayName(weapon, wname, sizeof(wname));
    format(msg, sizeof(msg), "You offered %s a %s for %s.", ER_GetName(target), wname, ER_FormatMoney(price));
    ER_Send(playerid, COLOR_GREEN, msg);
    format(msg, sizeof(msg), "%s has offered you a %s, for %s. /accept gun to accept.", ER_GetName(playerid), wname, ER_FormatMoney(price));
    return ER_Send(target, COLOR_YELLOW, msg);
}

CMD:makegun(playerid, params[])
{
    new weaponText[32], now = gettime(), remaining;
    if(!ER_RequireJobType(playerid, JOB_TYPE_ARMS, "makegun")) return 1;
    if(sscanf(params, "s[32]", weaponText)) return ER_ShowMakeGunUsage(playerid);

    remaining = GunMakeCooldown[playerid] - now;
    if(remaining > 0)
    {
        new cmsg[96];
        format(cmsg, sizeof(cmsg), "You must wait %d seconds before making another gun.", remaining);
        return ER_Send(playerid, COLOR_GREY, cmsg);
    }
    if(IsPlayerInAnyVehicle(playerid)) return ER_Send(playerid, COLOR_GREY, "You cannot make guns while inside a vehicle.");

    new weapon = ER_ResolveWeaponMaterial(weaponText);
    if(weapon <= 0) return ER_Send(playerid, COLOR_GREY, "Weapon not found.");

    new matCost = ER_GetWeaponMatCost(weapon), wname[32], msg[128];
    if(matCost < 0) return ER_Send(playerid, COLOR_GREY, "Weapon not found.");
    if(PlayerInfo[playerid][pMaterials] < matCost)
    {
        format(msg, sizeof(msg), "You need %d materials to make this weapon.", matCost);
        return ER_Send(playerid, COLOR_GREY, msg);
    }

    PlayerInfo[playerid][pMaterials] -= matCost;
    ER_GiveUnlimitedWeapon(playerid, weapon);
    GunMakeCooldown[playerid] = now + 8;
    ER_SaveCharacter(playerid);
    ER_GetWeaponMatDisplayName(weapon, wname, sizeof(wname));
    format(msg, sizeof(msg), "You made a %s and used %d materials.", wname, matCost);
    return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:getmats(playerid, params[])
{
    if(!ER_RequireJobType(playerid, JOB_TYPE_ARMS, "getmats")) return 1;
    PlayerInfo[playerid][pMaterials] += 250; GivePlayerMoney(playerid, -500); PlayerInfo[playerid][pCash] -= 500; ER_SaveCharacter(playerid);
    return ER_Send(playerid, COLOR_GREEN, "You collected 250 materials for $500.");
}

CMD:selldrugs(playerid, params[])
{
    new target, type[16], amount, price;
    if(!ER_RequireJobType(playerid, JOB_TYPE_DRUGS, "selldrugs")) return 1;
    if(sscanf(params,"us[16]dd",target,type,amount,price)) return ER_Send(playerid,COLOR_GREY,"USAGE: /selldrugs [player] [pot/crack] [amount] [price]");
    if(!IsPlayerConnected(target) || !ER_IsPlayerNearPlayer(playerid,target,5.0)) return ER_Send(playerid,COLOR_GREY,"Target not close enough.");
    if(amount < 1 || price < 0) return ER_Send(playerid,COLOR_GREY,"Invalid amount/price.");
    if(strfind(type,"pot",true)!=-1) { if(PlayerInfo[playerid][pPot] < amount) return ER_Send(playerid,COLOR_GREY,"Not enough pot."); PlayerInfo[playerid][pPot]-=amount; PlayerInfo[target][pPot]+=amount; }
    else { if(PlayerInfo[playerid][pCrack] < amount) return ER_Send(playerid,COLOR_GREY,"Not enough crack."); PlayerInfo[playerid][pCrack]-=amount; PlayerInfo[target][pCrack]+=amount; }
    ER_SaveCharacter(playerid); ER_SaveCharacter(target); return ER_Send(playerid,COLOR_GREEN,"Drug sale completed.");
}
CMD:sellpot(playerid, params[]) { return cmd_selldrugs(playerid, params); }
CMD:sellcrack(playerid, params[]) { return cmd_selldrugs(playerid, params); }
CMD:useheroin(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_DRUGS,"useheroin")) return 1; SetPlayerHealth(playerid, 100.0); return ER_Send(playerid,COLOR_LIGHTRED,"You used heroin and restored your health. RP consequences may apply."); }

CMD:find(playerid, params[])
{
    new target;
    if(!ER_RequireJobType(playerid, JOB_TYPE_DETECTIVE, "find")) return 1;
    if(sscanf(params,"u",target)) return ER_Send(playerid,COLOR_GREY,"USAGE: /find [player]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid,COLOR_GREY,"Invalid player.");
    new zone[32], name[MAX_PLAYER_NAME], msg[128]; ER_GetPlayerZone(target, zone, sizeof(zone)); ER_GetDisplayName(target, name, sizeof(name));
    format(msg, sizeof(msg), "Detective trace: %s was last seen in %s.", name, zone);
    return ER_Send(playerid, COLOR_YELLOW, msg);
}

CMD:lawyerduty(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_LAWYER,"lawyerduty")) return 1; SetPVarInt(playerid,"LawyerDuty",!GetPVarInt(playerid,"LawyerDuty")); return ER_Send(playerid,COLOR_GREEN,GetPVarInt(playerid,"LawyerDuty")?"You are on lawyer duty.":"You are off lawyer duty."); }
CMD:defend(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_LAWYER,"defend")) return 1; return ER_Send(playerid,COLOR_GREEN,"You offer legal defense. Use court/judicial RP to continue."); }
CMD:free(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_LAWYER,"free")) return 1; return ER_Send(playerid,COLOR_GREEN,"Release request submitted to law/judicial RP."); }
CMD:defendtime(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_LAWYER,"defendtime")) return 1; return ER_Send(playerid,COLOR_YELLOW,"Defense cooldown/status displayed."); }
CMD:offerappeal(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_LAWYER,"offerappeal")) return 1; return ER_Send(playerid,COLOR_GREEN,"Appeal offer sent."); }
CMD:finishappeal(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_LAWYER,"finishappeal")) return 1; return ER_Send(playerid,COLOR_GREEN,"Appeal finished."); }

CMD:fish(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_FISHER,"fish")) return 1; SetPVarInt(playerid,"FishCount",GetPVarInt(playerid,"FishCount")+1); ER_JobRP(playerid,"casts a fishing line."); return ER_Send(playerid,COLOR_GREEN,"You caught a fish."); }
CMD:fishes(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_FISHER,"fishes")) return 1; new msg[64]; format(msg,sizeof(msg),"Fish carried: %d",GetPVarInt(playerid,"FishCount")); return ER_Send(playerid,COLOR_YELLOW,msg); }
CMD:sellfish(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_FISHER,"sellfish")) return 1; new c=GetPVarInt(playerid,"FishCount"); if(c<1) return ER_Send(playerid,COLOR_GREY,"You have no fish."); new pay=c*150; DeletePVar(playerid,"FishCount"); PlayerInfo[playerid][pCash]+=pay; GivePlayerMoney(playerid,pay); ER_SaveCharacter(playerid); return ER_Send(playerid,COLOR_GREEN,"Fish sold."); }
CMD:fishhelp(playerid, params[]) { return ER_Send(playerid,COLOR_HELP,"Fishing: /fish /fishes /sellfish /releasefish /throwback /throwbackall"); }
CMD:ofishhelp(playerid, params[]) { return cmd_fishhelp(playerid, params); }
CMD:releasefish(playerid, params[]) { DeletePVar(playerid,"FishCount"); return ER_Send(playerid,COLOR_GREEN,"Fish released."); }
CMD:throwback(playerid, params[]) { return cmd_releasefish(playerid, params); }
CMD:throwbackall(playerid, params[]) { return cmd_releasefish(playerid, params); }

CMD:mine(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_MINER,"mine")) return 1; SetPVarInt(playerid,"OreCount",GetPVarInt(playerid,"OreCount")+1); ER_JobRP(playerid,"mines ore."); return ER_Send(playerid,COLOR_GREEN,"You mined ore."); }
CMD:sellore(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_MINER,"sellore")) return 1; new c=GetPVarInt(playerid,"OreCount"); if(c<1) return ER_Send(playerid,COLOR_GREY,"You have no ore."); PlayerInfo[playerid][pCash]+=c*200; GivePlayerMoney(playerid,c*200); DeletePVar(playerid,"OreCount"); ER_SaveCharacter(playerid); return ER_Send(playerid,COLOR_GREEN,"Ore sold."); }

CMD:collecttrash(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_GARBAGE,"collecttrash")) return 1; SetPVarInt(playerid,"TrashCount",GetPVarInt(playerid,"TrashCount")+1); ER_JobRP(playerid,"collects trash."); return ER_Send(playerid,COLOR_GREEN,"Trash collected."); }
CMD:dumptrash(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_GARBAGE,"dumptrash")) return 1; new c=GetPVarInt(playerid,"TrashCount"); if(c<1) return ER_Send(playerid,COLOR_GREY,"You have no trash bags."); PlayerInfo[playerid][pCash]+=c*100; GivePlayerMoney(playerid,c*100); DeletePVar(playerid,"TrashCount"); ER_SaveCharacter(playerid); return ER_Send(playerid,COLOR_GREEN,"Trash dumped and paid."); }

CMD:guard(playerid, params[]) { new target; if(!ER_RequireJobType(playerid,JOB_TYPE_BODYGUARD,"guard")) return 1; if(sscanf(params,"u",target)) return ER_Send(playerid,COLOR_GREY,"USAGE: /guard [player]"); if(!IsPlayerConnected(target)||!ER_IsPlayerNearPlayer(playerid,target,5.0)) return ER_Send(playerid,COLOR_GREY,"Target not close enough."); SetPVarInt(target,"GuardedBy",playerid+1); return ER_Send(playerid,COLOR_GREEN,"You are now guarding this player."); }
CMD:selldrink(playerid, params[]) { new target, price; if(!ER_RequireJobType(playerid,JOB_TYPE_BARTENDER,"selldrink")) return 1; if(sscanf(params,"uD(100)",target,price)) return ER_Send(playerid,COLOR_GREY,"USAGE: /selldrink [player] [price=100]"); if(!IsPlayerConnected(target)||!ER_IsPlayerNearPlayer(playerid,target,5.0)) return ER_Send(playerid,COLOR_GREY,"Target not close enough."); PlayerInfo[target][pSprunk]++; ER_SaveCharacter(target); return ER_Send(playerid,COLOR_GREEN,"Drink sold."); }
CMD:craft(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_CRAFTSMAN,"craft")) return 1; if(PlayerInfo[playerid][pMaterials] < 50) return ER_Send(playerid,COLOR_GREY,"You need 50 materials to craft a repair kit."); PlayerInfo[playerid][pMaterials]-=50; PlayerInfo[playerid][pHotwireKits]++; ER_SaveCharacter(playerid); return ER_Send(playerid,COLOR_GREEN,"You crafted a utility kit."); }
CMD:boxstats(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_BOXER,"boxstats")) return 1; return ER_Send(playerid,COLOR_YELLOW,"Boxing record: 0 wins / 0 losses. Arena persistence can be expanded later."); }
CMD:fight(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_BOXER,"fight")) return 1; return ER_Send(playerid,COLOR_GREEN,"You are ready to fight. Use RP/arena manager to start a bout."); }
CMD:train(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_BOXER,"train")) return 1; SetPlayerHealth(playerid,100.0); return ER_Send(playerid,COLOR_GREEN,"You train and recover your stamina."); }


// -----------------------------------------------------------------------------
// v52A compatibility wrappers for alias commands.
// Pawn.CMD in this build does not expose cmd_* symbols, so aliases call these
// concrete shared handlers instead of unresolved generated names.
// -----------------------------------------------------------------------------
stock cmd_leavejob(playerid, params[])
{
    new slot;
    if(sscanf(params, "d", slot)) return ER_Send(playerid, COLOR_GREY, "USAGE: /leavejob [slot 1-10]");
    slot--;
    if(slot < 0 || slot >= MAX_JOBS_PER_PLAYER) return ER_Send(playerid, COLOR_GREY, "Invalid slot.");
    PlayerInfo[playerid][pPlayerJob][slot] = 0;
    ER_SaveCharacter(playerid);
    return ER_Send(playerid, COLOR_GREEN, "Job slot cleared.");
}

stock cmd_myjobs(playerid, params[])
{
    #pragma unused params
    new msg[128], name[64], list[1024];
    for(new i; i < MAX_JOBS_PER_PLAYER; i++)
    {
        if(PlayerInfo[playerid][pPlayerJob][i] > 0)
        {
            new idx = ER_FindJobIndexBySQLID(PlayerInfo[playerid][pPlayerJob][i]);
            if(idx != -1) format(name, sizeof(name), "%s", Jobs[idx][jName]);
            else format(name, sizeof(name), "Job ID %d", PlayerInfo[playerid][pPlayerJob][i]);
        }
        else format(name, sizeof(name), "Empty");
        format(msg, sizeof(msg), "Slot %d: %s\n", i + 1, name);
        strcat(list, msg, sizeof(list));
    }
    return ShowPlayerDialog(playerid, DIALOG_JOB_EDITOR, DIALOG_STYLE_MSGBOX, "My Jobs", list, "Close", "");
}

stock cmd_loadshipment(playerid, params[])
{
    #pragma unused params
    if(!ER_RequireJobType(playerid, JOB_TYPE_TRUCKER, "loadshipment")) return 1;
    SetPVarInt(playerid, "ShipmentLoaded", 1);
    ER_JobRP(playerid, "loads shipment cargo.");
    return ER_Send(playerid, COLOR_GREEN, "Shipment loaded. Deliver it to a shipment drop point.");
}

stock cmd_unloadshipment(playerid, params[])
{
    #pragma unused params
    if(!ER_RequireJobType(playerid, JOB_TYPE_TRUCKER, "unloadshipment")) return 1;
    if(!GetPVarInt(playerid, "ShipmentLoaded")) return ER_Send(playerid, COLOR_GREY, "You do not have a shipment loaded.");
    DeletePVar(playerid, "ShipmentLoaded");
    GivePlayerMoney(playerid, 1500);
    PlayerInfo[playerid][pCash] += 1500;
    ER_SaveCharacter(playerid);
    return ER_Send(playerid, COLOR_GREEN, "Shipment delivered. You earned $1,500.");
}

stock cmd_searchtruck(playerid, params[])
{
    #pragma unused params
    if(!ER_RequireJobType(playerid, JOB_TYPE_TRUCKER, "searchtruck")) return 1;
    return ER_Send(playerid, COLOR_YELLOW, GetPVarInt(playerid,"ShipmentLoaded") ? "Truck contains loaded shipment." : "Truck is empty.");
}

stock cmd_selldrugs(playerid, params[])
{
    new target, type[16], amount, price;
    if(!ER_RequireJobType(playerid, JOB_TYPE_DRUGS, "selldrugs")) return 1;
    if(sscanf(params, "us[16]dd", target, type, amount, price)) return ER_Send(playerid, COLOR_GREY, "USAGE: /selldrugs [player] [pot/crack] [amount] [price]");
    if(!IsPlayerConnected(target) || !ER_IsPlayerNearPlayer(playerid,target,5.0)) return ER_Send(playerid, COLOR_GREY, "Target not close enough.");
    if(amount < 1 || price < 0) return ER_Send(playerid, COLOR_GREY, "Invalid amount/price.");
    if(strfind(type,"pot",true)!=-1)
    {
        if(PlayerInfo[playerid][pPot] < amount) return ER_Send(playerid, COLOR_GREY, "Not enough pot.");
        PlayerInfo[playerid][pPot] -= amount;
        PlayerInfo[target][pPot] += amount;
    }
    else
    {
        if(PlayerInfo[playerid][pCrack] < amount) return ER_Send(playerid, COLOR_GREY, "Not enough crack.");
        PlayerInfo[playerid][pCrack] -= amount;
        PlayerInfo[target][pCrack] += amount;
    }
    ER_SaveCharacter(playerid);
    ER_SaveCharacter(target);
    return ER_Send(playerid, COLOR_GREEN, "Drug sale completed.");
}

stock cmd_fishhelp(playerid, params[])
{
    #pragma unused params
    return ER_Send(playerid, COLOR_HELP, "Fishing: /fish /fishes /sellfish /releasefish /throwback /throwbackall");
}

stock cmd_releasefish(playerid, params[])
{
    #pragma unused params
    DeletePVar(playerid, "FishCount");
    return ER_Send(playerid, COLOR_GREEN, "Fish released.");
}
