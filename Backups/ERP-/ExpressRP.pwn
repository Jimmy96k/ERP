#pragma dynamic 65536
#pragma warning disable 214

#include <a_samp>

new bool:ER_FirstSpawned[MAX_PLAYERS];
#pragma unused ER_FirstSpawned
//  INCLUDES
#include <a_mysql>
#include <sscanf2>
#include <Pawn.CMD>
#include <streamer>
#include <foreach>
#include <whirlpool>
//  CORE
#include "includes/core/defines.pwn"
#include "includes/core/colors.pwn"
#include "includes/core/enums.pwn"
#include "includes/core/utils.pwn"
#include "includes/core/mysql.pwn"
#include "includes/core/servercore.pwn"
#include "includes/core/accounts.pwn"
#include "includes/core/savechars.pwn"
//  SYSTEMS
#include "includes/systems/tutorial.pwn"
#include "includes/systems/help.pwn"
#include "includes/systems/chat.pwn"
#include "includes/systems/phone.pwn"
#include "includes/systems/radio.pwn"
#include "includes/systems/inventory.pwn"
#include "includes/systems/weapons.pwn"
#include "includes/systems/hospitals.pwn"
#include "includes/systems/families.pwn"
#include "includes/systems/factions.pwn"
#include "includes/systems/jobs.pwn"
#include "includes/systems/factioncmds.pwn"
#include "includes/systems/vehicles.pwn"
#include "includes/systems/stats.pwn"
#include "includes/systems/death.pwn"
#include "includes/systems/gates.pwn"
#include "includes/systems/points.pwn"
#include "includes/systems/turfs.pwn"
#include "includes/systems/businesses.pwn"
#include "includes/systems/gas.pwn"
#include "includes/systems/houses.pwn"
#include "includes/systems/doors.pwn"
#include "includes/systems/admin.pwn"
#include "includes/systems/toys.pwn"
#include "includes/systems/reload.pwn"
//  MAPS
#include "includes/maps/pershing_square.pwn" 	// Pershing Square MAP
#include "includes/maps/cityhall_2018.pwn" 		// City Hall MAP
#include "includes/maps/rehab_community.pwn" 	// Rehab_Community MAP GROOVE
#include "includes/maps/restoran.pwn"           // Restaurant MAP GROOVE

//
main() { }

public OnGameModeInit()
{
    for(new _rv; _rv < MAX_VEHICLES; _rv++) ER_VehicleRadioStation[_rv] = -1;

    SetGameModeText("Express Roleplay - Gaming");
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
    UsePlayerPedAnims();
    ManualVehicleEngineAndLights();
    EnableStuntBonusForAll(0);
    DisableInteriorEnterExits();
    ER_CreateLoginTextDraws();

    ER_MySQLConnect();
	//  CORE
    ER_LoadServerCore();
	//  SYSTEMS
	ER_LoadHospitals();
    ER_LoadHospitalBeds();
    ER_LoadAudioStreams();
    ER_LoadWeaponMaterialCosts();
    ER_LoadBusinesses();
    ER_LoadGasPumps();
    ER_LoadHouses();
    ER_LoadDoors();
    ER_LoadToyCatalog();
    ER_LoadFamilies();
    ER_LoadFactions();
    ER_LoadJobs();
    ER_LoadGates();
    ER_LoadPoints();
    ER_LoadTurfs();
    ER_LoadVehicles();
    ER_LoadDealershipDisplays();
	//  MAPS
	LoadPershingSquareMap();	// Pershing Square MAP
    LoadCityHall2018Map();		// City Hall MAP
    LoadRehabCommunityMap();	// Rehab Community MAP
    LoadRestoranObjects();		// Restaurant MAP GROOVE
    //
    return 1;
}

public OnGameModeExit()
{
    foreach(new i : Player)
    {
        if(PlayerInfo[i][pLoggedIn])
        {
            SetPVarInt(i, "SyncSaveOnExit", 1);
            ER_SaveLastPosition(i, true);
            ER_SaveCharacter(i);
            DeletePVar(i, "SyncSaveOnExit");
        }
    }
    ER_MySQLClose();
    return 1;
}

public OnPlayerConnect(playerid)
{
    ER_ClearChat(playerid);
    ER_ClearGunSaleOffer(playerid);

    ER_ResetPlayer(playerid);
    TogglePlayerSpectating(playerid, true);
    ER_ShowLoginScreen(playerid);
    ER_ShowLoginOrRegister(playerid);
    //  MAPS
    
    RemovePSMapForPlayer(playerid); 	// Pershing Square MAP
    RemoveRehabCommunityMap(playerid);				// Rehab Community MAP
    RemoveRestoranBuildings(playerid);              // Restaurant MAP GROOVE
    
    return 1;
}

public OnPlayerUpdate(playerid)
{
    ER_UpdatePlayerAudioZone(playerid);
    ER_SyncPhysicalMoney(playerid);
    ER_UpdateDraggedPlayer(playerid);

    if(PlayerInfo[playerid][pLoggedIn] && PlayerInfo[playerid][pTutorial] == 1 && !PlayerInfo[playerid][pInjured] && !PlayerInfo[playerid][pHospitalized])
    {
        GetPlayerPos(playerid, PlayerInfo[playerid][pSpawnX], PlayerInfo[playerid][pSpawnY], PlayerInfo[playerid][pSpawnZ]);
        GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pSpawnA]);
        PlayerInfo[playerid][pSpawnInt] = GetPlayerInterior(playerid);
        PlayerInfo[playerid][pSpawnVW] = GetPlayerVirtualWorld(playerid);
    }
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    ER_SaveLastPosition(playerid);
    ER_SaveCharacter(playerid);
    ER_ClearPhoneState(playerid);
    ER_ClearHeldConsumable(playerid);
    ER_CancelBankATMAction(playerid);
    ER_ClearBankCashBag(playerid);
    ER_ClearFamilyBeacon(playerid);
    ER_ReleaseHospitalBed(playerid);
    ER_ClearDisconnectedGunOffers(playerid);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(PlayerInfo[playerid][pLoggedIn])
    {
        SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
        SetPlayerArmour(playerid, PlayerInfo[playerid][pArmor]);
        ER_GiveSavedWeapons(playerid);
    }
    return 1;
}

public OnPlayerText(playerid, text[])
{
    if(!PlayerInfo[playerid][pLoggedIn]) return 0;
    if(ER_PhoneText(playerid, text)) return 0;
    if(ER_HandleVehicleWindowText(playerid, text)) return 0;
    ER_LocalChat(playerid, text, CHAT_RANGE_NORMAL);
    return 0;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    ER_CancelBankATMAction(playerid);
    ER_ClearBankCashBag(playerid);
    ER_StartInjured(playerid, killerid, reason);
    SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin],
        PlayerInfo[playerid][pInjuredX], PlayerInfo[playerid][pInjuredY], PlayerInfo[playerid][pInjuredZ], PlayerInfo[playerid][pInjuredA],
        0, 0, 0, 0, 0, 0);
    SpawnPlayer(playerid);
    SetTimerEx("ER_ReapplyInjuredAfterSpawn", 400, false, "i", playerid);
    return 1;
}


public OnVehicleSpawn(vehicleid)
{
    ER_ResetVehicleRadio(vehicleid);

    ER_OnVehicleSpawn(vehicleid);
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    new bid = GetPVarInt(playerid, "TrackBusiness");
    if(bid > 0)
    {
        new idx = ER_FindBusinessIndexBySQLID(bid);
        if(idx != -1 && IsPlayerInRangeOfPoint(playerid, 8.0, Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ]))
        {
            DisablePlayerCheckpoint(playerid);
            DeletePVar(playerid, "TrackBusiness");
            ER_Send(playerid, COLOR_GREEN, "You have arrived at your business.");
            return 1;
        }
    }
    new vid = GetPVarInt(playerid, "TrackVehicle");
    if(vid > 0)
    {
        new vidx = ER_FindVehicleBySQLID(vid);
        if(vidx != -1)
        {
            new Float:vx = VehicleInfo[vidx][vX], Float:vy = VehicleInfo[vidx][vY], Float:vz = VehicleInfo[vidx][vZ];
            if(VehicleInfo[vidx][vSpawnedID] != INVALID_VEHICLE_ID && VehicleInfo[vidx][vSpawnedID] != 0)
            {
                GetVehiclePos(VehicleInfo[vidx][vSpawnedID], vx, vy, vz);
            }
            if(IsPlayerInRangeOfPoint(playerid, 8.0, vx, vy, vz))
            {
                DisablePlayerCheckpoint(playerid);
                DeletePVar(playerid, "TrackVehicle");
                if(VehicleTrackIcon[playerid] != -1) { DestroyDynamicMapIcon(VehicleTrackIcon[playerid]); VehicleTrackIcon[playerid] = -1; }
                ER_Send(playerid, COLOR_GREEN, "You have arrived at the tracked vehicle.");
                return 1;
            }
        }
    }
    new atmid = GetPVarInt(playerid, "TrackATM");
    if(atmid > 0)
    {
        new aidx = ER_FindATMIndexBySQLID(atmid);
        if(aidx != -1 && IsPlayerInRangeOfPoint(playerid, 6.0, BusinessATMs[aidx][atmX], BusinessATMs[aidx][atmY], BusinessATMs[aidx][atmZ]))
        {
            DisablePlayerCheckpoint(playerid);
            DeletePVar(playerid, "TrackATM");
            ER_Send(playerid, COLOR_GREEN, "You have arrived at the ATM.");
            return 1;
        }
    }
    new hid = GetPVarInt(playerid, "TrackHouse");
    if(hid > 0)
    {
        new hidx = ER_FindHouseIndexBySQLID(hid);
        if(hidx != -1 && IsPlayerInRangeOfPoint(playerid, 8.0, Houses[hidx][hExtX], Houses[hidx][hExtY], Houses[hidx][hExtZ]))
        {
            DisablePlayerCheckpoint(playerid);
            DeletePVar(playerid, "TrackHouse");
            ER_Send(playerid, COLOR_GREEN, "You have arrived at your house.");
            return 1;
        }
    }
    return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(ER_OnPlayerEnterAudioArea(playerid, areaid)) return 1;
    return 1;
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    if(ER_OnPlayerLeaveAudioArea(playerid, areaid)) return 1;
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(ER_AccountDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_ServerCoreDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_TutorialDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_AdminDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_HospitalDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_BusinessDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_GasDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_HouseDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_DoorDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_ToysDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_ReloadDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_FamilyDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_FactionDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_AudioDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_VehicleDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_WeaponDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_JobDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_GateDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_PointDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    if(ER_TurfDialog(playerid, dialogid, response, listitem, inputtext)) return 1;
    return 0;
}


public OnPlayerRequestClass(playerid, classid)
{
	#pragma unused classid
	if(PlayerInfo[playerid][pLoggedIn])
	{
		ER_SpawnCharacter(playerid);
	}
	else
	{
		TogglePlayerSpectating(playerid, true);
		ER_ShowLoginScreen(playerid);
	}
	return 0;
}


public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
        if(ER_OnBusinessVehicleEntered(playerid, GetPlayerVehicleID(playerid))) return 1;
        if(ER_OnJobVehicleSeatEntered(playerid, GetPlayerVehicleID(playerid))) return 1;
        ER_OnVehicleSeatEntered(playerid, GetPlayerVehicleID(playerid));
    }
    if(oldstate == PLAYER_STATE_DRIVER || oldstate == PLAYER_STATE_PASSENGER)
    {
        ER_OnJobVehicleSeatExited(playerid, 0);
        ER_OnVehicleSeatExited(playerid, 0);
    }
    return 1;
}


public OnPlayerExitVehicle(playerid, vehicleid)
{
    ER_OnJobVehicleSeatExited(playerid, vehicleid);
    ER_OnVehicleSeatExited(playerid, vehicleid);
    return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(((newkeys & KEY_ACTION) && !(oldkeys & KEY_ACTION)) || ((newkeys & KEY_FIRE) && !(oldkeys & KEY_FIRE)))
    {
        if(ER_HandleHeldConsumableKey(playerid)) return 1;
    }
    return 1;
}


public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if(ER_OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ)) return 1;
    return 1;
}


public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(ER_OnBizEditObj(playerid, objectid, response, x, y, z, rx, ry, rz)) return 1;
    if(ER_OnGateObjectEdited(playerid, objectid, response, x, y, z, rx, ry, rz)) return 1;
    return 1;
}


public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    #pragma unused params
    #pragma unused flags
    if(result == -1) return ER_ShowUnknownCommand(playerid, cmd);
    return 1;
}
