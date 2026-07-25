#if defined _ER_RADIO_INCLUDED
    #endinput
#endif
#define _ER_RADIO_INCLUDED

new ER_VehicleRadioStation[MAX_VEHICLES];

new FamilyBeaconActive[MAX_PLAYERS];
new FamilyBeaconTimer[MAX_PLAYERS];
new FamilyBeaconIcon[MAX_PLAYERS][MAX_PLAYERS];

stock ER_ClearPlayerAudioZoneStates()
{
    foreach(new i : Player)
    {
        if(GetPVarInt(i, "PlayingAudioZoneArea") > 0 || GetPVarInt(i, "CurrentAudioZoneArea") > 0)
        {
            DeletePVar(i, "PlayingAudioZoneArea");
            DeletePVar(i, "CurrentAudioZoneArea");

            // Only stop the stream if they are not currently in a vehicle with active radio.
            if(IsPlayerInAnyVehicle(i))
            {
                new vehicleid = GetPlayerVehicleID(i);
                if(vehicleid > 0 && vehicleid < MAX_VEHICLES && ER_VehicleRadioStation[vehicleid] >= 0)
                {
                    ER_PlayVehicleStationForPlayer(i, vehicleid);
                    continue;
                }
            }

            StopAudioStreamForPlayer(i);
        }
    }
    return 1;
}

stock ER_ClearAudioZones()
{
    ER_ClearPlayerAudioZoneStates();

    for(new i; i < AudioZoneCount; i++)
    {
        if(AudioZones[i][azAreaID]) DestroyDynamicArea(AudioZones[i][azAreaID]);
        AudioZones[i][azAreaID] = 0;
    }
    AudioZoneCount = 0;
    return 1;
}

stock ER_LoadAudioStreams()
{
    ER_LoadRadioStations();
    ER_LoadAudioZones();
    return 1;
}

stock ER_LoadRadioStations()
{
    mysql_tquery(MainPipeline, "SELECT * FROM `radiostations` WHERE `enabled`=1 ORDER BY `category`,`name` ASC", "ER_OnRadioStationsLoad");
    return 1;
}

forward ER_OnRadioStationsLoad();
public ER_OnRadioStationsLoad()
{
    new rows, catfound;
    cache_get_row_count(rows);
    RadioStationCount = 0;
    RadioCategoryCount = 0;

    for(new r; r < rows && RadioStationCount < MAX_RADIO_STATIONS; r++)
    {
        cache_get_value_name_int(r, "id", RadioStations[RadioStationCount][rsSQLID]);
        cache_get_value_name(r, "name", RadioStations[RadioStationCount][rsName], 64);
        cache_get_value_name(r, "url", RadioStations[RadioStationCount][rsURL], 256);
        cache_get_value_name(r, "category", RadioStations[RadioStationCount][rsCategory], 32);
        cache_get_value_name_int(r, "enabled", RadioStations[RadioStationCount][rsEnabled]);

        catfound = 0;
        for(new c; c < RadioCategoryCount; c++)
        {
            if(!strcmp(RadioCategories[c][rcName], RadioStations[RadioStationCount][rsCategory], true))
            {
                catfound = 1;
                break;
            }
        }

        if(!catfound && RadioCategoryCount < MAX_RADIO_CATEGORIES)
        {
            format(RadioCategories[RadioCategoryCount][rcName], 32, "%s", RadioStations[RadioStationCount][rsCategory]);
            RadioCategoryCount++;
        }

        RadioStationCount++;
    }

    printf("[RadioStations] Loaded %d stations in %d categories.", RadioStationCount, RadioCategoryCount);
    return 1;
}

stock ER_LoadAudioZones()
{
    mysql_tquery(MainPipeline, "SELECT * FROM `audiozones` WHERE `enabled`=1 ORDER BY `id` ASC", "ER_OnAudioZonesLoad");
    return 1;
}

forward ER_OnAudioZonesLoad();
public ER_OnAudioZonesLoad()
{
    new rows;
    cache_get_row_count(rows);
    ER_ClearAudioZones();

    for(new r; r < rows && AudioZoneCount < MAX_AUDIO_ZONES; r++)
    {
        cache_get_value_name_int(r, "id", AudioZones[AudioZoneCount][azSQLID]);
        cache_get_value_name(r, "name", AudioZones[AudioZoneCount][azName], 64);
        cache_get_value_name(r, "url", AudioZones[AudioZoneCount][azURL], 256);
        cache_get_value_name_float(r, "x", AudioZones[AudioZoneCount][azX]);
        cache_get_value_name_float(r, "y", AudioZones[AudioZoneCount][azY]);
        cache_get_value_name_float(r, "z", AudioZones[AudioZoneCount][azZ]);
        cache_get_value_name_float(r, "range", AudioZones[AudioZoneCount][azRange]);
        cache_get_value_name_int(r, "vw", AudioZones[AudioZoneCount][azVW]);
        cache_get_value_name_int(r, "interior", AudioZones[AudioZoneCount][azInt]);
        cache_get_value_name_int(r, "enabled", AudioZones[AudioZoneCount][azEnabled]);

        AudioZones[AudioZoneCount][azAreaID] = CreateDynamicSphere(
            AudioZones[AudioZoneCount][azX],
            AudioZones[AudioZoneCount][azY],
            AudioZones[AudioZoneCount][azZ],
            AudioZones[AudioZoneCount][azRange],
            AudioZones[AudioZoneCount][azVW],
            AudioZones[AudioZoneCount][azInt]
        );
        AudioZoneCount++;
    }

    printf("[AudioZones] Loaded %d audio zones.", AudioZoneCount);
    return 1;
}

stock ER_FindAudioZoneBySQLID(sqlid)
{
    for(new i; i < AudioZoneCount; i++) if(AudioZones[i][azSQLID] == sqlid) return i;
    return -1;
}

stock ER_FindAudioZoneByArea(areaid)
{
    for(new i; i < AudioZoneCount; i++) if(AudioZones[i][azAreaID] == areaid) return i;
    return -1;
}

stock ER_FindRadioStationBySQLID(sqlid)
{
    for(new i; i < RadioStationCount; i++) if(RadioStations[i][rsSQLID] == sqlid) return i;
    return -1;
}

stock ER_ShowCreateAudioMain(playerid)
{
    return ShowPlayerDialog(playerid, DIALOG_CREATE_AUDIO_MAIN, DIALOG_STYLE_LIST, "Create Audio Zone", "Custom URL\nRadio Station", "Select", "Cancel");
}

stock ER_ShowRadioCategories(playerid, dialogid)
{
    new list[2048];

    if(dialogid == DIALOG_SETRADIO_CATEGORY)
    {
        format(list, sizeof(list), "Favorite Radio\nStop Radio\n");
    }
    else list[0] = EOS;

    for(new c; c < RadioCategoryCount; c++)
    {
        format(list, sizeof(list), "%s%s\n", list, RadioCategories[c][rcName]);
    }

    return ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, "Radio Categories", list, "Select", "Cancel");
}

stock ER_ShowStationsByCategory(playerid, const category[], dialogid)
{
    new list[4096], count, pvar[24];
    list[0] = EOS;

    for(new i; i < RadioStationCount; i++)
    {
        if(!strcmp(RadioStations[i][rsCategory], category, true))
        {
            format(pvar, sizeof(pvar), "RadioSel%d", count);
            SetPVarInt(playerid, pvar, i);
            format(list, sizeof(list), "%s%s\n", list, RadioStations[i][rsName]);
            count++;
        }
    }

    if(!count) return ER_Send(playerid, COLOR_GREY, "No stations found in this category.");
    return ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, category, list, "Select", "Back");
}


stock ER_StopPlayerVehicleRadio(playerid)
{
    StopAudioStreamForPlayer(playerid);
    return 1;
}

stock ER_PlayVehicleStationForPlayer(playerid, vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;

    new stationidx = ER_VehicleRadioStation[vehicleid];
    if(stationidx < 0 || stationidx >= RadioStationCount) return 0;

    PlayAudioStreamForPlayer(playerid, RadioStations[stationidx][rsURL]);

    new msg[128];
    format(msg, sizeof(msg), "Vehicle radio tuned to %s.", RadioStations[stationidx][rsName]);
    ER_Send(playerid, COLOR_GREEN, msg);
    return 1;
}

stock ER_SetVehicleStation(vehicleid, stationidx)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;
    if(stationidx < 0 || stationidx >= RadioStationCount) return 0;

    ER_VehicleRadioStation[vehicleid] = stationidx;

    foreach(new i : Player)
    {
        if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == vehicleid)
        {
            PlayAudioStreamForPlayer(i, RadioStations[stationidx][rsURL]);
        }
    }
    return 1;
}

stock ER_StopVehicleStation(vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;

    ER_VehicleRadioStation[vehicleid] = -1;

    foreach(new i : Player)
    {
        if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == vehicleid)
        {
            StopAudioStreamForPlayer(i);
            ER_Send(i, COLOR_GREEN, "Vehicle radio stopped.");
        }
    }
    return 1;
}

stock ER_OnVehicleSeatEntered(playerid, vehicleid)
{
    if(vehicleid <= 0 || vehicleid >= MAX_VEHICLES) return 0;
    if(ER_VehicleRadioStation[vehicleid] >= 0)
    {
        return ER_PlayVehicleStationForPlayer(playerid, vehicleid);
    }
    return 0;
}

stock ER_OnVehicleSeatExited(playerid, vehicleid)
{
    if(vehicleid > 0 && vehicleid < MAX_VEHICLES && ER_VehicleRadioStation[vehicleid] >= 0)
    {
        StopAudioStreamForPlayer(playerid);
        DeletePVar(playerid, "PlayingAudioZoneArea");
        DeletePVar(playerid, "CurrentAudioZoneArea");

        // If player exited inside an audio zone, start the zone audio immediately.
        ER_StartAudioZoneIfInside(playerid);
    }
    else
    {
        // No active vehicle radio, but still check in case vehicle-radio priority blocked zone audio while inside.
        ER_StartAudioZoneIfInside(playerid);
    }
    return 1;
}

stock ER_ResetVehicleRadio(vehicleid)
{
    if(vehicleid > 0 && vehicleid < MAX_VEHICLES)
    {
        foreach(new i : Player)
        {
            if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == vehicleid)
            {
                StopAudioStreamForPlayer(i);
            }
        }
        ER_VehicleRadioStation[vehicleid] = -1;
    }
    return 1;
}


CMD:createaudio(playerid, params[])
{
    new Float:distance;
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "f", distance)) return ER_Send(playerid, COLOR_GREY, "USAGE: /createaudio [distance]");
    if(distance < 1.0 || distance > 250.0) return ER_Send(playerid, COLOR_GREY, "Distance must be between 1.0 and 250.0.");

    SetPVarFloat(playerid, "CreateAudioDistance", distance);
    return ER_ShowCreateAudioMain(playerid);
}
CMD:editaudios(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");

    new list[4096];
    format(list, sizeof(list), "ID\tName\tDistance\n");
    for(new i; i < AudioZoneCount; i++)
    {
        format(list, sizeof(list), "%s%d\t%s\t%.1f\n", list, AudioZones[i][azSQLID], AudioZones[i][azName], AudioZones[i][azRange]);
    }
    if(AudioZoneCount <= 0) return ER_Send(playerid, COLOR_GREY, "No audio zones created.");
    return ShowPlayerDialog(playerid, DIALOG_EDIT_AUDIO_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Edit Audio Zones", list, "Select", "Cancel");
}
alias:editaudios("editaudiozones")

CMD:editaudio(playerid, params[])
{
    new sqlid;

    if(!ER_IsAdmin(playerid, ADMIN_SENIOR))
    {
        return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    }

    // /editaudio with no ID opens the full audio list.
    if(isnull(params))
    {
        new list[4096];
        format(list, sizeof(list), "ID\tName\tDistance\n");

        for(new i; i < AudioZoneCount; i++)
        {
            format(list, sizeof(list), "%s%d\t%s\t%.1f\n", list, AudioZones[i][azSQLID], AudioZones[i][azName], AudioZones[i][azRange]);
        }

        if(AudioZoneCount <= 0)
        {
            return ER_Send(playerid, COLOR_GREY, "No audio zones created.");
        }

        return ShowPlayerDialog(playerid, DIALOG_EDIT_AUDIO_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Edit Audio Zones", list, "Select", "Cancel");
    }

    // /editaudio [id] opens that exact audio zone.
    if(sscanf(params, "d", sqlid))
    {
        return ER_Send(playerid, COLOR_GREY, "USAGE: /editaudio [optional id]");
    }

    if(ER_FindAudioZoneBySQLID(sqlid) == -1)
    {
        return ER_Send(playerid, COLOR_GREY, "Audio zone not found.");
    }

    SetPVarInt(playerid, "EditingAudioID", sqlid);
    return ShowPlayerDialog(playerid, DIALOG_EDIT_AUDIO_MENU, DIALOG_STYLE_LIST, "Edit Audio Zone", "Name\nURL\nChange Station\nSet Position To Me\nDistance\nReload\nDelete", "Select", "Close");
}
CMD:deleteaudio(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");

    new list[4096];
    format(list, sizeof(list), "ID\tName\tDistance\n");
    for(new i; i < AudioZoneCount; i++)
    {
        format(list, sizeof(list), "%s%d\t%s\t%.1f\n", list, AudioZones[i][azSQLID], AudioZones[i][azName], AudioZones[i][azRange]);
    }
    if(AudioZoneCount <= 0) return ER_Send(playerid, COLOR_GREY, "No audio zones created.");
    return ShowPlayerDialog(playerid, DIALOG_DELETE_AUDIO_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Delete Audio Zone", list, "Delete", "Cancel");
}

CMD:setstation(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid)) return ER_Send(playerid, COLOR_GREY, "You must be inside a vehicle to use the radio.");
    if(RadioStationCount <= 0) return ER_Send(playerid, COLOR_GREY, "No radio stations loaded.");
    return ER_ShowRadioCategories(playerid, DIALOG_SETRADIO_CATEGORY);
}
alias:setstation("setradio")


CMD:setfreq(playerid, params[])
{
    new freq;
    if(sscanf(params, "d", freq)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setfreq [1 to 99999]");
    if(!PlayerInfo[playerid][pHasRadio]) return ER_Send(playerid, COLOR_GREY, "You must have a radio to use this command.");
    if(freq < RADIO_MIN_FREQ || freq > RADIO_MAX_FREQ) return ER_Send(playerid, COLOR_GREY, "Frequency must be between 1 and 99999.");
    PlayerInfo[playerid][pRadio] = freq;
    new msg[96]; format(msg, sizeof(msg), "Radio frequency set to %d.", freq);
    return ER_Send(playerid, COLOR_RADIO, msg);
}

CMD:pr(playerid, params[])
{
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /pr [message]");
    if(!PlayerInfo[playerid][pHasRadio]) return ER_Send(playerid, COLOR_GREY, "You must have a radio to use this command.");
    if(PlayerInfo[playerid][pRadio] == 0) return ER_Send(playerid, COLOR_GREY, "Please set your radio frequency first by using /setfreq [1 to 99999].");

    new msg[160], bubble[96];
    format(msg, sizeof(msg), "[Radio: %d] %s says: %s", PlayerInfo[playerid][pRadio], ER_GetName(playerid), params);
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pHasRadio] && PlayerInfo[i][pRadio] == PlayerInfo[playerid][pRadio]) SendClientMessage(i, COLOR_RADIO, msg);
    }

    // Very close players see the player talking into the radio above their head,
    // but it does not print an extra nearby chat line.
    format(bubble, sizeof(bubble), "[Radio] %s", params);
    SetPlayerChatBubble(playerid, bubble, COLOR_WHITE, 12.0, 6000);
    return 1;
}
alias:pr("publicradio")

CMD:fbackup(playerid, params[])
{
    if(PlayerInfo[playerid][pFamily] == INVALID_FAMILY_ID) return ER_Send(playerid, COLOR_GREY, "You are not in a family.");
    if(!PlayerInfo[playerid][pHasRadio]) return ER_Send(playerid, COLOR_GREY, "You must have a radio to use this command.");
    if(FamilyBeaconActive[playerid]) return ER_Send(playerid, COLOR_GREY, "You already have an active beacon.");
    new zone[32] = "Unknown", msg[160], local[128], Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    ER_GetPlayerZone(playerid, zone, sizeof(zone));
    if(PlayerInfo[playerid][pWantedLevel] > 0) format(msg, sizeof(msg), "** Radio ** %s (%d): I need urgent backup, Wanted with %d charges! At: %s!", ER_GetName(playerid), playerid, PlayerInfo[playerid][pWantedLevel], zone);
    else format(msg, sizeof(msg), "** Radio ** %s (%d): I need urgent backup! Currently at %s!", ER_GetName(playerid), playerid, zone);
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFamily] == PlayerInfo[playerid][pFamily])
        {
            SendClientMessage(i, COLOR_RADIO, msg);
            FamilyBeaconIcon[playerid][i] = SetPlayerMapIcon(i, 90 + playerid, x, y, z, 0, COLOR_YELLOW, MAPICON_GLOBAL);
        }
    }
    format(local, sizeof(local), "* %s broadcasts a beacon signal.", ER_GetName(playerid));
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, local, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    FamilyBeaconActive[playerid] = 1;
    FamilyBeaconTimer[playerid] = SetTimerEx("ER_ClearFamilyBeaconTimer", ServerCore[scFamilyBackupBeaconTime] * 1000, false, "i", playerid);
    ER_Send(playerid, COLOR_YELLOW, "Your beacon has been placed automatically. Type /nofbackup to clear your beacon.");
    return 1;
}

forward ER_ClearFamilyBeaconTimer(playerid);
public ER_ClearFamilyBeaconTimer(playerid)
{
    ER_ClearFamilyBeacon(playerid);
    if(IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREY, "Your beacon has been cleared automatically.");
    return 1;
}

stock ER_ClearFamilyBeacon(playerid)
{
    if(FamilyBeaconTimer[playerid]) KillTimer(FamilyBeaconTimer[playerid]);
    FamilyBeaconTimer[playerid] = 0;
    FamilyBeaconActive[playerid] = 0;
    foreach(new i : Player) RemovePlayerMapIcon(i, 90 + playerid);
    return 1;
}

CMD:nofbackup(playerid, params[])
{
    ER_ClearFamilyBeacon(playerid);
    return ER_Send(playerid, COLOR_YELLOW, "You have cleared your beacon.");
}

stock ER_PlayVehicleRadio(playerid, stationidx)
{
    if(!IsPlayerInAnyVehicle(playerid)) return 0;
    return ER_SetVehicleStation(GetPlayerVehicleID(playerid), stationidx);
}

stock ER_OnPlayerEnterAudioArea(playerid, areaid)
{
    new idx = ER_FindAudioZoneByArea(areaid);
    if(idx == -1) return 0;

    SetPVarInt(playerid, "CurrentAudioZoneArea", areaid);

    // Already playing this exact zone. Do not restart the stream.
    if(GetPVarInt(playerid, "PlayingAudioZoneArea") == areaid)
    {
        return 1;
    }

    // Vehicle radio has priority. Do not override it with zone audio while inside a vehicle.
    if(IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid > 0 && vehicleid < MAX_VEHICLES && ER_VehicleRadioStation[vehicleid] >= 0)
        {
            return 1;
        }
    }

    SetPVarInt(playerid, "PlayingAudioZoneArea", areaid);
    PlayAudioStreamForPlayer(playerid, AudioZones[idx][azURL], AudioZones[idx][azX], AudioZones[idx][azY], AudioZones[idx][azZ], AudioZones[idx][azRange], 1);
    return 1;
}

stock ER_OnPlayerLeaveAudioArea(playerid, areaid)
{
    if(ER_FindAudioZoneByArea(areaid) == -1) return 0;

    if(GetPVarInt(playerid, "CurrentAudioZoneArea") == areaid)
    {
        DeletePVar(playerid, "CurrentAudioZoneArea");
    }

    if(GetPVarInt(playerid, "PlayingAudioZoneArea") == areaid)
    {
        DeletePVar(playerid, "PlayingAudioZoneArea");
        StopAudioStreamForPlayer(playerid);

        // If the player is still in a vehicle with a station, restore vehicle radio after zone audio stops.
        if(IsPlayerInAnyVehicle(playerid))
        {
            ER_PlayVehicleStationForPlayer(playerid, GetPlayerVehicleID(playerid));
        }
    }
    return 1;
}


stock ER_IsPlayerInsideAudioZoneIndex(playerid, idx)
{
    if(idx < 0 || idx >= AudioZoneCount) return 0;

    if(AudioZones[idx][azVW] != -1 && AudioZones[idx][azVW] != GetPlayerVirtualWorld(playerid)) return 0;
    if(AudioZones[idx][azInt] != -1 && AudioZones[idx][azInt] != GetPlayerInterior(playerid)) return 0;

    if(!IsPlayerInRangeOfPoint(playerid, AudioZones[idx][azRange] + 1.0, AudioZones[idx][azX], AudioZones[idx][azY], AudioZones[idx][azZ])) return 0;
    return 1;
}


stock ER_StartAudioZoneIfInside(playerid)
{
    if(!PlayerInfo[playerid][pLoggedIn]) return 0;

    // If still in a vehicle with active radio, vehicle radio has priority.
    if(IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid > 0 && vehicleid < MAX_VEHICLES && ER_VehicleRadioStation[vehicleid] >= 0)
        {
            return 0;
        }
    }

    // Already playing a zone.
    new playingArea = GetPVarInt(playerid, "PlayingAudioZoneArea");
    if(playingArea > 0)
    {
        new playingIdx = ER_FindAudioZoneByArea(playingArea);
        if(playingIdx != -1 && ER_IsPlayerInsideAudioZoneIndex(playerid, playingIdx))
        {
            return 1;
        }
    }

    for(new i; i < AudioZoneCount; i++)
    {
        if(ER_IsPlayerInsideAudioZoneIndex(playerid, i))
        {
            SetPVarInt(playerid, "CurrentAudioZoneArea", AudioZones[i][azAreaID]);
            SetPVarInt(playerid, "PlayingAudioZoneArea", AudioZones[i][azAreaID]);
            PlayAudioStreamForPlayer(playerid, AudioZones[i][azURL], AudioZones[i][azX], AudioZones[i][azY], AudioZones[i][azZ], AudioZones[i][azRange], 1);
            return 1;
        }
    }

    return 0;
}

stock ER_UpdatePlayerAudioZone(playerid)
{
    if(!PlayerInfo[playerid][pLoggedIn]) return 0;

    // Throttle check because this is called from OnPlayerUpdate.
    new now = GetTickCount();
    if(GetPVarInt(playerid, "AudioZoneCheckTick") > now) return 1;
    SetPVarInt(playerid, "AudioZoneCheckTick", now + 1500);

    new playingArea = GetPVarInt(playerid, "PlayingAudioZoneArea");

    if(playingArea > 0)
    {
        new idx = ER_FindAudioZoneByArea(playingArea);

        // If player is still inside the same zone, do nothing. This prevents double-play spam.
        if(idx != -1 && ER_IsPlayerInsideAudioZoneIndex(playerid, idx))
        {
            return 1;
        }

        DeletePVar(playerid, "PlayingAudioZoneArea");
        DeletePVar(playerid, "CurrentAudioZoneArea");
        StopAudioStreamForPlayer(playerid);

        if(IsPlayerInAnyVehicle(playerid))
        {
            ER_PlayVehicleStationForPlayer(playerid, GetPlayerVehicleID(playerid));
        }
        return 1;
    }

    // Vehicle radio has priority over audio zones.
    if(IsPlayerInAnyVehicle(playerid))
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid > 0 && vehicleid < MAX_VEHICLES && ER_VehicleRadioStation[vehicleid] >= 0)
        {
            return 1;
        }
    }

    // Not already playing a zone: start only one zone.
    for(new i; i < AudioZoneCount; i++)
    {
        if(ER_IsPlayerInsideAudioZoneIndex(playerid, i))
        {
            SetPVarInt(playerid, "CurrentAudioZoneArea", AudioZones[i][azAreaID]);
            SetPVarInt(playerid, "PlayingAudioZoneArea", AudioZones[i][azAreaID]);
            PlayAudioStreamForPlayer(playerid, AudioZones[i][azURL], AudioZones[i][azX], AudioZones[i][azY], AudioZones[i][azZ], AudioZones[i][azRange], 1);
            return 1;
        }
    }

    return 1;
}

forward ER_OnAudioZoneChanged(playerid);
public ER_OnAudioZoneChanged(playerid)
{
    ER_LoadAudioZones();
    if(IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "Audio zone saved and reloaded.");
    return 1;
}

stock ER_AudioDialog(playerid, dialogid, response, listitem, inputtext[])
{
    new q[768], Float:x, Float:y, Float:z, Float:distance, stationidx, pvar[24], sqlid, idx;

    if(dialogid == DIALOG_CREATE_AUDIO_MAIN)
    {
        if(!response) return 1;
        if(listitem == 0) return ShowPlayerDialog(playerid, DIALOG_CREATE_AUDIO_CUSTOM_NAME, DIALOG_STYLE_INPUT, "Custom Audio Name", "Enter a name for this custom audio zone:", "Next", "Back");
        return ER_ShowRadioCategories(playerid, DIALOG_CREATE_AUDIO_CATEGORY);
    }

    if(dialogid == DIALOG_CREATE_AUDIO_CATEGORY)
    {
        if(!response) return ER_ShowCreateAudioMain(playerid);
        if(listitem < 0 || listitem >= RadioCategoryCount) return 1;
        SetPVarString(playerid, "CreateAudioCategory", RadioCategories[listitem][rcName]);
        return ER_ShowStationsByCategory(playerid, RadioCategories[listitem][rcName], DIALOG_CREATE_AUDIO_STATION);
    }

    if(dialogid == DIALOG_CREATE_AUDIO_STATION)
    {
        if(!response) return ER_ShowRadioCategories(playerid, DIALOG_CREATE_AUDIO_CATEGORY);
        format(pvar, sizeof(pvar), "RadioSel%d", listitem);
        stationidx = GetPVarInt(playerid, pvar);
        if(stationidx < 0 || stationidx >= RadioStationCount) return 1;
        GetPlayerPos(playerid, x, y, z);
        distance = GetPVarFloat(playerid, "CreateAudioDistance");
        mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `audiozones` (`name`,`url`,`x`,`y`,`z`,`range`,`vw`,`interior`,`enabled`) VALUES ('%e','%e',%f,%f,%f,%f,%d,%d,1)", RadioStations[stationidx][rsName], RadioStations[stationidx][rsURL], x, y, z, distance, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
        mysql_tquery(MainPipeline, q, "ER_OnAudioZoneChanged", "i", playerid);
        return 1;
    }

    if(dialogid == DIALOG_CREATE_AUDIO_CUSTOM_NAME)
    {
        if(!response) return ER_ShowCreateAudioMain(playerid);
        if(strlen(inputtext) < 2) return ShowPlayerDialog(playerid, DIALOG_CREATE_AUDIO_CUSTOM_NAME, DIALOG_STYLE_INPUT, "Custom Audio Name", "Enter a valid name:", "Next", "Back");
        SetPVarString(playerid, "CustomAudioName", inputtext);
        return ShowPlayerDialog(playerid, DIALOG_CREATE_AUDIO_CUSTOM_URL, DIALOG_STYLE_INPUT, "Custom Audio URL", "Enter the stream URL:", "Create", "Back");
    }

    if(dialogid == DIALOG_CREATE_AUDIO_CUSTOM_URL)
    {
        if(!response) return ShowPlayerDialog(playerid, DIALOG_CREATE_AUDIO_CUSTOM_NAME, DIALOG_STYLE_INPUT, "Custom Audio Name", "Enter a name for this custom audio zone:", "Next", "Back");
        if(strlen(inputtext) < 8) return ShowPlayerDialog(playerid, DIALOG_CREATE_AUDIO_CUSTOM_URL, DIALOG_STYLE_INPUT, "Custom Audio URL", "Enter a valid stream URL:", "Create", "Back");
        new name[64];
        GetPVarString(playerid, "CustomAudioName", name, sizeof(name));
        GetPlayerPos(playerid, x, y, z);
        distance = GetPVarFloat(playerid, "CreateAudioDistance");
        mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `audiozones` (`name`,`url`,`x`,`y`,`z`,`range`,`vw`,`interior`,`enabled`) VALUES ('%e','%e',%f,%f,%f,%f,%d,%d,1)", name, inputtext, x, y, z, distance, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
        mysql_tquery(MainPipeline, q, "ER_OnAudioZoneChanged", "i", playerid);
        return 1;
    }

    if(dialogid == DIALOG_EDIT_AUDIO_LIST || dialogid == DIALOG_DELETE_AUDIO_LIST)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= AudioZoneCount) return 1;
        sqlid = AudioZones[listitem][azSQLID];
        if(dialogid == DIALOG_DELETE_AUDIO_LIST)
        {
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `audiozones` SET `enabled`=0 WHERE `id`=%d", sqlid);
            mysql_tquery(MainPipeline, q, "ER_OnAudioZoneChanged", "i", playerid);
            return 1;
        }
        SetPVarInt(playerid, "EditingAudioID", sqlid);
        return ShowPlayerDialog(playerid, DIALOG_EDIT_AUDIO_MENU, DIALOG_STYLE_LIST, "Edit Audio Zone", "Name\nURL\nChange Station\nSet Position To Me\nDistance\nReload\nDelete", "Select", "Close");
    }

    if(dialogid == DIALOG_EDIT_AUDIO_MENU)
    {
        if(!response) return 1;
        sqlid = GetPVarInt(playerid, "EditingAudioID");
        idx = ER_FindAudioZoneBySQLID(sqlid);
        if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Audio zone not found.");
        switch(listitem)
        {
            case 0: return ShowPlayerDialog(playerid, DIALOG_EDIT_AUDIO_NAME, DIALOG_STYLE_INPUT, "Audio Name", "Enter new audio name:", "Save", "Back");
            case 1: return ShowPlayerDialog(playerid, DIALOG_EDIT_AUDIO_URL, DIALOG_STYLE_INPUT, "Audio URL", "Enter new audio URL:", "Save", "Back");
            case 2:
            {
                SetPVarInt(playerid, "EditingAudioID", sqlid);
                return ER_ShowRadioCategories(playerid, DIALOG_EDIT_AUDIO_CATEGORY);
            }
            case 3:
            {
                GetPlayerPos(playerid, x, y, z);
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `audiozones` SET `x`=%f,`y`=%f,`z`=%f,`vw`=%d,`interior`=%d WHERE `id`=%d", x, y, z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), sqlid);
                mysql_tquery(MainPipeline, q, "ER_OnAudioZoneChanged", "i", playerid);
                return 1;
            }
            case 4: return ShowPlayerDialog(playerid, DIALOG_EDIT_AUDIO_DISTANCE, DIALOG_STYLE_INPUT, "Audio Distance", "Enter new hearing distance:", "Save", "Back");
            case 5:
            {
                ER_LoadAudioZones();
                return ER_Send(playerid, COLOR_GREEN, "Audio zones reloaded.");
            }
            case 6:
            {
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `audiozones` SET `enabled`=0 WHERE `id`=%d", sqlid);
                mysql_tquery(MainPipeline, q, "ER_OnAudioZoneChanged", "i", playerid);
                return 1;
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_EDIT_AUDIO_CATEGORY)
    {
        if(!response)
        {
            return ShowPlayerDialog(playerid, DIALOG_EDIT_AUDIO_MENU, DIALOG_STYLE_LIST, "Edit Audio Zone", "Name\nURL\nChange Station\nSet Position To Me\nDistance\nReload\nDelete", "Select", "Close");
        }

        if(listitem < 0 || listitem >= RadioCategoryCount) return 1;

        SetPVarString(playerid, "EditAudioCategory", RadioCategories[listitem][rcName]);
        return ER_ShowStationsByCategory(playerid, RadioCategories[listitem][rcName], DIALOG_EDIT_AUDIO_STATION);
    }

    if(dialogid == DIALOG_EDIT_AUDIO_STATION)
    {
        if(!response) return ER_ShowRadioCategories(playerid, DIALOG_EDIT_AUDIO_CATEGORY);

        sqlid = GetPVarInt(playerid, "EditingAudioID");
        idx = ER_FindAudioZoneBySQLID(sqlid);
        if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Audio zone not found.");

        format(pvar, sizeof(pvar), "RadioSel%d", listitem);
        stationidx = GetPVarInt(playerid, pvar);
        if(stationidx < 0 || stationidx >= RadioStationCount) return 1;

        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `audiozones` SET `name`='%e',`url`='%e' WHERE `id`=%d", RadioStations[stationidx][rsName], RadioStations[stationidx][rsURL], sqlid);
        mysql_tquery(MainPipeline, q, "ER_OnAudioZoneChanged", "i", playerid);
        return 1;
    }

    if(dialogid == DIALOG_EDIT_AUDIO_NAME)
    {
        if(!response) return 1;
        sqlid = GetPVarInt(playerid, "EditingAudioID");
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `audiozones` SET `name`='%e' WHERE `id`=%d", inputtext, sqlid);
        mysql_tquery(MainPipeline, q, "ER_OnAudioZoneChanged", "i", playerid);
        return 1;
    }

    if(dialogid == DIALOG_EDIT_AUDIO_URL)
    {
        if(!response) return 1;
        sqlid = GetPVarInt(playerid, "EditingAudioID");
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `audiozones` SET `url`='%e' WHERE `id`=%d", inputtext, sqlid);
        mysql_tquery(MainPipeline, q, "ER_OnAudioZoneChanged", "i", playerid);
        return 1;
    }

    if(dialogid == DIALOG_EDIT_AUDIO_DISTANCE)
    {
        if(!response) return 1;
        sqlid = GetPVarInt(playerid, "EditingAudioID");
        distance = floatstr(inputtext);
        if(distance < 1.0 || distance > 250.0) return ER_Send(playerid, COLOR_GREY, "Distance must be between 1.0 and 250.0.");
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `audiozones` SET `range`=%f WHERE `id`=%d", distance, sqlid);
        mysql_tquery(MainPipeline, q, "ER_OnAudioZoneChanged", "i", playerid);
        return 1;
    }

    if(dialogid == DIALOG_SETRADIO_CATEGORY)
    {
        if(!response) return 1;
        if(listitem == 0)
        {
            stationidx = ER_FindRadioStationBySQLID(PlayerInfo[playerid][pFavRadio]);
            if(stationidx == -1) return ER_Send(playerid, COLOR_GREY, "You do not have a favorite radio set.");
            return ER_SetVehicleStation(GetPlayerVehicleID(playerid), stationidx);
        }
        if(listitem == 1)
        {
            ER_StopVehicleStation(GetPlayerVehicleID(playerid));
            return 1;
        }
        new cat = listitem - 2;
        if(cat < 0 || cat >= RadioCategoryCount) return 1;
        return ER_ShowStationsByCategory(playerid, RadioCategories[cat][rcName], DIALOG_SETRADIO_STATION);
    }

    if(dialogid == DIALOG_SETRADIO_STATION)
    {
        if(!response) return ER_ShowRadioCategories(playerid, DIALOG_SETRADIO_CATEGORY);
        format(pvar, sizeof(pvar), "RadioSel%d", listitem);
        stationidx = GetPVarInt(playerid, pvar);
        if(stationidx < 0 || stationidx >= RadioStationCount) return 1;
        PlayerInfo[playerid][pFavRadio] = RadioStations[stationidx][rsSQLID];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `fav_radio`=%d WHERE `id`=%d", PlayerInfo[playerid][pFavRadio], PlayerInfo[playerid][pID]);
        mysql_tquery(MainPipeline, q);
        return ER_SetVehicleStation(GetPlayerVehicleID(playerid), stationidx);
    }

    if(dialogid == DIALOG_MP3_CATEGORY)
    {
        if(!response) return 1;
        new cat[32], seen, catidx = -1;
        for(new i; i < RadioCategoryCount; i++)
        {
            if(seen == listitem) { catidx = i; break; }
            seen++;
        }
        if(catidx == -1) return 1;
        format(cat, sizeof(cat), "%s", RadioCategories[catidx][rcName]);
        ER_ShowStationsByCategory(playerid, cat, DIALOG_MP3_STATION);
        return 1;
    }
    if(dialogid == DIALOG_MP3_STATION)
    {
        if(!response) return 1;
        new category[32]; GetPVarString(playerid, "RadioCategory", category, sizeof(category));
        new seen, stationidx2 = -1;
        for(new i; i < RadioStationCount; i++)
        {
            if(!strcmp(RadioStations[i][rsCategory], category, true))
            {
                if(seen == listitem) { stationidx2 = i; break; }
                seen++;
            }
        }
        if(stationidx2 == -1) return 1;
        PlayAudioStreamForPlayer(playerid, RadioStations[stationidx2][rsURL]);
        ER_Send(playerid, COLOR_GREEN, "MP3 station started. Use /stopmp3 to stop it.");
        return 1;
    }
    return 0;
}

CMD:mp3(playerid, params[])
{
    if(!PlayerInfo[playerid][pHasMP3]) return ER_Send(playerid, COLOR_GREY, "You do not own an MP3 player. Buy one from a 24/7 store.");
    ER_ShowRadioCategories(playerid, DIALOG_MP3_CATEGORY);
    return 1;
}
CMD:stopmp3(playerid, params[])
{
    StopAudioStreamForPlayer(playerid);
    return ER_Send(playerid, COLOR_GREEN, "MP3 stopped.");
}
