#if defined _ER_CHAT_INCLUDED
    #endinput
#endif
#define _ER_CHAT_INCLUDED

stock ER_GetChatName(playerid, dest[], size)
{
    GetPlayerName(playerid, dest, size);
    for(new i = 0; dest[i] != EOS; i++)
    {
        if(dest[i] == '_') dest[i] = ' ';
    }
    return 1;
}

stock ER_LocalChat(playerid, const text[], Float:range)
{
    new msg[160], Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new dname[MAX_PLAYER_NAME]; ER_GetDisplayName(playerid, dname, sizeof(dname));
    if(PlayerInfo[playerid][pAccent] > 0) format(msg, sizeof(msg), "%s says [%s accent]: %s", dname, AccentNames[PlayerInfo[playerid][pAccent]], text);
    else format(msg, sizeof(msg), "%s says: %s", dname, text);
    ER_NearbyMessage(x, y, z, range, COLOR_WHITE, msg, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

CMD:s(playerid, params[])
{
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /s(hout) [message]");
    new msg[160], Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new dname[MAX_PLAYER_NAME]; ER_GetDisplayName(playerid, dname, sizeof(dname));
    format(msg, sizeof(msg), "%s shouts: %s!", dname, params);
    ER_NearbyMessage(x, y, z, CHAT_RANGE_SHOUT, COLOR_WHITE, msg, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}
alias:s("shout")

CMD:l(playerid, params[])
{
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /l(ow) [message]");
    ER_LocalChat(playerid, params, CHAT_RANGE_LOW);
    return 1;
}
alias:l("low")

CMD:g(playerid, params[])
{
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /g [message]");

    new name[MAX_PLAYER_NAME], msg[160];
    ER_GetChatName(playerid, name, sizeof(name));
    format(msg, sizeof(msg), "%s: (( %s ))", name, params);
    SendClientMessageToAll(COLOR_OOC, msg);
    return 1;
}
alias:g("general")

CMD:b(playerid, params[])
{
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /b [message]");

    new name[MAX_PLAYER_NAME], msg[160], Float:x, Float:y, Float:z;
    ER_GetChatName(playerid, name, sizeof(name));
    GetPlayerPos(playerid, x, y, z);

    format(msg, sizeof(msg), "%s: (( %s ))", name, params);
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_OOC, msg, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

CMD:newb(playerid, params[])
{
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /newb(ie) [message]");
    new msg[160], dname[MAX_PLAYER_NAME]; ER_GetDisplayName(playerid, dname, sizeof(dname)); format(msg, sizeof(msg), "(( Newbie %s [%s]: %s ))", dname, ER_AdminLevelName(PlayerInfo[playerid][pAdmin]), params);
    SendClientMessageToAll(COLOR_NEWBIE, msg);
    return 1;
}
alias:newb("newbie")

CMD:me(playerid, params[])
{
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /me [action]");
    new msg[160], Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new dname[MAX_PLAYER_NAME]; ER_GetDisplayName(playerid, dname, sizeof(dname));
    format(msg, sizeof(msg), "* %s %s", dname, params);
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, msg, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

CMD:do(playerid, params[])
{
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /do [description]");
    new msg[160], Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    new dname[MAX_PLAYER_NAME]; ER_GetDisplayName(playerid, dname, sizeof(dname));
    format(msg, sizeof(msg), "* %s (( %s ))", params, dname);
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_DO, msg, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

CMD:accent(playerid, params[])
{
    new id, list[512];
    if(sscanf(params, "d", id))
    {
        strcat(list, "0. None\n1. American\n2. British\n3. Egyptian\n4. Russian\n5. Gangsta\n6. Hungarian\n7. Italian\n8. French\n9. Spanish\n10. Arabic\n11. Mexican\n12. German\n13. Irish\n14. Scottish\n15. Australian\n16. Jamaican");
        ShowPlayerDialog(playerid, DIALOG_ACCENT, DIALOG_STYLE_MSGBOX, "Accent List", list, "Close", "");
        return ER_Send(playerid, COLOR_GREY, "USAGE: /accent [accent-id]");
    }
    if(id < 0 || id >= sizeof(AccentNames)) return ER_Send(playerid, COLOR_GREY, "Invalid accent ID.");
    PlayerInfo[playerid][pAccent] = id;
    new msg[96]; format(msg, sizeof(msg), "Accent set to: %s", AccentNames[id]);
    return ER_Send(playerid, COLOR_GREEN, msg);
}
