#if defined _ER_PHONE_INCLUDED
    #endinput
#endif
#define _ER_PHONE_INCLUDED

stock ER_ClearPhoneState(playerid)
{
    new other = PlayerInfo[playerid][pPhoneline];
    if(other != INVALID_CALL_PLAYER && IsPlayerConnected(other))
    {
        PlayerInfo[other][pPhoneline] = INVALID_CALL_PLAYER;
        PlayerInfo[other][pCalling] = INVALID_CALL_PLAYER;
        PlayerInfo[other][pCallState] = 0;
        ER_Send(other, COLOR_GREY, "The line has disconnected.");
    }
    PlayerInfo[playerid][pPhoneline] = INVALID_CALL_PLAYER;
    PlayerInfo[playerid][pCalling] = INVALID_CALL_PLAYER;
    PlayerInfo[playerid][pCallState] = 0;
    return 1;
}

stock ER_PhoneText(playerid, const text[])
{
    new other = PlayerInfo[playerid][pPhoneline];
    if(other == INVALID_CALL_PLAYER || !IsPlayerConnected(other)) return 0;
    new msg[160], local[160], Float:x, Float:y, Float:z;
    format(msg, sizeof(msg), "%s (cellphone): %s", ER_GetName(playerid), text);
    SendClientMessage(other, COLOR_LIGHTBLUE, msg);
    GetPlayerPos(playerid, x, y, z);
    format(local, sizeof(local), "%s (cellphone): %s", ER_GetName(playerid), text);
    ER_NearbyMessage(x, y, z, CHAT_RANGE_LOW, COLOR_WHITE, local, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

CMD:call(playerid, params[])
{
    new number;
    if(sscanf(params, "d", number)) return ER_Send(playerid, COLOR_GREY, "USAGE: /call [number]");
    if(PlayerInfo[playerid][pPhone] <= 0) return ER_Send(playerid, COLOR_GREY, "You do not have a phone.");
    if(PlayerInfo[playerid][pPhoneOff]) return ER_Send(playerid, COLOR_GREY, "Your phone is switched off.");
    foreach(new i : Player)
    {
        if(i == playerid || !PlayerInfo[i][pLoggedIn]) continue;
        if(PlayerInfo[i][pPhone] == number)
        {
            if(PlayerInfo[i][pPhoneOff]) return ER_Send(playerid, COLOR_GREY, "The phone appears to be switched off.");
            if(PlayerInfo[i][pCallState] != 0) return ER_Send(playerid, COLOR_GREY, "That phone line is busy.");
            PlayerInfo[playerid][pCalling] = i;
            PlayerInfo[playerid][pCallState] = 1;
            PlayerInfo[i][pCalling] = playerid;
            PlayerInfo[i][pCallState] = 2;
            ER_Send(playerid, COLOR_LIGHTBLUE, "You are calling...");
            ER_Send(i, COLOR_LIGHTBLUE, "Your phone is ringing. Use /pickup to answer or /hangup to decline.");
            new msg[96], Float:x, Float:y, Float:z;
            GetPlayerPos(i, x, y, z);
            format(msg, sizeof(msg), "* %s's phone starts ringing.", ER_GetName(i));
            ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, msg, GetPlayerVirtualWorld(i), GetPlayerInterior(i));
            return 1;
        }
    }
    return ER_Send(playerid, COLOR_GREY, "No active phone found with that number.");
}

CMD:pickup(playerid, params[])
{
    if(PlayerInfo[playerid][pCallState] != 2) return ER_Send(playerid, COLOR_GREY, "Your phone is not ringing.");
    new caller = PlayerInfo[playerid][pCalling];
    if(!IsPlayerConnected(caller)) return ER_ClearPhoneState(playerid);
    PlayerInfo[playerid][pPhoneline] = caller;
    PlayerInfo[caller][pPhoneline] = playerid;
    PlayerInfo[playerid][pCallState] = 3;
    PlayerInfo[caller][pCallState] = 3;
    ER_Send(playerid, COLOR_LIGHTBLUE, "You have picked up the phone.");
    ER_Send(caller, COLOR_LIGHTBLUE, "The call has been answered.");
    return 1;
}
alias:pickup("p")

CMD:hangup(playerid, params[])
{
    ER_ClearPhoneState(playerid);
    return ER_Send(playerid, COLOR_LIGHTBLUE, "You hung up the phone.");
}
alias:hangup("h")

CMD:togphone(playerid, params[])
{
    PlayerInfo[playerid][pPhoneOff] = !PlayerInfo[playerid][pPhoneOff];
    if(PlayerInfo[playerid][pPhoneOff]) return ER_Send(playerid, COLOR_LIGHTBLUE, "Your phone is now switched off.");
    return ER_Send(playerid, COLOR_LIGHTBLUE, "Your phone is now switched on.");
}

CMD:number(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /number [playerid/name]");
    if(!PlayerInfo[playerid][pPhonebook]) return ER_Send(playerid, COLOR_GREY, "You need a phonebook to use this command.");
    if(!IsPlayerConnected(target)) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    new msg[96]; format(msg, sizeof(msg), "%s's number is %d.", ER_GetName(target), PlayerInfo[target][pPhone]);
    return ER_Send(playerid, COLOR_LIGHTBLUE, msg);
}

CMD:sms(playerid, params[])
{
    new number, text[128];
    if(sscanf(params, "ds[128]", number, text)) return ER_Send(playerid, COLOR_GREY, "USAGE: /sms [number] [message]");
    if(PlayerInfo[playerid][pPhone] <= 0) return ER_Send(playerid, COLOR_GREY, "You do not have a phone.");
    if(PlayerInfo[playerid][pPhoneOff]) return ER_Send(playerid, COLOR_GREY, "Your phone is switched off.");
    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i) || !PlayerInfo[i][pLoggedIn]) continue;
        if(PlayerInfo[i][pPhone] == number && number > 0)
        {
            if(PlayerInfo[i][pPhoneOff]) return ER_Send(playerid, COLOR_GREY, "The phone appears to be switched off.");
            new msg[180];
            format(msg, sizeof(msg), "SMS from %d: %s", PlayerInfo[playerid][pPhone], text);
            SendClientMessage(i, COLOR_YELLOW, msg);
            format(msg, sizeof(msg), "SMS sent to %d: %s", number, text);
            return SendClientMessage(playerid, COLOR_YELLOW, msg);
        }
    }
    return ER_Send(playerid, COLOR_GREY, "No active phone found with that number.");
}
