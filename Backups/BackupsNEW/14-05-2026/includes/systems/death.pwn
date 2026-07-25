#if defined _ER_DEATH_INCLUDED
    #endinput
#endif
#define _ER_DEATH_INCLUDED

new InjuredTimer[MAX_PLAYERS];
new HospitalTimer[MAX_PLAYERS];

stock ER_ApplyInjuredState(playerid)
{
    SetPlayerHealth(playerid, 50.0);
    TogglePlayerControllable(playerid, false);

    ClearAnimations(playerid);
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 1, 0, 1);

    GameTextForPlayer(playerid, "~r~INJURED~n~~w~WAITING FOR EMS TO ARRIVE...", 5000, 3);
    return 1;
}

stock ER_StartInjured(playerid, killerid, reason)
{
    #pragma unused killerid
    #pragma unused reason

    if(PlayerInfo[playerid][pInjured]) return 1;

    PlayerInfo[playerid][pInjured] = 1;
    PlayerInfo[playerid][pHospitalized] = 0;

    ER_ApplyInjuredState(playerid);

    if(InjuredTimer[playerid]) KillTimer(InjuredTimer[playerid]);
    InjuredTimer[playerid] = SetTimerEx("ER_InjuredTick", ServerCore[scDeathTickMS], true, "i", playerid);
    return 1;
}

forward ER_InjuredTick(playerid);
public ER_InjuredTick(playerid)
{
    if(!IsPlayerConnected(playerid) || !PlayerInfo[playerid][pInjured]) return 0;

    new Float:h;
    GetPlayerHealth(playerid, h);

    if(h > 50.0) h = 50.0;
    h -= ServerCore[scDeathHPDecrease];

    if(h <= 1.0)
    {
        return ER_SendToHospital(playerid, 0);
    }

    SetPlayerHealth(playerid, h);

    // Keep player locked on the ground. Some GTA animations/control states break after damage/desync.
    TogglePlayerControllable(playerid, false);
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 1, 0, 1);
    GameTextForPlayer(playerid, "~r~INJURED~n~~w~WAITING FOR EMS TO ARRIVE...", ServerCore[scDeathTickMS] + 500, 3);
    return 1;
}

CMD:accept(playerid, params[])
{
    new what[24];
    if(sscanf(params, "s[24]", what)) return ER_Send(playerid, COLOR_GREY, "USAGE: /accept [death/family/faction/crew/division]");
    if(!strcmp(what, "family", true)) return ER_AcceptFamilyInvite(playerid);
    if(!strcmp(what, "faction", true)) return ER_AcceptFactionInvite(playerid);
    if(!strcmp(what, "crew", true)) return ER_AcceptCrewInvite(playerid);
    if(!strcmp(what, "division", true)) return ER_AcceptDivisionInvite(playerid);
    if(!strcmp(what, "death", true))
    {
        if(!PlayerInfo[playerid][pInjured]) return ER_Send(playerid, COLOR_GREY, "You are not injured.");
        ER_ClearSavedWeapons(playerid);
        return ER_SendToHospital(playerid, 0);
    }
    return ER_Send(playerid, COLOR_GREY, "USAGE: /accept [death/family/faction/crew/division]");
}

stock ER_SendToHospital(playerid, deliveredByEMS)
{
    if(InjuredTimer[playerid]) KillTimer(InjuredTimer[playerid]);
    InjuredTimer[playerid] = 0;
    PlayerInfo[playerid][pInjured] = 0;
    PlayerInfo[playerid][pDeliveredByEMS] = deliveredByEMS;

    TogglePlayerControllable(playerid, true);
    ClearAnimations(playerid);

    new preferred = PlayerInfo[playerid][pHospInsurance];
    if(preferred == NO_HOSPITAL_INSURANCE || ER_FindHospitalSlotByID(preferred) == -1)
    {
        if(HospitalCount <= 0) return ER_Send(playerid, COLOR_GREY, "No hospitals loaded.");
        preferred = Hospitals[random(HospitalCount)][hSQLID];
    }
    new bed = ER_FindFreeBed(preferred);
    new hospitalSlot = ER_FindHospitalSlotByID(preferred);

    if(bed == -1 && PlayerInfo[playerid][pPlayerVip] >= ServerCore[scVipHospitalTransferMinLevel] && PlayerInfo[playerid][pTogFreeHospital])
    {
        new city = Hospitals[hospitalSlot][hCity];
        for(new h; h < HospitalCount; h++)
        {
            if(Hospitals[h][hSQLID] == preferred || Hospitals[h][hCity] != city) continue;
            bed = ER_FindFreeBed(Hospitals[h][hSQLID]);
            if(bed != -1)
            {
                new msg[160];
                format(msg, sizeof(msg), "Your preferred hospital is currently full. As a VIP patient, you have been transferred to %s within %s for immediate treatment.", Hospitals[h][hName], Hospitals[h][hCityName]);
                ER_Send(playerid, COLOR_LIGHTBLUE, msg);
                preferred = Hospitals[h][hSQLID];
                hospitalSlot = h;
                break;
            }
        }
    }

    if(bed == -1)
    {
        TogglePlayerSpectating(playerid, true);
        ER_Send(playerid, COLOR_LIGHTBLUE, "All beds at your assigned hospital are currently occupied. Please wait while a bed becomes available.");
        SetTimerEx("ER_TryAssignHospitalBed", 5000, false, "ii", playerid, preferred);
        return 1;
    }
    return ER_PlacePlayerInHospitalBed(playerid, preferred, bed, deliveredByEMS);
}

forward ER_TryAssignHospitalBed(playerid, hospitalid);
public ER_TryAssignHospitalBed(playerid, hospitalid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    new bed = ER_FindFreeBed(hospitalid);
    if(bed == -1)
    {
        SetTimerEx("ER_TryAssignHospitalBed", 5000, false, "ii", playerid, hospitalid);
        return 1;
    }
    TogglePlayerSpectating(playerid, false);
    return ER_PlacePlayerInHospitalBed(playerid, hospitalid, bed, PlayerInfo[playerid][pDeliveredByEMS]);
}

stock ER_PlacePlayerInHospitalBed(playerid, hospitalid, bed, deliveredByEMS)
{
    new hslot = ER_FindHospitalSlotByID(hospitalid);
    if(hslot == -1) return 0;
    HospitalBeds[bed][hbOccupiedBy] = playerid;
    HospitalBeds[bed][hbOccupiedUntil] = gettime() + ER_GetVipHospitalTime(playerid);
    PlayerInfo[playerid][pHospitalBed] = bed;
    PlayerInfo[playerid][pHospitalID] = hospitalid;
    PlayerInfo[playerid][pHospitalized] = 1;
    PlayerInfo[playerid][pHospitalTime] = ER_GetVipHospitalTime(playerid);

    new fee;
    if(deliveredByEMS) fee = (PlayerInfo[playerid][pHospInsurance] == hospitalid) ? Hospitals[hslot][hEMSFeeInsured] : Hospitals[hslot][hEMSFee];
    else fee = (PlayerInfo[playerid][pHospInsurance] == hospitalid) ? Hospitals[hslot][hHospitalPriceInsured] : Hospitals[hslot][hHospitalPrice];
    PlayerInfo[playerid][pCash] -= fee;
    GivePlayerMoney(playerid, -fee);
    Hospitals[hslot][hSafeBalance] += fee;

    SetPlayerInterior(playerid, HospitalBeds[bed][hbInt]);
    SetPlayerVirtualWorld(playerid, HospitalBeds[bed][hbVW]);
    SetPlayerPos(playerid, HospitalBeds[bed][hbX], HospitalBeds[bed][hbY], HospitalBeds[bed][hbZ]);
    SetPlayerFacingAngle(playerid, HospitalBeds[bed][hbA]);
    TogglePlayerControllable(playerid, false);
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 0, 0, 1);
    new msg[128]; format(msg, sizeof(msg), "Medical: You have been charged $%d for your hospital treatment at %s.", fee, Hospitals[hslot][hName]);
    ER_Send(playerid, COLOR_LIGHTBLUE, msg);
    HospitalTimer[playerid] = SetTimerEx("ER_ReleaseFromHospital", PlayerInfo[playerid][pHospitalTime] * 1000, false, "i", playerid);
    return 1;
}

forward ER_ReleaseFromHospital(playerid);
public ER_ReleaseFromHospital(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, true);
    SetPlayerHealth(playerid, ServerCore[scHospitalRespawnHP]);
    PlayerInfo[playerid][pHospitalized] = 0;
    ER_ReleaseHospitalBed(playerid);
    ER_Send(playerid, COLOR_LIGHTBLUE, "You have been treated. You may now leave the hospital.");
    return 1;
}
