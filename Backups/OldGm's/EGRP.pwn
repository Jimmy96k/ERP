#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include <streamer>
#include <zcmd>

//

#pragma warning disable 239

#define COLOR_RED          0xE74C3CFF
#define COLOR_GREEN        0x2ECC71FF
#define COLOR_YELLOW       0xF1C40FFF
#define COLOR_BLUE         0x5DADE2FF
#define COLOR_WHITE        0xFFFFFFFF

#define DIALOG_LOGIN       1
#define DIALOG_REGISTER    2
#define DIALOG_GENDER      3
#define DIALOG_BIRTHDATE   4
#define DIALOG_STATS       9999

new MySQL:g_SQL;

enum E_PLAYER
{
    pID,
    pName[MAX_PLAYER_NAME],
    pPassword[129],

    pLoggedIn,
    pAdmin,

    pGender,
    pBirthDate[32],

    pSkin,
    pCash,
    pBank,

    Float:pX,
    Float:pY,
    Float:pZ,
    Float:pA,

    pVW,
    pInterior
}
new PlayerInfo[MAX_PLAYERS][E_PLAYER];



// Script Includes
#include <EGRP/Commands.pwn>



main()
{
    print("EGRP Roleplay started.");
}

public OnGameModeInit()
{
    SetGameModeText("EGRP v0.1");
    ConnectDatabase();

    AddPlayerClass(299, 1958.3783, 1343.1572, 15.3746, 270.0, 0, 0, 0, 0, 0, 0);
    return 1;
}

public OnGameModeExit()
{
    if(g_SQL != MYSQL_INVALID_HANDLE)
        mysql_close(g_SQL);

    return 1;
}

stock ConnectDatabase()
{
    new host[64], user[32], pass[64], db[32], port[8];
    new File:file = fopen("mysql.cfg", io_read);

    if(!file)
    {
        print("[MySQL] ERROR: scriptfiles/mysql.cfg not found.");
        return 0;
    }

    fread(file, host);
    fread(file, user);
    fread(file, pass);
    fread(file, db);
    fread(file, port);
    fclose(file);

    StripNewLine(host);
    StripNewLine(user);
    StripNewLine(pass);
    StripNewLine(db);
    StripNewLine(port);

    new MySQLOpt:option_id = mysql_init_options();
    mysql_set_option(option_id, AUTO_RECONNECT, true);

    g_SQL = mysql_connect(host, user, pass, db, option_id);

    if(mysql_errno(g_SQL) != 0)
    {
        printf("[MySQL] Connection failed. Error ID: %d", mysql_errno(g_SQL));
        return 0;
    }

    print("[MySQL] Connected successfully.");

    mysql_tquery(g_SQL,
        "CREATE TABLE IF NOT EXISTS accounts (\
        id INT AUTO_INCREMENT PRIMARY KEY,\
        username VARCHAR(24) NOT NULL UNIQUE,\
        password VARCHAR(129) NOT NULL,\
        admin INT DEFAULT 0,\
        gender INT DEFAULT 1,\
        birthdate VARCHAR(32) DEFAULT '01/01/2000',\
        skin INT DEFAULT 299,\
        cash INT DEFAULT 5000,\
        bank INT DEFAULT 10000,\
        pos_x FLOAT DEFAULT 1958.3783,\
        pos_y FLOAT DEFAULT 1343.1572,\
        pos_z FLOAT DEFAULT 15.3746,\
        pos_a FLOAT DEFAULT 270.0,\
        vw INT DEFAULT 0,\
        interior INT DEFAULT 0,\
        regdate TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");

    return 1;
}

stock StripNewLine(string[])
{
    for(new i = 0; string[i] != EOS; i++)
    {
        if(string[i] == '\n' || string[i] == '\r')
        {
            string[i] = EOS;
            break;
        }
    }
    return 1;
}

stock ResetPlayerData(playerid)
{
    PlayerInfo[playerid][pID] = 0;
    PlayerInfo[playerid][pLoggedIn] = 0;
    PlayerInfo[playerid][pAdmin] = 0;

    PlayerInfo[playerid][pGender] = 1;
    format(PlayerInfo[playerid][pBirthDate], 32, "01/01/2000");

    PlayerInfo[playerid][pSkin] = 299;
    PlayerInfo[playerid][pCash] = 5000;
    PlayerInfo[playerid][pBank] = 10000;

    PlayerInfo[playerid][pX] = 1958.3783;
    PlayerInfo[playerid][pY] = 1343.1572;
    PlayerInfo[playerid][pZ] = 15.3746;
    PlayerInfo[playerid][pA] = 270.0;

    PlayerInfo[playerid][pVW] = 0;
    PlayerInfo[playerid][pInterior] = 0;
    return 1;
}

public OnPlayerConnect(playerid)
{
    GetPlayerName(playerid, PlayerInfo[playerid][pName], MAX_PLAYER_NAME);
    ResetPlayerData(playerid);

    new query[256];
    mysql_format(g_SQL, query, sizeof(query),
        "SELECT * FROM accounts WHERE username='%e' LIMIT 1",
        PlayerInfo[playerid][pName]);

    mysql_tquery(g_SQL, query, "OnAccountCheck", "i", playerid);
    return 1;
}

forward OnAccountCheck(playerid);
public OnAccountCheck(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    if(cache_num_rows())
    {
        cache_get_value_name_int(0, "id", PlayerInfo[playerid][pID]);
        cache_get_value_name(0, "password", PlayerInfo[playerid][pPassword], 129);

        cache_get_value_name_int(0, "admin", PlayerInfo[playerid][pAdmin]);
        cache_get_value_name_int(0, "gender", PlayerInfo[playerid][pGender]);
        cache_get_value_name(0, "birthdate", PlayerInfo[playerid][pBirthDate], 32);

        cache_get_value_name_int(0, "skin", PlayerInfo[playerid][pSkin]);
        cache_get_value_name_int(0, "cash", PlayerInfo[playerid][pCash]);
        cache_get_value_name_int(0, "bank", PlayerInfo[playerid][pBank]);

        cache_get_value_name_float(0, "pos_x", PlayerInfo[playerid][pX]);
        cache_get_value_name_float(0, "pos_y", PlayerInfo[playerid][pY]);
        cache_get_value_name_float(0, "pos_z", PlayerInfo[playerid][pZ]);
        cache_get_value_name_float(0, "pos_a", PlayerInfo[playerid][pA]);

        cache_get_value_name_int(0, "vw", PlayerInfo[playerid][pVW]);
        cache_get_value_name_int(0, "interior", PlayerInfo[playerid][pInterior]);

        new dialog[256];
        format(dialog, sizeof(dialog),
            "{FFFFFF}Welcome {5DADE2}%s{FFFFFF}.\n\nPlease login using your password.",
            PlayerInfo[playerid][pName]);

        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
            "{2ECC71}EGRP Login",
            dialog,
            "Login",
            "Quit");
    }
    else
    {
        new dialog[256];
        format(dialog, sizeof(dialog),
            "{FFFFFF}Welcome {5DADE2}%s{FFFFFF}.\n\nPlease register using a new password.",
            PlayerInfo[playerid][pName]);

        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,
            "{F1C40F}EGRP Register",
            dialog,
            "Continue",
            "Quit");
    }

    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(!response)
        return Kick(playerid);

    switch(dialogid)
    {
        case DIALOG_LOGIN:
        {
            if(strcmp(inputtext, PlayerInfo[playerid][pPassword], false))
            {
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD,
                    "{E74C3C}Wrong Password",
                    "{FFFFFF}Incorrect password.\nPlease try again.",
                    "Login",
                    "Quit");
                return 1;
            }

            PlayerInfo[playerid][pLoggedIn] = 1;
            SendClientMessage(playerid, COLOR_GREEN, "Successfully logged in.");
            SpawnPlayer(playerid);
        }

        case DIALOG_REGISTER:
        {
            if(strlen(inputtext) < 4)
            {
                new dialog[256];
                format(dialog, sizeof(dialog),
                    "{FFFFFF}Welcome {5DADE2}%s{FFFFFF}.\n\n{E74C3C}Password must be at least 4 characters.",
                    PlayerInfo[playerid][pName]);

                ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD,
                    "{E74C3C}Invalid Password",
                    dialog,
                    "Continue",
                    "Quit");
                return 1;
            }

            format(PlayerInfo[playerid][pPassword], 129, "%s", inputtext);

            ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST,
                "{F1C40F}Character Gender",
                "{5DADE2}Male\n{E91E63}Female",
                "Select",
                "Quit");
        }

        case DIALOG_GENDER:
        {
            PlayerInfo[playerid][pGender] = listitem + 1;

            ShowPlayerDialog(playerid, DIALOG_BIRTHDATE, DIALOG_STYLE_INPUT,
                "{5DADE2}Date of Birth",
                "{FFFFFF}Enter your character date of birth.\n\n{F1C40F}Example: {FFFFFF}15/08/2000",
                "Finish",
                "Quit");
        }

        case DIALOG_BIRTHDATE:
        {
            if(strlen(inputtext) < 8)
            {
                ShowPlayerDialog(playerid, DIALOG_BIRTHDATE, DIALOG_STYLE_INPUT,
                    "{E74C3C}Invalid Date of Birth",
                    "{FFFFFF}Enter your character date of birth.\n\n{F1C40F}Example: {FFFFFF}15/08/2000",
                    "Finish",
                    "Quit");
                return 1;
            }

            format(PlayerInfo[playerid][pBirthDate], 32, "%s", inputtext);

            new query[1024];
            mysql_format(g_SQL, query, sizeof(query),
                "INSERT INTO accounts \
                (username,password,admin,gender,birthdate,skin,cash,bank,pos_x,pos_y,pos_z,pos_a,vw,interior) \
                VALUES ('%e','%e',0,%d,'%e',%d,%d,%d,%f,%f,%f,%f,%d,%d)",
                PlayerInfo[playerid][pName],
                PlayerInfo[playerid][pPassword],
                PlayerInfo[playerid][pGender],
                PlayerInfo[playerid][pBirthDate],
                PlayerInfo[playerid][pSkin],
                PlayerInfo[playerid][pCash],
                PlayerInfo[playerid][pBank],
                PlayerInfo[playerid][pX],
                PlayerInfo[playerid][pY],
                PlayerInfo[playerid][pZ],
                PlayerInfo[playerid][pA],
                PlayerInfo[playerid][pVW],
                PlayerInfo[playerid][pInterior]);

            mysql_tquery(g_SQL, query, "OnAccountRegister", "i", playerid);
        }
    }

    return 1;
}

forward OnAccountRegister(playerid);
public OnAccountRegister(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    PlayerInfo[playerid][pID] = cache_insert_id();
    PlayerInfo[playerid][pLoggedIn] = 1;

    SendClientMessage(playerid, COLOR_GREEN, "Account registered successfully.");
    SpawnPlayer(playerid);
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
    SetPlayerCameraPos(playerid, 1958.3783, 1348.1572, 17.3746);
    SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(!PlayerInfo[playerid][pLoggedIn])
        return 1;

    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);

    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVW]);
    SetPlayerInterior(playerid, PlayerInfo[playerid][pInterior]);

    SetPlayerPos(playerid, PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ]);
    SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pA]);
    SetCameraBehindPlayer(playerid);

    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);
    return 1;
}

stock SavePlayer(playerid)
{
    if(!PlayerInfo[playerid][pLoggedIn])
        return 1;

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    PlayerInfo[playerid][pCash] = GetPlayerMoney(playerid);
    PlayerInfo[playerid][pSkin] = GetPlayerSkin(playerid);
    PlayerInfo[playerid][pVW] = GetPlayerVirtualWorld(playerid);
    PlayerInfo[playerid][pInterior] = GetPlayerInterior(playerid);

    new query[1024];
    mysql_format(g_SQL, query, sizeof(query),
        "UPDATE accounts SET \
        admin=%d,\
        gender=%d,\
        birthdate='%e',\
        skin=%d,\
        cash=%d,\
        bank=%d,\
        pos_x=%f,\
        pos_y=%f,\
        pos_z=%f,\
        pos_a=%f,\
        vw=%d,\
        interior=%d \
        WHERE id=%d",
        PlayerInfo[playerid][pAdmin],
        PlayerInfo[playerid][pGender],
        PlayerInfo[playerid][pBirthDate],
        PlayerInfo[playerid][pSkin],
        PlayerInfo[playerid][pCash],
        PlayerInfo[playerid][pBank],
        x, y, z, a,
        PlayerInfo[playerid][pVW],
        PlayerInfo[playerid][pInterior],
        PlayerInfo[playerid][pID]);

    mysql_tquery(g_SQL, query);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SavePlayer(playerid);
    return 1;
}

