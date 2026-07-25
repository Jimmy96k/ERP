#if defined _ER_ADMIN_INCLUDED
    #endinput
#endif
#define _ER_ADMIN_INCLUDED

CMD:setadmin(playerid, params[])
{
    new target, level;
    if(!ER_IsAdmin(playerid, ADMIN_EXEC)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "ui", target, level)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setadmin [playerid/name] [1/2/4/5/1337/99999]");
    if(level != 0 && level != 1 && level != 2 && level != 4 && level != 5 && level != 1337 && level != 99999) return ER_Send(playerid, COLOR_GREY, "Invalid admin level.");
    PlayerInfo[target][pAdmin] = level;
    ER_Send(playerid, COLOR_GREEN, "Admin level updated.");
    return 1;
}

CMD:setvip(playerid, params[])
{
    new target, level;
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "ui", target, level)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setvip [playerid/name] [0-5]");
    if(level < 0 || level > 5) return ER_Send(playerid, COLOR_GREY, "VIP level must be 0-5.");
    PlayerInfo[target][pPlayerVip] = level;
    return ER_Send(playerid, COLOR_GREEN, "VIP level updated.");
}

CMD:osetstat(playerid, params[])
{
    new pid, field[32], value[64], q[256];
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "ds[32]s[64]", pid, field, value)) return ER_Send(playerid, COLOR_GREY, "USAGE: /osetstat [pID] [field] [value]");
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `%e`='%e' WHERE `id`=%d", field, value, pid);
    mysql_tquery(MainPipeline, q);
    return ER_Send(playerid, COLOR_GREEN, "Offline stat update sent.");
}

CMD:a(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_MOD))
    {
        return ER_Send(playerid, COLOR_GREY,
            "You are not authorized.");
    }
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /a [message]");
    new msg[160]; format(msg, sizeof(msg), "** Admin %s: %s", ER_GetName(playerid), params);
    foreach(new i : Player) if(ER_IsAdmin(i, ADMIN_MOD)) SendClientMessage(i, COLOR_LIGHTRED, msg);
    return 1;
}

CMD:goto(playerid, params[])
{
    new target, Float:x, Float:y, Float:z;
    if(!ER_IsAdmin(playerid, ADMIN_MOD))
    {
        return ER_Send(playerid, COLOR_GREY,"You are not authorized.");
    }
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /goto [playerid/name]");
    GetPlayerPos(target, x, y, z);
    SetPlayerInterior(playerid, GetPlayerInterior(target));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(target));
    SetPlayerPos(playerid, x+1.0, y, z);
    return 1;
}

CMD:gotoco(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD))
    {
        return ER_Send(playerid, COLOR_GREY,"You are not authorized.");
    }
    new Float:x,Float:y,Float:z,vw = -1,interior = -1;

    if(sscanf(params, "fffDD", x, y, z, vw, interior))
    {
        return ER_Send(playerid, COLOR_GREY,"USAGE: /gotoco [x] [y] [z] [vw(optional)] [interior(optional)]");
    }
    SetPlayerPos(playerid, x, y, z);
    if(vw != -1)
    {
        SetPlayerVirtualWorld(playerid, vw);
    }
    if(interior != -1)
    {
        SetPlayerInterior(playerid, interior);
    }

    SetCameraBehindPlayer(playerid);

    return ER_Send(playerid, COLOR_GREEN,"You have been teleported successfully.");
}

CMD:gethere(playerid, params[])
{
    new target, Float:x, Float:y, Float:z;
    if(!ER_IsAdmin(playerid, ADMIN_MOD))
    {
        return ER_Send(playerid, COLOR_GREY,"You are not authorized.");
    }
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /gethere [playerid/name]");
    GetPlayerPos(playerid, x, y, z);
    SetPlayerInterior(target, GetPlayerInterior(playerid));
    SetPlayerVirtualWorld(target, GetPlayerVirtualWorld(playerid));
    SetPlayerPos(target, x+1.0, y, z);
    return 1;
}
CMD:nearestobj(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD))
    {
        return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    }

    new Float:ox, Float:oy, Float:oz;
    new modelid, str[144], count;

    SendClientMessage(playerid, COLOR_YELLOW, "Nearby dynamic objects within 10.0 units:");

    for(new i = 1; i < 20000; i++)
    {
        if(IsValidDynamicObject(i))
        {
            Streamer_GetFloatData(STREAMER_TYPE_OBJECT, i, E_STREAMER_X, ox);
            Streamer_GetFloatData(STREAMER_TYPE_OBJECT, i, E_STREAMER_Y, oy);
            Streamer_GetFloatData(STREAMER_TYPE_OBJECT, i, E_STREAMER_Z, oz);

            if(GetPlayerDistanceFromPoint(playerid, ox, oy, oz) < 10.0)
            {
                modelid = Streamer_GetIntData(STREAMER_TYPE_OBJECT, i, E_STREAMER_MODEL_ID);

                format(str, sizeof(str),
                    "DynamicObject ID: %d | Model: %d | Distance: %.2f",
                    i,
                    modelid,
                    GetPlayerDistanceFromPoint(playerid, ox, oy, oz)
                );

                SendClientMessage(playerid, COLOR_WHITE, str);
                count++;
            }
        }
    }

    if(!count)
    {
        SendClientMessage(playerid, COLOR_GREY, "No nearby dynamic objects found.");
    }

    return 1;
}
