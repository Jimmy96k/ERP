#if defined _ER_UTILS_INCLUDED
    #endinput
#endif
#define _ER_UTILS_INCLUDED

stock ER_ColorToDialogHex(color, dest[], size)
{
    new rgb = (color >>> 8) & 0xFFFFFF;
    if(rgb == 0) rgb = 0xFFFFFF;
    return format(dest, size, "%06x", rgb);
}

stock ER_GetWeekdayIndex(year, month, day)
{
    static const offsets[12] = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    if(month < 3) year--;
    return (year + year / 4 - year / 100 + year / 400 + offsets[month - 1] + day) % 7;
}

stock ER_GetWeekdayName(dayidx, dest[], size)
{
    switch(dayidx)
    {
        case 0: return format(dest, size, "Sunday");
        case 1: return format(dest, size, "Monday");
        case 2: return format(dest, size, "Tuesday");
        case 3: return format(dest, size, "Wednesday");
        case 4: return format(dest, size, "Thursday");
        case 5: return format(dest, size, "Friday");
    }
    return format(dest, size, "Saturday");
}

stock ER_GetMonthShortName(month, dest[], size)
{
    switch(month)
    {
        case 1: return format(dest, size, "JAN");
        case 2: return format(dest, size, "FEB");
        case 3: return format(dest, size, "MAR");
        case 4: return format(dest, size, "APR");
        case 5: return format(dest, size, "MAY");
        case 6: return format(dest, size, "JUN");
        case 7: return format(dest, size, "JUL");
        case 8: return format(dest, size, "AUG");
        case 9: return format(dest, size, "SEP");
        case 10: return format(dest, size, "OCT");
        case 11: return format(dest, size, "NOV");
    }
    return format(dest, size, "DEC");
}

new PlayerText:ER_TimeTD[MAX_PLAYERS][3];
new bool:ER_TimeTDVisible[MAX_PLAYERS];

stock ER_DestroyTimeTextdraw(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(ER_TimeTDVisible[playerid])
    {
        for(new i; i < 3; i++)
        {
            PlayerTextDrawHide(playerid, ER_TimeTD[playerid][i]);
            PlayerTextDrawDestroy(playerid, ER_TimeTD[playerid][i]);
            ER_TimeTD[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }
        ER_TimeTDVisible[playerid] = false;
    }
    return 1;
}

forward ER_HideTimeTextdraw(playerid);
public ER_HideTimeTextdraw(playerid)
{
    return ER_DestroyTimeTextdraw(playerid);
}

CMD:time(playerid, params[])
{
    #pragma unused params
    ER_DestroyTimeTextdraw(playerid);

    new year, month, day, hour, minute, second;
    new ampm[3], hour12, weekday[16], monthname[8], dateLine[24], timeLine[24];
    getdate(year, month, day);
    gettime(hour, minute, second);

    ER_GetWeekdayName(ER_GetWeekdayIndex(year, month, day), weekday, sizeof(weekday));
    ER_GetMonthShortName(month, monthname, sizeof(monthname));

    hour12 = hour % 12;
    if(hour12 == 0) hour12 = 12;
    format(ampm, sizeof(ampm), "%s", hour >= 12 ? "PM" : "AM");

    format(dateLine, sizeof(dateLine), "%02d %s", day, monthname);
    format(timeLine, sizeof(timeLine), "%02d:%02d %s", hour12, minute, ampm);

    ER_TimeTD[playerid][0] = CreatePlayerTextDraw(playerid, 623.0, 252.0, dateLine);
    PlayerTextDrawAlignment(playerid, ER_TimeTD[playerid][0], 3);
    PlayerTextDrawBackgroundColor(playerid, ER_TimeTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, ER_TimeTD[playerid][0], 2);
    PlayerTextDrawLetterSize(playerid, ER_TimeTD[playerid][0], 0.520000, 2.100000);
    PlayerTextDrawColor(playerid, ER_TimeTD[playerid][0], 0xE8E8E8FF);
    PlayerTextDrawSetOutline(playerid, ER_TimeTD[playerid][0], 2);
    PlayerTextDrawSetShadow(playerid, ER_TimeTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, ER_TimeTD[playerid][0], 1);

    ER_TimeTD[playerid][1] = CreatePlayerTextDraw(playerid, 623.0, 274.0, weekday);
    PlayerTextDrawAlignment(playerid, ER_TimeTD[playerid][1], 3);
    PlayerTextDrawBackgroundColor(playerid, ER_TimeTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, ER_TimeTD[playerid][1], 3);
    PlayerTextDrawLetterSize(playerid, ER_TimeTD[playerid][1], 0.760000, 3.100000);
    PlayerTextDrawColor(playerid, ER_TimeTD[playerid][1], 0xF6A800FF);
    PlayerTextDrawSetOutline(playerid, ER_TimeTD[playerid][1], 2);
    PlayerTextDrawSetShadow(playerid, ER_TimeTD[playerid][1], 2);
    PlayerTextDrawSetProportional(playerid, ER_TimeTD[playerid][1], 1);

    ER_TimeTD[playerid][2] = CreatePlayerTextDraw(playerid, 623.0, 313.0, timeLine);
    PlayerTextDrawAlignment(playerid, ER_TimeTD[playerid][2], 3);
    PlayerTextDrawBackgroundColor(playerid, ER_TimeTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, ER_TimeTD[playerid][2], 2);
    PlayerTextDrawLetterSize(playerid, ER_TimeTD[playerid][2], 0.640000, 2.500000);
    PlayerTextDrawColor(playerid, ER_TimeTD[playerid][2], 0xF4F4F4FF);
    PlayerTextDrawSetOutline(playerid, ER_TimeTD[playerid][2], 2);
    PlayerTextDrawSetShadow(playerid, ER_TimeTD[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, ER_TimeTD[playerid][2], 1);

    for(new i; i < 3; i++) PlayerTextDrawShow(playerid, ER_TimeTD[playerid][i]);
    ER_TimeTDVisible[playerid] = true;
    SetTimerEx("ER_HideTimeTextdraw", 7000, false, "i", playerid);
    return 1;
}

stock ER_Send(playerid, color, const msg[]) return SendClientMessage(playerid, color, msg);

stock ER_GetName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}


new Text:ER_LoginTD[6];

stock ER_CreateLoginTextDraws()
{
	// Top black bar
	ER_LoginTD[0] = TextDrawCreate(0.000000, 0.000000, "_");
	TextDrawBackgroundColor(ER_LoginTD[0], 255);
	TextDrawFont(ER_LoginTD[0], 1);
	TextDrawLetterSize(ER_LoginTD[0], 0.500000, 15.500000);
	TextDrawColor(ER_LoginTD[0], -1);
	TextDrawSetOutline(ER_LoginTD[0], 0);
	TextDrawSetProportional(ER_LoginTD[0], 1);
	TextDrawUseBox(ER_LoginTD[0], 1);
	TextDrawBoxColor(ER_LoginTD[0], 255);
	TextDrawTextSize(ER_LoginTD[0], 640.000000, 0.000000);

	// Bottom black bar
	ER_LoginTD[1] = TextDrawCreate(0.000000, 345.000000, "_");
	TextDrawBackgroundColor(ER_LoginTD[1], 255);
	TextDrawFont(ER_LoginTD[1], 1);
	TextDrawLetterSize(ER_LoginTD[1], 0.500000, 13.500000);
	TextDrawColor(ER_LoginTD[1], -1);
	TextDrawSetOutline(ER_LoginTD[1], 0);
	TextDrawSetProportional(ER_LoginTD[1], 1);
	TextDrawUseBox(ER_LoginTD[1], 1);
	TextDrawBoxColor(ER_LoginTD[1], 255);
	TextDrawTextSize(ER_LoginTD[1], 640.000000, 0.000000);

	// Main title
	ER_LoginTD[2] = TextDrawCreate(320.000000, 42.000000, "Express Roleplay Gaming");
	TextDrawAlignment(ER_LoginTD[2], 2);
	TextDrawBackgroundColor(ER_LoginTD[2], 255);
	TextDrawFont(ER_LoginTD[2], 3);
	TextDrawLetterSize(ER_LoginTD[2], 0.850000, 4.000000);
	TextDrawColor(ER_LoginTD[2], 0xF6A800FF);
	TextDrawSetOutline(ER_LoginTD[2], 2);
	TextDrawSetProportional(ER_LoginTD[2], 1);
	TextDrawSetShadow(ER_LoginTD[2], 2);

	// Subtitle
	ER_LoginTD[3] = TextDrawCreate(320.000000, 104.000000, "_");
	TextDrawAlignment(ER_LoginTD[3], 2);
	TextDrawBackgroundColor(ER_LoginTD[3], 255);
	TextDrawFont(ER_LoginTD[3], 3);
	TextDrawLetterSize(ER_LoginTD[3], 0.010000, 0.010000);
	TextDrawColor(ER_LoginTD[3], 0xFFFFFFFF);
	TextDrawSetOutline(ER_LoginTD[3], 2);
	TextDrawSetProportional(ER_LoginTD[3], 1);
	TextDrawSetShadow(ER_LoginTD[3], 2);

	// Bottom info placeholders
	ER_LoginTD[4] = TextDrawCreate(320.000000, 365.000000, "News: Welcome to Express Roleplay - Gaming!");
	TextDrawAlignment(ER_LoginTD[4], 2);
	TextDrawBackgroundColor(ER_LoginTD[4], 255);
	TextDrawFont(ER_LoginTD[4], 2);
	TextDrawLetterSize(ER_LoginTD[4], 0.520000, 2.100000);
	TextDrawColor(ER_LoginTD[4], 0xFFFFFFFF);
	TextDrawSetOutline(ER_LoginTD[4], 2);
	TextDrawSetProportional(ER_LoginTD[4], 1);

	ER_LoginTD[5] = TextDrawCreate(320.000000, 415.000000, "Website:   |   Discord:");
	TextDrawAlignment(ER_LoginTD[5], 2);
	TextDrawBackgroundColor(ER_LoginTD[5], 255);
	TextDrawFont(ER_LoginTD[5], 2);
	TextDrawLetterSize(ER_LoginTD[5], 0.470000, 1.900000);
	TextDrawColor(ER_LoginTD[5], 0xFFFFFFFF);
	TextDrawSetOutline(ER_LoginTD[5], 2);
	TextDrawSetProportional(ER_LoginTD[5], 1);

	return 1;
}

stock ER_ShowLoginScreen(playerid)
{
	new bottom[144], news[160], website[96], discord[96];

	if(ServerCore[scNews][0]) format(news, sizeof(news), "News: %s", ServerCore[scNews]);
	else format(news, sizeof(news), "News: Welcome to Express Roleplay - Gaming!");

	if(ServerCore[scWebsite][0]) format(website, sizeof(website), "%s", ServerCore[scWebsite]);
	else format(website, sizeof(website), "Not set");

	if(ServerCore[scDiscord][0]) format(discord, sizeof(discord), "%s", ServerCore[scDiscord]);
	else format(discord, sizeof(discord), "Not set");

	format(bottom, sizeof(bottom), "Website: %s   |   Discord: %s", website, discord);
	TextDrawSetString(ER_LoginTD[4], news);
	TextDrawSetString(ER_LoginTD[5], bottom);

	for(new i; i < 6; i++)
	{
		TextDrawShowForPlayer(playerid, ER_LoginTD[i]);
	}

	// Login/Register should always look like night, regardless of real server time.
	SetPlayerWeather(playerid, 20);
	SetPlayerTime(playerid, 0, 0);
	return 1;
}

stock ER_HideLoginScreen(playerid)
{
	for(new i; i < 6; i++)
	{
		TextDrawHideForPlayer(playerid, ER_LoginTD[i]);
	}

	// After login/register, return player to normal daylight/server style.
	SetPlayerWeather(playerid, 1);
	SetPlayerTime(playerid, 12, 0);
	return 1;
}

stock ER_ForceDefaultSpawn(playerid)
{
	PlayerInfo[playerid][pSpawnX] = ServerCore[scDefaultSpawnX];
	PlayerInfo[playerid][pSpawnY] = ServerCore[scDefaultSpawnY];
	PlayerInfo[playerid][pSpawnZ] = ServerCore[scDefaultSpawnZ];
	PlayerInfo[playerid][pSpawnA] = ServerCore[scDefaultSpawnA];
	PlayerInfo[playerid][pSpawnInt] = ServerCore[scDefaultSpawnInt];
	PlayerInfo[playerid][pSpawnVW] = ServerCore[scDefaultSpawnVW];

	if(PlayerInfo[playerid][pID] > 0)
	{
		new q[256];
		mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `spawn_x`=%f,`spawn_y`=%f,`spawn_z`=%f,`spawn_a`=%f,`spawn_int`=%d,`spawn_vw`=%d WHERE `id`=%d",
			PlayerInfo[playerid][pSpawnX], PlayerInfo[playerid][pSpawnY], PlayerInfo[playerid][pSpawnZ], PlayerInfo[playerid][pSpawnA], PlayerInfo[playerid][pSpawnInt], PlayerInfo[playerid][pSpawnVW], PlayerInfo[playerid][pID]);
		mysql_tquery(MainPipeline, q);
	}
	return 1;
}


stock ER_ResetPlayer(playerid)
{
    format(PlayerInfo[playerid][pName], MAX_PLAYER_NAME_EX, "%s", ER_GetName(playerid));
    PlayerInfo[playerid][pID] = 0;
    PlayerInfo[playerid][pLoggedIn] = 0;
    PlayerInfo[playerid][pRegistered] = 0;
    PlayerInfo[playerid][pTutorial] = 0;
    PlayerInfo[playerid][pTutorialStep] = 0;
    PlayerInfo[playerid][pAdmin] = 0;
    PlayerInfo[playerid][pPlayerVip] = 0;
    PlayerInfo[playerid][pPhone] = 0;
    PlayerInfo[playerid][pPhoneOff] = false;
    PlayerInfo[playerid][pPhonespeaker] = false;
    PlayerInfo[playerid][pPhoneline] = INVALID_CALL_PLAYER;
    PlayerInfo[playerid][pCalling] = INVALID_CALL_PLAYER;
    PlayerInfo[playerid][pCallState] = 0;
    PlayerInfo[playerid][pPhonebook] = 0;
    PlayerInfo[playerid][pHospInsurance] = NO_HOSPITAL_INSURANCE;
    PlayerInfo[playerid][pHasRadio] = 0;
    PlayerInfo[playerid][pRadio] = 0;
    PlayerInfo[playerid][pVehicleLock] = 0;
    PlayerInfo[playerid][pHospitalTime] = 30;
    PlayerInfo[playerid][pTogFreeHospital] = 0;
    PlayerInfo[playerid][pFamily] = INVALID_FAMILY_ID;
    PlayerInfo[playerid][pFaction] = 0;
    PlayerInfo[playerid][pFamilyRank] = 0;
    PlayerInfo[playerid][pFamilyCrew] = 0;
    PlayerInfo[playerid][pBusiness] = INVALID_BUSINESS_ID;
    PlayerInfo[playerid][pInjured] = 0;
    PlayerInfo[playerid][pHospitalized] = 0;
    PlayerInfo[playerid][pHospitalBed] = -1;
    PlayerInfo[playerid][pHospitalID] = -1;
    PlayerInfo[playerid][pDeliveredByEMS] = 0;
    PlayerInfo[playerid][pInjuredX] = 0.0;
    PlayerInfo[playerid][pInjuredY] = 0.0;
    PlayerInfo[playerid][pInjuredZ] = 0.0;
    PlayerInfo[playerid][pInjuredA] = 0.0;
    PlayerInfo[playerid][pInjuredInt] = 0;
    PlayerInfo[playerid][pInjuredVW] = 0;
    for(new i; i < MAX_JOBS_PER_PLAYER; i++) PlayerInfo[playerid][pPlayerJob][i] = 0;
    for(new w; w < MAX_WEAPON_SLOTS; w++) PlayerInfo[playerid][pPlayerWeapons][w] = 0;
    return 1;
}

stock ER_FormatMoney(amount)
{
    new out[32];
    format(out, sizeof(out), "$%d", amount);
    return out;
}

stock ER_IsAdmin(playerid, level)
{
    return PlayerInfo[playerid][pAdmin] >= level || PlayerInfo[playerid][pAdmin] == ADMIN_EXEC;
}

stock ER_ApplyDefaultPlayerInfo(playerid)
{
    PlayerInfo[playerid][pTutorial] = 0;
    PlayerInfo[playerid][pTutorialStep] = 0;
    PlayerInfo[playerid][pLevel] = 1;
    PlayerInfo[playerid][pPlayingHours] = 0;
    PlayerInfo[playerid][pCash] = ServerCore[scDefaultCash];
    PlayerInfo[playerid][pBank] = ServerCore[scDefaultBank];
    PlayerInfo[playerid][pAge] = 18;
    format(PlayerInfo[playerid][pDOB], 16, "01/01/2000");
    format(PlayerInfo[playerid][pCountry], 32, "Unknown");
    PlayerInfo[playerid][pGender] = 1;
    PlayerInfo[playerid][pAccent] = 0;
    PlayerInfo[playerid][pSkin] = ServerCore[scDefaultMaleSkin];
    PlayerInfo[playerid][pPhone] = 0;
    PlayerInfo[playerid][pPhoneOff] = false;
    PlayerInfo[playerid][pPhonebook] = 0;
    PlayerInfo[playerid][pHospInsurance] = NO_HOSPITAL_INSURANCE;
    format(PlayerInfo[playerid][pMarriedTo], MAX_PLAYER_NAME_EX, "Nobody");
    PlayerInfo[playerid][pCrimes] = 0;
    PlayerInfo[playerid][pArrests] = 0;
    PlayerInfo[playerid][pWantedLevel] = 0;
    PlayerInfo[playerid][pMaterials] = 0;
    PlayerInfo[playerid][pPot] = 0;
    PlayerInfo[playerid][pCrack] = 0;
    PlayerInfo[playerid][pRope] = 0;
    PlayerInfo[playerid][pPackages] = 0;
    PlayerInfo[playerid][pSeeds] = 0;
    PlayerInfo[playerid][pSprunk] = 0;
    PlayerInfo[playerid][pCigar] = 0;
    PlayerInfo[playerid][pSprayCans] = 0;
    PlayerInfo[playerid][pHealth] = 100.0;
    PlayerInfo[playerid][pArmor] = 0.0;
    PlayerInfo[playerid][pRespectPoints] = 0;
    PlayerInfo[playerid][pWarnings] = 0;

    // Family/Faction defaults:
    // 0 = none, joined member starts rank 1, leader gets rank 6.
    PlayerInfo[playerid][pFamily] = 0;
    PlayerInfo[playerid][pFaction] = 0;
    PlayerInfo[playerid][pFamilyRank] = 0;
    PlayerInfo[playerid][pFamilyCrew] = 0;
    PlayerInfo[playerid][pFactionRank] = 0;
    PlayerInfo[playerid][pFactionDivision] = 0;
    PlayerInfo[playerid][pMaxVehicles] = 0;
    PlayerInfo[playerid][pMaxHouses] = 0;
    PlayerInfo[playerid][pMaxBusinesses] = 0;
    PlayerInfo[playerid][pMaxToys] = 0;
    PlayerInfo[playerid][pHasMP3] = 0;

    PlayerInfo[playerid][pSpawnX] = ServerCore[scDefaultSpawnX];
    PlayerInfo[playerid][pSpawnY] = ServerCore[scDefaultSpawnY];
    PlayerInfo[playerid][pSpawnZ] = ServerCore[scDefaultSpawnZ];
    PlayerInfo[playerid][pSpawnA] = ServerCore[scDefaultSpawnA];
    PlayerInfo[playerid][pSpawnInt] = ServerCore[scDefaultSpawnInt];
    PlayerInfo[playerid][pSpawnVW] = ServerCore[scDefaultSpawnVW];
    return 1;
}

stock ER_SpawnCharacter(playerid)
{
    ER_HideLoginScreen(playerid);

    new Float:sx = PlayerInfo[playerid][pSpawnX], Float:sy = PlayerInfo[playerid][pSpawnY], Float:sz = PlayerInfo[playerid][pSpawnZ], Float:sa = PlayerInfo[playerid][pSpawnA];
    new sint = PlayerInfo[playerid][pSpawnInt], svw = PlayerInfo[playerid][pSpawnVW];

    if(PlayerInfo[playerid][pInjured])
    {
        sx = PlayerInfo[playerid][pInjuredX];
        sy = PlayerInfo[playerid][pInjuredY];
        sz = PlayerInfo[playerid][pInjuredZ];
        sa = PlayerInfo[playerid][pInjuredA];
        sint = PlayerInfo[playerid][pInjuredInt];
        svw = PlayerInfo[playerid][pInjuredVW];
    }

    SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], sx, sy, sz, sa, 0, 0, 0, 0, 0, 0);

    TogglePlayerSpectating(playerid, false);
    SpawnPlayer(playerid);

    SetPlayerInterior(playerid, sint);
    SetPlayerVirtualWorld(playerid, svw);
    SetPlayerPos(playerid, sx, sy, sz);
    SetPlayerFacingAngle(playerid, sa);
    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
    SetPlayerArmour(playerid, PlayerInfo[playerid][pArmor]);

    if(PlayerInfo[playerid][pInjured])
    {
        SetPlayerHealth(playerid, 35.0);
        ClearAnimations(playerid);
        ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 1, 0, 1);
        GameTextForPlayer(playerid, "~r~INJURED~n~~w~WAITING FOR EMS /SERVICE EMS OR /ACCEPT DEATH", 5000, 3);
    }

    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);
    return 1;
}

stock ER_NearbyMessage(Float:x, Float:y, Float:z, Float:range, color, const message[], world = -1, interior = -1)
{
    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i) || !PlayerInfo[i][pLoggedIn]) continue;
        if(world != -1 && GetPlayerVirtualWorld(i) != world) continue;
        if(interior != -1 && GetPlayerInterior(i) != interior) continue;
        if(IsPlayerInRangeOfPoint(i, range, x, y, z)) SendClientMessage(i, color, message);
    }
    return 1;
}

stock Float:ER_FloatMin(Float:a, Float:b)
{
	return (a < b) ? a : b;
}


stock ER_GetZoneFromPos(Float:x, Float:y, Float:z, zone[], size)
{
    #pragma unused z
    if(x >= 1800.0 && x <= 2250.0 && y >= -1850.0 && y <= -1600.0) format(zone, size, "Idlewood");
    else if(x >= 2200.0 && x <= 2600.0 && y >= -1750.0 && y <= -1500.0) format(zone, size, "Ganton");
    else if(x >= 2400.0 && x <= 2900.0 && y >= -2200.0 && y <= -1700.0) format(zone, size, "Willowfield");
    else if(x >= 550.0 && x <= 1550.0 && y >= -1450.0 && y <= -950.0) format(zone, size, "Vinewood");
    else if(x >= 200.0 && x <= 900.0 && y >= -1200.0 && y <= -750.0) format(zone, size, "Richman");
    else if(x >= 1000.0 && x <= 1800.0 && y >= -1900.0 && y <= -1400.0) format(zone, size, "Commerce");
    else if(x >= 44.0 && x <= 2997.0 && y >= -2892.0 && y <= -768.0) format(zone, size, "Los Santos");
    else if(x >= -2997.0 && x <= -1213.0 && y >= -1115.0 && y <= 1659.0) format(zone, size, "San Fierro");
    else if(x >= 869.0 && x <= 2997.0 && y >= 596.0 && y <= 2997.0) format(zone, size, "Las Venturas");
    else format(zone, size, "San Andreas");
    return 1;
}

stock ER_GetPlayerZone(playerid, zone[], size)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    // Simple RP-friendly Los Santos zone labels for house/business names and auto-pricing.
    if(x >= 1800.0 && x <= 2250.0 && y >= -1850.0 && y <= -1600.0) format(zone, size, "Idlewood");
    else if(x >= 2200.0 && x <= 2600.0 && y >= -1750.0 && y <= -1500.0) format(zone, size, "Ganton");
    else if(x >= 2400.0 && x <= 2900.0 && y >= -2200.0 && y <= -1700.0) format(zone, size, "Willowfield");
    else if(x >= 550.0 && x <= 1550.0 && y >= -1450.0 && y <= -950.0) format(zone, size, "Vinewood");
    else if(x >= 200.0 && x <= 900.0 && y >= -1200.0 && y <= -750.0) format(zone, size, "Richman");
    else if(x >= 1000.0 && x <= 1800.0 && y >= -1900.0 && y <= -1400.0) format(zone, size, "Commerce");
    else if(x >= 44.0 && x <= 2997.0 && y >= -2892.0 && y <= -768.0) format(zone, size, "Los Santos");
    else if(x >= -2997.0 && x <= -1213.0 && y >= -1115.0 && y <= 1659.0) format(zone, size, "San Fierro");
    else if(x >= 869.0 && x <= 2997.0 && y >= 596.0 && y <= 2997.0) format(zone, size, "Las Venturas");
    else format(zone, size, "San Andreas");
    return 1;
}



stock ER_ClearChat(playerid)
{
    for(new i; i < 30; i++)
    {
        SendClientMessage(playerid, COLOR_WHITE, " ");
    }
    return 1;
}

stock ER_GetNamedColorValue(listitem)
{
    switch(listitem)
    {
        case 0: return 0xFFFFFFFF; // White
        case 1: return 0xAFAFAFFF; // Grey
        case 2: return 0x33CC33FF; // Green
        case 3: return 0x3399FFFF; // Blue
        case 4: return 0xFFCC00FF; // Yellow
        case 5: return 0xFF9900FF; // Orange
        case 6: return 0xFF3333FF; // Red
        case 7: return 0xFF66CCFF; // Pink
        case 8: return 0x9933FFFF; // Purple
        case 9: return 0x00FFFFFF; // Cyan
        case 10: return 0x8B4513FF; // Brown
        case 11: return 0x00AA00FF; // Dark Green
        case 12: return 0x0000AAFF; // Dark Blue
    }
    return 0xFFFFFFFF;
}

stock ER_GetNamedColorName(listitem, dest[], size)
{
    switch(listitem)
    {
        case 0: format(dest, size, "White");
        case 1: format(dest, size, "Grey");
        case 2: format(dest, size, "Green");
        case 3: format(dest, size, "Blue");
        case 4: format(dest, size, "Yellow");
        case 5: format(dest, size, "Orange");
        case 6: format(dest, size, "Red");
        case 7: format(dest, size, "Pink");
        case 8: format(dest, size, "Purple");
        case 9: format(dest, size, "Cyan");
        case 10: format(dest, size, "Brown");
        case 11: format(dest, size, "Dark Green");
        case 12: format(dest, size, "Dark Blue");
        default: format(dest, size, "White");
    }
    return 1;
}


stock ER_GetNamedColorNameByValue(color, dest[], size)
{
    for(new i; i <= 12; i++)
    {
        if(ER_GetNamedColorValue(i) == color) return ER_GetNamedColorName(i, dest, size);
    }
    format(dest, size, "Custom");
    return 1;
}


stock ER_GetNamedColorDisplayByValue(color, dest[], size)
{
    for(new i; i <= 12; i++)
    {
        if(ER_GetNamedColorValue(i) == color)
        {
            new name[24];
            ER_GetNamedColorName(i, name, sizeof(name));
            switch(i)
            {
                case 0: return format(dest, size, "{FFFFFF}%s", name);
                case 1: return format(dest, size, "{AFAFAF}%s", name);
                case 2: return format(dest, size, "{33CC33}%s", name);
                case 3: return format(dest, size, "{3399FF}%s", name);
                case 4: return format(dest, size, "{FFCC00}%s", name);
                case 5: return format(dest, size, "{FF9900}%s", name);
                case 6: return format(dest, size, "{FF3333}%s", name);
                case 7: return format(dest, size, "{FF66CC}%s", name);
                case 8: return format(dest, size, "{9933FF}%s", name);
                case 9: return format(dest, size, "{00FFFF}%s", name);
                case 10: return format(dest, size, "{8B4513}%s", name);
                case 11: return format(dest, size, "{00AA00}%s", name);
                case 12: return format(dest, size, "{0000AA}%s", name);
            }
        }
    }
    return format(dest, size, "{FFFFFF}Custom");
}

stock ER_ShowNamedColorDialog(playerid, dialogid, const title[])
{
    new list[512];
    format(list, sizeof(list),
        "{FFFFFF}White\n{AFAFAF}Grey\n{33CC33}Green\n{3399FF}Blue\n{FFCC00}Yellow\n{FF9900}Orange\n{FF3333}Red\n{FF66CC}Pink\n{9933FF}Purple\n{00FFFF}Cyan\n{8B4513}Brown\n{00AA00}Dark Green\n{0000AA}Dark Blue");
    return ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, title, list, "Select", "Back");
}




forward ER_LoginRegisterTimeout(playerid);
public ER_LoginRegisterTimeout(playerid)
{
    if(IsPlayerConnected(playerid) && !PlayerInfo[playerid][pLoggedIn])
    {
        SendClientMessage(playerid, COLOR_GREY, "Login timed out. Please reconnect and try again.");
        Kick(playerid);
    }
    return 1;
}

stock ER_StartLoginRegisterTimeout(playerid)
{
    if(GetPVarInt(playerid, "LoginTimeoutTimer") > 0)
    {
        KillTimer(GetPVarInt(playerid, "LoginTimeoutTimer"));
    }

    SetPVarInt(playerid, "LoginTimeoutTimer", SetTimerEx("ER_LoginRegisterTimeout", LOGIN_REGISTER_TIMEOUT_SECONDS * 1000, false, "i", playerid));
    return 1;
}

stock ER_StopLoginRegisterTimeout(playerid)
{
    if(GetPVarInt(playerid, "LoginTimeoutTimer") > 0)
    {
        KillTimer(GetPVarInt(playerid, "LoginTimeoutTimer"));
        DeletePVar(playerid, "LoginTimeoutTimer");
    }
    return 1;
}

stock ER_PlayLoginMusic(playerid)
{
    StopAudioStreamForPlayer(playerid);

    if(strlen(ServerCore[scLoginTrack]) > 4)
    {
        PlayAudioStreamForPlayer(playerid, ServerCore[scLoginTrack]);
    }

    SetPVarInt(playerid, "LoginScreenMusic", 1);
    ER_StartLoginRegisterTimeout(playerid);
    return 1;
}

stock ER_PlayRegisterMusic(playerid)
{
    StopAudioStreamForPlayer(playerid);

    if(strlen(ServerCore[scRegisterTrack]) > 4)
    {
        PlayAudioStreamForPlayer(playerid, ServerCore[scRegisterTrack]);
    }

    SetPVarInt(playerid, "LoginScreenMusic", 2);
    ER_StartLoginRegisterTimeout(playerid);
    return 1;
}

stock ER_StopLoginRegisterMusic(playerid)
{
    if(GetPVarInt(playerid, "LoginScreenMusic") > 0)
    {
        StopAudioStreamForPlayer(playerid);
        DeletePVar(playerid, "LoginScreenMusic");
    }

    ER_StopLoginRegisterTimeout(playerid);
    return 1;
}

stock ER_SyncPhysicalMoney(playerid)
{
    if(!IsPlayerConnected(playerid) || !PlayerInfo[playerid][pLoggedIn]) return 0;
    if(GetPlayerMoney(playerid) != PlayerInfo[playerid][pCash])
    {
        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);
    }
    SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
    return 1;
}

stock ER_MinInt(a, b)
{
    return (a < b) ? a : b;
}


stock ER_GetDisplayName(playerid, dest[], size)
{
    GetPlayerName(playerid, dest, size);
    for(new i; dest[i] != EOS; i++) if(dest[i] == '_') dest[i] = ' ';
    return 1;
}

stock ER_FormatName(const src[], dest[], size)
{
    format(dest, size, "%s", src);
    for(new i; dest[i] != EOS; i++) if(dest[i] == '_') dest[i] = ' ';
    return 1;
}

stock ER_AdminLevelName(level)
{
    new name[32];
    switch(level)
    {
        case 0: format(name, sizeof(name), "Player");
        case 1: format(name, sizeof(name), "Moderator");
        case 2: format(name, sizeof(name), "Junior Admin");
        case 4: format(name, sizeof(name), "Senior Admin");
        case 5: format(name, sizeof(name), "Lead Admin");
        case 1337: format(name, sizeof(name), "Head Admin");
        case 99999: format(name, sizeof(name), "Executive Admin");
        default: format(name, sizeof(name), "Admin Level %d", level);
    }
    return name;
}

stock ER_StreamPrep(playerid, Float:x, Float:y, Float:z, vw, interior, const reason[])
{
    TogglePlayerControllable(playerid, 0);
    GameTextForPlayer(playerid, "~w~Loading objects...", 2500, 3);
    Streamer_UpdateEx(playerid, x, y, z, vw, interior);
    SetTimerEx("ER_FinishStreamPrep", 1200, false, "i", playerid);
    #pragma unused reason
    return 1;
}

forward ER_FinishStreamPrep(playerid);
public ER_FinishStreamPrep(playerid)
{
    if(IsPlayerConnected(playerid)) TogglePlayerControllable(playerid, 1);
    return 1;
}

stock ER_ShowUnknownCommand(playerid, const cmd[])
{
    new msg[144];
    GameTextForPlayer(playerid, "~r~Unknown Command", 2500, 3);
    format(msg, sizeof(msg), "SERVER: Unknown command /%s. Use /help to view available commands.", cmd);
    SendClientMessage(playerid, COLOR_GREY, msg);
    return 1;
}

stock ER_GetWeaponNameEx(weaponid)
{
    new name[32];
    GetWeaponName(weaponid, name, sizeof(name));
    if(!name[0]) format(name, sizeof(name), "Weapon %d", weaponid);
    return name;
}

stock intstr(value)
{
    new out[16];
    format(out, sizeof(out), "%d", value);
    return out;
}

stock ER_IsPlayerNearPlayer(playerid, targetid, Float:range)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerConnected(targetid)) return 0;
    if(GetPlayerVirtualWorld(playerid) != GetPlayerVirtualWorld(targetid)) return 0;
    if(GetPlayerInterior(playerid) != GetPlayerInterior(targetid)) return 0;
    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
    return IsPlayerInRangeOfPoint(playerid, range, x, y, z);
}
