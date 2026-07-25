CMD:stats(playerid, params[])
{
    if(!PlayerInfo[playerid][pLoggedIn])
        return SendClientMessage(playerid, COLOR_RED, "You are not logged in.");

    new gender[16], string[1024];

    if(PlayerInfo[playerid][pGender] == 1)
        format(gender, sizeof(gender), "Male");
    else
        format(gender, sizeof(gender), "Female");

    format(string, sizeof(string),
        "{FFFFFF}Account ID: {5DADE2}%d\n\
        {FFFFFF}Name: {5DADE2}%s\n\
        {FFFFFF}Admin Level: {F1C40F}%d\n\
        {FFFFFF}Gender: {5DADE2}%s\n\
        {FFFFFF}Date of Birth: {5DADE2}%s\n\n\
        {FFFFFF}Cash: {2ECC71}$%d\n\
        {FFFFFF}Bank: {2ECC71}$%d\n\
        {FFFFFF}Skin ID: {5DADE2}%d\n\n\
        {FFFFFF}Interior: {5DADE2}%d\n\
        {FFFFFF}Virtual World: {5DADE2}%d",
        PlayerInfo[playerid][pID],
        PlayerInfo[playerid][pName],
        PlayerInfo[playerid][pAdmin],
        gender,
        PlayerInfo[playerid][pBirthDate],
        GetPlayerMoney(playerid),
        PlayerInfo[playerid][pBank],
        PlayerInfo[playerid][pSkin],
        PlayerInfo[playerid][pInterior],
        PlayerInfo[playerid][pVW]);

    ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX,
        "{2ECC71}Character Statistics",
        string,
        "Close",
        "");

    return 1;
}

CMD:setskin(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, COLOR_RED, "You are not authorized.");

    new targetid, skinid;

    if(sscanf(params, "ud", targetid, skinid))
        return SendClientMessage(playerid, COLOR_RED, "Usage: /setskin [playerid/name] [skinid]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "Invalid player.");

    if(!(0 <= skinid <= 311))
        return SendClientMessage(playerid, COLOR_RED, "Invalid skin ID.");

    SetPlayerSkin(targetid, skinid);
    PlayerInfo[targetid][pSkin] = skinid;
    SavePlayer(targetid);

    SendClientMessage(playerid, COLOR_GREEN, "Skin changed successfully.");
    return 1;
}

CMD:setmoney(playerid, params[])
{
    if(PlayerInfo[playerid][pAdmin] < 1)
        return SendClientMessage(playerid, COLOR_RED, "You are not authorized.");

    new targetid, amount;

    if(sscanf(params, "ud", targetid, amount))
        return SendClientMessage(playerid, COLOR_RED, "Usage: /setmoney [playerid/name] [amount]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_RED, "Invalid player.");

    ResetPlayerMoney(targetid);
    GivePlayerMoney(targetid, amount);

    PlayerInfo[targetid][pCash] = amount;
    SavePlayer(targetid);

    SendClientMessage(playerid, COLOR_GREEN, "Money updated successfully.");
    return 1;
}

CMD:save(playerid, params[])
{
    SavePlayer(playerid);
    SendClientMessage(playerid, COLOR_GREEN, "Character saved successfully.");
    return 1;
}
