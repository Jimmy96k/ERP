#if defined _ER_SERVERCORE_INCLUDED
    #endinput
#endif
#define _ER_SERVERCORE_INCLUDED

stock ER_LoadServerCore()
{
    mysql_tquery(MainPipeline, "SELECT `keyname`,`value` FROM `servercore`", "ER_OnServerCoreLoad");
    mysql_tquery(MainPipeline, "SELECT * FROM `weapon_material_costs`", "ER_OnWeaponCostsLoad");
    return 1;
}

forward ER_OnServerCoreLoad();
public ER_OnServerCoreLoad()
{
    new rows, key[64], val[128];
    cache_get_row_count(rows);

    format(ServerCore[scServerName], 64, SERVER_BRAND);
    ServerCore[scWebsite][0] = EOS;
    ServerCore[scDiscord][0] = EOS;
    ServerCore[scLoginTrack][0] = EOS;
    ServerCore[scRegisterTrack][0] = EOS;
    ServerCore[scDefaultCash] = 1000;
    ServerCore[scDefaultBank] = 9000;
    ServerCore[scDefaultSpawnX] = 1715.0687;
    ServerCore[scDefaultSpawnY] = -1899.5597;
    ServerCore[scDefaultSpawnZ] = 13.5665;
    ServerCore[scDefaultSpawnA] = 0.0;
    ServerCore[scDefaultSpawnInt] = 0;
    ServerCore[scDefaultSpawnVW] = 0;
    ServerCore[scDefaultMaleSkin] = 26;
    ServerCore[scDefaultFemaleSkin] = 12;
    ServerCore[scTutorialEnabled] = 1;
    ServerCore[scAllowSkipTutorial] = 1;
    ServerCore[scJobLimitDefault] = 1;
    ServerCore[scVipHospitalTransferMinLevel] = 1;
    ServerCore[scDeathHPDecrease] = 2.0;
    ServerCore[scDeathTickMS] = 5000;
    ServerCore[scHospitalRespawnHP] = 50.0;
    ServerCore[scFamilyBackupBeaconTime] = 120;
    ServerCore[scDefaultMaxVehicles] = 3;
    ServerCore[scDefaultMaxHouses] = 1;
    ServerCore[scDefaultMaxBusinesses] = 1;
    ServerCore[scDefaultMaxToys] = 5;
    ServerCore[scMaxFamilies] = MAX_FAMILIES;
    ServerCore[scMaxFactions] = 100;
    ServerCore[scMaxFamilyRanks] = MAX_FAMILY_RANKS;
    ServerCore[scMaxFactionRanks] = MAX_FACTION_RANKS;
    ServerCore[scMaxFamilyCrews] = MAX_FAMILY_CREWS;
    ServerCore[scMaxFactionDivisions] = MAX_FACTION_DIVISIONS;
    ServerCore[scPhoneDigits] = 4;
    ServerCore[scAllowVehicleEngineWithoutKeys] = 1;
    ServerCore[scAllowVehicleHotwire] = 1;
    ServerCore[scDefaultVehicleFuelConsumption] = 1.0;
    ServerCore[scVehicleIdleFuelEnabled] = 0;
    ServerCore[scVehicleIdleFuelGallonsPerTick] = 0.05;
    for(new i; i < 6; i++)
    {
        ServerCore[scVipJobLimit][i] = i + 1;
        ServerCore[scVipHospitalTime][i] = 30 - (i * 5);
        if(ServerCore[scVipHospitalTime][i] < 0) ServerCore[scVipHospitalTime][i] = 0;
        ServerCore[scVipMaxVehicles][i] = ServerCore[scDefaultMaxVehicles] + (i * 2);
        ServerCore[scVipMaxHouses][i] = ServerCore[scDefaultMaxHouses] + i;
        ServerCore[scVipMaxBusinesses][i] = ServerCore[scDefaultMaxBusinesses] + i;
        ServerCore[scVipMaxToys][i] = ServerCore[scDefaultMaxToys] + (i * 3);
    }

    for(new r; r < rows; r++)
    {
        cache_get_value_name(r, "keyname", key, sizeof(key));
        cache_get_value_name(r, "value", val, sizeof(val));
        if(!strcmp(key, "ServerName", true)) format(ServerCore[scServerName], 64, "%s", val);
        else if(!strcmp(key, "Website", true)) format(ServerCore[scWebsite], 96, "%s", val);
        else if(!strcmp(key, "Discord", true)) format(ServerCore[scDiscord], 96, "%s", val);
        else if(!strcmp(key, "News", true)) format(ServerCore[scNews], 128, "%s", val);
        else if(!strcmp(key, "LoginTrack", true)) format(ServerCore[scLoginTrack], 256, "%s", val);
        else if(!strcmp(key, "RegisterTrack", true)) format(ServerCore[scRegisterTrack], 256, "%s", val);
        else if(!strcmp(key, "DefaultCash", true)) ServerCore[scDefaultCash] = strval(val);
        else if(!strcmp(key, "DefaultBank", true)) ServerCore[scDefaultBank] = strval(val);
        else if(!strcmp(key, "DefaultSpawnX", true)) ServerCore[scDefaultSpawnX] = floatstr(val);
        else if(!strcmp(key, "DefaultSpawnY", true)) ServerCore[scDefaultSpawnY] = floatstr(val);
        else if(!strcmp(key, "DefaultSpawnZ", true)) ServerCore[scDefaultSpawnZ] = floatstr(val);
        else if(!strcmp(key, "DefaultSpawnA", true)) ServerCore[scDefaultSpawnA] = floatstr(val);
        else if(!strcmp(key, "DefaultSpawnInterior", true)) ServerCore[scDefaultSpawnInt] = strval(val);
        else if(!strcmp(key, "DefaultSpawnVW", true)) ServerCore[scDefaultSpawnVW] = strval(val);
        else if(!strcmp(key, "DefaultMaleSkin", true)) ServerCore[scDefaultMaleSkin] = strval(val);
        else if(!strcmp(key, "DefaultFemaleSkin", true)) ServerCore[scDefaultFemaleSkin] = strval(val);
        else if(!strcmp(key, "TutorialEnabled", true)) ServerCore[scTutorialEnabled] = strval(val);
        else if(!strcmp(key, "AllowSkipTutorial", true)) ServerCore[scAllowSkipTutorial] = strval(val);
        else if(!strcmp(key, "JobLimitDefault", true)) ServerCore[scJobLimitDefault] = strval(val);
        else if(!strcmp(key, "VipJobLimit0", true)) ServerCore[scVipJobLimit][0] = strval(val);
        else if(!strcmp(key, "VipJobLimit1", true)) ServerCore[scVipJobLimit][1] = strval(val);
        else if(!strcmp(key, "VipJobLimit2", true)) ServerCore[scVipJobLimit][2] = strval(val);
        else if(!strcmp(key, "VipJobLimit3", true)) ServerCore[scVipJobLimit][3] = strval(val);
        else if(!strcmp(key, "VipJobLimit4", true)) ServerCore[scVipJobLimit][4] = strval(val);
        else if(!strcmp(key, "VipJobLimit5", true)) ServerCore[scVipJobLimit][5] = strval(val);
        else if(!strcmp(key, "VipHospitalTime0", true)) ServerCore[scVipHospitalTime][0] = strval(val);
        else if(!strcmp(key, "VipHospitalTime1", true)) ServerCore[scVipHospitalTime][1] = strval(val);
        else if(!strcmp(key, "VipHospitalTime2", true)) ServerCore[scVipHospitalTime][2] = strval(val);
        else if(!strcmp(key, "VipHospitalTime3", true)) ServerCore[scVipHospitalTime][3] = strval(val);
        else if(!strcmp(key, "VipHospitalTime4", true)) ServerCore[scVipHospitalTime][4] = strval(val);
        else if(!strcmp(key, "VipHospitalTime5", true)) ServerCore[scVipHospitalTime][5] = strval(val);
        else if(!strcmp(key, "VipHospitalTransferMinLevel", true)) ServerCore[scVipHospitalTransferMinLevel] = strval(val);
        else if(!strcmp(key, "DeathHPDecrease", true)) ServerCore[scDeathHPDecrease] = floatstr(val);
        else if(!strcmp(key, "DeathTickMS", true)) ServerCore[scDeathTickMS] = strval(val);
        else if(!strcmp(key, "HospitalRespawnHP", true)) ServerCore[scHospitalRespawnHP] = floatstr(val);
        else if(!strcmp(key, "FamilyBackupBeaconTime", true)) ServerCore[scFamilyBackupBeaconTime] = strval(val);
        else if(!strcmp(key, "DefaultMaxVehicles", true)) ServerCore[scDefaultMaxVehicles] = strval(val);
        else if(!strcmp(key, "DefaultMaxHouses", true)) ServerCore[scDefaultMaxHouses] = strval(val);
        else if(!strcmp(key, "DefaultMaxBusinesses", true)) ServerCore[scDefaultMaxBusinesses] = strval(val);
        else if(!strcmp(key, "DefaultMaxToys", true)) ServerCore[scDefaultMaxToys] = strval(val);
        else if(!strcmp(key, "MaxFamilies", true)) ServerCore[scMaxFamilies] = strval(val);
        else if(!strcmp(key, "MaxFactions", true)) ServerCore[scMaxFactions] = strval(val);
        else if(!strcmp(key, "MaxFamilyRanks", true)) ServerCore[scMaxFamilyRanks] = strval(val);
        else if(!strcmp(key, "MaxFactionRanks", true)) ServerCore[scMaxFactionRanks] = strval(val);
        else if(!strcmp(key, "MaxFamilyCrews", true)) ServerCore[scMaxFamilyCrews] = strval(val);
        else if(!strcmp(key, "MaxFactionDivisions", true)) ServerCore[scMaxFactionDivisions] = strval(val);
        else if(!strcmp(key, "VipMaxVehicles0", true)) ServerCore[scVipMaxVehicles][0] = strval(val);
        else if(!strcmp(key, "VipMaxVehicles1", true)) ServerCore[scVipMaxVehicles][1] = strval(val);
        else if(!strcmp(key, "VipMaxVehicles2", true)) ServerCore[scVipMaxVehicles][2] = strval(val);
        else if(!strcmp(key, "VipMaxVehicles3", true)) ServerCore[scVipMaxVehicles][3] = strval(val);
        else if(!strcmp(key, "VipMaxVehicles4", true)) ServerCore[scVipMaxVehicles][4] = strval(val);
        else if(!strcmp(key, "VipMaxVehicles5", true)) ServerCore[scVipMaxVehicles][5] = strval(val);
        else if(!strcmp(key, "VipMaxHouses0", true)) ServerCore[scVipMaxHouses][0] = strval(val);
        else if(!strcmp(key, "VipMaxHouses1", true)) ServerCore[scVipMaxHouses][1] = strval(val);
        else if(!strcmp(key, "VipMaxHouses2", true)) ServerCore[scVipMaxHouses][2] = strval(val);
        else if(!strcmp(key, "VipMaxHouses3", true)) ServerCore[scVipMaxHouses][3] = strval(val);
        else if(!strcmp(key, "VipMaxHouses4", true)) ServerCore[scVipMaxHouses][4] = strval(val);
        else if(!strcmp(key, "VipMaxHouses5", true)) ServerCore[scVipMaxHouses][5] = strval(val);
        else if(!strcmp(key, "VipMaxBusinesses0", true)) ServerCore[scVipMaxBusinesses][0] = strval(val);
        else if(!strcmp(key, "VipMaxBusinesses1", true)) ServerCore[scVipMaxBusinesses][1] = strval(val);
        else if(!strcmp(key, "VipMaxBusinesses2", true)) ServerCore[scVipMaxBusinesses][2] = strval(val);
        else if(!strcmp(key, "VipMaxBusinesses3", true)) ServerCore[scVipMaxBusinesses][3] = strval(val);
        else if(!strcmp(key, "VipMaxBusinesses4", true)) ServerCore[scVipMaxBusinesses][4] = strval(val);
        else if(!strcmp(key, "VipMaxBusinesses5", true)) ServerCore[scVipMaxBusinesses][5] = strval(val);
        else if(!strcmp(key, "VipMaxToys0", true)) ServerCore[scVipMaxToys][0] = strval(val);
        else if(!strcmp(key, "VipMaxToys1", true)) ServerCore[scVipMaxToys][1] = strval(val);
        else if(!strcmp(key, "VipMaxToys2", true)) ServerCore[scVipMaxToys][2] = strval(val);
        else if(!strcmp(key, "VipMaxToys3", true)) ServerCore[scVipMaxToys][3] = strval(val);
        else if(!strcmp(key, "VipMaxToys4", true)) ServerCore[scVipMaxToys][4] = strval(val);
        else if(!strcmp(key, "VipMaxToys5", true)) ServerCore[scVipMaxToys][5] = strval(val);
        else if(!strcmp(key, "PhoneDigits", true)) ServerCore[scPhoneDigits] = strval(val);
        else if(!strcmp(key, "AllowVehicleEngineWithoutKeys", true)) ServerCore[scAllowVehicleEngineWithoutKeys] = strval(val);
        else if(!strcmp(key, "AllowVehicleHotwire", true)) ServerCore[scAllowVehicleHotwire] = strval(val);
        else if(!strcmp(key, "DefaultVehicleFuelConsumption", true)) ServerCore[scDefaultVehicleFuelConsumption] = floatstr(val);
        else if(!strcmp(key, "VehicleIdleFuelEnabled", true)) ServerCore[scVehicleIdleFuelEnabled] = strval(val);
        else if(!strcmp(key, "VehicleIdleFuelGallonsPerTick", true)) ServerCore[scVehicleIdleFuelGallonsPerTick] = floatstr(val);
    }
    printf("[ServerCore] Loaded %d key/value entries.", rows);
    return 1;
}

new WeaponMaterialCost[47];

forward ER_OnWeaponCostsLoad();
public ER_OnWeaponCostsLoad()
{
    new rows, weaponid, cost;
    cache_get_row_count(rows);
    for(new i; i < sizeof(WeaponMaterialCost); i++) WeaponMaterialCost[i] = 0;
    for(new r; r < rows; r++)
    {
        cache_get_value_name_int(r, "weaponid", weaponid);
        cache_get_value_name_int(r, "material_cost", cost);
        if(weaponid >= 0 && weaponid < sizeof(WeaponMaterialCost)) WeaponMaterialCost[weaponid] = cost;
    }
    printf("[ServerCore] Loaded %d weapon material costs.", rows);
    return 1;
}

stock ER_GetVipJobLimit(playerid)
{
    new vip = PlayerInfo[playerid][pPlayerVip];
    if(vip < 0) vip = 0;
    if(vip > 5) vip = 5;
    return ServerCore[scVipJobLimit][vip];
}

stock ER_GetVipHospitalTime(playerid)
{
    new vip = PlayerInfo[playerid][pPlayerVip];
    if(vip < 0) vip = 0;
    if(vip > 5) vip = 5;
    return ServerCore[scVipHospitalTime][vip];
}

stock ER_ServerCoreUpsertInt(const key[], value)
{
    new q[192];
    mysql_format(MainPipeline, q, sizeof(q), "REPLACE INTO `servercore` (`keyname`,`value`) VALUES ('%e','%d')", key, value);
    mysql_tquery(MainPipeline, q);
    return 1;
}

stock ER_GetVipClamped(playerid)
{
    new vip = PlayerInfo[playerid][pPlayerVip];
    if(vip < 0) vip = 0;
    if(vip > 5) vip = 5;
    return vip;
}

stock ER_GetMaxVehicles(playerid)
{
    if(PlayerInfo[playerid][pMaxVehicles] > 0) return PlayerInfo[playerid][pMaxVehicles];
    new vip = ER_GetVipClamped(playerid);
    return ServerCore[scVipMaxVehicles][vip] > 0 ? ServerCore[scVipMaxVehicles][vip] : ServerCore[scDefaultMaxVehicles];
}
stock ER_GetMaxHouses(playerid)
{
    if(PlayerInfo[playerid][pMaxHouses] > 0) return PlayerInfo[playerid][pMaxHouses];
    new vip = ER_GetVipClamped(playerid);
    return ServerCore[scVipMaxHouses][vip] > 0 ? ServerCore[scVipMaxHouses][vip] : ServerCore[scDefaultMaxHouses];
}
stock ER_GetMaxBusinesses(playerid)
{
    if(PlayerInfo[playerid][pMaxBusinesses] > 0) return PlayerInfo[playerid][pMaxBusinesses];
    new vip = ER_GetVipClamped(playerid);
    return ServerCore[scVipMaxBusinesses][vip] > 0 ? ServerCore[scVipMaxBusinesses][vip] : ServerCore[scDefaultMaxBusinesses];
}
stock ER_GetMaxToys(playerid)
{
    if(PlayerInfo[playerid][pMaxToys] > 0) return PlayerInfo[playerid][pMaxToys];
    new vip = ER_GetVipClamped(playerid);
    return ServerCore[scVipMaxToys][vip] > 0 ? ServerCore[scVipMaxToys][vip] : ServerCore[scDefaultMaxToys];
}


#define MAX_SERVERCORE_EDIT_ROWS 128
new ER_ServerCoreEditKeys[MAX_PLAYERS][MAX_SERVERCORE_EDIT_ROWS][64];
new ER_ServerCoreEditValues[MAX_PLAYERS][MAX_SERVERCORE_EDIT_ROWS][128];
new ER_ServerCoreEditCount[MAX_PLAYERS];

stock ER_ServerCoreUpsertString(const key[], const value[])
{
    new q[384];
    mysql_format(MainPipeline, q, sizeof(q), "REPLACE INTO `servercore` (`keyname`,`value`) VALUES ('%e','%e')", key, value);
    mysql_tquery(MainPipeline, q);
    return 1;
}

stock ER_ApplyServerCoreCacheValue(const key[], const val[])
{
    if(!strcmp(key, "ServerName", true)) format(ServerCore[scServerName], 64, "%s", val);
    else if(!strcmp(key, "Website", true)) format(ServerCore[scWebsite], 96, "%s", val);
    else if(!strcmp(key, "Discord", true)) format(ServerCore[scDiscord], 96, "%s", val);
    else if(!strcmp(key, "News", true)) format(ServerCore[scNews], 128, "%s", val);
    else if(!strcmp(key, "LoginTrack", true)) format(ServerCore[scLoginTrack], 256, "%s", val);
    else if(!strcmp(key, "RegisterTrack", true)) format(ServerCore[scRegisterTrack], 256, "%s", val);
    else if(!strcmp(key, "DefaultCash", true)) ServerCore[scDefaultCash] = strval(val);
    else if(!strcmp(key, "DefaultBank", true)) ServerCore[scDefaultBank] = strval(val);
    else if(!strcmp(key, "DefaultSpawnX", true)) ServerCore[scDefaultSpawnX] = floatstr(val);
    else if(!strcmp(key, "DefaultSpawnY", true)) ServerCore[scDefaultSpawnY] = floatstr(val);
    else if(!strcmp(key, "DefaultSpawnZ", true)) ServerCore[scDefaultSpawnZ] = floatstr(val);
    else if(!strcmp(key, "DefaultSpawnA", true)) ServerCore[scDefaultSpawnA] = floatstr(val);
    else if(!strcmp(key, "DefaultSpawnInterior", true)) ServerCore[scDefaultSpawnInt] = strval(val);
    else if(!strcmp(key, "DefaultSpawnVW", true)) ServerCore[scDefaultSpawnVW] = strval(val);
    else if(!strcmp(key, "DefaultMaleSkin", true)) ServerCore[scDefaultMaleSkin] = strval(val);
    else if(!strcmp(key, "DefaultFemaleSkin", true)) ServerCore[scDefaultFemaleSkin] = strval(val);
    else if(!strcmp(key, "TutorialEnabled", true)) ServerCore[scTutorialEnabled] = strval(val);
    else if(!strcmp(key, "AllowSkipTutorial", true)) ServerCore[scAllowSkipTutorial] = strval(val);
    else if(!strcmp(key, "JobLimitDefault", true)) ServerCore[scJobLimitDefault] = strval(val);
    else if(!strcmp(key, "VipJobLimit0", true)) ServerCore[scVipJobLimit][0] = strval(val);
    else if(!strcmp(key, "VipJobLimit1", true)) ServerCore[scVipJobLimit][1] = strval(val);
    else if(!strcmp(key, "VipJobLimit2", true)) ServerCore[scVipJobLimit][2] = strval(val);
    else if(!strcmp(key, "VipJobLimit3", true)) ServerCore[scVipJobLimit][3] = strval(val);
    else if(!strcmp(key, "VipJobLimit4", true)) ServerCore[scVipJobLimit][4] = strval(val);
    else if(!strcmp(key, "VipJobLimit5", true)) ServerCore[scVipJobLimit][5] = strval(val);
    else if(!strcmp(key, "VipHospitalTime0", true)) ServerCore[scVipHospitalTime][0] = strval(val);
    else if(!strcmp(key, "VipHospitalTime1", true)) ServerCore[scVipHospitalTime][1] = strval(val);
    else if(!strcmp(key, "VipHospitalTime2", true)) ServerCore[scVipHospitalTime][2] = strval(val);
    else if(!strcmp(key, "VipHospitalTime3", true)) ServerCore[scVipHospitalTime][3] = strval(val);
    else if(!strcmp(key, "VipHospitalTime4", true)) ServerCore[scVipHospitalTime][4] = strval(val);
    else if(!strcmp(key, "VipHospitalTime5", true)) ServerCore[scVipHospitalTime][5] = strval(val);
    else if(!strcmp(key, "VipHospitalTransferMinLevel", true)) ServerCore[scVipHospitalTransferMinLevel] = strval(val);
    else if(!strcmp(key, "DeathHPDecrease", true)) ServerCore[scDeathHPDecrease] = floatstr(val);
    else if(!strcmp(key, "DeathTickMS", true)) ServerCore[scDeathTickMS] = strval(val);
    else if(!strcmp(key, "HospitalRespawnHP", true)) ServerCore[scHospitalRespawnHP] = floatstr(val);
    else if(!strcmp(key, "FamilyBackupBeaconTime", true)) ServerCore[scFamilyBackupBeaconTime] = strval(val);
    else if(!strcmp(key, "DefaultMaxVehicles", true)) ServerCore[scDefaultMaxVehicles] = strval(val);
    else if(!strcmp(key, "DefaultMaxHouses", true)) ServerCore[scDefaultMaxHouses] = strval(val);
    else if(!strcmp(key, "DefaultMaxBusinesses", true)) ServerCore[scDefaultMaxBusinesses] = strval(val);
    else if(!strcmp(key, "DefaultMaxToys", true)) ServerCore[scDefaultMaxToys] = strval(val);
    else if(!strcmp(key, "MaxFamilies", true)) ServerCore[scMaxFamilies] = strval(val);
    else if(!strcmp(key, "MaxFactions", true)) ServerCore[scMaxFactions] = strval(val);
    else if(!strcmp(key, "MaxFamilyRanks", true)) ServerCore[scMaxFamilyRanks] = strval(val);
    else if(!strcmp(key, "MaxFactionRanks", true)) ServerCore[scMaxFactionRanks] = strval(val);
    else if(!strcmp(key, "MaxFamilyCrews", true)) ServerCore[scMaxFamilyCrews] = strval(val);
    else if(!strcmp(key, "MaxFactionDivisions", true)) ServerCore[scMaxFactionDivisions] = strval(val);
    else if(!strcmp(key, "VipMaxVehicles0", true)) ServerCore[scVipMaxVehicles][0] = strval(val);
    else if(!strcmp(key, "VipMaxVehicles1", true)) ServerCore[scVipMaxVehicles][1] = strval(val);
    else if(!strcmp(key, "VipMaxVehicles2", true)) ServerCore[scVipMaxVehicles][2] = strval(val);
    else if(!strcmp(key, "VipMaxVehicles3", true)) ServerCore[scVipMaxVehicles][3] = strval(val);
    else if(!strcmp(key, "VipMaxVehicles4", true)) ServerCore[scVipMaxVehicles][4] = strval(val);
    else if(!strcmp(key, "VipMaxVehicles5", true)) ServerCore[scVipMaxVehicles][5] = strval(val);
    else if(!strcmp(key, "VipMaxHouses0", true)) ServerCore[scVipMaxHouses][0] = strval(val);
    else if(!strcmp(key, "VipMaxHouses1", true)) ServerCore[scVipMaxHouses][1] = strval(val);
    else if(!strcmp(key, "VipMaxHouses2", true)) ServerCore[scVipMaxHouses][2] = strval(val);
    else if(!strcmp(key, "VipMaxHouses3", true)) ServerCore[scVipMaxHouses][3] = strval(val);
    else if(!strcmp(key, "VipMaxHouses4", true)) ServerCore[scVipMaxHouses][4] = strval(val);
    else if(!strcmp(key, "VipMaxHouses5", true)) ServerCore[scVipMaxHouses][5] = strval(val);
    else if(!strcmp(key, "VipMaxBusinesses0", true)) ServerCore[scVipMaxBusinesses][0] = strval(val);
    else if(!strcmp(key, "VipMaxBusinesses1", true)) ServerCore[scVipMaxBusinesses][1] = strval(val);
    else if(!strcmp(key, "VipMaxBusinesses2", true)) ServerCore[scVipMaxBusinesses][2] = strval(val);
    else if(!strcmp(key, "VipMaxBusinesses3", true)) ServerCore[scVipMaxBusinesses][3] = strval(val);
    else if(!strcmp(key, "VipMaxBusinesses4", true)) ServerCore[scVipMaxBusinesses][4] = strval(val);
    else if(!strcmp(key, "VipMaxBusinesses5", true)) ServerCore[scVipMaxBusinesses][5] = strval(val);
    else if(!strcmp(key, "VipMaxToys0", true)) ServerCore[scVipMaxToys][0] = strval(val);
    else if(!strcmp(key, "VipMaxToys1", true)) ServerCore[scVipMaxToys][1] = strval(val);
    else if(!strcmp(key, "VipMaxToys2", true)) ServerCore[scVipMaxToys][2] = strval(val);
    else if(!strcmp(key, "VipMaxToys3", true)) ServerCore[scVipMaxToys][3] = strval(val);
    else if(!strcmp(key, "VipMaxToys4", true)) ServerCore[scVipMaxToys][4] = strval(val);
    else if(!strcmp(key, "VipMaxToys5", true)) ServerCore[scVipMaxToys][5] = strval(val);
    else if(!strcmp(key, "PhoneDigits", true)) ServerCore[scPhoneDigits] = strval(val);
    else if(!strcmp(key, "AllowVehicleEngineWithoutKeys", true)) ServerCore[scAllowVehicleEngineWithoutKeys] = strval(val);
    else if(!strcmp(key, "AllowVehicleHotwire", true)) ServerCore[scAllowVehicleHotwire] = strval(val);
    else if(!strcmp(key, "DefaultVehicleFuelConsumption", true)) ServerCore[scDefaultVehicleFuelConsumption] = floatstr(val);
    else if(!strcmp(key, "VehicleIdleFuelEnabled", true)) ServerCore[scVehicleIdleFuelEnabled] = strval(val);
    else if(!strcmp(key, "VehicleIdleFuelGallonsPerTick", true)) ServerCore[scVehicleIdleFuelGallonsPerTick] = floatstr(val);
    return 1;
}

stock ER_ShowServerSettings(playerid)
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    mysql_tquery(MainPipeline, "SELECT `keyname`,`value` FROM `servercore` ORDER BY `keyname` ASC", "ER_OnServerSettingsList", "i", playerid);
    return 1;
}

forward ER_OnServerSettingsList(playerid);
public ER_OnServerSettingsList(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows, key[64], val[128], showVal[64], line[160], list[4096];
    cache_get_row_count(rows);
    ER_ServerCoreEditCount[playerid] = 0;
    list[0] = EOS;

    for(new r; r < rows && r < MAX_SERVERCORE_EDIT_ROWS; r++)
    {
        cache_get_value_name(r, "keyname", key, sizeof(key));
        cache_get_value_name(r, "value", val, sizeof(val));
        format(ER_ServerCoreEditKeys[playerid][r], 64, "%s", key);
        format(ER_ServerCoreEditValues[playerid][r], 128, "%s", val);
        format(showVal, sizeof(showVal), "%s", val);
        if(strlen(showVal) > 50)
        {
            showVal[47] = '.';
            showVal[48] = '.';
            showVal[49] = '.';
            showVal[50] = EOS;
        }
        format(line, sizeof(line), "%s: %s\n", key, showVal);
        if(strlen(list) + strlen(line) < sizeof(list) - 1) strcat(list, line);
        ER_ServerCoreEditCount[playerid]++;
    }

    if(!ER_ServerCoreEditCount[playerid]) return ER_Send(playerid, COLOR_GREY, "No servercore settings found.");
    ShowPlayerDialog(playerid, DIALOG_SERVER_SETTINGS, DIALOG_STYLE_LIST, "ServerCore Settings", list, "Edit", "Close");
    return 1;
}

CMD:serversettings(playerid, params[])
{
    return ER_ShowServerSettings(playerid);
}

stock ER_ServerCoreDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_SERVER_SETTINGS)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= ER_ServerCoreEditCount[playerid]) return 1;
        SetPVarString(playerid, "ServerCoreEditKey", ER_ServerCoreEditKeys[playerid][listitem]);
        new title[96], body[512];
        format(title, sizeof(title), "Edit %s", ER_ServerCoreEditKeys[playerid][listitem]);
        format(body, sizeof(body), "Current value:\n%s\n\nEnter the new value:", ER_ServerCoreEditValues[playerid][listitem]);
        ShowPlayerDialog(playerid, DIALOG_SERVER_SETTINGS_INPUT, DIALOG_STYLE_INPUT, title, body, "Save", "Back");
        return 1;
    }
    if(dialogid == DIALOG_SERVER_SETTINGS_INPUT)
    {
        if(!response) return ER_ShowServerSettings(playerid);
        new key[64];
        GetPVarString(playerid, "ServerCoreEditKey", key, sizeof(key));
        if(!key[0]) return ER_ShowServerSettings(playerid);

        if(!strcmp(key, "PhoneDigits", true))
        {
            new val = strval(inputtext);
            if(val < 4 || val > 9) return ER_Send(playerid, COLOR_GREY, "Phone number digits must be between 4 and 9.");
        }
        ER_ServerCoreUpsertString(key, inputtext);
        ER_ApplyServerCoreCacheValue(key, inputtext);
        ER_Send(playerid, COLOR_GREEN, "ServerCore setting saved.");
        return ER_ShowServerSettings(playerid);
    }
    return 0;
}
