#if defined _ER_JOBS_INCLUDED
    #endinput
#endif
#define _ER_JOBS_INCLUDED

// ExpressRP static/dynamic hybrid job type IDs.
// Players join and save the JOB TYPE, not the created job pickup SQL ID.
#define JOB_TYPE_NONE          0
#define JOB_TYPE_ARMS          1
#define JOB_TYPE_CRAFTSMAN     2
#define JOB_TYPE_TRUCKER       3
#define JOB_TYPE_MECHANIC      4
#define JOB_TYPE_TAXI          5
#define JOB_TYPE_GARBAGE       6
#define JOB_TYPE_LAWYER        7
#define JOB_TYPE_DETECTIVE     8
#define JOB_TYPE_DRUG_DEALER   9
#define JOB_TYPE_DRUG_SMUGGLER 10
#define JOB_TYPE_PIZZA         11
#if !defined MAX_EXPRESS_JOB_TYPES
    #define MAX_EXPRESS_JOB_TYPES 12
#endif

// Backward compatibility aliases for older placeholder commands.
#define JOB_TYPE_DRUGS         JOB_TYPE_DRUG_DEALER
#define JOB_TYPE_BUS           0
#define JOB_TYPE_MINER         0
#define JOB_TYPE_FISHER        0
#define JOB_TYPE_BODYGUARD     0
#define JOB_TYPE_BARTENDER     0
#define JOB_TYPE_BOXER         0

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
        case JOB_TYPE_ARMS: format(dest, size, "Arms Dealer");
        case JOB_TYPE_CRAFTSMAN: format(dest, size, "Craftsman");
        case JOB_TYPE_TRUCKER: format(dest, size, "Trucker");
        case JOB_TYPE_MECHANIC: format(dest, size, "Mechanic");
        case JOB_TYPE_TAXI: format(dest, size, "Taxi Driver");
        case JOB_TYPE_GARBAGE: format(dest, size, "Garbage Man");
        case JOB_TYPE_LAWYER: format(dest, size, "Lawyer");
        case JOB_TYPE_DETECTIVE: format(dest, size, "Detective");
        case JOB_TYPE_DRUG_DEALER: format(dest, size, "Drug Dealer");
        case JOB_TYPE_DRUG_SMUGGLER: format(dest, size, "Drug Smuggler");
        case JOB_TYPE_PIZZA: format(dest, size, "Pizza Boy");
        default: format(dest, size, "None");
    }
    return 1;
}

stock ER_ParseJobType(const src[])
{
    if(isnull(src)) return 0;
    if(src[0] >= '0' && src[0] <= '9') return strval(src);
    if(strfind("arms", src, true) != -1 || strfind("gun", src, true) != -1) return JOB_TYPE_ARMS;
    if(strfind("craft", src, true) != -1) return JOB_TYPE_CRAFTSMAN;
    if(strfind("truck", src, true) != -1 || strfind("ship", src, true) != -1) return JOB_TYPE_TRUCKER;
    if(strfind("mech", src, true) != -1) return JOB_TYPE_MECHANIC;
    if(strfind("taxi", src, true) != -1) return JOB_TYPE_TAXI;
    if(strfind("garbage", src, true) != -1 || strfind("trash", src, true) != -1) return JOB_TYPE_GARBAGE;
    if(strfind("law", src, true) != -1) return JOB_TYPE_LAWYER;
    if(strfind("detect", src, true) != -1) return JOB_TYPE_DETECTIVE;
    if(strfind("smug", src, true) != -1) return JOB_TYPE_DRUG_SMUGGLER;
    if(strfind("drug", src, true) != -1 || strfind("pot", src, true) != -1) return JOB_TYPE_DRUG_DEALER;
    if(strfind("pizza", src, true) != -1) return JOB_TYPE_PIZZA;
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

stock ER_PlayerHasJob(playerid, jobtype)
{
    for(new i; i < MAX_JOBS_PER_PLAYER; i++) if(PlayerInfo[playerid][pPlayerJob][i] == jobtype) return 1;
    return 0;
}

stock ER_AddPlayerJob(playerid, jobtype)
{
    if(jobtype <= JOB_TYPE_NONE) return 0;
    if(ER_PlayerHasJob(playerid, jobtype)) return 0;
    for(new i; i < MAX_JOBS_PER_PLAYER; i++)
    {
        if(PlayerInfo[playerid][pPlayerJob][i] == 0)
        {
            PlayerInfo[playerid][pPlayerJob][i] = jobtype;
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
    new typeName[32], msg[128];
    ER_GetJobTypeName(Jobs[idx][jType], typeName, sizeof(typeName));
    if(ER_AddPlayerJob(playerid, Jobs[idx][jType]))
    {
        format(msg, sizeof(msg), "You joined the %s job type.", typeName);
        return ER_Send(playerid, COLOR_GREEN, msg);
    }
    return ER_Send(playerid, COLOR_GREY, "You already have this job type or your job slots are full.");
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
            ER_GetJobTypeName(PlayerInfo[playerid][pPlayerJob][i], name, sizeof(name));
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
            ER_GetJobTypeName(PlayerInfo[playerid][pPlayerJob][i], name, sizeof(name));
        }
        else format(name, sizeof(name), "Empty");
        format(msg, sizeof(msg), "Slot %d: %s\n", i + 1, name);
        strcat(list, msg, sizeof(list));
    }
    return ShowPlayerDialog(playerid, DIALOG_JOB_EDITOR, DIALOG_STYLE_MSGBOX, "My Jobs", list, "Close", "");
}

stock ER_JobDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_SKILLS) return 1;
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
    if(dialogid == DIALOG_JOBTYPE_LIST)
    {
        if(!response) return 1;
        new jt = listitem + 1;
        if(jt <= 0 || jt >= MAX_EXPRESS_JOB_TYPES) return 1;
        return ER_ShowJobTypeEditor(playerid, jt);
    }
    if(dialogid == DIALOG_JOBTYPE_EDITOR)
    {
        if(!response) return 1;
        new jt = GetPVarInt(playerid, "EditingJobType"), field = 0, q[256];

        switch(listitem)
        {
            case 0: field = 1; // name
            case 1:
            {
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_types` SET `enabled`=IF(`enabled`=1,0,1) WHERE `id`=%d", jt);
                mysql_tquery(MainPipeline, q);
                ER_Send(playerid, COLOR_GREEN, "Job type enabled state toggled.");
                return ER_ShowJobTypeEditor(playerid, jt);
            }
            case 2: field = 2; // base pay
            case 3: field = 3; // cooldown
            case 4:
            {
                ER_Send(playerid, COLOR_YELLOW, "Level requirements are stored in job_skill_levels. Full level editor will be expanded with the job gameplay pass.");
                return ER_ShowJobTypeEditor(playerid, jt);
            }
            default:
            {
                if(jt == JOB_TYPE_MECHANIC)
                {
                    switch(listitem)
                    {
                        case 5: field = 10;
                        case 6: field = 11;
                        case 7: field = 12;
                        case 8: field = 13;
                        case 9: field = 14;
                        case 10: field = 15;
                    }
                }
                else if(jt == JOB_TYPE_TAXI)
                {
                    switch(listitem)
                    {
                        case 5: field = 20;
                        case 6: field = 21;
                        case 7: field = 22;
                        case 8: field = 23;
                        case 9: field = 24;
                    }
                }
                else if(jt == JOB_TYPE_CRAFTSMAN)
                {
                    switch(listitem)
                    {
                        case 5: field = 30;
                        case 6: field = 31;
                        case 7: field = 32;
                        case 8:
                        {
                            ER_Send(playerid, COLOR_YELLOW, "Shared material run editor is planned for the next Arms/Crafts gameplay pass.");
                            return ER_ShowJobTypeEditor(playerid, jt);
                        }
                    }
                }
                else if(jt == JOB_TYPE_ARMS && listitem == 5)
                {
                    ER_Send(playerid, COLOR_YELLOW, "Weapon unlock editor is planned with the Arms Dealer gameplay pass.");
                    return ER_ShowJobTypeEditor(playerid, jt);
                }
                else
                {
                    ER_Send(playerid, COLOR_YELLOW, "This job setting will be editable in its gameplay pass.");
                    return ER_ShowJobTypeEditor(playerid, jt);
                }
            }
        }

        if(field <= 0)
        {
            ER_Send(playerid, COLOR_YELLOW, "This setting is not editable yet.");
            return ER_ShowJobTypeEditor(playerid, jt);
        }
        SetPVarInt(playerid, "JobTypeEditField", field);
        return ER_ShowJobTypeInput(playerid, jt, field);
    }
    if(dialogid == DIALOG_JOBTYPE_INPUT)
    {
        new jt = GetPVarInt(playerid, "EditingJobType"), field = GetPVarInt(playerid, "JobTypeEditField"), q[256], value;
        if(!response) return ER_ShowJobTypeEditor(playerid, jt);

        if(field == 1)
        {
            if(strlen(inputtext) < 2 || strlen(inputtext) > 31) return ER_Send(playerid, COLOR_GREY, "Name must be 2-31 characters.");
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_types` SET `name`='%e' WHERE `id`=%d", inputtext, jt);
        }
        else
        {
            value = strval(inputtext);
            if(value < 0) return ER_Send(playerid, COLOR_GREY, "Value cannot be negative.");

            switch(field)
            {
                case 2: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_types` SET `base_pay`=%d WHERE `id`=%d", value, jt);
                case 3: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_types` SET `cooldown`=%d WHERE `id`=%d", value, jt);
                case 10: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_mechanic_settings` SET `max_repair_price`=%d WHERE `id`=1", value);
                case 11: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_mechanic_settings` SET `max_refill_price`=%d WHERE `id`=1", value);
                case 12: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_mechanic_settings` SET `max_tune_price`=%d WHERE `id`=1", value);
                case 13: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_mechanic_settings` SET `repair_cooldown`=%d WHERE `id`=1", value);
                case 14: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_mechanic_settings` SET `refill_cooldown`=%d WHERE `id`=1", value);
                case 15: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_mechanic_settings` SET `tune_cooldown`=%d WHERE `id`=1", value);
                case 20: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_taxi_settings` SET `base_fare`=%d WHERE `id`=1", value);
                case 21: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_taxi_settings` SET `fare_per_30_seconds`=%d WHERE `id`=1", value);
                case 22: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_taxi_settings` SET `fare_per_100_meters`=%d WHERE `id`=1", value);
                case 23: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_taxi_settings` SET `minimum_balance`=%d WHERE `id`=1", value);
                case 24: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_taxi_settings` SET `request_expire_seconds`=%d WHERE `id`=1", value);
                case 30: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_craft_items` SET `material_cost`=%d WHERE `id`=1", value);
                case 31: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_craft_items` SET `material_cost`=%d WHERE `id`=2", value);
                case 32: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `job_craft_items` SET `material_cost`=%d WHERE `id`=3", value);
                default: return ER_ShowJobTypeEditor(playerid, jt);
            }
        }
        mysql_tquery(MainPipeline, q);
        ER_Send(playerid, COLOR_GREEN, "Job type setting updated.");
        return ER_ShowJobTypeEditor(playerid, jt);
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
    new list[1024], line[96], name[32];
    for(new jt = 1; jt < MAX_EXPRESS_JOB_TYPES; jt++)
    {
        ER_GetJobTypeName(jt, name, sizeof(name));
        format(line, sizeof(line), "%d. %s\n", jt, name);
        strcat(list, line, sizeof(list));
    }
    ShowPlayerDialog(playerid, DIALOG_SKILLS, DIALOG_STYLE_MSGBOX, "Job Types", list, "Close", "");
    return 1;
}

CMD:editjobtype(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new typeText[32], jt;
    if(sscanf(params, "s[32]", typeText))
    {
        new list[1024], line[96], name[32];
        for(new i = 1; i < MAX_EXPRESS_JOB_TYPES; i++)
        {
            ER_GetJobTypeName(i, name, sizeof(name));
            format(line, sizeof(line), "%d - %s\n", i, name);
            strcat(list, line, sizeof(list));
        }
        return ShowPlayerDialog(playerid, DIALOG_JOBTYPE_LIST, DIALOG_STYLE_LIST, "Edit Job Type", list, "Select", "Close");
    }
    jt = ER_ParseJobType(typeText);
    if(jt <= 0 || jt >= MAX_EXPRESS_JOB_TYPES) return ER_Send(playerid, COLOR_GREY, "Invalid job type.");
    return ER_ShowJobTypeEditor(playerid, jt);
}

stock ER_ShowJobTypeEditor(playerid, jobtype)
{
    new name[32], body[1536];
    ER_GetJobTypeName(jobtype, name, sizeof(name));
    SetPVarInt(playerid, "EditingJobType", jobtype);

    format(body, sizeof(body), "Name\nEnabled / Disabled\nBase Pay\nCooldown\nLevel Requirements");

    switch(jobtype)
    {
        case JOB_TYPE_ARMS:
        {
            strcat(body, "\nWeapon Unlocks Per Level\nShared Matrun Routes\nCraft/Sell Timers\nMaterial Costs", sizeof(body));
        }
        case JOB_TYPE_CRAFTSMAN:
        {
            strcat(body, "\nRepair Kit Material Cost\nJerry Can Material Cost\nScrewdriver Material Cost\nShared Matrun Routes\nCraft Timers", sizeof(body));
        }
        case JOB_TYPE_MECHANIC:
        {
            strcat(body, "\nMax Repair Price\nMax Refill Price\nMax Tune Price\nRepair Cooldown\nRefill Cooldown\nTune Cooldown\nJerry Can Level Settings", sizeof(body));
        }
        case JOB_TYPE_TAXI:
        {
            strcat(body, "\nBase Fare\nFare Per 30 Seconds\nFare Per 100 Meters\nMinimum Balance\nRequest Expire Time", sizeof(body));
        }
        case JOB_TYPE_TRUCKER:
        {
            strcat(body, "\nLegal Cargo Types\nIllegal Cargo Types\nPickup/Dropoff Routes\nCargo Inspection Settings\nRewards", sizeof(body));
        }
        case JOB_TYPE_GARBAGE:
        {
            strcat(body, "\nGarbage Routes\nDump Location\nLoading Time\nReward Settings\nLevel Bonuses", sizeof(body));
        }
        case JOB_TYPE_LAWYER:
        {
            strcat(body, "\nFree Jail Seconds Per Level\nDefend Max Price\nCooldowns\nWanted Reduction Rules", sizeof(body));
        }
        case JOB_TYPE_DETECTIVE:
        {
            strcat(body, "\nFind Cooldown\nTracking Range\nLevel Bonuses\nPrices", sizeof(body));
        }
        case JOB_TYPE_DRUG_DEALER:
        {
            strcat(body, "\nPlant Growth Time\nYield Per Level\nMax Plants\nSeed Cost", sizeof(body));
        }
        case JOB_TYPE_DRUG_SMUGGLER:
        {
            strcat(body, "\nCrate Pickup\nCrate Dropoff\nPot/Crack Rewards\nCooldowns", sizeof(body));
        }
        case JOB_TYPE_PIZZA:
        {
            strcat(body, "\nRestaurant Links\nDelivery Timer\nHot/Warm/Cold Rewards\nTip Chance", sizeof(body));
        }
    }
    new title[64]; format(title, sizeof(title), "Job Type Editor - %s", name);
    return ShowPlayerDialog(playerid, DIALOG_JOBTYPE_EDITOR, DIALOG_STYLE_LIST, title, body, "Select", "Close");
}

stock ER_ShowJobTypeInput(playerid, jobtype, field)
{
    #pragma unused jobtype
    new title[64], body[192];
    switch(field)
    {
        case 1: format(title, sizeof(title), "Job Type Name"), format(body, sizeof(body), "Enter new job type name:");
        case 2: format(title, sizeof(title), "Base Pay"), format(body, sizeof(body), "Enter default/base pay amount:");
        case 3: format(title, sizeof(title), "Cooldown"), format(body, sizeof(body), "Enter cooldown in seconds:");
        case 10: format(title, sizeof(title), "Max Repair Price"), format(body, sizeof(body), "Enter max repair price:");
        case 11: format(title, sizeof(title), "Max Refill Price"), format(body, sizeof(body), "Enter max refill price:");
        case 12: format(title, sizeof(title), "Max Tune Price"), format(body, sizeof(body), "Enter max tune price:");
        case 13: format(title, sizeof(title), "Repair Cooldown"), format(body, sizeof(body), "Enter repair cooldown in seconds:");
        case 14: format(title, sizeof(title), "Refill Cooldown"), format(body, sizeof(body), "Enter refill cooldown in seconds:");
        case 15: format(title, sizeof(title), "Tune Cooldown"), format(body, sizeof(body), "Enter tune cooldown in seconds:");
        case 20: format(title, sizeof(title), "Taxi Base Fare"), format(body, sizeof(body), "Enter taxi base fare:");
        case 21: format(title, sizeof(title), "Taxi Fare Per 30 Seconds"), format(body, sizeof(body), "Enter fare added every 30 seconds:");
        case 22: format(title, sizeof(title), "Taxi Fare Per 100 Meters"), format(body, sizeof(body), "Enter fare added per 100 meters:");
        case 23: format(title, sizeof(title), "Taxi Minimum Balance"), format(body, sizeof(body), "Enter minimum passenger cash required:");
        case 24: format(title, sizeof(title), "Taxi Request Expire"), format(body, sizeof(body), "Enter request expire time in seconds:");
        case 30: format(title, sizeof(title), "Repair Kit Cost"), format(body, sizeof(body), "Enter material cost for Repair Kit:");
        case 31: format(title, sizeof(title), "Jerry Can Cost"), format(body, sizeof(body), "Enter material cost for Jerry Can:");
        case 32: format(title, sizeof(title), "Screwdriver Cost"), format(body, sizeof(body), "Enter material cost for Screwdriver:");
        default: format(title, sizeof(title), "Job Type Setting"), format(body, sizeof(body), "Enter value:");
    }
    return ShowPlayerDialog(playerid, DIALOG_JOBTYPE_INPUT, DIALOG_STYLE_INPUT, title, body, "Save", "Back");
}


// -----------------------------------------------------------------------------
// ExpressRP v52 NGRP-style job command expansion
// Commands are bound to ExpressRP static job types and remain safe/playable.
// -----------------------------------------------------------------------------

stock ER_GetPlayerJobType(playerid)
{
    for(new s; s < MAX_JOBS_PER_PLAYER; s++)
    {
        if(PlayerInfo[playerid][pPlayerJob][s] > JOB_TYPE_NONE) return PlayerInfo[playerid][pPlayerJob][s];
    }
    return JOB_TYPE_NONE;
}

stock ER_PlayerHasJobType(playerid, type)
{
    for(new s; s < MAX_JOBS_PER_PLAYER; s++)
    {
        if(PlayerInfo[playerid][pPlayerJob][s] == type) return 1;
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


stock ER_GetJobLevelFromSkill(skill)
{
    if(skill >= 700) return 5;
    if(skill >= 350) return 4;
    if(skill >= 150) return 3;
    if(skill >= 50) return 2;
    return 1;
}

stock ER_GetJobNextSkillRequired(level)
{
    switch(level)
    {
        case 1: return 50;
        case 2: return 150;
        case 3: return 350;
        case 4: return 700;
    }
    return 700;
}

stock ER_AddJobSkill(playerid, jobtype, amount = 1)
{
    if(jobtype <= JOB_TYPE_NONE || jobtype >= MAX_EXPRESS_JOB_TYPES) return 0;
    if(amount < 1) amount = 1;
    new oldLevel = ER_GetJobLevelFromSkill(PlayerInfo[playerid][pJobSkill][jobtype]);
    PlayerInfo[playerid][pJobSkill][jobtype] += amount;
    new newLevel = ER_GetJobLevelFromSkill(PlayerInfo[playerid][pJobSkill][jobtype]);
    if(newLevel > oldLevel)
    {
        new name[32], msg[128];
        ER_GetJobTypeName(jobtype, name, sizeof(name));
        format(msg, sizeof(msg), "Your %s skill is now level %d.", name, newLevel);
        ER_Send(playerid, COLOR_GREEN, msg);
    }
    ER_SaveCharacter(playerid);
    return 1;
}

stock cmd_skills(playerid, params[])
{
    #pragma unused params
    new list[2048], line[160], name[32], skill, level, next;
    for(new jt = 1; jt < MAX_EXPRESS_JOB_TYPES; jt++)
    {
        ER_GetJobTypeName(jt, name, sizeof(name));
        skill = PlayerInfo[playerid][pJobSkill][jt];
        level = ER_GetJobLevelFromSkill(skill);
        next = ER_GetJobNextSkillRequired(level);
        if(level >= 5) format(line, sizeof(line), "%s: Level 5 - %d skill points\n", name, skill);
        else format(line, sizeof(line), "%s: Level %d - %d/%d\n", name, level, skill, next);
        strcat(list, line, sizeof(list));
    }
    if(ServerCore[scAllowVehicleHotwire])
    {
        format(line, sizeof(line), "\nHotwire: Level %d - %d success / %d failed\n", PlayerInfo[playerid][pHotwireLevel], PlayerInfo[playerid][pHotwireSuccess], PlayerInfo[playerid][pHotwireFail]);
        strcat(list, line, sizeof(list));
    }
    return ShowPlayerDialog(playerid, DIALOG_SKILLS, DIALOG_STYLE_MSGBOX, "Skills", list, "Close", "");
}

CMD:quitjob(playerid, params[]) { return cmd_leavejob(playerid, params); }
CMD:skill(playerid, params[]) { return cmd_skills(playerid, params); }
CMD:skills(playerid, params[]) { return cmd_skills(playerid, params); }

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
    #pragma unused params
    if(!ER_RequireJobType(playerid, JOB_TYPE_TAXI, "fare")) return 1;
    SetPVarInt(playerid, "TaxiDuty", !GetPVarInt(playerid, "TaxiDuty"));
    return ER_Send(playerid, COLOR_GREEN, GetPVarInt(playerid, "TaxiDuty") ? "You are now on taxi duty. Fare is calculated automatically by time and distance." : "You are now off taxi duty.");
}
CMD:ataxi(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_TAXI,"ataxi")) return 1; return ER_Send(playerid,COLOR_YELLOW,"Taxi advertisement sent to the taxi channel/public advert system."); }
CMD:emergencybutton(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_TAXI,"emergencybutton")) return 1; return ER_Send(playerid,COLOR_LIGHTRED,"Taxi emergency beacon sent to emergency factions."); }

CMD:loadshipment(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_TRUCKER,"loadshipment")) return 1; SetPVarInt(playerid,"ShipmentLoaded",1); ER_JobRP(playerid,"loads shipment cargo."); return ER_Send(playerid,COLOR_GREEN,"Shipment loaded. Deliver it to a shipment drop point."); }
CMD:loadtruck(playerid, params[]) { return cmd_loadshipment(playerid, params); }
CMD:unloadshipment(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_TRUCKER,"unloadshipment")) return 1; if(!GetPVarInt(playerid,"ShipmentLoaded")) return ER_Send(playerid,COLOR_GREY,"You do not have a shipment loaded."); DeletePVar(playerid,"ShipmentLoaded"); GivePlayerMoney(playerid,1500); PlayerInfo[playerid][pCash]+=1500; ER_AddJobSkill(playerid, JOB_TYPE_TRUCKER, 1); ER_SaveCharacter(playerid); return ER_Send(playerid,COLOR_GREEN,"Shipment delivered. You earned $1,500."); }
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
    ER_AddJobSkill(seller, JOB_TYPE_ARMS, 1);
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
    ER_AddJobSkill(playerid, JOB_TYPE_ARMS, 1);
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
CMD:dumptrash(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_GARBAGE,"dumptrash")) return 1; new c=GetPVarInt(playerid,"TrashCount"); if(c<1) return ER_Send(playerid,COLOR_GREY,"You have no trash bags."); PlayerInfo[playerid][pCash]+=c*100; GivePlayerMoney(playerid,c*100); DeletePVar(playerid,"TrashCount"); ER_AddJobSkill(playerid, JOB_TYPE_GARBAGE, 1); ER_SaveCharacter(playerid); return ER_Send(playerid,COLOR_GREEN,"Trash dumped and paid."); }

CMD:guard(playerid, params[]) { new target; if(!ER_RequireJobType(playerid,JOB_TYPE_BODYGUARD,"guard")) return 1; if(sscanf(params,"u",target)) return ER_Send(playerid,COLOR_GREY,"USAGE: /guard [player]"); if(!IsPlayerConnected(target)||!ER_IsPlayerNearPlayer(playerid,target,5.0)) return ER_Send(playerid,COLOR_GREY,"Target not close enough."); SetPVarInt(target,"GuardedBy",playerid+1); return ER_Send(playerid,COLOR_GREEN,"You are now guarding this player."); }
CMD:selldrink(playerid, params[]) { new target, price; if(!ER_RequireJobType(playerid,JOB_TYPE_BARTENDER,"selldrink")) return 1; if(sscanf(params,"uD(100)",target,price)) return ER_Send(playerid,COLOR_GREY,"USAGE: /selldrink [player] [price=100]"); if(!IsPlayerConnected(target)||!ER_IsPlayerNearPlayer(playerid,target,5.0)) return ER_Send(playerid,COLOR_GREY,"Target not close enough."); PlayerInfo[target][pSprunk]++; ER_SaveCharacter(target); return ER_Send(playerid,COLOR_GREEN,"Drink sold."); }
CMD:craft(playerid, params[])
{
    if(!ER_RequireJobType(playerid, JOB_TYPE_CRAFTSMAN, "craft")) return 1;
    new item[32];
    if(sscanf(params, "s[32]", item)) return ER_Send(playerid, COLOR_GREY, "USAGE: /craft [repairkit/jerrycan/screwdriver]");

    new cost, msg[128];
    if(!strcmp(item, "repairkit", true) || !strcmp(item, "repair", true))
    {
        cost = 50;
        if(PlayerInfo[playerid][pMaterials] < cost) return ER_Send(playerid, COLOR_GREY, "You need 50 materials to craft a repair kit.");
        PlayerInfo[playerid][pMaterials] -= cost;
        PlayerInfo[playerid][pRepairKits]++;
        format(msg, sizeof(msg), "You crafted a Repair Kit. Repair Kits: %d", PlayerInfo[playerid][pRepairKits]);
    }
    else if(!strcmp(item, "jerrycan", true) || !strcmp(item, "jerry", true) || !strcmp(item, "fuelcan", true))
    {
        if(PlayerInfo[playerid][pHasJerryCan]) return ER_Send(playerid, COLOR_GREY, "You already have a Jerry Can. Refill it at a gas station.");
        cost = 75;
        if(PlayerInfo[playerid][pMaterials] < cost) return ER_Send(playerid, COLOR_GREY, "You need 75 materials to craft a Jerry Can.");
        PlayerInfo[playerid][pMaterials] -= cost;
        PlayerInfo[playerid][pHasJerryCan] = 1;
        PlayerInfo[playerid][pJerryCanFuel] = 0.0;
        format(msg, sizeof(msg), "You crafted an empty Jerry Can. Refill it at a gas station.");
    }
    else if(!strcmp(item, "screwdriver", true) || !strcmp(item, "driver", true))
    {
        cost = 100;
        if(PlayerInfo[playerid][pMaterials] < cost) return ER_Send(playerid, COLOR_GREY, "You need 100 materials to craft a screwdriver.");
        PlayerInfo[playerid][pMaterials] -= cost;
        PlayerInfo[playerid][pScrewdrivers]++;
        format(msg, sizeof(msg), "You crafted a Screwdriver. Screwdrivers: %d", PlayerInfo[playerid][pScrewdrivers]);
    }
    else return ER_Send(playerid, COLOR_GREY, "USAGE: /craft [repairkit/jerrycan/screwdriver]");

    ER_AddJobSkill(playerid, JOB_TYPE_CRAFTSMAN, 1);
    ER_SaveCharacter(playerid);
    return ER_Send(playerid, COLOR_GREEN, msg);
}
CMD:boxstats(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_BOXER,"boxstats")) return 1; return ER_Send(playerid,COLOR_YELLOW,"Boxing record: 0 wins / 0 losses. Arena persistence can be expanded later."); }
CMD:fight(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_BOXER,"fight")) return 1; return ER_Send(playerid,COLOR_GREEN,"You are ready to fight. Use RP/arena manager to start a bout."); }
CMD:train(playerid, params[]) { if(!ER_RequireJobType(playerid,JOB_TYPE_BOXER,"train")) return 1; SetPlayerHealth(playerid,100.0); return ER_Send(playerid,COLOR_GREEN,"You train and recover your stamina."); }



// -----------------------------------------------------------------------------
// ExpressRP mechanic service offers: repair/refill/tune foundation.
// Repair uses Repair Kit. Refill uses Jerry Can fuel. Tune is reserved for next dialog pass.
// -----------------------------------------------------------------------------
#define ER_MAX_MECH_REPAIR_PRICE 5000
#define ER_MAX_MECH_REFILL_PRICE 3500

stock ER_GetMechanicRepairSeconds(playerid)
{
    new level = ER_GetJobLevelFromSkill(PlayerInfo[playerid][pJobSkill][JOB_TYPE_MECHANIC]);
    switch(level)
    {
        case 1: return 12;
        case 2: return 10;
        case 3: return 8;
        case 4: return 6;
    }
    return 4;
}

stock ER_GetMechanicMaxRefill(playerid)
{
    new level = ER_GetJobLevelFromSkill(PlayerInfo[playerid][pJobSkill][JOB_TYPE_MECHANIC]);
    switch(level)
    {
        case 1: return 20;
        case 2: return 35;
        case 3: return 50;
        case 4: return 75;
    }
    return 100;
}

stock ER_GetMechanicJerryCanCapacity(playerid)
{
    return ER_GetMechanicMaxRefill(playerid);
}

stock ER_GetTargetDriverVehicle(target)
{
    if(!IsPlayerConnected(target)) return 0;
    if(GetPlayerState(target) != PLAYER_STATE_DRIVER) return 0;
    return GetPlayerVehicleID(target);
}

stock ER_IsHoodOpen(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    return bonnet == VEHICLE_PARAMS_ON;
}

stock ER_MechNoHoodVeh(vehicleid)
{
    new model = GetVehicleModel(vehicleid);
    switch(model)
    {
        case 448, 461, 462, 463, 468, 471, 481, 509, 510, 521, 522, 523, 581, 586, 424, 568, 571: return 1;
    }
    return 0;
}

CMD:repair(playerid, params[])
{
    new target, price;
    if(!ER_RequireJobType(playerid, JOB_TYPE_MECHANIC, "repair")) return 1;
    if(sscanf(params, "ud", target, price)) return ER_Send(playerid, COLOR_GREY, "USAGE: /repair [playerid] [price]");
    if(price < 1 || price > ER_MAX_MECH_REPAIR_PRICE) return ER_Send(playerid, COLOR_GREY, "Invalid price or above mechanic repair cap.");
    if(!IsPlayerConnected(target) || target == playerid) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(PlayerInfo[playerid][pRepairKits] < 1) return ER_Send(playerid, COLOR_GREY, "You need a Repair Kit to repair vehicles.");
    new vehicleid = ER_GetTargetDriverVehicle(target);
    if(!vehicleid) return ER_Send(playerid, COLOR_GREY, "Target must be the driver of the vehicle to repair.");
    if(!ER_IsPlayerNearPlayer(playerid, target, 6.0)) return ER_Send(playerid, COLOR_GREY, "You are not close enough to the target vehicle.");
    if(!ER_MechNoHoodVeh(vehicleid) && !ER_IsHoodOpen(vehicleid)) return ER_Send(playerid, COLOR_GREY, "The vehicle hood must be opened first.");

    SetPVarInt(target, "RepairOfferMechanic", playerid + 1);
    SetPVarInt(target, "RepairOfferVehicle", vehicleid);
    SetPVarInt(target, "RepairOfferPrice", price);
    new mname[MAX_PLAYER_NAME], vname[32], msg[160];
    ER_GetDisplayName(playerid, mname, sizeof(mname));
    format(vname, sizeof(vname), "vehicle");
    format(msg, sizeof(msg), "%s has offered to fully repair your %s for $%d. Type /accept repair to accept.", mname, vname, price);
    ER_Send(target, COLOR_LIGHTBLUE, msg);
    ER_Send(playerid, COLOR_GREEN, "Repair offer sent.");
    return 1;
}

stock ER_AcceptRepairOffer(playerid)
{
    new mechanic = GetPVarInt(playerid, "RepairOfferMechanic") - 1;
    new vehicleid = GetPVarInt(playerid, "RepairOfferVehicle");
    new price = GetPVarInt(playerid, "RepairOfferPrice");
    if(mechanic < 0 || !IsPlayerConnected(mechanic)) return ER_Send(playerid, COLOR_GREY, "You have no valid repair offer.");
    if(PlayerInfo[playerid][pCash] < price) return ER_Send(playerid, COLOR_GREY, "You do not have enough money for this repair.");
    if(PlayerInfo[mechanic][pRepairKits] < 1) return ER_Send(playerid, COLOR_GREY, "The mechanic no longer has a Repair Kit.");
    if(GetPlayerVehicleID(playerid) != vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ER_Send(playerid, COLOR_GREY, "You must remain as driver in the offered vehicle.");
    if(!ER_IsPlayerNearPlayer(mechanic, playerid, 6.0)) return ER_Send(playerid, COLOR_GREY, "The mechanic is no longer close enough.");
    if(!ER_MechNoHoodVeh(vehicleid) && !ER_IsHoodOpen(vehicleid)) return ER_Send(playerid, COLOR_GREY, "The vehicle hood must stay open.");

    PlayerInfo[playerid][pCash] -= price; GivePlayerMoney(playerid, -price);
    PlayerInfo[mechanic][pCash] += price; GivePlayerMoney(mechanic, price);
    PlayerInfo[mechanic][pRepairKits]--;
    ApplyAnimation(mechanic, "CAR", "Fixn_Car_Loop", 4.1, 1, 0, 0, 0, 0, 1);
    SetPVarInt(playerid, "RepairInProgress", 1);
    SetPVarInt(playerid, "RepairMechanic", mechanic + 1);
    SetTimerEx("ER_FinishMechanicRepair", ER_GetMechanicRepairSeconds(mechanic) * 1000, false, "i", playerid);
    ER_Send(playerid, COLOR_GREEN, "Repair accepted. Please wait while the mechanic repairs your vehicle.");
    ER_Send(mechanic, COLOR_GREEN, "Repair accepted. Repairing vehicle...");
    return 1;
}

forward ER_FinishMechanicRepair(playerid);
public ER_FinishMechanicRepair(playerid)
{
    if(!IsPlayerConnected(playerid) || !GetPVarInt(playerid, "RepairInProgress")) return 1;
    new mechanic = GetPVarInt(playerid, "RepairMechanic") - 1;
    new vehicleid = GetPlayerVehicleID(playerid);
    DeletePVar(playerid, "RepairInProgress");
    DeletePVar(playerid, "RepairMechanic");
    DeletePVar(playerid, "RepairOfferMechanic");
    DeletePVar(playerid, "RepairOfferVehicle");
    DeletePVar(playerid, "RepairOfferPrice");
    if(vehicleid) SetVehicleHealth(vehicleid, 1000.0);
    if(mechanic >= 0 && IsPlayerConnected(mechanic))
    {
        ClearAnimations(mechanic);
        ER_AddJobSkill(mechanic, JOB_TYPE_MECHANIC, 1);
        ER_SaveCharacter(mechanic);
        ER_Send(mechanic, COLOR_GREEN, "Vehicle repaired successfully.");
    }
    ER_SaveCharacter(playerid);
    ER_Send(playerid, COLOR_GREEN, "Your vehicle has been fully repaired.");
    return 1;
}

CMD:refill(playerid, params[])
{
    new target, amount, price;
    if(!ER_RequireJobType(playerid, JOB_TYPE_MECHANIC, "refill")) return 1;
    if(sscanf(params, "udd", target, amount, price)) return ER_Send(playerid, COLOR_GREY, "USAGE: /refill [playerid] [fuel amount] [price]");
    if(price < 1 || price > ER_MAX_MECH_REFILL_PRICE) return ER_Send(playerid, COLOR_GREY, "Invalid price or above mechanic refill cap.");
    if(amount < 1) return ER_Send(playerid, COLOR_GREY, "Invalid fuel amount.");
    if(!IsPlayerConnected(target) || target == playerid) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(!PlayerInfo[playerid][pHasJerryCan]) return ER_Send(playerid, COLOR_GREY, "You need a Jerry Can to refill vehicles.");
    if(amount > ER_GetMechanicMaxRefill(playerid)) return ER_Send(playerid, COLOR_GREY, "Your mechanic level cannot refill that much fuel in one service.");
    if(float(amount) > PlayerInfo[playerid][pJerryCanFuel]) return ER_Send(playerid, COLOR_GREY, "Your Jerry Can does not have enough fuel.");
    new vehicleid = ER_GetTargetDriverVehicle(target);
    if(!vehicleid) return ER_Send(playerid, COLOR_GREY, "Target must be the driver of the vehicle to refill.");
    if(!ER_IsPlayerNearPlayer(playerid, target, 6.0)) return ER_Send(playerid, COLOR_GREY, "You are not close enough to the target vehicle.");

    SetPVarInt(target, "RefillOfferMechanic", playerid + 1);
    SetPVarInt(target, "RefillOfferVehicle", vehicleid);
    SetPVarInt(target, "RefillOfferAmount", amount);
    SetPVarInt(target, "RefillOfferPrice", price);
    new mname[MAX_PLAYER_NAME], msg[160];
    ER_GetDisplayName(playerid, mname, sizeof(mname));
    format(msg, sizeof(msg), "%s has offered to refill your vehicle with %d fuel for $%d. Type /accept refill to accept.", mname, amount, price);
    ER_Send(target, COLOR_LIGHTBLUE, msg);
    ER_Send(playerid, COLOR_GREEN, "Refill offer sent.");
    return 1;
}

stock ER_AcceptRefillOffer(playerid)
{
    new mechanic = GetPVarInt(playerid, "RefillOfferMechanic") - 1;
    new vehicleid = GetPVarInt(playerid, "RefillOfferVehicle");
    new amount = GetPVarInt(playerid, "RefillOfferAmount");
    new price = GetPVarInt(playerid, "RefillOfferPrice");
    if(mechanic < 0 || !IsPlayerConnected(mechanic)) return ER_Send(playerid, COLOR_GREY, "You have no valid refill offer.");
    if(PlayerInfo[playerid][pCash] < price) return ER_Send(playerid, COLOR_GREY, "You do not have enough money for this refill.");
    if(GetPlayerVehicleID(playerid) != vehicleid || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ER_Send(playerid, COLOR_GREY, "You must remain as driver in the offered vehicle.");
    if(!ER_IsPlayerNearPlayer(mechanic, playerid, 6.0)) return ER_Send(playerid, COLOR_GREY, "The mechanic is no longer close enough.");
    if(!PlayerInfo[mechanic][pHasJerryCan] || float(amount) > PlayerInfo[mechanic][pJerryCanFuel]) return ER_Send(playerid, COLOR_GREY, "The mechanic does not have enough Jerry Can fuel.");
    if(amount > ER_GetMechanicMaxRefill(mechanic)) return ER_Send(playerid, COLOR_GREY, "The mechanic cannot refill that much fuel in one service.");

    PlayerInfo[playerid][pCash] -= price; GivePlayerMoney(playerid, -price);
    PlayerInfo[mechanic][pCash] += price; GivePlayerMoney(mechanic, price);
    PlayerInfo[mechanic][pJerryCanFuel] -= float(amount);
    new idx = ER_FindVehicleBySpawnID(vehicleid);
    if(idx != -1) ER_SetVehicleFuel(idx, VehicleInfo[idx][vFuel] + float(amount));
    ApplyAnimation(mechanic, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0, 1);
    ER_AddJobSkill(mechanic, JOB_TYPE_MECHANIC, 1);
    ER_SaveCharacter(mechanic);
    ER_SaveCharacter(playerid);
    DeletePVar(playerid, "RefillOfferMechanic");
    DeletePVar(playerid, "RefillOfferVehicle");
    DeletePVar(playerid, "RefillOfferAmount");
    DeletePVar(playerid, "RefillOfferPrice");
    ER_Send(playerid, COLOR_GREEN, "Your vehicle has been refilled.");
    ER_Send(mechanic, COLOR_GREEN, "Vehicle refilled successfully.");
    return 1;
}

CMD:jerrycan(playerid, params[])
{
    new msg[96];
    if(!PlayerInfo[playerid][pHasJerryCan]) return ER_Send(playerid, COLOR_GREY, "You do not have a Jerry Can.");
    format(msg, sizeof(msg), "Jerry Can Fuel: %d/%d", floatround(PlayerInfo[playerid][pJerryCanFuel]), ER_GetMechanicJerryCanCapacity(playerid));
    return ER_Send(playerid, COLOR_YELLOW, msg);
}

stock ER_AcceptTuneOffer(playerid)
{
    #pragma unused playerid
    return 0;
}

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
    ER_AddJobSkill(playerid, JOB_TYPE_TRUCKER, 1);
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
