#if defined _ER_SAVECHARS_INCLUDED
    #endinput
#endif
#define _ER_SAVECHARS_INCLUDED


stock ER_SaveLastPosition(playerid, bool:syncsave = false)
{
    if(!PlayerInfo[playerid][pLoggedIn] || PlayerInfo[playerid][pID] <= 0) return 0;
    if(PlayerInfo[playerid][pTutorial] != 1) return 0;
    if(PlayerInfo[playerid][pInjured] || PlayerInfo[playerid][pHospitalized]) return 0;

    GetPlayerPos(playerid, PlayerInfo[playerid][pSpawnX], PlayerInfo[playerid][pSpawnY], PlayerInfo[playerid][pSpawnZ]);
    GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pSpawnA]);
    PlayerInfo[playerid][pSpawnInt] = GetPlayerInterior(playerid);
    PlayerInfo[playerid][pSpawnVW] = GetPlayerVirtualWorld(playerid);

    new q[384];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `spawn_x`=%f,`spawn_y`=%f,`spawn_z`=%f,`spawn_a`=%f,`spawn_int`=%d,`spawn_vw`=%d WHERE `id`=%d",
        PlayerInfo[playerid][pSpawnX], PlayerInfo[playerid][pSpawnY], PlayerInfo[playerid][pSpawnZ], PlayerInfo[playerid][pSpawnA], PlayerInfo[playerid][pSpawnInt], PlayerInfo[playerid][pSpawnVW], PlayerInfo[playerid][pID]);

    if(syncsave)
    {
        mysql_query(MainPipeline, q, false);
    }
    else
    {
        mysql_tquery(MainPipeline, q);
    }
    return 1;
}

CMD:savepos(playerid, params[])
{
    if(!PlayerInfo[playerid][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "You must be logged in.");
    ER_SaveLastPosition(playerid);
    return ER_Send(playerid, COLOR_GREEN, "Your current position has been saved.");
}




forward ER_AutoSavePlayerPositions();
public ER_AutoSavePlayerPositions()
{
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pLoggedIn])
        {
            ER_SaveLastPosition(i);
        }
    }
    return 1;
}

stock ER_LoadCharacter(playerid)
{
    new q[160];
    mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `accounts` WHERE `id`=%d LIMIT 1", PlayerInfo[playerid][pID]);
    mysql_tquery(MainPipeline, q, "ER_OnCharacterLoad", "i", playerid);
    return 1;
}

forward ER_OnCharacterLoad(playerid);
public ER_OnCharacterLoad(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows;
    cache_get_row_count(rows);
    if(!rows) return Kick(playerid);
    cache_get_value_name_int(0, "id", PlayerInfo[playerid][pID]);
    cache_get_value_name_int(0, "tutorial", PlayerInfo[playerid][pTutorial]);
    cache_get_value_name_int(0, "admin", PlayerInfo[playerid][pAdmin]);
    cache_get_value_name_int(0, "vip", PlayerInfo[playerid][pPlayerVip]);
    cache_get_value_name_int(0, "level", PlayerInfo[playerid][pLevel]);
    cache_get_value_name_int(0, "playing_hours", PlayerInfo[playerid][pPlayingHours]);
    cache_get_value_name_int(0, "age", PlayerInfo[playerid][pAge]);
    cache_get_value_name(0, "dob", PlayerInfo[playerid][pDOB], 16);
    cache_get_value_name(0, "country", PlayerInfo[playerid][pCountry], 32);
    cache_get_value_name_int(0, "gender", PlayerInfo[playerid][pGender]);
    cache_get_value_name_int(0, "accent", PlayerInfo[playerid][pAccent]);
    cache_get_value_name_int(0, "skin", PlayerInfo[playerid][pSkin]);
    cache_get_value_name_int(0, "cash", PlayerInfo[playerid][pCash]);
    cache_get_value_name_int(0, "bank", PlayerInfo[playerid][pBank]);
    cache_get_value_name_int(0, "phone", PlayerInfo[playerid][pPhone]);
    cache_get_value_name_int(0, "phonebook", PlayerInfo[playerid][pPhonebook]);
    cache_get_value_name_int(0, "phone_off", PlayerInfo[playerid][pPhoneOff]);
    cache_get_value_name_int(0, "has_radio", PlayerInfo[playerid][pHasRadio]);
    cache_get_value_name_int(0, "radio_freq", PlayerInfo[playerid][pRadio]);
    cache_get_value_name_int(0, "fav_radio", PlayerInfo[playerid][pFavRadio]);
    cache_get_value_name_int(0, "vehicle_lock", PlayerInfo[playerid][pVehicleLock]);
    cache_get_value_name_int(0, "hosp_insurance", PlayerInfo[playerid][pHospInsurance]);
    cache_get_value_name(0, "married_to", PlayerInfo[playerid][pMarriedTo], MAX_PLAYER_NAME_EX);
    cache_get_value_name_int(0, "crimes", PlayerInfo[playerid][pCrimes]);
    cache_get_value_name_int(0, "arrests", PlayerInfo[playerid][pArrests]);
    cache_get_value_name_int(0, "wanted_level", PlayerInfo[playerid][pWantedLevel]);
    cache_get_value_name_int(0, "materials", PlayerInfo[playerid][pMaterials]);
    cache_get_value_name_int(0, "pot", PlayerInfo[playerid][pPot]);
    cache_get_value_name_int(0, "crack", PlayerInfo[playerid][pCrack]);
    cache_get_value_name_int(0, "rope", PlayerInfo[playerid][pRope]);
    cache_get_value_name_int(0, "packages", PlayerInfo[playerid][pPackages]);
    cache_get_value_name_int(0, "seeds", PlayerInfo[playerid][pSeeds]);
    cache_get_value_name_int(0, "sprunk", PlayerInfo[playerid][pSprunk]);
    cache_get_value_name_int(0, "cigar", PlayerInfo[playerid][pCigar]);
    cache_get_value_name_int(0, "spraycans", PlayerInfo[playerid][pSprayCans]);
    cache_get_value_name_float(0, "health", PlayerInfo[playerid][pHealth]);
    cache_get_value_name_float(0, "armor", PlayerInfo[playerid][pArmor]);
    cache_get_value_name_int(0, "respect_points", PlayerInfo[playerid][pRespectPoints]);
    cache_get_value_name_int(0, "warnings", PlayerInfo[playerid][pWarnings]);
    cache_get_value_name_int(0, "hospital_time", PlayerInfo[playerid][pHospitalTime]);
    cache_get_value_name_int(0, "tog_free_hospital", PlayerInfo[playerid][pTogFreeHospital]);
    cache_get_value_name_int(0, "family_id", PlayerInfo[playerid][pFamily]);
    cache_get_value_name_int(0, "faction_id", PlayerInfo[playerid][pFaction]);
    cache_get_value_name_int(0, "family_rank", PlayerInfo[playerid][pFamilyRank]);
    cache_get_value_name_int(0, "family_crew", PlayerInfo[playerid][pFamilyCrew]);
    cache_get_value_name_int(0, "faction_rank", PlayerInfo[playerid][pFactionRank]);
    cache_get_value_name_int(0, "faction_division", PlayerInfo[playerid][pFactionDivision]);
    cache_get_value_name_int(0, "business_id", PlayerInfo[playerid][pBusiness]);
    cache_get_value_name_int(0, "max_vehicles", PlayerInfo[playerid][pMaxVehicles]);
    cache_get_value_name_int(0, "max_houses", PlayerInfo[playerid][pMaxHouses]);
    cache_get_value_name_int(0, "max_businesses", PlayerInfo[playerid][pMaxBusinesses]);
    cache_get_value_name_int(0, "max_toys", PlayerInfo[playerid][pMaxToys]);
    cache_get_value_name_int(0, "has_mp3", PlayerInfo[playerid][pHasMP3]);
    cache_get_value_name_int(0, "hotwire_level", PlayerInfo[playerid][pHotwireLevel]);
    if(PlayerInfo[playerid][pHotwireLevel] < 1) PlayerInfo[playerid][pHotwireLevel] = 1;
    cache_get_value_name_int(0, "hotwire_success", PlayerInfo[playerid][pHotwireSuccess]);
    cache_get_value_name_int(0, "hotwire_fail", PlayerInfo[playerid][pHotwireFail]);
    cache_get_value_name_int(0, "hotwire_kits", PlayerInfo[playerid][pHotwireKits]);
    cache_get_value_name_int(0, "repair_kits", PlayerInfo[playerid][pRepairKits]);
    cache_get_value_name_int(0, "screwdrivers", PlayerInfo[playerid][pScrewdrivers]);
    cache_get_value_name_int(0, "has_jerry_can", PlayerInfo[playerid][pHasJerryCan]);
    cache_get_value_name_float(0, "jerry_can_fuel", PlayerInfo[playerid][pJerryCanFuel]);
    cache_get_value_name_float(0, "spawn_x", PlayerInfo[playerid][pSpawnX]);
    cache_get_value_name_float(0, "spawn_y", PlayerInfo[playerid][pSpawnY]);
    cache_get_value_name_float(0, "spawn_z", PlayerInfo[playerid][pSpawnZ]);
    cache_get_value_name_float(0, "spawn_a", PlayerInfo[playerid][pSpawnA]);
    cache_get_value_name_int(0, "spawn_int", PlayerInfo[playerid][pSpawnInt]);
    cache_get_value_name_int(0, "spawn_vw", PlayerInfo[playerid][pSpawnVW]);
    cache_get_value_name_int(0, "injured", PlayerInfo[playerid][pInjured]);
    cache_get_value_name_int(0, "hospitalized", PlayerInfo[playerid][pHospitalized]);
    cache_get_value_name_int(0, "hospital_id", PlayerInfo[playerid][pHospitalID]);
    cache_get_value_name_int(0, "hospital_bed", PlayerInfo[playerid][pHospitalBed]);
    cache_get_value_name_float(0, "injured_x", PlayerInfo[playerid][pInjuredX]);
    cache_get_value_name_float(0, "injured_y", PlayerInfo[playerid][pInjuredY]);
    cache_get_value_name_float(0, "injured_z", PlayerInfo[playerid][pInjuredZ]);
    cache_get_value_name_float(0, "injured_a", PlayerInfo[playerid][pInjuredA]);
    cache_get_value_name_int(0, "injured_int", PlayerInfo[playerid][pInjuredInt]);
    cache_get_value_name_int(0, "injured_vw", PlayerInfo[playerid][pInjuredVW]);
    for(new js = 1; js < MAX_EXPRESS_JOB_TYPES; js++)
    {
        new field[20]; format(field, sizeof(field), "jobskill_%d", js);
        cache_get_value_name_int(0, field, PlayerInfo[playerid][pJobSkill][js]);
    }
    for(new j; j < MAX_JOBS_PER_PLAYER; j++)
    {
        new field[16]; format(field, sizeof(field), "job%d", j);
        cache_get_value_name_int(0, field, PlayerInfo[playerid][pPlayerJob][j]);
    }
    for(new w; w < MAX_WEAPON_SLOTS; w++)
    {
        new field[16]; format(field, sizeof(field), "weapon%d", w);
        cache_get_value_name_int(0, field, PlayerInfo[playerid][pPlayerWeapons][w]);
    }
    PlayerInfo[playerid][pLoggedIn] = 1;
    ER_StopLoginRegisterMusic(playerid);

    new welcome[96];
    format(welcome, sizeof(welcome), "SERVER: Welcome, %s.", ER_GetName(playerid));
    ER_Send(playerid, COLOR_WHITE, welcome);
    ER_ShowLoginMOTDs(playerid);
    ER_LoadPlayerToys(playerid);

    if(PlayerInfo[playerid][pTutorial]) ER_SpawnCharacter(playerid);
    else ER_StartTutorial(playerid);
    return 1;
}

stock ER_SaveCharacter(playerid)
{
    if(!PlayerInfo[playerid][pLoggedIn] || PlayerInfo[playerid][pID] <= 0) return 0;

    // ER_SAVECHAR_LIVE_POSITION_PATCH
    // Also refresh last position here before the big character save.
    if(PlayerInfo[playerid][pTutorial] == 1 && !PlayerInfo[playerid][pInjured] && !PlayerInfo[playerid][pHospitalized])
    {
        GetPlayerPos(playerid, PlayerInfo[playerid][pSpawnX], PlayerInfo[playerid][pSpawnY], PlayerInfo[playerid][pSpawnZ]);
        GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pSpawnA]);
        PlayerInfo[playerid][pSpawnInt] = GetPlayerInterior(playerid);
        PlayerInfo[playerid][pSpawnVW] = GetPlayerVirtualWorld(playerid);
    }

    GetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
    GetPlayerArmour(playerid, PlayerInfo[playerid][pArmor]);
    new q[4096];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `tutorial`=%d,`admin`=%d,`vip`=%d,`level`=%d,`playing_hours`=%d,`age`=%d,`dob`='%e',`country`='%e',`gender`=%d,`accent`=%d,`skin`=%d,`cash`=%d,`bank`=%d,`phone`=%d,`phonebook`=%d,`phone_off`=%d,`has_radio`=%d,`radio_freq`=%d,`fav_radio`=%d,`vehicle_lock`=%d,`hosp_insurance`=%d,`married_to`='%e',`crimes`=%d,`arrests`=%d,`wanted_level`=%d,`materials`=%d,`pot`=%d,`crack`=%d,`rope`=%d,`packages`=%d,`seeds`=%d,`sprunk`=%d,`cigar`=%d,`spraycans`=%d,`health`=%f,`armor`=%f,`respect_points`=%d,`warnings`=%d,`hospital_time`=%d,`tog_free_hospital`=%d,`family_id`=%d,`faction_id`=%d,`family_rank`=%d,`family_crew`=%d,`faction_rank`=%d,`faction_division`=%d,`business_id`=%d,`max_vehicles`=%d,`max_houses`=%d,`max_businesses`=%d,`max_toys`=%d,`has_mp3`=%d,`hotwire_level`=%d,`hotwire_success`=%d,`hotwire_fail`=%d,`hotwire_kits`=%d,`repair_kits`=%d,`screwdrivers`=%d,`has_jerry_can`=%d,`jerry_can_fuel`=%f,`spawn_x`=%f,`spawn_y`=%f,`spawn_z`=%f,`spawn_a`=%f,`spawn_int`=%d,`spawn_vw`=%d,`injured`=%d,`hospitalized`=%d,`hospital_id`=%d,`hospital_bed`=%d,`injured_x`=%f,`injured_y`=%f,`injured_z`=%f,`injured_a`=%f,`injured_int`=%d,`injured_vw`=%d",
        PlayerInfo[playerid][pTutorial], PlayerInfo[playerid][pAdmin], PlayerInfo[playerid][pPlayerVip], PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pPlayingHours], PlayerInfo[playerid][pAge], PlayerInfo[playerid][pDOB], PlayerInfo[playerid][pCountry], PlayerInfo[playerid][pGender], PlayerInfo[playerid][pAccent], PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pCash], PlayerInfo[playerid][pBank], PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pPhonebook], PlayerInfo[playerid][pPhoneOff], PlayerInfo[playerid][pHasRadio], PlayerInfo[playerid][pRadio], PlayerInfo[playerid][pFavRadio], PlayerInfo[playerid][pVehicleLock], PlayerInfo[playerid][pHospInsurance], PlayerInfo[playerid][pMarriedTo], PlayerInfo[playerid][pCrimes], PlayerInfo[playerid][pArrests], PlayerInfo[playerid][pWantedLevel], PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pPot], PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pRope], PlayerInfo[playerid][pPackages], PlayerInfo[playerid][pSeeds], PlayerInfo[playerid][pSprunk], PlayerInfo[playerid][pCigar], PlayerInfo[playerid][pSprayCans], PlayerInfo[playerid][pHealth], PlayerInfo[playerid][pArmor], PlayerInfo[playerid][pRespectPoints], PlayerInfo[playerid][pWarnings], PlayerInfo[playerid][pHospitalTime], PlayerInfo[playerid][pTogFreeHospital], PlayerInfo[playerid][pFamily], PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pFamilyRank], PlayerInfo[playerid][pFamilyCrew], PlayerInfo[playerid][pFactionRank], PlayerInfo[playerid][pFactionDivision], PlayerInfo[playerid][pBusiness], PlayerInfo[playerid][pMaxVehicles], PlayerInfo[playerid][pMaxHouses], PlayerInfo[playerid][pMaxBusinesses], PlayerInfo[playerid][pMaxToys], PlayerInfo[playerid][pHasMP3], PlayerInfo[playerid][pHotwireLevel], PlayerInfo[playerid][pHotwireSuccess], PlayerInfo[playerid][pHotwireFail], PlayerInfo[playerid][pHotwireKits], PlayerInfo[playerid][pRepairKits], PlayerInfo[playerid][pScrewdrivers], PlayerInfo[playerid][pHasJerryCan], PlayerInfo[playerid][pJerryCanFuel], PlayerInfo[playerid][pSpawnX], PlayerInfo[playerid][pSpawnY], PlayerInfo[playerid][pSpawnZ], PlayerInfo[playerid][pSpawnA], PlayerInfo[playerid][pSpawnInt], PlayerInfo[playerid][pSpawnVW], PlayerInfo[playerid][pInjured], PlayerInfo[playerid][pHospitalized], PlayerInfo[playerid][pHospitalID], PlayerInfo[playerid][pHospitalBed], PlayerInfo[playerid][pInjuredX], PlayerInfo[playerid][pInjuredY], PlayerInfo[playerid][pInjuredZ], PlayerInfo[playerid][pInjuredA], PlayerInfo[playerid][pInjuredInt], PlayerInfo[playerid][pInjuredVW]);
    for(new js = 1; js < MAX_EXPRESS_JOB_TYPES; js++) mysql_format(MainPipeline, q, sizeof(q), "%s,`jobskill_%d`=%d", q, js, PlayerInfo[playerid][pJobSkill][js]);
    for(new j; j < MAX_JOBS_PER_PLAYER; j++) mysql_format(MainPipeline, q, sizeof(q), "%s,`job%d`=%d", q, j, PlayerInfo[playerid][pPlayerJob][j]);
    for(new w; w < MAX_WEAPON_SLOTS; w++) mysql_format(MainPipeline, q, sizeof(q), "%s,`weapon%d`=%d", q, w, PlayerInfo[playerid][pPlayerWeapons][w]);
    mysql_format(MainPipeline, q, sizeof(q), "%s WHERE `id`=%d", q, PlayerInfo[playerid][pID]);

    if(GetPVarInt(playerid, "SyncSaveOnExit"))
    {
        mysql_query(MainPipeline, q, false);
    }
    else
    {
        mysql_tquery(MainPipeline, q);
    }
    return 1;
}
