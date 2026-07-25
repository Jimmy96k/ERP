#if defined _ER_INVENTORY_INCLUDED
    #endinput
#endif
#define _ER_INVENTORY_INCLUDED

#define ER_CONSUMABLE_ATTACH_SLOT 9

stock ER_ClearHeldConsumable(playerid)
{
    if(IsPlayerAttachedObjectSlotUsed(playerid, ER_CONSUMABLE_ATTACH_SLOT)) RemovePlayerAttachedObject(playerid, ER_CONSUMABLE_ATTACH_SLOT);
    DeletePVar(playerid, "HoldingSprunk");
    DeletePVar(playerid, "HoldingCigar");
    return 1;
}

stock ER_HandleHeldConsumableKey(playerid)
{
    if(GetPVarInt(playerid, "HoldingSprunk"))
    {
        new Float:h;
        GetPlayerHealth(playerid, h);
        SetPlayerHealth(playerid, ER_FloatMin(100.0, h + 5.0));
        PlayerInfo[playerid][pSprunk]--;
        ER_ClearHeldConsumable(playerid);
        return ER_Send(playerid, COLOR_GREEN, "You drink the Sprunk and recover 5 HP.");
    }
    if(GetPVarInt(playerid, "HoldingCigar"))
    {
        PlayerInfo[playerid][pCigar]--;
        ER_ClearHeldConsumable(playerid);
        return ER_Send(playerid, COLOR_GREEN, "You take a puff from the cigar.");
    }
    return 0;
}

CMD:inventory(playerid, params[])
{
    new list[640], lock[24];
    switch(PlayerInfo[playerid][pVehicleLock])
    {
        case 1: lock = "Alarm";
        case 2: lock = "Industrial";
        default: lock = "None";
    }
    format(list, sizeof(list), "Materials: %d\nCrack: %d\nPot: %d\nRope: %d\nPackages: %d\nSeeds: %d\nSprunk: %d\nCigars: %d\nSpray Cans: %d\nRadio: %s\nPhonebook: %s\nVehicle Security: %s",
        PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pPot], PlayerInfo[playerid][pRope], PlayerInfo[playerid][pPackages], PlayerInfo[playerid][pSeeds], PlayerInfo[playerid][pSprunk], PlayerInfo[playerid][pCigar], PlayerInfo[playerid][pSprayCans], PlayerInfo[playerid][pHasRadio] ? ("Yes") : ("No"), PlayerInfo[playerid][pPhonebook] ? ("Yes") : ("No"), lock);
    ShowPlayerDialog(playerid, DIALOG_INVENTORY, DIALOG_STYLE_MSGBOX, "Inventory", list, "Close", "");
    return 1;
}

CMD:use(playerid, params[])
{
    new item[32];
    if(sscanf(params, "s[32]", item)) return ER_Send(playerid, COLOR_GREY, "USAGE: /use [crack/pot/sprunk/cigar]");
    if(!strcmp(item, "crack", true))
    {
        if(PlayerInfo[playerid][pCrack] <= 0) return ER_Send(playerid, COLOR_GREY, "You do not have crack.");
        PlayerInfo[playerid][pCrack]--; SetPlayerHealth(playerid, 100.0); return ER_Send(playerid, COLOR_GREEN, "You used crack.");
    }
    if(!strcmp(item, "pot", true))
    {
        if(PlayerInfo[playerid][pPot] <= 0) return ER_Send(playerid, COLOR_GREY, "You do not have pot.");
        PlayerInfo[playerid][pPot]--; SetPlayerHealth(playerid, 100.0); return ER_Send(playerid, COLOR_GREEN, "You used pot.");
    }
    if(!strcmp(item, "sprunk", true))
    {
        if(PlayerInfo[playerid][pSprunk] <= 0) return ER_Send(playerid, COLOR_GREY, "You do not have Sprunk.");
        ER_ClearHeldConsumable(playerid);
        SetPlayerAttachedObject(playerid, ER_CONSUMABLE_ATTACH_SLOT, 1546, 6, 0.08, 0.03, 0.02, 0.0, 90.0, 0.0, 1.0, 1.0, 1.0);
        SetPVarInt(playerid, "HoldingSprunk", 1);
        return ER_Send(playerid, COLOR_GREEN, "You hold a Sprunk. Press CTRL/action to drink it.");
    }
    if(!strcmp(item, "cigar", true) || !strcmp(item, "cigars", true))
    {
        if(PlayerInfo[playerid][pCigar] <= 0) return ER_Send(playerid, COLOR_GREY, "You do not have a cigar.");
        ER_ClearHeldConsumable(playerid);
        SetPlayerAttachedObject(playerid, ER_CONSUMABLE_ATTACH_SLOT, 1485, 6, 0.05, 0.02, 0.01, 0.0, 90.0, 0.0, 0.6, 0.6, 0.6);
        SetPVarInt(playerid, "HoldingCigar", 1);
        return ER_Send(playerid, COLOR_GREEN, "You hold a cigar. Press CTRL/action to smoke it.");
    }
    return ER_Send(playerid, COLOR_GREY, "Unknown item.");
}

CMD:pay(playerid, params[])
{
    new target, amount;
    if(sscanf(params, "ui", target, amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /pay [playerid/name] [amount]");
    if(!IsPlayerConnected(target) || target == playerid) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(amount <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid amount.");
    if(PlayerInfo[playerid][pCash] < amount) return ER_Send(playerid, COLOR_GREY, "You do not have enough cash.");
    PlayerInfo[playerid][pCash] -= amount;
    PlayerInfo[target][pCash] += amount;
    GivePlayerMoney(playerid, -amount);
    GivePlayerMoney(target, amount);
    return ER_Send(playerid, COLOR_GREEN, "Payment sent.");
}

CMD:give(playerid, params[])
{
    new target, item[24], amount;
    if(sscanf(params, "us[24]i", target, item, amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /give [playerid/name] [materials/crack/pot] [amount]");
    if(!IsPlayerConnected(target) || amount <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid input.");
    if(!strcmp(item, "rope", true)) return ER_Send(playerid, COLOR_GREY, "Rope cannot be given to other players.");
    if(!strcmp(item, "materials", true))
    {
        if(PlayerInfo[playerid][pMaterials] < amount) return ER_Send(playerid, COLOR_GREY, "You do not have enough materials.");
        PlayerInfo[playerid][pMaterials] -= amount;
        PlayerInfo[target][pMaterials] += amount;
    }
    else if(!strcmp(item, "crack", true))
    {
        if(PlayerInfo[playerid][pCrack] < amount) return ER_Send(playerid, COLOR_GREY, "You do not have enough crack.");
        PlayerInfo[playerid][pCrack] -= amount;
        PlayerInfo[target][pCrack] += amount;
    }
    else if(!strcmp(item, "pot", true))
    {
        if(PlayerInfo[playerid][pPot] < amount) return ER_Send(playerid, COLOR_GREY, "You do not have enough pot.");
        PlayerInfo[playerid][pPot] -= amount;
        PlayerInfo[target][pPot] += amount;
    }
    else return ER_Send(playerid, COLOR_GREY, "Invalid item.");
    ER_Send(playerid, COLOR_GREEN, "Item given.");
    return 1;
}

CMD:tie(playerid, params[])
{
    new target;
    if(sscanf(params, "u", target)) return ER_Send(playerid, COLOR_GREY, "USAGE: /tie [playerid/name]");
    if(target == playerid) return ER_Send(playerid, COLOR_GREY, "You cannot tie yourself.");
    if(PlayerInfo[playerid][pRope] <= 0) return ER_Send(playerid, COLOR_GREY, "You need rope to tie someone.");
    if(!IsPlayerConnected(target)) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ER_Send(playerid, COLOR_GREY, "You must be driving a vehicle to tie someone.");
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInVehicle(target, vehicleid) || GetPlayerState(target) == PLAYER_STATE_DRIVER) return ER_Send(playerid, COLOR_GREY, "The player must be a passenger in your vehicle.");
    PlayerInfo[playerid][pRope]--;
    TogglePlayerControllable(target, false);
    ER_Send(target, COLOR_LIGHTRED, "You have been tied.");
    return ER_Send(playerid, COLOR_GREEN, "Player tied.");
}
