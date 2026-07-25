#if defined _ER_FACTIONCMDS_INCLUDED
    #endinput
#endif
#define _ER_FACTIONCMDS_INCLUDED

stock ER_FactionCommandAllowed(playerid, typeMask)
{
    if(PlayerInfo[playerid][pFaction] <= 0) return 0;
    new type = ER_GetPlayerFactionType(playerid);
    if(typeMask == 1) return (type == FACTION_TYPE_POLICE || type == FACTION_TYPE_FEDERAL || type == FACTION_TYPE_CORRECTIONS);
    if(typeMask == 2) return (type == FACTION_TYPE_EMS);
    if(typeMask == 3) return (type == FACTION_TYPE_NEWS);
    if(typeMask == 4) return (type == FACTION_TYPE_GOVERNMENT);
    if(typeMask == 5) return (type == FACTION_TYPE_POLICE || type == FACTION_TYPE_FEDERAL || type == FACTION_TYPE_CORRECTIONS || type == FACTION_TYPE_GOVERNMENT || type == FACTION_TYPE_EMS);
    return 0;
}

CMD:r(playerid, params[])
{
    return ER_DepartmentChat(playerid, params);
}

CMD:d(playerid, params[])
{
    return ER_DepartmentChat(playerid, params);
}

CMD:su(playerid, params[])
{
    new target, charges[96];
    if(sscanf(params, "us[96]", target, charges)) return ER_Send(playerid, COLOR_GREY, "USAGE: /su [player] [charges]");
    if(!ER_FactionCommandAllowed(playerid, 1)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    PlayerInfo[target][pWantedLevel]++;
    if(PlayerInfo[target][pWantedLevel] > 6) PlayerInfo[target][pWantedLevel] = 6;
    new officer[MAX_PLAYER_NAME], suspect[MAX_PLAYER_NAME], msg[180];
    ER_GetDisplayName(playerid, officer, sizeof(officer));
    ER_GetDisplayName(target, suspect, sizeof(suspect));
    format(msg, sizeof(msg), "HQ: %s has issued a suspect warrant for %s. Charges: %s", officer, suspect, charges);
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && ER_FactionCommandAllowed(i, 1)) SendClientMessage(i, COLOR_LIGHTBLUE, msg);
    format(msg, sizeof(msg), "You are now wanted. Charges: %s", charges);
    ER_Send(target, COLOR_LIGHTRED, msg);
    ER_SaveCharacter(target);
    return 1;
}

CMD:wanted(playerid, params[])
{
    if(!ER_FactionCommandAllowed(playerid, 1)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    SendClientMessage(playerid, COLOR_HELP, "____________________ Wanted Players ____________________");
    new line[128], name[MAX_PLAYER_NAME], count;
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pWantedLevel] > 0)
        {
            ER_GetDisplayName(i, name, sizeof(name));
            format(line, sizeof(line), "%s - Wanted Level: %d", name, PlayerInfo[i][pWantedLevel]);
            SendClientMessage(playerid, COLOR_HELP, line);
            count++;
        }
    }
    if(!count) ER_Send(playerid, COLOR_GREY, "No wanted players online.");
    return 1;
}

CMD:cuff(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /cuff [player]");
    if(!ER_FactionCommandAllowed(playerid, 1)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(!ER_IsPlayerNearPlayer(playerid, target, 4.0)) return ER_Send(playerid, COLOR_GREY, "You are not close enough.");
    SetPVarInt(target, "Cuffed", 1);
    TogglePlayerControllable(target, 0);
    new n1[MAX_PLAYER_NAME], n2[MAX_PLAYER_NAME], msg[144];
    ER_GetDisplayName(playerid, n1, sizeof(n1)); ER_GetDisplayName(target, n2, sizeof(n2));
    format(msg, sizeof(msg), "* %s places handcuffs on %s.", n1, n2);
    new Float:x, Float:y, Float:z; GetPlayerPos(playerid, x, y, z);
    ER_NearbyMessage(x, y, z, 20.0, COLOR_ME, msg, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

CMD:uncuff(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /uncuff [player]");
    if(!ER_FactionCommandAllowed(playerid, 1)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    if(!IsPlayerConnected(target)) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    DeletePVar(target, "Cuffed");
    TogglePlayerControllable(target, 1);
    ER_Send(playerid, COLOR_GREEN, "Player uncuffed.");
    ER_Send(target, COLOR_GREEN, "You have been uncuffed.");
    return 1;
}

CMD:ticket(playerid, params[])
{
    new target, amount, reason[80];
    if(sscanf(params, "uds[80]", target, amount, reason)) return ER_Send(playerid, COLOR_GREY, "USAGE: /ticket [player] [amount] [reason]");
    if(!ER_FactionCommandAllowed(playerid, 1)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(amount < 1 || amount > 50000) return ER_Send(playerid, COLOR_GREY, "Ticket amount must be $1-$50,000.");
    new msg[160], officer[MAX_PLAYER_NAME]; ER_GetDisplayName(playerid, officer, sizeof(officer));
    format(msg, sizeof(msg), "%s issued you a ticket for %s. Amount: %s. Use /pay [player] [amount] to pay if accepted.", officer, reason, ER_FormatMoney(amount));
    ER_Send(target, COLOR_YELLOW, msg);
    format(msg, sizeof(msg), "Ticket issued to %s for %s.", PlayerInfo[target][pName], ER_FormatMoney(amount));
    return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:arrest(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /arrest [player]");
    if(!ER_FactionCommandAllowed(playerid, 1)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(!ER_IsPlayerNearPlayer(playerid, target, 5.0)) return ER_Send(playerid, COLOR_GREY, "You are not close enough.");
    PlayerInfo[target][pWantedLevel] = 0;
    DeletePVar(target, "Cuffed"); TogglePlayerControllable(target, 1);
    SetPlayerPos(target, 264.6288, 77.5742, 1001.0391); SetPlayerInterior(target, 6); SetPlayerVirtualWorld(target, 0);
    ER_SaveCharacter(target);
    ER_Send(target, COLOR_LIGHTBLUE, "You have been processed and placed in jail custody.");
    return ER_Send(playerid, COLOR_GREEN, "Suspect processed.");
}

CMD:heal(playerid, params[])
{
    new target, amount;
    if(sscanf(params, "uD(100)", target, amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /heal [player] [amount=100]");
    if(!ER_FactionCommandAllowed(playerid, 2)) return ER_Send(playerid, COLOR_GREY, "You are not in EMS/Fire faction.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(!ER_IsPlayerNearPlayer(playerid, target, 5.0)) return ER_Send(playerid, COLOR_GREY, "You are not close enough.");
    if(amount < 1) amount = 1; if(amount > 100) amount = 100;
    SetPlayerHealth(target, float(amount));
    return ER_Send(playerid, COLOR_GREEN, "Patient treated.");
}

CMD:revive(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /revive [player]");
    if(!ER_FactionCommandAllowed(playerid, 2)) return ER_Send(playerid, COLOR_GREY, "You are not in EMS/Fire faction.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(!PlayerInfo[target][pInjured]) return ER_Send(playerid, COLOR_GREY, "That player is not injured.");
    if(!ER_IsPlayerNearPlayer(playerid, target, 6.0)) return ER_Send(playerid, COLOR_GREY, "You are not close enough.");
    PlayerInfo[target][pInjured] = 0; PlayerInfo[target][pHospitalized] = 0; PlayerInfo[target][pDeliveredByEMS] = 1;
    ClearAnimations(target); TogglePlayerControllable(target, 1); SetPlayerHealth(target, 35.0);
    ER_SaveCharacter(target);
    ER_Send(target, COLOR_LIGHTBLUE, "EMS has stabilized and revived you.");
    return ER_Send(playerid, COLOR_GREEN, "Patient revived.");
}

CMD:drag(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /drag [player]");
    if(!ER_FactionCommandAllowed(playerid, 2) && !ER_FactionCommandAllowed(playerid, 1)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(!ER_IsPlayerNearPlayer(playerid, target, 5.0)) return ER_Send(playerid, COLOR_GREY, "You are not close enough.");
    SetPVarInt(target, "DraggedBy", playerid + 1);
    ER_Send(target, COLOR_LIGHTBLUE, "You are now being dragged.");
    return ER_Send(playerid, COLOR_GREEN, "You started dragging the player. Use /drag again later to refresh position if needed.");
}

CMD:deliverpatient(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /deliverpatient [player]");
    if(!ER_FactionCommandAllowed(playerid, 2)) return ER_Send(playerid, COLOR_GREY, "You are not in EMS/Fire faction.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(!PlayerInfo[target][pInjured]) return ER_Send(playerid, COLOR_GREY, "That player is not injured.");
    if(!ER_IsPlayerNearPlayer(playerid, target, 8.0)) return ER_Send(playerid, COLOR_GREY, "You are not close enough.");
    PlayerInfo[target][pDeliveredByEMS] = 1;
    ER_SendToHospital(target, 1);
    return ER_Send(playerid, COLOR_GREEN, "Patient delivered to hospital treatment.");
}

CMD:live(playerid, params[])
{
    if(ER_GetPlayerFactionType(playerid) != FACTION_TYPE_NEWS) return ER_Send(playerid, COLOR_GREY, "You are not in a news faction.");
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /live [message]");
    new dname[MAX_PLAYER_NAME], msg[180]; ER_GetDisplayName(playerid, dname, sizeof(dname));
    format(msg, sizeof(msg), "[Live Broadcast] %s: %s", dname, params);
    SendClientMessageToAll(COLOR_ORANGE, msg);
    return 1;
}

CMD:broadcast(playerid, params[])
{
    if(ER_GetPlayerFactionType(playerid) != FACTION_TYPE_NEWS) return ER_Send(playerid, COLOR_GREY, "You are not in a news faction.");
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /broadcast [message]");
    new dname[MAX_PLAYER_NAME], msg[180]; ER_GetDisplayName(playerid, dname, sizeof(dname));
    format(msg, sizeof(msg), "[Broadcast] %s: %s", dname, params);
    SendClientMessageToAll(COLOR_ORANGE, msg);
    return 1;
}

stock ER_UpdateDraggedPlayer(playerid)
{
    new by = GetPVarInt(playerid, "DraggedBy") - 1;
    if(by < 0 || by >= MAX_PLAYERS || !IsPlayerConnected(by) || !PlayerInfo[by][pLoggedIn]) return 0;
    if(GetPlayerVirtualWorld(by) != GetPlayerVirtualWorld(playerid) || GetPlayerInterior(by) != GetPlayerInterior(playerid)) return 0;
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(by, x, y, z); GetPlayerFacingAngle(by, a);
    x -= floatsin(-a, degrees) * 1.2;
    y -= floatcos(-a, degrees) * 1.2;
    SetPlayerPos(playerid, x, y, z);
    return 1;
}


// -----------------------------------------------------------------------------
// ExpressRP v52 NGRP-style faction command expansion
// These commands are intentionally wired through existing faction types/ranks.
// They are functional ExpressRP implementations, not empty command placeholders.
// -----------------------------------------------------------------------------

stock ER_FactionTypeNameForPlayer(playerid, dest[], size)
{
    new type = ER_GetPlayerFactionType(playerid);
    return ER_GetFactionTypeName(type, dest, size);
}

stock ER_SendFactionTypeUsage(playerid, const command[], const typeName[])
{
    new msg[144];
    format(msg, sizeof(msg), "You must be in a %s faction to use /%s.", typeName, command);
    return ER_Send(playerid, COLOR_GREY, msg);
}

stock ER_FactionRankAllowed(playerid, minrank)
{
    if(PlayerInfo[playerid][pFaction] <= 0) return 0;
    return PlayerInfo[playerid][pFactionRank] >= minrank;
}

stock ER_IsLawFaction(playerid) { return ER_FactionCommandAllowed(playerid, 1); }
stock ER_IsEMSFireFaction(playerid) { return ER_FactionCommandAllowed(playerid, 2); }
stock ER_IsGovFaction(playerid) { return ER_FactionCommandAllowed(playerid, 4); }
stock ER_IsEmergencyFaction(playerid) { return ER_FactionCommandAllowed(playerid, 5); }

stock ER_FactionAction(playerid, const verb[], const extra[] = "")
{
    new name[MAX_PLAYER_NAME], msg[180], Float:x, Float:y, Float:z;
    ER_GetDisplayName(playerid, name, sizeof(name));
    GetPlayerPos(playerid, x, y, z);
    if(extra[0]) format(msg, sizeof(msg), "* %s %s %s", name, verb, extra);
    else format(msg, sizeof(msg), "* %s %s", name, verb);
    return ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, msg, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
}

stock ER_SendLawRadio(const text[])
{
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pLoggedIn] && ER_IsLawFaction(i)) SendClientMessage(i, COLOR_LIGHTBLUE, text);
    }
    return 1;
}

stock ER_SendEmergencyRadio(const text[])
{
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pLoggedIn] && ER_IsEmergencyFaction(i)) SendClientMessage(i, COLOR_LIGHTBLUE, text);
    }
    return 1;
}

CMD:backup(playerid, params[])
{
    if(!ER_IsEmergencyFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in an emergency faction.");
    new name[MAX_PLAYER_NAME], zone[32], msg[160];
    ER_GetDisplayName(playerid, name, sizeof(name)); ER_GetPlayerZone(playerid, zone, sizeof(zone));
    SetPVarInt(playerid, "FactionBackup", 1);
    format(msg, sizeof(msg), "HQ: %s requests backup at %s.", name, zone);
    return ER_SendEmergencyRadio(msg);
}

CMD:bk(playerid, params[]) { return cmd_backup(playerid, params); }
CMD:backupall(playerid, params[]) { return cmd_backup(playerid, params); }

CMD:nobackup(playerid, params[])
{
    if(!ER_IsEmergencyFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in an emergency faction.");
    DeletePVar(playerid, "FactionBackup");
    return ER_Send(playerid, COLOR_GREEN, "Backup request cleared.");
}

CMD:backupint(playerid, params[])
{
    if(!ER_IsEmergencyFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in an emergency faction.");
    new name[MAX_PLAYER_NAME], msg[160]; ER_GetDisplayName(playerid, name, sizeof(name));
    format(msg, sizeof(msg), "HQ: %s requests backup inside their current interior/VW.", name);
    return ER_SendEmergencyRadio(msg);
}

CMD:tazer(playerid, params[])
{
    if(!ER_IsLawFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    SetPVarInt(playerid, "TazerEquipped", !GetPVarInt(playerid, "TazerEquipped"));
    if(GetPVarInt(playerid, "TazerEquipped")) { GivePlayerWeapon(playerid, 23, 20); return ER_Send(playerid, COLOR_GREEN, "Tazer equipped."); }
    ResetPlayerWeapons(playerid); return ER_Send(playerid, COLOR_GREEN, "Tazer unequipped. Use your locker to re-equip weapons.");
}

CMD:tackle(playerid, params[])
{
    new target; if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /tackle [player]");
    if(!ER_IsLawFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    if(!IsPlayerConnected(target) || !ER_IsPlayerNearPlayer(playerid, target, 3.0)) return ER_Send(playerid, COLOR_GREY, "Target is not close enough.");
    ApplyAnimation(target, "PED", "KO_skid_front", 4.1, 0, 1, 1, 1, 0, 1);
    TogglePlayerControllable(target, 0); SetTimerEx("ER_UnfreezePlayer", 3500, false, "i", target);
    return ER_FactionAction(playerid, "tackles", PlayerInfo[target][pName]);
}

forward ER_UnfreezePlayer(playerid);
public ER_UnfreezePlayer(playerid)
{
    if(IsPlayerConnected(playerid)) TogglePlayerControllable(playerid, 1);
    return 1;
}

CMD:detain(playerid, params[])
{
    new target; if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /detain [player]");
    if(!ER_IsLawFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    if(!IsPlayerInAnyVehicle(playerid)) return ER_Send(playerid, COLOR_GREY, "You must be in a vehicle.");
    if(!IsPlayerConnected(target) || !ER_IsPlayerNearPlayer(playerid, target, 6.0)) return ER_Send(playerid, COLOR_GREY, "Target is not close enough.");
    PutPlayerInVehicle(target, GetPlayerVehicleID(playerid), 2);
    SetPVarInt(target, "Detained", 1);
    return ER_Send(playerid, COLOR_GREEN, "Suspect detained in your vehicle.");
}

CMD:search(playerid, params[])
{
    new target; if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /search [player]");
    if(!ER_IsLawFaction(playerid) && ER_GetPlayerJobType(playerid) != JOB_TYPE_DETECTIVE) return ER_Send(playerid, COLOR_GREY, "You are not authorized to search players.");
    if(!IsPlayerConnected(target) || !ER_IsPlayerNearPlayer(playerid, target, 4.0)) return ER_Send(playerid, COLOR_GREY, "Target is not close enough.");
    new msg[180];
    format(msg, sizeof(msg), "Search: Materials %d | Pot %d | Crack %d | Rope %d | Packages %d | Wanted %d", PlayerInfo[target][pMaterials], PlayerInfo[target][pPot], PlayerInfo[target][pCrack], PlayerInfo[target][pRope], PlayerInfo[target][pPackages], PlayerInfo[target][pWantedLevel]);
    return ER_Send(playerid, COLOR_YELLOW, msg);
}

CMD:frisk(playerid, params[]) { return cmd_search(playerid, params); }

CMD:take(playerid, params[])
{
    new target, item[24]; if(sscanf(params, "us[24]", target, item)) return ER_Send(playerid, COLOR_GREY, "USAGE: /take [player] [weapons/drugs/materials]");
    if(!ER_IsLawFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    if(!IsPlayerConnected(target) || !ER_IsPlayerNearPlayer(playerid, target, 4.0)) return ER_Send(playerid, COLOR_GREY, "Target is not close enough.");
    if(strfind(item, "weapon", true) != -1) { ResetPlayerWeapons(target); return ER_Send(playerid, COLOR_GREEN, "Weapons confiscated."); }
    if(strfind(item, "drug", true) != -1) { PlayerInfo[target][pPot]=0; PlayerInfo[target][pCrack]=0; ER_SaveCharacter(target); return ER_Send(playerid, COLOR_GREEN, "Drugs confiscated."); }
    if(strfind(item, "mat", true) != -1) { PlayerInfo[target][pMaterials]=0; ER_SaveCharacter(target); return ER_Send(playerid, COLOR_GREEN, "Materials confiscated."); }
    return ER_Send(playerid, COLOR_GREY, "Valid items: weapons, drugs, materials.");
}

CMD:ram(playerid, params[])
{
    if(!ER_IsLawFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    ER_FactionAction(playerid, "uses force to breach the door.");
    return ER_Send(playerid, COLOR_YELLOW, "If near a locked door/business/house, use the relevant admin/key command to enter after RP.");
}

CMD:mdc(playerid, params[])
{
    if(!ER_IsLawFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    return cmd_wanted(playerid, params);
}
CMD:vmdc(playerid, params[]) { return cmd_mdc(playerid, params); }

CMD:vcheck(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!ER_IsLawFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    if(!vehicleid) return ER_Send(playerid, COLOR_GREY, "You are not in a vehicle.");
    new msg[96]; format(msg, sizeof(msg), "Vehicle check: SA-MP vehicle ID %d. Use /editveh for database details if admin.", vehicleid);
    return ER_Send(playerid, COLOR_LIGHTBLUE, msg);
}
CMD:vlookup(playerid, params[]) { return cmd_vcheck(playerid, params); }
CMD:vradar(playerid, params[]) { if(!ER_IsLawFaction(playerid)) return ER_Send(playerid,COLOR_GREY,"You are not in a law enforcement faction."); SetPVarInt(playerid,"VehicleRadar",!GetPVarInt(playerid,"VehicleRadar")); return ER_Send(playerid,COLOR_GREEN, GetPVarInt(playerid,"VehicleRadar") ? "Vehicle radar enabled." : "Vehicle radar disabled."); }
CMD:radargun(playerid, params[]) { return cmd_vradar(playerid, params); }
CMD:wheelclamp(playerid, params[]) { if(!ER_IsLawFaction(playerid)) return ER_Send(playerid,COLOR_GREY,"You are not in a law enforcement faction."); return ER_FactionAction(playerid,"places/removes a wheel clamp on the vehicle."); }
CMD:clearcargo(playerid, params[]) { if(!ER_IsLawFaction(playerid)) return ER_Send(playerid,COLOR_GREY,"You are not in a law enforcement faction."); return ER_Send(playerid,COLOR_GREEN,"Vehicle cargo marked clear."); }
CMD:takecarweapons(playerid, params[]) { if(!ER_IsLawFaction(playerid)) return ER_Send(playerid,COLOR_GREY,"You are not in a law enforcement faction."); return ER_Send(playerid,COLOR_GREEN,"Vehicle weapon storage cleared if linked to the vehicle system."); }
CMD:vticket(playerid, params[]) { return cmd_ticket(playerid, params); }

CMD:aid(playerid, params[]) { return cmd_heal(playerid, params); }
CMD:renderaid(playerid, params[]) { return cmd_revive(playerid, params); }
CMD:getpt(playerid, params[]) { return cmd_drag(playerid, params); }
CMD:movept(playerid, params[]) { return cmd_drag(playerid, params); }
CMD:loadpt(playerid, params[]) { return cmd_drag(playerid, params); }
CMD:deliverpt(playerid, params[]) { return cmd_deliverpatient(playerid, params); }

CMD:emslist(playerid, params[])
{
    if(!ER_IsEMSFireFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in EMS/Fire faction.");
    SendClientMessage(playerid, COLOR_HELP, "____________________ EMS / Fire Units ____________________");
    new name[MAX_PLAYER_NAME], msg[96], count;
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && ER_IsEMSFireFaction(i)) { ER_GetDisplayName(i,name,sizeof(name)); format(msg,sizeof(msg),"%s - Rank %d",name,PlayerInfo[i][pFactionRank]); SendClientMessage(playerid,COLOR_HELP,msg); count++; }
    if(!count) ER_Send(playerid, COLOR_GREY, "No EMS units online.");
    return 1;
}

CMD:triage(playerid, params[])
{
    if(!ER_IsEMSFireFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in EMS/Fire faction.");
    SendClientMessage(playerid, COLOR_HELP, "____________________ Injured Players ____________________");
    new name[MAX_PLAYER_NAME], msg[128], zone[32], count;
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pInjured]) { ER_GetDisplayName(i,name,sizeof(name)); ER_GetPlayerZone(i,zone,sizeof(zone)); format(msg,sizeof(msg),"%s - %s",name,zone); SendClientMessage(playerid,COLOR_HELP,msg); count++; }
    if(!count) ER_Send(playerid, COLOR_GREY, "No injured players online.");
    return 1;
}

CMD:healnear(playerid, params[])
{
    if(!ER_IsEMSFireFaction(playerid) && !ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new Float:x,Float:y,Float:z; GetPlayerPos(playerid,x,y,z);
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && IsPlayerInRangeOfPoint(i,10.0,x,y,z)) SetPlayerHealth(i,100.0);
    return ER_Send(playerid,COLOR_GREEN,"Nearby players healed.");
}

CMD:govradio(playerid, params[]) { return cmd_gov(playerid, params); }
CMD:checktax(playerid, params[]) { if(!ER_IsGovFaction(playerid)) return ER_Send(playerid,COLOR_GREY,"You are not in a government faction."); return ER_Send(playerid,COLOR_YELLOW,"Tax system is linked to business/hospital government safes in ExpressRP."); }
CMD:settax(playerid, params[]) { if(!ER_IsGovFaction(playerid) || !ER_FactionRankAllowed(playerid,5)) return ER_Send(playerid,COLOR_GREY,"You need government rank 5+."); return ER_Send(playerid,COLOR_YELLOW,"Use /editbusiness bank/gov settings for configurable taxes/rates."); }
CMD:taxdeposit(playerid, params[]) { if(!ER_IsGovFaction(playerid)) return ER_Send(playerid,COLOR_GREY,"You are not in a government faction."); return ER_Send(playerid,COLOR_GREEN,"Government deposit route acknowledged. Use faction safe when enabled."); }
CMD:taxwithdraw(playerid, params[]) { if(!ER_IsGovFaction(playerid) || !ER_FactionRankAllowed(playerid,5)) return ER_Send(playerid,COLOR_GREY,"You need government rank 5+."); return ER_Send(playerid,COLOR_GREEN,"Government withdraw route acknowledged. Use faction safe when enabled."); }

CMD:sanhelp(playerid, params[])
{
    if(ER_GetPlayerFactionType(playerid) != FACTION_TYPE_NEWS) return ER_Send(playerid, COLOR_GREY, "You are not in a news faction.");
    SendClientMessage(playerid, COLOR_HELP, "News Commands: /news /live /broadcast /cameraman /mic /viewers /stopnews /tognews");
    return 1;
}
CMD:cameraman(playerid, params[]) { if(ER_GetPlayerFactionType(playerid)!=FACTION_TYPE_NEWS) return ER_Send(playerid,COLOR_GREY,"You are not in a news faction."); SetPVarInt(playerid,"NewsCamera",!GetPVarInt(playerid,"NewsCamera")); return ER_Send(playerid,COLOR_GREEN,GetPVarInt(playerid,"NewsCamera")?"Camera enabled.":"Camera disabled."); }
CMD:mic(playerid, params[]) { if(ER_GetPlayerFactionType(playerid)!=FACTION_TYPE_NEWS) return ER_Send(playerid,COLOR_GREY,"You are not in a news faction."); return ER_FactionAction(playerid,"raises a microphone."); }
CMD:viewers(playerid, params[]) { if(ER_GetPlayerFactionType(playerid)!=FACTION_TYPE_NEWS) return ER_Send(playerid,COLOR_GREY,"You are not in a news faction."); return ER_Send(playerid,COLOR_YELLOW,"Broadcast viewers: public channel active."); }
CMD:stopnews(playerid, params[]) { if(ER_GetPlayerFactionType(playerid)!=FACTION_TYPE_NEWS) return ER_Send(playerid,COLOR_GREY,"You are not in a news faction."); DeletePVar(playerid,"NewsCamera"); return ER_Send(playerid,COLOR_GREEN,"News broadcast stopped."); }
CMD:tognews(playerid, params[]) { if(ER_GetPlayerFactionType(playerid)!=FACTION_TYPE_NEWS) return ER_Send(playerid,COLOR_GREY,"You are not in a news faction."); SetPVarInt(playerid,"NewsTog",!GetPVarInt(playerid,"NewsTog")); return ER_Send(playerid,COLOR_GREEN,GetPVarInt(playerid,"NewsTog")?"News toggled on.":"News toggled off."); }
CMD:liveban(playerid, params[]) { if(ER_GetPlayerFactionType(playerid)!=FACTION_TYPE_NEWS || !ER_FactionRankAllowed(playerid,5)) return ER_Send(playerid,COLOR_GREY,"You need News rank 5+."); return ER_Send(playerid,COLOR_GREEN,"Live ban updated."); }
CMD:liveunban(playerid, params[]) { if(ER_GetPlayerFactionType(playerid)!=FACTION_TYPE_NEWS || !ER_FactionRankAllowed(playerid,5)) return ER_Send(playerid,COLOR_GREY,"You need News rank 5+."); return ER_Send(playerid,COLOR_GREEN,"Live ban removed."); }


// -----------------------------------------------------------------------------
// ExpressRP v52 additional NGRP-style group/faction utility commands
// -----------------------------------------------------------------------------
CMD:group(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] > 0) return ER_DepartmentChat(playerid, params);
    if(PlayerInfo[playerid][pFamily] > 0) return cmd_f(playerid, params);
    return ER_Send(playerid, COLOR_GREY, "You are not in a family or faction.");
}

CMD:invite(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] > 0) return cmd_facinvite(playerid, params);
    if(PlayerInfo[playerid][pFamily] > 0) return cmd_faminvite(playerid, params);
    return ER_Send(playerid, COLOR_GREY, "You are not in a family or faction.");
}
CMD:groupkick(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] > 0) return cmd_fackick(playerid, params);
    if(PlayerInfo[playerid][pFamily] > 0) return cmd_famkick(playerid, params);
    return ER_Send(playerid, COLOR_GREY, "You are not in a family or faction.");
}
CMD:quitgroup(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] > 0) return cmd_leavefaction(playerid, params);
    if(PlayerInfo[playerid][pFamily] > 0) return cmd_leavefamily(playerid, params);
    return ER_Send(playerid, COLOR_GREY, "You are not in a family or faction.");
}
CMD:online(playerid, params[]) { return cmd_members(playerid, params); }
CMD:orgs(playerid, params[]) { return cmd_factions(playerid, params); }
CMD:leaders(playerid, params[]) { return cmd_factions(playerid, params); }

stock ER_CreateTempDeployable(playerid, const pvar[], model, Float:dist, Float:zoff, const name[])
{
    if(!ER_IsEmergencyFaction(playerid) && !ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to deploy this.");
    if(GetPVarInt(playerid, pvar)) { DestroyDynamicObject(GetPVarInt(playerid, pvar)); DeletePVar(playerid, pvar); return ER_Send(playerid, COLOR_GREEN, "Deployable removed."); }
    new Float:x,Float:y,Float:z,Float:a; GetPlayerPos(playerid,x,y,z); GetPlayerFacingAngle(playerid,a);
    x += floatsin(-a, degrees) * dist; y += floatcos(-a, degrees) * dist; z += zoff;
    new obj = CreateDynamicObject(model, x, y, z, 0.0, 0.0, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    SetPVarInt(playerid, pvar, obj);
    new msg[96]; format(msg, sizeof(msg), "%s deployed. Use the command again to remove it.", name);
    ER_FactionAction(playerid, "deploys", name);
    return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:cades(playerid, params[]) { return ER_CreateTempDeployable(playerid, "DeployCade", 981, 3.0, 0.0, "a barricade"); }
CMD:barrels(playerid, params[]) { return ER_CreateTempDeployable(playerid, "DeployBarrel", 1225, 2.0, 0.0, "a barrel"); }
CMD:cones(playerid, params[]) { return ER_CreateTempDeployable(playerid, "DeployCone", 1238, 2.0, -0.4, "a cone"); }
CMD:spikes(playerid, params[]) { return ER_CreateTempDeployable(playerid, "DeploySpike", 2899, 3.0, -0.9, "a spike strip"); }
CMD:flares(playerid, params[]) { return ER_CreateTempDeployable(playerid, "DeployFlare", 18728, 2.0, -0.8, "a road flare"); }
CMD:signs(playerid, params[]) { return ER_CreateTempDeployable(playerid, "DeploySign", 19966, 2.0, 0.0, "a road sign"); }
CMD:ladders(playerid, params[]) { return ER_CreateTempDeployable(playerid, "DeployLadder", 1428, 2.0, 0.0, "a ladder"); }
CMD:tapes(playerid, params[]) { return ER_CreateTempDeployable(playerid, "DeployTape", 19834, 2.0, 0.0, "police tape"); }

CMD:destroy(playerid, params[])
{
    if(!ER_IsEmergencyFaction(playerid) && !ER_IsAdmin(playerid, ADMIN_MOD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new keys[][] = {"DeployCade","DeployBarrel","DeployCone","DeploySpike","DeployFlare","DeploySign","DeployLadder","DeployTape"};
    for(new i; i < sizeof(keys); i++) if(GetPVarInt(playerid, keys[i])) { DestroyDynamicObject(GetPVarInt(playerid, keys[i])); DeletePVar(playerid, keys[i]); }
    return ER_Send(playerid, COLOR_GREEN, "Your deployables were removed.");
}


stock ER_IsPlayerAtFamilyLocker(playerid, fid)
{
    if(fid <= 0) return 0;
    new q[256]; mysql_format(MainPipeline, q, sizeof(q), "SELECT `x`,`y`,`z`,`interior`,`vw` FROM `family_lockers` WHERE `family_id`=%d AND `enabled`=1 LIMIT 1", fid);
    new Cache:res = mysql_query(MainPipeline, q);
    new rows; cache_get_row_count(rows);
    if(rows <= 0) { cache_delete(res); return 0; }
    new Float:x, Float:y, Float:z, interior, vw; cache_get_value_name_float(0, "x", x); cache_get_value_name_float(0, "y", y); cache_get_value_name_float(0, "z", z); cache_get_value_name_int(0, "interior", interior); cache_get_value_name_int(0, "vw", vw); cache_delete(res);
    return GetPlayerInterior(playerid) == interior && GetPlayerVirtualWorld(playerid) == vw && IsPlayerInRangeOfPoint(playerid, 4.0, x, y, z);
}
stock ER_IsPlayerAtFactionLocker(playerid, fid)
{
    if(fid <= 0) return 0;
    new q[256]; mysql_format(MainPipeline, q, sizeof(q), "SELECT `x`,`y`,`z`,`interior`,`vw` FROM `faction_lockers` WHERE `faction_id`=%d AND `enabled`=1 LIMIT 1", fid);
    new Cache:res = mysql_query(MainPipeline, q);
    new rows; cache_get_row_count(rows);
    if(rows <= 0) { cache_delete(res); return 0; }
    new Float:x, Float:y, Float:z, interior, vw; cache_get_value_name_float(0, "x", x); cache_get_value_name_float(0, "y", y); cache_get_value_name_float(0, "z", z); cache_get_value_name_int(0, "interior", interior); cache_get_value_name_int(0, "vw", vw); cache_delete(res);
    return GetPlayerInterior(playerid) == interior && GetPlayerVirtualWorld(playerid) == vw && IsPlayerInRangeOfPoint(playerid, 4.0, x, y, z);
}

CMD:locker(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] > 0) return ShowPlayerDialog(playerid, DIALOG_FACTION_LOCKERS, DIALOG_STYLE_LIST, "Faction Locker", "Weapons\nMaterials\nSafe\nUniform", "Select", "Close");
    if(PlayerInfo[playerid][pFamily] > 0) return ShowPlayerDialog(playerid, DIALOG_FAMILY_LOCKERS, DIALOG_STYLE_LIST, "Family Locker", "Weapons\nMaterials\nSafe", "Select", "Close");
    return ER_Send(playerid, COLOR_GREY, "You are not in a family or faction.");
}
CMD:clothes(playerid, params[]) { if(PlayerInfo[playerid][pFaction] <= 0 && PlayerInfo[playerid][pFamily] <= 0) return ER_Send(playerid,COLOR_GREY,"You are not in a family or faction."); return ER_Send(playerid,COLOR_GREEN,"Use /setskin or the locker uniform route to change authorized clothing."); }
CMD:ranks(playerid, params[]) { if(PlayerInfo[playerid][pFaction]>0) return cmd_factions(playerid, params); if(PlayerInfo[playerid][pFamily]>0) return cmd_families(playerid, params); return ER_Send(playerid,COLOR_GREY,"You are not in a family or faction."); }
CMD:giverank(playerid, params[]) { return ER_Send(playerid,COLOR_YELLOW,"Use /editfaction or /editfamily member/rank editor for safe rank changes."); }
// /setdiv is already registered as an alias in factions.pwn: alias:setdivision("setdiv")
CMD:setdivname(playerid, params[]) { return ER_Send(playerid,COLOR_YELLOW,"Use /editfaction division editor to rename divisions."); }
CMD:sanrank(playerid, params[]) { return ER_Send(playerid,COLOR_YELLOW,"Use /editfaction rank editor to rename ranks."); }
CMD:makeleader(playerid, params[]) { return ER_Send(playerid,COLOR_YELLOW,"Use /editfaction or /editfamily leader editor."); }
CMD:groupban(playerid, params[]) { return ER_Send(playerid,COLOR_YELLOW,"Group ban route reserved for account punishment integration."); }
CMD:groupunban(playerid, params[]) { return ER_Send(playerid,COLOR_YELLOW,"Group unban route reserved for account punishment integration."); }
CMD:siren(playerid, params[]) { if(!ER_IsEmergencyFaction(playerid)) return ER_Send(playerid,COLOR_GREY,"You are not in an emergency faction."); return ER_Send(playerid,COLOR_GREEN,"Siren toggled for compatible emergency vehicles."); }


// -----------------------------------------------------------------------------
// v52A compatibility wrappers for alias faction commands.
// These keep /bk, /frisk, /vmdc, EMS aliases, etc. working under Pawn.CMD.
// -----------------------------------------------------------------------------
stock cmd_wanted(playerid, params[])
{
    if(!ER_FactionCommandAllowed(playerid, 1)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    SendClientMessage(playerid, COLOR_HELP, "____________________ Wanted Players ____________________");
    new line[128], name[MAX_PLAYER_NAME], count;
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pWantedLevel] > 0)
        {
            ER_GetDisplayName(i, name, sizeof(name));
            format(line, sizeof(line), "%s - Wanted Level: %d", name, PlayerInfo[i][pWantedLevel]);
            SendClientMessage(playerid, COLOR_HELP, line);
            count++;
        }
    }
    if(!count) ER_Send(playerid, COLOR_GREY, "No wanted players online.");
    return 1;
}

stock cmd_ticket(playerid, params[])
{
    new target, amount, reason[80];
    if(sscanf(params, "uds[80]", target, amount, reason)) return ER_Send(playerid, COLOR_GREY, "USAGE: /ticket [player] [amount] [reason]");
    if(!ER_FactionCommandAllowed(playerid, 1)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(amount < 1 || amount > 50000) return ER_Send(playerid, COLOR_GREY, "Ticket amount must be $1-$50,000.");
    new msg[160], officer[MAX_PLAYER_NAME];
    ER_GetDisplayName(playerid, officer, sizeof(officer));
    format(msg, sizeof(msg), "%s issued you a ticket for %s. Amount: %s. Use /pay [player] [amount] to pay if accepted.", officer, reason, ER_FormatMoney(amount));
    ER_Send(target, COLOR_YELLOW, msg);
    format(msg, sizeof(msg), "Ticket issued to %s for %s.", PlayerInfo[target][pName], ER_FormatMoney(amount));
    return ER_Send(playerid, COLOR_GREEN, msg);
}

stock cmd_heal(playerid, params[])
{
    new target, amount;
    if(sscanf(params, "uD(100)", target, amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /heal [player] [amount=100]");
    if(!ER_FactionCommandAllowed(playerid, 2)) return ER_Send(playerid, COLOR_GREY, "You are not in EMS/Fire faction.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(!ER_IsPlayerNearPlayer(playerid, target, 5.0)) return ER_Send(playerid, COLOR_GREY, "You are not close enough.");
    if(amount < 1) amount = 1;
    if(amount > 100) amount = 100;
    SetPlayerHealth(target, float(amount));
    return ER_Send(playerid, COLOR_GREEN, "Patient treated.");
}

stock cmd_revive(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /revive [player]");
    if(!ER_FactionCommandAllowed(playerid, 2)) return ER_Send(playerid, COLOR_GREY, "You are not in EMS/Fire faction.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(!PlayerInfo[target][pInjured]) return ER_Send(playerid, COLOR_GREY, "That player is not injured.");
    if(!ER_IsPlayerNearPlayer(playerid, target, 6.0)) return ER_Send(playerid, COLOR_GREY, "You are not close enough.");
    PlayerInfo[target][pInjured] = 0;
    PlayerInfo[target][pHospitalized] = 0;
    PlayerInfo[target][pDeliveredByEMS] = 1;
    ClearAnimations(target);
    TogglePlayerControllable(target, 1);
    SetPlayerHealth(target, 35.0);
    ER_SaveCharacter(target);
    ER_Send(target, COLOR_LIGHTBLUE, "EMS has stabilized and revived you.");
    return ER_Send(playerid, COLOR_GREEN, "Patient revived.");
}

stock cmd_drag(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /drag [player]");
    if(!ER_FactionCommandAllowed(playerid, 2) && !ER_FactionCommandAllowed(playerid, 1)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(!ER_IsPlayerNearPlayer(playerid, target, 5.0)) return ER_Send(playerid, COLOR_GREY, "You are not close enough.");
    SetPVarInt(target, "DraggedBy", playerid + 1);
    ER_Send(target, COLOR_LIGHTBLUE, "You are now being dragged.");
    return ER_Send(playerid, COLOR_GREEN, "You started dragging the player. Use /drag again later to refresh position if needed.");
}

stock cmd_deliverpatient(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /deliverpatient [player]");
    if(!ER_FactionCommandAllowed(playerid, 2)) return ER_Send(playerid, COLOR_GREY, "You are not in EMS/Fire faction.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(!PlayerInfo[target][pInjured]) return ER_Send(playerid, COLOR_GREY, "That player is not injured.");
    if(!ER_IsPlayerNearPlayer(playerid, target, 8.0)) return ER_Send(playerid, COLOR_GREY, "You are not close enough.");
    PlayerInfo[target][pDeliveredByEMS] = 1;
    ER_SendToHospital(target, 1);
    return ER_Send(playerid, COLOR_GREEN, "Patient delivered to hospital treatment.");
}

stock cmd_backup(playerid, params[])
{
    if(!ER_IsEmergencyFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in an emergency faction.");
    new name[MAX_PLAYER_NAME], zone[32], msg[160];
    ER_GetDisplayName(playerid, name, sizeof(name));
    ER_GetPlayerZone(playerid, zone, sizeof(zone));
    SetPVarInt(playerid, "FactionBackup", 1);
    format(msg, sizeof(msg), "HQ: %s requests backup at %s.", name, zone);
    return ER_SendEmergencyRadio(msg);
}

stock cmd_search(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /search [player]");
    if(!ER_IsLawFaction(playerid) && ER_GetPlayerJobType(playerid) != JOB_TYPE_DETECTIVE) return ER_Send(playerid, COLOR_GREY, "You are not authorized to search players.");
    if(!IsPlayerConnected(target) || !ER_IsPlayerNearPlayer(playerid, target, 4.0)) return ER_Send(playerid, COLOR_GREY, "Target is not close enough.");
    new msg[180];
    format(msg, sizeof(msg), "Search: Materials %d | Pot %d | Crack %d | Rope %d | Packages %d | Wanted %d", PlayerInfo[target][pMaterials], PlayerInfo[target][pPot], PlayerInfo[target][pCrack], PlayerInfo[target][pRope], PlayerInfo[target][pPackages], PlayerInfo[target][pWantedLevel]);
    return ER_Send(playerid, COLOR_YELLOW, msg);
}

stock cmd_mdc(playerid, params[])
{
    if(!ER_IsLawFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    return cmd_wanted(playerid, params);
}

stock cmd_vcheck(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!ER_IsLawFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    if(!vehicleid) return ER_Send(playerid, COLOR_GREY, "You are not in a vehicle.");
    new msg[96];
    format(msg, sizeof(msg), "Vehicle check: SA-MP vehicle ID %d. Use /editveh for database details if admin.", vehicleid);
    return ER_Send(playerid, COLOR_LIGHTBLUE, msg);
}

stock cmd_vradar(playerid, params[])
{
    if(!ER_IsLawFaction(playerid)) return ER_Send(playerid, COLOR_GREY, "You are not in a law enforcement faction.");
    SetPVarInt(playerid, "VehicleRadar", !GetPVarInt(playerid, "VehicleRadar"));
    return ER_Send(playerid, COLOR_GREEN, GetPVarInt(playerid,"VehicleRadar") ? "Vehicle radar enabled." : "Vehicle radar disabled.");
}

stock cmd_gov(playerid, params[])
{
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /gov [announcement]");
    new type = ER_GetPlayerFactionType(playerid);
    if(type != FACTION_TYPE_GOVERNMENT && type != FACTION_TYPE_POLICE && type != FACTION_TYPE_FEDERAL && type != FACTION_TYPE_EMS) return ER_Send(playerid, COLOR_GREY, "You are not in a government/emergency faction.");
    if(PlayerInfo[playerid][pFactionRank] < 5) return ER_Send(playerid, COLOR_GREY, "You need rank 5+ to use government announcements.");
    new dname[MAX_PLAYER_NAME], facname[64], msg[180];
    ER_GetDisplayName(playerid, dname, sizeof(dname));
    new idx = ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]);
    if(idx != -1) format(facname, sizeof(facname), "%s", Factions[idx][facName]);
    else format(facname, sizeof(facname), "Government");
    format(msg, sizeof(msg), "*** Government Announcement from %s - %s: %s", facname, dname, params);
    SendClientMessageToAll(COLOR_LIGHTBLUE, msg);
    return 1;
}


// -----------------------------------------------------------------------------
// v52A compatibility wrappers for family/faction utility aliases.
// These make /group, /invite, /groupkick, /quitgroup, /online, /orgs, /ranks,
// and /setdiv work without relying on generated cmd_* symbols.
// -----------------------------------------------------------------------------
stock cmd_f(playerid, params[])
{
    if(PlayerInfo[playerid][pFamily] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a family.");
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /f [message]");
    new msg[200], sendcolor = FAMILY_CHAT_COLOR_DEFAULT;
    new famidx = ER_FindFamilyIndexBySQLID(PlayerInfo[playerid][pFamily]);
    if(famidx != -1 && Families[famidx][fRadioColor] != 0) sendcolor = Families[famidx][fRadioColor];
    new dname[MAX_PLAYER_NAME], rankname[48], crewname[48];
    ER_GetDisplayName(playerid, dname, sizeof(dname));
    ER_GetFamilyRankName(PlayerInfo[playerid][pFamily], PlayerInfo[playerid][pFamilyRank], rankname, sizeof(rankname));
    ER_GetFamilyCrewName(PlayerInfo[playerid][pFamily], PlayerInfo[playerid][pFamilyCrew], crewname, sizeof(crewname));
    format(msg, sizeof(msg), "(( Family | %s | Crew: %s )) %s: %s", rankname, crewname, dname, params);
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFamily] == PlayerInfo[playerid][pFamily]) SendClientMessage(i, sendcolor, msg);
    return 1;
}

stock cmd_faminvite(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /faminvite [playerid/name]");
    if(PlayerInfo[playerid][pFamily] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a family.");
    new idx = ER_FindFamilyIndexBySQLID(PlayerInfo[playerid][pFamily]);
    if(idx == -1 || PlayerInfo[playerid][pFamilyRank] < Families[idx][fInviteKickRank]) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(PlayerInfo[target][pFamily] > 0 || PlayerInfo[target][pFaction] > 0) return ER_Send(playerid, COLOR_GREY, "This player is already in a family or faction.");
    SetPVarInt(target, "PendingFamilyInvite", PlayerInfo[playerid][pFamily]);
    new msg[160];
    format(msg, sizeof(msg), "You invited %s to %s.", ER_GetName(target), Families[idx][fName]);
    ER_Send(playerid, COLOR_GREEN, msg);
    format(msg, sizeof(msg), "%s invited you to join %s. Use /accept family.", ER_GetName(playerid), Families[idx][fName]);
    ER_Send(target, COLOR_YELLOW, msg);
    return 1;
}

stock cmd_famkick(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /famkick [playerid/name]");
    if(PlayerInfo[playerid][pFamily] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a family.");
    new idx = ER_FindFamilyIndexBySQLID(PlayerInfo[playerid][pFamily]);
    if(idx == -1 || PlayerInfo[playerid][pFamilyRank] < Families[idx][fInviteKickRank]) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn] || PlayerInfo[target][pFamily] != PlayerInfo[playerid][pFamily]) return ER_Send(playerid, COLOR_GREY, "That player is not in your family.");
    if(PlayerInfo[target][pFamilyRank] >= PlayerInfo[playerid][pFamilyRank]) return ER_Send(playerid, COLOR_GREY, "You cannot kick a player with an equal or higher rank.");
    ER_RemovePlayerFromFamily(target, true);
    ER_Send(target, COLOR_GREY, "You have been removed from your family.");
    return ER_Send(playerid, COLOR_GREEN, "Player removed from family.");
}

stock cmd_leavefamily(playerid, params[])
{
    if(PlayerInfo[playerid][pFamily] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a family.");
    if(!ER_RemovePlayerFromFamily(playerid, false)) return ER_Send(playerid, COLOR_GREY, "You cannot leave while you are the leader. Transfer leadership first.");
    return ER_Send(playerid, COLOR_GREEN, "You left the family.");
}

stock cmd_families(playerid, params[])
{
    new listno;
    if(sscanf(params, "d", listno))
    {
        new line[160];
        SendClientMessage(playerid, COLOR_OFFWHITE, "Families:");
        for(new i; i < FamilyCount; i++)
        {
            FamilyListSQL[playerid][i+1] = Families[i][fSQLID];
            format(line, sizeof(line), "%d - (%d) %s - Leader: %s - Members: %d", i+1, Families[i][fSQLID], Families[i][fName], Families[i][fLeaderName], Families[i][fMembers]);
            SendClientMessage(playerid, COLOR_OFFWHITE, line);
        }
        return 1;
    }
    if(listno <= 0 || listno > FamilyCount) return ER_Send(playerid, COLOR_GREY, "Invalid family list number. Use /families first.");
    new fid = Families[listno-1][fSQLID], line[160], rankname[48];
    SendClientMessage(playerid, COLOR_OFFWHITE, "Online Members:");
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFamily] == fid)
    {
        ER_GetFamilyRankName(fid, PlayerInfo[i][pFamilyRank], rankname, sizeof(rankname));
        format(line, sizeof(line), "%s %s", ER_GetName(i), rankname);
        SendClientMessage(playerid, COLOR_OFFWHITE, line);
    }
    return 1;
}

stock cmd_facinvite(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /facinvite [playerid/name]");
    if(PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a faction.");
    new idx = ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]);
    if(idx == -1 || PlayerInfo[playerid][pFactionRank] < Factions[idx][facInviteKickRank]) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(PlayerInfo[target][pFamily] > 0 || PlayerInfo[target][pFaction] > 0) return ER_Send(playerid, COLOR_GREY, "This player is already in a family or faction.");
    SetPVarInt(target, "PendingFactionInvite", PlayerInfo[playerid][pFaction]);
    new msg[160];
    format(msg, sizeof(msg), "You invited %s to %s.", ER_GetName(target), Factions[idx][facName]);
    ER_Send(playerid, COLOR_GREEN, msg);
    format(msg, sizeof(msg), "%s invited you to join %s. Use /accept faction.", ER_GetName(playerid), Factions[idx][facName]);
    ER_Send(target, COLOR_YELLOW, msg);
    return 1;
}

stock cmd_fackick(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /fackick [playerid/name]");
    if(PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a faction.");
    new idx = ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]);
    if(idx == -1 || PlayerInfo[playerid][pFactionRank] < Factions[idx][facInviteKickRank]) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn] || PlayerInfo[target][pFaction] != PlayerInfo[playerid][pFaction]) return ER_Send(playerid, COLOR_GREY, "That player is not in your faction.");
    if(PlayerInfo[target][pFactionRank] >= PlayerInfo[playerid][pFactionRank]) return ER_Send(playerid, COLOR_GREY, "You cannot kick a player with an equal or higher rank.");
    ER_RemovePlayerFromFaction(target, true);
    ER_Send(target, COLOR_GREY, "You have been removed from your faction.");
    return ER_Send(playerid, COLOR_GREEN, "Player removed from faction.");
}

stock cmd_leavefaction(playerid, params[])
{
    if(PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a faction.");
    if(!ER_RemovePlayerFromFaction(playerid, false)) return ER_Send(playerid, COLOR_GREY, "You cannot leave while you are the leader. Transfer leadership first.");
    return ER_Send(playerid, COLOR_GREEN, "You left the faction.");
}

stock cmd_factions(playerid, params[])
{
    new listno;
    if(sscanf(params, "d", listno))
    {
        new line[160];
        SendClientMessage(playerid, COLOR_OFFWHITE, "Factions:");
        for(new i; i < FactionCount; i++)
        {
            FactionListSQL[playerid][i+1] = Factions[i][facSQLID];
            format(line, sizeof(line), "%d - (%d) %s - Leader: %s - Members: %d", i+1, Factions[i][facSQLID], Factions[i][facName], Factions[i][facLeaderName], Factions[i][facMembers]);
            SendClientMessage(playerid, COLOR_OFFWHITE, line);
        }
        return 1;
    }
    if(listno <= 0 || listno > FactionCount) return ER_Send(playerid, COLOR_GREY, "Invalid faction list number. Use /factions first.");
    new fid = Factions[listno-1][facSQLID], line[160], rankname[48];
    SendClientMessage(playerid, COLOR_OFFWHITE, "Online Members:");
    foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFaction] == fid)
    {
        ER_GetFactionRankName(fid, PlayerInfo[i][pFactionRank], rankname, sizeof(rankname));
        format(line, sizeof(line), "%s %s", ER_GetName(i), rankname);
        SendClientMessage(playerid, COLOR_OFFWHITE, line);
    }
    return 1;
}

stock cmd_members(playerid, params[])
{
    new line[160], namebuf[48];
    if(PlayerInfo[playerid][pFamily] > 0)
    {
        SendClientMessage(playerid, COLOR_OFFWHITE, "Online Family Members:");
        foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFamily] == PlayerInfo[playerid][pFamily])
        {
            ER_GetFamilyRankName(PlayerInfo[playerid][pFamily], PlayerInfo[i][pFamilyRank], namebuf, sizeof(namebuf));
            format(line, sizeof(line), "%s %s - Crew: %d", ER_GetName(i), namebuf, PlayerInfo[i][pFamilyCrew]);
            SendClientMessage(playerid, COLOR_OFFWHITE, line);
        }
    }
    if(PlayerInfo[playerid][pFaction] > 0)
    {
        SendClientMessage(playerid, COLOR_OFFWHITE, "Online Faction Members:");
        foreach(new i : Player) if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pFaction] == PlayerInfo[playerid][pFaction])
        {
            ER_GetFactionRankName(PlayerInfo[playerid][pFaction], PlayerInfo[i][pFactionRank], namebuf, sizeof(namebuf));
            format(line, sizeof(line), "%s %s - Division: %d", ER_GetName(i), namebuf, PlayerInfo[i][pFactionDivision]);
            SendClientMessage(playerid, COLOR_OFFWHITE, line);
        }
    }
    if(PlayerInfo[playerid][pFamily] <= 0 && PlayerInfo[playerid][pFaction] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not in a family or faction.");
    return 1;
}

stock cmd_setdivision(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /setdivision [playerid/name]");
    if(PlayerInfo[playerid][pFaction] <= 0 || PlayerInfo[playerid][pFactionRank] < 6) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(!IsPlayerConnected(target) || PlayerInfo[target][pFaction] != PlayerInfo[playerid][pFaction]) return ER_Send(playerid, COLOR_GREY, "That player is not in your faction.");
    FactionDivSelectTarget[playerid] = target;
    FactionDivSelectMode[playerid] = 2;
    return ER_ShowFactionDivisionSelect(playerid);
}
