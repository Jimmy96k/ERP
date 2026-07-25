#if defined _ER_ACCOUNTS_INCLUDED
    #endinput
#endif
#define _ER_ACCOUNTS_INCLUDED

stock ER_ShowLoginOrRegister(playerid)
{
    new q[160];
    mysql_format(MainPipeline, q, sizeof(q), "SELECT `id`,`password` FROM `accounts` WHERE `username`='%e' LIMIT 1", ER_GetName(playerid));
    mysql_tquery(MainPipeline, q, "ER_OnAccountCheck", "i", playerid);
    return 1;
}

forward ER_OnAccountCheck(playerid);
public ER_OnAccountCheck(playerid)
{
    new rows;
    cache_get_row_count(rows);
    if(!IsPlayerConnected(playerid)) return 1;
    if(rows)
    {
        PlayerInfo[playerid][pRegistered] = 1;
        cache_get_value_name_int(0, "id", PlayerInfo[playerid][pID]);
        cache_get_value_name(0, "password", PlayerInfo[playerid][pPassword], 129);
        new title[64], body[256];
        format(title, sizeof(title), "{3399FF}Login - %s", ER_GetName(playerid));
        format(body, sizeof(body), "{FFFFFF}Welcome to Express Roleplay - Gaming, %s.\n\nThe name that you are using is registered, please enter a password to login:", ER_GetName(playerid));
        ER_PlayLoginMusic(playerid);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, title, body, "Login", "Exit");
    }
    else
    {
        PlayerInfo[playerid][pRegistered] = 0;
        new title[64], body[512];
        format(title, sizeof(title), "{3399FF}Register - %s", ER_GetName(playerid));
        format(body, sizeof(body), "{FFFFFF}Welcome to Express Roleplay - Gaming, %s.\n\nThe name that you are using is not registered.\n\nPlease enter a password to create your account.\n\n{F69500}Your password should contain letters/numbers and be at least 4 characters.", ER_GetName(playerid));
        ER_PlayRegisterMusic(playerid);
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, title, body, "Register", "Exit");
    }
    return 1;
}

stock ER_AccountDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    #pragma unused listitem
    if(dialogid == DIALOG_LOGIN)
    {
        if(!response) return Kick(playerid);
        new hash[129];
        WP_Hash(hash, sizeof(hash), inputtext);
        if(strcmp(hash, PlayerInfo[playerid][pPassword], false))
        {
            new title[64], body[256];
            format(title, sizeof(title), "{3399FF}Login - %s", ER_GetName(playerid));
            format(body, sizeof(body), "{FFFFFF}Invalid Password!\n\nWelcome to Express Roleplay - Gaming, %s.\n\nPlease enter your password to login:", ER_GetName(playerid));
            if(GetPVarInt(playerid, "LoginScreenMusic") != 1) ER_PlayLoginMusic(playerid);
            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, title, body, "Login", "Exit");
            return 1;
        }
        ER_LoadCharacter(playerid);
        return 1;
    }
    if(dialogid == DIALOG_REGISTER)
    {
        if(!response) return Kick(playerid);
        if(strlen(inputtext) < 4) {
            new title[64], body[256];
            format(title, sizeof(title), "{3399FF}Register - %s", ER_GetName(playerid));
            format(body, sizeof(body), "{FFFFFF}Your password is too short.\n\nPlease enter at least 4 characters.");
            if(GetPVarInt(playerid, "LoginScreenMusic") != 2) ER_PlayRegisterMusic(playerid);
            return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, title, body, "Register", "Exit");
        }
        new hash[129], q[2048];
        WP_Hash(hash, sizeof(hash), inputtext);
        ER_ApplyDefaultPlayerInfo(playerid);
        format(PlayerInfo[playerid][pPassword], 129, "%s", hash);
        mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `accounts` (`username`,`password`,`tutorial`,`level`,`age`,`dob`,`country`,`gender`,`accent`,`skin`,`cash`,`bank`,`phone`,`hosp_insurance`,`family_id`,`faction_id`,`family_rank`,`family_crew`,`faction_rank`,`faction_division`,`max_vehicles`,`max_houses`,`max_businesses`,`max_toys`,`has_mp3`,`spawn_x`,`spawn_y`,`spawn_z`,`spawn_a`,`spawn_int`,`spawn_vw`,`health`,`armor`) VALUES ('%e','%e',0,1,%d,'%e','%e',%d,%d,%d,%d,%d,%d,%d,0,0,0,0,0,0,0,0,0,0,0,%f,%f,%f,%f,%d,%d,100.0,0.0)", ER_GetName(playerid), hash, PlayerInfo[playerid][pAge], PlayerInfo[playerid][pDOB], PlayerInfo[playerid][pCountry], PlayerInfo[playerid][pGender], PlayerInfo[playerid][pAccent], PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pCash], PlayerInfo[playerid][pBank], PlayerInfo[playerid][pPhone], NO_HOSPITAL_INSURANCE, PlayerInfo[playerid][pSpawnX], PlayerInfo[playerid][pSpawnY], PlayerInfo[playerid][pSpawnZ], PlayerInfo[playerid][pSpawnA], PlayerInfo[playerid][pSpawnInt], PlayerInfo[playerid][pSpawnVW]);
        mysql_tquery(MainPipeline, q, "ER_OnAccountRegister", "i", playerid);
        return 1;
    }
    return 0;
}

forward ER_OnAccountRegister(playerid);
public ER_OnAccountRegister(playerid)
{
    PlayerInfo[playerid][pID] = cache_insert_id();
    PlayerInfo[playerid][pRegistered] = 1;
    PlayerInfo[playerid][pLoggedIn] = 1;
    ER_StopLoginRegisterMusic(playerid);
    ER_Send(playerid, COLOR_GREEN, "Account created successfully. Welcome to Express Roleplay - Gaming.");
    ER_StartTutorial(playerid);
    return 1;
}


