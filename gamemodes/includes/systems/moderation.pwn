#if defined _ER_MODERATION_INCLUDED
    #endinput
#endif
#define _ER_MODERATION_INCLUDED

#define DIALOG_REPORTS_LIST 9400
#define DIALOG_ADMINS_LIST  9401

new bool:ER_PlayerSpectating[MAX_PLAYERS] = {false, ...};
new ER_SpectateTarget[MAX_PLAYERS];
new ER_JailReleaseMsgShown[MAX_PLAYERS];

// ==========================================================
//  Jail / mute / ban / freeze tick
// ==========================================================
forward ER_ModerationTick();
public ER_ModerationTick()
{
    foreach(new i : Player)
    {
        if(!PlayerInfo[i][pLoggedIn]) continue;
        if(PlayerInfo[i][pJailTime] > 0)
        {
            PlayerInfo[i][pJailTime]--;
            if(PlayerInfo[i][pJailTime] <= 0)
            {
                PlayerInfo[i][pJailTime] = 0;
                ER_Send(i, COLOR_GREEN, "You have been released from jail.");
                SetPlayerInterior(i, 0);
                SetPlayerVirtualWorld(i, 0);
                SetPlayerPos(i, PlayerInfo[i][pSpawnX], PlayerInfo[i][pSpawnY], PlayerInfo[i][pSpawnZ]);
            }
            else if(i != INVALID_PLAYER_ID)
            {
                new hud[48];
                format(hud, sizeof(hud), "~r~Jailed~n~~w~%d min left", PlayerInfo[i][pJailTime]);
                GameTextForPlayer(i, hud, 1100, 4);
            }
        }
    }
    return 1;
}

stock ER_SendToJail(playerid, minutes)
{
    PlayerInfo[playerid][pJailTime] = minutes;
    SetPlayerInterior(playerid, 10);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, 264.6, 77.1, 1001.0);
    return 1;
}

// ==========================================================
//  BAN / UNBAN
// ==========================================================
CMD:ban(playerid, params[])
{
    new target, reason[128], q[256];
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "uS()[128]", target, reason)) return ER_Send(playerid, COLOR_GREY, "USAGE: /ban [id] [reason]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(isnull(reason)) format(reason, sizeof(reason), "No reason given");

    PlayerInfo[target][pBanned] = 1;
    format(PlayerInfo[target][pBanReason], 128, "%s", reason);
    ER_SaveCharacter(target);

    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `bans` (`account_id`,`username`,`ip`,`reason`,`admin_name`,`permanent`,`timestamp`) VALUES (%d,'%e','%e','%e','%e',0,%d)",
        PlayerInfo[target][pID], PlayerInfo[target][pName], PlayerInfo[target][pLastIP], reason, PlayerInfo[playerid][pName], gettime());
    mysql_tquery(MainPipeline, q);

    new msg[160];
    format(msg, sizeof(msg), "%s has been banned by %s. Reason: %s", ER_GetName(target), ER_GetName(playerid), reason);
    SendClientMessageToAll(COLOR_LIGHTRED, msg);
    return Kick(target);
}

CMD:permaban(playerid, params[])
{
    new target, reason[128], q[256];
    if(!ER_IsAdmin(playerid, ADMIN_LEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "uS()[128]", target, reason)) return ER_Send(playerid, COLOR_GREY, "USAGE: /permaban [id] [reason]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(isnull(reason)) format(reason, sizeof(reason), "No reason given");

    PlayerInfo[target][pBanned] = 1;
    format(PlayerInfo[target][pBanReason], 128, "[PERMANENT] %s", reason);
    ER_SaveCharacter(target);

    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `bans` (`account_id`,`username`,`ip`,`reason`,`admin_name`,`permanent`,`timestamp`) VALUES (%d,'%e','%e','%e','%e',1,%d)",
        PlayerInfo[target][pID], PlayerInfo[target][pName], PlayerInfo[target][pLastIP], reason, PlayerInfo[playerid][pName], gettime());
    mysql_tquery(MainPipeline, q);

    new msg[160];
    format(msg, sizeof(msg), "%s has been PERMANENTLY banned by %s. Reason: %s", ER_GetName(target), ER_GetName(playerid), reason);
    SendClientMessageToAll(COLOR_LIGHTRED, msg);
    return Kick(target);
}

CMD:banaccount(playerid, params[])
{
    new username[24], reason[128], q[300];
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "s[24]S()[128]", username, reason)) return ER_Send(playerid, COLOR_GREY, "USAGE: /banaccount [username] [reason]");
    if(isnull(reason)) format(reason, sizeof(reason), "No reason given");

    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `banned`=1,`ban_reason`='%e' WHERE `username`='%e'", reason, username);
    mysql_tquery(MainPipeline, q);
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `bans` (`account_id`,`username`,`reason`,`admin_name`,`permanent`,`timestamp`) VALUES (0,'%e','%e','%e',0,%d)", username, reason, PlayerInfo[playerid][pName], gettime());
    mysql_tquery(MainPipeline, q);

    new msg[160];
    format(msg, sizeof(msg), "Offline account '%s' has been banned. Reason: %s", username, reason);
    return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:unban(playerid, params[])
{
    new username[24], q[256];
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "s[24]", username)) return ER_Send(playerid, COLOR_GREY, "USAGE: /unban [username]");

    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `banned`=0,`ban_reason`='' WHERE `username`='%e'", username);
    mysql_tquery(MainPipeline, q);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `bans` SET `active`=0 WHERE `username`='%e'", username);
    mysql_tquery(MainPipeline, q);

    new msg[128];
    format(msg, sizeof(msg), "Account '%s' has been unbanned.", username);
    return ER_Send(playerid, COLOR_GREEN, msg);
}
alias:unban("unbanip")

// ==========================================================
//  JAIL
// ==========================================================
CMD:jail(playerid, params[])
{
    new target, minutes, reason[128];
    if(!ER_IsAdmin(playerid, ADMIN_JUNIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "udS()[128]", target, minutes, reason)) return ER_Send(playerid, COLOR_GREY, "USAGE: /jail [id] [minutes] [reason]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(isnull(reason)) format(reason, sizeof(reason), "No reason given");
    if(minutes < 1) minutes = 1;

    ER_SendToJail(target, minutes);
    ER_SaveCharacter(target);

    new msg[160];
    format(msg, sizeof(msg), "%s has been jailed for %d minute(s) by %s. Reason: %s", ER_GetName(target), minutes, ER_GetName(playerid), reason);
    SendClientMessageToAll(COLOR_ORANGE, msg);
    return 1;
}
alias:jail("prison")

CMD:sprison(playerid, params[])
{
    new target, minutes, reason[128];
    if(!ER_IsAdmin(playerid, ADMIN_JUNIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "udS()[128]", target, minutes, reason)) return ER_Send(playerid, COLOR_GREY, "USAGE: /sprison [id] [minutes] [reason] (silent, no public announce)");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(minutes < 1) minutes = 1;

    ER_SendToJail(target, minutes);
    ER_SaveCharacter(target);
    return ER_Send(playerid, COLOR_GREEN, "Player silently jailed.");
}

CMD:unjail(playerid, params[])
{
    new target;
    if(!ER_IsAdmin(playerid, ADMIN_JUNIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /unjail [id]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pJailTime] = 0;
    SetPlayerInterior(target, 0);
    SetPlayerVirtualWorld(target, 0);
    SetPlayerPos(target, PlayerInfo[target][pSpawnX], PlayerInfo[target][pSpawnY], PlayerInfo[target][pSpawnZ]);
    ER_SaveCharacter(target);

    ER_Send(target, COLOR_GREEN, "You have been released from jail early by an admin.");
    return ER_Send(playerid, COLOR_GREEN, "Player released.");
}

// ==========================================================
//  MUTE
// ==========================================================
CMD:mute(playerid, params[])
{
    new target, reason[128];
    if(!ER_IsAdmin(playerid, ADMIN_JUNIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "uS()[128]", target, reason)) return ER_Send(playerid, COLOR_GREY, "USAGE: /mute [id] [reason]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pMuted] = 1;
    ER_SaveCharacter(target);
    new msg[160];
    format(msg, sizeof(msg), "%s has been muted by %s.", ER_GetName(target), ER_GetName(playerid));
    SendClientMessageToAll(COLOR_ORANGE, msg);
    return 1;
}

CMD:unmute(playerid, params[])
{
    new target;
    if(!ER_IsAdmin(playerid, ADMIN_JUNIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /unmute [id]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pMuted] = 0;
    ER_SaveCharacter(target);
    ER_Send(target, COLOR_GREEN, "You have been unmuted.");
    return ER_Send(playerid, COLOR_GREEN, "Player unmuted.");
}

// ==========================================================
//  FREEZE
// ==========================================================
CMD:freeze(playerid, params[])
{
    new target;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /freeze [id]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pFrozen] = true;
    TogglePlayerControllable(target, false);
    ER_Send(target, COLOR_LIGHTRED, "You have been frozen by an admin.");
    return ER_Send(playerid, COLOR_GREEN, "Player frozen.");
}

CMD:unfreeze(playerid, params[])
{
    new target;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /unfreeze [id]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pFrozen] = false;
    TogglePlayerControllable(target, true);
    ER_Send(target, COLOR_GREEN, "You have been unfrozen.");
    return ER_Send(playerid, COLOR_GREEN, "Player unfrozen.");
}

// ==========================================================
//  KICK / WARN
// ==========================================================
CMD:kick(playerid, params[])
{
    new target, reason[128];
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "uS()[128]", target, reason)) return ER_Send(playerid, COLOR_GREY, "USAGE: /kick [id] [reason]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(isnull(reason)) format(reason, sizeof(reason), "No reason given");

    new msg[160];
    format(msg, sizeof(msg), "%s has been kicked by %s. Reason: %s", ER_GetName(target), ER_GetName(playerid), reason);
    SendClientMessageToAll(COLOR_ORANGE, msg);
    return Kick(target);
}

CMD:warn(playerid, params[])
{
    new target, reason[128];
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "uS()[128]", target, reason)) return ER_Send(playerid, COLOR_GREY, "USAGE: /warn [id] [reason]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(isnull(reason)) format(reason, sizeof(reason), "No reason given");

    PlayerInfo[target][pWarnings]++;
    ER_SaveCharacter(target);

    new msg[160];
    format(msg, sizeof(msg), "You have been warned by %s (warning #%d). Reason: %s", ER_GetName(playerid), PlayerInfo[target][pWarnings], reason);
    ER_Send(target, COLOR_LIGHTRED, msg);
    format(msg, sizeof(msg), "%s warned %s. Reason: %s", ER_GetName(playerid), ER_GetName(target), reason);
    return ER_Send(playerid, COLOR_GREEN, msg);
}

// ==========================================================
//  GOD MODE
// ==========================================================
public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    #pragma unused issuerid, amount, weaponid, bodypart
    if(PlayerInfo[playerid][pGodMode])
    {
        SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
        return 0;
    }
    return 1;
}

CMD:god(playerid, params[])
{
    new target = playerid;
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!isnull(params) && sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /god [id (optional, defaults to yourself)]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pGodMode] = !PlayerInfo[target][pGodMode];
    new msg[96];
    format(msg, sizeof(msg), "God mode %s for %s.", PlayerInfo[target][pGodMode] ? "ENABLED" : "disabled", ER_GetName(target));
    return ER_Send(playerid, COLOR_GREEN, msg);
}

// ==========================================================
//  SPECTATE
// ==========================================================
CMD:spec(playerid, params[])
{
    new target;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /spec [id]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(target == playerid) return ER_Send(playerid, COLOR_GREY, "You cannot spectate yourself.");

    ER_PlayerSpectating[playerid] = true;
    ER_SpectateTarget[playerid] = target;
    TogglePlayerSpectating(playerid, true);
    PlayerSpectatePlayer(playerid, target);

    new msg[96];
    format(msg, sizeof(msg), "You are now spectating %s. Use /specreset to stop.", ER_GetName(target));
    return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:specreset(playerid, params[])
{
    #pragma unused params
    if(!ER_PlayerSpectating[playerid]) return ER_Send(playerid, COLOR_GREY, "You are not spectating anyone.");

    ER_PlayerSpectating[playerid] = false;
    TogglePlayerSpectating(playerid, false);
    SetPlayerInterior(playerid, PlayerInfo[playerid][pSpawnInt]);
    SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pSpawnVW]);
    SetPlayerPos(playerid, PlayerInfo[playerid][pSpawnX], PlayerInfo[playerid][pSpawnY], PlayerInfo[playerid][pSpawnZ]);
    return ER_Send(playerid, COLOR_GREEN, "Spectating stopped.");
}

// ==========================================================
//  MONEY / APPEARANCE
// ==========================================================
CMD:setmoney(playerid, params[])
{
    new target, amount;
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "ud", target, amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setmoney [id] [amount]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pCash] = amount;
    ResetPlayerMoney(target);
    GivePlayerMoney(target, amount);
    ER_SaveCharacter(target);
    return ER_Send(playerid, COLOR_GREEN, "Player's cash updated.");
}

CMD:givemoney(playerid, params[])
{
    new target, amount;
    if(!ER_IsAdmin(playerid, ADMIN_JUNIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "ud", target, amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /givemoney [id] [amount]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pCash] += amount;
    GivePlayerMoney(target, amount);
    ER_SaveCharacter(target);
    return ER_Send(playerid, COLOR_GREEN, "Money given.");
}

CMD:setskin(playerid, params[])
{
    new target, skinid;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "ud", target, skinid)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setskin [id] [skinid]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pSkin] = skinid;
    SetPlayerSkin(target, skinid);
    ER_SaveCharacter(target);
    return ER_Send(playerid, COLOR_GREEN, "Skin updated.");
}
alias:setskin("forceskin")

CMD:changename(playerid, params[])
{
    new target, newname[24], q[256];
    if(!ER_IsAdmin(playerid, ADMIN_LEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "us[24]", target, newname)) return ER_Send(playerid, COLOR_GREY, "USAGE: /changename [id] [newname]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `username`='%e' WHERE `id`=%d", newname, PlayerInfo[target][pID]);
    mysql_tquery(MainPipeline, q);
    format(PlayerInfo[target][pName], MAX_PLAYER_NAME_EX, "%s", newname);
    SetPlayerName(target, newname);
    ER_Send(target, COLOR_GREEN, "Your name has been changed by an admin. Please reconnect.");
    return ER_Send(playerid, COLOR_GREEN, "Name changed. The player should reconnect to fully sync.");
}
alias:changename("setname")

// ==========================================================
//  IP LOOKUP
// ==========================================================
CMD:ip(playerid, params[])
{
    new target, msg[96];
    if(!ER_IsAdmin(playerid, ADMIN_JUNIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /ip [id]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    format(msg, sizeof(msg), "%s's IP: %s", ER_GetName(target), PlayerInfo[target][pLastIP]);
    return ER_Send(playerid, COLOR_YELLOW, msg);
}

CMD:ipcheck(playerid, params[])
{
    new ip[16], q[160];
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "s[16]", ip)) return ER_Send(playerid, COLOR_GREY, "USAGE: /ipcheck [ip]");

    mysql_format(MainPipeline, q, sizeof(q), "SELECT `username` FROM `accounts` WHERE `last_ip`='%e' LIMIT 20", ip);
    mysql_tquery(MainPipeline, q, "ER_OnIPCheckResult", "i", playerid);
    return 1;
}
forward ER_OnIPCheckResult(playerid);
public ER_OnIPCheckResult(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows, list[600], name[24], line[32];
    cache_get_row_count(rows);
    if(!rows) return ER_Send(playerid, COLOR_YELLOW, "No accounts found with that IP.");
    for(new r; r < rows; r++)
    {
        cache_get_value_name(r, "username", name, 24);
        format(line, sizeof(line), "%s\n", name);
        strcat(list, line, sizeof(list));
    }
    return ShowPlayerDialog(playerid, DIALOG_ADMINS_LIST, DIALOG_STYLE_MSGBOX, "Accounts sharing that IP", list, "Close", "");
}

// ==========================================================
//  WORLD (weather/time)
// ==========================================================
CMD:weather(playerid, params[])
{
    new id;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "d", id)) return ER_Send(playerid, COLOR_GREY, "USAGE: /weather [weatherid]");
    SetWeather(id);
    return ER_Send(playerid, COLOR_GREEN, "Weather updated for the server.");
}
alias:weather("weatherall")

CMD:settime(playerid, params[])
{
    new hour;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "d", hour)) return ER_Send(playerid, COLOR_GREY, "USAGE: /settime [0-23]");
    if(hour < 0 || hour > 23) return ER_Send(playerid, COLOR_GREY, "Hour must be between 0 and 23.");
    SetWorldTime(hour);
    return ER_Send(playerid, COLOR_GREEN, "Server time updated.");
}
alias:settime("tod")

// ==========================================================
//  STAFF MANAGEMENT
// ==========================================================
CMD:makeadmin(playerid, params[])
{
    new target, level, q[128];
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "ud", target, level)) return ER_Send(playerid, COLOR_GREY, "USAGE: /makeadmin [id] [level] (1=mod,2=junior,4=senior,5=lead)");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pAdmin] = level;
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `admin`=%d WHERE `id`=%d", level, PlayerInfo[target][pID]);
    mysql_tquery(MainPipeline, q);

    new msg[96];
    format(msg, sizeof(msg), "%s has been made admin level %d.", ER_GetName(target), level);
    return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:makehelper(playerid, params[])
{
    new target, q[128];
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /makehelper [id]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pAdmin] = ADMIN_MOD;
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `admin`=%d WHERE `id`=%d", ADMIN_MOD, PlayerInfo[target][pID]);
    mysql_tquery(MainPipeline, q);
    return ER_Send(playerid, COLOR_GREEN, "Player promoted to Helper.");
}

CMD:makemoderator(playerid, params[])
{
    new target, q[128];
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /makemoderator [id]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pAdmin] = ADMIN_JUNIOR;
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `admin`=%d WHERE `id`=%d", ADMIN_JUNIOR, PlayerInfo[target][pID]);
    mysql_tquery(MainPipeline, q);
    return ER_Send(playerid, COLOR_GREEN, "Player promoted to Moderator.");
}

CMD:removemoderator(playerid, params[])
{
    new target, q[128];
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /removemoderator [id]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    PlayerInfo[target][pAdmin] = 0;
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `admin`=0 WHERE `id`=%d", PlayerInfo[target][pID]);
    mysql_tquery(MainPipeline, q);
    return ER_Send(playerid, COLOR_GREEN, "Admin access removed.");
}

CMD:admins(playerid, params[])
{
    #pragma unused params
    new list[600], line[64], count;
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pAdmin] > 0)
        {
            format(line, sizeof(line), "%s - level %d\n", ER_GetName(i), PlayerInfo[i][pAdmin]);
            strcat(list, line, sizeof(list));
            count++;
        }
    }
    if(!count) format(list, sizeof(list), "No admins are currently online.");
    return ShowPlayerDialog(playerid, DIALOG_ADMINS_LIST, DIALOG_STYLE_MSGBOX, "Online Staff", list, "Close", "");
}

// ==========================================================
//  REPORTS
// ==========================================================
CMD:report(playerid, params[])
{
    new target, reason[128], q[400];
    if(sscanf(params, "uS()[128]", target, reason)) return ER_Send(playerid, COLOR_GREY, "USAGE: /report [id] [reason]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(isnull(reason)) return ER_Send(playerid, COLOR_GREY, "You must include a reason.");

    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `player_reports` (`reporter_id`,`reporter_name`,`target_id`,`target_name`,`reason`,`timestamp`) VALUES (%d,'%e',%d,'%e','%e',%d)",
        PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], PlayerInfo[target][pID], PlayerInfo[target][pName], reason, gettime());
    mysql_tquery(MainPipeline, q);

    new msg[160];
    format(msg, sizeof(msg), "[REPORT] %s reported %s: %s", ER_GetName(playerid), ER_GetName(target), reason);
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && ER_IsAdmin(i, ADMIN_MOD)) ER_Send(i, COLOR_LIGHTRED, msg);
    return ER_Send(playerid, COLOR_GREEN, "Your report has been sent to online staff.");
}

CMD:reports(playerid, params[])
{
    #pragma unused params
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    mysql_tquery(MainPipeline, "SELECT * FROM `player_reports` WHERE `resolved`=0 ORDER BY `id` DESC LIMIT 30", "ER_OnReportsListResult", "i", playerid);
    return 1;
}
forward ER_OnReportsListResult(playerid);
public ER_OnReportsListResult(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows, list[2048], line[128], id, reporter[24], target[24], reason[128];
    cache_get_row_count(rows);
    if(!rows) return ER_Send(playerid, COLOR_GREEN, "No open reports.");
    for(new r; r < rows; r++)
    {
        cache_get_value_name_int(r, "id", id);
        cache_get_value_name(r, "reporter_name", reporter, 24);
        cache_get_value_name(r, "target_name", target, 24);
        cache_get_value_name(r, "reason", reason, 128);
        format(line, sizeof(line), "#%d: %s -> %s: %s\n", id, reporter, target, reason);
        strcat(list, line, sizeof(list));
    }
    return ShowPlayerDialog(playerid, DIALOG_REPORTS_LIST, DIALOG_STYLE_MSGBOX, "Open Reports", list, "Close", "");
}

CMD:clearallreports(playerid, params[])
{
    #pragma unused params
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new q[160];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `player_reports` SET `resolved`=1,`resolved_by`='%e' WHERE `resolved`=0", PlayerInfo[playerid][pName]);
    mysql_tquery(MainPipeline, q);
    return ER_Send(playerid, COLOR_GREEN, "All open reports marked resolved.");
}

// ==========================================================
//  MISC ADMIN UTILITY
// ==========================================================
CMD:takeadminweapons(playerid, params[])
{
    new target;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /takeadminweapons [id]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");

    ResetPlayerWeapons(target);
    for(new w; w < MAX_WEAPON_SLOTS; w++) PlayerInfo[target][pPlayerWeapons][w] = 0;
    ER_SaveCharacter(target);
    return ER_Send(playerid, COLOR_GREEN, "Player's weapons cleared.");
}

CMD:setmyhp(playerid, params[])
{
    new Float:hp;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "f", hp)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setmyhp [health]");
    SetPlayerHealth(playerid, hp);
    PlayerInfo[playerid][pHealth] = hp;
    return ER_Send(playerid, COLOR_GREEN, "Health set.");
}

CMD:setmyarmor(playerid, params[])
{
    new Float:ar;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "f", ar)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setmyarmor [armor]");
    SetPlayerArmour(playerid, ar);
    PlayerInfo[playerid][pArmor] = ar;
    return ER_Send(playerid, COLOR_GREEN, "Armor set.");
}

CMD:setarmorall(playerid, params[])
{
    new Float:ar;
    if(!ER_IsAdmin(playerid, ADMIN_LEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "f", ar)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setarmorall [armor]");
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pLoggedIn])
        {
            SetPlayerArmour(i, ar);
            PlayerInfo[i][pArmor] = ar;
        }
    }
    return ER_Send(playerid, COLOR_GREEN, "Armor set for all online players.");
}

CMD:setint(playerid, params[])
{
    new target, interior;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "ud", target, interior)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setint [id] [interior]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    SetPlayerInterior(target, interior);
    return ER_Send(playerid, COLOR_GREEN, "Interior set.");
}

CMD:setvw(playerid, params[])
{
    new target, vw;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "ud", target, vw)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setvw [id] [virtualworld]");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    SetPlayerVirtualWorld(target, vw);
    return ER_Send(playerid, COLOR_GREEN, "Virtual world set.");
}

forward ER_CountdownTick(playerid, seconds);
public ER_CountdownTick(playerid, seconds)
{
    #pragma unused playerid
    if(seconds <= 0) { SendClientMessageToAll(COLOR_YELLOW, "Countdown finished!"); return 1; }
    new msg[32];
    format(msg, sizeof(msg), "Countdown: %d...", seconds);
    SendClientMessageToAll(COLOR_YELLOW, msg);
    SetTimerEx("ER_CountdownTick", 1000, false, "ii", playerid, seconds - 1);
    return 1;
}

CMD:countdown(playerid, params[])
{
    new seconds;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "d", seconds)) return ER_Send(playerid, COLOR_GREY, "USAGE: /countdown [seconds]");
    if(seconds < 1 || seconds > 60) return ER_Send(playerid, COLOR_GREY, "Seconds must be between 1 and 60.");
    ER_CountdownTick(playerid, seconds);
    return 1;
}

CMD:shutdown(playerid, params[])
{
    #pragma unused params
    if(!ER_IsAdmin(playerid, ADMIN_EXEC)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    SendClientMessageToAll(COLOR_LIGHTRED, "Server is shutting down...");
    SetTimerEx("ER_DoShutdown", 3000, false, "");
    return 1;
}
forward ER_DoShutdown();
public ER_DoShutdown()
{
    SendRconCommand("exit");
    return 1;
}
