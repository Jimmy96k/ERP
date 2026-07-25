#if defined _ER_DEATH_INCLUDED
    #endinput
#endif
#define _ER_DEATH_INCLUDED

new InjuredTimer[MAX_PLAYERS];
new HospitalTimer[MAX_PLAYERS];

forward ER_ReapplyInjuredAfterSpawn(playerid);
forward ER_SendInjuredDeathToHospital(playerid);
forward ER_InjuredTick(playerid);
forward ER_TryAssignHospitalBed(playerid, hospitalid);
forward ER_HospitalBedStreamReady(playerid, bed);
forward ER_HospitalTreatmentTick(playerid);
forward ER_ReleaseFromHospital(playerid);

stock ER_IsEMSNearInjured(patientid, Float:range = 8.0)
{
    foreach(new i : Player)
    {
        if(i == patientid) continue;
        if(!IsPlayerConnected(i) || !PlayerInfo[i][pLoggedIn]) continue;
        if(!ER_FactionCommandAllowed(i, 2)) continue;
        if(GetPlayerInterior(i) != GetPlayerInterior(patientid)) continue;
        if(GetPlayerVirtualWorld(i) != GetPlayerVirtualWorld(patientid)) continue;
        if(ER_IsPlayerNearPlayer(i, patientid, range)) return 1;
    }
    return 0;
}

stock ER_SaveInjuredPosition(playerid, bool:syncsave = false)
{
    if(!PlayerInfo[playerid][pLoggedIn] || PlayerInfo[playerid][pID] <= 0) return 0;

    GetPlayerPos(playerid, PlayerInfo[playerid][pInjuredX], PlayerInfo[playerid][pInjuredY], PlayerInfo[playerid][pInjuredZ]);
    GetPlayerFacingAngle(playerid, PlayerInfo[playerid][pInjuredA]);
    PlayerInfo[playerid][pInjuredInt] = GetPlayerInterior(playerid);
    PlayerInfo[playerid][pInjuredVW] = GetPlayerVirtualWorld(playerid);

    new q[384];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `injured`=1,`hospitalized`=0,`injured_x`=%f,`injured_y`=%f,`injured_z`=%f,`injured_a`=%f,`injured_int`=%d,`injured_vw`=%d WHERE `id`=%d",
        PlayerInfo[playerid][pInjuredX], PlayerInfo[playerid][pInjuredY], PlayerInfo[playerid][pInjuredZ], PlayerInfo[playerid][pInjuredA], PlayerInfo[playerid][pInjuredInt], PlayerInfo[playerid][pInjuredVW], PlayerInfo[playerid][pID]);
    if(syncsave) mysql_query(MainPipeline, q, false);
    else mysql_tquery(MainPipeline, q);
    return 1;
}

stock ER_ApplyInjuredState(playerid)
{
    SetPlayerInterior(playerid, PlayerInfo[playerid][pInjuredInt]);
    SetPlayerVirtualWorld(playerid, PlayerInfo[playerid][pInjuredVW]);
    SetPlayerPos(playerid, PlayerInfo[playerid][pInjuredX], PlayerInfo[playerid][pInjuredY], PlayerInfo[playerid][pInjuredZ]);
    SetPlayerFacingAngle(playerid, PlayerInfo[playerid][pInjuredA]);
    SetPlayerHealth(playerid, 35.0);

    // No hard screen/control lock. Keep the player visually downed while they wait for EMS or /accept death.
    TogglePlayerControllable(playerid, true);
    ClearAnimations(playerid);
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 1, 0, 1);

    GameTextForPlayer(playerid, "~r~INJURED~n~~w~WAITING FOR EMS OR /ACCEPT DEATH", 5000, 3);
    return 1;
}

stock ER_StartInjured(playerid, killerid, reason)
{
    #pragma unused killerid
    #pragma unused reason

    if(PlayerInfo[playerid][pInjured]) return 1;

    PlayerInfo[playerid][pInjured] = 1;
    PlayerInfo[playerid][pHospitalized] = 0;
    PlayerInfo[playerid][pHospitalID] = -1;
    PlayerInfo[playerid][pHospitalBed] = -1;

    ER_SaveInjuredPosition(playerid);
    ER_ApplyInjuredState(playerid);

    if(InjuredTimer[playerid]) KillTimer(InjuredTimer[playerid]);
    InjuredTimer[playerid] = SetTimerEx("ER_InjuredTick", ServerCore[scDeathTickMS], true, "i", playerid);
    return 1;
}

public ER_ReapplyInjuredAfterSpawn(playerid)
{
    if(!IsPlayerConnected(playerid) || !PlayerInfo[playerid][pInjured]) return 0;
    return ER_ApplyInjuredState(playerid);
}

public ER_SendInjuredDeathToHospital(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    // Still injured means this was a true second death while downed.
    // Move straight to hospital instead of reapplying injury animation.
    if(PlayerInfo[playerid][pInjured])
    {
        ER_Send(playerid, COLOR_LIGHTBLUE, "You have died from your injuries and were sent to the hospital.");
        return ER_SendToHospital(playerid, 0);
    }

    return 1;
}

public ER_InjuredTick(playerid)
{
    if(!IsPlayerConnected(playerid) || !PlayerInfo[playerid][pInjured]) return 0;

    new Float:h;
    GetPlayerHealth(playerid, h);

    if(ER_IsEMSNearInjured(playerid, 8.0))
    {
        if(h < 2.0) SetPlayerHealth(playerid, 2.0);
        else if(h > 35.0) SetPlayerHealth(playerid, 35.0);

        ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 1, 0, 1);
        GameTextForPlayer(playerid, "~b~EMS ON SCENE~n~~w~INJURY TIMER PAUSED", ServerCore[scDeathTickMS] + 500, 3);
        return 1;
    }

    if(h > 35.0) h = 35.0;
    h -= ServerCore[scDeathHPDecrease];

    if(h <= 1.0)
    {
        return ER_SendToHospital(playerid, 0);
    }

    SetPlayerHealth(playerid, h);
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.1, 1, 0, 0, 1, 0, 1);
    GameTextForPlayer(playerid, "~r~INJURED~n~~w~WAITING FOR EMS OR /ACCEPT DEATH", ServerCore[scDeathTickMS] + 500, 3);
    return 1;
}

stock ER_AcceptBusinessInvitation(playerid);

CMD:accept(playerid, params[])
{
    new what[24];
    if(sscanf(params, "s[24]", what)) return ER_Send(playerid, COLOR_GREY, "USAGE: /accept [death/ems/family/faction/crew/division/invitation/gun/repair/refill/tune]");
    if(!strcmp(what, "family", true)) return ER_AcceptFamilyInvite(playerid);
    if(!strcmp(what, "faction", true)) return ER_AcceptFactionInvite(playerid);
    if(!strcmp(what, "crew", true)) return ER_AcceptCrewInvite(playerid);
    if(!strcmp(what, "division", true)) return ER_AcceptDivisionInvite(playerid);
    if(!strcmp(what, "invitation", true) || !strcmp(what, "business", true)) return ER_AcceptBusinessInvitation(playerid);
    if(!strcmp(what, "gun", true)) return ER_AcceptGunOffer(playerid);
    if(!strcmp(what, "repair", true)) return ER_AcceptRepairOffer(playerid);
    if(!strcmp(what, "refill", true)) return ER_AcceptRefillOffer(playerid);
    if(!strcmp(what, "tune", true)) return ER_AcceptTuneOffer(playerid);
    if(!strcmp(what, "ems", true)) return ER_AcceptEMSCall(playerid);
    if(!strcmp(what, "death", true))
    {
        if(!PlayerInfo[playerid][pInjured]) return ER_Send(playerid, COLOR_GREY, "You are not injured.");
        ER_ClearSavedWeapons(playerid);
        return ER_SendToHospital(playerid, 0);
    }
    return ER_Send(playerid, COLOR_GREY, "USAGE: /accept [death/ems/family/faction/crew/division/invitation/gun/repair/refill/tune]");
}

stock ER_GetHospitalTreatmentTime(playerid, hospitalid, deliveredByEMS)
{
    #pragma unused hospitalid

    // EMS-delivered patients should be placed in a hospital bed without a treatment timer.
    if(deliveredByEMS) return 0;

    if(PlayerInfo[playerid][pWantedLevel] > 0) return 60;

    new t = ER_GetVipHospitalTime(playerid);
    if(t < 0) t = 0;
    return t;
}

stock ER_FindEMSDeliveryHosp(playerid, Float:range = 8.0)
{
    for(new i; i < HospitalCount; i++)
    {
        if(!Hospitals[i][hEnabled]) continue;
        if(GetPlayerInterior(playerid) != Hospitals[i][hEMSInt]) continue;
        if(GetPlayerVirtualWorld(playerid) != Hospitals[i][hEMSVW]) continue;
        if(IsPlayerInRangeOfPoint(playerid, range, Hospitals[i][hEMSX], Hospitals[i][hEMSY], Hospitals[i][hEMSZ]))
            return Hospitals[i][hSQLID];
    }
    return -1;
}

stock ER_SendToSpecificHospital(playerid, hospitalid, deliveredByEMS)
{
    if(InjuredTimer[playerid]) KillTimer(InjuredTimer[playerid]);
    InjuredTimer[playerid] = 0;

    PlayerInfo[playerid][pInjured] = 0;
    PlayerInfo[playerid][pDeliveredByEMS] = deliveredByEMS;

    TogglePlayerControllable(playerid, true);
    ClearAnimations(playerid);

    new hslot = ER_FindHospitalSlotByID(hospitalid);
    if(hslot == -1 || !Hospitals[hslot][hEnabled]) return ER_Send(playerid, COLOR_GREY, "Invalid hospital delivery point.");

    new bed = ER_FindFreeBed(hospitalid);
    if(bed == -1)
    {
        TogglePlayerSpectating(playerid, true);
        ER_Send(playerid, COLOR_LIGHTBLUE, "All beds at this hospital are currently occupied. Please wait while a bed becomes available.");
        SetTimerEx("ER_TryAssignHospitalBed", 5000, false, "ii", playerid, hospitalid);
        return 1;
    }

    return ER_PlacePlayerInHospitalBed(playerid, hospitalid, bed, deliveredByEMS);
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
    PlayerInfo[playerid][pHospitalBed] = bed;
    PlayerInfo[playerid][pHospitalID] = hospitalid;
    PlayerInfo[playerid][pHospitalized] = 1;
    PlayerInfo[playerid][pHospitalTime] = ER_GetHospitalTreatmentTime(playerid, hospitalid, deliveredByEMS);
    HospitalBeds[bed][hbOccupiedUntil] = gettime() + PlayerInfo[playerid][pHospitalTime];

    new fee;
    if(deliveredByEMS) fee = (PlayerInfo[playerid][pHospInsurance] == hospitalid) ? Hospitals[hslot][hEMSFeeInsured] : Hospitals[hslot][hEMSFee];
    else fee = (PlayerInfo[playerid][pHospInsurance] == hospitalid) ? Hospitals[hslot][hHospitalPriceInsured] : Hospitals[hslot][hHospitalPrice];
    if(fee < 0) fee = 0;
    PlayerInfo[playerid][pCash] -= fee;
    GivePlayerMoney(playerid, -fee);
    Hospitals[hslot][hSafeBalance] += fee;

    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `injured`=0,`hospitalized`=1,`hospital_id`=%d,`hospital_bed`=%d,`hospital_time`=%d WHERE `id`=%d", hospitalid, HospitalBeds[bed][hbSQLID], PlayerInfo[playerid][pHospitalTime], PlayerInfo[playerid][pID]);
    mysql_tquery(MainPipeline, q);

    SetPlayerInterior(playerid, HospitalBeds[bed][hbInt]);
    SetPlayerVirtualWorld(playerid, HospitalBeds[bed][hbVW]);
    Streamer_UpdateEx(playerid, HospitalBeds[bed][hbX], HospitalBeds[bed][hbY], HospitalBeds[bed][hbZ]);
    SetPlayerPos(playerid, HospitalBeds[bed][hbX], HospitalBeds[bed][hbY], HospitalBeds[bed][hbZ]);
    SetPlayerFacingAngle(playerid, HospitalBeds[bed][hbA]);
    SetPlayerHealth(playerid, 5.0);

    if(HospitalBeds[bed][hbCustomMap])
    {
        TogglePlayerControllable(playerid, false);
        SetTimerEx("ER_HospitalBedStreamReady", 1200, false, "ii", playerid, bed);
    }
    else
    {
        ER_HospitalBedStreamReady(playerid, bed);
    }

    new msg[160]; format(msg, sizeof(msg), "Medical: You have been charged $%d for your hospital treatment at %s.", fee, Hospitals[hslot][hName]);
    ER_Send(playerid, COLOR_LIGHTBLUE, msg);
    if(deliveredByEMS) ER_Send(playerid, COLOR_LIGHTBLUE, "You have been delivered to the hospital by EMS.");
    else if(PlayerInfo[playerid][pWantedLevel] > 0) ER_Send(playerid, COLOR_LIGHTBLUE, "You are wanted, so your hospital treatment will take longer.");
    else if(PlayerInfo[playerid][pPlayerVip] > 0) ER_Send(playerid, COLOR_LIGHTBLUE, "Your VIP healthcare reduces your hospital treatment time.");
    return 1;
}

public ER_HospitalBedStreamReady(playerid, bed)
{
    if(!IsPlayerConnected(playerid) || !PlayerInfo[playerid][pHospitalized]) return 0;
    if(bed < 0 || bed >= HospitalBedCount) return 0;

    SetPlayerInterior(playerid, HospitalBeds[bed][hbInt]);
    SetPlayerVirtualWorld(playerid, HospitalBeds[bed][hbVW]);
    Streamer_UpdateEx(playerid, HospitalBeds[bed][hbX], HospitalBeds[bed][hbY], HospitalBeds[bed][hbZ]);
    SetPlayerPos(playerid, HospitalBeds[bed][hbX], HospitalBeds[bed][hbY], HospitalBeds[bed][hbZ]);
    SetPlayerFacingAngle(playerid, HospitalBeds[bed][hbA]);
    TogglePlayerControllable(playerid, true);
    ClearAnimations(playerid);
    ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0, 1);

    if(PlayerInfo[playerid][pHospitalTime] <= 0)
    {
        return ER_ReleaseFromHospital(playerid);
    }

    if(HospitalTimer[playerid]) KillTimer(HospitalTimer[playerid]);
    HospitalTimer[playerid] = SetTimerEx("ER_HospitalTreatmentTick", 1000, false, "i", playerid);
    return 1;
}

public ER_HospitalTreatmentTick(playerid)
{
    if(!IsPlayerConnected(playerid) || !PlayerInfo[playerid][pHospitalized]) return 0;

    new bed = PlayerInfo[playerid][pHospitalBed];
    if(bed < 0 || bed >= HospitalBedCount) return ER_ReleaseFromHospital(playerid);

    // 0 means instant release. Positive values must be shown before decreasing.
    if(PlayerInfo[playerid][pHospitalTime] <= 0) return ER_ReleaseFromHospital(playerid);

    new Float:h;
    GetPlayerHealth(playerid, h);
    if(h < 100.0)
    {
        h += 2.5;
        if(h > 100.0) h = 100.0;
        SetPlayerHealth(playerid, h);
    }

    new text[96];
    format(text, sizeof(text), "~b~Hospital Treatment~n~~w~Time Left: ~r~%d~w~ seconds", PlayerInfo[playerid][pHospitalTime]);
    GameTextForPlayer(playerid, text, 1100, 3);

    ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0, 1);

    PlayerInfo[playerid][pHospitalTime]--;

    new q[160];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `hospital_time`=%d WHERE `id`=%d", PlayerInfo[playerid][pHospitalTime], PlayerInfo[playerid][pID]);
    mysql_tquery(MainPipeline, q);

    if(PlayerInfo[playerid][pHospitalTime] <= 0)
    {
        HospitalTimer[playerid] = SetTimerEx("ER_HospitalTreatmentTick", 1000, false, "i", playerid);
        return 1;
    }

    HospitalTimer[playerid] = SetTimerEx("ER_HospitalTreatmentTick", 1000, false, "i", playerid);
    return 1;
}

public ER_ReleaseFromHospital(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(HospitalTimer[playerid]) KillTimer(HospitalTimer[playerid]);
    HospitalTimer[playerid] = 0;

    ClearAnimations(playerid);
    TogglePlayerControllable(playerid, true);
    new Float:finalhp = ServerCore[scHospitalRespawnHP];
    if(PlayerInfo[playerid][pPlayerVip] >= 3) finalhp = 100.0;
    if(finalhp < 1.0) finalhp = 50.0;
    SetPlayerHealth(playerid, finalhp);

    PlayerInfo[playerid][pHospitalized] = 0;
    PlayerInfo[playerid][pHospitalTime] = 0;
    ER_ReleaseHospitalBed(playerid);

    new q[192];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `injured`=0,`hospitalized`=0,`hospital_time`=0,`hospital_id`=-1,`hospital_bed`=-1 WHERE `id`=%d", PlayerInfo[playerid][pID]);
    mysql_tquery(MainPipeline, q);

    ER_SaveLastPosition(playerid);
    ER_Send(playerid, COLOR_LIGHTBLUE, "You have been treated. You may now leave the hospital.");
    return 1;
}
