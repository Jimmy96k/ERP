#if defined _ER_FACTIONS_INCLUDED
    #endinput
#endif
#define _ER_FACTIONS_INCLUDED

#define MAX_FACTIONS 250 // static type list, but faction *instances* are effectively unlimited (headroom cap, not a design limit)
#define FACTION_CHAT_COLOR_DEFAULT 0x33CCFFFF // cyan
#define FACTION_DIV_COLOR_DEFAULT 0xFFFF00FF // yellow

#define FACTION_TYPE_NONE 0
#define FACTION_TYPE_POLICE 1
#define FACTION_TYPE_GOVERNMENT 2
#define FACTION_TYPE_EMS 3
#define FACTION_TYPE_NEWS 4
#define FACTION_TYPE_CRIMINAL 5
#define FACTION_TYPE_FEDERAL 6
#define FACTION_TYPE_CORRECTIONS 7

new FactionListSQL[MAX_PLAYERS][MAX_FACTIONS];
new FactionDivSelectTarget[MAX_PLAYERS];
new FactionDivSelectMode[MAX_PLAYERS]; // 1 invite, 2 set
new FactionLeaderSelectSQL[MAX_PLAYERS][100];
new FactionLeaderSelectName[MAX_PLAYERS][100][MAX_PLAYER_NAME_EX];
new FactionLockerGunList[MAX_PLAYERS][64];

enum E_FACTION_INFO
{
    facSQLID,
    facName[64],
    facType,
    facLeaderID,
    facLeaderName[MAX_PLAYER_NAME_EX],
    facMOTD[128],
    facMembers,
    facColor,
    facRadioColor,
    facDivisionColor,
    facSetMOTDRank,
    facInviteKickRank,
    facPointCaptureRank,
    facTurfCaptureRank,
    facSafeDepositRank,
    facSafeWithdrawRank,
    facLockerDepositRank,
    facLockerWithdrawRank,
    facLockerGunRank,
    facVehicleLockRank,
    facVehicleTrackRank,
    facVehicleParkRank,
    facBusinessSafeDepositRank,
    facBusinessSafeWithdrawRank,
    facBusinessRestockRank,
    facBusinessLockRank,
    facDoorLockRank,
    facEnabled
}
new Factions[MAX_FACTIONS][E_FACTION_INFO];
new FactionRankNames[MAX_FACTIONS][MAX_FACTION_RANKS][32];
new FactionDivisionNames[MAX_FACTIONS][MAX_FACTION_DIVISIONS][32];
new FactionCount;

stock ER_GetFactionTypeName(type, dest[], size = sizeof(dest))
{
    switch(type)
    {
        case FACTION_TYPE_POLICE: format(dest, size, "Police Department");
        case FACTION_TYPE_GOVERNMENT: format(dest, size, "Government");
        case FACTION_TYPE_EMS: format(dest, size, "EMS / Fire Department");
        case FACTION_TYPE_NEWS: format(dest, size, "News Agency");
        case FACTION_TYPE_CRIMINAL: format(dest, size, "Criminal Faction");
        case FACTION_TYPE_FEDERAL: format(dest, size, "Federal Agency");
        case FACTION_TYPE_CORRECTIONS: format(dest, size, "Correctional / Prison");
        default: format(dest, size, "None");
    }
    return 1;
}

stock ER_ResolveFactionTypeInput(const input[])
{
    // Static, fixed list of faction TYPES. New faction INSTANCES are unlimited (up to MAX_FACTIONS headroom),
    // but every instance must belong to one of these predefined types.
    if(!strcmp(input, "police", true))      return FACTION_TYPE_POLICE;
    if(!strcmp(input, "government", true) || !strcmp(input, "gov", true)) return FACTION_TYPE_GOVERNMENT;
    if(!strcmp(input, "ems", true) || !strcmp(input, "fire", true))       return FACTION_TYPE_EMS;
    if(!strcmp(input, "news", true))        return FACTION_TYPE_NEWS;
    if(!strcmp(input, "criminal", true) || !strcmp(input, "crime", true)) return FACTION_TYPE_CRIMINAL;
    if(!strcmp(input, "federal", true) || !strcmp(input, "fed", true))    return FACTION_TYPE_FEDERAL;
    if(!strcmp(input, "corrections", true) || !strcmp(input, "prison", true)) return FACTION_TYPE_CORRECTIONS;
    return -1; // invalid/unknown type string
}

stock ER_FindFactionIndexBySQLID(fid)
{
    for(new i; i < FactionCount; i++) if(Factions[i][facSQLID] == fid) return i;
    return -1;
}

stock ER_GetFactionRankName(fid, rank, dest[], size)
{
    if(rank <= 0) return format(dest, size, "None");
    new idx = ER_FindFactionIndexBySQLID(fid);
    if(idx == -1) return format(dest, size, "(%d) - Unknown", rank);
    new slot = rank - 1;
    if(slot >= 0 && slot < MAX_FACTION_RANKS && !isnull(FactionRankNames[idx][slot])) return format(dest, size, "(%d) - %s", rank, FactionRankNames[idx][slot]);
    return format(dest, size, "(%d) - Rank %d", rank, rank);
}

stock ER_GetFactionDivisionName(fid, division, dest[], size)
{
    if(division <= 0) return format(dest, size, "None");
    new idx = ER_FindFactionIndexBySQLID(fid);
    if(idx == -1) return format(dest, size, "(%d) - Unknown", division);
    new slot = division - 1;
    if(slot >= 0 && slot < MAX_FACTION_DIVISIONS && !isnull(FactionDivisionNames[idx][slot])) return format(dest, size, "(%d) - %s", division, FactionDivisionNames[idx][slot]);
    return format(dest, size, "(%d) - Division %d", division, division);
}

stock ER_LoadFactions()
{
    mysql_tquery(MainPipeline, "SELECT * FROM `factions` WHERE `enabled`=1", "ER_OnFactionsLoad");
    return 1;
}
forward ER_OnFactionsLoad();
public ER_OnFactionsLoad()
{
    new rows; cache_get_row_count(rows); FactionCount = 0;
    for(new r; r < rows && FactionCount < MAX_FACTIONS; r++)
    {
        cache_get_value_name_int(r, "id", Factions[FactionCount][facSQLID]);
        cache_get_value_name(r, "name", Factions[FactionCount][facName], 64);
        cache_get_value_name_int(r, "type", Factions[FactionCount][facType]);
        cache_get_value_name_int(r, "leader_id", Factions[FactionCount][facLeaderID]);
        cache_get_value_name(r, "leader_name", Factions[FactionCount][facLeaderName], MAX_PLAYER_NAME_EX);
        cache_get_value_name(r, "motd", Factions[FactionCount][facMOTD], 128);
        cache_get_value_name_int(r, "members_count", Factions[FactionCount][facMembers]);
        cache_get_value_name_int(r, "color", Factions[FactionCount][facColor]);
        cache_get_value_name_int(r, "radio_color", Factions[FactionCount][facRadioColor]);
        cache_get_value_name_int(r, "division_color", Factions[FactionCount][facDivisionColor]);
        cache_get_value_name_int(r, "set_motd_rank", Factions[FactionCount][facSetMOTDRank]);
        cache_get_value_name_int(r, "invite_kick_rank", Factions[FactionCount][facInviteKickRank]);
        cache_get_value_name_int(r, "point_capture_rank", Factions[FactionCount][facPointCaptureRank]);
        cache_get_value_name_int(r, "turf_capture_rank", Factions[FactionCount][facTurfCaptureRank]);
        cache_get_value_name_int(r, "safe_deposit_rank", Factions[FactionCount][facSafeDepositRank]);
        cache_get_value_name_int(r, "safe_withdraw_rank", Factions[FactionCount][facSafeWithdrawRank]);
        cache_get_value_name_int(r, "locker_deposit_rank", Factions[FactionCount][facLockerDepositRank]);
        cache_get_value_name_int(r, "locker_withdraw_rank", Factions[FactionCount][facLockerWithdrawRank]);
        cache_get_value_name_int(r, "locker_gun_rank", Factions[FactionCount][facLockerGunRank]);
        cache_get_value_name_int(r, "vehicle_lock_rank", Factions[FactionCount][facVehicleLockRank]);
        cache_get_value_name_int(r, "vehicle_track_rank", Factions[FactionCount][facVehicleTrackRank]);
        cache_get_value_name_int(r, "vehicle_park_rank", Factions[FactionCount][facVehicleParkRank]);
        cache_get_value_name_int(r, "business_safe_deposit_rank", Factions[FactionCount][facBusinessSafeDepositRank]);
        cache_get_value_name_int(r, "business_safe_withdraw_rank", Factions[FactionCount][facBusinessSafeWithdrawRank]);
        cache_get_value_name_int(r, "business_restock_rank", Factions[FactionCount][facBusinessRestockRank]);
        cache_get_value_name_int(r, "business_lock_rank", Factions[FactionCount][facBusinessLockRank]);
        cache_get_value_name_int(r, "door_lock_rank", Factions[FactionCount][facDoorLockRank]);
        if(Factions[FactionCount][facVehicleLockRank] <= 0) Factions[FactionCount][facVehicleLockRank] = 5;
        if(Factions[FactionCount][facVehicleTrackRank] <= 0) Factions[FactionCount][facVehicleTrackRank] = 5;
        if(Factions[FactionCount][facVehicleParkRank] <= 0) Factions[FactionCount][facVehicleParkRank] = 5;
        if(Factions[FactionCount][facBusinessSafeDepositRank] <= 0) Factions[FactionCount][facBusinessSafeDepositRank] = 5;
        if(Factions[FactionCount][facBusinessSafeWithdrawRank] <= 0) Factions[FactionCount][facBusinessSafeWithdrawRank] = 5;
        if(Factions[FactionCount][facBusinessRestockRank] <= 0) Factions[FactionCount][facBusinessRestockRank] = 5;
        if(Factions[FactionCount][facBusinessLockRank] <= 0) Factions[FactionCount][facBusinessLockRank] = 5;
        if(Factions[FactionCount][facDoorLockRank] <= 0) Factions[FactionCount][facDoorLockRank] = 5;
        cache_get_value_name_int(r, "enabled", Factions[FactionCount][facEnabled]);
        if(Factions[FactionCount][facColor] == 0) Factions[FactionCount][facColor] = FACTION_CHAT_COLOR_DEFAULT;
        if(Factions[FactionCount][facRadioColor] == 0) Factions[FactionCount][facRadioColor] = FACTION_CHAT_COLOR_DEFAULT;
        if(Factions[FactionCount][facDivisionColor] == 0) Factions[FactionCount][facDivisionColor] = FACTION_DIV_COLOR_DEFAULT;
        if(Factions[FactionCount][facInviteKickRank] <= 0) Factions[FactionCount][facInviteKickRank] = 5;
        FactionCount++;
    }
    mysql_tquery(MainPipeline, "SELECT * FROM `faction_ranks` ORDER BY `faction_id`,`rank_id`", "ER_OnFactionRanksLoad");
    mysql_tquery(MainPipeline, "SELECT * FROM `faction_divisions` ORDER BY `faction_id`,`division_id`", "ER_OnFactionDivisionsLoad");
    printf("[Factions] Loaded %d factions.", FactionCount);
    return 1;
}
forward ER_OnFactionRanksLoad();
public ER_OnFactionRanksLoad()
{
    for(new i; i < MAX_FACTIONS; i++) for(new r; r < MAX_FACTION_RANKS; r++) FactionRankNames[i][r][0] = EOS;
    new rows; cache_get_row_count(rows);
    for(new row; row < rows; row++)
    {
        new fid, rank; cache_get_value_name_int(row, "faction_id", fid); cache_get_value_name_int(row, "rank_id", rank);
        new idx = ER_FindFactionIndexBySQLID(fid);
        if(idx != -1 && rank >= 1 && rank <= MAX_FACTION_RANKS) cache_get_value_name(row, "rank_name", FactionRankNames[idx][rank-1], 32);
    }
    return 1;
}
forward ER_OnFactionDivisionsLoad();
public ER_OnFactionDivisionsLoad()
{
    for(new i; i < MAX_FACTIONS; i++) for(new d; d < MAX_FACTION_DIVISIONS; d++) FactionDivisionNames[i][d][0] = EOS;
    new rows; cache_get_row_count(rows);
    for(new row; row < rows; row++)
    {
        new fid, div; cache_get_value_name_int(row, "faction_id", fid); cache_get_value_name_int(row, "division_id", div);
        new idx = ER_FindFactionIndexBySQLID(fid);
        if(idx != -1 && div >= 1 && div <= MAX_FACTION_DIVISIONS) cache_get_value_name(row, "division_name", FactionDivisionNames[idx][div-1], 32);
    }
    return 1;
}

stock ER_RecountFactionMembers(fid)
{
    new q[180];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `members_count`=(SELECT COUNT(*) FROM `accounts` WHERE `faction_id`=%d) WHERE `id`=%d", fid, fid);
    mysql_tquery(MainPipeline, q);
    return 1;
}


stock ER_RecountAllFactionMembers()
{
    mysql_tquery(MainPipeline, "UPDATE `factions` f SET `members_count`=(SELECT COUNT(*) FROM `accounts` a WHERE a.`faction_id`=f.`id`)");
    return 1;
}

stock ER_MovePlayerToFaction(playerid, fid, rank = 1, division = 0, bool:force = false)
{
    if(!IsPlayerConnected(playerid) || !PlayerInfo[playerid][pLoggedIn]) return 0;
    if(ER_FindFactionIndexBySQLID(fid) == -1) return 0;
    if(!force && (PlayerInfo[playerid][pFamily] > 0 || PlayerInfo[playerid][pFaction] > 0)) return 0;
    new oldfac = PlayerInfo[playerid][pFaction], oldfam = PlayerInfo[playerid][pFamily];
    PlayerInfo[playerid][pFaction] = fid; PlayerInfo[playerid][pFactionRank] = rank; PlayerInfo[playerid][pFactionDivision] = division;
    PlayerInfo[playerid][pFamily] = 0; PlayerInfo[playerid][pFamilyRank] = 0; PlayerInfo[playerid][pFamilyCrew] = 0;
    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `faction_id`=%d,`faction_rank`=%d,`faction_division`=%d,`family_id`=0,`family_rank`=0,`family_crew`=0 WHERE `id`=%d", fid, rank, division, PlayerInfo[playerid][pID]);
    mysql_tquery(MainPipeline, q);
    if(oldfac > 0 && oldfac != fid) ER_RecountFactionMembers(oldfac);
    if(oldfam > 0) ER_RecountFamilyMembers(oldfam);
    ER_RecountFactionMembers(fid);
    return 1;
}

stock ER_RemovePlayerFromFaction(playerid, bool:force = false)
{
    if(PlayerInfo[playerid][pFaction] <= 0) return 0;
    new fid = PlayerInfo[playerid][pFaction], idx = ER_FindFactionIndexBySQLID(fid);
    if(!force && idx != -1 && Factions[idx][facLeaderID] == PlayerInfo[playerid][pID]) return 0;
    PlayerInfo[playerid][pFaction] = 0; PlayerInfo[playerid][pFactionRank] = 0; PlayerInfo[playerid][pFactionDivision] = 0;
    new q[160]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `faction_id`=0,`faction_rank`=0,`faction_division`=0 WHERE `id`=%d", PlayerInfo[playerid][pID]); mysql_tquery(MainPipeline, q);
    ER_RecountFactionMembers(fid);
    return 1;
}

stock ER_CreateDefaultFactionRows(fid)
{
    new q[384];
    new ranks[6][24] = {"Recruit", "Officer", "Senior Officer", "Sergeant", "Lieutenant", "Chief"};
    for(new r; r < 6; r++) { mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `faction_ranks` (`faction_id`,`rank_id`,`rank_name`) VALUES (%d,%d,'%e') ON DUPLICATE KEY UPDATE `rank_name`=VALUES(`rank_name`)", fid, r+1, ranks[r]); mysql_tquery(MainPipeline, q); }
    new divs[3][32] = {"Patrol Division", "Investigations Division", "Command Division"};
    for(new d; d < 3; d++) { mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `faction_divisions` (`faction_id`,`division_id`,`division_name`) VALUES (%d,%d,'%e') ON DUPLICATE KEY UPDATE `division_name`=VALUES(`division_name`)", fid, d+1, divs[d]); mysql_tquery(MainPipeline, q); }
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `faction_lockers` (`faction_id`,`materials`,`pot`,`crack`,`enabled`) VALUES (%d,0,0,0,0)", fid); mysql_tquery(MainPipeline, q, "ER_OnDefaultFactionLocker", "i", fid);
    return 1;
}

CMD:createfaction(playerid, params[])
{
    new typestr[16], name[64];
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "s[16]S()[64]", typestr, name))
        return ER_Send(playerid, COLOR_GREY, "USAGE: /createfaction [type] [name]  -  types: police, government, ems, news, criminal, federal, corrections");

    new type = ER_ResolveFactionTypeInput(typestr);
    if(type == -1)
        return ER_Send(playerid, COLOR_GREY, "Invalid faction type. Valid types: police, government, ems, news, criminal, federal, corrections.");

    if(isnull(name))
        return ER_Send(playerid, COLOR_GREY, "USAGE: /createfaction [type] [name]");

    // Faction TYPES are a fixed/static list (above). Faction INSTANCES are not limited by design,
    // only by this technical headroom cap so the server doesn't run out of array slots.
    if(FactionCount >= MAX_FACTIONS)
        return ER_Send(playerid, COLOR_GREY, "Faction slot limit reached. Increase MAX_FACTIONS in factions.pwn to allow more.");

    new q[700];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `factions` (`name`,`type`,`leader_id`,`leader_name`,`motd`,`members_count`,`set_motd_rank`,`invite_kick_rank`,`point_capture_rank`,`turf_capture_rank`,`safe_deposit_rank`,`safe_withdraw_rank`,`locker_deposit_rank`,`locker_withdraw_rank`,`locker_gun_rank`,`business_safe_deposit_rank`,`business_safe_withdraw_rank`,`business_restock_rank`,`business_lock_rank`,`door_lock_rank`,`color`,`radio_color`,`division_color`,`enabled`) VALUES ('%e',%d,%d,'%e','Welcome to the faction.',1,5,5,5,5,1,5,1,5,1,5,5,5,5,5,%d,%d,%d,1)", name, type, PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], FACTION_CHAT_COLOR_DEFAULT, FACTION_CHAT_COLOR_DEFAULT, FACTION_DIV_COLOR_DEFAULT);
    mysql_tquery(MainPipeline, q, "ER_OnFactionCreated", "i", playerid);
    return 1;
}
forward ER_OnFactionCreated(playerid);
public ER_OnFactionCreated(playerid)
{
    new fid = cache_insert_id();
    ER_CreateDefaultFactionRows(fid);
    ER_MovePlayerToFaction(playerid, fid, 6, 0, true);
    ER_LoadFactions();
    ER_Send(playerid, COLOR_GREEN, "Faction created with 6 ranks and 3 divisions.");
    SetTimerEx("ER_ShowCreatedFactionEditor", 600, false, "ii", playerid, fid);
    return 1;
}
forward ER_ShowCreatedFactionEditor(playerid, fid);
public ER_ShowCreatedFactionEditor(playerid, fid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    return ER_ShowFactionEditor(playerid, fid);
}
forward ER_OnDefaultFactionLocker(fid);
public ER_OnDefaultFactionLocker(fid)
{
    new lockerid = cache_insert_id(), q[256];
    new weaps[] = {22, 23, 24, 25, 29, 30, 31, 33, 34};
    for(new i; i < sizeof(weaps); i++)
    {
        mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `faction_locker_guns` (`locker_id`,`weaponid`,`required_rank`,`admin_enabled`,`leader_enabled`) VALUES (%d,%d,%d,1,1)", lockerid, weaps[i], (i < 3) ? 1 : ((i < 6) ? 4 : 5));
        mysql_tquery(MainPipeline, q);
    }
    return 1;
}

CMD:facinvite(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /facinvite [playerid/name]");
    if(PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a faction.");
    new idx = ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]);
    if(idx == -1 || PlayerInfo[playerid][pFactionRank] < Factions[idx][facInviteKickRank]) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(PlayerInfo[target][pFamily] > 0 || PlayerInfo[target][pFaction] > 0) return ER_Send(playerid, COLOR_GREY, "This player is already in a family or faction.");
    SetPVarInt(target, "PendingFactionInvite", PlayerInfo[playerid][pFaction]);
    new msg[160]; format(msg, sizeof(msg), "You invited %s to %s.", ER_GetName(target), Factions[idx][facName]); ER_Send(playerid, COLOR_GREEN, msg);
    format(msg, sizeof(msg), "%s invited you to join %s. Use /accept faction.", ER_GetName(playerid), Factions[idx][facName]); ER_Send(target, COLOR_YELLOW, msg);
    return 1;
}
alias:facinvite("factioninvite")

CMD:fackick(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /fackick [playerid/name]");
    if(PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a faction.");
    new idx = ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]);
    if(idx == -1 || PlayerInfo[playerid][pFactionRank] < Factions[idx][facInviteKickRank]) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn] || PlayerInfo[target][pFaction] != PlayerInfo[playerid][pFaction]) return ER_Send(playerid, COLOR_GREY, "That player is not in your faction.");
    if(PlayerInfo[target][pFactionRank] >= PlayerInfo[playerid][pFactionRank]) return ER_Send(playerid, COLOR_GREY, "You cannot kick a player with an equal or higher rank.");
    ER_RemovePlayerFromFaction(target, true);
    ER_Send(target, COLOR_GREY, "You have been removed from your faction.");
    return ER_Send(playerid, COLOR_GREEN, "Player removed from faction.");
}
alias:fackick("factionkick")

CMD:leavefaction(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a faction.");
    if(!ER_RemovePlayerFromFaction(playerid, false)) return ER_Send(playerid, COLOR_GREY, "You cannot leave while you are the leader. Transfer leadership first.");
    return ER_Send(playerid, COLOR_GREEN, "You left the faction.");
}

stock ER_DepartmentChat(playerid, const text[])
{
    if(PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a faction.");
    if(isnull(text)) return ER_Send(playerid, COLOR_GREY, "USAGE: /dep [message]");
    new msg[200], sendcolor = FACTION_CHAT_COLOR_DEFAULT;
    new facidx = ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]);
    if(facidx != -1 && Factions[facidx][facRadioColor] != 0) sendcolor = Factions[facidx][facRadioColor];

    new dname[MAX_PLAYER_NAME], rankname[48], divname[48];
    ER_GetDisplayName(playerid, dname, sizeof(dname));
    ER_GetFactionRankName(PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pFactionRank], rankname, sizeof(rankname));
    ER_GetFactionDivisionName(PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pFactionDivision], divname, sizeof(divname));

    if(PlayerInfo[playerid][pFactionDivision] > 0) format(msg, sizeof(msg), "(( Department | %s | Division: %s )) %s: %s", rankname, divname, dname, text);
    else format(msg, sizeof(msg), "(( Department | %s )) %s: %s", rankname, dname, text);
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction]) SendClientMessage(i, sendcolor, msg);
    return 1;
}

stock ER_GetPlayerFactionType(playerid)
{
    if(PlayerInfo[playerid][pFaction] <= 0) return FACTION_TYPE_NONE;
    new idx = ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]);
    if(idx == -1) return FACTION_TYPE_NONE;
    return Factions[idx][facType];
}

stock ER_IsLawFactionType(type)
{
    return (type == FACTION_TYPE_POLICE || type == FACTION_TYPE_FEDERAL || type == FACTION_TYPE_CORRECTIONS || type == FACTION_TYPE_GOVERNMENT);
}

stock ER_IsEmergencyFactionType(type)
{
    return (type == FACTION_TYPE_POLICE || type == FACTION_TYPE_FEDERAL || type == FACTION_TYPE_CORRECTIONS || type == FACTION_TYPE_EMS || type == FACTION_TYPE_GOVERNMENT);
}

CMD:gov(playerid, params[])
{
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /gov [announcement]");
    new type = ER_GetPlayerFactionType(playerid);
    if(type != FACTION_TYPE_GOVERNMENT && type != FACTION_TYPE_POLICE && type != FACTION_TYPE_FEDERAL && type != FACTION_TYPE_EMS) return ER_Send(playerid, COLOR_GREY, "You are not in a government/emergency faction.");
    if(PlayerInfo[playerid][pFactionRank] < 5) return ER_Send(playerid, COLOR_GREY, "You need rank 5+ to use government announcements.");
    new dname[MAX_PLAYER_NAME], facname[64], msg[180];
    ER_GetDisplayName(playerid, dname, sizeof(dname));
    new idx = ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]);
    if(idx != -1) format(facname, sizeof(facname), "%s", Factions[idx][facName]); else format(facname, sizeof(facname), "Government");
    format(msg, sizeof(msg), "*** Government Announcement from %s - %s: %s", facname, dname, params);
    SendClientMessageToAll(COLOR_LIGHTBLUE, msg);
    return 1;
}

CMD:m(playerid, params[])
{
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /m [megaphone]");
    new type = ER_GetPlayerFactionType(playerid);
    if(!ER_IsEmergencyFactionType(type)) return ER_Send(playerid, COLOR_GREY, "You are not in an emergency/law faction.");
    new Float:x, Float:y, Float:z, dname[MAX_PLAYER_NAME], msg[180];
    GetPlayerPos(playerid, x, y, z);
    ER_GetDisplayName(playerid, dname, sizeof(dname));
    format(msg, sizeof(msg), "[Megaphone] %s: %s", dname, params);
    ER_NearbyMessage(x, y, z, 60.0, COLOR_YELLOW, msg, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

CMD:badge(playerid, params[])
{
    new type = ER_GetPlayerFactionType(playerid);
    if(!ER_IsEmergencyFactionType(type) && type != FACTION_TYPE_NEWS) return ER_Send(playerid, COLOR_GREY, "You are not in a badge/ID faction.");
    new dname[MAX_PLAYER_NAME], rankname[48], divname[48], msg[180], Float:x, Float:y, Float:z;
    ER_GetDisplayName(playerid, dname, sizeof(dname));
    ER_GetFactionRankName(PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pFactionRank], rankname, sizeof(rankname));
    ER_GetFactionDivisionName(PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pFactionDivision], divname, sizeof(divname));
    GetPlayerPos(playerid, x, y, z);
    format(msg, sizeof(msg), "* %s shows their badge/ID. Rank: %s | Division: %s", dname, rankname, divname);
    ER_NearbyMessage(x, y, z, 20.0, COLOR_LIGHTBLUE, msg, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

CMD:news(playerid, params[])
{
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /news [message]");
    if(ER_GetPlayerFactionType(playerid) != FACTION_TYPE_NEWS) return ER_Send(playerid, COLOR_GREY, "You are not in a news faction.");
    new dname[MAX_PLAYER_NAME], msg[180];
    ER_GetDisplayName(playerid, dname, sizeof(dname));
    format(msg, sizeof(msg), "[News] %s: %s", dname, params);
    SendClientMessageToAll(COLOR_ORANGE, msg);
    return 1;
}

CMD:dep(playerid, params[]) { return ER_DepartmentChat(playerid, params); }
CMD:dept(playerid, params[]) { return ER_DepartmentChat(playerid, params); }
CMD:fr(playerid, params[]) { return ER_DepartmentChat(playerid, params); }
CMD:department(playerid, params[]) { return ER_DepartmentChat(playerid, params); }

CMD:division(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a faction.");
    if(PlayerInfo[playerid][pFactionDivision] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not assigned to a division.");
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /division [message]");
    new msg[200], sendcolor = FACTION_DIV_COLOR_DEFAULT;
    new facidx = ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]);
    if(facidx != -1 && Factions[facidx][facDivisionColor] != 0) sendcolor = Factions[facidx][facDivisionColor];

    new dname[MAX_PLAYER_NAME], rankname[48], divname[48];
    ER_GetDisplayName(playerid, dname, sizeof(dname));
    ER_GetFactionRankName(PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pFactionRank], rankname, sizeof(rankname));
    ER_GetFactionDivisionName(PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pFactionDivision], divname, sizeof(divname));

    format(msg, sizeof(msg), "(( Division | %s | %s )) %s: %s", rankname, divname, dname, params);
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction] && PlayerInfo[i][pFactionDivision] == PlayerInfo[playerid][pFactionDivision]) SendClientMessage(i, sendcolor, msg);
    return 1;
}
alias:division("div")

CMD:divinvite(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /divinvite [playerid/name]");
    if(PlayerInfo[playerid][pFaction] <= 0 || PlayerInfo[playerid][pFactionRank] < 5) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || PlayerInfo[target][pFaction] != PlayerInfo[playerid][pFaction]) return ER_Send(playerid, COLOR_GREY, "That player is not in your faction.");
    FactionDivSelectTarget[playerid] = target; FactionDivSelectMode[playerid] = 1;
    return ER_ShowFactionDivisionSelect(playerid);
}
alias:divinvite("divisioninvite")

CMD:setdivision(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setdivision [playerid/name]");
    if(PlayerInfo[playerid][pFaction] <= 0 || PlayerInfo[playerid][pFactionRank] < 6) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || PlayerInfo[target][pFaction] != PlayerInfo[playerid][pFaction]) return ER_Send(playerid, COLOR_GREY, "That player is not in your faction.");
    FactionDivSelectTarget[playerid] = target; FactionDivSelectMode[playerid] = 2;
    return ER_ShowFactionDivisionSelect(playerid);
}
alias:setdivision("setdiv")

stock ER_ShowFactionDivisionSelect(playerid)
{
    new fid = PlayerInfo[playerid][pFaction], list[512], name[48];
    format(list, sizeof(list), "1 - (0) None\n");
    for(new d = 1; d <= 3 && d <= MAX_FACTION_DIVISIONS; d++)
    {
        ER_GetFactionDivisionName(fid, d, name, sizeof(name));
        format(list, sizeof(list), "%s%d - %s\n", list, d + 1, name);
    }
    ShowPlayerDialog(playerid, DIALOG_FACTION_DIV_INVITE, DIALOG_STYLE_LIST, "Select Division", list, "Select", "Cancel");
    return 1;
}

stock ER_AcceptFactionInvite(playerid)
{
    new fid = GetPVarInt(playerid, "PendingFactionInvite");
    if(fid <= 0) return 0;
    if(PlayerInfo[playerid][pFamily] > 0 || PlayerInfo[playerid][pFaction] > 0) { DeletePVar(playerid, "PendingFactionInvite"); return ER_Send(playerid, COLOR_GREY, "You are already in a family or faction."); }
    ER_MovePlayerToFaction(playerid, fid, 1, 0, false);
    DeletePVar(playerid, "PendingFactionInvite");
    return ER_Send(playerid, COLOR_GREEN, "You joined the faction.");
}

stock ER_AcceptDivisionInvite(playerid)
{
    new div = GetPVarInt(playerid, "PendingDivisionInvite");
    if(div <= 0) return 0;
    PlayerInfo[playerid][pFactionDivision] = div;
    new q[160]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `faction_division`=%d WHERE `id`=%d", div, PlayerInfo[playerid][pID]); mysql_tquery(MainPipeline, q);
    DeletePVar(playerid, "PendingDivisionInvite");
    return ER_Send(playerid, COLOR_GREEN, "You accepted the division invite.");
}

CMD:factions(playerid, params[])
{
    new listno;
    if(sscanf(params, "d", listno))
    {
        new line[160];
        SendClientMessage(playerid, COLOR_OFFWHITE, "Factions:");
        for(new i; i < FactionCount; i++)
        {
            FactionListSQL[playerid][i+1] = Factions[i][facSQLID];
            format(line, sizeof(line), "%d - (%d) %s - Leader: %s - Members: %d", i+1, Factions[i][facSQLID], Factions[i][facName], Factions[i][facLeaderName], Factions[i][facMembers]);
            SendClientMessage(playerid, COLOR_OFFWHITE, line);
        }
        return 1;
    }
    if(listno <= 0 || listno > FactionCount) return ER_Send(playerid, COLOR_GREY, "Invalid faction list number. Use /factions first.");
    new fid = Factions[listno-1][facSQLID], line[160], rankname[48];
    SendClientMessage(playerid, COLOR_OFFWHITE, "Online Members:");
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFaction] == fid)
    {
        ER_GetFactionRankName(fid, PlayerInfo[i][pFactionRank], rankname, sizeof(rankname));
        format(line, sizeof(line), "%s %s", ER_GetName(i), rankname);
        SendClientMessage(playerid, COLOR_OFFWHITE, line);
    }
    return 1;
}

stock ER_SendFactionMOTD(playerid)
{
    if(PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a faction.");
    new idx = ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]), msg[180];
    if(idx == -1) return 1;
    format(msg, sizeof(msg), "Faction MOTD: %s", Factions[idx][facMOTD]);
    return ER_Send(playerid, Factions[idx][facColor], msg);
}
CMD:facmotd(playerid, params[])
{
    return ER_SendFactionMOTD(playerid);
}

CMD:motd(playerid, params[])
{
    if(PlayerInfo[playerid][pFamily] > 0) ER_SendFamilyMOTD(playerid);
    if(PlayerInfo[playerid][pFaction] > 0) ER_SendFactionMOTD(playerid);
    if(PlayerInfo[playerid][pFamily] <= 0 && PlayerInfo[playerid][pFaction] <= 0) ER_Send(playerid, COLOR_GREY, "No MOTDs available.");
    return 1;
}

CMD:members(playerid, params[])
{
    new line[160], namebuf[48];
    if(PlayerInfo[playerid][pFamily] > 0)
    {
        SendClientMessage(playerid, COLOR_OFFWHITE, "Online Family Members:");
        foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFamily] == PlayerInfo[playerid][pFamily])
        {
            ER_GetFamilyRankName(PlayerInfo[playerid][pFamily], PlayerInfo[i][pFamilyRank], namebuf, sizeof(namebuf));
            format(line, sizeof(line), "%s %s - Crew: %d", ER_GetName(i), namebuf, PlayerInfo[i][pFamilyCrew]); SendClientMessage(playerid, COLOR_OFFWHITE, line);
        }
    }
    if(PlayerInfo[playerid][pFaction] > 0)
    {
        SendClientMessage(playerid, COLOR_OFFWHITE, "Online Faction Members:");
        foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction])
        {
            ER_GetFactionRankName(PlayerInfo[playerid][pFaction], PlayerInfo[i][pFactionRank], namebuf, sizeof(namebuf));
            format(line, sizeof(line), "%s %s - Division: %d", ER_GetName(i), namebuf, PlayerInfo[i][pFactionDivision]); SendClientMessage(playerid, COLOR_OFFWHITE, line);
        }
    }
    if(PlayerInfo[playerid][pFamily] <= 0 && PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a family or faction.");
    return 1;
}


stock ER_ShowFactionRanksEditor(playerid, fid)
{
    new idx = ER_FindFactionIndexBySQLID(fid), list[512], line[96];
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid faction."), 1;
    for(new r = 1; r <= 6; r++)
    {
        format(line, sizeof(line), "%d - %s\n", r, FactionRankNames[idx][r - 1]);
        strcat(list, line, sizeof(list));
    }
    ShowPlayerDialog(playerid, DIALOG_FACTION_RANKS, DIALOG_STYLE_LIST, "Faction Ranks", list, "Edit", "Back");
    return 1;
}

stock ER_ShowFactionDivisionsEditor(playerid, fid)
{
    new idx = ER_FindFactionIndexBySQLID(fid), list[512], line[96];
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid faction."), 1;
    for(new d = 1; d <= 3; d++)
    {
        format(line, sizeof(line), "%d - %s\n", d, FactionDivisionNames[idx][d - 1]);
        strcat(list, line, sizeof(list));
    }
    ShowPlayerDialog(playerid, DIALOG_FACTION_DIVISIONS, DIALOG_STYLE_LIST, "Faction Divisions", list, "Edit", "Back");
    return 1;
}

stock ER_ShowFactionPermsEditor(playerid, fid)
{
    new idx = ER_FindFactionIndexBySQLID(fid), list[1024];
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid faction."), 1;
    format(list, sizeof(list),
        "Set MOTD >= %d\nInvite & Kick >= %d\nPoint Capture >= %d\nTurf Capture >= %d\nSafe Deposit >= %d\nSafe Withdraw >= %d\nLocker Deposit >= %d\nLocker Withdraw >= %d\nLocker Weapons >= %d\nVehicles - Lock/Unlock >= %d\nVehicles - Track >= %d\nVehicles - Park >= %d\nBusiness - Safe Deposit >= %d\nBusiness - Safe Withdraw >= %d\nBusiness - Restock >= %d\nBusiness - Lock/Unlock >= %d\nDoors - Lock/Unlock >= %d",
        Factions[idx][facSetMOTDRank], Factions[idx][facInviteKickRank], Factions[idx][facPointCaptureRank], Factions[idx][facTurfCaptureRank],
        Factions[idx][facSafeDepositRank], Factions[idx][facSafeWithdrawRank], Factions[idx][facLockerDepositRank], Factions[idx][facLockerWithdrawRank], Factions[idx][facLockerGunRank],
        Factions[idx][facVehicleLockRank], Factions[idx][facVehicleTrackRank], Factions[idx][facVehicleParkRank], Factions[idx][facBusinessSafeDepositRank], Factions[idx][facBusinessSafeWithdrawRank], Factions[idx][facBusinessRestockRank], Factions[idx][facBusinessLockRank], Factions[idx][facDoorLockRank]);
    ShowPlayerDialog(playerid, DIALOG_FACTION_PERMS, DIALOG_STYLE_LIST, "Faction Permissions", list, "Edit", "Back");
    return 1;
}

stock ER_ShowFactionLockerEditor(playerid, fid)
{
    new caption[64];
    format(caption, sizeof(caption), "Faction %d Locker", fid);
    ShowPlayerDialog(playerid, DIALOG_FACTION_LOCKERS, DIALOG_STYLE_LIST, caption, "Create Locker\nEdit Lockers", "Select", "Back");
    return 1;
}

stock ER_SetFactionLockerPos(playerid, fid)
{
    new Float:x, Float:y, Float:z, q[256];
    GetPlayerPos(playerid, x, y, z);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `faction_lockers` SET `x`=%f,`y`=%f,`z`=%f,`interior`=%d,`vw`=%d,`enabled`=1 WHERE `faction_id`=%d LIMIT 1", x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), fid);
    mysql_tquery(MainPipeline, q);
    ER_Send(playerid, COLOR_GREEN, "Faction locker position saved.");
    return 1;
}

stock ER_SetFactionSafePos(playerid, fid)
{
    new Float:x, Float:y, Float:z, Float:a, q[256];
    GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `faction_safes` SET `x`=%f,`y`=%f,`z`=%f,`a`=%f,`interior`=%d,`vw`=%d,`enabled`=1 WHERE `faction_id`=%d LIMIT 1", x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), fid);
    mysql_tquery(MainPipeline, q);
    ER_Send(playerid, COLOR_GREEN, "Faction safe position saved.");
    return 1;
}


stock ER_GetFactionLockerID(fid)
{
    new q[160]; mysql_format(MainPipeline, q, sizeof(q), "SELECT `id` FROM `faction_lockers` WHERE `faction_id`=%d AND `enabled`=1 LIMIT 1", fid);
    new Cache:res = mysql_query(MainPipeline, q);
    new rows, lockerid = 0; cache_get_row_count(rows);
    if(rows > 0) cache_get_value_name_int(0, "id", lockerid);
    cache_delete(res);
    return lockerid;
}

stock ER_ShowFacLockerWpnEdit(playerid, fid)
{
    SetPVarInt(playerid, "FactionLockerMode", 1);
    new lockerid = ER_GetFactionLockerID(fid);
    if(lockerid <= 0) return ER_Send(playerid, COLOR_GREY, "Create/set this faction locker first."), ER_ShowFactionLockerEditor(playerid, fid);
    new q[256]; mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `faction_locker_guns` WHERE `locker_id`=%d ORDER BY `id` ASC", lockerid);
    new Cache:res = mysql_query(MainPipeline, q);
    new rows; cache_get_row_count(rows);
    new list[2048], line[160], rankname[48], wname[32], weaponid, rank, div, gunid;
    for(new i; i < rows && i < 63; i++)
    {
        cache_get_value_name_int(i, "id", gunid);
        cache_get_value_name_int(i, "weaponid", weaponid);
        cache_get_value_name_int(i, "required_rank", rank);
        cache_get_value_name_int(i, "required_division", div);
        FactionLockerGunList[playerid][i] = gunid;
        ER_GetFactionRankName(fid, rank, rankname, sizeof(rankname));
        if(weaponid > 0) format(wname, sizeof(wname), "%s", ER_GetWeaponNameEx(weaponid)); else format(wname, sizeof(wname), "None");
        format(line, sizeof(line), "%d - (%d) %s - %s - Division %d\n", i + 1, weaponid, wname, rankname, div);
        strcat(list, line, sizeof(list));
    }
    SetPVarInt(playerid, "FactionLockerGunCount", rows < 63 ? rows : 63);
    strcat(list, "Add Weapon", sizeof(list));
    cache_delete(res);
    return ShowPlayerDialog(playerid, DIALOG_FACTION_LOCKER_WEAPONS, DIALOG_STYLE_LIST, "Faction Locker Weapons", list, "Select", "Back");
}

stock ER_ShowFactionLockerWeaponEdit(playerid, gunid)
{
    SetPVarInt(playerid, "FactionLockerGunID", gunid);
    new q[160]; mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `faction_locker_guns` WHERE `id`=%d LIMIT 1", gunid);
    new Cache:res = mysql_query(MainPipeline, q);
    new rows; cache_get_row_count(rows);
    if(rows <= 0) { cache_delete(res); return ER_ShowFacLockerWpnEdit(playerid, GetPVarInt(playerid, "EditingFaction")); }
    new weaponid, rank, div, rankname[48], divname[48], wname[32], list[512];
    cache_get_value_name_int(0, "weaponid", weaponid);
    cache_get_value_name_int(0, "required_rank", rank);
    cache_get_value_name_int(0, "required_division", div);
    cache_delete(res);
    ER_GetFactionRankName(GetPVarInt(playerid, "EditingFaction"), rank, rankname, sizeof(rankname));
    ER_GetFactionDivisionName(GetPVarInt(playerid, "EditingFaction"), div, divname, sizeof(divname));
    if(weaponid > 0) format(wname, sizeof(wname), "%s", ER_GetWeaponNameEx(weaponid)); else format(wname, sizeof(wname), "None");
    format(list, sizeof(list), "Select Weapon: (%d) %s\nRank: %s\nDivision: %s", weaponid, wname, rankname, divname);
    return ShowPlayerDialog(playerid, DIALOG_FACTION_LOCKER_WEAPON_EDIT, DIALOG_STYLE_LIST, "Edit Locker Weapon", list, "Select", "Back");
}

stock ER_AddFactionLockerWeapon(playerid, fid)
{
    new lockerid = ER_GetFactionLockerID(fid), q[220];
    if(lockerid <= 0) return ER_Send(playerid, COLOR_GREY, "Create/set this faction locker first."), 1;
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `faction_locker_guns` (`locker_id`,`weaponid`,`required_rank`,`required_division`,`admin_enabled`,`leader_enabled`) VALUES (%d,0,1,0,1,1)", lockerid);
    mysql_tquery(MainPipeline, q);
    ER_Send(playerid, COLOR_GREEN, "Empty locker weapon slot added. Reopen Edit Lockers to edit it.");
    return 1;
}

stock ER_ShowFactionPlayerWeapons(playerid)
{
    SetPVarInt(playerid, "FactionLockerMode", 2);
    new fid = PlayerInfo[playerid][pFaction], lockerid = ER_GetFactionLockerID(fid);
    if(lockerid <= 0) return ER_Send(playerid, COLOR_GREY, "Your faction does not have a locker set."), 1;
    new q[256]; mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `faction_locker_guns` WHERE `locker_id`=%d AND `weaponid`>0 ORDER BY `id` ASC", lockerid);
    new Cache:res = mysql_query(MainPipeline, q);
    new rows; cache_get_row_count(rows);
    new list[2048], line[160], prefix[16], weaponid, rank, div, gunid, allowed;
    for(new i; i < rows && i < 63; i++)
    {
        cache_get_value_name_int(i, "id", gunid); cache_get_value_name_int(i, "weaponid", weaponid); cache_get_value_name_int(i, "required_rank", rank); cache_get_value_name_int(i, "required_division", div);
        FactionLockerGunList[playerid][i] = gunid;
        allowed = (PlayerInfo[playerid][pFactionRank] >= rank && (div == 0 || PlayerInfo[playerid][pFactionDivision] == div));
        if(allowed) prefix[0] = EOS; else format(prefix, sizeof(prefix), "{AAAAAA}LOCKED ");
        format(line, sizeof(line), "%s(%d) %s - Rank %d - Division %d\n", prefix, weaponid, ER_GetWeaponNameEx(weaponid), rank, div);
        strcat(list, line, sizeof(list));
    }
    SetPVarInt(playerid, "FactionLockerGunCount", rows < 63 ? rows : 63);
    cache_delete(res);
    if(isnull(list)) return ER_Send(playerid, COLOR_GREY, "No locker weapons are configured."), 1;
    return ShowPlayerDialog(playerid, DIALOG_FACTION_LOCKER_WEAPONS, DIALOG_STYLE_LIST, "Faction Locker Weapons", list, "Take", "Back");
}


stock ER_FactionPermsAreDefault(idx)
{
    if(idx == -1) return 1;
    return (Factions[idx][facSetMOTDRank] == 5 &&
        Factions[idx][facInviteKickRank] == 5 &&
        Factions[idx][facPointCaptureRank] == 5 &&
        Factions[idx][facTurfCaptureRank] == 5 &&
        Factions[idx][facSafeDepositRank] == 1 &&
        Factions[idx][facSafeWithdrawRank] == 5 &&
        Factions[idx][facLockerDepositRank] == 1 &&
        Factions[idx][facLockerWithdrawRank] == 5 &&
        Factions[idx][facLockerGunRank] == 1 &&
        Factions[idx][facVehicleLockRank] == 5 &&
        Factions[idx][facVehicleTrackRank] == 5 &&
        Factions[idx][facVehicleParkRank] == 5 &&
        Factions[idx][facBusinessSafeDepositRank] == 5 &&
        Factions[idx][facBusinessSafeWithdrawRank] == 5 &&
        Factions[idx][facBusinessRestockRank] == 5 &&
        Factions[idx][facBusinessLockRank] == 5 &&
        Factions[idx][facDoorLockRank] == 5);
}

stock ER_ShowFactionEditor(playerid, fid)
{
    SetPVarInt(playerid, "EditingFaction", fid);
    new idx = ER_FindFactionIndexBySQLID(fid), list[1280], typeName[48], deptColor[32], divColor[32], leader[MAX_PLAYER_NAME_EX], status[16], permText[16];
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid faction."), 1;
    ER_GetFactionTypeName(Factions[idx][facType], typeName, sizeof(typeName));
    ER_GetNamedColorDisplayByValue(Factions[idx][facRadioColor], deptColor, sizeof(deptColor));
    ER_GetNamedColorDisplayByValue(Factions[idx][facDivisionColor], divColor, sizeof(divColor));
    if(Factions[idx][facLeaderID] > 0 && strcmp(Factions[idx][facLeaderName], "Nobody", true)) format(leader, sizeof(leader), "%s", Factions[idx][facLeaderName]); else format(leader, sizeof(leader), "None");
    if(Factions[idx][facEnabled]) format(status, sizeof(status), "Enabled"); else format(status, sizeof(status), "Disabled");
    if(ER_FactionPermsAreDefault(idx)) format(permText, sizeof(permText), "Default"); else format(permText, sizeof(permText), "Custom");
    format(list, sizeof(list), "Name: %s\nType: %s\nLeader: %s\nMOTD: %s\nDepartment Chat Color: %s\nDivision Chat Color: %s\nRanks: 6 Ranks\nDivisions: 3 Divisions\nLockers\nSafes\nPermissions: %s\nStatus: %s\nReload This Faction",
        Factions[idx][facName], typeName, leader, Factions[idx][facMOTD], deptColor, divColor, permText, status);
    ShowPlayerDialog(playerid, DIALOG_FACTION_EDITOR, DIALOG_STYLE_LIST, "Faction Editor", list, "Select", "Close");
    return 1;
}

stock ER_SetFactionLeaderAccount(playerid, fid, accountid, const accountName[])
{
    if(fid <= 0 || accountid <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid account."), 1;

    // MySQL R41 on this setup is not accepting multi-statement queries.
    // Send each UPDATE separately so setting a leader cannot fail with SQL error 1064.
    new q[384];
    new idx = ER_FindFactionIndexBySQLID(fid);
    new oldLeader = (idx != -1) ? Factions[idx][facLeaderID] : 0;

    // If this faction already had a different leader, remove that old leader from this faction.
    if(oldLeader > 0 && oldLeader != accountid)
    {
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `faction_id`=0,`faction_rank`=0,`faction_division`=0 WHERE `id`=%d AND `faction_id`=%d", oldLeader, fid);
        mysql_tquery(MainPipeline, q);
        foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pID] == oldLeader && PlayerInfo[i][pFaction] == fid)
        {
            PlayerInfo[i][pFaction] = 0;
            PlayerInfo[i][pFactionRank] = 0;
            PlayerInfo[i][pFactionDivision] = 0;
        }
    }

    // Clear this account as leader anywhere else before assigning the new faction.
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `leader_id`=0,`leader_name`='Nobody' WHERE `leader_id`=%d", accountid);
    mysql_tquery(MainPipeline, q);

    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `leader_id`=0,`leader_name`='Nobody' WHERE `leader_id`=%d AND `id`<>%d", accountid, fid);
    mysql_tquery(MainPipeline, q);

    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `family_id`=0,`family_rank`=0,`family_crew`=0,`faction_id`=%d,`faction_rank`=6,`faction_division`=0 WHERE `id`=%d", fid, accountid);
    mysql_tquery(MainPipeline, q);

    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `leader_id`=%d,`leader_name`='%e' WHERE `id`=%d", accountid, accountName, fid);
    mysql_tquery(MainPipeline, q);

    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pID] == accountid)
    {
        PlayerInfo[i][pFamily] = 0;
        PlayerInfo[i][pFamilyRank] = 0;
        PlayerInfo[i][pFamilyCrew] = 0;
        PlayerInfo[i][pFaction] = fid;
        PlayerInfo[i][pFactionRank] = 6;
        PlayerInfo[i][pFactionDivision] = 0;
    }

    if(idx != -1)
    {
        Factions[idx][facLeaderID] = accountid;
        format(Factions[idx][facLeaderName], MAX_PLAYER_NAME_EX, "%s", accountName);
    }

    ER_RecountAllFamilyMembers();
    ER_RecountAllFactionMembers();
    ER_LoadFamilies(); ER_LoadFactions();
    new msg[128]; format(msg, sizeof(msg), "Faction leader set to %s (PID %d).", accountName, accountid); ER_Send(playerid, COLOR_GREEN, msg);
    return ER_ShowFactionEditor(playerid, fid);
}
forward ER_OnFactionLeaderOfflineList(playerid);
public ER_OnFactionLeaderOfflineList(playerid)
{
    new rows; cache_get_row_count(rows); new list[4096], line[96], name[MAX_PLAYER_NAME_EX], id; if(rows > 100) rows = 100;
    for(new r; r < rows; r++) { cache_get_value_name_int(r, "id", id); cache_get_value_name(r, "username", name, sizeof(name)); FactionLeaderSelectSQL[playerid][r] = id; format(FactionLeaderSelectName[playerid][r], MAX_PLAYER_NAME_EX, "%s", name); format(line, sizeof(line), "ID: %d - %s\n", id, name); strcat(list, line, sizeof(list)); }
    if(!rows) return ER_Send(playerid, COLOR_GREY, "No accounts found."), 1;
    ShowPlayerDialog(playerid, DIALOG_FACTION_LEADER_OFFLINE, DIALOG_STYLE_LIST, "Select Offline Faction Leader", list, "Set", "Back");
    return 1;
}

CMD:editfactions(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new list[2048];
    for(new i; i < FactionCount; i++) format(list, sizeof(list), "%s%d | %s | Leader: %s\n", list, Factions[i][facSQLID], Factions[i][facName], Factions[i][facLeaderName]);
    if(!FactionCount) return ER_Send(playerid, COLOR_GREY, "No factions found.");
    ShowPlayerDialog(playerid, DIALOG_FACTION_LIST, DIALOG_STYLE_LIST, "Select Faction", list, "Edit", "Cancel");
    return 1;
}
CMD:editfaction(playerid, params[])
{
    new fid;
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "d", fid)) return ER_Send(playerid, COLOR_GREY, "USAGE: /editfaction [id]");
    return ER_ShowFactionEditor(playerid, fid);
}
CMD:factionsettings(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] <= 0 || PlayerInfo[playerid][pFactionRank] < 6) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    return ER_ShowFactionEditor(playerid, PlayerInfo[playerid][pFaction]);
}

stock ER_FactionDialog(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_FACTION_LIST)
    {
        if(response && listitem >= 0 && listitem < FactionCount) ER_ShowFactionEditor(playerid, Factions[listitem][facSQLID]);
        return 1;
    }
    if(dialogid == DIALOG_FACTION_EDITOR)
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0: { SetPVarInt(playerid, "FactionInputField", 1); ShowPlayerDialog(playerid, DIALOG_FACTION_INPUT, DIALOG_STYLE_INPUT, "Faction Name", "Enter new faction name:", "Save", "Back"); }
            case 1: { SetPVarInt(playerid, "FactionInputField", 4); ShowPlayerDialog(playerid, DIALOG_FACTION_INPUT, DIALOG_STYLE_LIST, "Faction Type", "None\nPolice Department\nGovernment\nEMS / Fire Department\nNews Agency\nCriminal Faction\nFederal Agency\nCorrections / Prison", "Save", "Back"); }
            case 2: { ShowPlayerDialog(playerid, DIALOG_FACTION_LEADER_TYPE, DIALOG_STYLE_LIST, "Faction Leader", "Online Player\nOffline Player\nClear Leader", "Select", "Back"); }
            case 3: { SetPVarInt(playerid, "FactionInputField", 2); ShowPlayerDialog(playerid, DIALOG_FACTION_INPUT, DIALOG_STYLE_INPUT, "Faction MOTD", "Enter new faction MOTD:", "Save", "Back"); }
            case 4: { SetPVarInt(playerid, "FactionColorField", 1); ER_ShowNamedColorDialog(playerid, DIALOG_FACTION_COLOR_SELECT, "Department Chat Color"); }
            case 5: { SetPVarInt(playerid, "FactionColorField", 2); ER_ShowNamedColorDialog(playerid, DIALOG_FACTION_COLOR_SELECT, "Division Chat Color"); }
            case 6: return ER_ShowFactionRanksEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
            case 7: return ER_ShowFactionDivisionsEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
            case 8: return ER_ShowFactionLockerEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
            case 9: return ER_ShowFactionLockerEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
            case 10: return ER_ShowFactionPermsEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
            case 11: { SetPVarInt(playerid, "FactionInputField", 50); ShowPlayerDialog(playerid, DIALOG_FACTION_INPUT, DIALOG_STYLE_LIST, "Faction Status", "Enabled\nDisabled", "Save", "Back"); }
            case 12: { ER_LoadFactions(); ER_Send(playerid, COLOR_GREEN, "Factions reloaded."); }
        }
        return 1;
    }
    if(dialogid == DIALOG_FACTION_RANKS)
    {
        if(!response) return ER_ShowFactionEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
        SetPVarInt(playerid, "FactionInputField", 10 + listitem);
        ShowPlayerDialog(playerid, DIALOG_FACTION_INPUT, DIALOG_STYLE_INPUT, "Edit Faction Rank", "Enter new rank name:", "Save", "Back");
        return 1;
    }
    if(dialogid == DIALOG_FACTION_DIVISIONS)
    {
        if(!response) return ER_ShowFactionEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
        SetPVarInt(playerid, "FactionInputField", 20 + listitem);
        ShowPlayerDialog(playerid, DIALOG_FACTION_INPUT, DIALOG_STYLE_INPUT, "Edit Faction Division", "Enter new division name:", "Save", "Back");
        return 1;
    }
    if(dialogid == DIALOG_FACTION_PERMS)
    {
        if(!response) return ER_ShowFactionEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
        SetPVarInt(playerid, "FactionInputField", 30 + listitem);
        ShowPlayerDialog(playerid, DIALOG_FACTION_INPUT, DIALOG_STYLE_INPUT, "Edit Permission Rank", "Enter minimum rank 1-6. Players with this rank or higher can use it:", "Save", "Back");
        return 1;
    }
    if(dialogid == DIALOG_FACTION_LOCKERS)
    {
        if(!response) return ER_ShowFactionEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
        new fid = GetPVarInt(playerid, "EditingFaction");
        if(listitem == 0) return ER_SetFactionLockerPos(playerid, fid), ER_ShowFactionEditor(playerid, fid);
        if(listitem == 1) return ER_ShowFacLockerWpnEdit(playerid, fid);
        return 1;
    }
    if(dialogid == DIALOG_FACTION_PLAYER_LOCKER)
    {
        if(!response) return 1;
        if(listitem == 0) return ER_ShowFactionPlayerWeapons(playerid);
        if(listitem == 1) return ER_Send(playerid, COLOR_GREEN, "Faction materials locker selected.");
        if(listitem == 2) return ER_Send(playerid, COLOR_GREEN, "Faction safe selected.");
        if(listitem == 3) return ER_Send(playerid, COLOR_GREEN, "Faction uniform selected.");
        return 1;
    }
    if(dialogid == DIALOG_FACTION_LOCKER_WEAPONS)
    {
        if(!response)
        {
            if(GetPVarInt(playerid, "FactionLockerMode") == 1) return ER_ShowFactionLockerEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
            return ShowPlayerDialog(playerid, DIALOG_FACTION_PLAYER_LOCKER, DIALOG_STYLE_LIST, "Faction Locker", "Weapons\nMaterials\nSafe\nUniform", "Select", "Close");
        }
        new count = GetPVarInt(playerid, "FactionLockerGunCount"), mode = GetPVarInt(playerid, "FactionLockerMode");
        if(mode == 1)
        {
            if(listitem == count) return ER_AddFactionLockerWeapon(playerid, GetPVarInt(playerid, "EditingFaction")), ER_ShowFacLockerWpnEdit(playerid, GetPVarInt(playerid, "EditingFaction"));
            if(listitem >= 0 && listitem < count) return ER_ShowFactionLockerWeaponEdit(playerid, FactionLockerGunList[playerid][listitem]);
            return 1;
        }
        if(mode == 2 && listitem >= 0 && listitem < count)
        {
            new gunid = FactionLockerGunList[playerid][listitem], q[160];
            mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `faction_locker_guns` WHERE `id`=%d LIMIT 1", gunid);
            new Cache:res = mysql_query(MainPipeline, q);
            new rows; cache_get_row_count(rows);
            if(rows <= 0) { cache_delete(res); return 1; }
            new weaponid, rank, div; cache_get_value_name_int(0, "weaponid", weaponid); cache_get_value_name_int(0, "required_rank", rank); cache_get_value_name_int(0, "required_division", div); cache_delete(res);
            if(PlayerInfo[playerid][pFactionRank] < rank || (div > 0 && PlayerInfo[playerid][pFactionDivision] != div)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to use this locker weapon.");
            new matCost = ER_GetWeaponMatCost(weaponid), lockerid = ER_GetFactionLockerID(PlayerInfo[playerid][pFaction]);
            if(matCost < 0) return ER_Send(playerid, COLOR_GREY, "This weapon has no enabled material-cost row.");
            mysql_format(MainPipeline, q, sizeof(q), "SELECT `materials` FROM `faction_lockers` WHERE `id`=%d LIMIT 1", lockerid);
            res = mysql_query(MainPipeline, q);
            cache_get_row_count(rows);
            new materials;
            if(rows > 0) cache_get_value_name_int(0, "materials", materials);
            cache_delete(res);
            if(materials < matCost) return ER_Send(playerid, COLOR_GREY, "Your faction locker does not have enough materials for this weapon.");
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `faction_lockers` SET `materials`=`materials`-%d WHERE `id`=%d", matCost, lockerid);
            mysql_tquery(MainPipeline, q);
            GivePlayerWeapon(playerid, weaponid, 99999);
            return ER_Send(playerid, COLOR_GREEN, "Weapon taken from locker. Materials deducted.");
        }
        return 1;
    }
    if(dialogid == DIALOG_FACTION_LOCKER_WEAPON_EDIT)
    {
        if(!response) return ER_ShowFacLockerWpnEdit(playerid, GetPVarInt(playerid, "EditingFaction"));
        if(listitem == 0) return ShowPlayerDialog(playerid, DIALOG_FACTION_LOCKER_WEAPON_SELECT, DIALOG_STYLE_INPUT, "Select Weapon", "Enter weapon ID, or 0 for None:", "Save", "Back");
        if(listitem == 1) return ShowPlayerDialog(playerid, DIALOG_FACTION_LOCKER_WEAPON_RANK, DIALOG_STYLE_INPUT, "Weapon Rank", "Enter minimum rank 1-6:", "Save", "Back");
        if(listitem == 2) return ShowPlayerDialog(playerid, DIALOG_FACTION_LOCKER_WEAPON_DIVISION, DIALOG_STYLE_LIST, "Weapon Division", "1 - (0) None\n2 - (1) Division 1\n3 - (2) Division 2\n4 - (3) Division 3", "Save", "Back");
        return 1;
    }
    if(dialogid == DIALOG_FACTION_LOCKER_WEAPON_SELECT || dialogid == DIALOG_FACTION_LOCKER_WEAPON_RANK || dialogid == DIALOG_FACTION_LOCKER_WEAPON_DIVISION)
    {
        if(!response) return ER_ShowFactionLockerWeaponEdit(playerid, GetPVarInt(playerid, "FactionLockerGunID"));
        new gunid = GetPVarInt(playerid, "FactionLockerGunID"), q[160];
        if(dialogid == DIALOG_FACTION_LOCKER_WEAPON_SELECT)
        {
            new wid;
            if(!strcmp(inputtext, "0", true) || !strcmp(inputtext, "none", true)) wid = 0;
            else
            {
                wid = ER_ResolveWeaponMaterial(inputtext);
                if(wid == -2) return ER_Send(playerid, COLOR_GREY, "That partial weapon name matches more than one weapon. Type more letters."), ER_ShowFactionLockerWeaponEdit(playerid, gunid);
                if(wid <= 0) return ER_Send(playerid, COLOR_GREY, "Weapon not found in weapon_material_costs or is disabled."), ER_ShowFactionLockerWeaponEdit(playerid, gunid);
            }
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `faction_locker_guns` SET `weaponid`=%d WHERE `id`=%d", wid, gunid);
        }
        else if(dialogid == DIALOG_FACTION_LOCKER_WEAPON_RANK)
        {
            new rank = strval(inputtext); if(rank < 1 || rank > 6) return ER_Send(playerid, COLOR_GREY, "Enter a rank from 1 to 6."), ER_ShowFactionLockerWeaponEdit(playerid, gunid);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `faction_locker_guns` SET `required_rank`=%d WHERE `id`=%d", rank, gunid);
        }
        else mysql_format(MainPipeline, q, sizeof(q), "UPDATE `faction_locker_guns` SET `required_division`=%d WHERE `id`=%d", listitem, gunid);
        mysql_tquery(MainPipeline, q);
        return ER_ShowFactionLockerWeaponEdit(playerid, gunid);
    }
    if(dialogid == DIALOG_FACTION_INPUT)
    {
        if(!response) return ER_ShowFactionEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
        new fid = GetPVarInt(playerid, "EditingFaction"), field = GetPVarInt(playerid, "FactionInputField"), q[384];
        if(field == 1) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `name`='%e' WHERE `id`=%d", inputtext, fid);
        else if(field == 2) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `motd`='%e' WHERE `id`=%d", inputtext, fid);
        else if(field == 4) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `type`=%d WHERE `id`=%d", listitem, fid);
        else if(field == 3)
        {
            if(!strcmp(inputtext, "0", true) || !strcmp(inputtext, "Nobody", true)) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `leader_id`=0,`leader_name`='Nobody' WHERE `id`=%d", fid);
            else mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` f LEFT JOIN `accounts` a ON a.`username`='%e' SET f.`leader_id`=IFNULL(a.`id`,0), f.`leader_name`='%e' WHERE f.`id`=%d", inputtext, inputtext, fid);
        }
        else if(field >= 10 && field < 16)
        {
            new rankid = field - 9;
            mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `faction_ranks` (`faction_id`,`rank_id`,`rank_name`) VALUES (%d,%d,'%e') ON DUPLICATE KEY UPDATE `rank_name`=VALUES(`rank_name`)", fid, rankid, inputtext);
        }
        else if(field >= 20 && field < 23)
        {
            new divid = field - 19;
            mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `faction_divisions` (`faction_id`,`division_id`,`division_name`) VALUES (%d,%d,'%e') ON DUPLICATE KEY UPDATE `division_name`=VALUES(`division_name`)", fid, divid, inputtext);
        }
        else if(field >= 30 && field < 47)
        {
            new rank = strval(inputtext); if(rank < 1 || rank > 6) return ER_Send(playerid, COLOR_GREY, "Enter a rank from 1 to 6."), ER_ShowFactionPermsEditor(playerid, fid);
            new col[32];
            switch(field - 30)
            {
                case 0: format(col, sizeof(col), "set_motd_rank");
                case 1: format(col, sizeof(col), "invite_kick_rank");
                case 2: format(col, sizeof(col), "point_capture_rank");
                case 3: format(col, sizeof(col), "turf_capture_rank");
                case 4: format(col, sizeof(col), "safe_deposit_rank");
                case 5: format(col, sizeof(col), "safe_withdraw_rank");
                case 6: format(col, sizeof(col), "locker_deposit_rank");
                case 7: format(col, sizeof(col), "locker_withdraw_rank");
                case 8: format(col, sizeof(col), "locker_gun_rank");
                case 9: format(col, sizeof(col), "vehicle_lock_rank");
                case 10: format(col, sizeof(col), "vehicle_track_rank");
                case 11: format(col, sizeof(col), "vehicle_park_rank");
                case 12: format(col, sizeof(col), "business_safe_deposit_rank");
                case 13: format(col, sizeof(col), "business_safe_withdraw_rank");
                case 14: format(col, sizeof(col), "business_restock_rank");
                case 15: format(col, sizeof(col), "business_lock_rank");
                case 16: format(col, sizeof(col), "door_lock_rank");
            }
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `%s`=%d WHERE `id`=%d", col, rank, fid);
        }
        else if(field == 50) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `enabled`=%d WHERE `id`=%d", listitem == 0 ? 1 : 0, fid);
        else return ER_ShowFactionEditor(playerid, fid);
        mysql_tquery(MainPipeline, q); ER_LoadFactions(); return ER_ShowFactionEditor(playerid, fid);
    }
    if(dialogid == DIALOG_FACTION_COLOR_SELECT)
    {
        if(!response) return ER_ShowFactionEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
        new fid = GetPVarInt(playerid, "EditingFaction"), field = GetPVarInt(playerid, "FactionColorField"), color = ER_GetNamedColorValue(listitem), q[160];
        if(field == 1) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `radio_color`=%d,`color`=%d WHERE `id`=%d", color, color, fid);
        else mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `division_color`=%d WHERE `id`=%d", color, fid);
        mysql_tquery(MainPipeline, q); ER_LoadFactions(); return ER_ShowFactionEditor(playerid, fid);
    }

    if(dialogid == DIALOG_FACTION_LEADER_TYPE)
    {
        if(!response) return ER_ShowFactionEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
        if(listitem == 0) return ShowPlayerDialog(playerid, DIALOG_FACTION_LEADER_ONLINE, DIALOG_STYLE_INPUT, "Online Faction Leader", "Enter online player ID or part of name:", "Set", "Back");
        if(listitem == 1) { mysql_tquery(MainPipeline, "SELECT `id`,`username` FROM `accounts` ORDER BY `username` ASC LIMIT 100", "ER_OnFactionLeaderOfflineList", "i", playerid); return 1; }
        new fid = GetPVarInt(playerid, "EditingFaction"), q[256];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `leader_id`=0,`leader_name`='Nobody' WHERE `id`=%d", fid); mysql_tquery(MainPipeline, q); ER_LoadFactions(); return ER_ShowFactionEditor(playerid, fid);
    }
    if(dialogid == DIALOG_FACTION_LEADER_ONLINE)
    {
        if(!response) return ER_ShowFactionEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
        new target; if(sscanf(inputtext, "u", target) || !IsPlayerConnected(target)) return ER_Send(playerid, COLOR_GREY, "Player not found."), ER_ShowFactionEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
        return ER_SetFactionLeaderAccount(playerid, GetPVarInt(playerid, "EditingFaction"), PlayerInfo[target][pID], PlayerInfo[target][pName]);
    }
    if(dialogid == DIALOG_FACTION_LEADER_OFFLINE)
    {
        if(!response) return ER_ShowFactionEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
        new accountid = FactionLeaderSelectSQL[playerid][listitem]; if(accountid <= 0) return ER_ShowFactionEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
        new name[MAX_PLAYER_NAME_EX]; format(name, sizeof(name), "%s", FactionLeaderSelectName[playerid][listitem]);
        return ER_SetFactionLeaderAccount(playerid, GetPVarInt(playerid, "EditingFaction"), accountid, name);
    }
    if(dialogid == DIALOG_FACTION_DIV_INVITE)
    {
        if(!response) return 1;
        new div = listitem, target = FactionDivSelectTarget[playerid];
        if(!IsPlayerConnected(target)) return 1;
        if(FactionDivSelectMode[playerid] == 2)
        {
            PlayerInfo[target][pFactionDivision] = div;
            new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `faction_division`=%d WHERE `id`=%d", div, PlayerInfo[target][pID]); mysql_tquery(MainPipeline, q);
            ER_Send(playerid, COLOR_GREEN, "Division updated."); ER_Send(target, COLOR_GREEN, "Your division was updated.");
        }
        else
        {
            SetPVarInt(target, "PendingDivisionInvite", div);
            ER_Send(target, COLOR_YELLOW, "You received a division invite. Use /accept division.");
            ER_Send(playerid, COLOR_GREEN, "Division invite sent.");
        }
        return 1;
    }
    return 0;
}

stock ER_ShowLoginMOTDs(playerid)
{
    if(PlayerInfo[playerid][pFamily] > 0) ER_SendFamilyMOTD(playerid);
    if(PlayerInfo[playerid][pFaction] > 0) ER_SendFactionMOTD(playerid);
    if(PlayerInfo[playerid][pAdmin] >= ADMIN_MOD) SendClientMessage(playerid, COLOR_YELLOW, "Admin MOTD: None");
    return 1;
}
