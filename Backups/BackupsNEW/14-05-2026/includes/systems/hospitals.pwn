#if defined _ER_HOSPITALS_INCLUDED
    #endinput
#endif
#define _ER_HOSPITALS_INCLUDED

stock ER_LoadHospitals()
{
    mysql_tquery(MainPipeline, "SELECT * FROM `hospitals` WHERE `enabled`=1 ORDER BY `id` ASC", "ER_OnHospitalsLoad");
    return 1;
}

forward ER_OnHospitalsLoad();
public ER_OnHospitalsLoad()
{
    new rows; cache_get_row_count(rows); HospitalCount = 0;
    for(new r; r < rows && HospitalCount < MAX_HOSPITALS; r++)
    {
        cache_get_value_name_int(r, "id", Hospitals[HospitalCount][hSQLID]);
        cache_get_value_name(r, "name", Hospitals[HospitalCount][hName], 64);
        cache_get_value_name_int(r, "city", Hospitals[HospitalCount][hCity]);
        cache_get_value_name(r, "city_name", Hospitals[HospitalCount][hCityName], 32);
        cache_get_value_name_float(r, "insurance_x", Hospitals[HospitalCount][hInsuranceX]);
        cache_get_value_name_float(r, "insurance_y", Hospitals[HospitalCount][hInsuranceY]);
        cache_get_value_name_float(r, "insurance_z", Hospitals[HospitalCount][hInsuranceZ]);
        cache_get_value_name_int(r, "insurance_int", Hospitals[HospitalCount][hInsuranceInt]);
        cache_get_value_name_int(r, "insurance_vw", Hospitals[HospitalCount][hInsuranceVW]);
        cache_get_value_name_float(r, "ems_x", Hospitals[HospitalCount][hEMSX]);
        cache_get_value_name_float(r, "ems_y", Hospitals[HospitalCount][hEMSY]);
        cache_get_value_name_float(r, "ems_z", Hospitals[HospitalCount][hEMSZ]);
        cache_get_value_name_int(r, "ems_int", Hospitals[HospitalCount][hEMSInt]);
        cache_get_value_name_int(r, "ems_vw", Hospitals[HospitalCount][hEMSVW]);
        cache_get_value_name_int(r, "hospital_price", Hospitals[HospitalCount][hHospitalPrice]);
        cache_get_value_name_int(r, "hospital_price_insured", Hospitals[HospitalCount][hHospitalPriceInsured]);
        cache_get_value_name_int(r, "insurance_price", Hospitals[HospitalCount][hInsurancePrice]);
        cache_get_value_name_int(r, "ems_fee", Hospitals[HospitalCount][hEMSFee]);
        cache_get_value_name_int(r, "ems_fee_insured", Hospitals[HospitalCount][hEMSFeeInsured]);
        cache_get_value_name_int(r, "safe_balance", Hospitals[HospitalCount][hSafeBalance]);
        HospitalCount++;
    }
    printf("[Hospitals] Loaded %d hospitals.", HospitalCount);
    return 1;
}

stock ER_LoadHospitalBeds()
{
    mysql_tquery(MainPipeline, "SELECT * FROM `hospital_beds` ORDER BY `hospital_id`,`id` ASC", "ER_OnHospitalBedsLoad");
    return 1;
}

forward ER_OnHospitalBedsLoad();
public ER_OnHospitalBedsLoad()
{
    new rows; cache_get_row_count(rows); HospitalBedCount = 0;
    for(new r; r < rows && HospitalBedCount < MAX_HOSPITAL_BEDS; r++)
    {
        cache_get_value_name_int(r, "id", HospitalBeds[HospitalBedCount][hbSQLID]);
        cache_get_value_name_int(r, "hospital_id", HospitalBeds[HospitalBedCount][hbHospital]);
        cache_get_value_name_float(r, "x", HospitalBeds[HospitalBedCount][hbX]);
        cache_get_value_name_float(r, "y", HospitalBeds[HospitalBedCount][hbY]);
        cache_get_value_name_float(r, "z", HospitalBeds[HospitalBedCount][hbZ]);
        cache_get_value_name_float(r, "a", HospitalBeds[HospitalBedCount][hbA]);
        cache_get_value_name_int(r, "interior", HospitalBeds[HospitalBedCount][hbInt]);
        cache_get_value_name_int(r, "vw", HospitalBeds[HospitalBedCount][hbVW]);
        HospitalBeds[HospitalBedCount][hbOccupiedBy] = INVALID_PLAYER_ID;
        HospitalBeds[HospitalBedCount][hbOccupiedUntil] = 0;
        HospitalBedCount++;
    }
    printf("[Hospitals] Loaded %d beds.", HospitalBedCount);
    return 1;
}

stock ER_FindHospitalSlotByID(hid)
{
    for(new i; i < HospitalCount; i++) if(Hospitals[i][hSQLID] == hid) return i;
    return -1;
}

stock ER_FindFreeBed(hospitalSQLID)
{
    for(new i; i < HospitalBedCount; i++) if(HospitalBeds[i][hbHospital] == hospitalSQLID && HospitalBeds[i][hbOccupiedBy] == INVALID_PLAYER_ID) return i;
    return -1;
}

stock ER_ReleaseHospitalBed(playerid)
{
    for(new i; i < HospitalBedCount; i++) if(HospitalBeds[i][hbOccupiedBy] == playerid) { HospitalBeds[i][hbOccupiedBy] = INVALID_PLAYER_ID; HospitalBeds[i][hbOccupiedUntil] = 0; }
    PlayerInfo[playerid][pHospitalBed] = -1;
    return 1;
}

CMD:createhospital(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /createhospital [name]");
    new q[512];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `hospitals` (`name`,`city`,`city_name`,`hospital_price`,`hospital_price_insured`,`insurance_price`,`ems_fee`,`ems_fee_insured`,`enabled`) VALUES ('%e',0,'Los Santos',250,150,1000,120,60,1)", params);
    mysql_tquery(MainPipeline, q, "ER_OnHospitalCreated", "i", playerid);
    return 1;
}

forward ER_OnHospitalCreated(playerid);
public ER_OnHospitalCreated(playerid)
{
    new hid = cache_insert_id(), q[512], vw = 1000 + hid;
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `hospitals` SET `insurance_x`=2383.0728,`insurance_y`=2662.0520,`insurance_z`=8001.1479,`insurance_int`=1,`insurance_vw`=%d,`ems_x`=2380.0,`ems_y`=2660.0,`ems_z`=8001.1479,`ems_int`=1,`ems_vw`=%d,`safe_x`=2385.0,`safe_y`=2662.0,`safe_z`=8001.1479,`safe_int`=1,`safe_vw`=%d WHERE `id`=%d", vw, vw, vw, hid);
    mysql_tquery(MainPipeline, q);
    ER_LoadHospitals();
    SetPVarInt(playerid, "EditingHospital", hid);
    ER_Send(playerid, COLOR_GREEN, "Hospital created. Use /edithospital [id] to edit it.");
    return 1;
}

CMD:edithospitals(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new list[2048];
    for(new i; i < HospitalCount; i++) format(list, sizeof(list), "%s%d | %s | %s\n", list, Hospitals[i][hSQLID], Hospitals[i][hName], Hospitals[i][hCityName]);
    ShowPlayerDialog(playerid, DIALOG_HOSPITAL_LIST, DIALOG_STYLE_LIST, "Select Hospital", list, "Edit", "Cancel");
    return 1;
}

CMD:edithospital(playerid, params[])
{
    new hid;
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "d", hid)) return ER_Send(playerid, COLOR_GREY, "USAGE: /edithospital [id]");
    SetPVarInt(playerid, "EditingHospital", hid);
    return ER_ShowHospitalEditor(playerid, hid);
}

stock ER_ShowHospitalEditor(playerid, hid)
{
    new s = ER_FindHospitalSlotByID(hid), list[2048], bedcount;
    if(s == -1) return ER_Send(playerid, COLOR_GREY, "Invalid hospital ID.");
    for(new b; b < HospitalBedCount; b++) if(HospitalBeds[b][hbHospital] == hid) bedcount++;
    format(list, sizeof(list), "Name: %s\nCity ID: %d\nCity Name: %s\nInsurance Price: $%d\nHospital Price: $%d\nHospital Price Insured: $%d\nEMS Fee: $%d\nEMS Fee Insured: $%d\nInsurance Point: Set\nEMS Delivery Point: Set\nSafe Position: Set\nManage Beds: %d beds\nStatus: Enabled\nSave & Reload",
        Hospitals[s][hName], Hospitals[s][hCity], Hospitals[s][hCityName], Hospitals[s][hInsurancePrice], Hospitals[s][hHospitalPrice], Hospitals[s][hHospitalPriceInsured], Hospitals[s][hEMSFee], Hospitals[s][hEMSFeeInsured], bedcount);
    ShowPlayerDialog(playerid, DIALOG_HOSPITAL_EDITOR, DIALOG_STYLE_LIST, "Hospital Editor", list, "Select", "Close");
    return 1;
}

stock ER_HospitalDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    #pragma unused inputtext
    if(dialogid == DIALOG_HOSPITAL_LIST)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= HospitalCount) return 1;
        SetPVarInt(playerid, "EditingHospital", Hospitals[listitem][hSQLID]);
        ER_ShowHospitalEditor(playerid, Hospitals[listitem][hSQLID]);
        return 1;
    }
    if(dialogid == DIALOG_HOSPITAL_EDITOR)
    {
        if(!response) return 1;
        new hid = GetPVarInt(playerid, "EditingHospital");
        #pragma unused hid
        if(listitem == 11) ShowPlayerDialog(playerid, DIALOG_HOSPITAL_BEDS, DIALOG_STYLE_LIST, "Hospital Beds", "Create bed at my position\nList/Edit Beds\nDelete Bed\nGoto Bed\nBack", "Select", "Back");
        else ER_Send(playerid, COLOR_GREY, "Editor field placeholder. Full field editing comes in next phase.");
        return 1;
    }
    if(dialogid == DIALOG_HOSPITAL_BEDS)
    {
        if(!response) return 1;
        if(listitem == 0)
        {
            new hid = GetPVarInt(playerid, "EditingHospital"), q[256], Float:x, Float:y, Float:z, Float:a;
            GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
            mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `hospital_beds` (`hospital_id`,`x`,`y`,`z`,`a`,`interior`,`vw`) VALUES (%d,%f,%f,%f,%f,%d,%d)", hid, x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
            mysql_tquery(MainPipeline, q);
            ER_LoadHospitalBeds();
            ER_Send(playerid, COLOR_GREEN, "Hospital bed created.");
        }
        return 1;
    }
    return 0;
}

CMD:buyinsurance(playerid, params[])
{
    for(new i; i < HospitalCount; i++)
    {
        if(GetPlayerInterior(playerid) == Hospitals[i][hInsuranceInt] && GetPlayerVirtualWorld(playerid) == Hospitals[i][hInsuranceVW] && IsPlayerInRangeOfPoint(playerid, 2.5, Hospitals[i][hInsuranceX], Hospitals[i][hInsuranceY], Hospitals[i][hInsuranceZ]))
        {
            PlayerInfo[playerid][pCash] -= Hospitals[i][hInsurancePrice];
            GivePlayerMoney(playerid, -Hospitals[i][hInsurancePrice]);
            PlayerInfo[playerid][pHospInsurance] = Hospitals[i][hSQLID];
            Hospitals[i][hSafeBalance] += Hospitals[i][hInsurancePrice];
            new msg[128]; format(msg, sizeof(msg), "You bought hospital insurance at %s for $%d.", Hospitals[i][hName], Hospitals[i][hInsurancePrice]);
            return ER_Send(playerid, COLOR_GREEN, msg);
        }
    }
    return ER_Send(playerid, COLOR_GREY, "You are not at a hospital insurance point.");
}

CMD:togfreehospital(playerid, params[])
{
    PlayerInfo[playerid][pTogFreeHospital] = !PlayerInfo[playerid][pTogFreeHospital];
    if(PlayerInfo[playerid][pTogFreeHospital]) return ER_Send(playerid, COLOR_LIGHTBLUE, "You will now be transferred to another same-city hospital if your assigned hospital is full.");
    return ER_Send(playerid, COLOR_LIGHTBLUE, "You will now wait for a free bed at your assigned hospital.");
}
