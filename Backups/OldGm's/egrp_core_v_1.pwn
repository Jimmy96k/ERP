#include <a_samp>

// =====================================================
// EGRP CORE V2 - NORMAL SA-MP, NO ZCMD, NO YSI
// Systems included:
// Login/Register + tutorial
// Colored /help dialogs
// RP chat: local, /b, /s, /g, /newb, /pr, /accent
// Admin basics
// Jobs foundation + /getmats delivery for Arms Dealer/Craftsman
// Dynamic Dealership Business System
// Dynamic Houses foundation
// Business foundation: 24/7, clothes, gunshop style
// =====================================================

#define SERVER_NAME "EGRP Roleplay"
#define ACC_PATH "Accounts/%s.txt"
#define DP_PATH "Dealerships/%d.txt"
#define DV_PATH "DealerVehicles/%d.txt"
#define HOUSE_PATH "Houses/%d.txt"

#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_GREY 0xAFAFAFFF
#define COLOR_RED 0xFF0000FF
#define COLOR_GREEN 0x33FF33FF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_BLUE 0x3399FFFF
#define COLOR_PURPLE 0xC2A2DAFF
#define COLOR_ORANGE 0xFF9900FF
#define COLOR_LIGHTBLUE 0x00C3FFFF

#define DIALOG_REGISTER      1000
#define DIALOG_LOGIN         1001
#define DIALOG_TUTORIAL_1    1002
#define DIALOG_TUTORIAL_2    1003
#define DIALOG_TUTORIAL_3    1004

#define DIALOG_HELP_MAIN     1100
#define DIALOG_HELP_GENERAL  1101
#define DIALOG_HELP_JOB      1102
#define DIALOG_HELP_OTHER    1103
#define DIALOG_HELP_ADMIN    1104
#define DIALOG_STATS         1200

#define DIALOG_BUY_DEALER_CAR 5001

#define MAX_DEALERSHIPS 50
#define MAX_DVEHICLES 500
#define MAX_PLAYER_CARS 10
#define MAX_PVEHICLES 1000
#define MAX_HOUSES 500
#define MAX_BUSINESSES 200

#define DP_BASE_MAX_CARS 5
#define DP_UPGRADE_PRICE 250000
#define DEALERSHIP_NONE "None"

#define ADMIN_NONE      0
#define ADMIN_JR        1
#define ADMIN_GEN       2
#define ADMIN_SENIOR    3
#define ADMIN_HEAD      4
#define ADMIN_OWNER     5

#define JOB_NONE        0
#define JOB_TRUCKER     1
#define JOB_MECHANIC    2
#define JOB_TAXI        3
#define JOB_ARMSDEALER  4
#define JOB_CRAFTSMAN   5
#define JOB_GARBAGEMAN  6
#define JOB_LAWYER      7
#define JOB_FARMER      8
#define JOB_MINER       9
#define JOB_DRUGDEALER  10

#define MAT_PICKUP_X 2172.0000
#define MAT_PICKUP_Y -2265.0000
#define MAT_PICKUP_Z 13.3000
#define MAT_DROP_X   1365.0000
#define MAT_DROP_Y   -1275.0000
#define MAT_DROP_Z   13.5000

enum pInfo
{
    pPassword,
    bool:pLogged,
    bool:pNewbie,
    pCash,
    pBank,
    pLevel,
    pRespect,
    pPlayingHours,
    pAdmin,
    pHelper,
    pGender,
    pAge,
    pSkin,
    pAccent[32],
    pFaction,
    pFactionRank,
    pFamily,
    pFamilyRank,
    pJob,
    pSecondJob,
    pMaterials,
    pMatPackages,
    bool:pOnMatRun,
    pRadio,
    pPhone,
    pWanted,
    pWarns,
    Float:pPosX,
    Float:pPosY,
    Float:pPosZ,
    Float:pPosA,
    pVW,
    pInt
}
new PlayerInfo[MAX_PLAYERS][pInfo];

enum dInfo
{
    bool:dExists,
    dName[64],
    dOwner[MAX_PLAYER_NAME],
    dPrice,
    dSafe,
    dStock,
    dLevel,
    dMaxCars,
    Float:dX,
    Float:dY,
    Float:dZ,
    Text3D:dLabel,
    dPickup
}
new DealershipInfo[MAX_DEALERSHIPS][dInfo];

enum dvInfo
{
    bool:dvExists,
    dvDealerID,
    dvModel,
    dvPrice,
    Float:dvX,
    Float:dvY,
    Float:dvZ,
    Float:dvA,
    dvVehID,
    Text3D:dvLabel
}
new DealerVehInfo[MAX_DVEHICLES][dvInfo];
new PlayerSelectedDealerVeh[MAX_PLAYERS];
new DealershipSellID[MAX_PLAYERS];
new DealershipSellPrice[MAX_PLAYERS];
new DealershipSellSeller[MAX_PLAYERS];

enum hInfo
{
    bool:hExists,
    hOwner[MAX_PLAYER_NAME],
    hPrice,
    hLevel,
    hLocked,
    Float:hX,
    Float:hY,
    Float:hZ,
    Text3D:hLabel,
    hPickup
}
new HouseInfo[MAX_HOUSES][hInfo];

main()
{
    print("----------------------------------");
    print(" EGRP Core V2 Loaded");
    print("----------------------------------");
}

stock GetAccountPath(playerid, path[], size = 128)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    format(path, size, ACC_PATH, name);
    return 1;
}

stock HashPassword(const str[])
{
    new h = 5381;
    for(new i = 0; str[i] != EOS; i++) h = ((h << 5) + h) + str[i];
    return h;
}

stock GetFileValue(const line[])
{
    new pos = strfind(line, "=");
    if(pos == -1) return 0;
    new value[64];
    strmid(value, line, pos + 1, strlen(line), sizeof(value));
    return strval(value);
}

stock Float:GetFileFloat(const line[])
{
    new pos = strfind(line, "=");
    if(pos == -1) return 0.0;
    new value[64];
    strmid(value, line, pos + 1, strlen(line), sizeof(value));
    return floatstr(value);
}

stock GetFileString(const line[], output[], size)
{
    new pos = strfind(line, "=");
    if(pos == -1) return 0;
    strmid(output, line, pos + 1, strlen(line), size);
    for(new i = 0; output[i] != EOS; i++)
    {
        if(output[i] == '\n' || output[i] == '\r')
        {
            output[i] = EOS;
            break;
        }
    }
    return 1;
}

stock ParseWord(const str[], start, word[], size)
{
    new i;
    while(str[start] == ' ') start++;
    while(str[start] != EOS && str[start] != ' ' && i < size - 1)
    {
        word[i++] = str[start++];
    }
    word[i] = EOS;
    return start;
}

stock ParseRest(const str[], start, output[], size)
{
    new i;
    while(str[start] == ' ') start++;
    while(str[start] != EOS && i < size - 1)
    {
        output[i++] = str[start++];
    }
    output[i] = EOS;
    return 1;
}

stock SendLocalMessage(playerid, Float:range, color, const message[])
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && GetPlayerVirtualWorld(i) == GetPlayerVirtualWorld(playerid) && IsPlayerInRangeOfPoint(i, range, x, y, z))
        {
            SendClientMessage(i, color, message);
        }
    }
    return 1;
}

stock IsAdmin(playerid, level)
{
    return PlayerInfo[playerid][pAdmin] >= level || IsPlayerAdmin(playerid);
}

stock GetJobName(jobid, name[], size = 32)
{
    switch(jobid)
    {
        case JOB_TRUCKER: format(name, size, "Trucker");
        case JOB_MECHANIC: format(name, size, "Mechanic");
        case JOB_TAXI: format(name, size, "Taxi Driver");
        case JOB_ARMSDEALER: format(name, size, "Arms Dealer");
        case JOB_CRAFTSMAN: format(name, size, "Craftsman");
        case JOB_GARBAGEMAN: format(name, size, "Garbage Man");
        case JOB_LAWYER: format(name, size, "Lawyer");
        case JOB_FARMER: format(name, size, "Farmer");
        case JOB_MINER: format(name, size, "Miner");
        case JOB_DRUGDEALER: format(name, size, "Drug Dealer");
        default: format(name, size, "None");
    }
    return 1;
}

stock GetVehicleNameEx(modelid, name[], size = 32)
{
    switch(modelid)
    {
        case 560: format(name, size, "Sultan");
        case 562: format(name, size, "Elegy");
        case 559: format(name, size, "Jester");
        case 565: format(name, size, "Flash");
        case 411: format(name, size, "Infernus");
        case 415: format(name, size, "Cheetah");
        case 451: format(name, size, "Turismo");
        case 522: format(name, size, "NRG-500");
        case 541: format(name, size, "Bullet");
        case 506: format(name, size, "Super GT");
        case 402: format(name, size, "Buffalo");
        case 579: format(name, size, "Huntley");
        default: format(name, size, "Vehicle");
    }
    return 1;
}

stock GetVehicleModelByNameOrID(const input[])
{
    new modelid = strval(input);
    if(modelid >= 400 && modelid <= 611) return modelid;
    if(strcmp(input, "sultan", true) == 0) return 560;
    if(strcmp(input, "elegy", true) == 0) return 562;
    if(strcmp(input, "jester", true) == 0) return 559;
    if(strcmp(input, "flash", true) == 0) return 565;
    if(strcmp(input, "infernus", true) == 0) return 411;
    if(strcmp(input, "cheetah", true) == 0) return 415;
    if(strcmp(input, "turismo", true) == 0) return 451;
    if(strcmp(input, "nrg", true) == 0) return 522;
    if(strcmp(input, "bullet", true) == 0) return 541;
    if(strcmp(input, "supergt", true) == 0) return 506;
    if(strcmp(input, "buffalo", true) == 0) return 402;
    if(strcmp(input, "huntley", true) == 0) return 579;
    return 0;
}

stock SetDefaultPlayer(playerid)
{
    ResetPlayerMoney(playerid);
    PlayerInfo[playerid][pCash] = 5000;
    PlayerInfo[playerid][pBank] = 0;
    PlayerInfo[playerid][pLevel] = 1;
    PlayerInfo[playerid][pRespect] = 0;
    PlayerInfo[playerid][pPlayingHours] = 0;
    PlayerInfo[playerid][pAdmin] = 0;
    PlayerInfo[playerid][pHelper] = 0;
    PlayerInfo[playerid][pGender] = 0;
    PlayerInfo[playerid][pAge] = 18;
    PlayerInfo[playerid][pSkin] = 26;
    format(PlayerInfo[playerid][pAccent], 32, "None");
    PlayerInfo[playerid][pFaction] = 0;
    PlayerInfo[playerid][pFactionRank] = 0;
    PlayerInfo[playerid][pFamily] = 0;
    PlayerInfo[playerid][pFamilyRank] = 0;
    PlayerInfo[playerid][pJob] = JOB_NONE;
    PlayerInfo[playerid][pSecondJob] = JOB_NONE;
    PlayerInfo[playerid][pMaterials] = 0;
    PlayerInfo[playerid][pMatPackages] = 0;
    PlayerInfo[playerid][pOnMatRun] = false;
    PlayerInfo[playerid][pRadio] = 0;
    PlayerInfo[playerid][pPhone] = 0;
    PlayerInfo[playerid][pWanted] = 0;
    PlayerInfo[playerid][pWarns] = 0;
    PlayerInfo[playerid][pPosX] = 1642.1833;
    PlayerInfo[playerid][pPosY] = -2334.1958;
    PlayerInfo[playerid][pPosZ] = 13.5469;
    PlayerInfo[playerid][pPosA] = 0.0;
    PlayerInfo[playerid][pVW] = 0;
    PlayerInfo[playerid][pInt] = 0;
    GivePlayerMoney(playerid, 5000);
    SetPlayerScore(playerid, 1);
    SetPlayerSkin(playerid, 26);
    return 1;
}

stock SaveAccount(playerid)
{
    new path[128], line[160], File:f;
    GetAccountPath(playerid, path);
    GetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
    GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPosA]);
    PlayerInfo[playerid][pCash] = GetPlayerMoney(playerid);
    PlayerInfo[playerid][pLevel] = GetPlayerScore(playerid);
    PlayerInfo[playerid][pVW] = GetPlayerVirtualWorld(playerid);
    PlayerInfo[playerid][pInt] = GetPlayerInterior(playerid);
    f = fopen(path, io_write);
    if(!f) return 0;
    format(line, sizeof(line), "pPassword=%d\n", PlayerInfo[playerid][pPassword]); fwrite(f, line);
    format(line, sizeof(line), "pNewbie=%d\n", PlayerInfo[playerid][pNewbie]); fwrite(f, line);
    format(line, sizeof(line), "pCash=%d\n", PlayerInfo[playerid][pCash]); fwrite(f, line);
    format(line, sizeof(line), "pBank=%d\n", PlayerInfo[playerid][pBank]); fwrite(f, line);
    format(line, sizeof(line), "pLevel=%d\n", PlayerInfo[playerid][pLevel]); fwrite(f, line);
    format(line, sizeof(line), "pAdmin=%d\n", PlayerInfo[playerid][pAdmin]); fwrite(f, line);
    format(line, sizeof(line), "pSkin=%d\n", PlayerInfo[playerid][pSkin]); fwrite(f, line);
    format(line, sizeof(line), "pAccent=%s\n", PlayerInfo[playerid][pAccent]); fwrite(f, line);
    format(line, sizeof(line), "pJob=%d\n", PlayerInfo[playerid][pJob]); fwrite(f, line);
    format(line, sizeof(line), "pMaterials=%d\n", PlayerInfo[playerid][pMaterials]); fwrite(f, line);
    format(line, sizeof(line), "pRadio=%d\n", PlayerInfo[playerid][pRadio]); fwrite(f, line);
    format(line, sizeof(line), "pPosX=%f\n", PlayerInfo[playerid][pPosX]); fwrite(f, line);
    format(line, sizeof(line), "pPosY=%f\n", PlayerInfo[playerid][pPosY]); fwrite(f, line);
    format(line, sizeof(line), "pPosZ=%f\n", PlayerInfo[playerid][pPosZ]); fwrite(f, line);
    format(line, sizeof(line), "pPosA=%f\n", PlayerInfo[playerid][pPosA]); fwrite(f, line);
    format(line, sizeof(line), "pVW=%d\n", PlayerInfo[playerid][pVW]); fwrite(f, line);
    format(line, sizeof(line), "pInt=%d\n", PlayerInfo[playerid][pInt]); fwrite(f, line);
    fclose(f);
    return 1;
}

stock LoadAccount(playerid)
{
    new path[128], line[160], File:f;
    GetAccountPath(playerid, path);
    f = fopen(path, io_read);
    if(!f) return 0;
    SetDefaultPlayer(playerid);
    while(fread(f, line))
    {
        if(strfind(line, "pPassword=") == 0) PlayerInfo[playerid][pPassword] = GetFileValue(line);
        else if(strfind(line, "pNewbie=") == 0) PlayerInfo[playerid][pNewbie] = bool:GetFileValue(line);
        else if(strfind(line, "pCash=") == 0) PlayerInfo[playerid][pCash] = GetFileValue(line);
        else if(strfind(line, "pBank=") == 0) PlayerInfo[playerid][pBank] = GetFileValue(line);
        else if(strfind(line, "pLevel=") == 0) PlayerInfo[playerid][pLevel] = GetFileValue(line);
        else if(strfind(line, "pAdmin=") == 0) PlayerInfo[playerid][pAdmin] = GetFileValue(line);
        else if(strfind(line, "pSkin=") == 0) PlayerInfo[playerid][pSkin] = GetFileValue(line);
        else if(strfind(line, "pAccent=") == 0) GetFileString(line, PlayerInfo[playerid][pAccent], 32);
        else if(strfind(line, "pJob=") == 0) PlayerInfo[playerid][pJob] = GetFileValue(line);
        else if(strfind(line, "pMaterials=") == 0) PlayerInfo[playerid][pMaterials] = GetFileValue(line);
        else if(strfind(line, "pRadio=") == 0) PlayerInfo[playerid][pRadio] = GetFileValue(line);
        else if(strfind(line, "pPosX=") == 0) PlayerInfo[playerid][pPosX] = GetFileFloat(line);
        else if(strfind(line, "pPosY=") == 0) PlayerInfo[playerid][pPosY] = GetFileFloat(line);
        else if(strfind(line, "pPosZ=") == 0) PlayerInfo[playerid][pPosZ] = GetFileFloat(line);
        else if(strfind(line, "pPosA=") == 0) PlayerInfo[playerid][pPosA] = GetFileFloat(line);
        else if(strfind(line, "pVW=") == 0) PlayerInfo[playerid][pVW] = GetFileValue(line);
        else if(strfind(line, "pInt=") == 0) PlayerInfo[playerid][pInt] = GetFileValue(line);
    }
    fclose(f);
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, PlayerInfo[playerid][pCash]);
    SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]);
    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    PlayerInfo[playerid][pLogged] = true;
    return 1;
}

stock ShowHelpMain(playerid)
{
    new str[256];
    strcat(str, "{FFFFFF}General Help\n");
    strcat(str, "{FFFF00}Job Help\n");
    strcat(str, "{33CCFF}Others Help\n");
    if(PlayerInfo[playerid][pAdmin] > 0 || IsPlayerAdmin(playerid)) strcat(str, "{FF9900}Admin Help\n");
    ShowPlayerDialog(playerid, DIALOG_HELP_MAIN, DIALOG_STYLE_LIST, "{33FF33}EGRP Help Menu", str, "Select", "Close");
    return 1;
}

stock ShowHelpGeneral(playerid)
{
    new str[700];
    strcat(str, "{33FF33}General Help:\n\n");
    strcat(str, "{FFFFFF}/stats /help /cmds /accent\n");
    strcat(str, "{FFFFFF}/b /shout /s /g /newb /pr\n");
    strcat(str, "{FFFFFF}/families /gangs /points /turfs\n");
    ShowPlayerDialog(playerid, DIALOG_HELP_GENERAL, DIALOG_STYLE_MSGBOX, "{33FF33}General Help", str, "Back", "Close");
    return 1;
}

stock ShowHelpJob(playerid)
{
    new str[700];
    strcat(str, "{FFFF00}Job Help:\n\n");
    strcat(str, "{FFFFFF}/jobs /getjob /quitjob /work\n");
    strcat(str, "{FFFFFF}/materials /getmats /makegun\n");
    strcat(str, "{AAAAAA}Arms Dealer/Craftsman: /getmats starts a package run.\n");
    ShowPlayerDialog(playerid, DIALOG_HELP_JOB, DIALOG_STYLE_MSGBOX, "{FFFF00}Job Help", str, "Back", "Close");
    return 1;
}

stock ShowHelpOther(playerid)
{
    new str[900];
    strcat(str, "{33CCFF}Others Help:\n\n");
    strcat(str, "{FFFFFF}/dealerships /buydealership /mydealership\n");
    strcat(str, "{FFFFFF}/dpsafebalance /dpwithdraw /dpdeposit /dpsetprice /dpupgrade\n");
    strcat(str, "{FFFFFF}/selldealership /acceptdealership\n");
    strcat(str, "{FFFFFF}/houses /buyhouse /myhouse\n");
    ShowPlayerDialog(playerid, DIALOG_HELP_OTHER, DIALOG_STYLE_MSGBOX, "{33CCFF}Others Help", str, "Back", "Close");
    return 1;
}

stock ShowHelpAdmin(playerid)
{
    new str[1300];
    format(str, sizeof(str), "{FF9900}Admin Level %d Help:\n\n", PlayerInfo[playerid][pAdmin]);
    if(IsAdmin(playerid, 1)) strcat(str, "{FFFFFF}Level 1: /goto /gethere\n");
    if(IsAdmin(playerid, 2)) strcat(str, "{FFFFFF}Level 2: /setskin /setmoney /freeze /unfreeze\n");
    if(IsAdmin(playerid, 3)) strcat(str, "{FFFFFF}Level 3: /createdealership /createdp /createdv /gotodp\n");
    if(IsAdmin(playerid, 4)) strcat(str, "{FFFFFF}Level 4: /setdpinfo /createhouse /sethouse\n");
    if(IsAdmin(playerid, 5)) strcat(str, "{FFFFFF}Level 5: /setadmin /makefamily /setfamily /createfaction\n");
    ShowPlayerDialog(playerid, DIALOG_HELP_ADMIN, DIALOG_STYLE_MSGBOX, "{FF9900}Admin Help", str, "Back", "Close");
    return 1;
}

stock ShowStats(playerid)
{
    new job[32], str[1024], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    GetJobName(PlayerInfo[playerid][pJob], job);
    format(str, sizeof(str), "{33FF33}Name:{FFFFFF} %s\n{33FF33}Level:{FFFFFF} %d\n{33FF33}Cash:{FFFFFF} $%d\n{33FF33}Bank:{FFFFFF} $%d\n{33FF33}", name, PlayerInfo[playerid][pLevel], GetPlayerMoney(playerid), PlayerInfo[playerid][pBank], PlayerInfo[playerid][pAdmin], PlayerInfo[playerid][pSkin], job, PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pRadio] ? ("Yes") : ("No"), PlayerInfo[playerid][pAccent]);
    format(str, sizeof(str), "{33FF33}Admin:{FFFFFF} %d\n{33FF33}Skin:{FFFFFF} %d\n{33FF33}Job:{FFFFFF} %s\n{33FF33}Materials:{FFFFFF} %d\n{33FF33}Radio:{FFFFFF} %s\n{33FF33}Accent:{FFFFFF} %s", PlayerInfo[playerid][pAdmin], PlayerInfo[playerid][pSkin], job, PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pRadio] ? ("Yes") : ("No"), PlayerInfo[playerid][pAccent]);
    ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, "{33FF33}Player Statistics", str, "Close", "");
    return 1;
}

// ================= Dealership System =================
stock GetDealershipFile(id, path[], size = 128) { format(path, size, DP_PATH, id); return 1; }
stock GetDealerVehicleFile(id, path[], size = 128) { format(path, size, DV_PATH, id); return 1; }

stock IsDealershipOwned(id)
{
    if(!DealershipInfo[id][dExists]) return 0;
    if(strcmp(DealershipInfo[id][dOwner], DEALERSHIP_NONE, true) == 0) return 0;
    return 1;
}

stock GetPlayerDealership(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    for(new i = 1; i < MAX_DEALERSHIPS; i++)
    {
        if(DealershipInfo[i][dExists] && strcmp(DealershipInfo[i][dOwner], name, true) == 0) return i;
    }
    return 0;
}

stock IsPlayerDealershipOwner(playerid, id)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    if(!DealershipInfo[id][dExists]) return 0;
    return !strcmp(DealershipInfo[id][dOwner], name, true);
}

stock GetNearestDealership(playerid)
{
    for(new i = 1; i < MAX_DEALERSHIPS; i++)
    {
        if(DealershipInfo[i][dExists] && IsPlayerInRangeOfPoint(playerid, 3.0, DealershipInfo[i][dX], DealershipInfo[i][dY], DealershipInfo[i][dZ])) return i;
    }
    return 0;
}

stock GetFreeDealershipID()
{
    for(new i = 1; i < MAX_DEALERSHIPS; i++) if(!DealershipInfo[i][dExists]) return i;
    return -1;
}

stock GetFreeDealerVehicleID()
{
    for(new i = 1; i < MAX_DVEHICLES; i++) if(!DealerVehInfo[i][dvExists]) return i;
    return -1;
}

stock CountDealerVehicles(dealerid)
{
    new count;
    for(new i = 1; i < MAX_DVEHICLES; i++) if(DealerVehInfo[i][dvExists] && DealerVehInfo[i][dvDealerID] == dealerid) count++;
    return count;
}

stock RefreshDealershipLabel(id)
{
    new text[256];
    if(DealershipInfo[id][dLabel]) Delete3DTextLabel(DealershipInfo[id][dLabel]);
    if(DealershipInfo[id][dPickup]) DestroyPickup(DealershipInfo[id][dPickup]);
    if(IsDealershipOwned(id))
    {
        format(text, sizeof(text), "{33FF33}%s\n{FFFFFF}Owner: %s\nLevel: %d | Safe: $%d\nStock: %d | Cars: %d/%d", DealershipInfo[id][dName], DealershipInfo[id][dOwner], DealershipInfo[id][dLevel], DealershipInfo[id][dSafe], DealershipInfo[id][dStock], CountDealerVehicles(id), DealershipInfo[id][dMaxCars]);
    }
    else
    {
        format(text, sizeof(text), "{FFFF00}%s\n{FFFFFF}For Sale: $%d\nUse /buydealership", DealershipInfo[id][dName], DealershipInfo[id][dPrice]);
    }
    DealershipInfo[id][dLabel] = Create3DTextLabel(text, COLOR_YELLOW, DealershipInfo[id][dX], DealershipInfo[id][dY], DealershipInfo[id][dZ] + 1.0, 20.0, 0, 1);
    DealershipInfo[id][dPickup] = CreatePickup(1272, 1, DealershipInfo[id][dX], DealershipInfo[id][dY], DealershipInfo[id][dZ], 0);
    return 1;
}

stock SaveDealership(id)
{
    new path[128], line[256], File:f;
    GetDealershipFile(id, path);
    f = fopen(path, io_write);
    if(!f) return 0;
    format(line, sizeof(line), "Exists=1\n"); fwrite(f, line);
    format(line, sizeof(line), "Name=%s\n", DealershipInfo[id][dName]); fwrite(f, line);
    format(line, sizeof(line), "Owner=%s\n", DealershipInfo[id][dOwner]); fwrite(f, line);
    format(line, sizeof(line), "Price=%d\n", DealershipInfo[id][dPrice]); fwrite(f, line);
    format(line, sizeof(line), "Safe=%d\n", DealershipInfo[id][dSafe]); fwrite(f, line);
    format(line, sizeof(line), "Stock=%d\n", DealershipInfo[id][dStock]); fwrite(f, line);
    format(line, sizeof(line), "Level=%d\n", DealershipInfo[id][dLevel]); fwrite(f, line);
    format(line, sizeof(line), "MaxCars=%d\n", DealershipInfo[id][dMaxCars]); fwrite(f, line);
    format(line, sizeof(line), "X=%f\n", DealershipInfo[id][dX]); fwrite(f, line);
    format(line, sizeof(line), "Y=%f\n", DealershipInfo[id][dY]); fwrite(f, line);
    format(line, sizeof(line), "Z=%f\n", DealershipInfo[id][dZ]); fwrite(f, line);
    fclose(f);
    return 1;
}

stock LoadDealership(id)
{
    new path[128], line[256], File:f;
    GetDealershipFile(id, path);
    if(!fexist(path)) return 0;
    f = fopen(path, io_read);
    if(!f) return 0;
    while(fread(f, line))
    {
        if(strfind(line, "Exists=") == 0) DealershipInfo[id][dExists] = true;
        else if(strfind(line, "Name=") == 0) GetFileString(line, DealershipInfo[id][dName], 64);
        else if(strfind(line, "Owner=") == 0) GetFileString(line, DealershipInfo[id][dOwner], MAX_PLAYER_NAME);
        else if(strfind(line, "Price=") == 0) DealershipInfo[id][dPrice] = GetFileValue(line);
        else if(strfind(line, "Safe=") == 0) DealershipInfo[id][dSafe] = GetFileValue(line);
        else if(strfind(line, "Stock=") == 0) DealershipInfo[id][dStock] = GetFileValue(line);
        else if(strfind(line, "Level=") == 0) DealershipInfo[id][dLevel] = GetFileValue(line);
        else if(strfind(line, "MaxCars=") == 0) DealershipInfo[id][dMaxCars] = GetFileValue(line);
        else if(strfind(line, "X=") == 0) DealershipInfo[id][dX] = GetFileFloat(line);
        else if(strfind(line, "Y=") == 0) DealershipInfo[id][dY] = GetFileFloat(line);
        else if(strfind(line, "Z=") == 0) DealershipInfo[id][dZ] = GetFileFloat(line);
    }
    fclose(f);
    if(DealershipInfo[id][dExists]) RefreshDealershipLabel(id);
    return 1;
}

stock SaveDealerVehicle(id)
{
    new path[128], line[256], File:f;
    GetDealerVehicleFile(id, path);
    f = fopen(path, io_write);
    if(!f) return 0;
    format(line, sizeof(line), "Exists=1\n"); fwrite(f, line);
    format(line, sizeof(line), "DealerID=%d\n", DealerVehInfo[id][dvDealerID]); fwrite(f, line);
    format(line, sizeof(line), "Model=%d\n", DealerVehInfo[id][dvModel]); fwrite(f, line);
    format(line, sizeof(line), "Price=%d\n", DealerVehInfo[id][dvPrice]); fwrite(f, line);
    format(line, sizeof(line), "X=%f\n", DealerVehInfo[id][dvX]); fwrite(f, line);
    format(line, sizeof(line), "Y=%f\n", DealerVehInfo[id][dvY]); fwrite(f, line);
    format(line, sizeof(line), "Z=%f\n", DealerVehInfo[id][dvZ]); fwrite(f, line);
    format(line, sizeof(line), "A=%f\n", DealerVehInfo[id][dvA]); fwrite(f, line);
    fclose(f);
    return 1;
}

stock SpawnDealerVehicle(id)
{
    new name[32], text[256];
    if(DealerVehInfo[id][dvVehID]) DestroyVehicle(DealerVehInfo[id][dvVehID]);
    if(DealerVehInfo[id][dvLabel]) Delete3DTextLabel(DealerVehInfo[id][dvLabel]);
    DealerVehInfo[id][dvVehID] = CreateVehicle(DealerVehInfo[id][dvModel], DealerVehInfo[id][dvX], DealerVehInfo[id][dvY], DealerVehInfo[id][dvZ], DealerVehInfo[id][dvA], 1, 1, -1);
    GetVehicleNameEx(DealerVehInfo[id][dvModel], name);
    format(text, sizeof(text), "{FFFF00}%s\n{FFFFFF}Price: $%d\nDealerVehID: %d\nEnter to buy", name, DealerVehInfo[id][dvPrice], id);
    DealerVehInfo[id][dvLabel] = Create3DTextLabel(text, COLOR_YELLOW, DealerVehInfo[id][dvX], DealerVehInfo[id][dvY], DealerVehInfo[id][dvZ] + 1.2, 20.0, 0, 1);
    return 1;
}

stock LoadDealerVehicle(id)
{
    new path[128], line[256], File:f;
    GetDealerVehicleFile(id, path);
    if(!fexist(path)) return 0;
    f = fopen(path, io_read);
    if(!f) return 0;
    while(fread(f, line))
    {
        if(strfind(line, "Exists=") == 0) DealerVehInfo[id][dvExists] = true;
        else if(strfind(line, "DealerID=") == 0) DealerVehInfo[id][dvDealerID] = GetFileValue(line);
        else if(strfind(line, "Model=") == 0) DealerVehInfo[id][dvModel] = GetFileValue(line);
        else if(strfind(line, "Price=") == 0) DealerVehInfo[id][dvPrice] = GetFileValue(line);
        else if(strfind(line, "X=") == 0) DealerVehInfo[id][dvX] = GetFileFloat(line);
        else if(strfind(line, "Y=") == 0) DealerVehInfo[id][dvY] = GetFileFloat(line);
        else if(strfind(line, "Z=") == 0) DealerVehInfo[id][dvZ] = GetFileFloat(line);
        else if(strfind(line, "A=") == 0) DealerVehInfo[id][dvA] = GetFileFloat(line);
    }
    fclose(f);
    if(DealerVehInfo[id][dvExists]) SpawnDealerVehicle(id);
    return 1;
}

stock LoadAllDealerships()
{
    for(new i = 1; i < MAX_DEALERSHIPS; i++) LoadDealership(i);
    for(new i = 1; i < MAX_DVEHICLES; i++) LoadDealerVehicle(i);
    return 1;
}

stock CreateDealership(playerid, price, name[])
{
    new id = GetFreeDealershipID();
    if(id == -1) return SendClientMessage(playerid, COLOR_RED, "No free dealership slots.");
    DealershipInfo[id][dExists] = true;
    format(DealershipInfo[id][dName], 64, "%s", name);
    format(DealershipInfo[id][dOwner], MAX_PLAYER_NAME, DEALERSHIP_NONE);
    DealershipInfo[id][dPrice] = price;
    DealershipInfo[id][dSafe] = 0;
    DealershipInfo[id][dStock] = 0;
    DealershipInfo[id][dLevel] = 1;
    DealershipInfo[id][dMaxCars] = DP_BASE_MAX_CARS;
    GetPlayerPos(playerid, DealershipInfo[id][dX], DealershipInfo[id][dY], DealershipInfo[id][dZ]);
    SaveDealership(id);
    RefreshDealershipLabel(id);
    SendClientMessage(playerid, COLOR_GREEN, "Dealership created.");
    return 1;
}

stock CreateDealerVehicle(playerid, dealerid, modelid, price)
{
    if(dealerid < 1 || dealerid >= MAX_DEALERSHIPS || !DealershipInfo[dealerid][dExists]) return SendClientMessage(playerid, COLOR_RED, "Invalid dealership ID.");
    if(modelid < 400 || modelid > 611) return SendClientMessage(playerid, COLOR_RED, "Invalid vehicle model.");
    if(CountDealerVehicles(dealerid) >= DealershipInfo[dealerid][dMaxCars]) return SendClientMessage(playerid, COLOR_RED, "Dealership reached max display cars.");
    new id = GetFreeDealerVehicleID();
    if(id == -1) return SendClientMessage(playerid, COLOR_RED, "No free dealer vehicle slots.");
    DealerVehInfo[id][dvExists] = true;
    DealerVehInfo[id][dvDealerID] = dealerid;
    DealerVehInfo[id][dvModel] = modelid;
    DealerVehInfo[id][dvPrice] = price;
    GetPlayerPos(playerid, DealerVehInfo[id][dvX], DealerVehInfo[id][dvY], DealerVehInfo[id][dvZ]);
    GetPlayerFacingAngle(playerid, DealerVehInfo[id][dvA]);
    SaveDealerVehicle(id);
    SpawnDealerVehicle(id);
    RefreshDealershipLabel(dealerid);
    SendClientMessage(playerid, COLOR_GREEN, "Dealer vehicle created.");
    return 1;
}

stock BuyDealership(playerid)
{
    new id = GetNearestDealership(playerid);
    if(id == 0) return SendClientMessage(playerid, COLOR_RED, "You are not near a dealership.");
    if(IsDealershipOwned(id)) return SendClientMessage(playerid, COLOR_RED, "This dealership is already owned.");
    if(GetPlayerDealership(playerid) != 0) return SendClientMessage(playerid, COLOR_RED, "You already own a dealership.");
    if(GetPlayerMoney(playerid) < DealershipInfo[id][dPrice]) return SendClientMessage(playerid, COLOR_RED, "Not enough money.");
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    GivePlayerMoney(playerid, -DealershipInfo[id][dPrice]);
    format(DealershipInfo[id][dOwner], MAX_PLAYER_NAME, "%s", name);
    SaveDealership(id);
    RefreshDealershipLabel(id);
    SendClientMessage(playerid, COLOR_GREEN, "You bought the dealership.");
    return 1;
}

stock GetDealerVehicleFromVehicle(vehicleid)
{
    for(new i = 1; i < MAX_DVEHICLES; i++) if(DealerVehInfo[i][dvExists] && DealerVehInfo[i][dvVehID] == vehicleid) return i;
    return 0;
}

stock StartMaterialRun(playerid)
{
    if(PlayerInfo[playerid][pJob] != JOB_ARMSDEALER && PlayerInfo[playerid][pJob] != JOB_CRAFTSMAN) return SendClientMessage(playerid, COLOR_RED, "Only Arms Dealer or Craftsman can get materials.");
    if(PlayerInfo[playerid][pOnMatRun]) return SendClientMessage(playerid, COLOR_RED, "You are already on a materials run.");
    if(!IsPlayerInRangeOfPoint(playerid, 5.0, MAT_PICKUP_X, MAT_PICKUP_Y, MAT_PICKUP_Z)) return SendClientMessage(playerid, COLOR_YELLOW, "You must be at the materials pickup point.");
    PlayerInfo[playerid][pOnMatRun] = true;
    PlayerInfo[playerid][pMatPackages] = 10;
    SetPlayerCheckpoint(playerid, MAT_DROP_X, MAT_DROP_Y, MAT_DROP_Z, 5.0);
    SendClientMessage(playerid, COLOR_GREEN, "You picked up 10 packages. Deliver them to the checkpoint for 250 materials.");
    return 1;
}

public OnGameModeInit()
{
    SetGameModeText(SERVER_NAME);
    AddPlayerClass(26, 1642.1833, -2334.1958, 13.5469, 0.0, 0, 0, 0, 0, 0, 0);
    LoadAllDealerships();
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, playerid + 1);
    SetPlayerPos(playerid, 1642.1833, -2334.1958, 13.5469);
    SetPlayerCameraPos(playerid, 1642.1833, -2328.1958, 16.5469);
    SetPlayerCameraLookAt(playerid, 1642.1833, -2334.1958, 13.5469);
    return 1;
}

public OnPlayerConnect(playerid)
{
    new path[128];
    GetAccountPath(playerid, path);
    PlayerInfo[playerid][pLogged] = false;
    PlayerInfo[playerid][pOnMatRun] = false;
    DealershipSellID[playerid] = 0;
    DealershipSellSeller[playerid] = INVALID_PLAYER_ID;
    if(fexist(path)) ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{33FF33}Welcome to EGRP - Login", "{FFFFFF}Welcome back to {33FF33}EGRP Roleplay{FFFFFF}.\n\nEnter your password:", "Login", "Quit");
    else ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{33FF33}Welcome to EGRP - Register", "{FFFFFF}Welcome to {33FF33}EGRP Roleplay{FFFFFF}.\n\nCreate a password:", "Register", "Quit");
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerInfo[playerid][pLogged]) SaveAccount(playerid);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    if(PlayerInfo[playerid][pNewbie])
    {
        SetPlayerPos(playerid, 1642.1833, -2334.1958, 13.5469);
        SendClientMessage(playerid, COLOR_GREEN, "Welcome to Los Santos. Use /help to get started.");
    }
    else if(PlayerInfo[playerid][pLogged])
    {
        SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pVW]);
        SetPlayerInterior(playerid, PlayerInfo[playerid][pInt]);
        SetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
        SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pPosA]);
    }
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    if(PlayerInfo[playerid][pOnMatRun] && IsPlayerInRangeOfPoint(playerid, 7.0, MAT_DROP_X, MAT_DROP_Y, MAT_DROP_Z))
    {
        PlayerInfo[playerid][pOnMatRun] = false;
        PlayerInfo[playerid][pMatPackages] = 0;
        PlayerInfo[playerid][pMaterials] += 250;
        DisablePlayerCheckpoint(playerid);
        SendClientMessage(playerid, COLOR_GREEN, "Materials delivered. You gained 250 materials.");
    }
    return 1;
}

public OnPlayerText(playerid, text[])
{
    new name[MAX_PLAYER_NAME], msg[160];
    GetPlayerName(playerid, name, sizeof(name));
    format(msg, sizeof(msg), "%s says: %s", name, text);
    SendLocalMessage(playerid, 20.0, COLOR_WHITE, msg);
    SetPlayerChatBubble(playerid, text, COLOR_WHITE, 20.0, 5000);
    return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    new dveh = GetDealerVehicleFromVehicle(vehicleid);
    if(dveh > 0)
    {
        ClearAnimations(playerid);
        PlayerSelectedDealerVeh[playerid] = dveh;
        new name[32], str[256], dealerid;
        dealerid = DealerVehInfo[dveh][dvDealerID];
        GetVehicleNameEx(DealerVehInfo[dveh][dvModel], name);
        format(str, sizeof(str), "{FFFFFF}Vehicle: {FFFF00}%s\n{FFFFFF}Price: {33FF33}$%d\n{FFFFFF}Dealership: %s\nOwner: %s\n\nBuy this vehicle?", name, DealerVehInfo[dveh][dvPrice], DealershipInfo[dealerid][dName], DealershipInfo[dealerid][dOwner]);
        ShowPlayerDialog(playerid, DIALOG_BUY_DEALER_CAR, DIALOG_STYLE_MSGBOX, "{FFFF00}Dealership Vehicle", str, "Buy", "Cancel");
        return 1;
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_REGISTER)
    {
        if(!response) return Kick(playerid);
        if(strlen(inputtext) < 4)
        {
            ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "{33FF33}Welcome to EGRP - Register", "Password must be at least 4 characters:", "Register", "Quit");
            return 1;
        }
        SetDefaultPlayer(playerid);
        PlayerInfo[playerid][pPassword] = HashPassword(inputtext);
        PlayerInfo[playerid][pNewbie] = true;
        PlayerInfo[playerid][pLogged] = true;
        SaveAccount(playerid);
        ShowPlayerDialog(playerid, DIALOG_TUTORIAL_1, DIALOG_STYLE_MSGBOX, "{33FF33}Tutorial 1/3", "Welcome to EGRP. Stay IC in normal chat. Use /b for OOC.", "Next", "Skip");
        return 1;
    }
    if(dialogid == DIALOG_LOGIN)
    {
        if(!response) return Kick(playerid);
        new path[128], line[128], File:f;
        GetAccountPath(playerid, path);
        f = fopen(path, io_read);
        if(!f) return Kick(playerid);
        fread(f, line);
        fclose(f);
        if(GetFileValue(line) != HashPassword(inputtext))
        {
            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "{FF0000}Wrong Password", "Wrong password. Try again:", "Login", "Quit");
            return 1;
        }
        LoadAccount(playerid);
        SendClientMessage(playerid, COLOR_GREEN, "Welcome back to EGRP.");
        SpawnPlayer(playerid);
        return 1;
    }
    if(dialogid == DIALOG_TUTORIAL_1)
    {
        if(!response) { PlayerInfo[playerid][pNewbie] = false; SpawnPlayer(playerid); return 1; }
        ShowPlayerDialog(playerid, DIALOG_TUTORIAL_2, DIALOG_STYLE_MSGBOX, "{33FF33}Tutorial 2/3", "Use /help, /jobs, /newb, /stats. You can work jobs and earn money/materials.", "Next", "Skip");
        return 1;
    }
    if(dialogid == DIALOG_TUTORIAL_2)
    {
        if(!response) { PlayerInfo[playerid][pNewbie] = false; SpawnPlayer(playerid); return 1; }
        ShowPlayerDialog(playerid, DIALOG_TUTORIAL_3, DIALOG_STYLE_MSGBOX, "{33FF33}Tutorial 3/3", "Buy businesses, dealerships, houses, join gangs/factions, and roleplay properly.", "Finish", "");
        return 1;
    }
    if(dialogid == DIALOG_TUTORIAL_3)
    {
        PlayerInfo[playerid][pNewbie] = false;
        SaveAccount(playerid);
        SpawnPlayer(playerid);
        return 1;
    }
    if(dialogid == DIALOG_HELP_MAIN)
    {
        if(!response) return 1;
        if(listitem == 0) return ShowHelpGeneral(playerid);
        if(listitem == 1) return ShowHelpJob(playerid);
        if(listitem == 2) return ShowHelpOther(playerid);
        if(listitem == 3) return ShowHelpAdmin(playerid);
        return 1;
    }
    if(dialogid == DIALOG_HELP_GENERAL || dialogid == DIALOG_HELP_JOB || dialogid == DIALOG_HELP_OTHER || dialogid == DIALOG_HELP_ADMIN)
    {
        if(response) ShowHelpMain(playerid);
        return 1;
    }
    if(dialogid == DIALOG_BUY_DEALER_CAR)
    {
        if(!response) return 1;
        new dveh = PlayerSelectedDealerVeh[playerid];
        if(dveh <= 0 || !DealerVehInfo[dveh][dvExists]) return 1;
        new dealerid = DealerVehInfo[dveh][dvDealerID], price = DealerVehInfo[dveh][dvPrice];
        if(GetPlayerMoney(playerid) < price) return SendClientMessage(playerid, COLOR_RED, "You do not have enough money.");
        GivePlayerMoney(playerid, -price);
        DealershipInfo[dealerid][dSafe] += price / 4;
        DealershipInfo[dealerid][dStock]--;
        if(DealershipInfo[dealerid][dStock] < 0) DealershipInfo[dealerid][dStock] = 0;
        SaveDealership(dealerid);
        RefreshDealershipLabel(dealerid);
        SendClientMessage(playerid, COLOR_GREEN, "Vehicle purchased. Add your owned vehicle spawn function here.");
        return 1;
    }
    return 0;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(strcmp(cmdtext, "/help", true) == 0 || strcmp(cmdtext, "/cmds", true) == 0) { ShowHelpMain(playerid); return 1; }
    if(strcmp(cmdtext, "/stats", true) == 0) { ShowStats(playerid); return 1; }
    if(strcmp(cmdtext, "/b", true, 2) == 0)
    {
        new text[128], name[MAX_PLAYER_NAME], msg[180]; ParseRest(cmdtext, 3, text, sizeof(text));
        if(!strlen(text)) return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /b [text]");
        GetPlayerName(playerid, name, sizeof(name)); format(msg, sizeof(msg), "(( %s: %s ))", name, text); SendLocalMessage(playerid, 20.0, COLOR_GREY, msg); return 1;
    }
    if(strcmp(cmdtext, "/shout", true, 6) == 0 || strcmp(cmdtext, "/s", true, 2) == 0)
    {
        new text[128], name[MAX_PLAYER_NAME], msg[180], offset = 7; if(strcmp(cmdtext, "/s", true, 2) == 0) offset = 3; ParseRest(cmdtext, offset, text, sizeof(text));
        if(!strlen(text)) return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /shout [text]");
        GetPlayerName(playerid, name, sizeof(name)); format(msg, sizeof(msg), "%s shouts: %s!", name, text); SendLocalMessage(playerid, 40.0, COLOR_WHITE, msg); SetPlayerChatBubble(playerid, text, COLOR_WHITE, 40.0, 5000); return 1;
    }
    if(strcmp(cmdtext, "/g", true, 2) == 0)
    {
        new text[128], name[MAX_PLAYER_NAME], msg[180]; ParseRest(cmdtext, 3, text, sizeof(text)); if(!strlen(text)) return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /g [text]");
        GetPlayerName(playerid, name, sizeof(name)); format(msg, sizeof(msg), "[Global] %s: %s", name, text); SendClientMessageToAll(COLOR_GREY, msg); return 1;
    }
    if(strcmp(cmdtext, "/newb", true, 5) == 0)
    {
        new text[128], name[MAX_PLAYER_NAME], msg[180]; ParseRest(cmdtext, 6, text, sizeof(text)); if(!strlen(text)) return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /newb [question]");
        GetPlayerName(playerid, name, sizeof(name)); format(msg, sizeof(msg), "[Newbie] %s: %s", name, text); SendClientMessageToAll(COLOR_GREEN, msg); return 1;
    }
    if(strcmp(cmdtext, "/pr", true, 3) == 0)
    {
        new text[128], name[MAX_PLAYER_NAME], msg[180]; if(!PlayerInfo[playerid][pRadio]) return SendClientMessage(playerid, COLOR_RED, "You need a radio from 24/7."); ParseRest(cmdtext, 4, text, sizeof(text)); if(!strlen(text)) return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /pr [text]");
        GetPlayerName(playerid, name, sizeof(name)); format(msg, sizeof(msg), "[Radio] %s: %s", name, text); for(new i = 0; i < MAX_PLAYERS; i++) if(IsPlayerConnected(i) && PlayerInfo[i][pRadio]) SendClientMessage(i, COLOR_BLUE, msg); return 1;
    }
    if(strcmp(cmdtext, "/accent", true, 7) == 0)
    {
        new accent[32]; ParseRest(cmdtext, 8, accent, sizeof(accent)); if(!strlen(accent)) return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /accent [accent]"); format(PlayerInfo[playerid][pAccent], 32, "%s", accent); SendClientMessage(playerid, COLOR_GREEN, "Accent updated."); return 1;
    }
    if(strcmp(cmdtext, "/jobs", true) == 0) { SendClientMessage(playerid, COLOR_YELLOW, "Jobs: 1 Trucker, 2 Mechanic, 3 Taxi, 4 ArmsDealer, 5 Craftsman, 6 Garbage, 7 Lawyer, 8 Farmer, 9 Miner, 10 DrugDealer."); return 1; }
    if(strcmp(cmdtext, "/getjob", true, 7) == 0)
    {
        new jobStr[16]; ParseWord(cmdtext, 8, jobStr, sizeof(jobStr)); if(!strlen(jobStr)) return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /getjob [jobid]"); PlayerInfo[playerid][pJob] = strval(jobStr); SendClientMessage(playerid, COLOR_GREEN, "Job set."); return 1;
    }
    if(strcmp(cmdtext, "/quitjob", true) == 0) { PlayerInfo[playerid][pJob] = JOB_NONE; SendClientMessage(playerid, COLOR_GREEN, "You quit your job."); return 1; }
    if(strcmp(cmdtext, "/work", true) == 0) { if(PlayerInfo[playerid][pJob] == JOB_NONE) return SendClientMessage(playerid, COLOR_RED, "You do not have a job."); GivePlayerMoney(playerid, 500); SendClientMessage(playerid, COLOR_GREEN, "You earned $500."); return 1; }
    if(strcmp(cmdtext, "/getmats", true) == 0) { StartMaterialRun(playerid); return 1; }
    if(strcmp(cmdtext, "/materials", true) == 0) { new msg[80]; format(msg, sizeof(msg), "Materials: %d", PlayerInfo[playerid][pMaterials]); SendClientMessage(playerid, COLOR_YELLOW, msg); return 1; }
    if(strcmp(cmdtext, "/makegun", true, 8) == 0) { if(PlayerInfo[playerid][pMaterials] < 100) return SendClientMessage(playerid, COLOR_RED, "You need 100 materials."); PlayerInfo[playerid][pMaterials] -= 100; GivePlayerWeapon(playerid, 24, 50); SendClientMessage(playerid, COLOR_GREEN, "You crafted a Desert Eagle."); return 1; }

    if(strcmp(cmdtext, "/createdealership", true, 17) == 0 || strcmp(cmdtext, "/createdp", true, 9) == 0)
    {
        if(!IsAdmin(playerid, 3)) return SendClientMessage(playerid, COLOR_RED, "You are not authorized.");
        new offset = 18; if(strcmp(cmdtext, "/createdp", true, 9) == 0) offset = 10;
        new priceStr[32], name[64], next = ParseWord(cmdtext, offset, priceStr, sizeof(priceStr)); ParseRest(cmdtext, next, name, sizeof(name));
        if(!strlen(priceStr) || !strlen(name)) return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /createdealership [price] [name]");
        CreateDealership(playerid, strval(priceStr), name); return 1;
    }
    if(strcmp(cmdtext, "/createdv", true, 9) == 0)
    {
        if(!IsAdmin(playerid, 3)) return SendClientMessage(playerid, COLOR_RED, "You are not authorized.");
        new idStr[16], carStr[32], priceStr[32], next = ParseWord(cmdtext, 10, idStr, sizeof(idStr)); next = ParseWord(cmdtext, next, carStr, sizeof(carStr)); ParseWord(cmdtext, next, priceStr, sizeof(priceStr));
        if(!strlen(idStr) || !strlen(carStr) || !strlen(priceStr)) return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /createdv [dealershipid] [carid/name] [price]");
        new modelid = GetVehicleModelByNameOrID(carStr); if(!modelid) return SendClientMessage(playerid, COLOR_RED, "Invalid car name/id.");
        CreateDealerVehicle(playerid, strval(idStr), modelid, strval(priceStr)); return 1;
    }
    if(strcmp(cmdtext, "/setdpinfo", true, 10) == 0 || strcmp(cmdtext, "/setdealership", true, 14) == 0)
    {
        if(!IsAdmin(playerid, 4)) return SendClientMessage(playerid, COLOR_RED, "You are not authorized.");
        new offset = 11; if(strcmp(cmdtext, "/setdealership", true, 14) == 0) offset = 15;
        new idStr[16], field[32], value[64], next = ParseWord(cmdtext, offset, idStr, sizeof(idStr)); next = ParseWord(cmdtext, next, field, sizeof(field)); ParseRest(cmdtext, next, value, sizeof(value));
        if(!strlen(idStr)) return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /setdpinfo [id] [name] [value]");
        if(!strlen(field)) return SendClientMessage(playerid, COLOR_YELLOW, "FIELDS: price, name, stock, maxcars");
        new id = strval(idStr); if(id < 1 || id >= MAX_DEALERSHIPS || !DealershipInfo[id][dExists]) return SendClientMessage(playerid, COLOR_RED, "Invalid dealership ID.");
        if(!strlen(value)) return SendClientMessage(playerid, COLOR_YELLOW, "VALUES: price [amount], name [text], stock [amount], maxcars [amount]");
        if(strcmp(field, "price", true) == 0) DealershipInfo[id][dPrice] = strval(value);
        else if(strcmp(field, "name", true) == 0) format(DealershipInfo[id][dName], 64, "%s", value);
        else if(strcmp(field, "stock", true) == 0) DealershipInfo[id][dStock] = strval(value);
        else if(strcmp(field, "maxcars", true) == 0) DealershipInfo[id][dMaxCars] = strval(value);
        else return SendClientMessage(playerid, COLOR_YELLOW, "FIELDS: price, name, stock, maxcars");
        SaveDealership(id); RefreshDealershipLabel(id); SendClientMessage(playerid, COLOR_GREEN, "Dealership info updated."); return 1;
    }
    if(strcmp(cmdtext, "/gotodp", true, 7) == 0)
    {
        if(!IsAdmin(playerid, 3)) return SendClientMessage(playerid, COLOR_RED, "You are not authorized.");
        new idStr[16]; ParseWord(cmdtext, 8, idStr, sizeof(idStr)); if(!strlen(idStr)) return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /gotodp [id]"); new id = strval(idStr); if(id < 1 || id >= MAX_DEALERSHIPS || !DealershipInfo[id][dExists]) return SendClientMessage(playerid, COLOR_RED, "Invalid dealership ID."); SetPlayerPos(playerid, DealershipInfo[id][dX], DealershipInfo[id][dY], DealershipInfo[id][dZ]); return 1;
    }
    if(strcmp(cmdtext, "/dealerships", true) == 0)
    {
        new str[2048], line[180]; for(new i = 1; i < MAX_DEALERSHIPS; i++) if(DealershipInfo[i][dExists]) { format(line, sizeof(line), "ID %d | %s | Owner: %s | Price: $%d | Level: %d | Stock: %d | Cars: %d/%d\n", i, DealershipInfo[i][dName], DealershipInfo[i][dOwner], DealershipInfo[i][dPrice], DealershipInfo[i][dLevel], DealershipInfo[i][dStock], CountDealerVehicles(i), DealershipInfo[i][dMaxCars]); strcat(str, line); }
        if(!strlen(str)) return SendClientMessage(playerid, COLOR_RED, "No dealerships created."); ShowPlayerDialog(playerid, 5010, DIALOG_STYLE_MSGBOX, "Dealerships", str, "Close", ""); return 1;
    }
    if(strcmp(cmdtext, "/buydealership", true) == 0) { BuyDealership(playerid); return 1; }
    if(strcmp(cmdtext, "/mydealership", true) == 0)
    {
        new id = GetPlayerDealership(playerid); if(!id) return SendClientMessage(playerid, COLOR_RED, "You do not own a dealership."); new str[256]; format(str, sizeof(str), "ID: %d\nName: %s\nSafe: $%d\nStock: %d\nLevel: %d\nCars: %d/%d", id, DealershipInfo[id][dName], DealershipInfo[id][dSafe], DealershipInfo[id][dStock], DealershipInfo[id][dLevel], CountDealerVehicles(id), DealershipInfo[id][dMaxCars]); ShowPlayerDialog(playerid, 5011, DIALOG_STYLE_MSGBOX, "My Dealership", str, "Close", ""); return 1;
    }
    if(strcmp(cmdtext, "/dpsafebalance", true) == 0)
	{
		new id = GetPlayerDealership(playerid);
		if(!id) return SendClientMessage(playerid, COLOR_RED, "You do not own a dealership.");
		new msg[96]; format(msg, sizeof(msg), "Safe balance: $%d", DealershipInfo[id][dSafe]);
		SendClientMessage(playerid, COLOR_GREEN, msg); return 1;
	}
    if(strcmp(cmdtext, "/dpupgrade", true) == 0)
	{
		new id = GetPlayerDealership(playerid);
		if(!id) return SendClientMessage(playerid, COLOR_RED, "You do not own a dealership.");
		new price = DP_UPGRADE_PRICE * DealershipInfo[id][dLevel];
		if(DealershipInfo[id][dSafe] < price)
		return SendClientMessage(playerid, COLOR_RED, "Not enough safe money.");
		DealershipInfo[id][dSafe] -= price; DealershipInfo[id][dLevel]++; DealershipInfo[id][dMaxCars] += 5; SaveDealership(id); RefreshDealershipLabel(id); SendClientMessage(playerid, COLOR_GREEN, "Dealership upgraded.");
		return 1;
	}
    if(strcmp(cmdtext, "/setadmin", true, 9) == 0)
	{
		if(!IsAdmin(playerid, 5))
		return SendClientMessage(playerid, COLOR_RED, "You are not authorized.");
		new idStr[16], lvlStr[16], next = ParseWord(cmdtext, 10, idStr, sizeof(idStr));
		ParseWord(cmdtext, next, lvlStr, sizeof(lvlStr)); if(!strlen(idStr) || !strlen(lvlStr))
		return SendClientMessage(playerid, COLOR_YELLOW, "USAGE: /setadmin [playerid] [level]");
		new target = strval(idStr);
		if(!IsPlayerConnected(target))
		return SendClientMessage(playerid, COLOR_RED, "Invalid player."); PlayerInfo[target][pAdmin] = strval(lvlStr); SendClientMessage(playerid, COLOR_GREEN, "Admin set.");
		return 1;
	}
    return 0;
}

public OnGameModeExit() return 1;
public OnPlayerDeath(playerid, killerid, reason) return 1;
public OnVehicleSpawn(vehicleid) return 1;
public OnVehicleDeath(vehicleid, killerid) return 1;
public OnPlayerExitVehicle(playerid, vehicleid) return 1;
public OnPlayerStateChange(playerid, newstate, oldstate) return 1;
public OnPlayerLeaveCheckpoint(playerid) return 1;
public OnRconCommand(cmd[]) return 1;
public OnPlayerRequestSpawn(playerid) return 1;
public OnPlayerUpdate(playerid) return 1;
public OnPlayerClickPlayer(playerid, clickedplayerid, source) return 1;

