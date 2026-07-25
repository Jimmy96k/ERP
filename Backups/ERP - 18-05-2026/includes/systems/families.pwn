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
        cache_get_value_name_int(r, "business_safe_deposit_rank", Families[FamilyCount][fBusinessSafeDepositRank]);
        cache_get_value_name_int(r, "business_safe_withdraw_rank", Families[FamilyCount][fBusinessSafeWithdrawRank]);
        cache_get_value_name_int(r, "business_restock_rank", Families[FamilyCount][fBusinessRestockRank]);
        cache_get_value_name_int(r, "business_lock_rank", Families[FamilyCount][fBusinessLockRank]);
        cache_get_value_name_int(r, "door_lock_rank", Families[FamilyCount][fDoorLockRank]);
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
    for(new r; r < 6; r++) { mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `family_ranks` (`family_id`,`rank_id`,`rank_name`) VALUES (%d,%d,'%e')", fid, r+1, ranks[r]); mysql_tquery(MainPipeline, q); }
    new crews[3][24] = {"Main Crew", "Street Crew", "Business Crew"};
    for(new c; c < 3; c++) { mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `family_crews` (`family_id`,`crew_id`,`crew_name`) VALUES (%d,%d,'%e')", fid, c+1, crews[c]); mysql_tquery(MainPipeline, q); }
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

    format(msg, sizeof(msg), "(( Family | %s | Crew: %s )) %s: %s", rankname, crewname, dname, params);
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
    for(new c = 1; c <= 3 && c <= MAX_FAMILY_CREWS; c++)
    {
        ER_GetFamilyCrewName(fid, c, name, sizeof(name));
        format(list, sizeof(list), "%s%d - %s\n", list, c, name);
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
    new idx = ER_FindFamilyIndexBySQLID(fid), list[768];
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid family."), 1;
    format(list, sizeof(list),
        "Set MOTD >= %d\nInvite & Kick >= %d\nPoint Capture >= %d\nTurf Capture >= %d\nSafe Deposit >= %d\nSafe Withdraw >= %d\nLocker Deposit >= %d\nLocker Withdraw >= %d\nGun Locker >= %d",
        Families[idx][fSetMOTDRank], Families[idx][fInviteKickRank], Families[idx][fPointCaptureRank], Families[idx][fTurfCaptureRank],
        Families[idx][fSafeDepositRank], Families[idx][fSafeWithdrawRank], Families[idx][fLockerDepositRank], Families[idx][fLockerWithdrawRank], Families[idx][fLockerGunRank]);
    ShowPlayerDialog(playerid, DIALOG_FAMILY_PERMS, DIALOG_STYLE_LIST, "Family Permissions", list, "Edit", "Back");
    return 1;
}

stock ER_ShowFamilyLockerEditor(playerid, fid)
{
    SetPVarInt(playerid, "EditingFamily", fid);
    SetPVarInt(playerid, "FamilyInputField", 60);
    ShowPlayerDialog(playerid, DIALOG_FAMILY_LOCKERS, DIALOG_STYLE_LIST, "Family Locker", "Set Locker Position Here\nSet Safe Position Here\nGun Locker Weapons", "Select", "Back");
    return 1;
}

stock ER_SetFamilyLockerPos(playerid, fid)
{
    new Float:x, Float:y, Float:z, Float:a, q[256];
    GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `family_lockers` SET `x`=%f,`y`=%f,`z`=%f,`a`=%f,`interior`=%d,`vw`=%d,`enabled`=1 WHERE `family_id`=%d LIMIT 1", x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), fid);
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

stock ER_ShowFamilyEditor(playerid, fid)
{
    SetPVarInt(playerid, "EditingFamily", fid);
    ShowPlayerDialog(playerid, DIALOG_FAMILY_EDITOR, DIALOG_STYLE_LIST, "Family Editor", "Name\nLeader\nMOTD\nFamily Chat Color\nCrew Chat Color\nRanks\nCrews\nLockers\nSafes\nPermissions\nStatus\nReload This Family", "Select", "Close");
    return 1;
}


stock ER_SetFamilyLeaderAccount(playerid, fid, accountid, const accountName[])
{
    if(fid <= 0 || accountid <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid account."), 1;
    new q[768];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `factions` SET `leader_id`=0,`leader_name`='Nobody' WHERE `leader_id`=%d; UPDATE `families` SET `leader_id`=0,`leader_name`='Nobody' WHERE `leader_id`=%d AND `id`<>%d; UPDATE `accounts` SET `faction_id`=0,`faction_rank`=0,`faction_division`=0,`family_id`=%d,`family_rank`=6,`family_crew`=0 WHERE `id`=%d; UPDATE `families` SET `leader_id`=%d,`leader_name`='%e' WHERE `id`=%d", accountid, accountid, fid, fid, accountid, accountid, accountName, fid);
    mysql_tquery(MainPipeline, q);
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pID] == accountid) { PlayerInfo[i][pFaction] = 0; PlayerInfo[i][pFactionRank] = 0; PlayerInfo[i][pFactionDivision] = 0; PlayerInfo[i][pFamily] = fid; PlayerInfo[i][pFamilyRank] = 6; PlayerInfo[i][pFamilyCrew] = 0; }
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
        SetPVarInt(playerid, "FamilyInputField", 10 + listitem + 1);
        ShowPlayerDialog(playerid, DIALOG_FAMILY_INPUT, DIALOG_STYLE_INPUT, "Edit Family Rank", "Enter new rank name:", "Save", "Back");
        return 1;
    }
    if(dialogid == DIALOG_FAMILY_CREWS)
    {
        if(!response) return ER_ShowFamilyEditor(playerid, GetPVarInt(playerid, "EditingFamily"));
        SetPVarInt(playerid, "FamilyInputField", 20 + listitem + 1);
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
        if(listitem == 0) ER_SetFamilyLockerPos(playerid, fid);
        else if(listitem == 1) ER_SetFamilySafePos(playerid, fid);
        else ER_Send(playerid, COLOR_GREY, "Gun locker weapons are saved in SQL; use /gunlocker at the locker position to manage or use stored weapons.");
        return ER_ShowFamilyEditor(playerid, fid);
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
        else if(field >= 10 && field < 20) mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `family_ranks` (`family_id`,`rank_id`,`rank_name`) VALUES (%d,%d,'%e') ON DUPLICATE KEY UPDATE `rank_name`=VALUES(`rank_name`)", fid, field - 9, inputtext);
        else if(field >= 20 && field < 30) mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `family_crews` (`family_id`,`crew_id`,`crew_name`) VALUES (%d,%d,'%e') ON DUPLICATE KEY UPDATE `crew_name`=VALUES(`crew_name`)", fid, field - 19, inputtext);
        else if(field >= 30 && field < 45)
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
                case 9: format(col, sizeof(col), "business_safe_deposit_rank");
                case 10: format(col, sizeof(col), "business_safe_withdraw_rank");
                case 11: format(col, sizeof(col), "business_restock_rank");
                case 12: format(col, sizeof(col), "business_lock_rank");
                case 13: format(col, sizeof(col), "door_lock_rank");
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
        new crew = listitem + 1, target = FamilyCrewSelectTarget[playerid];
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
