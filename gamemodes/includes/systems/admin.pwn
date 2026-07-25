#if defined _ER_ADMIN_INCLUDED
    #endinput
#endif
#define _ER_ADMIN_INCLUDED

CMD:setadmin(playerid, params[])
{
    new target, level;
    if(!ER_IsAdmin(playerid, ADMIN_EXEC)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "ui", target, level)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setadmin [playerid/name] [1/2/4/5/1337/99999]");
    if(level != 0 && level != 1 && level != 2 && level != 4 && level != 5 && level != 1337 && level != 99999) return ER_Send(playerid, COLOR_GREY, "Invalid admin level.");
    PlayerInfo[target][pAdmin] = level;
    ER_Send(playerid, COLOR_GREEN, "Admin level updated.");
    return 1;
}

CMD:setvip(playerid, params[])
{
    new target, level;
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "ui", target, level)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setvip [playerid/name] [0-5]");
    if(level < 0 || level > 5) return ER_Send(playerid, COLOR_GREY, "VIP level must be 0-5.");
    PlayerInfo[target][pPlayerVip] = level;
    return ER_Send(playerid, COLOR_GREEN, "VIP level updated.");
}


stock ER_AdminStatFieldName(field, name[], size)
{
    switch(field)
    {
        case 0: format(name, size, "Admin Level");
        case 1: format(name, size, "VIP Level");
        case 2: format(name, size, "Level");
        case 3: format(name, size, "Skin");
        case 4: format(name, size, "Cash");
        case 5: format(name, size, "Bank Money");
        case 6: format(name, size, "Materials");
        case 7: format(name, size, "Pot");
        case 8: format(name, size, "Crack");
        case 9: format(name, size, "Rope");
        case 10: format(name, size, "Packages");
        case 11: format(name, size, "Seeds");
        case 12: format(name, size, "Sprunk");
        case 13: format(name, size, "Cigar");
        case 14: format(name, size, "Spray Cans");
        case 15: format(name, size, "Respect Points");
        case 16: format(name, size, "Warnings");
        case 17: format(name, size, "Wanted Level");
        case 18: format(name, size, "Family ID");
        case 19: format(name, size, "Family Rank");
        case 20: format(name, size, "Family Crew");
        case 21: format(name, size, "Faction ID");
        case 22: format(name, size, "Faction Rank");
        case 23: format(name, size, "Faction Division");
        case 24: format(name, size, "Business ID");
        case 25: format(name, size, "Max Vehicles");
        case 26: format(name, size, "Max Houses");
        case 27: format(name, size, "Max Businesses");
        case 28: format(name, size, "Max Toys");
        case 29: format(name, size, "Hotwiring Level");
        case 30: format(name, size, "Hotwire Kits");
        case 31: format(name, size, "Has MP3");
        default: format(name, size, "Unknown");
    }
    return 1;
}

stock ER_AdminStatColumn(field, col[], size)
{
    switch(field)
    {
        case 0: format(col, size, "admin");
        case 1: format(col, size, "vip");
        case 2: format(col, size, "level");
        case 3: format(col, size, "skin");
        case 4: format(col, size, "cash");
        case 5: format(col, size, "bank");
        case 6: format(col, size, "materials");
        case 7: format(col, size, "pot");
        case 8: format(col, size, "crack");
        case 9: format(col, size, "rope");
        case 10: format(col, size, "packages");
        case 11: format(col, size, "seeds");
        case 12: format(col, size, "sprunk");
        case 13: format(col, size, "cigar");
        case 14: format(col, size, "spraycans");
        case 15: format(col, size, "respect_points");
        case 16: format(col, size, "warnings");
        case 17: format(col, size, "wanted_level");
        case 18: format(col, size, "family_id");
        case 19: format(col, size, "family_rank");
        case 20: format(col, size, "family_crew");
        case 21: format(col, size, "faction_id");
        case 22: format(col, size, "faction_rank");
        case 23: format(col, size, "faction_division");
        case 24: format(col, size, "business_id");
        case 25: format(col, size, "max_vehicles");
        case 26: format(col, size, "max_houses");
        case 27: format(col, size, "max_businesses");
        case 28: format(col, size, "max_toys");
        case 29: format(col, size, "hotwire_level");
        case 30: format(col, size, "hotwire_kits");
        case 31: format(col, size, "has_mp3");
        default: return 0;
    }
    return 1;
}

stock ER_AdminGetOnlineStat(target, field)
{
    switch(field)
    {
        case 0: return PlayerInfo[target][pAdmin];
        case 1: return PlayerInfo[target][pPlayerVip];
        case 2: return PlayerInfo[target][pLevel];
        case 3: return PlayerInfo[target][pSkin];
        case 4: return PlayerInfo[target][pCash];
        case 5: return PlayerInfo[target][pBank];
        case 6: return PlayerInfo[target][pMaterials];
        case 7: return PlayerInfo[target][pPot];
        case 8: return PlayerInfo[target][pCrack];
        case 9: return PlayerInfo[target][pRope];
        case 10: return PlayerInfo[target][pPackages];
        case 11: return PlayerInfo[target][pSeeds];
        case 12: return PlayerInfo[target][pSprunk];
        case 13: return PlayerInfo[target][pCigar];
        case 14: return PlayerInfo[target][pSprayCans];
        case 15: return PlayerInfo[target][pRespectPoints];
        case 16: return PlayerInfo[target][pWarnings];
        case 17: return PlayerInfo[target][pWantedLevel];
        case 18: return PlayerInfo[target][pFamily];
        case 19: return PlayerInfo[target][pFamilyRank];
        case 20: return PlayerInfo[target][pFamilyCrew];
        case 21: return PlayerInfo[target][pFaction];
        case 22: return PlayerInfo[target][pFactionRank];
        case 23: return PlayerInfo[target][pFactionDivision];
        case 24: return PlayerInfo[target][pBusiness];
        case 25: return ER_GetMaxVehicles(target);
        case 26: return ER_GetMaxHouses(target);
        case 27: return ER_GetMaxBusinesses(target);
        case 28: return ER_GetMaxToys(target);
        case 29: return PlayerInfo[target][pHotwireLevel];
        case 30: return PlayerInfo[target][pHotwireKits];
        case 31: return PlayerInfo[target][pHasMP3];
    }
    return 0;
}

stock ER_AdminFormatStatValue(field, value, out[], size)
{
    if(field == 0)
    {
        if(value == 0) format(out, size, "None");
        else format(out, size, "%d", value);
        return 1;
    }
    if(field == 31)
    {
        format(out, size, "%s", value ? ("Yes") : ("No"));
        return 1;
    }
    if((field == 18 || field == 21 || field == 24) && value == 0)
    {
        format(out, size, "None");
        return 1;
    }
    if((field == 19 || field == 20 || field == 22 || field == 23) && value == 0)
    {
        format(out, size, "None");
        return 1;
    }
    format(out, size, "%d", value);
    return 1;
}


stock ER_AdminEffectiveLimitByVip(field, vip)
{
    if(vip < 0) vip = 0;
    if(vip > 5) vip = 5;
    switch(field)
    {
        case 25: return ServerCore[scVipMaxVehicles][vip] > 0 ? ServerCore[scVipMaxVehicles][vip] : ServerCore[scDefaultMaxVehicles];
        case 26: return ServerCore[scVipMaxHouses][vip] > 0 ? ServerCore[scVipMaxHouses][vip] : ServerCore[scDefaultMaxHouses];
        case 27: return ServerCore[scVipMaxBusinesses][vip] > 0 ? ServerCore[scVipMaxBusinesses][vip] : ServerCore[scDefaultMaxBusinesses];
        case 28: return ServerCore[scVipMaxToys][vip] > 0 ? ServerCore[scVipMaxToys][vip] : ServerCore[scDefaultMaxToys];
    }
    return 0;
}

stock ER_AdminFormatLimitValue(field, rawvalue, effective, out[], size)
{
    if(field >= 25 && field <= 28)
    {
        if(rawvalue <= 0) format(out, size, "%d (Default/VIP)", effective);
        else format(out, size, "%d (Custom)", rawvalue);
        return 1;
    }
    return 0;
}


stock ER_AdminGetRawLimitStat(playerid, field)
{
    switch(field)
    {
        case 25: return PlayerInfo[playerid][pMaxVehicles];
        case 26: return PlayerInfo[playerid][pMaxHouses];
        case 27: return PlayerInfo[playerid][pMaxBusinesses];
        case 28: return PlayerInfo[playerid][pMaxToys];
    }
    return 0;
}

stock ER_AdminShowOnlineStatMenu(playerid, target)
{
    new list[4096], line[160], fname[48], fval[48], value;
    SetPVarInt(playerid, "SetStatTarget", target);
    for(new f; f < 32; f++)
    {
        value = ER_AdminGetOnlineStat(target, f);
        ER_AdminStatFieldName(f, fname, sizeof(fname));
        if(f >= 25 && f <= 28) ER_AdminFormatLimitValue(f, ER_AdminGetRawLimitStat(target, f), value, fval, sizeof(fval));
        else ER_AdminFormatStatValue(f, value, fval, sizeof(fval));
        format(line, sizeof(line), "%s: %s\n", fname, fval);
        strcat(list, line, sizeof(list));
    }
    new title[96]; format(title, sizeof(title), "Set Stat - %s", ER_GetName(target));
    return ShowPlayerDialog(playerid, DIALOG_SETSTAT_MENU, DIALOG_STYLE_LIST, title, list, "Edit", "Close");
}

stock ER_AdminApplyOnlineStat(playerid, target, field, value)
{
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Target is not logged in.");
    if(field == 18 && value > 0 && PlayerInfo[target][pFaction] > 0) return ER_Send(playerid, COLOR_GREY, "This player is already in a faction. Remove faction first.");
    if(field == 21 && value > 0 && PlayerInfo[target][pFamily] > 0) return ER_Send(playerid, COLOR_GREY, "This player is already in a family. Remove family first.");
    switch(field)
    {
        case 0: PlayerInfo[target][pAdmin] = value;
        case 1: PlayerInfo[target][pPlayerVip] = value;
        case 2: PlayerInfo[target][pLevel] = value;
        case 3: { PlayerInfo[target][pSkin] = value; SetPlayerSkin(target, value); }
        case 4: { PlayerInfo[target][pCash] = value; ResetPlayerMoney(target); GivePlayerMoney(target, value); }
        case 5: PlayerInfo[target][pBank] = value;
        case 6: PlayerInfo[target][pMaterials] = value;
        case 7: PlayerInfo[target][pPot] = value;
        case 8: PlayerInfo[target][pCrack] = value;
        case 9: PlayerInfo[target][pRope] = value;
        case 10: PlayerInfo[target][pPackages] = value;
        case 11: PlayerInfo[target][pSeeds] = value;
        case 12: PlayerInfo[target][pSprunk] = value;
        case 13: PlayerInfo[target][pCigar] = value;
        case 14: PlayerInfo[target][pSprayCans] = value;
        case 15: PlayerInfo[target][pRespectPoints] = value;
        case 16: PlayerInfo[target][pWarnings] = value;
        case 17: PlayerInfo[target][pWantedLevel] = value;
        case 18:
        {
            PlayerInfo[target][pFamily] = value;
            if(value == 0) { PlayerInfo[target][pFamilyRank] = 0; PlayerInfo[target][pFamilyCrew] = 0; }
            else if(PlayerInfo[target][pFamilyRank] < 1) PlayerInfo[target][pFamilyRank] = 1;
        }
        case 19: PlayerInfo[target][pFamilyRank] = value;
        case 20: PlayerInfo[target][pFamilyCrew] = value;
        case 21:
        {
            PlayerInfo[target][pFaction] = value;
            if(value == 0) { PlayerInfo[target][pFactionRank] = 0; PlayerInfo[target][pFactionDivision] = 0; }
            else if(PlayerInfo[target][pFactionRank] < 1) PlayerInfo[target][pFactionRank] = 1;
        }
        case 22: PlayerInfo[target][pFactionRank] = value;
        case 23: PlayerInfo[target][pFactionDivision] = value;
        case 24: PlayerInfo[target][pBusiness] = value;
        case 25: PlayerInfo[target][pMaxVehicles] = value;
        case 26: PlayerInfo[target][pMaxHouses] = value;
        case 27: PlayerInfo[target][pMaxBusinesses] = value;
        case 28: PlayerInfo[target][pMaxToys] = value;
        case 29: PlayerInfo[target][pHotwireLevel] = value;
        case 30: PlayerInfo[target][pHotwireKits] = value;
        case 31: PlayerInfo[target][pHasMP3] = value ? 1 : 0;
    }
    ER_SaveCharacter(target);
    ER_Send(playerid, COLOR_GREEN, "Player stat updated and saved.");
    return ER_AdminShowOnlineStatMenu(playerid, target);
}

CMD:setstat(playerid, params[])
{
    new target;
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setstat [playerid/name]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Target is not logged in.");
    return ER_AdminShowOnlineStatMenu(playerid, target);
}

CMD:osetstat(playerid, params[])
{
    new pid, field[32], value[64], q[256];
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(isnull(params))
    {
        mysql_tquery(MainPipeline, "SELECT `id`,`username`,`level`,`admin`,`vip`,`family_id`,`faction_id` FROM `accounts` ORDER BY `username` ASC LIMIT 200", "ER_OnOSetStatPlayers", "i", playerid);
        return 1;
    }
    if(!sscanf(params, "ds[32]s[64]", pid, field, value))
    {
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `%e`='%e' WHERE `id`=%d", field, value, pid);
        mysql_tquery(MainPipeline, q);
        return ER_Send(playerid, COLOR_GREEN, "Offline stat update sent.");
    }
    return ER_Send(playerid, COLOR_GREY, "USAGE: /osetstat OR /osetstat [pID] [field] [value]");
}

forward ER_OnOSetStatPlayers(playerid);
public ER_OnOSetStatPlayers(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows = cache_num_rows();
    if(!rows) return ER_Send(playerid, COLOR_GREY, "No accounts found.");
    new list[4096], line[160], accid, username[MAX_PLAYER_NAME_EX], lvl, adm, vip, fam, fac;
    if(rows > 128) rows = 128;
    SetPVarInt(playerid, "OSetCount", rows);
    for(new i; i < rows; i++)
    {
        cache_get_value_name_int(i, "id", accid);
        cache_get_value_name(i, "username", username, sizeof(username));
        cache_get_value_name_int(i, "level", lvl);
        cache_get_value_name_int(i, "admin", adm);
        cache_get_value_name_int(i, "vip", vip);
        cache_get_value_name_int(i, "family_id", fam);
        cache_get_value_name_int(i, "faction_id", fac);
        format(line, sizeof(line), "%s (ID: %d) | Level: %d | Admin: %d | VIP: %d | Fam: %d | Fac: %d\n", username, accid, lvl, adm, vip, fam, fac);
        strcat(list, line, sizeof(list));
        format(line, sizeof(line), "OSetPID_%d", i); SetPVarInt(playerid, line, accid);
    }
    return ShowPlayerDialog(playerid, DIALOG_OSETSTAT_PLAYER_LIST, DIALOG_STYLE_LIST, "Offline Set Stat - Select Account", list, "Select", "Close");
}

stock ER_OSetLoadAccount(playerid, pid)
{
    new q[160];
    SetPVarInt(playerid, "OSetPID", pid);
    mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `accounts` WHERE `id`=%d LIMIT 1", pid);
    mysql_tquery(MainPipeline, q, "ER_OnOSetStatAccount", "i", playerid);
    return 1;
}

stock ER_OSetCacheInt(const col[])
{
    new v; cache_get_value_name_int(0, col, v); return v;
}

forward ER_OnOSetStatAccount(playerid);
public ER_OnOSetStatAccount(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(!cache_num_rows()) return ER_Send(playerid, COLOR_GREY, "Account not found.");
    new list[4096], line[160], fname[48], fval[48], col[32], value, username[MAX_PLAYER_NAME_EX];
    cache_get_value_name(0, "username", username, sizeof(username));
    for(new f; f < 32; f++)
    {
        ER_AdminStatFieldName(f, fname, sizeof(fname));
        ER_AdminStatColumn(f, col, sizeof(col));
        value = ER_OSetCacheInt(col);
        if(f >= 25 && f <= 28) ER_AdminFormatLimitValue(f, value, ER_AdminEffectiveLimitByVip(f, ER_OSetCacheInt("vip")), fval, sizeof(fval));
        else ER_AdminFormatStatValue(f, value, fval, sizeof(fval));
        format(line, sizeof(line), "%s: %s\n", fname, fval);
        strcat(list, line, sizeof(list));
    }
    new title[96]; format(title, sizeof(title), "Offline Set Stat - %s", username);
    return ShowPlayerDialog(playerid, DIALOG_OSETSTAT_MENU, DIALOG_STYLE_LIST, title, list, "Edit", "Back");
}

stock ER_OSetApply(playerid, pid, field, value)
{
    new q[256], col[32];
    if(!ER_AdminStatColumn(field, col, sizeof(col))) return ER_Send(playerid, COLOR_GREY, "Invalid stat field.");
    SetPVarInt(playerid, "OSetField", field);
    SetPVarInt(playerid, "OSetValue", value);
    if(field == 18 || field == 21)
    {
        mysql_format(MainPipeline, q, sizeof(q), "SELECT `family_id`,`faction_id` FROM `accounts` WHERE `id`=%d LIMIT 1", pid);
        mysql_tquery(MainPipeline, q, "ER_OnOSetMembershipCheck", "ii", playerid, pid);
        return 1;
    }
    if(field == 31) value = value ? 1 : 0;
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `%e`=%d WHERE `id`=%d", col, value, pid);
    mysql_tquery(MainPipeline, q);
    ER_Send(playerid, COLOR_GREEN, "Offline stat updated.");
    return ER_OSetLoadAccount(playerid, pid);
}

forward ER_OnOSetMembershipCheck(playerid, pid);
public ER_OnOSetMembershipCheck(playerid, pid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(!cache_num_rows()) return ER_Send(playerid, COLOR_GREY, "Account not found.");
    new fam, fac, field = GetPVarInt(playerid, "OSetField"), value = GetPVarInt(playerid, "OSetValue"), q[256];
    cache_get_value_name_int(0, "family_id", fam);
    cache_get_value_name_int(0, "faction_id", fac);
    if(field == 18 && value > 0 && fac > 0) return ER_Send(playerid, COLOR_GREY, "This account is already in a faction. Remove faction first.");
    if(field == 21 && value > 0 && fam > 0) return ER_Send(playerid, COLOR_GREY, "This account is already in a family. Remove family first.");
    if(field == 18)
    {
        if(value == 0) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `family_id`=0,`family_rank`=0,`family_crew`=0 WHERE `id`=%d", pid);
        else mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `family_id`=%d,`family_rank`=1,`family_crew`=0 WHERE `id`=%d", value, pid);
    }
    else if(field == 21)
    {
        if(value == 0) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `faction_id`=0,`faction_rank`=0,`faction_division`=0 WHERE `id`=%d", pid);
        else mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `faction_id`=%d,`faction_rank`=1,`faction_division`=0 WHERE `id`=%d", value, pid);
    }
    mysql_tquery(MainPipeline, q);
    ER_Send(playerid, COLOR_GREEN, "Offline membership stat updated.");
    return ER_OSetLoadAccount(playerid, pid);
}

CMD:a(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_MOD))
    {
        return ER_Send(playerid, COLOR_GREY,
            "You are not authorized.");
    }
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /a [message]");
    new msg[160]; format(msg, sizeof(msg), "** Admin %s: %s", ER_GetName(playerid), params);
    foreach(new i : Player) if(ER_IsAdmin(i, ADMIN_MOD)) SendClientMessage(i, COLOR_LIGHTRED, msg);
    return 1;
}

stock ER_AdminGotoBusiness(playerid, id)
{
    new idx = ER_FindBusinessIndexBySQLID(id);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business ID.");
    SetPlayerInterior(playerid, Businesses[idx][bExtInt]);
    SetPlayerVirtualWorld(playerid, Businesses[idx][bExtVW]);
    SetPlayerPos(playerid, Businesses[idx][bExtX] + 1.0, Businesses[idx][bExtY], Businesses[idx][bExtZ]);
    SetCameraBehindPlayer(playerid);
    return ER_Send(playerid, COLOR_GREEN, "Teleported to business.");
}

stock ER_AdminGotoHouse(playerid, id)
{
    new idx = ER_FindHouseIndexBySQLID(id);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid house ID.");
    SetPlayerInterior(playerid, Houses[idx][hExtInt]);
    SetPlayerVirtualWorld(playerid, Houses[idx][hExtVW]);
    SetPlayerPos(playerid, Houses[idx][hExtX] + 1.0, Houses[idx][hExtY], Houses[idx][hExtZ]);
    SetCameraBehindPlayer(playerid);
    return ER_Send(playerid, COLOR_GREEN, "Teleported to house.");
}

stock ER_AdminGotoDoor(playerid, id)
{
    new idx = ER_FindDoorIndexBySQLID(id);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid door ID.");
    SetPlayerInterior(playerid, Doors[idx][dExtInt]);
    SetPlayerVirtualWorld(playerid, Doors[idx][dExtVW]);
    SetPlayerPos(playerid, Doors[idx][dExtX] + 1.0, Doors[idx][dExtY], Doors[idx][dExtZ]);
    SetCameraBehindPlayer(playerid);
    return ER_Send(playerid, COLOR_GREEN, "Teleported to door.");
}

stock ER_AdminGotoVehicle(playerid, id)
{
    new idx = ER_FindVehicleBySQLID(id);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid vehicle ID.");
    SetPlayerInterior(playerid, VehicleInfo[idx][vInt]);
    SetPlayerVirtualWorld(playerid, VehicleInfo[idx][vVW]);
    SetPlayerPos(playerid, VehicleInfo[idx][vX] + 2.0, VehicleInfo[idx][vY], VehicleInfo[idx][vZ]);
    SetCameraBehindPlayer(playerid);
    return ER_Send(playerid, COLOR_GREEN, "Teleported to vehicle.");
}

stock ER_ShowAdminGotoList(playerid, type)
{
    new list[4096], line[160], count;
    SetPVarInt(playerid, "AdminGotoType", type);
    if(type == 1)
    {
        for(new i; i < BusinessCount && count < 128; i++)
        {
            format(line, sizeof(line), "%d - %s\n", Businesses[i][bSQLID], Businesses[i][bName]);
            strcat(list, line, sizeof(list));
            format(line, sizeof(line), "AdminGotoID_%d", count); SetPVarInt(playerid, line, Businesses[i][bSQLID]);
            count++;
        }
        if(!count) format(list, sizeof(list), "No businesses loaded.");
        SetPVarInt(playerid, "AdminGotoCount", count);
        return ShowPlayerDialog(playerid, DIALOG_ADMIN_GOTO_LIST, DIALOG_STYLE_LIST, "Goto Business", list, "Goto", "Close");
    }
    if(type == 2)
    {
        for(new i; i < HouseCount && count < 128; i++)
        {
            format(line, sizeof(line), "%d - %s\n", Houses[i][hSQLID], Houses[i][hZone]);
            strcat(list, line, sizeof(list));
            format(line, sizeof(line), "AdminGotoID_%d", count); SetPVarInt(playerid, line, Houses[i][hSQLID]);
            count++;
        }
        if(!count) format(list, sizeof(list), "No houses loaded.");
        SetPVarInt(playerid, "AdminGotoCount", count);
        return ShowPlayerDialog(playerid, DIALOG_ADMIN_GOTO_LIST, DIALOG_STYLE_LIST, "Goto House", list, "Goto", "Close");
    }
    if(type == 3)
    {
        for(new i; i < DoorCount && count < 128; i++)
        {
            format(line, sizeof(line), "%d - %s\n", Doors[i][dSQLID], Doors[i][dName]);
            strcat(list, line, sizeof(list));
            format(line, sizeof(line), "AdminGotoID_%d", count); SetPVarInt(playerid, line, Doors[i][dSQLID]);
            count++;
        }
        if(!count) format(list, sizeof(list), "No doors loaded.");
        SetPVarInt(playerid, "AdminGotoCount", count);
        return ShowPlayerDialog(playerid, DIALOG_ADMIN_GOTO_LIST, DIALOG_STYLE_LIST, "Goto Door", list, "Goto", "Close");
    }
    if(type == 4)
    {
        format(list, sizeof(list), "ID\tVehID\tModel\tOwner\tLocation\n");
        for(new i; i < VehicleCount && count < 128; i++)
        {
            new owner[96], area[32];
            ER_GetVehicleOwnerTextEx(VehicleInfo[i][vOwnerPID], VehicleInfo[i][vFamilyID], VehicleInfo[i][vFactionID], VehicleInfo[i][vJobID], "", owner, sizeof(owner));
            ER_GetVehicleAreaName(VehicleInfo[i][vX], VehicleInfo[i][vY], VehicleInfo[i][vZ], area, sizeof(area));
            format(line, sizeof(line), "%d\t%d\t%s\t%s\t%s\n", VehicleInfo[i][vSQLID], VehicleInfo[i][vSpawnedID], ER_GetVehicleModelName(VehicleInfo[i][vModel]), owner, area);
            strcat(list, line, sizeof(list));
            format(line, sizeof(line), "AdminGotoID_%d", count); SetPVarInt(playerid, line, VehicleInfo[i][vSQLID]);
            count++;
        }
        if(!count) format(list, sizeof(list), "No vehicles loaded.");
        SetPVarInt(playerid, "AdminGotoCount", count);
        return ShowPlayerDialog(playerid, DIALOG_ADMIN_GOTO_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Goto Vehicle", list, "Goto", "Close");
    }
    return 1;
}


stock ER_AdminDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_ADMIN_GOTO_LIST)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= GetPVarInt(playerid, "AdminGotoCount")) return 1;
        new key[32]; format(key, sizeof(key), "AdminGotoID_%d", listitem);
        new id = GetPVarInt(playerid, key), type = GetPVarInt(playerid, "AdminGotoType");
        switch(type)
        {
            case 1: return ER_AdminGotoBusiness(playerid, id);
            case 2: return ER_AdminGotoHouse(playerid, id);
            case 3: return ER_AdminGotoDoor(playerid, id);
            case 4: return ER_AdminGotoVehicle(playerid, id);
        }
        return 1;
    }
    if(dialogid == DIALOG_SETSTAT_MENU)
    {
        if(!response) return 1;
        new target = GetPVarInt(playerid, "SetStatTarget"), fname[48], fval[48];
        if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Target is no longer online.");
        SetPVarInt(playerid, "SetStatField", listitem);
        ER_AdminStatFieldName(listitem, fname, sizeof(fname));
        ER_AdminFormatStatValue(listitem, ER_AdminGetOnlineStat(target, listitem), fval, sizeof(fval));
        new title[96], body[192];
        format(title, sizeof(title), "Edit %s", fname);
        if(listitem >= 25 && listitem <= 28) format(body, sizeof(body), "Current value: %s\n\nEnter new value, or 0 to use Default/VIP limit:", fval);
        else if(listitem == 31) format(body, sizeof(body), "Current value: %s\n\nEnter 1 for Yes or 0 for No:", fval);
        else format(body, sizeof(body), "Current value: %s\n\nEnter new value:", fval);
        return ShowPlayerDialog(playerid, DIALOG_SETSTAT_INPUT, DIALOG_STYLE_INPUT, title, body, "Save", "Back");
    }
    if(dialogid == DIALOG_SETSTAT_INPUT)
    {
        new target = GetPVarInt(playerid, "SetStatTarget");
        if(!response) return ER_AdminShowOnlineStatMenu(playerid, target);
        if(isnull(inputtext)) return ER_Send(playerid, COLOR_GREY, "Value cannot be empty.");
        return ER_AdminApplyOnlineStat(playerid, target, GetPVarInt(playerid, "SetStatField"), strval(inputtext));
    }
    if(dialogid == DIALOG_OSETSTAT_PLAYER_LIST)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= GetPVarInt(playerid, "OSetCount")) return 1;
        new key[32]; format(key, sizeof(key), "OSetPID_%d", listitem);
        return ER_OSetLoadAccount(playerid, GetPVarInt(playerid, key));
    }
    if(dialogid == DIALOG_OSETSTAT_MENU)
    {
        if(!response)
        {
            mysql_tquery(MainPipeline, "SELECT `id`,`username`,`level`,`admin`,`vip`,`family_id`,`faction_id` FROM `accounts` ORDER BY `username` ASC LIMIT 200", "ER_OnOSetStatPlayers", "i", playerid);
            return 1;
        }
        new pid = GetPVarInt(playerid, "OSetPID"), fname[48];
        SetPVarInt(playerid, "OSetField", listitem);
        ER_AdminStatFieldName(listitem, fname, sizeof(fname));
        new title[96], body[160];
        format(title, sizeof(title), "Offline Edit %s", fname);
        if(listitem >= 25 && listitem <= 28) format(body, sizeof(body), "Account ID: %d\nStat: %s\n\nEnter new value, or 0 to use Default/VIP limit:", pid, fname);
        else if(listitem == 31) format(body, sizeof(body), "Account ID: %d\nStat: %s\n\nEnter 1 for Yes or 0 for No:", pid, fname);
        else format(body, sizeof(body), "Account ID: %d\nStat: %s\n\nEnter new value:", pid, fname);
        return ShowPlayerDialog(playerid, DIALOG_OSETSTAT_INPUT, DIALOG_STYLE_INPUT, title, body, "Save", "Back");
    }
    if(dialogid == DIALOG_OSETSTAT_INPUT)
    {
        new pid = GetPVarInt(playerid, "OSetPID");
        if(!response) return ER_OSetLoadAccount(playerid, pid);
        if(isnull(inputtext)) return ER_Send(playerid, COLOR_GREY, "Value cannot be empty.");
        return ER_OSetApply(playerid, pid, GetPVarInt(playerid, "OSetField"), strval(inputtext));
    }
    if(dialogid == DIALOG_GIVEGUN_LIST)
    {
        if(!response) return 1;
        new target = GetPVarInt(playerid, "GiveGunTarget");
        if(target == INVALID_PLAYER_ID || !IsPlayerConnected(target)) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
        return ER_GiveGunByListIndex(playerid, target, listitem);
    }
    return 0;
}

CMD:goto(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY,"You are not authorized.");

    new type[16], id = -1;
    if(!sscanf(params, "s[16]D(-1)", type, id))
    {
        if(!strcmp(type, "ls", true)) { SetPlayerInterior(playerid,0); SetPlayerVirtualWorld(playerid,0); SetPlayerPos(playerid,1529.6,-1691.2,13.3); return 1; }
        if(!strcmp(type, "sf", true)) { SetPlayerInterior(playerid,0); SetPlayerVirtualWorld(playerid,0); SetPlayerPos(playerid,-1985.2,138.1,27.6); return 1; }
        if(!strcmp(type, "lv", true)) { SetPlayerInterior(playerid,0); SetPlayerVirtualWorld(playerid,0); SetPlayerPos(playerid,2028.5,1342.2,10.8); return 1; }
        if(!strcmp(type, "allsaints", true)) { SetPlayerInterior(playerid,0); SetPlayerVirtualWorld(playerid,0); SetPlayerPos(playerid,1172.0,-1323.5,15.4); return 1; }
        if(!strcmp(type, "countygen", true)) { SetPlayerInterior(playerid,0); SetPlayerVirtualWorld(playerid,0); SetPlayerPos(playerid,2034.0,-1402.7,17.3); return 1; }
        if(!strcmp(type, "business", true) || !strcmp(type, "biz", true))
        {
            if(id == -1) return ER_ShowAdminGotoList(playerid, 1);
            return ER_AdminGotoBusiness(playerid, id);
        }
        if(!strcmp(type, "house", true))
        {
            if(id == -1) return ER_ShowAdminGotoList(playerid, 2);
            return ER_AdminGotoHouse(playerid, id);
        }
        if(!strcmp(type, "door", true))
        {
            if(id == -1) return ER_ShowAdminGotoList(playerid, 3);
            return ER_AdminGotoDoor(playerid, id);
        }
        if(!strcmp(type, "veh", true) || !strcmp(type, "vehicle", true))
        {
            if(id == -1) return ER_ShowAdminGotoList(playerid, 4);
            return ER_AdminGotoVehicle(playerid, id);
        }
    }

    new target, Float:x, Float:y, Float:z;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /goto [playerid/name] OR /goto [business/house/door/veh] [id]");
    GetPlayerPos(target, x, y, z);
    SetPlayerInterior(playerid, GetPlayerInterior(target));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(target));
    SetPlayerPos(playerid, x+1.0, y, z);
    SetCameraBehindPlayer(playerid);
    return 1;
}

CMD:gotoco(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD))
    {
        return ER_Send(playerid, COLOR_GREY,"You are not authorized.");
    }
    new Float:x,Float:y,Float:z,vw = -1,interior = -1;

    if(sscanf(params, "fffDD", x, y, z, vw, interior))
    {
        return ER_Send(playerid, COLOR_GREY,"USAGE: /gotoco [x] [y] [z] [vw(optional)] [interior(optional)]");
    }
    SetPlayerPos(playerid, x, y, z);
    if(vw != -1)
    {
        SetPlayerVirtualWorld(playerid, vw);
    }
    if(interior != -1)
    {
        SetPlayerInterior(playerid, interior);
    }

    SetCameraBehindPlayer(playerid);

    return ER_Send(playerid, COLOR_GREEN,"You have been teleported successfully.");
}

CMD:gethere(playerid, params[])
{
    new target, Float:x, Float:y, Float:z;
    if(!ER_IsAdmin(playerid, ADMIN_MOD))
    {
        return ER_Send(playerid, COLOR_GREY,"You are not authorized.");
    }
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /gethere [playerid/name]");
    GetPlayerPos(playerid, x, y, z);
    SetPlayerInterior(target, GetPlayerInterior(playerid));
    SetPlayerVirtualWorld(target, GetPlayerVirtualWorld(playerid));
    SetPlayerPos(target, x+1.0, y, z);
    return 1;
}
CMD:nearestobj(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD))
    {
        return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    }

    new Float:ox, Float:oy, Float:oz;
    new modelid, str[144], count;

    SendClientMessage(playerid, COLOR_YELLOW, "Nearby dynamic objects within 10.0 units:");

    for(new i = 1; i < 20000; i++)
    {
        if(IsValidDynamicObject(i))
        {
            Streamer_GetFloatData(STREAMER_TYPE_OBJECT, i, E_STREAMER_X, ox);
            Streamer_GetFloatData(STREAMER_TYPE_OBJECT, i, E_STREAMER_Y, oy);
            Streamer_GetFloatData(STREAMER_TYPE_OBJECT, i, E_STREAMER_Z, oz);

            if(GetPlayerDistanceFromPoint(playerid, ox, oy, oz) < 10.0)
            {
                modelid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, i, E_STREAMER_MODEL_ID);

                format(str, sizeof(str),
                    "DynamicObject ID: %d | Model: %d | Distance: %.2f",
                    i,
                    modelid,
                    GetPlayerDistanceFromPoint(playerid, ox, oy, oz)
                );

                SendClientMessage(playerid, COLOR_WHITE, str);
                count++;
            }
        }
    }

    if(!count)
    {
        SendClientMessage(playerid, COLOR_GREY, "No nearby dynamic objects found.");
    }

    return 1;
}


stock ER_WeaponNameToID(const input[])
{
    if(!strlen(input)) return 0;
    if(input[0] >= '0' && input[0] <= '9') return strval(input);
    if(strfind("brassknuckle", input, true) != -1 || strfind("knuckle", input, true) != -1) return 1;
    if(strfind("golf", input, true) != -1) return 2;
    if(strfind("nightstick", input, true) != -1 || strfind("baton", input, true) != -1) return 3;
    if(strfind("knife", input, true) != -1) return 4;
    if(strfind("bat", input, true) != -1) return 5;
    if(strfind("shovel", input, true) != -1) return 6;
    if(strfind("pool", input, true) != -1) return 7;
    if(strfind("katana", input, true) != -1) return 8;
    if(strfind("chainsaw", input, true) != -1) return 9;
    if(strfind("dildo", input, true) != -1) return 10;
    if(strfind("flowers", input, true) != -1) return 14;
    if(strfind("cane", input, true) != -1) return 15;
    if(strfind("grenade", input, true) != -1) return 16;
    if(strfind("teargas", input, true) != -1 || strfind("tear", input, true) != -1) return 17;
    if(strfind("molotov", input, true) != -1) return 18;
    if(strfind("colt", input, true) != -1 || strfind("pistol", input, true) != -1 || strfind("9mm", input, true) != -1) return 22;
    if(strfind("silenced", input, true) != -1) return 23;
    if(strfind("deagle", input, true) != -1 || strfind("desert", input, true) != -1) return 24;
    if(strfind("shotgun", input, true) != -1) return 25;
    if(strfind("sawnoff", input, true) != -1 || strfind("sawn", input, true) != -1) return 26;
    if(strfind("spas", input, true) != -1 || strfind("combat", input, true) != -1) return 27;
    if(strfind("uzi", input, true) != -1) return 28;
    if(strfind("mp5", input, true) != -1) return 29;
    if(strfind("ak", input, true) != -1 || strfind("ak47", input, true) != -1) return 30;
    if(strfind("m4", input, true) != -1) return 31;
    if(strfind("tec", input, true) != -1) return 32;
    if(strfind("rifle", input, true) != -1 && strfind("sniper", input, true) == -1) return 33;
    if(strfind("sniper", input, true) != -1) return 34;
    if(strfind("rocket", input, true) != -1 || strfind("rpg", input, true) != -1) return 35;
    if(strfind("heat", input, true) != -1) return 36;
    if(strfind("flame", input, true) != -1) return 37;
    if(strfind("minigun", input, true) != -1) return 38;
    if(strfind("satchel", input, true) != -1) return 39;
    if(strfind("spray", input, true) != -1) return 41;
    if(strfind("exting", input, true) != -1) return 42;
    if(strfind("camera", input, true) != -1) return 43;
    if(strfind("parachute", input, true) != -1) return 46;
    return 0;
}

stock ER_ShowGiveGunList(playerid, target)
{
    SetPVarInt(playerid, "GiveGunTarget", target);
    return ShowPlayerDialog(playerid, DIALOG_GIVEGUN_LIST, DIALOG_STYLE_LIST, "Give Gun", "Colt 45\nSilenced Pistol\nDesert Eagle\nShotgun\nSawnoff Shotgun\nSPAS-12\nMicro UZI\nMP5\nAK-47\nM4\nTec-9\nRifle\nSniper Rifle\nSpraycan\nParachute", "Give", "Cancel");
}

stock ER_GiveGunByListIndex(playerid, target, listitem)
{
    new wid;
    switch(listitem)
    {
        case 0: wid = 22; case 1: wid = 23; case 2: wid = 24; case 3: wid = 25; case 4: wid = 26; case 5: wid = 27;
        case 6: wid = 28; case 7: wid = 29; case 8: wid = 30; case 9: wid = 31; case 10: wid = 32; case 11: wid = 33;
        case 12: wid = 34; case 13: wid = 41; case 14: wid = 46;
    }
    GivePlayerWeapon(target, wid, 0x7FFFFFFF);
    new msg[128]; format(msg, sizeof(msg), "You gave %s a %s.", ER_GetName(target), ER_GetWeaponNameEx(wid));
    return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:givegun(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR))
        return ER_Send(playerid, COLOR_GREY, "You are not authorized.");

    new target, weapon[32];

    if(sscanf(params, "uS()[32]", target, weapon))
        return ER_ShowGiveGunList(playerid, playerid);

    if(target == INVALID_PLAYER_ID || !IsPlayerConnected(target))
        return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    if(isnull(weapon))
        return ER_ShowGiveGunList(playerid, target);

    new wid = ER_WeaponNameToID(weapon);

    if(wid < 1 || wid > 46)
        return ER_Send(playerid, COLOR_GREY, "Invalid weapon. Use /givegun [player] [weapon id/name/partial].");

    GivePlayerWeapon(target, wid, 0x7FFFFFFF);

    new msg[144];
    format(msg, sizeof(msg), "You gave %s a %s.", ER_GetName(target), ER_GetWeaponNameEx(wid));

    return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:sethp(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new target, Float:hp; if(sscanf(params, "uf", target, hp)) return ER_Send(playerid, COLOR_GREY, "USAGE: /sethp [player] [health]");
    if(target == INVALID_PLAYER_ID || !IsPlayerConnected(target)) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(hp < 0.0) hp = 0.0; if(hp > 100.0) hp = 100.0;

    if(hp <= 0.0)
    {
        // Never save pHealth as 0 before SpawnPlayer(), otherwise OnPlayerSpawn restores
        // 0 HP and OnPlayerDeath loops forever. Trigger the death flow once instead.
        PlayerInfo[target][pHealth] = 35.0;
        SetPlayerHealth(target, 0.0);
        CallLocalFunction("OnPlayerDeath", "iii", target, INVALID_PLAYER_ID, 255);
    }
    else
    {
        SetPlayerHealth(target, hp);
        PlayerInfo[target][pHealth] = hp;
    }
    return ER_Send(playerid, COLOR_GREEN, "Health updated.");
}
CMD:kill(playerid, params[])
{
	SetPlayerHealth(playerid, 0.0);
    return 1;
}

CMD:setarmor(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new target, Float:ar; if(sscanf(params, "uf", target, ar)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setarmor [player] [armor]");
    if(target == INVALID_PLAYER_ID || !IsPlayerConnected(target)) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(ar < 0.0) ar = 0.0; if(ar > 100.0) ar = 100.0;
    SetPlayerArmour(target, ar); PlayerInfo[target][pArmor] = ar;
    return ER_Send(playerid, COLOR_GREEN, "Armour updated.");
}

CMD:gotols(playerid, params[]) { if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized."); SetPlayerInterior(playerid,0); SetPlayerVirtualWorld(playerid,0); SetPlayerPos(playerid,1529.6,-1691.2,13.3); return 1; }
CMD:gotolv(playerid, params[]) { if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized."); SetPlayerInterior(playerid,0); SetPlayerVirtualWorld(playerid,0); SetPlayerPos(playerid,2028.5,1342.2,10.8); return 1; }
CMD:gotosf(playerid, params[]) { if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized."); SetPlayerInterior(playerid,0); SetPlayerVirtualWorld(playerid,0); SetPlayerPos(playerid,-1985.2,138.1,27.6); return 1; }
CMD:gotoallsaints(playerid, params[]) { if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized."); SetPlayerInterior(playerid,0); SetPlayerVirtualWorld(playerid,0); SetPlayerPos(playerid,1172.0,-1323.5,15.4); return 1; }
CMD:gotocountygen(playerid, params[]) { if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized."); SetPlayerInterior(playerid,0); SetPlayerVirtualWorld(playerid,0); SetPlayerPos(playerid,2034.0,-1402.7,17.3); return 1; }

