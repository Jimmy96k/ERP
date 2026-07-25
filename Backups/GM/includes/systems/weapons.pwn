#if defined _ER_WEAPONS_INCLUDED
    #endinput
#endif
#define _ER_WEAPONS_INCLUDED

stock ER_SaveCurrentWeapons(playerid)
{
    for(new slot; slot < MAX_WEAPON_SLOTS; slot++)
    {
        new weapon, ammo;
        GetPlayerWeaponData(playerid, slot, weapon, ammo);
        PlayerInfo[playerid][pPlayerWeapons][slot] = weapon;
    }
    return 1;
}

stock ER_GiveSavedWeapons(playerid)
{
    ResetPlayerWeapons(playerid);
    for(new slot; slot < MAX_WEAPON_SLOTS; slot++)
    {
        if(PlayerInfo[playerid][pPlayerWeapons][slot] > 0) GivePlayerWeapon(playerid, PlayerInfo[playerid][pPlayerWeapons][slot], 99999);
    }
    return 1;
}

stock ER_ClearSavedWeapons(playerid)
{
    ResetPlayerWeapons(playerid);
    for(new slot; slot < MAX_WEAPON_SLOTS; slot++) PlayerInfo[playerid][pPlayerWeapons][slot] = 0;
    return 1;
}
