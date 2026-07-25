#if defined _ER_FAMILIES_INCLUDED
    #endinput
#endif
#define _ER_FAMILIES_INCLUDED

#define FAMILY_CHAT_COLOR_DEFAULT 0x33CCFFFF // cyan
#define FAMILY_CREW_COLOR_DEFAULT 0xFFFF00FF // yellow

new FamilyListSQL[MAX_PLAYERS][MAX_FAMILIES];
new FamilyCrewSelectTarget[MAX_PLAYERS];
new FamilyCrewSelectMode[MAX_PLAYERS]; // 1 invite, 2 set
new FamilyLeaderSelectSQL[MAX_PLAYERS][100];
new FamilyLeaderSelectName[MAX_PLAYERS][100][MAX_PLAYER_NAME_EX];
new FamilyLockerGunList[MAX_PLAYERS][64];

stock ER_FindFamilyIndexBySQLID(fid)
{
    for(new i; i < FamilyCount; i++) if(Families[i][fSQLID] == fid) return i;
    return -1;
}

stock ER_GetFamilyRankName(fid, rank, dest[], size)
{
    if(rank <= 0) return format(dest, size, "None");
    new idx = ER_FindFamilyIndexBySQLID(fid);
    if(idx == -1) return format(dest, size, "(%d) - Unknown", rank);
    new slot = rank - 1;
    if(slot >= 0 && slot < MAX_FAMILY_RANKS && !isnull(FamilyRankNames[idx][slot])) return format(dest, size, "(%d) - %s", rank, FamilyRankNames[idx][slot]);
    return format(dest, size, "(%d) - Rank %d", rank, rank);
}

stock ER_GetFamilyCrewName(fid, crew, dest[], size)
{
    if(crew <= 0) return format(dest, size, "None");
    new idx = ER_FindFamilyIndexBySQLID(fid);
    if(idx == -1) return format(dest, size, "(%d) - Unknown", crew);
    new slot = crew - 1;
    if(slot >= 0 && slot < MAX_FAMILY_CREWS && !isnull(FamilyCrewNames[idx][slot])) return format(dest, size, "(%d) - %s", crew, FamilyCrewNames[idx][slot]);
    return format(dest, size, "(%d) - Crew %d", crew, crew);
}

stock ER_LoadFamilies()
{
    mysql_tquery(MainPipeline, "SELECT * FROM `families` WHERE `enabled`=1", "ER_OnFamiliesLoad");
    return 1;
}
forward ER_OnFamiliesLoad();
public ER_OnFamiliesLoad()
{
    new rows; cache_get_row_count(rows); FamilyCount = 0;
    for(new r; r < rows && FamilyCount < MAX_FAMILIES; r++)
    {
        cache_get_value_name_int(r, "id", Families[FamilyCount][fSQLID]);
        cache_get_value_name(r, "name", Families[FamilyCount][fName], 64);
        cache_get_value_name_int(r, "leader_id", Families[FamilyCount][fLeaderID]);
        cache_get_value_name(r, "leader_name", Families[FamilyCount][fLeaderName], MAX_PLAYER_NAME_EX);
        cache_get_value_name(r, "motd", Families[FamilyCount][fMOTD], 128);
        cache_get_value_name_int(r, "members_count", Families[FamilyCount][fMembers]);
        cache_get_value_name_int(r, "color", Families[FamilyCount][fColor]);
        cache_get_value_name_int(r, "radio_color", Families[FamilyCount][fRadioColor]);
        cache_get_value_name_int(r, "crew_color", Families[FamilyCount][fCrewColor]);
        cache_get_value_name_int(r, "set_motd_rank", Families[FamilyCount][fSetMOTDRank]);
        cache_get_value_name_int(r, "invite_kick_rank", Families[FamilyCount][fInviteKickRank]);
        cache_get_value_name_int(r, "point_capture_rank", Families[FamilyCount][fPointCaptureRank]);
        cache_get_value_name_int(r, "turf_capture_rank", Families[FamilyCount][fTurfCaptureRank]);
        cache_get_value_name_int(r, "safe_deposit_rank", Families[FamilyCount][fSafeDepositRank]);
        cache_get_value_name_int(r, "safe_withdraw_rank", Families[FamilyCount][fSafeWithdrawRank]);
        cache_get_value_name_int(r, "locker_deposit_rank", Families[FamilyCount][fLockerDepositRank]);
        cache_get_value_name_int(r, "locker_withdraw_rank", Families[FamilyCount][fLockerWithdrawRank]);
        cache_get_value_name_int(r, "locker_gun_rank", Families[FamilyCount][fLockerGunRank]);
        cache_get_value_name_int(r, "vehicle_lock_rank", Families[FamilyCount][fVehicleLockRank]);
        cache_get_value_name_int(r, "vehicle_track_rank", Families[FamilyCount][fVehicleTrackRank]);
        cache_get_value_name_int(r, "vehicle_park_rank", Families[FamilyCount][fVehicleParkRank]);
        cache_get_value_name_int(r, "business_safe_deposit_rank", Families[FamilyCount][fBusinessSafeDepositRank]);
        cache_get_value_name_int(r, "business_safe_withdraw_rank", Families[FamilyCount][fBusinessSafeWithdrawRank]);
        cache_get_value_name_int(r, "business_restock_rank", Families[FamilyCount][fBusinessRestockRank]);
        cache_get_value_name_int(r, "business_lock_rank", Families[FamilyCount][fBusinessLockRank]);
        cache_get_value_name_int(r, "door_lock_rank", Families[FamilyCount][fDoorLockRank]);
        if(Families[FamilyCount][fVehicleLockRank] <= 0) Families[FamilyCount][fVehicleLockRank] = 5;
        if(Families[FamilyCount][fVehicleTrackRank] <= 0) Families[FamilyCount][fVehicleTrackRank] = 5;
        if(Families[FamilyCount][fVehicleParkRank] <= 0) Families[FamilyCount][fVehicleParkRank] = 5;
        if(Families[FamilyCount][fBusinessSafeDepositRank] <= 0) Families[FamilyCount][fBusinessSafeDepositRank] = 5;
        if(Families[FamilyCount][fBusinessSafeWithdrawRank] <= 0) Families[FamilyCount][fBusinessSafeWithdrawRank] = 5;
        if(Families[FamilyCount][fBusinessRestockRank] <= 0) Families[FamilyCount][fBusinessRestockRank] = 5;
        if(Families[FamilyCount][fBusinessLockRank] <= 0) Families[FamilyCount][fBusinessLockRank] = 5;
        if(Families[FamilyCount][fDoorLockRank] <= 0) Families[FamilyCount][fDoorLockRank] = 5;
        cache_get_value_name_int(r, "enabled", Families[FamilyCount][fEnabled]);
        if(Families[FamilyCount][fColor] == 0) Families[FamilyCount][fColor] = FAMILY_CHAT_COLOR_DEFAULT;
        if(Families[FamilyCount][fRadioColor] == 0) Families[FamilyCount][fRadioColor] = FAMILY_CHAT_COLOR_DEFAULT;
        if(Families[FamilyCount][fCrewColor] == 0) Families[FamilyCount][fCrewColor] = FAMILY_CREW_COLOR_DEFAULT;
        if(Families[FamilyCount][fInviteKickRank] <= 0) Families[FamilyCount][fInviteKickRank] = 5;
        FamilyCount++;
    }
    mysql_tquery(MainPipeline, "SELECT * FROM `family_ranks` ORDER BY `family_id`,`rank_id`", "ER_OnFamilyRanksLoad");
    mysql_tquery(MainPipeline, "SELECT * FROM `family_crews` ORDER BY `family_id`,`crew_id`", "ER_OnFamilyCrewsLoad");
    printf("[Families] Loaded %d families.", FamilyCount);
    return 1;
}
forward ER_OnFamilyRanksLoad();
public ER_OnFamilyRanksLoad()
{
    for(new i; i < MAX_FAMILIES; i++) for(new r; r < MAX_FAMILY_RANKS; r++) FamilyRankNames[i][r][0] = EOS;
    new rows; cache_get_row_count(rows);
    for(new row; row < rows; row++)
    {
        new fid, rank; cache_get_value_name_int(row, "family_id", fid); cache_get_value_name_int(row, "rank_id", rank);
        new idx = ER_FindFamilyIndexBySQLID(fid);
        if(idx != -1 && rank >= 1 && rank <= MAX_FAMILY_RANKS) cache_get_value_name(row, "rank_name", FamilyRankNames[idx][rank-1], 32);
    }
    return 1;
}
forward ER_OnFamilyCrewsLoad();
public ER_OnFamilyCrewsLoad()
{
    for(new i; i < MAX_FAMILIES; i++) for(new c; c < MAX_FAMILY_CREWS; c++) FamilyCrewNames[i][c][0] = EOS;
    new rows; cache_get_row_count(rows);
    for(new row; row < rows; row++)
    {
        new fid, crew; cache_get_value_name_int(row, "family_id", fid); cache_get_value_name_int(row, "crew_id", crew);
        new idx = ER_FindFamilyIndexBySQLID(fid);
        if(idx != -1 && crew >= 1 && crew <= MAX_FAMILY_CREWS) cache_get_value_name(row, "crew_name", FamilyCrewNames[idx][crew-1], 32);
    }
    return 1;
}

stock ER_RecountFamilyMembers(fid)
{
    new q[180];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `members_count`=(SELECT COUNT(*) FROM `accounts` WHERE `family_id`=%d) WHERE `id`=%d", fid, fid);
    mysql_tquery(MainPipeline, q);
    return 1;
}


stock ER_RecountAllFamilyMembers()
{
    mysql_tquery(MainPipeline, "UPDATE `families` f SET `members_count`=(SELECT COUNT(*) FROM `accounts` a WHERE a.`family_id`=f.`id`)");
    return 1;
}

stock ER_PlayerCanFamily(playerid, fid, required)
{
    if(PlayerInfo[playerid][pFamily] != fid || PlayerInfo[playerid][pFamilyRank] <= 0) return 0;
    return PlayerInfo[playerid][pFamilyRank] >= required;
}

stock ER_MovePlayerToFamily(playerid, fid, rank = 1, crew = 0, bool:force = false)
{
    if(!IsPlayerConnected(playerid) || !PlayerInfo[playerid][pLoggedIn]) return 0;
    if(ER_FindFamilyIndexBySQLID(fid) == -1) return 0;
    if(!force && (PlayerInfo[playerid][pFamily] > 0 || PlayerInfo[playerid][pFaction] > 0)) return 0;
    new oldfam = PlayerInfo[playerid][pFamily], oldfac = PlayerInfo[playerid][pFaction];
    PlayerInfo[playerid][pFamily] = fid; PlayerInfo[playerid][pFamilyRank] = rank; PlayerInfo[playerid][pFamilyCrew] = crew;
    PlayerInfo[playerid][pFaction] = 0; PlayerInfo[playerid][pFactionRank] = 0; PlayerInfo[playerid][pFactionDivision] = 0;
    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `family_id`=%d,`family_rank`=%d,`family_crew`=%d,`faction_id`=0,`faction_rank`=0,`faction_division`=0 WHERE `id`=%d", fid, rank, crew, PlayerInfo[playerid][pID]);
    mysql_tquery(MainPipeline, q);
    if(oldfam > 0 && oldfam != fid) ER_RecountFamilyMembers(oldfam);
    if(oldfac > 0) ER_RecountFactionMembers(oldfac);
    ER_RecountFamilyMembers(fid);
    return 1;
}

stock ER_RemovePlayerFromFamily(playerid, bool:force = false)
{
    if(PlayerInfo[playerid][pFamily] <= 0) return 0;
    new fid = PlayerInfo[playerid][pFamily], idx = ER_FindFamilyIndexBySQLID(fid);
    if(!force && idx != -1 && Families[idx][fLeaderID] == PlayerInfo[playerid][pID]) return 0;
    PlayerInfo[playerid][pFamily] = 0; PlayerInfo[playerid][pFamilyRank] = 0; PlayerInfo[playerid][pFamilyCrew] = 0;
    new q[160]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `family_id`=0,`family_rank`=0,`family_crew`=0 WHERE `id`=%d", PlayerInfo[playerid][pID]); mysql_tquery(MainPipeline, q);
    ER_RecountFamilyMembers(fid);
    return 1;
}

stock ER_CreateDefaultFamilyRows(fid)
{
    new q[384];
    new ranks[6][16] = {"Outsider", "Associate", "Soldier", "Captain", "Underboss", "Leader"};
    for(new r; r < 6; r++) { mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `family_ranks` (`family_id`,`rank_id`,`rank_name`) VALUES (%d,%d,'%e') ON DUPLICATE KEY UPDATE `rank_name`=VALUES(`rank_name`)", fid, r+1, ranks[r]); mysql_tquery(MainPipeline, q); }
    new crews[3][24] = {"Main Crew", "Street Crew", "Business Crew"};
    for(new c; c < 3; c++) { mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `family_crews` (`family_id`,`crew_id`,`crew_name`) VALUES (%d,%d,'%e') ON DUPLICATE KEY UPDATE `crew_name`=VALUES(`crew_name`)", fid, c+1, crews[c]); mysql_tquery(MainPipeline, q); }
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `family_lockers` (`family_id`,`materials`,`pot`,`crack`,`enabled`) VALUES (%d,0,0,0,0)", fid); mysql_tquery(MainPipeline, q, "ER_OnDefaultFamilyLocker", "i", fid);
    return 1;
}

CMD:createfamily(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /createfamily [name]");
    new q[700];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `families` (`name`,`leader_id`,`leader_name`,`motd`,`members_count`,`set_motd_rank`,`invite_kick_rank`,`point_capture_rank`,`turf_capture_rank`,`safe_deposit_rank`,`safe_withdraw_rank`,`locker_deposit_rank`,`locker_withdraw_rank`,`locker_gun_rank`,`business_safe_deposit_rank`,`business_safe_withdraw_rank`,`business_restock_rank`,`business_lock_rank`,`door_lock_rank`,`color`,`radio_color`,`crew_color`,`enabled`) VALUES ('%e',%d,'%e','Welcome to the family.',1,5,5,5,5,1,5,1,5,1,5,5,5,5,5,%d,%d,%d,1)", params, PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], FAMILY_CHAT_COLOR_DEFAULT, FAMILY_CHAT_COLOR_DEFAULT, FAMILY_CREW_COLOR_DEFAULT);
    mysql_tquery(MainPipeline, q, "ER_OnFamilyCreated", "i", playerid);
    return 1;
}
forward ER_OnFamilyCreated(playerid);
public ER_OnFamilyCreated(playerid)
{
    new fid = cache_insert_id();
    ER_CreateDefaultFamilyRows(fid);
    ER_MovePlayerToFamily(playerid, fid, 6, 0, true);
    ER_LoadFamilies();
    ER_Send(playerid, COLOR_GREEN, "Family created with 6 ranks and 3 crews.");
    SetTimerEx("ER_ShowCreatedFamilyEditor", 600, false, "ii", playerid, fid);
    return 1;
}
forward ER_ShowCreatedFamilyEditor(playerid, fid);
public ER_ShowCreatedFamilyEditor(playerid, fid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    return ER_ShowFamilyEditor(playerid, fid);
}
forward ER_OnDefaultFamilyLocker(fid);
public ER_OnDefaultFamilyLocker(fid)
{
    new lockerid = cache_insert_id(), q[256];
    new weaps[] = {22, 23, 24, 25, 29, 30, 31, 33, 34};
    for(new i; i < sizeof(weaps); i++)
    {
        mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `family_locker_guns` (`locker_id`,`weaponid`,`required_rank`,`admin_enabled`,`leader_enabled`) VALUES (%d,%d,%d,1,1)", lockerid, weaps[i], (i < 3) ? 1 : ((i < 6) ? 4 : 5));
        mysql_tquery(MainPipeline, q);
    }
    return 1;
}

CMD:f(playerid, params[])
{
    if(PlayerInfo[playerid][pFamily] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a family.");
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /f [message]");
    new msg[200], sendcolor = FAMILY_CHAT_COLOR_DEFAULT;
    new famidx = ER_FindFamilyIndexBySQLID(PlayerInfo[playerid][pFamily]);
    if(famidx != -1 && Families[famidx][fRadioColor] != 0) sendcolor = Families[famidx][fRadioColor];

    new dname[MAX_PLAYER_NAME], rankname[48], crewname[48];
    ER_GetDisplayName(playerid, dname, sizeof(dname));
    ER_GetFamilyRankName(PlayerInfo[playerid][pFamily], PlayerInfo[playerid][pFamilyRank], rankname, sizeof(rankname));
    ER_GetFamilyCrewName(PlayerInfo[playerid][pFamily], PlayerInfo[playerid][pFamilyCrew], crewname, sizeof(crewname));

    if(PlayerInfo[playerid][pFamilyCrew] > 0) format(msg, sizeof(msg), "(( Family | %s | Crew: %s )) %s: %s", rankname, crewname, dname, params);
    else format(msg, sizeof(msg), "(( Family | %s )) %s: %s", rankname, dname, params);
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFamily] == PlayerInfo[playerid][pFamily]) SendClientMessage(i, sendcolor, msg);
    return 1;
}
alias:f("family")

CMD:crew(playerid, params[])
{
    if(PlayerInfo[playerid][pFamily] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a family.");
    if(PlayerInfo[playerid][pFamilyCrew] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not assigned to a crew.");
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /crew [message]");
    new msg[200], sendcolor = FAMILY_CREW_COLOR_DEFAULT;
    new famidx = ER_FindFamilyIndexBySQLID(PlayerInfo[playerid][pFamily]);
    if(famidx != -1 && Families[famidx][fCrewColor] != 0) sendcolor = Families[famidx][fCrewColor];

    new dname[MAX_PLAYER_NAME], rankname[48], crewname[48];
    ER_GetDisplayName(playerid, dname, sizeof(dname));
    ER_GetFamilyRankName(PlayerInfo[playerid][pFamily], PlayerInfo[playerid][pFamilyRank], rankname, sizeof(rankname));
    ER_GetFamilyCrewName(PlayerInfo[playerid][pFamily], PlayerInfo[playerid][pFamilyCrew], crewname, sizeof(crewname));

    format(msg, sizeof(msg), "(( Crew | %s | %s )) %s: %s", rankname, crewname, dname, params);
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFamily] == PlayerInfo[playerid][pFamily] && PlayerInfo[i][pFamilyCrew] == PlayerInfo[playerid][pFamilyCrew]) SendClientMessage(i, sendcolor, msg);
    return 1;
}
alias:crew("cr")

CMD:faminvite(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /faminvite [playerid/name]");
    if(PlayerInfo[playerid][pFamily] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a family.");
    new idx = ER_FindFamilyIndexBySQLID(PlayerInfo[playerid][pFamily]);
    if(idx == -1 || PlayerInfo[playerid][pFamilyRank] < Families[idx][fInviteKickRank]) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(PlayerInfo[target][pFamily] > 0 || PlayerInfo[target][pFaction] > 0) return ER_Send(playerid, COLOR_GREY, "This player is already in a family or faction.");
    SetPVarInt(target, "PendingFamilyInvite", PlayerInfo[playerid][pFamily]);
    new msg[160]; format(msg, sizeof(msg), "You invited %s to %s.", ER_GetName(target), Families[idx][fName]); ER_Send(playerid, COLOR_GREEN, msg);
    format(msg, sizeof(msg), "%s invited you to join %s. Use /accept family.", ER_GetName(playerid), Families[idx][fName]); ER_Send(target, COLOR_YELLOW, msg);
    return 1;
}
alias:faminvite("familyinvite")

CMD:famkick(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /famkick [playerid/name]");
    if(PlayerInfo[playerid][pFamily] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a family.");
    new idx = ER_FindFamilyIndexBySQLID(PlayerInfo[playerid][pFamily]);
    if(idx == -1 || PlayerInfo[playerid][pFamilyRank] < Families[idx][fInviteKickRank]) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn] || PlayerInfo[target][pFamily] != PlayerInfo[playerid][pFamily]) return ER_Send(playerid, COLOR_GREY, "That player is not in your family.");
    if(PlayerInfo[target][pFamilyRank] >= PlayerInfo[playerid][pFamilyRank]) return ER_Send(playerid, COLOR_GREY, "You cannot kick a player with an equal or higher rank.");
    ER_RemovePlayerFromFamily(target, true);
    ER_Send(target, COLOR_GREY, "You have been removed from your family.");
    return ER_Send(playerid, COLOR_GREEN, "Player removed from family.");
}
alias:famkick("familykick")

CMD:leavefamily(playerid, params[])
{
    if(PlayerInfo[playerid][pFamily] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a family.");
    if(!ER_RemovePlayerFromFamily(playerid, false)) return ER_Send(playerid, COLOR_GREY, "You cannot leave while you are the leader. Transfer leadership first.");
    return ER_Send(playerid, COLOR_GREEN, "You left the family.");
}

CMD:crewinvite(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /crewinvite [playerid/name]");
    if(PlayerInfo[playerid][pFamily] <= 0 || PlayerInfo[playerid][pFamilyRank] < 5) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || PlayerInfo[target][pFamily] != PlayerInfo[playerid][pFamily]) return ER_Send(playerid, COLOR_GREY, "That player is not in your family.");
    FamilyCrewSelectTarget[playerid] = target; FamilyCrewSelectMode[playerid] = 1;
    return ER_ShowFamilyCrewSelect(playerid);
}
alias:crewinvite("crinvite")

CMD:setcrew(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setcrew [playerid/name]");
    if(PlayerInfo[playerid][pFamily] <= 0 || PlayerInfo[playerid][pFamilyRank] < 6) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || PlayerInfo[target][pFamily] != PlayerInfo[playerid][pFamily]) return ER_Send(playerid, COLOR_GREY, "That player is not in your family.");
    FamilyCrewSelectTarget[playerid] = target; FamilyCrewSelectMode[playerid] = 2;
    return ER_ShowFamilyCrewSelect(playerid);
}
alias:setcrew("setcr")

stock ER_ShowFamilyCrewSelect(playerid)
{
    new fid = PlayerInfo[playerid][pFamily], idx = ER_FindFamilyIndexBySQLID(fid), list[512], name[48];
    format(list, sizeof(list), "1 - (0) None\n");
    for(new c = 1; c <= 3 && c <= MAX_FAMILY_CREWS; c++)
    {
        ER_GetFamilyCrewName(fid, c, name, sizeof(name));
        format(list, sizeof(list), "%s%d - %s\n", list, c + 1, name);
    }
    ShowPlayerDialog(playerid, DIALOG_FAMILY_CREW_INVITE, DIALOG_STYLE_LIST, "Select Crew", list, "Select", "Cancel");
    #pragma unused idx
    return 1;
}

stock ER_AcceptFamilyInvite(playerid)
{
    new fid = GetPVarInt(playerid, "PendingFamilyInvite");
    if(fid <= 0) return 0;
    if(PlayerInfo[playerid][pFamily] > 0 || PlayerInfo[playerid][pFaction] > 0) { DeletePVar(playerid, "PendingFamilyInvite"); return ER_Send(playerid, COLOR_GREY, "You are already in a family or faction."); }
    ER_MovePlayerToFamily(playerid, fid, 1, 0, false);
    DeletePVar(playerid, "PendingFamilyInvite");
    return ER_Send(playerid, COLOR_GREEN, "You joined the family.");
}

stock ER_AcceptCrewInvite(playerid)
{
    new crew = GetPVarInt(playerid, "PendingCrewInvite");
    if(crew <= 0) return 0;
    PlayerInfo[playerid][pFamilyCrew] = crew;
    new q[160]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `family_crew`=%d WHERE `id`=%d", crew, PlayerInfo[playerid][pID]); mysql_tquery(MainPipeline, q);
    DeletePVar(playerid, "PendingCrewInvite");
    return ER_Send(playerid, COLOR_GREEN, "You accepted the crew invite.");
}

CMD:families(playerid, params[])
{
    new listno;
    if(sscanf(params, "d", listno))
    {
        new line[160];
        SendClientMessage(playerid, COLOR_OFFWHITE, "Families:");
        for(new i; i < FamilyCount; i++)
        {
            FamilyListSQL[playerid][i+1] = Families[i][fSQLID];
            format(line, sizeof(line), "%d - (%d) %s - Leader: %s - Members: %d", i+1, Families[i][fSQLID], Families[i][fName], Families[i][fLeaderName], Families[i][fMembers]);
            SendClientMessage(playerid, COLOR_OFFWHITE, line);
        }
        return 1;
    }
    if(listno <= 0 || listno > FamilyCount) return ER_Send(playerid, COLOR_GREY, "Invalid family list number. Use /families first.");
    new fid = Families[listno-1][fSQLID], line[160], rankname[48];
    SendClientMessage(playerid, COLOR_OFFWHITE, "Online Members:");
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFamily] == fid)
    {
        ER_GetFamilyRankName(fid, PlayerInfo[i][pFamilyRank], rankname, sizeof(rankname));
        format(line, sizeof(line), "%s %s", ER_GetName(i), rankname);
        SendClientMessage(playerid, COLOR_OFFWHITE, line);
    }
    return 1;
}

stock ER_SendFamilyMOTD(playerid)
{
    if(PlayerInfo[playerid][pFamily] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a family.");
    new idx = ER_FindFamilyIndexBySQLID(PlayerInfo[playerid][pFamily]), msg[180];
    if(idx == -1) return 1;
    format(msg, sizeof(msg), "Family MOTD: %s", Families[idx][fMOTD]);
    return ER_Send(playerid, Families[idx][fColor], msg);
}
CMD:fmotd(playerid, params[])
{
    return ER_SendFamilyMOTD(playerid);
}


stock ER_ShowFamilyRanksEditor(playerid, fid)
{
    new idx = ER_FindFamilyIndexBySQLID(fid), list[512], line[96];
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid family."), 1;
    for(new r = 1; r <= 6; r++)
    {
        format(line, sizeof(line), "%d - %s\n", r, FamilyRankNames[idx][r - 1]);
        strcat(list, line, sizeof(list));
    }
    ShowPlayerDialog(playerid, DIALOG_FAMILY_RANKS, DIALOG_STYLE_LIST, "Family Ranks", list, "Edit", "Back");
    return 1;
}

stock ER_ShowFamilyCrewsEditor(playerid, fid)
{
    new idx = ER_FindFamilyIndexBySQLID(fid), list[512], line[96];
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid family."), 1;
    for(new c = 1; c <= 3; c++)
    {
        format(line, sizeof(line), "%d - %s\n", c, FamilyCrewNames[idx][c - 1]);
        strcat(list, line, sizeof(list));
    }
    ShowPlayerDialog(playerid, DIALOG_FAMILY_CREWS, DIALOG_STYLE_LIST, "Family Crews", list, "Edit", "Back");
    return 1;
}

stock ER_ShowFamilyPermsEditor(playerid, fid)
{
    new idx = ER_FindFamilyIndexBySQLID(fid), list[1024];
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid family."), 1;
    format(list, sizeof(list),
        "Set MOTD >= %d\nInvite & Kick >= %d\nPoint Capture >= %d\nTurf Capture >= %d\nSafe Deposit >= %d\nSafe Withdraw >= %d\nLocker Deposit >= %d\nLocker Withdraw >= %d\nLocker Weapons >= %d\nVehicles - Lock/Unlock >= %d\nVehicles - Track >= %d\nVehicles - Park >= %d\nBusiness - Safe Deposit >= %d\nBusiness - Safe Withdraw >= %d\nBusiness - Restock >= %d\nBusiness - Lock/Unlock >= %d\nDoors - Lock/Unlock >= %d",
        Families[idx][fSetMOTDRank], Families[idx][fInviteKickRank], Families[idx][fPointCaptureRank], Families[idx][fTurfCaptureRank],
        Families[idx][fSafeDepositRank], Families[idx][fSafeWithdrawRank], Families[idx][fLockerDepositRank], Families[idx][fLockerWithdrawRank], Families[idx][fLockerGunRank],
        Families[idx][fVehicleLockRank], Families[idx][fVehicleTrackRank], Families[idx][fVehicleParkRank], Families[idx][fBusinessSafeDepositRank], Families[idx][fBusinessSafeWithdrawRank], Families[idx][fBusinessRestockRank], Families[idx][fBusinessLockRank], Families[idx][fDoorLockRank]);
    ShowPlayerDialog(playerid, DIALOG_FAMILY_PERMS, DIALOG_STYLE_LIST, "Family Permissions", list, "Edit", "Back");
    return 1;
}

stock ER_ShowFamilyLockerEditor(playerid, fid)
{
    SetPVarInt(playerid, "EditingFamily", fid);
    SetPVarInt(playerid, "FamilyInputField", 60);
    ShowPlayerDialog(playerid, DIALOG_FAMILY_LOCKERS, DIALOG_STYLE_LIST, "Family Locker", "Create Locker\nEdit Lockers", "Select", "Back");
    return 1;
}

stock ER_SetFamilyLockerPos(playerid, fid)
{
    new Float:x, Float:y, Float:z, q[256];
    GetPlayerPos(playerid, x, y, z);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `family_lockers` SET `x`=%f,`y`=%f,`z`=%f,`interior`=%d,`vw`=%d,`enabled`=1 WHERE `family_id`=%d LIMIT 1", x, y, z, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), fid);
    mysql_tquery(MainPipeline, q);
    ER_Send(playerid, COLOR_GREEN, "Family locker position saved.");
    return 1;
}

stock ER_SetFamilySafePos(playerid, fid)
{
    new Float:x, Float:y, Float:z, Float:a, q[256];
    GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `family_safes` SET `x`=%f,`y`=%f,`z`=%f,`a`=%f,`interior`=%d,`vw`=%d,`enabled`=1 WHERE `family_id`=%d LIMIT 1", x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), fid);
    mysql_tquery(MainPipeline, q);
    ER_Send(playerid, COLOR_GREEN, "Family safe position saved.");
    return 1;
}


stock ER_GetFamilyLockerID(fid)
{
    new q[160]; mysql_format(MainPipeline, q, sizeof(q), "SELECT `id` FROM `family_lockers` WHERE `family_id`=%d AND `enabled`=1 LIMIT 1", fid);
    new Cache:res = mysql_query(MainPipeline, q);
    new rows, lockerid = 0; cache_get_row_count(rows);
    if(rows > 0) cache_get_value_name_int(0, "id", lockerid);
    cache_delete(res);
    return lockerid;
}

stock ER_ShowFamLockerWpnEdit(playerid, fid)
{
    SetPVarInt(playerid, "FamilyLockerMode", 1);
    new lockerid = ER_GetFamilyLockerID(fid);
    if(lockerid <= 0) return ER_Send(playerid, COLOR_GREY, "Create/set this family locker first."), ER_ShowFamilyLockerEditor(playerid, fid);
    new q[256]; mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `family_locker_guns` WHERE `locker_id`=%d ORDER BY `id` ASC", lockerid);
    new Cache:res = mysql_query(MainPipeline, q);
    new rows; cache_get_row_count(rows);
    new list[2048], line[160], rankname[48], wname[32], weaponid, rank, crew, gunid;
    for(new i; i < rows && i < 63; i++)
    {
        cache_get_value_name_int(i, "id", gunid);
        cache_get_value_name_int(i, "weaponid", weaponid);
        cache_get_value_name_int(i, "required_rank", rank);
        cache_get_value_name_int(i, "required_crew", crew);
        FamilyLockerGunList[playerid][i] = gunid;
        ER_GetFamilyRankName(fid, rank, rankname, sizeof(rankname));
        if(weaponid > 0) format(wname, sizeof(wname), "%s", ER_GetWeaponNameEx(weaponid)); else format(wname, sizeof(wname), "None");
        format(line, sizeof(line), "%d - (%d) %s - %s - Crew %d\n", i + 1, weaponid, wname, rankname, crew);
        strcat(list, line, sizeof(list));
    }
    SetPVarInt(playerid, "FamilyLockerGunCount", rows < 63 ? rows : 63);
    strcat(list, "Add Weapon", sizeof(list));
    cache_delete(res);
    return ShowPlayerDialog(playerid, DIALOG_FAMILY_LOCKER_WEAPONS, DIALOG_STYLE_LIST, "Family Locker Weapons", list, "Select", "Back");
}

stock ER_ShowFamilyLockerWeaponEdit(playerid, gunid)
{
    SetPVarInt(playerid, "FamilyLockerGunID", gunid);
    new q[160]; mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `family_locker_guns` WHERE `id`=%d LIMIT 1", gunid);
    new Cache:res = mysql_query(MainPipeline, q);
    new rows; cache_get_row_count(rows);
    if(rows <= 0) { cache_delete(res); return ER_ShowFamLockerWpnEdit(playerid, GetPVarInt(playerid, "EditingFamily")); }
    new weaponid, rank, crew, rankname[48], crewname[48], wname[32], list[512];
    cache_get_value_name_int(0, "weaponid", weaponid);
    cache_get_value_name_int(0, "required_rank", rank);
    cache_get_value_name_int(0, "required_crew", crew);
    cache_delete(res);
    ER_GetFamilyRankName(GetPVarInt(playerid, "EditingFamily"), rank, rankname, sizeof(rankname));
    ER_GetFamilyCrewName(GetPVarInt(playerid, "EditingFamily"), crew, crewname, sizeof(crewname));
    if(weaponid > 0) format(wname, sizeof(wname), "%s", ER_GetWeaponNameEx(weaponid)); else format(wname, sizeof(wname), "None");
    format(list, sizeof(list), "Select Weapon: (%d) %s\nRank: %s\nCrew: %s", weaponid, wname, rankname, crewname);
    return ShowPlayerDialog(playerid, DIALOG_FAMILY_LOCKER_WEAPON_EDIT, DIALOG_STYLE_LIST, "Edit Locker Weapon", list, "Select", "Back");
}

stock ER_AddFamilyLockerWeapon(playerid, fid)
{
    new lockerid = ER_GetFamilyLockerID(fid), q[220];
    if(lockerid <= 0) return ER_Send(playerid, COLOR_GREY, "Create/set this family locker first."), 1;
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `family_locker_guns` (`locker_id`,`weaponid`,`required_rank`,`required_crew`,`admin_enabled`,`leader_enabled`) VALUES (%d,0,1,0,1,1)", lockerid);
    mysql_tquery(MainPipeline, q);
    ER_Send(playerid, COLOR_GREEN, "Empty locker weapon slot added. Reopen Edit Lockers to edit it.");
    return 1;
}

stock ER_ShowFamilyPlayerWeapons(playerid)
{
    SetPVarInt(playerid, "FamilyLockerMode", 2);
    new fid = PlayerInfo[playerid][pFamily], lockerid = ER_GetFamilyLockerID(fid);
    if(lockerid <= 0) return ER_Send(playerid, COLOR_GREY, "Your family does not have a locker set."), 1;
    new q[256]; mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `family_locker_guns` WHERE `locker_id`=%d AND `weaponid`>0 ORDER BY `id` ASC", lockerid);
    new Cache:res = mysql_query(MainPipeline, q);
    new rows; cache_get_row_count(rows);
    new list[2048], line[160], prefix[16], weaponid, rank, crew, gunid, allowed;
    for(new i; i < rows && i < 63; i++)
    {
        cache_get_value_name_int(i, "id", gunid); cache_get_value_name_int(i, "weaponid", weaponid); cache_get_value_name_int(i, "required_rank", rank); cache_get_value_name_int(i, "required_crew", crew);
        FamilyLockerGunList[playerid][i] = gunid;
        allowed = (PlayerInfo[playerid][pFamilyRank] >= rank && (crew == 0 || PlayerInfo[playerid][pFamilyCrew] == crew));
        if(allowed) prefix[0] = EOS; else format(prefix, sizeof(prefix), "{AAAAAA}LOCKED ");
        format(line, sizeof(line), "%s(%d) %s - Rank %d - Crew %d\n", prefix, weaponid, ER_GetWeaponNameEx(weaponid), rank, crew);
        strcat(list, line, sizeof(list));
    }
    SetPVarInt(playerid, "FamilyLockerGunCount", rows < 63 ? rows : 63);
    cache_delete(res);
    if(isnull(list)) return ER_Send(playerid, COLOR_GREY, "No locker weapons are configured."), 1;
    return ShowPlayerDialog(playerid, DIALOG_FAMILY_LOCKER_WEAPONS, DIALOG_STYLE_LIST, "Family Locker Weapons", list, "Take", "Back");
}


stock ER_FamilyPermsAreDefault(idx)
{
    if(idx == -1) return 1;
    return (Families[idx][fSetMOTDRank] == 5 &&
        Families[idx][fInviteKickRank] == 5 &&
        Families[idx][fPointCaptureRank] == 5 &&
        Families[idx][fTurfCaptureRank] == 5 &&
        Families[idx][fSafeDepositRank] == 1 &&
        Families[idx][fSafeWithdrawRank] == 5 &&
        Families[idx][fLockerDepositRank] == 1 &&
        Families[idx][fLockerWithdrawRank] == 5 &&
        Families[idx][fLockerGunRank] == 1 &&
        Families[idx][fVehicleLockRank] == 5 &&
        Families[idx][fVehicleTrackRank] == 5 &&
        Families[idx][fVehicleParkRank] == 5 &&
        Families[idx][fBusinessSafeDepositRank] == 5 &&
        Families[idx][fBusinessSafeWithdrawRank] == 5 &&
        Families[idx][fBusinessRestockRank] == 5 &&
        Families[idx][fBusinessLockRank] == 5 &&
        Families[idx][fDoorLockRank] == 5);
}

stock ER_ShowFamilyEditor(playerid, fid)
{
    SetPVarInt(playerid, "EditingFamily", fid);
    new idx = ER_FindFamilyIndexBySQLID(fid), list[1280], famColor[32], crewColor[32], leader[MAX_PLAYER_NAME_EX], status[16], permText[16];
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid family."), 1;
    ER_GetNamedColorDisplayByValue(Families[idx][fRadioColor], famColor, sizeof(famColor));
    ER_GetNamedColorDisplayByValue(Families[idx][fCrewColor], crewColor, sizeof(crewColor));
    if(Families[idx][fLeaderID] > 0 && strcmp(Families[idx][fLeaderName], "Nobody", true)) format(leader, sizeof(leader), "%s", Families[idx][fLeaderName]); else format(leader, sizeof(leader), "None");
    if(Families[idx][fEnabled]) format(status, sizeof(status), "Enabled"); else format(status, sizeof(status), "Disabled");
    if(ER_FamilyPermsAreDefault(idx)) format(permText, sizeof(permText), "Default"); else format(permText, sizeof(permText), "Custom");
    format(list, sizeof(list), "Name: %s\nLeader: %s\nMOTD: %s\nFamily Chat Color: %s\nCrew Chat Color: %s\nRanks: 6 Ranks\nCrews: 3 Crews\nLockers\nSafes\nPermissions: %s\nStatus: %s\nReload This Family",
        Families[idx][fName], leader, Families[idx][fMOTD], famColor, crewColor, permText, status);
    ShowPlayerDialog(playerid, DIALOG_FAMILY_EDITOR, DIALOG_STYLE_LIST, "Family Editor", list, "Select", "Close");
    return 1;
}


stock ER_SetFamilyLeaderAccount(playerid, fid, accountid, const accountName[])
{
    if(fid <= 0 || accountid <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid account."), 1;

    // MySQL R41 on this setup is not accepting multi-statement queries.
    // Send each UPDATE separately so setting a leader cannot fail with SQL error 1064.
    new q[384];
    new idx = ER_FindFamilyIndexBySQLID(fid);
    new oldLeader = (idx != -1) ? Families[idx][fLeaderID] : 0;

    // If this family already had a different leader, remove that old leader from this family.
    if(oldLeader > 0 && oldLeader != accountid)
    {
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `family_id`=0,`family_rank`=0,`family_crew`=0 WHERE `id`=%d AND `family_id`=%d", oldLeader, fid);
        mysql_tquery(MainPipeline, q);
        foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pID] == oldLeader && PlayerInfo[i][pFamily] == fid)
        {
            PlayerInfo[i][pFamily] = 0;
            PlayerInfo[i][pFamilyRank] = 0;
            PlayerInfo[i][pFamilyCrew] = 0;
        }
    }

    // Clear this account as leader anywhere else before assigning the new family.
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `leader_id`=0,`leader_name`='Nobody' WHERE `leader_id`=%d", accountid);
    mysql_tquery(MainPipeline, q);

    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `leader_id`=0,`leader_name`='Nobody' WHERE `leader_id`=%d AND `id`<>%d", accountid, fid);
    mysql_tquery(MainPipeline, q);

    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `faction_id`=0,`faction_rank`=0,`faction_division`=0,`family_id`=%d,`family_rank`=6,`family_crew`=0 WHERE `id`=%d", fid, accountid);
    mysql_tquery(MainPipeline, q);

    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `leader_id`=%d,`leader_name`='%e' WHERE `id`=%d", accountid, accountName, fid);
    mysql_tquery(MainPipeline, q);

    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pID] == accountid)
    {
        PlayerInfo[i][pFaction] = 0;
        PlayerInfo[i][pFactionRank] = 0;
        PlayerInfo[i][pFactionDivision] = 0;
        PlayerInfo[i][pFamily] = fid;
        PlayerInfo[i][pFamilyRank] = 6;
        PlayerInfo[i][pFamilyCrew] = 0;
    }

    if(idx != -1)
    {
        Families[idx][fLeaderID] = accountid;
        format(Families[idx][fLeaderName], MAX_PLAYER_NAME_EX, "%s", accountName);
    }

    ER_RecountAllFamilyMembers();
    ER_RecountAllFactionMembers();
    ER_LoadFamilies(); ER_LoadFactions();
    new msg[128]; format(msg, sizeof(msg), "Family leader set to %s (PID %d).", accountName, accountid); ER_Send(playerid, COLOR_GREEN, msg);
    return ER_ShowFamilyEditor(playerid, fid);
}
forward ER_OnFamilyLeaderOfflineList(playerid);
public ER_OnFamilyLeaderOfflineList(playerid)
{
    new rows; cache_get_row_count(rows); new list[4096], line[96], name[MAX_PLAYER_NAME_EX], id; if(rows > 100) rows = 100;
    for(new r; r < rows; r++) { cache_get_value_name_int(r, "id", id); cache_get_value_name(r, "username", name, sizeof(name)); FamilyLeaderSelectSQL[playerid][r] = id; format(FamilyLeaderSelectName[playerid][r], MAX_PLAYER_NAME_EX, "%s", name); format(line, sizeof(line), "ID: %d - %s\n", id, name); strcat(list, line, sizeof(list)); }
    if(!rows) return ER_Send(playerid, COLOR_GREY, "No accounts found."), 1;
    ShowPlayerDialog(playerid, DIALOG_FAMILY_LEADER_OFFLINE, DIALOG_STYLE_LIST, "Select Offline Family Leader", list, "Set", "Back");
    return 1;
}

CMD:editfamilies(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new list[2048];
    for(new i; i < FamilyCount; i++) format(list, sizeof(list), "%s%d | %s | Leader: %s\n", list, Families[i][fSQLID], Families[i][fName], Families[i][fLeaderName]);
    if(!FamilyCount) return ER_Send(playerid, COLOR_GREY, "No families found.");
    ShowPlayerDialog(playerid, DIALOG_FAMILY_LIST, DIALOG_STYLE_LIST, "Select Family", list, "Edit", "Cancel");
    return 1;
}
CMD:editfamily(playerid, params[])
{
    new fid;
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "d", fid)) return ER_Send(playerid, COLOR_GREY, "USAGE: /editfamily [id]");
    return ER_ShowFamilyEditor(playerid, fid);
}
CMD:familysettings(playerid, params[])
{
    if(PlayerInfo[playerid][pFamily] <= 0 || PlayerInfo[playerid][pFamilyRank] < 6) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    return ER_ShowFamilyEditor(playerid, PlayerInfo[playerid][pFamily]);
}

stock ER_FamilyDialog(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_FAMILY_LIST)
    {
        if(response && listitem >= 0 && listitem < FamilyCount) ER_ShowFamilyEditor(playerid, Families[listitem][fSQLID]);
        return 1;
    }
    if(dialogid == DIALOG_FAMILY_EDITOR)
    {
        if(!response) return 1;
        switch(listitem)
        {
            case 0: { SetPVarInt(playerid, "FamilyInputField", 1); ShowPlayerDialog(playerid, DIALOG_FAMILY_INPUT, DIALOG_STYLE_INPUT, "Family Name", "Enter new family name:", "Save", "Back"); }
            case 1: { ShowPlayerDialog(playerid, DIALOG_FAMILY_LEADER_TYPE, DIALOG_STYLE_LIST, "Family Leader", "Online Player\nOffline Player\nClear Leader", "Select", "Back"); }
            case 2: { SetPVarInt(playerid, "FamilyInputField", 2); ShowPlayerDialog(playerid, DIALOG_FAMILY_INPUT, DIALOG_STYLE_INPUT, "Family MOTD", "Enter new family MOTD:", "Save", "Back"); }
            case 3: { SetPVarInt(playerid, "FamilyColorField", 1); ER_ShowNamedColorDialog(playerid, DIALOG_FAMILY_COLOR_SELECT, "Family Chat Color"); }
            case 4: { SetPVarInt(playerid, "FamilyColorField", 2); ER_ShowNamedColorDialog(playerid, DIALOG_FAMILY_COLOR_SELECT, "Crew Chat Color"); }
            case 5: return ER_ShowFamilyRanksEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
            case 6: return ER_ShowFamilyCrewsEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
            case 7: return ER_ShowFamilyLockerEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
            case 8: return ER_ShowFamilyLockerEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
            case 9: return ER_ShowFamilyPermsEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
            case 10: { SetPVarInt(playerid, "FamilyInputField", 50); ShowPlayerDialog(playerid, DIALOG_FAMILY_INPUT, DIALOG_STYLE_LIST, "Family Status", "Enabled\nDisabled", "Save", "Back"); }
            case 11: { ER_LoadFamilies(); ER_Send(playerid, COLOR_GREEN, "Families reloaded."); }
        }
        return 1;
    }
    if(dialogid == DIALOG_FAMILY_RANKS)
    {
        if(!response) return ER_ShowFamilyEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
        SetPVarInt(playerid, "FamilyInputField", 10 + listitem);
        ShowPlayerDialog(playerid, DIALOG_FAMILY_INPUT, DIALOG_STYLE_INPUT, "Edit Family Rank", "Enter new rank name:", "Save", "Back");
        return 1;
    }
    if(dialogid == DIALOG_FAMILY_CREWS)
    {
        if(!response) return ER_ShowFamilyEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
        SetPVarInt(playerid, "FamilyInputField", 20 + listitem);
        ShowPlayerDialog(playerid, DIALOG_FAMILY_INPUT, DIALOG_STYLE_INPUT, "Edit Family Crew", "Enter new crew name:", "Save", "Back");
        return 1;
    }
    if(dialogid == DIALOG_FAMILY_PERMS)
    {
        if(!response) return ER_ShowFamilyEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
        SetPVarInt(playerid, "FamilyInputField", 30 + listitem);
        ShowPlayerDialog(playerid, DIALOG_FAMILY_INPUT, DIALOG_STYLE_INPUT, "Edit Permission Rank", "Enter minimum rank 1-6. Players with this rank or higher can use it:", "Save", "Back");
        return 1;
    }
    if(dialogid == DIALOG_FAMILY_LOCKERS)
    {
        if(!response) return ER_ShowFamilyEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
        new fid = GetPVarInt(playerid, "EditingFamily");
        if(listitem == 0) return ER_SetFamilyLockerPos(playerid, fid), ER_ShowFamilyEditor(playerid, fid);
        if(listitem == 1) return ER_ShowFamLockerWpnEdit(playerid, fid);
        return 1;
    }
    if(dialogid == DIALOG_FAMILY_PLAYER_LOCKER)
    {
        if(!response) return 1;
        if(listitem == 0) return ER_ShowFamilyPlayerWeapons(playerid);
        if(listitem == 1) return ER_Send(playerid, COLOR_GREEN, "Family materials locker selected.");
        if(listitem == 2) return ER_Send(playerid, COLOR_GREEN, "Family safe selected.");
        return 1;
    }
    if(dialogid == DIALOG_FAMILY_LOCKER_WEAPONS)
    {
        if(!response)
        {
            if(GetPVarInt(playerid, "FamilyLockerMode") == 1) return ER_ShowFamilyLockerEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
            return ShowPlayerDialog(playerid, DIALOG_FAMILY_PLAYER_LOCKER, DIALOG_STYLE_LIST, "Family Locker", "Weapons\nMaterials\nSafe", "Select", "Close");
        }
        new count = GetPVarInt(playerid, "FamilyLockerGunCount"), mode = GetPVarInt(playerid, "FamilyLockerMode");
        if(mode == 1)
        {
            if(listitem == count) return ER_AddFamilyLockerWeapon(playerid, GetPVarInt(playerid, "EditingFamily")), ER_ShowFamLockerWpnEdit(playerid, GetPVarInt(playerid, "EditingFamily"));
            if(listitem >= 0 && listitem < count) return ER_ShowFamilyLockerWeaponEdit(playerid, FamilyLockerGunList[playerid][listitem]);
            return 1;
        }
        if(mode == 2 && listitem >= 0 && listitem < count)
        {
            new gunid = FamilyLockerGunList[playerid][listitem], q[160];
            mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `family_locker_guns` WHERE `id`=%d LIMIT 1", gunid);
            new Cache:res = mysql_query(MainPipeline, q);
            new rows; cache_get_row_count(rows);
            if(rows <= 0) { cache_delete(res); return 1; }
            new weaponid, rank, crew; cache_get_value_name_int(0, "weaponid", weaponid); cache_get_value_name_int(0, "required_rank", rank); cache_get_value_name_int(0, "required_crew", crew); cache_delete(res);
            if(PlayerInfo[playerid][pFamilyRank] < rank || (crew > 0 && PlayerInfo[playerid][pFamilyCrew] != crew)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to use this locker weapon.");
            new matCost = ER_GetWeaponMatCost(weaponid), lockerid = ER_GetFamilyLockerID(PlayerInfo[playerid][pFamily]);
            if(matCost < 0) return ER_Send(playerid, COLOR_GREY, "This weapon has no enabled material-cost row.");
            mysql_format(MainPipeline, q, sizeof(q), "SELECT `materials` FROM `family_lockers` WHERE `id`=%d LIMIT 1", lockerid);
            res = mysql_query(MainPipeline, q);
            cache_get_row_count(rows);
            new materials;
            if(rows > 0) cache_get_value_name_int(0, "materials", materials);
            cache_delete(res);
            if(materials < matCost) return ER_Send(playerid, COLOR_GREY, "Your family locker does not have enough materials for this weapon.");
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `family_lockers` SET `materials`=`materials`-%d WHERE `id`=%d", matCost, lockerid);
            mysql_tquery(MainPipeline, q);
            GivePlayerWeapon(playerid, weaponid, 99999);
            return ER_Send(playerid, COLOR_GREEN, "Weapon taken from locker. Materials deducted.");
        }
        return 1;
    }
    if(dialogid == DIALOG_FAMILY_LOCKER_WEAPON_EDIT)
    {
        if(!response) return ER_ShowFamLockerWpnEdit(playerid, GetPVarInt(playerid, "EditingFamily"));
        if(listitem == 0) return ShowPlayerDialog(playerid, DIALOG_FAMILY_LOCKER_WEAPON_SELECT, DIALOG_STYLE_INPUT, "Select Weapon", "Enter weapon ID, or 0 for None:", "Save", "Back");
        if(listitem == 1) return ShowPlayerDialog(playerid, DIALOG_FAMILY_LOCKER_WEAPON_RANK, DIALOG_STYLE_INPUT, "Weapon Rank", "Enter minimum rank 1-6:", "Save", "Back");
        if(listitem == 2) return ShowPlayerDialog(playerid, DIALOG_FAMILY_LOCKER_WEAPON_CREW, DIALOG_STYLE_LIST, "Weapon Crew", "1 - (0) None\n2 - (1) Crew 1\n3 - (2) Crew 2\n4 - (3) Crew 3", "Save", "Back");
        return 1;
    }
    if(dialogid == DIALOG_FAMILY_LOCKER_WEAPON_SELECT || dialogid == DIALOG_FAMILY_LOCKER_WEAPON_RANK || dialogid == DIALOG_FAMILY_LOCKER_WEAPON_CREW)
    {
        if(!response) return ER_ShowFamilyLockerWeaponEdit(playerid, GetPVarInt(playerid, "FamilyLockerGunID"));
        new gunid = GetPVarInt(playerid, "FamilyLockerGunID"), q[160];
        if(dialogid == DIALOG_FAMILY_LOCKER_WEAPON_SELECT)
        {
            new wid;
            if(!strcmp(inputtext, "0", true) || !strcmp(inputtext, "none", true)) wid = 0;
            else
            {
                wid = ER_ResolveWeaponMaterial(inputtext);
                if(wid == -2) return ER_Send(playerid, COLOR_GREY, "That partial weapon name matches more than one weapon. Type more letters."), ER_ShowFamilyLockerWeaponEdit(playerid, gunid);
                if(wid <= 0) return ER_Send(playerid, COLOR_GREY, "Weapon not found in weapon_material_costs or is disabled."), ER_ShowFamilyLockerWeaponEdit(playerid, gunid);
            }
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `family_locker_guns` SET `weaponid`=%d WHERE `id`=%d", wid, gunid);
        }
        else if(dialogid == DIALOG_FAMILY_LOCKER_WEAPON_RANK)
        {
            new rank = strval(inputtext); if(rank < 1 || rank > 6) return ER_Send(playerid, COLOR_GREY, "Enter a rank from 1 to 6."), ER_ShowFamilyLockerWeaponEdit(playerid, gunid);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `family_locker_guns` SET `required_rank`=%d WHERE `id`=%d", rank, gunid);
        }
        else mysql_format(MainPipeline, q, sizeof(q), "UPDATE `family_locker_guns` SET `required_crew`=%d WHERE `id`=%d", listitem, gunid);
        mysql_tquery(MainPipeline, q);
        return ER_ShowFamilyLockerWeaponEdit(playerid, gunid);
    }
    if(dialogid == DIALOG_FAMILY_INPUT)
    {
        if(!response) return ER_ShowFamilyEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
        new fid = GetPVarInt(playerid, "EditingFamily"), field = GetPVarInt(playerid, "FamilyInputField"), q[384];
        if(field == 1) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `name`='%e' WHERE `id`=%d", inputtext, fid);
        else if(field == 2) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `motd`='%e' WHERE `id`=%d", inputtext, fid);
        else if(field == 3)
        {
            if(!strcmp(inputtext, "0", true) || !strcmp(inputtext, "Nobody", true)) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `leader_id`=0,`leader_name`='Nobody' WHERE `id`=%d", fid);
            else mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` f LEFT JOIN `accounts` a ON a.`username`='%e' SET f.`leader_id`=IFNULL(a.`id`,0), f.`leader_name`='%e' WHERE f.`id`=%d", inputtext, inputtext, fid);
        }
        else if(field >= 10 && field < 16)
        {
            new rankid = field - 9;
            mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `family_ranks` (`family_id`,`rank_id`,`rank_name`) VALUES (%d,%d,'%e') ON DUPLICATE KEY UPDATE `rank_name`=VALUES(`rank_name`)", fid, rankid, inputtext);
        }
        else if(field >= 20 && field < 23)
        {
            new crewid = field - 19;
            mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `family_crews` (`family_id`,`crew_id`,`crew_name`) VALUES (%d,%d,'%e') ON DUPLICATE KEY UPDATE `crew_name`=VALUES(`crew_name`)", fid, crewid, inputtext);
        }
        else if(field >= 30 && field < 47)
        {
            new rank = strval(inputtext); if(rank < 1 || rank > 6) return ER_Send(playerid, COLOR_GREY, "Enter a rank from 1 to 6."), ER_ShowFamilyPermsEditor(playerid, fid);
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
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `%s`=%d WHERE `id`=%d", col, rank, fid);
        }
        else if(field == 50) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `enabled`=%d WHERE `id`=%d", listitem == 0 ? 1 : 0, fid);
        else return ER_ShowFamilyEditor(playerid, fid);
        mysql_tquery(MainPipeline, q); ER_LoadFamilies(); return ER_ShowFamilyEditor(playerid, fid);
    }

    if(dialogid == DIALOG_FAMILY_LEADER_TYPE)
    {
        if(!response) return ER_ShowFamilyEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
        if(listitem == 0) return ShowPlayerDialog(playerid, DIALOG_FAMILY_LEADER_ONLINE, DIALOG_STYLE_INPUT, "Online Family Leader", "Enter online player ID or part of name:", "Set", "Back");
        if(listitem == 1) { mysql_tquery(MainPipeline, "SELECT `id`,`username` FROM `accounts` ORDER BY `username` ASC LIMIT 100", "ER_OnFamilyLeaderOfflineList", "i", playerid); return 1; }
        new fid = GetPVarInt(playerid, "EditingFamily"), q[256];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `leader_id`=0,`leader_name`='Nobody' WHERE `id`=%d", fid); mysql_tquery(MainPipeline, q); ER_LoadFamilies(); return ER_ShowFamilyEditor(playerid, fid);
    }
    if(dialogid == DIALOG_FAMILY_LEADER_ONLINE)
    {
        if(!response) return ER_ShowFamilyEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
        new target; if(sscanf(inputtext, "u", target) || !IsPlayerConnected(target)) return ER_Send(playerid, COLOR_GREY, "Player not found."), ER_ShowFamilyEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
        return ER_SetFamilyLeaderAccount(playerid, GetPVarInt(playerid, "EditingFamily"), PlayerInfo[target][pID], PlayerInfo[target][pName]);
    }
    if(dialogid == DIALOG_FAMILY_LEADER_OFFLINE)
    {
        if(!response) return ER_ShowFamilyEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
        new accountid = FamilyLeaderSelectSQL[playerid][listitem]; if(accountid <= 0) return ER_ShowFamilyEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
        new name[MAX_PLAYER_NAME_EX]; format(name, sizeof(name), "%s", FamilyLeaderSelectName[playerid][listitem]);
        return ER_SetFamilyLeaderAccount(playerid, GetPVarInt(playerid, "EditingFamily"), accountid, name);
    }
    if(dialogid == DIALOG_FAMILY_COLOR_SELECT)
    {
        if(!response) return ER_ShowFamilyEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
        new fid = GetPVarInt(playerid, "EditingFamily"), field = GetPVarInt(playerid, "FamilyColorField"), color = ER_GetNamedColorValue(listitem), q[160];
        if(field == 1) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `radio_color`=%d,`color`=%d WHERE `id`=%d", color, color, fid);
        else mysql_format(MainPipeline, q, sizeof(q), "UPDATE `families` SET `crew_color`=%d WHERE `id`=%d", color, fid);
        mysql_tquery(MainPipeline, q); ER_LoadFamilies(); return ER_ShowFamilyEditor(playerid, fid);
    }
    if(dialogid == DIALOG_FAMILY_CREW_INVITE)
    {
        if(!response) return 1;
        new crew = listitem, target = FamilyCrewSelectTarget[playerid];
        if(!IsPlayerConnected(target)) return 1;
        if(FamilyCrewSelectMode[playerid] == 2)
        {
            PlayerInfo[target][pFamilyCrew] = crew;
            new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `family_crew`=%d WHERE `id`=%d", crew, PlayerInfo[target][pID]); mysql_tquery(MainPipeline, q);
            ER_Send(playerid, COLOR_GREEN, "Crew updated."); ER_Send(target, COLOR_GREEN, "Your crew was updated.");
        }
        else
        {
            SetPVarInt(target, "PendingCrewInvite", crew);
            ER_Send(target, COLOR_YELLOW, "You received a crew invite. Use /accept crew.");
            ER_Send(playerid, COLOR_GREEN, "Crew invite sent.");
        }
        return 1;
    }
    return 0;
}
