#if defined _ER_RELOAD_INCLUDED
    #endinput
#endif
#define _ER_RELOAD_INCLUDED

stock ER_DoReloadSystem(playerid, const system[])
{
    if(!strcmp(system, "businesses", true) || !strcmp(system, "business", true)) { ER_LoadBusinesses(); return ER_Send(playerid, COLOR_GREEN, "Businesses reloaded."); }
    if(!strcmp(system, "houses", true) || !strcmp(system, "house", true)) { ER_LoadHouses(); return ER_Send(playerid, COLOR_GREEN, "Houses reloaded."); }
    if(!strcmp(system, "doors", true) || !strcmp(system, "door", true)) { ER_LoadDoors(); return ER_Send(playerid, COLOR_GREEN, "Doors reloaded."); }
    if(!strcmp(system, "families", true) || !strcmp(system, "family", true)) { ER_LoadFamilies(); return ER_Send(playerid, COLOR_GREEN, "Families reloaded."); }
    if(!strcmp(system, "factions", true) || !strcmp(system, "faction", true)) { ER_LoadFactions(); return ER_Send(playerid, COLOR_GREEN, "Factions reloaded."); }
    if(!strcmp(system, "radio", true) || !strcmp(system, "radios", true)) { ER_LoadRadioStations(); return ER_Send(playerid, COLOR_GREEN, "Radio stations reloaded."); }
    if(!strcmp(system, "audio", true) || !strcmp(system, "audiozones", true)) { ER_LoadAudioZones(); return ER_Send(playerid, COLOR_GREEN, "Audio zones reloaded."); }
    if(!strcmp(system, "servercore", true) || !strcmp(system, "core", true)) { ER_LoadServerCore(); return ER_Send(playerid, COLOR_GREEN, "ServerCore reloaded."); }
    if(!strcmp(system, "all", true)) { ER_LoadServerCore(); ER_LoadBusinesses(); ER_LoadHouses(); ER_LoadDoors(); ER_LoadFamilies(); ER_LoadFactions(); ER_LoadRadioStations(); ER_LoadAudioZones(); return ER_Send(playerid, COLOR_GREEN, "All supported systems reloaded."); }
    return ER_Send(playerid, COLOR_GREY, "USAGE: /reload [businesses/houses/doors/families/factions/radio/audio/servercore/all]");
}
CMD:reload(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(isnull(params))
    {
        ShowPlayerDialog(playerid, DIALOG_RELOAD_MAIN, DIALOG_STYLE_LIST, "Reload Systems", "Businesses\nHouses\nDoors\nFamilies\nFactions\nRadio Stations\nAudio Zones\nServerCore\nReload All", "Reload", "Cancel");
        return 1;
    }
    return ER_DoReloadSystem(playerid, params);
}
stock ER_ReloadDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    #pragma unused inputtext
    if(dialogid != DIALOG_RELOAD_MAIN) return 0;
    if(!response) return 1;
    switch(listitem)
    {
        case 0: return ER_DoReloadSystem(playerid, "businesses");
        case 1: return ER_DoReloadSystem(playerid, "houses");
        case 2: return ER_DoReloadSystem(playerid, "doors");
        case 3: return ER_DoReloadSystem(playerid, "families");
        case 4: return ER_DoReloadSystem(playerid, "factions");
        case 5: return ER_DoReloadSystem(playerid, "radio");
        case 6: return ER_DoReloadSystem(playerid, "audio");
        case 7: return ER_DoReloadSystem(playerid, "servercore");
        case 8: return ER_DoReloadSystem(playerid, "all");
    }
    return 1;
}
