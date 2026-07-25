#if defined _ER_ENUMS_INCLUDED
    #endinput
#endif
#define _ER_ENUMS_INCLUDED

enum E_PLAYER_INFO
{
    pID,
    pLoggedIn,
    pRegistered,
    pTutorial,
    pTutorialStep,
    pName[MAX_PLAYER_NAME_EX],
    pPassword[129],
    pAdmin,
    pPlayerVip,
    pLevel,
    pPlayingHours,
    pAge,
    pDOB[16],
    pCountry[32],
    pGender,
    pAccent,
    pSkin,
    pCash,
    pBank,
    pPhone,
    bool:pPhoneOff,
    bool:pPhonespeaker,
    pPhoneline,
    pCalling,
    pCallState,
    pPhonebook,
    pHospInsurance,
    pMarriedTo[MAX_PLAYER_NAME_EX],
    pCrimes,
    pArrests,
    pWantedLevel,
    pMaterials,
    pPot,
    pCrack,
    pRope,
    pPackages,
    pSeeds,
    pSprunk,
    pCigar,
    pSprayCans,
    Float:pHealth,
    Float:pArmor,
    pRespectPoints,
    pWarnings,
    pHasRadio,
    pRadio,
    pFavRadio,
    pVehicleLock,
    pHospitalTime,
    pTogFreeHospital,
    pFamily,
    pFaction,
    pFamilyRank,
    pFamilyCrew,
    pFactionRank,
    pFactionDivision,
    pBusiness,
    pMaxVehicles,
    pMaxHouses,
    pMaxBusinesses,
    pMaxToys,
    pHasMP3,
    pHotwireLevel,
    pHotwireSuccess,
    pHotwireFail,
    pHotwireKits,
    Float:pSpawnX,
    Float:pSpawnY,
    Float:pSpawnZ,
    Float:pSpawnA,
    pSpawnInt,
    pSpawnVW,
    pPlayerJob[MAX_JOBS_PER_PLAYER],
    pPlayerWeapons[MAX_WEAPON_SLOTS],
    pInjured,
    pHospitalized,
    pHospitalBed,
    pHospitalID,
    pDeliveredByEMS,
    Float:pInjuredX,
    Float:pInjuredY,
    Float:pInjuredZ,
    Float:pInjuredA,
    pInjuredInt,
    pInjuredVW
};
new PlayerInfo[MAX_PLAYERS][E_PLAYER_INFO];

new AccentNames[][] = {
    "None", "American", "British", "Japanese", "Chinese", "Korean", "Scottish", "Irish", "Russian", "Spanish",
    "Italian", "French", "German", "Australian", "Arabic", "Egyptian", "Mexican", "Gangsta", "Jamaican", "Hungarian",
    "Greek", "Indian", "Turkish", "Portuguese", "Polish", "Swedish", "Dutch", "Canadian", "Texan", "Southern"
};


enum E_SERVER_CORE
{
    scServerName[64],
    scWebsite[96],
    scDiscord[96],
    scNews[128],
    scLoginTrack[256],
    scRegisterTrack[256],
    scDefaultCash,
    scDefaultBank,
    Float:scDefaultSpawnX,
    Float:scDefaultSpawnY,
    Float:scDefaultSpawnZ,
    Float:scDefaultSpawnA,
    scDefaultSpawnInt,
    scDefaultSpawnVW,
    scDefaultMaleSkin,
    scDefaultFemaleSkin,
    scTutorialEnabled,
    scAllowSkipTutorial,
    scJobLimitDefault,
    scVipJobLimit[6],
    scVipHospitalTime[6],
    scVipHospitalTransferMinLevel,
    Float:scDeathHPDecrease,
    scDeathTickMS,
    Float:scHospitalRespawnHP,
    scFamilyBackupBeaconTime,
    scDefaultMaxVehicles,
    scDefaultMaxHouses,
    scDefaultMaxBusinesses,
    scDefaultMaxToys,
    scVipMaxVehicles[6],
    scVipMaxHouses[6],
    scVipMaxBusinesses[6],
    scVipMaxToys[6],
    scMaxFamilies,
    scMaxFactions,
    scMaxFamilyRanks,
    scMaxFactionRanks,
    scMaxFamilyCrews,
    scMaxFactionDivisions,
    scPhoneDigits,
    scAllowVehicleEngineWithoutKeys,
    scAllowVehicleHotwire
};
new ServerCore[E_SERVER_CORE];

enum E_HOSPITAL
{
    hSQLID,
    hName[64],
    hCity,
    hCityName[32],
    Float:hInsuranceX,
    Float:hInsuranceY,
    Float:hInsuranceZ,
    Float:hInsuranceA,
    hInsuranceInt,
    hInsuranceVW,
    Float:hEMSX,
    Float:hEMSY,
    Float:hEMSZ,
    Float:hEMSA,
    hEMSInt,
    hEMSVW,
    Float:hSafeX,
    Float:hSafeY,
    Float:hSafeZ,
    Float:hSafeA,
    hSafeInt,
    hSafeVW,
    hHospitalPrice,
    hHospitalPriceInsured,
    hInsurancePrice,
    hEMSFee,
    hEMSFeeInsured,
    hSafeBalance,
    hEnabled
};
new Hospitals[MAX_HOSPITALS][E_HOSPITAL];
new HospitalCount;

enum E_HOSPITAL_BED
{
    hbSQLID,
    hbHospital,
    Float:hbX,
    Float:hbY,
    Float:hbZ,
    Float:hbA,
    hbInt,
    hbVW,
    hbCustomMap,
    hbOccupiedBy,
    hbOccupiedUntil
};
new HospitalBeds[MAX_HOSPITAL_BEDS][E_HOSPITAL_BED];
new HospitalBedCount;

enum E_BUSINESS
{
    bSQLID,
    bName[64],
    bType,
    bOwnerType,
    bOwnerID,
    bOwnerName[MAX_PLAYER_NAME_EX],
    bPrice,
    bPriceMode,
    bMaterials,
    bMaterialsCapacity,
    bSafeBalance,
    Float:bExtX,
    Float:bExtY,
    Float:bExtZ,
    Float:bExtA,
    bExtInt,
    bExtVW,
    Float:bIntX,
    Float:bIntY,
    Float:bIntZ,
    Float:bIntA,
    bIntInt,
    bIntVW,
    Float:bSafeX,
    Float:bSafeY,
    Float:bSafeZ,
    Float:bSafeA,
    bSafeInt,
    bSafeVW,
    bPickupModel,
    bPickupType,
    bPickupID,
    Text3D:bLabelID,
    bLocked,
    bLockable,
    bEnterable,
    bCustomExt,
    bCustomInt,
    bEnabled
};
new Businesses[MAX_BUSINESSES][E_BUSINESS];
new BusinessCount;

enum E_FAMILY
{
    fSQLID,
    fName[64],
    fLeaderID,
    fLeaderName[MAX_PLAYER_NAME_EX],
    fMOTD[128],
    fMembers,
    fColor,
    fRadioColor,
    fCrewColor,
    fSetMOTDRank,
    fInviteKickRank,
    fPointCaptureRank,
    fTurfCaptureRank,
    fSafeDepositRank,
    fSafeWithdrawRank,
    fLockerDepositRank,
    fLockerWithdrawRank,
    fLockerGunRank,
    fVehicleLockRank,
    fVehicleTrackRank,
    fVehicleParkRank,
    fBusinessSafeDepositRank,
    fBusinessSafeWithdrawRank,
    fBusinessRestockRank,
    fBusinessLockRank,
    fDoorLockRank,
    fEnabled
};
new Families[MAX_FAMILIES][E_FAMILY];
new FamilyRankNames[MAX_FAMILIES][MAX_FAMILY_RANKS][32];
new FamilyCrewNames[MAX_FAMILIES][MAX_FAMILY_CREWS][32];
new FamilyCount;

enum E_RADIO_STATION
{
    rsSQLID,
    rsName[64],
    rsURL[256],
    rsCategory[32],
    rsEnabled
};
new RadioStations[MAX_RADIO_STATIONS][E_RADIO_STATION];
new RadioStationCount;

enum E_RADIO_CATEGORY
{
    rcName[32]
};
new RadioCategories[MAX_RADIO_CATEGORIES][E_RADIO_CATEGORY];
new RadioCategoryCount;

enum E_AUDIO_ZONE
{
    azSQLID,
    azName[64],
    azURL[256],
    Float:azX,
    Float:azY,
    Float:azZ,
    Float:azRange,
    azVW,
    azInt,
    azAreaID,
    azEnabled
};
new AudioZones[MAX_AUDIO_ZONES][E_AUDIO_ZONE];
new AudioZoneCount;

enum E_VEHICLE_INFO
{
    vSQLID,
    vOwnerPID,
    vFamilyID,
    vFactionID,
    vJobID,
    vModel,
    vColor1,
    vColor2,
    vPaintjob,
    Float:vX,
    Float:vY,
    Float:vZ,
    Float:vA,
    vInt,
    vVW,
    vLockType,
    vNos,
    vUnlimitedNos,
    vModSpoiler,
    vModHood,
    vModRoof,
    vModSideskirtL,
    vModSideskirtR,
    vModLamps,
    vModNitro,
    vModExhaust,
    vModWheels,
    vModStereo,
    vModHydraulics,
    vModFrontBumper,
    vModRearBumper,
    vModVentRight,
    vModVentLeft,
    vSpawnedID,
    vEngine,
    vLights,
    vWindows[4],
    Float:vHealth,
    vEnabled
};
new VehicleInfo[MAX_DYNAMIC_VEHICLES][E_VEHICLE_INFO];
new VehicleCount;


enum E_HOUSE
{
    hSQLID,
    hZone[32],
    hCustomName[64],
    hOwnerType,
    hOwnerID,
    hOwnerName[MAX_PLAYER_NAME_EX],
    hPrice,
    hPriceMode,
    Float:hExtX,
    Float:hExtY,
    Float:hExtZ,
    Float:hExtA,
    hExtInt,
    hExtVW,
    Float:hIntX,
    Float:hIntY,
    Float:hIntZ,
    Float:hIntA,
    hIntInt,
    hIntVW,
    hSafeBalance,
    hMaterials,
    hPot,
    hCrack,
    hPickupModel,
    hPickupType,
    hPickupID,
    Text3D:hLabelID,
    hLocked,
    hCustomExt,
    hCustomInt,
    hEnabled
};
new Houses[MAX_HOUSES][E_HOUSE];
new HouseCount;

enum E_DOOR
{
    dSQLID,
    dName[64],
    dOwnerType,
    dOwnerID,
    dLockRank,
    dFamilyCrew,
    dFactionDivision,
    dVipLevel,
    dAdminLevel,
    Float:dExtX,
    Float:dExtY,
    Float:dExtZ,
    Float:dExtA,
    dExtInt,
    dExtVW,
    Float:dIntX,
    Float:dIntY,
    Float:dIntZ,
    Float:dIntA,
    dIntInt,
    dIntVW,
    dPickupModel,
    dPickupType,
    dPickupID,
    Text3D:dLabelID,
    dLockable,
    dLocked,
    dCustomExt,
    dCustomInt,
    dEnabled
};
new Doors[MAX_DOORS][E_DOOR];
new DoorCount;

enum E_TOY_CACHE
{
    ptSQLID,
    ptSlot,
    ptName[32],
    ptModel,
    ptBone,
    Float:ptOffX,
    Float:ptOffY,
    Float:ptOffZ,
    Float:ptRotX,
    Float:ptRotY,
    Float:ptRotZ,
    Float:ptScaleX,
    Float:ptScaleY,
    Float:ptScaleZ,
    ptEnabled,
    ptAutoWear
};
new PlayerToys[MAX_PLAYERS][MAX_PLAYER_TOYS][E_TOY_CACHE];
new PlayerToyCount[MAX_PLAYERS];

new MySQL:MainPipeline;
