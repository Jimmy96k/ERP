#if defined _ER_RELOAD_INCLUDED
    #endinput
#endif
#define _ER_RELOAD_INCLUDED

stock ER_DoReloadSystem(playerid, const system[])
{
    if(!strcmp(system, "businesses", true) || !strcmp(system, "business", true)) { ER_LoadBusinesses(); ER_LoadGasPumps(); ER_LoadBusinessATMs(); return ER_Send(playerid, COLOR_GREEN, "Businesses, gas pumps, and ATMs reloaded."); }
    if(!strcmp(system, "vehicles", true) || !strcmp(system, "vehicle", true) || !strcmp(system, "cars", true)) { ER_LoadVehicles(); ER_LoadDealershipDisplays(); return ER_Send(playerid, COLOR_GREEN, "Vehicles and dealership displays reloaded."); }
    if(!strcmp(system, "houses", true) || !strcmp(system, "house", true)) { ER_LoadHouses(); return ER_Send(playerid, COLOR_GREEN, "Houses reloaded."); }
    if(!strcmp(system, "doors", true) || !strcmp(system, "door", true)) { ER_LoadDoors(); return ER_Send(playerid, COLOR_GREEN, "Doors reloaded."); }
    if(!strcmp(system, "jobs", true) || !strcmp(system, "job", true)) { ER_LoadJobs(); return ER_Send(playerid, COLOR_GREEN, "Jobs reloaded."); }
    if(!strcmp(system, "matruns", true) || !strcmp(system, "matrun", true) || !strcmp(system, "materials", true)) { ER_LoadMatruns(); return ER_Send(playerid, COLOR_GREEN, "Material runs reloaded."); }
    if(!strcmp(system, "gates", true) || !strcmp(system, "gate", true)) { ER_LoadGates(); return ER_Send(playerid, COLOR_GREEN, "Gates reloaded."); }
    if(!strcmp(system, "points", true) || !strcmp(system, "point", true)) { ER_LoadPoints(); return ER_Send(playerid, COLOR_GREEN, "Capture points reloaded."); }
    if(!strcmp(system, "turfs", true) || !strcmp(system, "turf", true)) { ER_LoadTurfs(); return ER_Send(playerid, COLOR_GREEN, "Turfs reloaded."); }
    if(!strcmp(system, "families", true) || !strcmp(system, "family", true)) { ER_LoadFamilies(); return ER_Send(playerid, COLOR_GREEN, "Families reloaded."); }
    if(!strcmp(system, "factions", true) || !strcmp(system, "faction", true)) { ER_LoadFactions(); return ER_Send(playerid, COLOR_GREEN, "Factions reloaded."); }
    if(!strcmp(system, "radio", true) || !strcmp(system, "radios", true) || !strcmp(system, "stations", true)) { ER_LoadRadioStations(); return ER_Send(playerid, COLOR_GREEN, "Radio stations reloaded."); }
    if(!strcmp(system, "audio", true) || !strcmp(system, "audiozones", true) || !strcmp(system, "audiozones", true)) { ER_LoadAudioZones(); return ER_Send(playerid, COLOR_GREEN, "Audio zones reloaded."); }
    if(!strcmp(system, "streams", true) || !strcmp(system, "audiostreams", true)) { ER_LoadAudioStreams(); return ER_Send(playerid, COLOR_GREEN, "Audio streams reloaded."); }
    if(!strcmp(system, "servercore", true) || !strcmp(system, "core", true)) { ER_LoadServerCore(); return ER_Send(playerid, COLOR_GREEN, "ServerCore reloaded."); }
    if(!strcmp(system, "gas", true) || !strcmp(system, "gaspumps", true) || !strcmp(system, "pumps", true)) { ER_LoadGasPumps(); return ER_Send(playerid, COLOR_GREEN, "Gas pumps reloaded."); }
    if(!strcmp(system, "atms", true) || !strcmp(system, "atm", true)) { ER_LoadBusinessATMs(); return ER_Send(playerid, COLOR_GREEN, "Business ATMs reloaded."); }
    if(!strcmp(system, "dealerships", true) || !strcmp(system, "dealership", true) || !strcmp(system, "dealershipvehicles", true)) { ER_LoadDealershipDisplays(); return ER_Send(playerid, COLOR_GREEN, "Dealership displays reloaded."); }
    if(!strcmp(system, "hospitals", true) || !strcmp(system, "hospital", true)) { ER_LoadHospitals(); return ER_Send(playerid, COLOR_GREEN, "Hospitals reloaded."); }
    if(!strcmp(system, "hospitalbeds", true) || !strcmp(system, "beds", true)) { ER_LoadHospitalBeds(); return ER_Send(playerid, COLOR_GREEN, "Hospital beds reloaded."); }
    if(!strcmp(system, "weapons", true) || !strcmp(system, "weaponcosts", true) || !strcmp(system, "weapon_material_costs", true)) { ER_LoadWeaponMaterialCosts(); return ER_Send(playerid, COLOR_GREEN, "Weapon material costs reloaded."); }
    if(!strcmp(system, "toys", true) || !strcmp(system, "toycatalog", true)) { ER_LoadToyCatalog(); return ER_Send(playerid, COLOR_GREEN, "Toy catalog reloaded."); }

    if(!strcmp(system, "all", true))
    {
        ER_LoadServerCore();
        ER_LoadBusinesses();
        ER_LoadGasPumps();
        ER_LoadBusinessATMs();
        ER_LoadVehicles();
        ER_LoadDealershipDisplays();
        ER_LoadHouses();
        ER_LoadDoors();
        ER_LoadJobs();
        ER_LoadMatruns();
        ER_LoadGates();
        ER_LoadPoints();
        ER_LoadTurfs();
        ER_LoadFamilies();
        ER_LoadFactions();
        ER_LoadRadioStations();
        ER_LoadAudioZones();
        ER_LoadAudioStreams();
        ER_LoadHospitals();
        ER_LoadHospitalBeds();
        ER_LoadWeaponMaterialCosts();
        ER_LoadToyCatalog();
        return ER_Send(playerid, COLOR_GREEN, "All supported systems reloaded.");
    }
    return ER_Send(playerid, COLOR_GREY, "USAGE: /reload [businesses/vehicles/houses/doors/jobs/matruns/gates/points/turfs/families/factions/radio/audio/streams/servercore/gas/atms/dealerships/hospitals/beds/weapons/toys/all]");
}

CMD:reload(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(isnull(params))
    {
        ShowPlayerDialog(playerid, DIALOG_RELOAD_MAIN, DIALOG_STYLE_LIST, "Reload Systems", "Businesses\nVehicles\nHouses\nDoors\nJobs\nMaterial Runs\nGates\nPoints\nTurfs\nFamilies\nFactions\nRadio Stations\nAudio Zones\nAudio Streams\nServerCore\nGas Pumps\nBusiness ATMs\nDealership Displays\nHospitals\nHospital Beds\nWeapon Material Costs\nToy Catalog\nReload All", "Reload", "Cancel");
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
        case 1: return ER_DoReloadSystem(playerid, "vehicles");
        case 2: return ER_DoReloadSystem(playerid, "houses");
        case 3: return ER_DoReloadSystem(playerid, "doors");
        case 4: return ER_DoReloadSystem(playerid, "jobs");
        case 5: return ER_DoReloadSystem(playerid, "matruns");
        case 6: return ER_DoReloadSystem(playerid, "gates");
        case 7: return ER_DoReloadSystem(playerid, "points");
        case 8: return ER_DoReloadSystem(playerid, "turfs");
        case 9: return ER_DoReloadSystem(playerid, "families");
        case 10: return ER_DoReloadSystem(playerid, "factions");
        case 11: return ER_DoReloadSystem(playerid, "radio");
        case 12: return ER_DoReloadSystem(playerid, "audio");
        case 13: return ER_DoReloadSystem(playerid, "streams");
        case 14: return ER_DoReloadSystem(playerid, "servercore");
        case 15: return ER_DoReloadSystem(playerid, "gas");
        case 16: return ER_DoReloadSystem(playerid, "atms");
        case 17: return ER_DoReloadSystem(playerid, "dealerships");
        case 18: return ER_DoReloadSystem(playerid, "hospitals");
        case 19: return ER_DoReloadSystem(playerid, "beds");
        case 20: return ER_DoReloadSystem(playerid, "weapons");
        case 21: return ER_DoReloadSystem(playerid, "toys");
        case 22: return ER_DoReloadSystem(playerid, "all");
    }
    return 1;
}
