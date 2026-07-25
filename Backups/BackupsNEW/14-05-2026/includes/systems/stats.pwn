#if defined _ER_STATS_INCLUDED
    #endinput
#endif
#define _ER_STATS_INCLUDED

stock ER_GetHospitalNameByID(hid)
{
    static name[64];
    format(name, sizeof(name), "None");
    for(new i; i < HospitalCount; i++)
    {
        if(Hospitals[i][hSQLID] == hid)
        {
            format(name, sizeof(name), "%s", Hospitals[i][hName]);
            return name;
        }
    }
    return name;
}

stock ER_FormatNoneInt(value, dest[], size)
{
    if(value == 0) format(dest, size, "None");
    else format(dest, size, "%d", value);
    return 1;
}

stock ER_GetPlayerFamilyStats(playerid, family[], fRank[], crew[], size1, size2, size3)
{
    if(PlayerInfo[playerid][pFamily] <= 0)
    {
        format(family, size1, "None"); format(fRank, size2, "None"); format(crew, size3, "None"); return 1;
    }
    new idx = ER_FindFamilyIndexBySQLID(PlayerInfo[playerid][pFamily]);
    if(idx == -1) format(family, size1, "Unknown");
    else format(family, size1, "%s", Families[idx][fName]);
    ER_GetFamilyRankName(PlayerInfo[playerid][pFamily], PlayerInfo[playerid][pFamilyRank], fRank, size2);
    ER_GetFamilyCrewName(PlayerInfo[playerid][pFamily], PlayerInfo[playerid][pFamilyCrew], crew, size3);
    return 1;
}

stock ER_GetPlayerFactionStats(playerid, faction[], fRank[], division[], size1, size2, size3)
{
    if(PlayerInfo[playerid][pFaction] <= 0)
    {
        format(faction, size1, "None"); format(fRank, size2, "None"); format(division, size3, "None"); return 1;
    }
    new idx = ER_FindFactionIndexBySQLID(PlayerInfo[playerid][pFaction]);
    if(idx == -1) format(faction, size1, "Unknown");
    else format(faction, size1, "%s", Factions[idx][facName]);
    ER_GetFactionRankName(PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pFactionRank], fRank, size2);
    ER_GetFactionDivisionName(PlayerInfo[playerid][pFaction], PlayerInfo[playerid][pFactionDivision], division, size3);
    return 1;
}

CMD:stats(playerid, params[])
{
    new line[256], gender[8], insurance[64], phone[24], family[64], famrank[64], crew[64], faction[64], facrank[64], division[64], job[24], vip[24], married[32], radio[24];

    format(gender, sizeof(gender), PlayerInfo[playerid][pGender] == 2 ? "Female" : "Male");

    if(PlayerInfo[playerid][pHospInsurance] == NO_HOSPITAL_INSURANCE) format(insurance, sizeof(insurance), "None");
    else format(insurance, sizeof(insurance), "%s", ER_GetHospitalNameByID(PlayerInfo[playerid][pHospInsurance]));

    if(PlayerInfo[playerid][pPhone] == 0) format(phone, sizeof(phone), "None");
    else format(phone, sizeof(phone), "%d", PlayerInfo[playerid][pPhone]);

    ER_GetPlayerFamilyStats(playerid, family, famrank, crew, sizeof(family), sizeof(famrank), sizeof(crew));
    ER_GetPlayerFactionStats(playerid, faction, facrank, division, sizeof(faction), sizeof(facrank), sizeof(division));
    ER_FormatNoneInt(PlayerInfo[playerid][pPlayerJob][0], job, sizeof(job));
    ER_FormatNoneInt(PlayerInfo[playerid][pPlayerVip], vip, sizeof(vip));

    if(isnull(PlayerInfo[playerid][pMarriedTo]) || !strcmp(PlayerInfo[playerid][pMarriedTo], "0", true)) format(married, sizeof(married), "Nobody");
    else format(married, sizeof(married), "%s", PlayerInfo[playerid][pMarriedTo]);

    if(PlayerInfo[playerid][pRadio] == 0) format(radio, sizeof(radio), "None");
    else format(radio, sizeof(radio), "%d kHz", PlayerInfo[playerid][pRadio]);

    SendClientMessage(playerid, COLOR_ORANGE, "------------------------------------------------------------");
    format(line, sizeof(line), "%s - (Level: %d) - (Playing hours: %d) - (Gender: %s) - (Age: %d) - (Phone number: %s) - (Warnings: %d)",
        ER_GetName(playerid), PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pPlayingHours], gender, PlayerInfo[playerid][pAge], phone, PlayerInfo[playerid][pWarnings]);
    SendClientMessage(playerid, COLOR_WHITE, line);

    format(line, sizeof(line), "Family: %s | Rank: %s | Crew: %s", family, famrank, crew);
    SendClientMessage(playerid, COLOR_WHITE, line);
    format(line, sizeof(line), "Faction: %s | Faction Rank: %s | Division: %s", faction, facrank, division);
    SendClientMessage(playerid, COLOR_WHITE, line);

    format(line, sizeof(line), "(Job 1: %s) - (VIP: %s) - (Total wealth: $%d) - (Cash: $%d) - (Bank balance: $%d)",
        job, vip, PlayerInfo[playerid][pCash] + PlayerInfo[playerid][pBank], PlayerInfo[playerid][pCash], PlayerInfo[playerid][pBank]);
    SendClientMessage(playerid, COLOR_WHITE, line);

    format(line, sizeof(line), "(Insurance: %s) - (Married to: %s) - (Respect points: %d) - (Health: %.1f) - (Armor: %.1f) - (Radio: %s)",
        insurance, married, PlayerInfo[playerid][pRespectPoints], PlayerInfo[playerid][pHealth], PlayerInfo[playerid][pArmor], radio);
    SendClientMessage(playerid, COLOR_WHITE, line);

    format(line, sizeof(line), "(Crimes: %d) - (Arrests: %d) - (Wanted Level: %d) - (Materials: %d) - (Pot: %d) - (Crack: %d) - (Packages: %d)",
        PlayerInfo[playerid][pCrimes], PlayerInfo[playerid][pArrests], PlayerInfo[playerid][pWantedLevel], PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pPot], PlayerInfo[playerid][pCrack], PlayerInfo[playerid][pPackages]);
    SendClientMessage(playerid, COLOR_WHITE, line);

    format(line, sizeof(line), "(Rope: %d) - (Sprunk: %d) - (Spray Cans: %d) - (Seeds: %d) - (Country: %s)",
        PlayerInfo[playerid][pRope], PlayerInfo[playerid][pSprunk], PlayerInfo[playerid][pSprayCans], PlayerInfo[playerid][pSeeds], PlayerInfo[playerid][pCountry]);
    SendClientMessage(playerid, COLOR_WHITE, line);
    SendClientMessage(playerid, COLOR_ORANGE, "------------------------------------------------------------");
    return 1;
}
