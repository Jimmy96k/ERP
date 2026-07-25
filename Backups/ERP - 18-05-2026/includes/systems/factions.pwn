#if defined _ER_FACTIONS_INCLUDED
    #endinput
#endif
#define _ER_FACTIONS_INCLUDED

#define MAX_FACTIONS 100
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
        cache_get_value_name_int(r, "business_safe_deposit_rank", Factions[FactionCount][facBusinessSafeDepositRank]);
        cache_get_value_name_int(r, "business_safe_withdraw_rank", Factions[FactionCount][facBusinessSafeWithdrawRank]);
        cache_get_value_name_int(r, "business_restock_rank", Factions[FactionCount][facBusinessRestockRank]);
        cache_get_value_name_int(r, "business_lock_rank", Factions[FactionCount][facBusinessLockRank]);
        cache_get_value_name_int(r, "door_lock_rank", Factions[FactionCount][facDoorLockRank]);
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
    for(new r; r < 6; r++) { mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `faction_ranks` (`faction_id`,`rank_id`,`rank_name`) VALUES (%d,%d,'%e')", fid, r+1, ranks[r]); mysql_tquery(MainPipeline, q); }
    new divs[3][32] = {"Patrol Division", "Investigations Division", "Command Division"};
    for(new d; d < 3; d++) { mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `faction_divisions` (`faction_id`,`division_id`,`division_name`) VALUES (%d,%d,'%e')", fid, d+1, divs[d]); mysql_tquery(MainPipeline, q); }
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `faction_lockers` (`faction_id`,`materials`,`pot`,`crack`,`enabled`) VALUES (%d,0,0,0,0)", fid); mysql_tquery(MainPipeline, q, "ER_OnDefaultFactionLocker", "i", fid);
    return 1;
}

CMD:createfaction(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /createfaction [name]");
    new q[700];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `factions` (`name`,`type`,`leader_id`,`leader_name`,`motd`,`members_count`,`set_motd_rank`,`invite_kick_rank`,`point_capture_rank`,`turf_capture_rank`,`safe_deposit_rank`,`safe_withdraw_rank`,`locker_deposit_rank`,`locker_withdraw_rank`,`locker_gun_rank`,`business_safe_deposit_rank`,`business_safe_withdraw_rank`,`business_restock_rank`,`business_lock_rank`,`door_lock_rank`,`color`,`radio_color`,`division_color`,`enabled`) VALUES ('%e',0,%d,'%e','Welcome to the faction.',1,5,5,5,5,1,5,1,5,1,5,5,5,5,5,%d,%d,%d,1)", params, PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], FACTION_CHAT_COLOR_DEFAULT, FACTION_CHAT_COLOR_DEFAULT, FACTION_DIV_COLOR_DEFAULT);
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

    format(msg, sizeof(msg), "(( Department | %s | Division: %s )) %s: %s", rankname, divname, dname, text);
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
    for(new d = 1; d <= 3 && d <= MAX_FACTION_DIVISIONS; d++)
    {
        ER_GetFactionDivisionName(fid, d, name, sizeof(name));
        format(list, sizeof(list), "%s%d - %s\n", list, d, name);
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
    new idx = ER_FindFactionIndexBySQLID(fid), list[768];
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid faction."), 1;
    format(list, sizeof(list),
        "Set MOTD >= %d\nInvite & Kick >= %d\nPoint Capture >= %d\nTurf Capture >= %d\nSafe Deposit >= %d\nSafe Withdraw >= %d\nLocker Deposit >= %d\nLocker Withdraw >= %d\nGun Locker >= %d",
        Factions[idx][facSetMOTDRank], Factions[idx][facInviteKickRank], Factions[idx][facPointCaptureRank], Factions[idx][facTurfCaptureRank],
        Factions[idx][facSafeDepositRank], Factions[idx][facSafeWithdrawRank], Factions[idx][facLockerDepositRank], Factions[idx][facLockerWithdrawRank], Factions[idx][facLockerGunRank]);
    ShowPlayerDialog(playerid, DIALOG_FACTION_PERMS, DIALOG_STYLE_LIST, "Faction Permissions", list, "Edit", "Back");
    return 1;
}

stock ER_ShowFactionLockerEditor(playerid, fid)
{
    new caption[64];
    format(caption, sizeof(caption), "Faction %d Locker", fid);
    ShowPlayerDialog(playerid, DIALOG_FACTION_LOCKERS, DIALOG_STYLE_LIST, caption, "Set Locker Position Here\nSet Safe Position Here\nGun Locker Weapons", "Select", "Back");
    return 1;
}

stock ER_SetFactionLockerPos(playerid, fid)
{
    new Float:x, Float:y, Float:z, Float:a, q[256];
    GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `faction_lockers` SET `x`=%f,`y`=%f,`z`=%f,`a`=%f,`interior`=%d,`vw`=%d,`enabled`=1 WHERE `faction_id`=%d LIMIT 1", x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), fid);
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

stock ER_ShowFactionEditor(playerid, fid)
{
    SetPVarInt(playerid, "EditingFaction", fid);
    ShowPlayerDialog(playerid, DIALOG_FACTION_EDITOR, DIALOG_STYLE_LIST, "Faction Editor", "Name\nType\nLeader\nMOTD\nDepartment Chat Color\nDivision Chat Color\nRanks\nDivisions\nLockers\nSafes\nPermissions\nStatus\nReload This Faction", "Select", "Close");
    return 1;
}

stock ER_SetFactionLeaderAccount(playerid, fid, accountid, const accountName[])
{
    if(fid <= 0 || accountid <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid account."), 1;
    new q[768];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `leader_id`=0,`leader_name`='Nobody' WHERE `leader_id`=%d; UPDATE `factions` SET `leader_id`=0,`leader_name`='Nobody' WHERE `leader_id`=%d AND `id`<>%d; UPDATE `accounts` SET `family_id`=0,`family_rank`=0,`family_crew`=0,`faction_id`=%d,`faction_rank`=6,`faction_division`=0 WHERE `id`=%d; UPDATE `factions` SET `leader_id`=%d,`leader_name`='%e' WHERE `id`=%d", accountid, accountid, fid, fid, accountid, accountid, accountName, fid);
    mysql_tquery(MainPipeline, q);
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pID] == accountid) { PlayerInfo[i][pFamily] = 0; PlayerInfo[i][pFamilyRank] = 0; PlayerInfo[i][pFamilyCrew] = 0; PlayerInfo[i][pFaction] = fid; PlayerInfo[i][pFactionRank] = 6; PlayerInfo[i][pFactionDivision] = 0; }
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
        SetPVarInt(playerid, "FactionInputField", 10 + listitem + 1);
        ShowPlayerDialog(playerid, DIALOG_FACTION_INPUT, DIALOG_STYLE_INPUT, "Edit Faction Rank", "Enter new rank name:", "Save", "Back");
        return 1;
    }
    if(dialogid == DIALOG_FACTION_DIVISIONS)
    {
        if(!response) return ER_ShowFactionEditor(playerid, GetPVarInt(playerid, "EditingFaction"));
        SetPVarInt(playerid, "FactionInputField", 20 + listitem + 1);
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
        if(listitem == 0) ER_SetFactionLockerPos(playerid, fid);
        else if(listitem == 1) ER_SetFactionSafePos(playerid, fid);
        else ER_Send(playerid, COLOR_GREY, "Gun locker weapons are saved in SQL; use /gunlocker at the locker position to manage or use stored weapons.");
        return ER_ShowFactionEditor(playerid, fid);
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
        else if(field >= 10 && field < 20) mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `faction_ranks` (`faction_id`,`rank_id`,`rank_name`) VALUES (%d,%d,'%e') ON DUPLICATE KEY UPDATE `rank_name`=VALUES(`rank_name`)", fid, field - 9, inputtext);
        else if(field >= 20 && field < 30) mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `faction_divisions` (`faction_id`,`division_id`,`division_name`) VALUES (%d,%d,'%e') ON DUPLICATE KEY UPDATE `division_name`=VALUES(`division_name`)", fid, field - 19, inputtext);
        else if(field >= 30 && field < 45)
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
                case 9: format(col, sizeof(col), "business_safe_deposit_rank");
                case 10: format(col, sizeof(col), "business_safe_withdraw_rank");
                case 11: format(col, sizeof(col), "business_restock_rank");
                case 12: format(col, sizeof(col), "business_lock_rank");
                case 13: format(col, sizeof(col), "door_lock_rank");
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
        new div = listitem + 1, target = FactionDivSelectTarget[playerid];
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
