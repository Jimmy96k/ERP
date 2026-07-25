#if defined _ER_BUSINESSES_INCLUDED
    #endinput
#endif
#define _ER_BUSINESSES_INCLUDED

#define BUSINESS_TYPE_247        1
#define BUSINESS_TYPE_RESTAURANT 2
#define BUSINESS_TYPE_CLOTHES    3
#define BUSINESS_TYPE_GUNSTORE   4
#define BUSINESS_TYPE_DEALERSHIP 5
#define BUSINESS_TYPE_BAR        6
#define BUSINESS_TYPE_GAS        7
#define BUSINESS_TYPE_BANK       8
#define BUSINESS_TYPE_GYM        9

#define BUSINESS_OWNER_NONE      0
#define BUSINESS_OWNER_PLAYER    1
#define BUSINESS_OWNER_FAMILY    2
#define BUSINESS_OWNER_FACTION   3


#define MAX_BUSINESS_ATMS 512
#define ATM_OBJECT_MODEL 2942
#define BANK_SERVICE_RANGE 4.0
#define BANK_CASH_BAG_MAX 50000
#define ATM_CASH_MAX 50000

enum E_BUSINESS_ATM
{
    atmSQLID,
    atmBusinessID,
    atmObjectID,
    Text3D:atmLabelID,
    Float:atmX,
    Float:atmY,
    Float:atmZ,
    Float:atmRX,
    Float:atmRY,
    Float:atmRZ,
    atmVW,
    atmInt,
    atmEnabled,
    atmCash,
    atmFees
};
new BusinessATMs[MAX_BUSINESS_ATMS][E_BUSINESS_ATM];
new BusinessATMCount;
new ER_BusinessMapIcon[MAX_BUSINESSES];
new ER_BusinessInviteFrom[MAX_PLAYERS];
new ER_BusinessInviteID[MAX_PLAYERS];


#define MAX_DEALERSHIP_DISPLAY 512

enum E_DEALER_DISPLAY
{
    ddSQLID,
    ddBusinessID,
    ddSpawnedID,
    Text3D:ddLabelID,
    ddModel,
    ddColor1,
    ddColor2,
    ddPrice,
    ddStock,
    ddStockCapacity,
    Float:ddX,
    Float:ddY,
    Float:ddZ,
    Float:ddA,
    ddInt,
    ddVW,
    Float:ddSpawnX,
    Float:ddSpawnY,
    Float:ddSpawnZ,
    Float:ddSpawnA,
    ddSpawnInt,
    ddSpawnVW,
    ddPaintjob,
    ddNos,
    ddUnlimitedNos,
    ddModSpoiler,
    ddModHood,
    ddModRoof,
    ddModSideskirtL,
    ddModSideskirtR,
    ddModLamps,
    ddModNitro,
    ddModExhaust,
    ddModWheels,
    ddModStereo,
    ddModHydraulics,
    ddModFrontBumper,
    ddModRearBumper,
    ddModVentRight,
    ddModVentLeft,
    ddEnabled
};
new DealershipDisplay[MAX_DEALERSHIP_DISPLAY][E_DEALER_DISPLAY];
new DealershipDisplayCount;


new ER_BuyProductID[MAX_PLAYERS][64];
new ER_BuyProductCount[MAX_PLAYERS];
new ER_BuyBusinessSQL[MAX_PLAYERS];
new ER_ClothesSelectedSkin[MAX_PLAYERS];
new ER_ToyCatalogSelected[MAX_PLAYERS];
new ER_PendingPhoneProductID[MAX_PLAYERS];
new ER_PendingPhoneBusinessID[MAX_PLAYERS];
new ER_PendingPhonePrice[MAX_PLAYERS];
#pragma unused ER_ClothesSelectedSkin
#pragma unused ER_ToyCatalogSelected

stock ER_GetBusinessTypeName(type, dest[], size)
{
    switch(type)
    {
        case BUSINESS_TYPE_247: format(dest, size, "24/7 Store");
        case BUSINESS_TYPE_RESTAURANT: format(dest, size, "Restaurant");
        case BUSINESS_TYPE_CLOTHES: format(dest, size, "Clothes Store");
        case BUSINESS_TYPE_GUNSTORE: format(dest, size, "Gun Store");
        case BUSINESS_TYPE_DEALERSHIP: format(dest, size, "Dealership");
        case BUSINESS_TYPE_BAR: format(dest, size, "Bar / Club");
        case BUSINESS_TYPE_GAS: format(dest, size, "Gas Station");
        case BUSINESS_TYPE_BANK: format(dest, size, "Bank");
        case BUSINESS_TYPE_GYM: format(dest, size, "Gym");
        default: format(dest, size, "Unknown");
    }
    return 1;
}

stock ER_ShowBusinessTypes(playerid)
{
    return ER_Send(playerid, COLOR_GREY, "USAGE: /createbusiness [type/id] | Types: 1-24/7, 2-Restaurant, 3-Clothes, 4-Gun, 5-Dealership, 6-Bar, 7-Gas, 8-Bank, 9-Gym");
}

stock ER_ParseBusinessType(const src[])
{
    if(isnull(src)) return 0;
    if(src[0] >= '0' && src[0] <= '9')
    {
        new id = strval(src);
        if(id >= 1 && id <= 9) return id;
    }
    if(!strcmp(src, "247", true) || !strcmp(src, "24/7", true) || !strcmp(src, "store", true)) return BUSINESS_TYPE_247;
    if(!strcmp(src, "restaurant", true) || !strcmp(src, "food", true)) return BUSINESS_TYPE_RESTAURANT;
    if(!strcmp(src, "clothes", true) || !strcmp(src, "clothing", true)) return BUSINESS_TYPE_CLOTHES;
    if(!strcmp(src, "gun", true) || !strcmp(src, "guns", true) || !strcmp(src, "gunstore", true)) return BUSINESS_TYPE_GUNSTORE;
    if(!strcmp(src, "dealership", true) || !strcmp(src, "dealer", true)) return BUSINESS_TYPE_DEALERSHIP;
    if(!strcmp(src, "bar", true) || !strcmp(src, "club", true)) return BUSINESS_TYPE_BAR;
    if(!strcmp(src, "gas", true) || !strcmp(src, "fuel", true)) return BUSINESS_TYPE_GAS;
    if(!strcmp(src, "bank", true)) return BUSINESS_TYPE_BANK;
    if(!strcmp(src, "gym", true)) return BUSINESS_TYPE_GYM;
    return 0;
}

stock ER_DefaultBusinessPrice(type, const zone[])
{
    new base;
    switch(type)
    {
        case BUSINESS_TYPE_247: base = 300000;
        case BUSINESS_TYPE_RESTAURANT: base = 450000;
        case BUSINESS_TYPE_CLOTHES: base = 500000;
        case BUSINESS_TYPE_GUNSTORE: base = 900000;
        case BUSINESS_TYPE_DEALERSHIP: base = 2000000;
        case BUSINESS_TYPE_BAR: base = 750000;
        case BUSINESS_TYPE_GAS: base = 1000000;
        case BUSINESS_TYPE_BANK: base = 3000000;
        case BUSINESS_TYPE_GYM: base = 650000;
        default: base = 250000;
    }
    if(strfind(zone, "Vinewood", true) != -1 || strfind(zone, "Richman", true) != -1 || strfind(zone, "Rodeo", true) != -1 || strfind(zone, "Commerce", true) != -1) base = base * 3 / 2;
    if(strfind(zone, "Idlewood", true) != -1 || strfind(zone, "Ganton", true) != -1 || strfind(zone, "Willowfield", true) != -1) base = base * 3 / 4;
    return base;
}

stock ER_DefaultBusinessPickup(type)
{
    switch(type)
    {
        case BUSINESS_TYPE_DEALERSHIP: return 1239;
        case BUSINESS_TYPE_BANK: return 1274;
    }
    return 1272; // default blue business pickup
}


stock ER_DefaultBusinessMapIcon(type)
{
    switch(type)
    {
        case BUSINESS_TYPE_247: return 17;
        case BUSINESS_TYPE_RESTAURANT: return 10;
        case BUSINESS_TYPE_CLOTHES: return 45;
        case BUSINESS_TYPE_GUNSTORE: return 18;
        case BUSINESS_TYPE_DEALERSHIP: return 55;
        case BUSINESS_TYPE_BAR: return 49;
        case BUSINESS_TYPE_GAS: return 63;
        case BUSINESS_TYPE_BANK: return 52;
        case BUSINESS_TYPE_GYM: return 54;
    }
    return 17;
}

stock ER_SetBusinessInteriorDefaults(type, bid, &Float:x, &Float:y, &Float:z, &Float:a, &interior, &vw)
{
    vw = bid;
    switch(type)
    {
        case BUSINESS_TYPE_247: { x = -25.8845; y = -185.8689; z = 1003.5469; a = 0.0; interior = 17; }
        case BUSINESS_TYPE_RESTAURANT: { x = 372.3520; y = -133.5240; z = 1001.4922; a = 0.0; interior = 5; }
        case BUSINESS_TYPE_CLOTHES: { x = 204.3329; y = -168.8799; z = 1000.5234; a = 0.0; interior = 14; }
        case BUSINESS_TYPE_GUNSTORE: { x = 285.8840; y = -39.0160; z = 1001.5156; a = 0.0; interior = 1; }
        case BUSINESS_TYPE_DEALERSHIP: { x = -2158.6731; y = 641.5175; z = 1052.3750; a = 0.0; interior = 1; }
        case BUSINESS_TYPE_BAR: { x = 501.9809; y = -69.1502; z = 998.7578; a = 0.0; interior = 11; }
        case BUSINESS_TYPE_GAS: { x = -27.3123; y = -29.2776; z = 1003.5573; a = 0.0; interior = 4; }
        case BUSINESS_TYPE_BANK: { x = 2306.3826; y = -15.2365; z = 26.7496; a = 0.0; interior = 0; }
        case BUSINESS_TYPE_GYM: { x = 772.1119; y = -3.8986; z = 1000.7288; a = 0.0; interior = 5; }
        default: { x = 0.0; y = 0.0; z = 3.0; a = 0.0; interior = 0; }
    }
    return 1;
}



stock ER_ClearDealershipDisplays()
{
    for(new i; i < DealershipDisplayCount; i++)
    {
        if(DealershipDisplay[i][ddLabelID]) DestroyDynamic3DTextLabel(DealershipDisplay[i][ddLabelID]);
        if(DealershipDisplay[i][ddSpawnedID] && DealershipDisplay[i][ddSpawnedID] != INVALID_VEHICLE_ID) DestroyVehicle(DealershipDisplay[i][ddSpawnedID]);
        DealershipDisplay[i][ddLabelID] = Text3D:0;
        DealershipDisplay[i][ddSpawnedID] = INVALID_VEHICLE_ID;
    }
    DealershipDisplayCount = 0;
    return 1;
}



stock ER_RemoveDealershipDisplayIndex(didx)
{
    if(didx < 0 || didx >= DealershipDisplayCount) return 0;
    if(DealershipDisplay[didx][ddLabelID]) DestroyDynamic3DTextLabel(DealershipDisplay[didx][ddLabelID]);
    if(DealershipDisplay[didx][ddSpawnedID] && DealershipDisplay[didx][ddSpawnedID] != INVALID_VEHICLE_ID) DestroyVehicle(DealershipDisplay[didx][ddSpawnedID]);
    DealershipDisplay[didx][ddLabelID] = Text3D:0;
    DealershipDisplay[didx][ddSpawnedID] = INVALID_VEHICLE_ID;
    DealershipDisplay[didx][ddEnabled] = 0;
    return 1;
}


stock ER_RefreshDealerLabel(didx)
{
    if(didx < 0 || didx >= DealershipDisplayCount) return 0;
    if(DealershipDisplay[didx][ddLabelID])
    {
        DestroyDynamic3DTextLabel(DealershipDisplay[didx][ddLabelID]);
        DealershipDisplay[didx][ddLabelID] = Text3D:0;
    }
    if(DealershipDisplay[didx][ddEnabled]) ER_CreateDealershipDisplayLabel(didx);
    return 1;
}

stock ER_RemoveDealerComponentLive(didx, component)
{
    if(didx < 0 || didx >= DealershipDisplayCount) return 0;
    if(component <= 0) return 0;
    if(DealershipDisplay[didx][ddSpawnedID] && DealershipDisplay[didx][ddSpawnedID] != INVALID_VEHICLE_ID)
    {
        RemoveVehicleComponent(DealershipDisplay[didx][ddSpawnedID], component);
    }
    return 1;
}

stock ER_ClearDealerModsLive(didx)
{
    if(didx < 0 || didx >= DealershipDisplayCount) return 0;
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModSpoiler]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModHood]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModRoof]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModSideskirtL]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModSideskirtR]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModLamps]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModNitro]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModExhaust]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModWheels]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModStereo]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModHydraulics]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModFrontBumper]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModRearBumper]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModVentRight]);
    ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModVentLeft]);
    return 1;
}

stock ER_RespawnDealerIdx(didx)
{
    if(didx < 0 || didx >= DealershipDisplayCount) return 0;

    if(DealershipDisplay[didx][ddLabelID])
    {
        DestroyDynamic3DTextLabel(DealershipDisplay[didx][ddLabelID]);
        DealershipDisplay[didx][ddLabelID] = Text3D:0;
    }
    if(DealershipDisplay[didx][ddSpawnedID] && DealershipDisplay[didx][ddSpawnedID] != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(DealershipDisplay[didx][ddSpawnedID]);
        DealershipDisplay[didx][ddSpawnedID] = INVALID_VEHICLE_ID;
    }

    if(!DealershipDisplay[didx][ddEnabled]) return 1;

    DealershipDisplay[didx][ddSpawnedID] = CreateVehicle(DealershipDisplay[didx][ddModel], DealershipDisplay[didx][ddX], DealershipDisplay[didx][ddY], DealershipDisplay[didx][ddZ], DealershipDisplay[didx][ddA], DealershipDisplay[didx][ddColor1], DealershipDisplay[didx][ddColor2], -1);
    SetVehicleVirtualWorld(DealershipDisplay[didx][ddSpawnedID], DealershipDisplay[didx][ddVW]);
    LinkVehicleToInterior(DealershipDisplay[didx][ddSpawnedID], DealershipDisplay[didx][ddInt]);
    ER_ApplyDealershipVehicleMods(didx);
    ER_CreateDealershipDisplayLabel(didx);
    return 1;
}

stock ER_RespawnDealerVehBySQL(dealerSqlId)
{
    new didx = ER_FindDealershipDisplayBySQL(dealerSqlId);
    if(didx == -1) return 0;
    return ER_RespawnDealerIdx(didx);
}

stock ER_GetDealerComponent(didx, slot)
{
    switch(slot)
    {
        case CARMODTYPE_SPOILER: return DealershipDisplay[didx][ddModSpoiler];
        case CARMODTYPE_HOOD: return DealershipDisplay[didx][ddModHood];
        case CARMODTYPE_ROOF: return DealershipDisplay[didx][ddModRoof];
        case CARMODTYPE_SIDESKIRT: return DealershipDisplay[didx][ddModSideskirtL];
        case CARMODTYPE_LAMPS: return DealershipDisplay[didx][ddModLamps];
        case CARMODTYPE_NITRO: return DealershipDisplay[didx][ddModNitro];
        case CARMODTYPE_EXHAUST: return DealershipDisplay[didx][ddModExhaust];
        case CARMODTYPE_WHEELS: return DealershipDisplay[didx][ddModWheels];
        case CARMODTYPE_STEREO: return DealershipDisplay[didx][ddModStereo];
        case CARMODTYPE_HYDRAULICS: return DealershipDisplay[didx][ddModHydraulics];
        case CARMODTYPE_FRONT_BUMPER: return DealershipDisplay[didx][ddModFrontBumper];
        case CARMODTYPE_REAR_BUMPER: return DealershipDisplay[didx][ddModRearBumper];
        case CARMODTYPE_VENT_RIGHT: return DealershipDisplay[didx][ddModVentRight];
        case CARMODTYPE_VENT_LEFT: return DealershipDisplay[didx][ddModVentLeft];
    }
    return 0;
}

stock ER_GetDealerModColumn(slot, dest[], len)
{
    switch(slot)
    {
        case CARMODTYPE_SPOILER: format(dest, len, "mod_spoiler");
        case CARMODTYPE_HOOD: format(dest, len, "mod_hood");
        case CARMODTYPE_ROOF: format(dest, len, "mod_roof");
        case CARMODTYPE_SIDESKIRT: format(dest, len, "mod_sideskirt_l");
        case CARMODTYPE_LAMPS: format(dest, len, "mod_lamps");
        case CARMODTYPE_NITRO: format(dest, len, "mod_nitro");
        case CARMODTYPE_EXHAUST: format(dest, len, "mod_exhaust");
        case CARMODTYPE_WHEELS: format(dest, len, "mod_wheels");
        case CARMODTYPE_STEREO: format(dest, len, "mod_stereo");
        case CARMODTYPE_HYDRAULICS: format(dest, len, "mod_hydraulics");
        case CARMODTYPE_FRONT_BUMPER: format(dest, len, "mod_front_bumper");
        case CARMODTYPE_REAR_BUMPER: format(dest, len, "mod_rear_bumper");
        case CARMODTYPE_VENT_RIGHT: format(dest, len, "mod_vent_right");
        case CARMODTYPE_VENT_LEFT: format(dest, len, "mod_vent_left");
        default: return 0;
    }
    return 1;
}

stock ER_AddDealerComponent(didx, component)
{
    if(didx < 0 || didx >= DealershipDisplayCount) return 0;
    if(component <= 0) return 0;
    if(!ER_IsComponentCompatible(DealershipDisplay[didx][ddModel], component)) return 0;
    if(DealershipDisplay[didx][ddSpawnedID] && DealershipDisplay[didx][ddSpawnedID] != INVALID_VEHICLE_ID) AddVehicleComponent(DealershipDisplay[didx][ddSpawnedID], component);
    return 1;
}

stock ER_ApplyDealershipVehicleMods(didx)
{
    if(didx < 0 || didx >= DealershipDisplayCount) return 0;
    if(!DealershipDisplay[didx][ddSpawnedID] || DealershipDisplay[didx][ddSpawnedID] == INVALID_VEHICLE_ID) return 0;
    if(DealershipDisplay[didx][ddPaintjob] >= 0) ChangeVehiclePaintjob(DealershipDisplay[didx][ddSpawnedID], DealershipDisplay[didx][ddPaintjob]);

    // Unlimited NOS is a saved flag, but SA-MP still needs the physical NOS component installed.
    // Use 10x NOS (1010), same as /editvehicle unlimited NOS.
    if(DealershipDisplay[didx][ddUnlimitedNos])
    {
        DealershipDisplay[didx][ddNos] = 1010;
        DealershipDisplay[didx][ddModNitro] = 1010;
    }

    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddNos]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModSpoiler]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModHood]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModRoof]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModSideskirtL]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModSideskirtR]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModLamps]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModNitro]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModExhaust]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModWheels]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModStereo]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModHydraulics]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModFrontBumper]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModRearBumper]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModVentRight]);
    ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModVentLeft]);
    return 1;
}


stock ER_GetDealerModComponentBySlot(didx, slot)
{
    if(didx < 0 || didx >= DealershipDisplayCount) return 0;
    switch(slot)
    {
        case 0: return DealershipDisplay[didx][ddModSpoiler];
        case 1: return DealershipDisplay[didx][ddModHood];
        case 2: return DealershipDisplay[didx][ddModRoof];
        case 3: return DealershipDisplay[didx][ddModSideskirtL];
        case 4: return DealershipDisplay[didx][ddModSideskirtR];
        case 5: return DealershipDisplay[didx][ddModLamps];
        case 7: return DealershipDisplay[didx][ddModExhaust];
        case 8: return DealershipDisplay[didx][ddModWheels];
        case 9: return DealershipDisplay[didx][ddModStereo];
        case 10: return DealershipDisplay[didx][ddModHydraulics];
        case 11: return DealershipDisplay[didx][ddModFrontBumper];
        case 12: return DealershipDisplay[didx][ddModRearBumper];
        case 13: return DealershipDisplay[didx][ddModVentRight];
        case 14: return DealershipDisplay[didx][ddModVentLeft];
    }
    return 0;
}

stock ER_SetDealerSideSkirtSet(didx, component)
{
    if(didx < 0 || didx >= DealershipDisplayCount) return 0;
    new pair = ER_GetMatchingSideSkirt(component);
    DealershipDisplay[didx][ddModSideskirtL] = 0;
    DealershipDisplay[didx][ddModSideskirtR] = 0;
    if(component > 0)
    {
        DealershipDisplay[didx][ddModSideskirtL] = component;
        if(pair > 0 && ER_IsComponentCompatible(DealershipDisplay[didx][ddModel], pair)) DealershipDisplay[didx][ddModSideskirtR] = pair;
    }
    return 1;
}

stock ER_AddDealerModCategory(playerid, &count, list[], size, const name[], slot)
{
    new pvar[32];
    format(pvar, sizeof(pvar), "DealerModSlot%d", count);
    SetPVarInt(playerid, pvar, slot);
    format(list, size, "%s%s\n", list, name);
    count++;
    return 1;
}

stock ER_ShowDealerModMenu(playerid, dealerId)
{
    SetPVarInt(playerid, "SelectedDealerVehicle", dealerId);
    new didx = ER_FindDealershipDisplayBySQL(dealerId);
    if(didx == -1) return ER_ShowDealershipVehicleEditor(playerid, dealerId);
    new model = DealershipDisplay[didx][ddModel];
    new list[768], count = 0;
    list[0] = EOS;
    if(ER_ModSlotHasCompatible(model, 0)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Spoiler", 0);
    if(ER_ModSlotHasCompatible(model, 1)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Hood", 1);
    if(ER_ModSlotHasCompatible(model, 2)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Roof", 2);
    if(ER_ModSlotHasCompatible(model, 3) || ER_ModSlotHasCompatible(model, 4)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Side Skirt", 3);
    if(ER_ModSlotHasCompatible(model, 5)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Lamps", 5);
    if(ER_ModSlotHasCompatible(model, 7)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Exhaust", 7);
    if(ER_ModSlotHasCompatible(model, 8)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Wheels/Rims", 8);
    if(ER_ModSlotHasCompatible(model, 9)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Stereo", 9);
    if(ER_ModSlotHasCompatible(model, 10)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Hydraulics", 10);
    if(ER_ModSlotHasCompatible(model, 11)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Front Bumper", 11);
    if(ER_ModSlotHasCompatible(model, 12)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Rear Bumper", 12);
    if(ER_ModSlotHasCompatible(model, 13)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Vent Right", 13);
    if(ER_ModSlotHasCompatible(model, 14)) ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Vent Left", 14);
    ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Paintjob", 90);
    ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Clear All Mods", 91);
    ER_AddDealerModCategory(playerid, count, list, sizeof(list), "Toggle Unlimited NOS", 92);
    return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_MOD_MENU, DIALOG_STYLE_LIST, "Dealership Vehicle Mods", list, "Select", "Back");
}

stock ER_ShowDealerComponentList(playerid, slot)
{
    new dealerId = GetPVarInt(playerid, "SelectedDealerVehicle");
    new didx = ER_FindDealershipDisplayBySQL(dealerId);
    if(didx == -1) return ER_ShowDealershipVehicleEditor(playerid, dealerId);

    new model = DealershipDisplay[didx][ddModel];
    new list[2048], count = 0, cname[64];

    list[0] = EOS;
    ER_AddModRow(playerid, count, list, sizeof(list), "None", 0);

    switch(slot)
    {
        case 0:
        {
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Pro Spoiler", 1000);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Win Spoiler", 1001);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Drag Spoiler", 1002);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alpha Spoiler", 1003);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Fury Spoiler", 1023);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Spoiler", 1138);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Spoiler", 1139);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Spoiler", 1146);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Spoiler", 1147);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Spoiler", 1158);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Spoiler", 1162);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Spoiler", 1163);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Spoiler", 1164);
        }
        case 1:
        {
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Bonnet Scoop Hood", 1004);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Fury Scoop Hood", 1005);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Roof Scoop Hood", 1006);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Champ Scoop Hood", 1014);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Fury Scoop Hood", 1015);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Worx Scoop Hood", 1016);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Race Scoop Hood", 1065);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Worx Scoop Hood", 1066);
        }
        case 2:
        {
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Roof Vent", 1032);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Roof Vent", 1033);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Roof", 1035);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Roof", 1038);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Roof", 1053);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Roof", 1054);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Roof", 1055);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Roof", 1061);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Roof Scoop", 1067);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Roof Vent", 1088);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Roof Vent", 1091);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Convertible Roof", 1103);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Vinyl Hardtop", 1128);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Hardtop Roof", 1130);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Softtop Roof", 1131);
        }
        case 3, 4:
        {
            for(new component = 1000; component <= 1193; component++)
            {
                new pair = ER_GetMatchingSideSkirt(component);
                if(pair <= 0) continue;
                if(!ER_IsPrimarySideSkirt(component)) continue;
                if(!ER_IsComponentCompatible(model, component)) continue;
                if(!ER_IsComponentCompatible(model, pair)) continue;

                ER_GetSideSkirtSetName(component, cname, sizeof(cname));
                ER_AddModRow(playerid, count, list, sizeof(list), cname, component);
            }
        }
        case 5:
        {
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Square Fog Lamps", 1024);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Round Fog Lamps", 1027);
        }
        case 7:
        {
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Upswept Exhaust", 1018);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Twin Exhaust", 1019);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Large Exhaust", 1020);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Medium Exhaust", 1021);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Small Exhaust", 1022);

            // Sultan WAA exhausts.
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Sultan Alien Exhaust", 1028);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Sultan X-Flow Exhaust", 1029);

            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Exhaust", 1034);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Exhaust", 1037);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Exhaust", 1044);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Exhaust", 1046);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Chrome Exhaust", 1104);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Slamin Exhaust", 1105);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Chrome Exhaust", 1113);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Slamin Exhaust", 1114);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Exhaust", 1126);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Exhaust", 1127);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Chrome Exhaust", 1129);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Slamin Exhaust", 1132);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Slamin Exhaust", 1135);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Chrome Exhaust", 1136);
        }
        case 8:
        {
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Offroad Wheels", 1025);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Shadow Wheels", 1073);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Mega Wheels", 1074);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Rimshine Wheels", 1075);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Wires Wheels", 1076);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Classic Wheels", 1077);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Twist Wheels", 1078);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Cutter Wheels", 1079);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Switch Wheels", 1080);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Grove Wheels", 1081);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Import Wheels", 1082);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Dollar Wheels", 1083);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Trance Wheels", 1084);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Atomic Wheels", 1085);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Ahab Wheels", 1096);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Virtual Wheels", 1097);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Access Wheels", 1098);
        }
        case 9:
        {
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Bass Boost", 1086);
        }
        case 10:
        {
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Hydraulics", 1087);
        }
        case 11:
        {
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Front Bumper", 1169);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Front Bumper", 1170);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Front Bumper", 1171);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Front Bumper", 1172);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Chrome Front Bumper", 1179);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Slamin Front Bumper", 1182);
        }
        case 12:
        {
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Rear Bumper", 1140);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Rear Bumper", 1141);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Alien Rear Bumper", 1148);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "X-Flow Rear Bumper", 1149);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Chrome Rear Bumper", 1180);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Slamin Rear Bumper", 1183);
        }
        case 13:
        {
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Right Vent", 1142);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Right Vent", 1144);
        }
        case 14:
        {
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Left Vent", 1143);
            ER_TryAddModRow(playerid, count, list, sizeof(list), model, "Left Vent", 1145);
        }
    }

    if(count <= 1)
    {
        ER_Send(playerid, COLOR_GREY, "No compatible parts are available for this vehicle.");
        return ER_ShowDealerModMenu(playerid, dealerId);
    }

    return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_MOD_SELECT, DIALOG_STYLE_TABLIST, "Select Dealership Component", list, "Select", "Back");
}


stock ER_CreateDealershipDisplayLabel(idx)
{
    if(idx < 0 || idx >= DealershipDisplayCount) return 0;
    new label[192];
    format(label, sizeof(label), "{3399FF}%s For Sale!\n{33AA33}Price: %s\n{3399FF}Business ID: %d\nVehicle ID: %d", ER_GetVehicleModelName(DealershipDisplay[idx][ddModel]), ER_FormatMoney(DealershipDisplay[idx][ddPrice]), DealershipDisplay[idx][ddBusinessID], DealershipDisplay[idx][ddSQLID]);
    DealershipDisplay[idx][ddLabelID] = CreateDynamic3DTextLabel(label, COLOR_BLUE, DealershipDisplay[idx][ddX], DealershipDisplay[idx][ddY], DealershipDisplay[idx][ddZ] + 0.65, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, DealershipDisplay[idx][ddVW], DealershipDisplay[idx][ddInt]);
    return 1;
}

stock ER_LoadDealershipDisplays()
{
    ER_ClearDealershipDisplays();
    mysql_tquery(MainPipeline, "SELECT * FROM `dealership_vehicles` WHERE `enabled`=1", "ER_OnDealershipDisplaysLoad");
    return 1;
}

forward ER_OnDealershipDisplaysLoad();
public ER_OnDealershipDisplaysLoad()
{
    new rows; cache_get_row_count(rows);
    DealershipDisplayCount = 0;
    for(new r; r < rows && DealershipDisplayCount < MAX_DEALERSHIP_DISPLAY; r++)
    {
        cache_get_value_name_int(r, "id", DealershipDisplay[DealershipDisplayCount][ddSQLID]);
        cache_get_value_name_int(r, "business_id", DealershipDisplay[DealershipDisplayCount][ddBusinessID]);
        cache_get_value_name_int(r, "veh_modelid", DealershipDisplay[DealershipDisplayCount][ddModel]);
        cache_get_value_name_int(r, "color1", DealershipDisplay[DealershipDisplayCount][ddColor1]);
        cache_get_value_name_int(r, "color2", DealershipDisplay[DealershipDisplayCount][ddColor2]);
        cache_get_value_name_int(r, "price", DealershipDisplay[DealershipDisplayCount][ddPrice]);
        cache_get_value_name_int(r, "stock", DealershipDisplay[DealershipDisplayCount][ddStock]);
        cache_get_value_name_int(r, "stock_capacity", DealershipDisplay[DealershipDisplayCount][ddStockCapacity]);
        cache_get_value_name_float(r, "x", DealershipDisplay[DealershipDisplayCount][ddX]);
        cache_get_value_name_float(r, "y", DealershipDisplay[DealershipDisplayCount][ddY]);
        cache_get_value_name_float(r, "z", DealershipDisplay[DealershipDisplayCount][ddZ]);
        cache_get_value_name_float(r, "a", DealershipDisplay[DealershipDisplayCount][ddA]);
        cache_get_value_name_int(r, "interior", DealershipDisplay[DealershipDisplayCount][ddInt]);
        cache_get_value_name_int(r, "vw", DealershipDisplay[DealershipDisplayCount][ddVW]);
        cache_get_value_name_float(r, "spawn_x", DealershipDisplay[DealershipDisplayCount][ddSpawnX]);
        cache_get_value_name_float(r, "spawn_y", DealershipDisplay[DealershipDisplayCount][ddSpawnY]);
        cache_get_value_name_float(r, "spawn_z", DealershipDisplay[DealershipDisplayCount][ddSpawnZ]);
        cache_get_value_name_float(r, "spawn_a", DealershipDisplay[DealershipDisplayCount][ddSpawnA]);
        cache_get_value_name_int(r, "spawn_int", DealershipDisplay[DealershipDisplayCount][ddSpawnInt]);
        cache_get_value_name_int(r, "spawn_vw", DealershipDisplay[DealershipDisplayCount][ddSpawnVW]);
        cache_get_value_name_int(r, "paintjob", DealershipDisplay[DealershipDisplayCount][ddPaintjob]);
        cache_get_value_name_int(r, "nos", DealershipDisplay[DealershipDisplayCount][ddNos]);
        cache_get_value_name_int(r, "unlimited_nos", DealershipDisplay[DealershipDisplayCount][ddUnlimitedNos]);
        cache_get_value_name_int(r, "mod_spoiler", DealershipDisplay[DealershipDisplayCount][ddModSpoiler]);
        cache_get_value_name_int(r, "mod_hood", DealershipDisplay[DealershipDisplayCount][ddModHood]);
        cache_get_value_name_int(r, "mod_roof", DealershipDisplay[DealershipDisplayCount][ddModRoof]);
        cache_get_value_name_int(r, "mod_sideskirt_l", DealershipDisplay[DealershipDisplayCount][ddModSideskirtL]);
        cache_get_value_name_int(r, "mod_sideskirt_r", DealershipDisplay[DealershipDisplayCount][ddModSideskirtR]);
        cache_get_value_name_int(r, "mod_lamps", DealershipDisplay[DealershipDisplayCount][ddModLamps]);
        cache_get_value_name_int(r, "mod_nitro", DealershipDisplay[DealershipDisplayCount][ddModNitro]);
        cache_get_value_name_int(r, "mod_exhaust", DealershipDisplay[DealershipDisplayCount][ddModExhaust]);
        cache_get_value_name_int(r, "mod_wheels", DealershipDisplay[DealershipDisplayCount][ddModWheels]);
        cache_get_value_name_int(r, "mod_stereo", DealershipDisplay[DealershipDisplayCount][ddModStereo]);
        cache_get_value_name_int(r, "mod_hydraulics", DealershipDisplay[DealershipDisplayCount][ddModHydraulics]);
        cache_get_value_name_int(r, "mod_front_bumper", DealershipDisplay[DealershipDisplayCount][ddModFrontBumper]);
        cache_get_value_name_int(r, "mod_rear_bumper", DealershipDisplay[DealershipDisplayCount][ddModRearBumper]);
        cache_get_value_name_int(r, "mod_vent_right", DealershipDisplay[DealershipDisplayCount][ddModVentRight]);
        cache_get_value_name_int(r, "mod_vent_left", DealershipDisplay[DealershipDisplayCount][ddModVentLeft]);
        cache_get_value_name_int(r, "enabled", DealershipDisplay[DealershipDisplayCount][ddEnabled]);
        DealershipDisplay[DealershipDisplayCount][ddSpawnedID] = CreateVehicle(DealershipDisplay[DealershipDisplayCount][ddModel], DealershipDisplay[DealershipDisplayCount][ddX], DealershipDisplay[DealershipDisplayCount][ddY], DealershipDisplay[DealershipDisplayCount][ddZ], DealershipDisplay[DealershipDisplayCount][ddA], DealershipDisplay[DealershipDisplayCount][ddColor1], DealershipDisplay[DealershipDisplayCount][ddColor2], -1);
        SetVehicleVirtualWorld(DealershipDisplay[DealershipDisplayCount][ddSpawnedID], DealershipDisplay[DealershipDisplayCount][ddVW]);
        LinkVehicleToInterior(DealershipDisplay[DealershipDisplayCount][ddSpawnedID], DealershipDisplay[DealershipDisplayCount][ddInt]);

        // Important: increment first. ER_ApplyDealershipVehicleMods validates didx against DealershipDisplayCount.
        DealershipDisplayCount++;
        ER_ApplyDealershipVehicleMods(DealershipDisplayCount - 1);
        SetTimerEx("ER_ReapplyDealerDisplayMods", 1000, false, "i", DealershipDisplayCount - 1);
        ER_CreateDealershipDisplayLabel(DealershipDisplayCount - 1);
    }
    printf("[DealershipVehicles] Loaded %d display vehicles.", DealershipDisplayCount);
    return 1;
}

forward ER_ReapplyDealerDisplayMods(didx);
public ER_ReapplyDealerDisplayMods(didx)
{
    if(didx < 0 || didx >= DealershipDisplayCount) return 0;
    return ER_ApplyDealershipVehicleMods(didx);
}

stock ER_FindDealerByVeh(vehicleid)
{
    for(new i; i < DealershipDisplayCount; i++)
    {
        if(DealershipDisplay[i][ddSpawnedID] == vehicleid) return i;
    }
    return -1;
}


stock ER_ShowDealershipVehicles(playerid, businessid, ownerMode = 0)
{
    SetPVarInt(playerid, "DealerOwnerMode", ownerMode);
    new list[2048], line[128], found;
    for(new i; i < DealershipDisplayCount; i++)
    {
        if(!DealershipDisplay[i][ddEnabled] || DealershipDisplay[i][ddBusinessID] != businessid) continue;
        format(line, sizeof(line), "(%d) %s - %s - Stock: %d/%d\n", DealershipDisplay[i][ddSQLID], ER_GetVehicleModelName(DealershipDisplay[i][ddModel]), ER_FormatMoney(DealershipDisplay[i][ddPrice]), DealershipDisplay[i][ddStock], DealershipDisplay[i][ddStockCapacity]);
        strcat(list, line, sizeof(list));
        new pvarName[32];
        format(pvarName, sizeof(pvarName), "DealerList_%d", found);
        SetPVarInt(playerid, pvarName, DealershipDisplay[i][ddSQLID]);
        found++;
    }
    if(!found) format(list, sizeof(list), "No dealership display vehicles found.");
    SetPVarInt(playerid, "DealerListCount", found);
    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_LIST, DIALOG_STYLE_LIST, "Dealership Vehicles", list, "Select", "Back");
    return 1;
}

stock ER_FindDealershipDisplayBySQL(sqlid)
{
    for(new i; i < DealershipDisplayCount; i++)
    {
        if(DealershipDisplay[i][ddSQLID] == sqlid) return i;
    }
    return -1;
}

stock ER_CountDealerVehForBiz(bid)
{
    new count;
    for(new i; i < DealershipDisplayCount; i++)
    {
        if(DealershipDisplay[i][ddBusinessID] == bid && DealershipDisplay[i][ddEnabled]) count++;
    }
    return count;
}

stock ER_OnBusinessVehicleEntered(playerid, vehicleid)
{
    new d = ER_FindDealerByVeh(vehicleid);
    if(d == -1) return 0;
    new msg[160];
    format(msg, sizeof(msg), "Would you like to buy this %s for %s?", ER_GetVehicleModelName(DealershipDisplay[d][ddModel]), ER_FormatMoney(DealershipDisplay[d][ddPrice]));
    SetPVarInt(playerid, "BuyDealerDisplay", DealershipDisplay[d][ddSQLID]);
    ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_BUY, DIALOG_STYLE_MSGBOX, "Buy Vehicle", msg, "Buy", "Cancel");
    return 1;
}

stock ER_IsInsideBusiness(playerid, idx)
{
    if(idx < 0 || idx >= BusinessCount) return 0;
    return (GetPlayerVirtualWorld(playerid) == Businesses[idx][bIntVW] && GetPlayerInterior(playerid) == Businesses[idx][bIntInt]);
}

stock ER_IsAtBusinessServicePoint(playerid, idx)
{
    if(idx < 0 || idx >= BusinessCount) return 0;
    if(!ER_IsInsideBusiness(playerid, idx)) return 0;
    if(Businesses[idx][bSafeX] == 0.0 && Businesses[idx][bSafeY] == 0.0 && Businesses[idx][bSafeZ] == 0.0) return 1;
    return IsPlayerInRangeOfPoint(playerid, BANK_SERVICE_RANGE, Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ]);
}

stock ER_GetBankBusinessAtCounter(playerid)
{
    for(new i; i < BusinessCount; i++)
    {
        if(Businesses[i][bType] == BUSINESS_TYPE_BANK && ER_IsAtBusinessServicePoint(playerid, i)) return i;
    }
    return -1;
}

stock ER_ClearBusinessATMs()
{
    for(new i; i < BusinessATMCount; i++)
    {
        if(BusinessATMs[i][atmObjectID]) DestroyDynamicObject(BusinessATMs[i][atmObjectID]);
        if(BusinessATMs[i][atmLabelID]) DestroyDynamic3DTextLabel(BusinessATMs[i][atmLabelID]);
        BusinessATMs[i][atmObjectID] = 0;
        BusinessATMs[i][atmLabelID] = Text3D:0;
    }
    BusinessATMCount = 0;
    return 1;
}

stock ER_CreateATMWorld(idx)
{
    if(idx < 0 || idx >= BusinessATMCount) return 0;
    BusinessATMs[idx][atmObjectID] = CreateDynamicObject(ATM_OBJECT_MODEL, BusinessATMs[idx][atmX], BusinessATMs[idx][atmY], BusinessATMs[idx][atmZ], BusinessATMs[idx][atmRX], BusinessATMs[idx][atmRY], BusinessATMs[idx][atmRZ], BusinessATMs[idx][atmVW], BusinessATMs[idx][atmInt]);
    new label[96]; format(label, sizeof(label), "ATM Machine\nBank ID: %d\nATM ID: %d", BusinessATMs[idx][atmBusinessID], BusinessATMs[idx][atmSQLID]);
    BusinessATMs[idx][atmLabelID] = CreateDynamic3DTextLabel(label, COLOR_GREEN, BusinessATMs[idx][atmX], BusinessATMs[idx][atmY], BusinessATMs[idx][atmZ] + 0.8, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, BusinessATMs[idx][atmVW], BusinessATMs[idx][atmInt]);
    return 1;
}
stock ER_RecreateATMWorld(idx)
{
    if(idx < 0 || idx >= BusinessATMCount) return 0;
    if(BusinessATMs[idx][atmObjectID]) DestroyDynamicObject(BusinessATMs[idx][atmObjectID]);
    if(BusinessATMs[idx][atmLabelID]) DestroyDynamic3DTextLabel(BusinessATMs[idx][atmLabelID]);
    BusinessATMs[idx][atmObjectID] = 0;
    BusinessATMs[idx][atmLabelID] = Text3D:0;
    return ER_CreateATMWorld(idx);
}

stock ER_FindATMIndexBySQLID(sqlid)
{
    for(new i; i < BusinessATMCount; i++)
    {
        if(BusinessATMs[i][atmSQLID] == sqlid) return i;
    }
    return -1;
}

stock ER_LoadBusinessATMs()
{
    ER_ClearBusinessATMs();
    mysql_tquery(MainPipeline, "SELECT * FROM `business_atms` WHERE `enabled`=1", "ER_OnBusinessATMsLoad");
    return 1;
}
forward ER_OnBusinessATMsLoad();
public ER_OnBusinessATMsLoad()
{
    new rows; cache_get_row_count(rows);
    BusinessATMCount = 0;
    for(new r; r < rows && BusinessATMCount < MAX_BUSINESS_ATMS; r++)
    {
        cache_get_value_name_int(r, "id", BusinessATMs[BusinessATMCount][atmSQLID]);
        cache_get_value_name_int(r, "business_id", BusinessATMs[BusinessATMCount][atmBusinessID]);
        cache_get_value_name_float(r, "x", BusinessATMs[BusinessATMCount][atmX]);
        cache_get_value_name_float(r, "y", BusinessATMs[BusinessATMCount][atmY]);
        cache_get_value_name_float(r, "z", BusinessATMs[BusinessATMCount][atmZ]);
        cache_get_value_name_float(r, "rx", BusinessATMs[BusinessATMCount][atmRX]);
        cache_get_value_name_float(r, "ry", BusinessATMs[BusinessATMCount][atmRY]);
        cache_get_value_name_float(r, "rz", BusinessATMs[BusinessATMCount][atmRZ]);
        cache_get_value_name_int(r, "vw", BusinessATMs[BusinessATMCount][atmVW]);
        cache_get_value_name_int(r, "interior", BusinessATMs[BusinessATMCount][atmInt]);
        cache_get_value_name_int(r, "enabled", BusinessATMs[BusinessATMCount][atmEnabled]);
        cache_get_value_name_int(r, "atm_cash", BusinessATMs[BusinessATMCount][atmCash]);
        cache_get_value_name_int(r, "atm_fees", BusinessATMs[BusinessATMCount][atmFees]);
        BusinessATMCount++;
        ER_CreateATMWorld(BusinessATMCount - 1);
    }
    printf("[BusinessATMs] Loaded %d ATMs.", BusinessATMCount);
    return 1;
}

stock ER_GetNearestATM(playerid)
{
    new vw = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);
    for(new i; i < BusinessATMCount; i++)
    {
        if(vw == BusinessATMs[i][atmVW] && interior == BusinessATMs[i][atmInt] && IsPlayerInRangeOfPoint(playerid, 3.0, BusinessATMs[i][atmX], BusinessATMs[i][atmY], BusinessATMs[i][atmZ])) return i;
    }
    return -1;
}

stock ER_ProcessBankAction(playerid, amount, action, bool:atm)
{
    if(amount <= 0) return ER_Send(playerid, COLOR_GREY, "Amount must be greater than 0.");
    new atmIdx = -1, bankIdx = -1, fee = 0;
    if(atm)
    {
        atmIdx = ER_GetNearestATM(playerid);
        if(atmIdx == -1) return ER_Send(playerid, COLOR_GREY, "You must be near an ATM to use this command.");
        bankIdx = ER_FindBusinessIndexBySQLID(BusinessATMs[atmIdx][atmBusinessID]);
        fee = 25;
    }
    else
    {
        bankIdx = ER_GetBankBusinessAtCounter(playerid);
        if(bankIdx == -1) return ER_Send(playerid, COLOR_GREY, "You must be near a bank counter to use this command.");
        fee = 0;
    }
    if(action == 1) // deposit
    {
        if(PlayerInfo[playerid][pCash] < amount + fee) return ER_Send(playerid, COLOR_GREY, "You do not have enough cash.");
        PlayerInfo[playerid][pCash] -= (amount + fee); PlayerInfo[playerid][pBank] += amount; GivePlayerMoney(playerid, -(amount + fee));
        if(atm && atmIdx != -1)
        {
            BusinessATMs[atmIdx][atmCash] += amount; BusinessATMs[atmIdx][atmFees] += fee;
            new q[192]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_atms` SET `atm_cash`=%d,`atm_fees`=%d WHERE `id`=%d", BusinessATMs[atmIdx][atmCash], BusinessATMs[atmIdx][atmFees], BusinessATMs[atmIdx][atmSQLID]); mysql_tquery(MainPipeline, q);
        }
        else if(bankIdx != -1)
        {
            Businesses[bankIdx][bSafeBalance] += amount + fee;
            new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=%d WHERE `id`=%d", Businesses[bankIdx][bSafeBalance], Businesses[bankIdx][bSQLID]); mysql_tquery(MainPipeline, q);
        }
        new msg[128]; format(msg, sizeof(msg), "You deposited %s into your bank account.", ER_FormatMoney(amount)); ER_Send(playerid, COLOR_GREEN, msg);
        ER_SaveCharacter(playerid); return 1;
    }
    if(action == 2) // withdraw
    {
        if(PlayerInfo[playerid][pBank] < amount + fee) return ER_Send(playerid, COLOR_GREY, "You do not have enough money in the bank.");
        if(atm && atmIdx != -1 && BusinessATMs[atmIdx][atmCash] < amount) return ER_Send(playerid, COLOR_GREY, "This ATM does not have enough cash.");
        if(!atm && bankIdx != -1 && Businesses[bankIdx][bSafeBalance] < amount) return ER_Send(playerid, COLOR_GREY, "This bank safe does not have enough cash for that withdrawal.");
        PlayerInfo[playerid][pBank] -= (amount + fee); PlayerInfo[playerid][pCash] += amount; GivePlayerMoney(playerid, amount);
        if(atm && atmIdx != -1)
        {
            BusinessATMs[atmIdx][atmCash] -= amount; BusinessATMs[atmIdx][atmFees] += fee;
            new q[192]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_atms` SET `atm_cash`=%d,`atm_fees`=%d WHERE `id`=%d", BusinessATMs[atmIdx][atmCash], BusinessATMs[atmIdx][atmFees], BusinessATMs[atmIdx][atmSQLID]); mysql_tquery(MainPipeline, q);
        }
        else if(bankIdx != -1)
        {
            Businesses[bankIdx][bSafeBalance] = Businesses[bankIdx][bSafeBalance] - amount + fee;
            new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=%d WHERE `id`=%d", Businesses[bankIdx][bSafeBalance], Businesses[bankIdx][bSQLID]); mysql_tquery(MainPipeline, q);
        }
        new msg[128]; format(msg, sizeof(msg), "You withdrew %s from your bank account.", ER_FormatMoney(amount)); ER_Send(playerid, COLOR_GREEN, msg);
        ER_SaveCharacter(playerid); return 1;
    }
    return 1;
}

stock ER_ProcessWireTransfer(playerid, target, amount, bool:atm)
{
    if(target == INVALID_PLAYER_ID || !IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid target player.");
    if(target == playerid) return ER_Send(playerid, COLOR_GREY, "You cannot wire money to yourself.");
    if(amount <= 0) return ER_Send(playerid, COLOR_GREY, "Amount must be greater than 0.");
    if(atm)
    {
        if(ER_GetNearestATM(playerid) == -1) return ER_Send(playerid, COLOR_GREY, "You must be near an ATM to use this command.");
    }
    else
    {
        if(ER_GetBankBusinessAtCounter(playerid) == -1) return ER_Send(playerid, COLOR_GREY, "You must be near a bank counter to use this command.");
    }
    if(PlayerInfo[playerid][pBank] < amount) return ER_Send(playerid, COLOR_GREY, "You do not have enough money in the bank.");
    PlayerInfo[playerid][pBank] -= amount;
    PlayerInfo[target][pBank] += amount;
    new msg[128]; format(msg, sizeof(msg), "You wired %s to %s.", ER_FormatMoney(amount), PlayerInfo[target][pName]); ER_Send(playerid, COLOR_GREEN, msg);
    format(msg, sizeof(msg), "%s wired %s to your bank account.", PlayerInfo[playerid][pName], ER_FormatMoney(amount)); ER_Send(target, COLOR_GREEN, msg);
    ER_SaveCharacter(playerid); ER_SaveCharacter(target);
    return 1;
}


stock ER_ShowBusinessATMs(playerid, businessid)
{
    new list[2048], line[128], found;
    for(new i; i < BusinessATMCount; i++)
    {
        if(BusinessATMs[i][atmBusinessID] != businessid) continue;
        format(line, sizeof(line), "ATM ID: %d - Cash: %s/%s - Fees: %s - %s\n", BusinessATMs[i][atmSQLID], ER_FormatMoney(BusinessATMs[i][atmCash]), ER_FormatMoney(ATM_CASH_MAX), ER_FormatMoney(BusinessATMs[i][atmFees]), BusinessATMs[i][atmEnabled] ? ("Enabled") : ("Disabled"));
        strcat(list, line, sizeof(list));
        new pvarName[32];
        format(pvarName, sizeof(pvarName), "ATMList_%d", found);
        SetPVarInt(playerid, pvarName, BusinessATMs[i][atmSQLID]);
        found++;
    }
    if(!found) format(list, sizeof(list), "No ATMs found for this bank.");
    SetPVarInt(playerid, "ATMListCount", found);
    ShowPlayerDialog(playerid, DIALOG_BUSINESS_ATM_LIST, DIALOG_STYLE_LIST, "Bank ATMs", list, "Select", "Back");
    return 1;
}

stock ER_CreateBusinessATMAtPlayer(playerid, businessid)
{
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
    SetPVarFloat(playerid, "NewATMX", x); SetPVarFloat(playerid, "NewATMY", y); SetPVarFloat(playerid, "NewATMZ", z); SetPVarFloat(playerid, "NewATMRZ", a);
    SetPVarInt(playerid, "NewATMVW", GetPlayerVirtualWorld(playerid)); SetPVarInt(playerid, "NewATMInt", GetPlayerInterior(playerid));
    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `business_atms` (`business_id`,`x`,`y`,`z`,`rx`,`ry`,`rz`,`vw`,`interior`,`enabled`,`atm_cash`,`atm_fees`) VALUES (%d,%f,%f,%f,0.0,0.0,%f,%d,%d,1,0,0)", businessid, x, y, z, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    mysql_tquery(MainPipeline, q, "ER_OnBusinessATMCreated", "ii", playerid, businessid);
    return 1;
}
forward ER_OnBusinessATMCreated(playerid, businessid);
public ER_OnBusinessATMCreated(playerid, businessid)
{
    new atmId = cache_insert_id();
    if(BusinessATMCount < MAX_BUSINESS_ATMS)
    {
        new idx = BusinessATMCount++;
        BusinessATMs[idx][atmSQLID] = atmId;
        BusinessATMs[idx][atmBusinessID] = businessid;
        BusinessATMs[idx][atmX] = GetPVarFloat(playerid, "NewATMX");
        BusinessATMs[idx][atmY] = GetPVarFloat(playerid, "NewATMY");
        BusinessATMs[idx][atmZ] = GetPVarFloat(playerid, "NewATMZ");
        BusinessATMs[idx][atmRX] = 0.0;
        BusinessATMs[idx][atmRY] = 0.0;
        BusinessATMs[idx][atmRZ] = GetPVarFloat(playerid, "NewATMRZ");
        BusinessATMs[idx][atmVW] = GetPVarInt(playerid, "NewATMVW");
        BusinessATMs[idx][atmInt] = GetPVarInt(playerid, "NewATMInt");
        BusinessATMs[idx][atmEnabled] = 1;
        BusinessATMs[idx][atmCash] = 0;
        BusinessATMs[idx][atmFees] = 0;
        ER_CreateATMWorld(idx);
        SetPVarInt(playerid, "EditingATM", atmId);
        EditDynamicObject(playerid, BusinessATMs[idx][atmObjectID]);
    }
    DeletePVar(playerid, "NewATMX"); DeletePVar(playerid, "NewATMY"); DeletePVar(playerid, "NewATMZ"); DeletePVar(playerid, "NewATMRZ"); DeletePVar(playerid, "NewATMVW"); DeletePVar(playerid, "NewATMInt");
    ER_Send(playerid, COLOR_GREEN, "ATM created. Move it with your mouse and click save to save its position.");
    return 1;
}

stock ER_OnBizEditObj(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    #pragma unused objectid
    new atmId = GetPVarInt(playerid, "EditingATM");
    if(!atmId) return 0;
    if(response == EDIT_RESPONSE_UPDATE) return 1;
    if(response != EDIT_RESPONSE_FINAL)
    {
        DeletePVar(playerid, "EditingATM");
        ER_LoadBusinessATMs();
        return 1;
    }
    new vw = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);
    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_atms` SET `x`=%f,`y`=%f,`z`=%f,`rx`=%f,`ry`=%f,`rz`=%f,`vw`=%d,`interior`=%d WHERE `id`=%d", x, y, z, rx, ry, rz, vw, interior, atmId);
    mysql_tquery(MainPipeline, q);

    new idx = ER_FindATMIndexBySQLID(atmId);
    if(idx != -1)
    {
        BusinessATMs[idx][atmX] = x;
        BusinessATMs[idx][atmY] = y;
        BusinessATMs[idx][atmZ] = z;
        BusinessATMs[idx][atmRX] = rx;
        BusinessATMs[idx][atmRY] = ry;
        BusinessATMs[idx][atmRZ] = rz;
        BusinessATMs[idx][atmVW] = vw;
        BusinessATMs[idx][atmInt] = interior;
        ER_RecreateATMWorld(idx);
    }

    DeletePVar(playerid, "EditingATM");
    ER_Send(playerid, COLOR_GREEN, "ATM position saved.");
    return 1;
}

stock ER_FindBusinessIndexBySQLID(sqlid)
{
    for(new i; i < BusinessCount; i++) if(Businesses[i][bSQLID] == sqlid) return i;
    return -1;
}

stock ER_ClearBusinessWorld()
{
    for(new i; i < BusinessCount; i++)
    {
        if(Businesses[i][bPickupID]) DestroyDynamicPickup(Businesses[i][bPickupID]);
        if(Businesses[i][bLabelID]) DestroyDynamic3DTextLabel(Businesses[i][bLabelID]);
        if(ER_BusinessMapIcon[i]) DestroyDynamicMapIcon(ER_BusinessMapIcon[i]);
        Businesses[i][bPickupID] = 0;
        Businesses[i][bLabelID] = Text3D:0;
        ER_BusinessMapIcon[i] = 0;
    }
    return 1;
}

stock ER_FormatBusinessLabel(idx, label[], size)
{
    new typeName[32], money[32];
    ER_GetBusinessTypeName(Businesses[idx][bType], typeName, sizeof(typeName));
    format(money, sizeof(money), "%s", ER_FormatMoney(Businesses[idx][bPrice]));
    if(Businesses[idx][bOwnerType] == BUSINESS_OWNER_NONE || Businesses[idx][bOwnerID] == 0)
    {
        format(label, size, "%s For Sale!\nPrice: %s\nBusiness ID: %d", typeName, money, Businesses[idx][bSQLID]);
    }
    else
    {
        if(Businesses[idx][bEnterable] && Businesses[idx][bLockable])
        {
            format(label, size, "%s\nOwner: %s\n%s{FFFF00}\nBusiness ID: %d", Businesses[idx][bName], Businesses[idx][bOwnerName], Businesses[idx][bLocked] ? ("{FF0000}Locked") : ("{00FF00}Unlocked"), Businesses[idx][bSQLID]);
        }
        else
        {
            format(label, size, "%s\nOwner: %s\n{FFFF00}Business ID: %d", Businesses[idx][bName], Businesses[idx][bOwnerName], Businesses[idx][bSQLID]);
        }
    }
    return 1;
}

stock ER_CreateBusinessWorld(idx)
{
    if(idx < 0 || idx >= MAX_BUSINESSES) return 0;
    if(Businesses[idx][bSQLID] <= 0) return 0;

    new label[160];
    ER_FormatBusinessLabel(idx, label, sizeof(label));

    new model = Businesses[idx][bPickupModel];
    if(model <= 0) model = ER_DefaultBusinessPickup(Businesses[idx][bType]);

    new ptype = Businesses[idx][bPickupType];
    if(ptype <= 0) ptype = 23; // persistent pickup/icon, does not disappear when touched

    Businesses[idx][bPickupID] = CreateDynamicPickup(model, ptype, Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], Businesses[idx][bExtVW], Businesses[idx][bExtInt], -1, 100.0);
    Businesses[idx][bLabelID] = CreateDynamic3DTextLabel(label, COLOR_YELLOW, Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ] + 0.35, 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, Businesses[idx][bExtVW], Businesses[idx][bExtInt]);
    ER_BusinessMapIcon[idx] = CreateDynamicMapIcon(Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], ER_DefaultBusinessMapIcon(Businesses[idx][bType]), 0, Businesses[idx][bExtVW], Businesses[idx][bExtInt], -1, 300.0, MAPICON_LOCAL);
    return 1;
}

stock ER_UpdateBusinessLabel(idx)
{
    if(idx < 0 || idx >= BusinessCount) return 0;
    if(!Businesses[idx][bLabelID]) return 0;
    new label[160];
    ER_FormatBusinessLabel(idx, label, sizeof(label));
    UpdateDynamic3DTextLabelText(Businesses[idx][bLabelID], COLOR_YELLOW, label);
    return 1;
}

stock ER_LoadBusinesses()
{
    ER_ClearBusinessWorld();
    mysql_tquery(MainPipeline, "SELECT * FROM `businesses` WHERE `enabled`=1", "ER_OnBusinessesLoad");
    ER_LoadBusinessATMs();
    return 1;
}
forward ER_OnBusinessesLoad();
public ER_OnBusinessesLoad()
{
    new rows; cache_get_row_count(rows); BusinessCount = 0;
    for(new r; r < rows && BusinessCount < MAX_BUSINESSES; r++)
    {
        cache_get_value_name_int(r, "id", Businesses[BusinessCount][bSQLID]);
        cache_get_value_name(r, "name", Businesses[BusinessCount][bName], 64);
        cache_get_value_name_int(r, "type", Businesses[BusinessCount][bType]);
        cache_get_value_name_int(r, "owner_type", Businesses[BusinessCount][bOwnerType]);
        cache_get_value_name_int(r, "owner_id", Businesses[BusinessCount][bOwnerID]);
        cache_get_value_name(r, "owner_name", Businesses[BusinessCount][bOwnerName], MAX_PLAYER_NAME_EX);
        cache_get_value_name_int(r, "price", Businesses[BusinessCount][bPrice]);
        cache_get_value_name_int(r, "price_mode", Businesses[BusinessCount][bPriceMode]);
        cache_get_value_name_int(r, "materials", Businesses[BusinessCount][bMaterials]);
        cache_get_value_name_int(r, "materials_capacity", Businesses[BusinessCount][bMaterialsCapacity]);
        cache_get_value_name_int(r, "safe_balance", Businesses[BusinessCount][bSafeBalance]);
        cache_get_value_name_float(r, "ext_x", Businesses[BusinessCount][bExtX]);
        cache_get_value_name_float(r, "ext_y", Businesses[BusinessCount][bExtY]);
        cache_get_value_name_float(r, "ext_z", Businesses[BusinessCount][bExtZ]);
        cache_get_value_name_float(r, "ext_a", Businesses[BusinessCount][bExtA]);
        cache_get_value_name_int(r, "ext_int", Businesses[BusinessCount][bExtInt]);
        cache_get_value_name_int(r, "ext_vw", Businesses[BusinessCount][bExtVW]);
        cache_get_value_name_float(r, "int_x", Businesses[BusinessCount][bIntX]);
        cache_get_value_name_float(r, "int_y", Businesses[BusinessCount][bIntY]);
        cache_get_value_name_float(r, "int_z", Businesses[BusinessCount][bIntZ]);
        cache_get_value_name_float(r, "int_a", Businesses[BusinessCount][bIntA]);
        cache_get_value_name_int(r, "int_int", Businesses[BusinessCount][bIntInt]);
        cache_get_value_name_int(r, "int_vw", Businesses[BusinessCount][bIntVW]);
        cache_get_value_name_float(r, "safe_x", Businesses[BusinessCount][bSafeX]);
        cache_get_value_name_float(r, "safe_y", Businesses[BusinessCount][bSafeY]);
        cache_get_value_name_float(r, "safe_z", Businesses[BusinessCount][bSafeZ]);
        cache_get_value_name_float(r, "safe_a", Businesses[BusinessCount][bSafeA]);
        cache_get_value_name_int(r, "safe_int", Businesses[BusinessCount][bSafeInt]);
        cache_get_value_name_int(r, "safe_vw", Businesses[BusinessCount][bSafeVW]);
        // safe_x/y/z/int/vw is also used as the business service/counter position.
        cache_get_value_name_int(r, "pickup_model", Businesses[BusinessCount][bPickupModel]);
        cache_get_value_name_int(r, "pickup_type", Businesses[BusinessCount][bPickupType]);
        cache_get_value_name_int(r, "locked", Businesses[BusinessCount][bLocked]);
        cache_get_value_name_int(r, "lockable", Businesses[BusinessCount][bLockable]);
        cache_get_value_name_int(r, "enterable", Businesses[BusinessCount][bEnterable]);
        cache_get_value_name_int(r, "custom_ext", Businesses[BusinessCount][bCustomExt]);
        cache_get_value_name_int(r, "custom_int", Businesses[BusinessCount][bCustomInt]);
        if(Businesses[BusinessCount][bLockable] == 0 && Businesses[BusinessCount][bType] != BUSINESS_TYPE_GAS && Businesses[BusinessCount][bType] != BUSINESS_TYPE_DEALERSHIP) Businesses[BusinessCount][bLockable] = 1;
        cache_get_value_name_int(r, "enabled", Businesses[BusinessCount][bEnabled]);
        BusinessCount++;
        ER_CreateBusinessWorld(BusinessCount - 1);
    }
    printf("[Businesses] Loaded %d businesses.", BusinessCount);
    return 1;
}

stock ER_DestroyBusinessWorldSlot(idx)
{
    if(idx < 0 || idx >= MAX_BUSINESSES) return 0;
    if(Businesses[idx][bPickupID]) DestroyDynamicPickup(Businesses[idx][bPickupID]);
    if(Businesses[idx][bLabelID]) DestroyDynamic3DTextLabel(Businesses[idx][bLabelID]);
    if(ER_BusinessMapIcon[idx]) DestroyDynamicMapIcon(ER_BusinessMapIcon[idx]);
    Businesses[idx][bPickupID] = 0;
    Businesses[idx][bLabelID] = Text3D:0;
    ER_BusinessMapIcon[idx] = 0;
    return 1;
}


stock ER_SetBusinessOwnerToPlayer(playerid, accountid, const ownerName[])
{
    new bid = GetPVarInt(playerid, "EditingBusiness");
    if(bid <= 0) return ER_Send(playerid, COLOR_GREY, "No business is selected.");

    new idx = ER_FindBusinessIndexBySQLID(bid);
    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `owner_type`=%d,`owner_id`=%d,`owner_name`='%e',`locked`=1 WHERE `id`=%d", BUSINESS_OWNER_PLAYER, accountid, ownerName, bid);
    mysql_tquery(MainPipeline, q);

    if(idx != -1)
    {
        Businesses[idx][bOwnerType] = BUSINESS_OWNER_PLAYER;
        Businesses[idx][bOwnerID] = accountid;
        format(Businesses[idx][bOwnerName], MAX_PLAYER_NAME_EX, "%s", ownerName);
        Businesses[idx][bLocked] = 1;
        ER_UpdateBusinessLabel(idx);
    }

    ER_ReloadBusinessBySQLID(bid, playerid);
    ER_Send(playerid, COLOR_GREEN, "Business owner set to player.");
    return ER_ShowBusinessEditor(playerid, bid);
}

stock ER_ReloadBusinessBySQLID(sqlid, playerid = INVALID_PLAYER_ID)
{
    new q[128];
    mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `businesses` WHERE `id`=%d LIMIT 1", sqlid);
    mysql_tquery(MainPipeline, q, "ER_OnSingleBusinessReload", "ii", sqlid, playerid);
    return 1;
}

forward ER_OnSingleBusinessReload(sqlid, playerid);
public ER_OnSingleBusinessReload(sqlid, playerid)
{
    new rows; cache_get_row_count(rows);
    new idx = ER_FindBusinessIndexBySQLID(sqlid);

    if(!rows)
    {
        if(idx != -1)
        {
            ER_DestroyBusinessWorldSlot(idx);
            Businesses[idx][bEnabled] = 0;
        }
        if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "Business reloaded: not found or removed.");
        return 1;
    }

    if(idx == -1)
    {
        if(BusinessCount >= MAX_BUSINESSES) return 0;
        idx = BusinessCount++;
    }
    else ER_DestroyBusinessWorldSlot(idx);

    cache_get_value_name_int(0, "id", Businesses[idx][bSQLID]);
    cache_get_value_name(0, "name", Businesses[idx][bName], 64);
    cache_get_value_name_int(0, "type", Businesses[idx][bType]);
    cache_get_value_name_int(0, "owner_type", Businesses[idx][bOwnerType]);
    cache_get_value_name_int(0, "owner_id", Businesses[idx][bOwnerID]);
    cache_get_value_name(0, "owner_name", Businesses[idx][bOwnerName], MAX_PLAYER_NAME_EX);
    cache_get_value_name_int(0, "price", Businesses[idx][bPrice]);
    cache_get_value_name_int(0, "price_mode", Businesses[idx][bPriceMode]);
    cache_get_value_name_int(0, "materials", Businesses[idx][bMaterials]);
    cache_get_value_name_int(0, "materials_capacity", Businesses[idx][bMaterialsCapacity]);
    cache_get_value_name_int(0, "safe_balance", Businesses[idx][bSafeBalance]);
    cache_get_value_name_float(0, "ext_x", Businesses[idx][bExtX]);
    cache_get_value_name_float(0, "ext_y", Businesses[idx][bExtY]);
    cache_get_value_name_float(0, "ext_z", Businesses[idx][bExtZ]);
    cache_get_value_name_float(0, "ext_a", Businesses[idx][bExtA]);
    cache_get_value_name_int(0, "ext_int", Businesses[idx][bExtInt]);
    cache_get_value_name_int(0, "ext_vw", Businesses[idx][bExtVW]);
    cache_get_value_name_float(0, "int_x", Businesses[idx][bIntX]);
    cache_get_value_name_float(0, "int_y", Businesses[idx][bIntY]);
    cache_get_value_name_float(0, "int_z", Businesses[idx][bIntZ]);
    cache_get_value_name_float(0, "int_a", Businesses[idx][bIntA]);
    cache_get_value_name_int(0, "int_int", Businesses[idx][bIntInt]);
    cache_get_value_name_int(0, "int_vw", Businesses[idx][bIntVW]);
    cache_get_value_name_float(0, "safe_x", Businesses[idx][bSafeX]);
    cache_get_value_name_float(0, "safe_y", Businesses[idx][bSafeY]);
    cache_get_value_name_float(0, "safe_z", Businesses[idx][bSafeZ]);
    cache_get_value_name_float(0, "safe_a", Businesses[idx][bSafeA]);
    cache_get_value_name_int(0, "safe_int", Businesses[idx][bSafeInt]);
    cache_get_value_name_int(0, "safe_vw", Businesses[idx][bSafeVW]);
    cache_get_value_name_int(0, "pickup_model", Businesses[idx][bPickupModel]);
    cache_get_value_name_int(0, "pickup_type", Businesses[idx][bPickupType]);
    cache_get_value_name_int(0, "locked", Businesses[idx][bLocked]);
    cache_get_value_name_int(0, "enabled", Businesses[idx][bEnabled]);

    if(Businesses[idx][bEnabled]) ER_CreateBusinessWorld(idx);
    if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "Business reloaded: selected ID only.");
    return 1;
}

CMD:createbusiness(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new type = ER_ParseBusinessType(params);
    if(!type) return ER_ShowBusinessTypes(playerid);
    new Float:x, Float:y, Float:z, Float:a, zone[32], typeName[32];
    GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a); ER_GetPlayerZone(playerid, zone, sizeof(zone)); ER_GetBusinessTypeName(type, typeName, sizeof(typeName));
    new price = ER_DefaultBusinessPrice(type, zone), pickup = ER_DefaultBusinessPickup(type);
    new q[768];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `businesses` (`name`,`type`,`owner_type`,`owner_id`,`owner_name`,`price`,`price_mode`,`materials`,`materials_capacity`,`safe_balance`,`ext_x`,`ext_y`,`ext_z`,`ext_a`,`ext_int`,`ext_vw`,`pickup_model`,`pickup_type`,`locked`,`lockable`,`enterable`,`custom_ext`,`custom_int`,`enabled`) VALUES ('%e',%d,0,0,'Nobody',%d,0,0,2000,0,%f,%f,%f,%f,%d,%d,%d,23,0,1,%d,0,0,1)", typeName, type, price, x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), pickup, (type == BUSINESS_TYPE_GAS || type == BUSINESS_TYPE_DEALERSHIP) ? 0 : 1);
    mysql_tquery(MainPipeline, q, "ER_OnBusinessCreated", "ii", playerid, type);
    return 1;
}
forward ER_OnBusinessCreated(playerid, type);
public ER_OnBusinessCreated(playerid, type)
{
    new bid = cache_insert_id();
    new Float:x, Float:y, Float:z, Float:a, interior, vw;
    ER_SetBusinessInteriorDefaults(type, bid, x, y, z, a, interior, vw);

    new q[512];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `int_x`=%f,`int_y`=%f,`int_z`=%f,`int_a`=%f,`int_int`=%d,`int_vw`=%d WHERE `id`=%d", x, y, z, a, interior, vw, bid);
    mysql_tquery(MainPipeline, q, "ER_OnBusinessCreateFinal", "iii", playerid, bid, type);
    return 1;
}

forward ER_OnBusinessCreateFinal(playerid, bid, type);
public ER_OnBusinessCreateFinal(playerid, bid, type)
{
    ER_CreateDefBusinessProducts(bid, type);
    ER_ReloadBusinessBySQLID(bid);

    new msg[96];
    format(msg, sizeof(msg), "Business created. Business ID: %d. Use /editbusiness %d to edit it.", bid, bid);
    ER_Send(playerid, COLOR_GREEN, msg);
    return 1;
}

stock ER_CreateDefBusinessProducts(businessid, type)
{
    new q[1024];
    if(type == BUSINESS_TYPE_GAS)
    {
        mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `business_products` (`business_id`,`catalog_id`,`product_name`,`product_key`,`price`,`min_price`,`max_price`,`restock_cost`,`material_cost`,`stock`,`stock_capacity`,`admin_enabled`,`owner_enabled`) SELECT %d,c.`id`,'Gas','gas',c.`price`,c.`min_price`,c.`max_price`,c.`restock_cost`,c.`material_cost`,c.`default_stock_capacity`,c.`default_stock_capacity`,1,1 FROM `business_product_catalog` c LEFT JOIN `business_products` bp ON bp.`business_id`=%d AND bp.`product_key`='gas' WHERE c.`business_type`=%d AND c.`product_key`='gas' AND c.`enabled`=1 AND bp.`id` IS NULL LIMIT 1", businessid, businessid, type);
    }
    else
    {
        mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `business_products` (`business_id`,`catalog_id`,`product_name`,`product_key`,`price`,`min_price`,`max_price`,`restock_cost`,`material_cost`,`stock`,`stock_capacity`,`admin_enabled`,`owner_enabled`) SELECT %d,c.`id`,c.`product_name`,c.`product_key`,c.`price`,c.`min_price`,c.`max_price`,c.`restock_cost`,c.`material_cost`,c.`default_stock_capacity`,c.`default_stock_capacity`,1,1 FROM `business_product_catalog` c LEFT JOIN `business_products` bp ON bp.`business_id`=%d AND bp.`catalog_id`=c.`id` WHERE c.`business_type`=%d AND c.`enabled`=1 AND (c.`business_type`<>7 OR c.`product_key`='gas') AND bp.`id` IS NULL", businessid, businessid, type);
    }
    mysql_tquery(MainPipeline, q);
    return 1;
}

stock ER_RebuildBusinessProducts(playerid, businessid, type)
{
    new q[128];
    mysql_format(MainPipeline, q, sizeof(q), "DELETE FROM `business_products` WHERE `business_id`=%d", businessid);
    mysql_tquery(MainPipeline, q, "ER_OnBizProductsDeleted", "iii", playerid, businessid, type);
    return 1;
}

forward ER_OnBizProductsDeleted(playerid, businessid, type);
public ER_OnBizProductsDeleted(playerid, businessid, type)
{
    new q[1024];
    if(type == BUSINESS_TYPE_GAS)
    {
        mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `business_products` (`business_id`,`catalog_id`,`product_name`,`product_key`,`price`,`min_price`,`max_price`,`restock_cost`,`material_cost`,`stock`,`stock_capacity`,`admin_enabled`,`owner_enabled`) SELECT %d,`id`,'Gas','gas',`price`,`min_price`,`max_price`,`restock_cost`,`material_cost`,`default_stock_capacity`,`default_stock_capacity`,1,1 FROM `business_product_catalog` WHERE `business_type`=%d AND `product_key`='gas' AND `enabled`=1 LIMIT 1", businessid, type);
    }
    else
    {
        mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `business_products` (`business_id`,`catalog_id`,`product_name`,`product_key`,`price`,`min_price`,`max_price`,`restock_cost`,`material_cost`,`stock`,`stock_capacity`,`admin_enabled`,`owner_enabled`) SELECT %d,`id`,`product_name`,`product_key`,`price`,`min_price`,`max_price`,`restock_cost`,`material_cost`,`default_stock_capacity`,`default_stock_capacity`,1,1 FROM `business_product_catalog` WHERE `business_type`=%d AND `enabled`=1", businessid, type);
    }
    mysql_tquery(MainPipeline, q, "ER_OnBizProductsRebuilt", "iii", playerid, businessid, type);
    return 1;
}

forward ER_OnBizProductsRebuilt(playerid, businessid, type);
public ER_OnBizProductsRebuilt(playerid, businessid, type)
{
    ER_ReloadBusinessBySQLID(businessid, playerid);
    if(IsPlayerConnected(playerid))
    {
        ER_Send(playerid, COLOR_YELLOW, "Business type changed. Interior, pickup, and products were reset to the new type defaults.");
        ER_ShowBusinessEditor(playerid, businessid);
    }
    return 1;
}

forward ER_OnBizTypeUpdated(playerid, businessid, type);
public ER_OnBizTypeUpdated(playerid, businessid, type)
{
    return ER_RebuildBusinessProducts(playerid, businessid, type);
}

stock ER_GetNearestBusiness(playerid, bool:inside = true)
{
    new vw = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);
    new Float:px, Float:py, Float:pz; GetPlayerPos(playerid, px, py, pz);
    for(new i; i < BusinessCount; i++)
    {
        if(inside && vw == Businesses[i][bIntVW] && interior == Businesses[i][bIntInt]) return i;
        if(IsPlayerInRangeOfPoint(playerid, 3.0, Businesses[i][bExtX], Businesses[i][bExtY], Businesses[i][bExtZ]) && vw == Businesses[i][bExtVW] && interior == Businesses[i][bExtInt]) return i;
    }
    return -1;
}

stock ER_FamBizLockRank(fid) { new idx = ER_FindFamilyIndexBySQLID(fid); if(idx == -1) return 6; return Families[idx][fBusinessLockRank] > 0 ? Families[idx][fBusinessLockRank] : 5; }
stock ER_FamBizDepRank(fid) { new idx = ER_FindFamilyIndexBySQLID(fid); if(idx == -1) return 6; return Families[idx][fBusinessSafeDepositRank] > 0 ? Families[idx][fBusinessSafeDepositRank] : 5; }
stock ER_FamBizWdrRank(fid) { new idx = ER_FindFamilyIndexBySQLID(fid); if(idx == -1) return 6; return Families[idx][fBusinessSafeWithdrawRank] > 0 ? Families[idx][fBusinessSafeWithdrawRank] : 5; }
stock ER_FamBizStockRank(fid) { new idx = ER_FindFamilyIndexBySQLID(fid); if(idx == -1) return 6; return Families[idx][fBusinessRestockRank] > 0 ? Families[idx][fBusinessRestockRank] : 5; }
stock ER_FacBizLockRank(fid) { new idx = ER_FindFactionIndexBySQLID(fid); if(idx == -1) return 6; return Factions[idx][facBusinessLockRank] > 0 ? Factions[idx][facBusinessLockRank] : 5; }
stock ER_FacBizDepRank(fid) { new idx = ER_FindFactionIndexBySQLID(fid); if(idx == -1) return 6; return Factions[idx][facBusinessSafeDepositRank] > 0 ? Factions[idx][facBusinessSafeDepositRank] : 5; }
stock ER_FacBizWdrRank(fid) { new idx = ER_FindFactionIndexBySQLID(fid); if(idx == -1) return 6; return Factions[idx][facBusinessSafeWithdrawRank] > 0 ? Factions[idx][facBusinessSafeWithdrawRank] : 5; }
stock ER_FacBizStockRank(fid) { new idx = ER_FindFactionIndexBySQLID(fid); if(idx == -1) return 6; return Factions[idx][facBusinessRestockRank] > 0 ? Factions[idx][facBusinessRestockRank] : 5; }

stock ER_PlayerCanBusinessDeposit(playerid, bidx)
{
    if(bidx < 0 || bidx >= BusinessCount) return 0;
    if(Businesses[bidx][bOwnerType] == BUSINESS_OWNER_PLAYER) return Businesses[bidx][bOwnerID] == PlayerInfo[playerid][pID];
    if(Businesses[bidx][bOwnerType] == BUSINESS_OWNER_FAMILY) return PlayerInfo[playerid][pFamily] == Businesses[bidx][bOwnerID] && PlayerInfo[playerid][pFamilyRank] >= ER_FamBizDepRank(Businesses[bidx][bOwnerID]);
    if(Businesses[bidx][bOwnerType] == BUSINESS_OWNER_FACTION) return PlayerInfo[playerid][pFaction] == Businesses[bidx][bOwnerID] && PlayerInfo[playerid][pFactionRank] >= ER_FacBizDepRank(Businesses[bidx][bOwnerID]);
    return 0;
}
stock ER_PlayerCanBusinessWithdraw(playerid, bidx)
{
    if(bidx < 0 || bidx >= BusinessCount) return 0;
    if(Businesses[bidx][bOwnerType] == BUSINESS_OWNER_PLAYER) return Businesses[bidx][bOwnerID] == PlayerInfo[playerid][pID];
    if(Businesses[bidx][bOwnerType] == BUSINESS_OWNER_FAMILY) return PlayerInfo[playerid][pFamily] == Businesses[bidx][bOwnerID] && PlayerInfo[playerid][pFamilyRank] >= ER_FamBizWdrRank(Businesses[bidx][bOwnerID]);
    if(Businesses[bidx][bOwnerType] == BUSINESS_OWNER_FACTION) return PlayerInfo[playerid][pFaction] == Businesses[bidx][bOwnerID] && PlayerInfo[playerid][pFactionRank] >= ER_FacBizWdrRank(Businesses[bidx][bOwnerID]);
    return 0;
}
stock ER_PlayerCanBusinessRestock(playerid, bidx)
{
    if(bidx < 0 || bidx >= BusinessCount) return 0;
    if(Businesses[bidx][bOwnerType] == BUSINESS_OWNER_PLAYER) return Businesses[bidx][bOwnerID] == PlayerInfo[playerid][pID];
    if(Businesses[bidx][bOwnerType] == BUSINESS_OWNER_FAMILY) return PlayerInfo[playerid][pFamily] == Businesses[bidx][bOwnerID] && PlayerInfo[playerid][pFamilyRank] >= ER_FamBizStockRank(Businesses[bidx][bOwnerID]);
    if(Businesses[bidx][bOwnerType] == BUSINESS_OWNER_FACTION) return PlayerInfo[playerid][pFaction] == Businesses[bidx][bOwnerID] && PlayerInfo[playerid][pFactionRank] >= ER_FacBizStockRank(Businesses[bidx][bOwnerID]);
    return 0;
}

stock ER_PlayerCanLockBusiness(playerid, idx)
{
    if(idx < 0 || idx >= BusinessCount) return 0;
    if(ER_IsAdmin(playerid, ADMIN_HEAD)) return 1;

    switch(Businesses[idx][bOwnerType])
    {
        case BUSINESS_OWNER_PLAYER: return Businesses[idx][bOwnerID] == PlayerInfo[playerid][pID];
        case BUSINESS_OWNER_FAMILY: return PlayerInfo[playerid][pFamily] == Businesses[idx][bOwnerID] && PlayerInfo[playerid][pFamilyRank] >= ER_FamBizLockRank(Businesses[idx][bOwnerID]);
        case BUSINESS_OWNER_FACTION: return PlayerInfo[playerid][pFaction] == Businesses[idx][bOwnerID] && PlayerInfo[playerid][pFactionRank] >= ER_FacBizLockRank(Businesses[idx][bOwnerID]);
    }
    return 0;
}

stock ER_SendBusinessLockRP(playerid, idx, bool:locked)
{
    if(idx < 0 || idx >= BusinessCount) return 0;
    new Float:x, Float:y, Float:z, rp[160];
    GetPlayerPos(playerid, x, y, z);
    format(rp, sizeof(rp), "* %s %s the %s.", ER_GetName(playerid), locked ? ("locks") : ("unlocks"), Businesses[idx][bName]);
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

stock ER_TryBusinessLock(playerid)
{
    new idx = ER_GetNearestBusiness(playerid, false);
    if(idx == -1) idx = ER_GetNearestBusiness(playerid, true);
    if(idx == -1) return 0;
    if(!Businesses[idx][bLockable]) { ER_Send(playerid, COLOR_GREY, "This business cannot be locked or unlocked."); return 1; }

    if(!ER_PlayerCanLockBusiness(playerid, idx))
    {
        ER_Send(playerid, COLOR_GREY, "You do not have keys to this business.");
        return 1;
    }

    Businesses[idx][bLocked] = !Businesses[idx][bLocked];
    new q[128];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `locked`=%d WHERE `id`=%d", Businesses[idx][bLocked], Businesses[idx][bSQLID]);
    mysql_tquery(MainPipeline, q);
    ER_UpdateBusinessLabel(idx);
    ER_SendBusinessLockRP(playerid, idx, Businesses[idx][bLocked] ? true : false);
    return 1;
}


CMD:enter(playerid, params[])
{
    new idx = ER_GetNearestBusiness(playerid, false);
    if(idx != -1)
    {
        if(!Businesses[idx][bEnterable]) return ER_Send(playerid, COLOR_GREY, "This business does not have an enterable interior.");
        if(Businesses[idx][bLocked]) return ER_Send(playerid, COLOR_GREY, "This business is locked.");

        new rp[144], Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        format(rp, sizeof(rp), "* %s enters the %s.", ER_GetName(playerid), Businesses[idx][bName]);
        ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

        SetPlayerInterior(playerid, Businesses[idx][bIntInt]);
        SetPlayerVirtualWorld(playerid, Businesses[idx][bIntVW]);
        SetPlayerPos(playerid, Businesses[idx][bIntX], Businesses[idx][bIntY], Businesses[idx][bIntZ]);
        SetPlayerFacingAngle(playerid, Businesses[idx][bIntA]);
        if(Businesses[idx][bCustomInt]) ER_StreamPrep(playerid, Businesses[idx][bIntX], Businesses[idx][bIntY], Businesses[idx][bIntZ], Businesses[idx][bIntVW], Businesses[idx][bIntInt], "Business Interior");
        return 1;
    }
    if(ER_TryEnterHouse(playerid)) return 1;
    if(ER_TryEnterDoor(playerid)) return 1;
    return ER_Send(playerid, COLOR_GREY, "You are not near an entrance.");
}
CMD:exit(playerid, params[])
{
    new vw = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid);
    for(new i; i < BusinessCount; i++) if(vw == Businesses[i][bIntVW] && interior == Businesses[i][bIntInt])
    {
        if(Businesses[i][bLocked]) return ER_Send(playerid, COLOR_GREY, "This business is locked.");

        new rp[144], Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        format(rp, sizeof(rp), "* %s exits the %s.", ER_GetName(playerid), Businesses[i][bName]);
        ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

        SetPlayerInterior(playerid, Businesses[i][bExtInt]);
        SetPlayerVirtualWorld(playerid, Businesses[i][bExtVW]);
        SetPlayerPos(playerid, Businesses[i][bExtX], Businesses[i][bExtY], Businesses[i][bExtZ]);
        SetPlayerFacingAngle(playerid, Businesses[i][bExtA]);
        if(Businesses[i][bCustomExt]) ER_StreamPrep(playerid, Businesses[i][bExtX], Businesses[i][bExtY], Businesses[i][bExtZ], Businesses[i][bExtVW], Businesses[i][bExtInt], "Business Exterior");
        return 1;
    }
    if(ER_TryExitHouse(playerid)) return 1;
    if(ER_TryExitDoor(playerid)) return 1;
    return ER_Send(playerid, COLOR_GREY, "You are not inside an exit.");
}

CMD:buy(playerid, params[])
{
    new idx = ER_GetNearestBusiness(playerid, true);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "You are not inside or near a business.");
    if(Businesses[idx][bType] == BUSINESS_TYPE_BANK) return ER_Send(playerid, COLOR_GREY, "Use /deposit, /withdraw, or /wire inside a bank.");
    if(!ER_IsAtBusinessServicePoint(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You must be near the business counter to buy something.");
    ER_BuyBusinessSQL[playerid] = Businesses[idx][bSQLID];
    if(Businesses[idx][bType] == BUSINESS_TYPE_CLOTHES)
    {
        ShowPlayerDialog(playerid, DIALOG_BUY_CLOTHES_TOYS, DIALOG_STYLE_LIST, "Clothes Store", "Clothes - $500\nToys - $1000+", "Select", "Cancel");
        return 1;
    }
    new q[768];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `business_products` (`business_id`,`catalog_id`,`product_name`,`product_key`,`price`,`min_price`,`max_price`,`restock_cost`,`material_cost`,`stock`,`stock_capacity`,`admin_enabled`,`owner_enabled`) SELECT %d,c.`id`,c.`product_name`,c.`product_key`,c.`price`,c.`min_price`,c.`max_price`,c.`restock_cost`,c.`material_cost`,c.`default_stock_capacity`,c.`default_stock_capacity`,1,1 FROM `business_product_catalog` c LEFT JOIN `business_products` bp ON bp.`business_id`=%d AND bp.`product_key`=c.`product_key` WHERE c.`business_type`=%d AND c.`enabled`=1 AND (c.`business_type`<>7 OR c.`product_key`='gas') AND bp.`id` IS NULL", Businesses[idx][bSQLID], Businesses[idx][bSQLID], Businesses[idx][bType]);
    mysql_tquery(MainPipeline, q, "ER_OnBuyProductsSynced", "ii", playerid, Businesses[idx][bSQLID]);
    return 1;
}
forward ER_OnBuyProductsSynced(playerid, businessid);
public ER_OnBuyProductsSynced(playerid, businessid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new q[768];
    new idx = ER_FindBusinessIndexBySQLID(businessid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");
    mysql_format(MainPipeline, q, sizeof(q), "SELECT bp.`id`,bp.`product_name`,bp.`price`,bp.`stock` FROM `business_products` bp JOIN `business_product_catalog` c ON c.`id`=bp.`catalog_id` WHERE bp.`business_id`=%d AND c.`business_type`=%d AND bp.`admin_enabled`=1 AND bp.`owner_enabled`=1 ORDER BY bp.`id` ASC LIMIT 64", businessid, Businesses[idx][bType]);
    mysql_tquery(MainPipeline, q, "ER_ShowBuyProducts", "i", playerid);
    return 1;
}
forward ER_ShowBuyProducts(playerid);
public ER_ShowBuyProducts(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows; cache_get_row_count(rows);
    if(!rows) return ER_Send(playerid, COLOR_GREY, "This business has no products available.");
    new list[2048], name[64], price, productStock, id, stockText[32];
    ER_BuyProductCount[playerid] = 0;
    for(new r; r < rows && r < 64; r++)
    {
        cache_get_value_name_int(r, "id", id);
        cache_get_value_name(r, "product_name", name, sizeof(name));
        cache_get_value_name_int(r, "price", price);
        cache_get_value_name_int(r, "stock", productStock);
        ER_BuyProductID[playerid][r] = id;
        if(productStock > 0) format(stockText, sizeof(stockText), "{00FF00}In Stock");
        else format(stockText, sizeof(stockText), "{FF0000}Out of Stock");
        format(list, sizeof(list), "%s%s - %s - %s\n", list, name, ER_FormatMoney(price), stockText);
        ER_BuyProductCount[playerid]++;
    }
    ShowPlayerDialog(playerid, DIALOG_BUY_PRODUCTS, DIALOG_STYLE_LIST, "Buy Products", list, "Buy", "Cancel");
    return 1;
}


stock ER_PlayerCanManageBusiness(playerid, bidx)
{
    if(bidx < 0 || bidx >= BusinessCount) return 0;
    switch(Businesses[bidx][bOwnerType])
    {
        case BUSINESS_OWNER_PLAYER: return Businesses[bidx][bOwnerID] == PlayerInfo[playerid][pID];
        case BUSINESS_OWNER_FAMILY: return PlayerInfo[playerid][pFamily] == Businesses[bidx][bOwnerID] && PlayerInfo[playerid][pFamilyRank] >= ER_FamBizLockRank(Businesses[bidx][bOwnerID]);
        case BUSINESS_OWNER_FACTION: return PlayerInfo[playerid][pFaction] == Businesses[bidx][bOwnerID] && PlayerInfo[playerid][pFactionRank] >= ER_FacBizLockRank(Businesses[bidx][bOwnerID]);
    }
    return 0;
}

stock ER_GetBusinessOwnerTypeName(type, dest[], size)
{
    switch(type)
    {
        case BUSINESS_OWNER_NONE: format(dest, size, "None / For Sale");
        case BUSINESS_OWNER_PLAYER: format(dest, size, "Player");
        case BUSINESS_OWNER_FAMILY: format(dest, size, "Family");
        case BUSINESS_OWNER_FACTION: format(dest, size, "Faction");
        default: format(dest, size, "Unknown");
    }
    return 1;
}

stock ER_ShowBusinessProductsAdmin(playerid, bid)
{
    new idx = ER_FindBusinessIndexBySQLID(bid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");
    SetPVarInt(playerid, "EditingBusiness", bid);
    ER_BuyProductCount[playerid] = 0;

    new q[2048];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `business_products` (`business_id`,`catalog_id`,`product_name`,`product_key`,`price`,`min_price`,`max_price`,`restock_cost`,`material_cost`,`stock`,`stock_capacity`,`admin_enabled`,`owner_enabled`) SELECT %d,c.`id`,c.`product_name`,c.`product_key`,c.`price`,c.`min_price`,c.`max_price`,c.`restock_cost`,c.`material_cost`,c.`default_stock_capacity`,c.`default_stock_capacity`,1,1 FROM `business_product_catalog` c LEFT JOIN `business_products` bp ON bp.`business_id`=%d AND bp.`product_key`=c.`product_key` WHERE c.`business_type`=%d AND c.`enabled`=1 AND (c.`business_type`<>7 OR c.`product_key`='gas') AND bp.`id` IS NULL", bid, bid, Businesses[idx][bType]);
    if(q[0] == EOS) return ER_Send(playerid, COLOR_GREY, "Could not prepare product sync query.");
    mysql_tquery(MainPipeline, q, "ER_BizProdSyncCB", "ii", playerid, bid);
    return 1;
}

forward ER_BizProdSyncCB(playerid, bid);
public ER_BizProdSyncCB(playerid, bid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new idx = ER_FindBusinessIndexBySQLID(bid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");

    new q[1024];
    mysql_format(MainPipeline, q, sizeof(q), "SELECT bp.`id`,bp.`product_name`,bp.`price`,bp.`min_price`,bp.`max_price`,bp.`restock_cost`,bp.`stock`,bp.`stock_capacity`,bp.`admin_enabled`,bp.`owner_enabled` FROM `business_products` bp JOIN `business_product_catalog` c ON c.`id`=bp.`catalog_id` WHERE bp.`business_id`=%d AND c.`business_type`=%d AND (c.`business_type`<>7 OR bp.`product_key`='gas') ORDER BY bp.`id` ASC LIMIT 64", bid, Businesses[idx][bType]);
    if(q[0] == EOS)
    {
        ER_Send(playerid, COLOR_GREY, "Could not build the product list query for this business.");
        return 1;
    }
    mysql_tquery(MainPipeline, q, "ER_ShowBusinessProductsAdminCB", "i", playerid);
    return 1;
}

forward ER_ShowBusinessProductsAdminCB(playerid);
public ER_ShowBusinessProductsAdminCB(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows; cache_get_row_count(rows);
    if(!rows) return ER_Send(playerid, COLOR_GREY, "This business has no products. Recreate/backfill products for this type.");

    new list[2048], name[64], price, minPrice, maxPrice, restockCost, productStock, cap, pid, ae, oe;
    ER_BuyProductCount[playerid] = 0;
    for(new r; r < rows && r < 64; r++)
    {
        cache_get_value_name_int(r, "id", pid);
        cache_get_value_name(r, "product_name", name, sizeof(name));
        cache_get_value_name_int(r, "price", price);
        cache_get_value_name_int(r, "min_price", minPrice);
        cache_get_value_name_int(r, "max_price", maxPrice);
        cache_get_value_name_int(r, "restock_cost", restockCost);
        cache_get_value_name_int(r, "stock", productStock);
        cache_get_value_name_int(r, "stock_capacity", cap);
        cache_get_value_name_int(r, "admin_enabled", ae);
        cache_get_value_name_int(r, "owner_enabled", oe);
        ER_BuyProductID[playerid][r] = pid;
        format(list, sizeof(list), "%s%d | %s | Price: %s [%s-%s] | Restock: %s | Stock: %d/%d | %s/%s\n", list, pid, name, ER_FormatMoney(price), ER_FormatMoney(minPrice), ER_FormatMoney(maxPrice), ER_FormatMoney(restockCost), productStock, cap, ae ? ("Admin ON") : ("Admin OFF"), oe ? ("Owner ON") : ("Owner OFF"));
        ER_BuyProductCount[playerid]++;
    }
    ShowPlayerDialog(playerid, DIALOG_BUSINESS_PRODUCTS, DIALOG_STYLE_LIST, "Business Products", list, "Edit", "Back");
    return 1;
}

stock ER_ShowBusinessEditor(playerid, bid)
{
    new idx = ER_FindBusinessIndexBySQLID(bid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");

    SetPVarInt(playerid, "EditingBusiness", bid);

    new title[96], list[2048], typeName[32], lockText[12], statusText[12], ownerText[64];
    ER_GetBusinessTypeName(Businesses[idx][bType], typeName, sizeof(typeName));
    if(Businesses[idx][bOwnerType] == BUSINESS_OWNER_NONE || Businesses[idx][bOwnerID] == 0) format(ownerText, sizeof(ownerText), "None / For Sale");
    else format(ownerText, sizeof(ownerText), "%s", Businesses[idx][bOwnerName]);
    format(lockText, sizeof(lockText), "%s", Businesses[idx][bLocked] ? ("{FF0000}Locked") : ("{00FF00}Unlocked"));
    format(statusText, sizeof(statusText), "%s", Businesses[idx][bEnabled] ? ("Enabled") : ("Disabled"));
    format(title, sizeof(title), "Business Editor - ID %d", bid);
    format(list, sizeof(list), "Name: %s\nType: %s\nOwner: %s\nPrice: %s\nSet Exterior Position\nSet Interior Position\nInterior Options\nSet Counter / Service Position\nMaterials: %d/%d\nSafe Balance: %s\nManage Products / Stock\nPickup Icon: %d\nToggle Lock: %s\nToggle Status: %s\nReload This Business\nDelete Business\nType Settings\nToggle Lockable: %s\nToggle Enterable: %s\nToggle CustomExt Stream: %s\nToggle CustomInt Stream: %s",
        Businesses[idx][bName], typeName, ownerText, ER_FormatMoney(Businesses[idx][bPrice]),
        Businesses[idx][bMaterials], Businesses[idx][bMaterialsCapacity], ER_FormatMoney(Businesses[idx][bSafeBalance]),
        Businesses[idx][bPickupModel], lockText, statusText,
        Businesses[idx][bLockable] ? ("Yes") : ("No"), Businesses[idx][bEnterable] ? ("Yes") : ("No"), Businesses[idx][bCustomExt] ? ("Yes") : ("No"), Businesses[idx][bCustomInt] ? ("Yes") : ("No"));
    ShowPlayerDialog(playerid, DIALOG_BUSINESS_EDITOR, DIALOG_STYLE_LIST, title, list, "Select", "Close");
    return 1;
}

CMD:editbusinesses(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new list[2048], typeName[32];
    for(new i; i < BusinessCount; i++) { ER_GetBusinessTypeName(Businesses[i][bType], typeName, sizeof(typeName)); format(list, sizeof(list), "%s%d | %s | %s\n", list, Businesses[i][bSQLID], Businesses[i][bName], typeName); }
    ShowPlayerDialog(playerid, DIALOG_BUSINESS_LIST, DIALOG_STYLE_LIST, "Select Business", list, "Edit", "Cancel");
    return 1;
}

CMD:editbusiness(playerid, params[])
{
    new bid;
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    if(sscanf(params, "d", bid)) return ER_Send(playerid, COLOR_GREY, "USAGE: /editbusiness [id]");
    return ER_ShowBusinessEditor(playerid, bid);
}


stock ER_ShowMyBusinessMenu(playerid, bid, bool:remote = false)
{
    new idx = ER_FindBusinessIndexBySQLID(bid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");
    if(!ER_PlayerCanManageBusiness(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to manage this business.");

    SetPVarInt(playerid, "MyBusiness", bid);
    SetPVarInt(playerid, "MyBizRemote", remote ? 1 : 0);
    new title[96], body[1024];
    if(remote)
    {
        format(title, sizeof(title), "Business - %s", Businesses[idx][bName]);
        format(body, sizeof(body), "Business Information\nTrack Business\nInvite To Business");
    }
    else if(Businesses[idx][bType] == BUSINESS_TYPE_BANK)
    {
        format(title, sizeof(title), "Bank Management - %s", Businesses[idx][bName]);
        format(body, sizeof(body), "Bank Information\nBank Safe: %s\nOwner Deposit To Safe\nView / Track ATMs\nCollect Nearby ATM Fees\nTake Bank Cash Bag\nStore Bank Cash Bag\nRefill Nearby ATM\nLock / Unlock Bank\nTrack Bank",
            ER_FormatMoney(Businesses[idx][bSafeBalance]));
    }
    else if(Businesses[idx][bType] == BUSINESS_TYPE_DEALERSHIP)
    {
        format(title, sizeof(title), "Dealership Management - %s", Businesses[idx][bName]);
        format(body, sizeof(body), "Dealership Information\nSafe Balance: %s\nOwner Deposit To Safe\nManage Vehicle Stock / Prices\nSet Purchased Vehicle Spawn Position\nTrack Dealership\nLock / Unlock Dealership",
            ER_FormatMoney(Businesses[idx][bSafeBalance]));
    }
    else
    {
        format(title, sizeof(title), "Manage Business - %s", Businesses[idx][bName]);
        if(Businesses[idx][bType] == BUSINESS_TYPE_GUNSTORE)
        {
            format(body, sizeof(body), "Business Information\nSafe Balance: %s\nOwner Deposit To Safe\nOwner Withdraw From Safe\nAdd Materials\nWithdraw Materials\nManage Product Prices / Stock\nLock / Unlock Business\nTrack Business\nSell Business",
                ER_FormatMoney(Businesses[idx][bSafeBalance]));
        }
        else
        {
            format(body, sizeof(body), "Business Information\nSafe Balance: %s\nOwner Deposit To Safe\nOwner Withdraw From Safe\nManage Product Prices / Stock\nLock / Unlock Business\nTrack Business\nSell Business",
                ER_FormatMoney(Businesses[idx][bSafeBalance]));
        }
    }
    ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_MENU, DIALOG_STYLE_LIST, title, body, "Select", "Close");
    return 1;
}

CMD:mybusinesses(playerid, params[])
{
    new count, msg[144], list[2048], zone[32];
    for(new i; i < BusinessCount; i++) if(Businesses[i][bOwnerType] == BUSINESS_OWNER_PLAYER && Businesses[i][bOwnerID] == PlayerInfo[playerid][pID])
    {
        ER_BuyProductID[playerid][count] = Businesses[i][bSQLID];
        ER_GetZoneFromPos(Businesses[i][bExtX], Businesses[i][bExtY], Businesses[i][bExtZ], zone, sizeof(zone));
        format(list, sizeof(list), "%s%d - %s (ID %d) - %s\n", list, count + 1, Businesses[i][bName], Businesses[i][bSQLID], zone);
        count++;
    }
    if(!count) return ER_Send(playerid, COLOR_GREY, "You do not own any businesses.");
    ER_BuyProductCount[playerid] = count;
    format(msg, sizeof(msg), "Your Businesses (%d/%d)", count, ER_GetMaxBusinesses(playerid));
    ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_LIST, DIALOG_STYLE_LIST, msg, list, "Select", "Close");
    return 1;
}

CMD:managebusiness(playerid, params[])
{
    new idx = ER_GetNearestBusiness(playerid, true);
    if(idx == -1) idx = ER_GetNearestBusiness(playerid, false);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "You are not near or inside your business.");
    if(!ER_PlayerCanManageBusiness(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to manage this business.");
    return ER_ShowMyBusinessMenu(playerid, Businesses[idx][bSQLID]);
}

CMD:businesssettings(playerid, params[])
{
    #pragma unused params
    new idx = ER_GetNearestBusiness(playerid, true);
    if(idx == -1) idx = ER_GetNearestBusiness(playerid, false);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "You are not near or inside your business.");
    if(!ER_PlayerCanManageBusiness(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to manage this business.");
    return ER_ShowMyBusinessMenu(playerid, Businesses[idx][bSQLID]);
}

stock ER_ShowMyBusinessProducts(playerid, bid)
{
    new idx = ER_FindBusinessIndexBySQLID(bid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");
    if(!ER_PlayerCanManageBusiness(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to manage this business.");
    SetPVarInt(playerid, "MyBusiness", bid);
    new q[768];
    mysql_format(MainPipeline, q, sizeof(q), "SELECT bp.`id`,bp.`product_name`,bp.`price`,bp.`min_price`,bp.`max_price`,bp.`restock_cost`,bp.`stock`,bp.`stock_capacity`,bp.`admin_enabled`,bp.`owner_enabled` FROM `business_products` bp JOIN `business_product_catalog` c ON c.`id`=bp.`catalog_id` WHERE bp.`business_id`=%d AND c.`business_type`=%d AND (c.`business_type`<>7 OR bp.`product_key`='gas') ORDER BY bp.`id` ASC LIMIT 64", bid, Businesses[idx][bType]);
    mysql_tquery(MainPipeline, q, "ER_ShowMyBizProductsCB", "i", playerid);
    return 1;
}

forward ER_ShowMyBizProductsCB(playerid);
public ER_ShowMyBizProductsCB(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows; cache_get_row_count(rows);
    if(!rows) return ER_Send(playerid, COLOR_GREY, "This business has no products configured yet.");
    new list[2048], name[64], price, minPrice, maxPrice, restockCost, productStock, cap, pid, ae, oe, status[32];
    ER_BuyProductCount[playerid] = 0;
    for(new r; r < rows && r < 64; r++)
    {
        cache_get_value_name_int(r, "id", pid);
        cache_get_value_name(r, "product_name", name, sizeof(name));
        cache_get_value_name_int(r, "price", price);
        cache_get_value_name_int(r, "min_price", minPrice);
        cache_get_value_name_int(r, "max_price", maxPrice);
        cache_get_value_name_int(r, "restock_cost", restockCost);
        cache_get_value_name_int(r, "stock", productStock);
        cache_get_value_name_int(r, "stock_capacity", cap);
        cache_get_value_name_int(r, "admin_enabled", ae);
        cache_get_value_name_int(r, "owner_enabled", oe);
        ER_BuyProductID[playerid][r] = pid;
        if(!ae) format(status, sizeof(status), "Disabled by Admin");
        else format(status, sizeof(status), "%s", oe ? ("Enabled") : ("Disabled"));
        new bid = GetPVarInt(playerid, "MyBusiness"), bidx = ER_FindBusinessIndexBySQLID(bid);
        if(bidx != -1 && Businesses[bidx][bType] == BUSINESS_TYPE_GUNSTORE)
            format(list, sizeof(list), "%s%s - %s - Stock: %d/%d - Restock Materials: %d - %s\n", list, name, ER_FormatMoney(price), productStock, cap, restockCost, status);
        else if(bidx != -1 && Businesses[bidx][bType] == BUSINESS_TYPE_GAS)
            format(list, sizeof(list), "%sGas - Price/Gallon: %s - Gallons: %d/%d - Restock Cost/Gallon: %s - %s\n", list, ER_FormatMoney(price), productStock, cap, ER_FormatMoney(restockCost), status);
        else
            format(list, sizeof(list), "%s%s - %s - Stock: %d/%d - Restock: %s - %s\n", list, name, ER_FormatMoney(price), productStock, cap, ER_FormatMoney(restockCost), status);
        ER_BuyProductCount[playerid]++;
    }
    ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_PRODUCTS, DIALOG_STYLE_LIST, "Manage Products", list, "Select", "Back");
    return 1;
}



stock ER_ShowOwnDealerVehOpts(playerid, dealerSqlId)
{
    new didx = ER_FindDealershipDisplayBySQL(dealerSqlId);
    if(didx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid dealership vehicle.");
    new bidx = ER_FindBusinessIndexBySQLID(DealershipDisplay[didx][ddBusinessID]);
    if(bidx == -1 || !ER_PlayerCanManageBusiness(playerid, bidx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to manage this dealership.");

    SetPVarInt(playerid, "SelectedDealerVehicle", dealerSqlId);
    SetPVarInt(playerid, "MyBusiness", DealershipDisplay[didx][ddBusinessID]);
    new title[96], list[256];
    format(title, sizeof(title), "%s Stock / Price", ER_GetVehicleModelName(DealershipDisplay[didx][ddModel]));
    format(list, sizeof(list), "Set Sell Price: %s\nRestock Vehicle: %d/%d\n%s",
        ER_FormatMoney(DealershipDisplay[didx][ddPrice]),
        DealershipDisplay[didx][ddStock], DealershipDisplay[didx][ddStockCapacity],
        DealershipDisplay[didx][ddEnabled] ? "Disable From Sale" : "Enable For Sale");
    return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_OWNER_OPTIONS, DIALOG_STYLE_LIST, title, list, "Select", "Back");
}

forward ER_OnOwnerProductValidated(playerid, bid, pid, action, amount);
public ER_OnOwnerProductValidated(playerid, bid, pid, action, amount)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new idx = ER_FindBusinessIndexBySQLID(bid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");
    if(!ER_PlayerCanManageBusiness(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to manage this business.");

    new rows; cache_get_row_count(rows);
    if(!rows) return ER_Send(playerid, COLOR_GREY, "Invalid or disabled product.");

    new price, minPrice, maxPrice, restockCost, curStock, cap, adminEnabled;
    cache_get_value_name_int(0, "price", price);
    cache_get_value_name_int(0, "min_price", minPrice);
    cache_get_value_name_int(0, "max_price", maxPrice);
    cache_get_value_name_int(0, "restock_cost", restockCost);
    cache_get_value_name_int(0, "stock", curStock);
    cache_get_value_name_int(0, "stock_capacity", cap);
    cache_get_value_name_int(0, "admin_enabled", adminEnabled);
    if(!adminEnabled) return ER_Send(playerid, COLOR_GREY, "This product is disabled by admin.");

    new q[256], msg[160];
    if(action == 10)
    {
        if(amount < minPrice || amount > maxPrice)
        {
            if(Businesses[idx][bType] == BUSINESS_TYPE_GAS)
                format(msg, sizeof(msg), "Gas price per gallon must be between %s and %s.", ER_FormatMoney(minPrice), ER_FormatMoney(maxPrice));
            else
                format(msg, sizeof(msg), "Price must be between %s and %s.", ER_FormatMoney(minPrice), ER_FormatMoney(maxPrice));
            return ER_Send(playerid, COLOR_GREY, msg);
        }
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `price`=%d WHERE `id`=%d AND `business_id`=%d AND `admin_enabled`=1", amount, pid, bid);
        mysql_tquery(MainPipeline, q);
        ER_Send(playerid, COLOR_GREEN, "Product price updated.");
        return ER_ShowMyBusinessProducts(playerid, bid);
    }
    if(action == 11)
    {
        if(cap > 0 && curStock + amount > cap)
        {
            format(msg, sizeof(msg), "You can only restock %d more. Stock capacity is %d.", cap - curStock, cap);
            return ER_Send(playerid, COLOR_GREY, msg);
        }
        new totalCost = restockCost * amount;
        if(Businesses[idx][bType] == BUSINESS_TYPE_GUNSTORE)
        {
            if(Businesses[idx][bMaterials] < totalCost)
            {
                format(msg, sizeof(msg), "The Ammu-Nation safe needs %d materials for this restock.", totalCost);
                return ER_Send(playerid, COLOR_GREY, msg);
            }
            Businesses[idx][bMaterials] -= totalCost;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `materials`=%d WHERE `id`=%d", Businesses[idx][bMaterials], bid);
            mysql_tquery(MainPipeline, q);
        }
        else
        {
            if(Businesses[idx][bSafeBalance] < totalCost)
            {
                if(Businesses[idx][bType] == BUSINESS_TYPE_GAS)
                    format(msg, sizeof(msg), "The gas station safe needs %s to restock %d gallons.", ER_FormatMoney(totalCost), amount);
                else
                    format(msg, sizeof(msg), "The business safe needs %s for this restock.", ER_FormatMoney(totalCost));
                return ER_Send(playerid, COLOR_GREY, msg);
            }
            Businesses[idx][bSafeBalance] -= totalCost;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=%d WHERE `id`=%d", Businesses[idx][bSafeBalance], bid);
            mysql_tquery(MainPipeline, q);
        }
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `stock`=`stock`+%d WHERE `id`=%d AND `business_id`=%d AND `admin_enabled`=1", amount, pid, bid);
        mysql_tquery(MainPipeline, q);
        ER_Send(playerid, COLOR_GREEN, "Product restocked.");
        return ER_ShowMyBusinessProducts(playerid, bid);
    }
    if(action == 12)
    {
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `owner_enabled`=IF(`owner_enabled`=1,0,1) WHERE `id`=%d AND `business_id`=%d AND `admin_enabled`=1", pid, bid);
        mysql_tquery(MainPipeline, q);
        ER_Send(playerid, COLOR_GREEN, "Product availability updated.");
        return ER_ShowMyBusinessProducts(playerid, bid);
    }
    return 1;
}

stock ER_BusinessDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_MY_BUSINESS_LIST)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= ER_BuyProductCount[playerid]) return 1;
        return ER_ShowMyBusinessMenu(playerid, ER_BuyProductID[playerid][listitem], true);
    }

    if(dialogid == DIALOG_MY_BUSINESS_MENU)
    {
        if(!response) return 1;
        new bid = GetPVarInt(playerid, "MyBusiness"), idx = ER_FindBusinessIndexBySQLID(bid);
        if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");
        if(!ER_PlayerCanManageBusiness(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to manage this business.");
        if(GetPVarInt(playerid, "MyBizRemote"))
        {
            switch(listitem)
            {
                case 0:
                {
                    new msg[384], typeName[32], zone[32];
                    ER_GetBusinessTypeName(Businesses[idx][bType], typeName, sizeof(typeName));
                    ER_GetZoneFromPos(Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], zone, sizeof(zone));
                    format(msg, sizeof(msg), "Name: %s\nType: %s\nLocation: %s\nSafe Balance: %s\nStatus: %s", Businesses[idx][bName], typeName, zone, ER_FormatMoney(Businesses[idx][bSafeBalance]), Businesses[idx][bLocked] ? ("Locked") : ("Unlocked"));
                    ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_MENU + 50, DIALOG_STYLE_MSGBOX, "Business Information", msg, "Back", "");
                    return 1;
                }
                case 1:
                {
                    SetPlayerCheckpoint(playerid, Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], 4.0);
                    SetPVarInt(playerid, "TrackBusiness", bid);
                    ER_Send(playerid, COLOR_GREEN, "Business location marked on your map.");
                    return 1;
                }
                case 2:
                {
                    ShowPlayerDialog(playerid, DIALOG_BUSINESS_INVITE_INPUT, DIALOG_STYLE_INPUT, "Invite To Business", "Enter player ID/name to invite to your business:", "Invite", "Back");
                    return 1;
                }
            }
            return 1;
        }
        if(0 && Businesses[idx][bType] == BUSINESS_TYPE_GAS)
        {
            if(listitem == 0)
            {
                GetPlayerPos(playerid, Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ]); GetPlayerFacingAngle(playerid, Businesses[idx][bSafeA]); Businesses[idx][bSafeInt] = GetPlayerInterior(playerid); Businesses[idx][bSafeVW] = GetPlayerVirtualWorld(playerid);
                new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_x`=%f,`safe_y`=%f,`safe_z`=%f,`safe_a`=%f,`safe_int`=%d,`safe_vw`=%d WHERE `id`=%d", Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ], Businesses[idx][bSafeA], Businesses[idx][bSafeInt], Businesses[idx][bSafeVW], bid); mysql_tquery(MainPipeline, q);
                ER_Send(playerid, COLOR_GREEN, "Gas station counter/service position saved.");
                return ER_ShowBusinessEditor(playerid, bid);
            }
            if(listitem == 1)
            {
                new Float:px, Float:py, Float:pz, pq[256]; GetPlayerPos(playerid, px, py, pz);
                mysql_format(MainPipeline, pq, sizeof(pq), "INSERT INTO `gas_pumps` (`business_id`,`x`,`y`,`z`,`vw`,`interior`,`enabled`) VALUES (%d,%f,%f,%f,%d,%d,1)", bid, px, py, pz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
                mysql_tquery(MainPipeline, pq, "ER_OnGasPumpCreated", "i", playerid);
                return 1;
            }
            if(listitem == 2) return ER_ShowGasPumpListForBusiness(playerid, bid);
            return ER_ShowBusinessEditor(playerid, bid);
        }

        if(Businesses[idx][bType] == BUSINESS_TYPE_BANK)
        {
            switch(listitem)
            {
                case 0:
                {
                    new msg[384], zone[32];
                    ER_GetZoneFromPos(Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], zone, sizeof(zone));
                    format(msg, sizeof(msg), "Name: %s\nType: Bank\nLocation: %s\nSafe Balance: %s\nStatus: %s", Businesses[idx][bName], zone, ER_FormatMoney(Businesses[idx][bSafeBalance]), Businesses[idx][bLocked] ? ("Locked") : ("Unlocked"));
                    ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_MENU + 50, DIALOG_STYLE_MSGBOX, "Bank Information", msg, "Back", "");
                    return 1;
                }
                case 1: return ER_ShowMyBusinessMenu(playerid, bid);
                case 2:
                {
                    SetPVarInt(playerid, "MyBizAction", 1);
                    ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Owner Deposit To Safe", "Enter cash amount to deposit into the bank safe:", "Deposit", "Back");
                    return 1;
                }
                case 3:
                {
                    SetPVarInt(playerid, "ATMListOwnerMode", 1);
                    SetPVarInt(playerid, "ATMListBusiness", bid);
                    return ER_ShowBusinessATMs(playerid, bid);
                }
                case 4: return ER_Send(playerid, COLOR_GREY, "Use /collectatm near the ATM for now.");
                case 5: return ER_Send(playerid, COLOR_GREY, "Use /takebankcash [amount] at the bank counter. Max bag: $50,000.");
                case 6: return ER_Send(playerid, COLOR_GREY, "Use /storebankcash at the bank counter.");
                case 7: return ER_Send(playerid, COLOR_GREY, "Use /refillatm [amount] near the ATM. ATM cap: $50,000.");
                case 8:
                {
                    Businesses[idx][bLocked] = !Businesses[idx][bLocked];
                    new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `locked`=%d WHERE `id`=%d", Businesses[idx][bLocked], bid);
                    mysql_tquery(MainPipeline, q);
                    ER_UpdateBusinessLabel(idx);
                    ER_SendBusinessLockRP(playerid, idx, Businesses[idx][bLocked] ? true : false);
                    return ER_ShowMyBusinessMenu(playerid, bid);
                }
                case 9:
                {
                    SetPlayerCheckpoint(playerid, Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], 4.0);
                    SetPVarInt(playerid, "TrackBusiness", bid);
                    ER_Send(playerid, COLOR_GREEN, "Bank location marked on your map.");
                    return 1;
                }
            }
            return 1;
        }
        if(Businesses[idx][bType] == BUSINESS_TYPE_DEALERSHIP)
        {
            switch(listitem)
            {
                case 0:
                {
                    new msg[384], zone[32];
                    ER_GetZoneFromPos(Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], zone, sizeof(zone));
                    format(msg, sizeof(msg), "Name: %s\nType: Dealership\nLocation: %s\nSafe Balance: %s\nStatus: %s", Businesses[idx][bName], zone, ER_FormatMoney(Businesses[idx][bSafeBalance]), Businesses[idx][bLocked] ? ("Locked") : ("Unlocked"));
                    ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_MENU + 50, DIALOG_STYLE_MSGBOX, "Dealership Information", msg, "Back", "");
                    return 1;
                }
                case 1: return ER_ShowMyBusinessMenu(playerid, bid);
                case 2:
                {
                    SetPVarInt(playerid, "MyBizAction", 1);
                    ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Owner Deposit To Safe", "Enter cash amount to deposit into the dealership safe:", "Deposit", "Back");
                    return 1;
                }
                case 3: return ER_ShowDealershipVehicles(playerid, bid, 1);
                case 4: return ER_Send(playerid, COLOR_GREY, "Use admin Dealership Settings to set the purchased vehicle spawn position for now.");
                case 5:
                {
                    SetPlayerCheckpoint(playerid, Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], 4.0);
                    SetPVarInt(playerid, "TrackBusiness", bid);
                    ER_Send(playerid, COLOR_GREEN, "Dealership location marked on your map.");
                    return 1;
                }
                case 6:
                {
                    Businesses[idx][bLocked] = !Businesses[idx][bLocked];
                    new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `locked`=%d WHERE `id`=%d", Businesses[idx][bLocked], bid);
                    mysql_tquery(MainPipeline, q);
                    ER_UpdateBusinessLabel(idx);
                    ER_SendBusinessLockRP(playerid, idx, Businesses[idx][bLocked] ? true : false);
                    return ER_ShowMyBusinessMenu(playerid, bid);
                }
            }
            return 1;
        }

        if(Businesses[idx][bType] == BUSINESS_TYPE_GUNSTORE)
        {
            switch(listitem)
            {
                case 0:
                {
                    new msg[384], typeName[32], zone[32];
                    ER_GetBusinessTypeName(Businesses[idx][bType], typeName, sizeof(typeName));
                    ER_GetZoneFromPos(Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], zone, sizeof(zone));
                    format(msg, sizeof(msg), "Name: %s\nType: %s\nLocation: %s\nSafe Balance: %s\nMaterials: %d/%d\nStatus: %s", Businesses[idx][bName], typeName, zone, ER_FormatMoney(Businesses[idx][bSafeBalance]), Businesses[idx][bMaterials], Businesses[idx][bMaterialsCapacity], Businesses[idx][bLocked] ? ("Locked") : ("Unlocked"));
                    ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_MENU + 50, DIALOG_STYLE_MSGBOX, "Business Information", msg, "Back", "");
                    return 1;
                }
                case 1: return ER_ShowMyBusinessMenu(playerid, bid);
                case 2: { SetPVarInt(playerid, "MyBizAction", 1); ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Owner Deposit To Safe", "Enter cash amount to deposit into the business safe:", "Deposit", "Back"); return 1; }
                case 3: { SetPVarInt(playerid, "MyBizAction", 2); ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Owner Withdraw From Safe", "Enter amount to withdraw from the business safe:", "Withdraw", "Back"); return 1; }
                case 4: { SetPVarInt(playerid, "MyBizAction", 3); ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Add Materials", "Enter materials amount to add from your inventory/carry materials into the business safe:", "Add", "Back"); return 1; }
                case 5: { SetPVarInt(playerid, "MyBizAction", 4); ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Withdraw Materials", "Enter materials amount to withdraw from the business safe:", "Withdraw", "Back"); return 1; }
                case 6: return ER_ShowMyBusinessProducts(playerid, bid);
                case 7:
                {
                    Businesses[idx][bLocked] = !Businesses[idx][bLocked];
                    new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `locked`=%d WHERE `id`=%d", Businesses[idx][bLocked], bid);
                    mysql_tquery(MainPipeline, q); ER_UpdateBusinessLabel(idx); ER_SendBusinessLockRP(playerid, idx, Businesses[idx][bLocked] ? true : false); return ER_ShowMyBusinessMenu(playerid, bid);
                }
                case 8: { SetPlayerCheckpoint(playerid, Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], 4.0); SetPVarInt(playerid, "TrackBusiness", bid); ER_Send(playerid, COLOR_GREEN, "Business location marked on your map."); return 1; }
                case 9: { new refund = Businesses[idx][bPrice] / 2; PlayerInfo[playerid][pCash] += refund; GivePlayerMoney(playerid, refund); new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `owner_type`=0,`owner_id`=0,`owner_name`='Nobody',`locked`=0 WHERE `id`=%d", bid); mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid); return ER_Send(playerid, COLOR_GREEN, "Business sold for 50 percent of its price."); }
            }
            return 1;
        }

        switch(listitem)
        {
            case 0:
            {
                new msg[384], typeName[32], zone[32];
                ER_GetBusinessTypeName(Businesses[idx][bType], typeName, sizeof(typeName));
                ER_GetZoneFromPos(Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], zone, sizeof(zone));
                format(msg, sizeof(msg), "Name: %s\nType: %s\nLocation: %s\nSafe Balance: %s\nMaterials: %d/%d\nStatus: %s", Businesses[idx][bName], typeName, zone, ER_FormatMoney(Businesses[idx][bSafeBalance]), Businesses[idx][bMaterials], Businesses[idx][bMaterialsCapacity], Businesses[idx][bLocked] ? ("Locked") : ("Unlocked"));
                ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_MENU + 50, DIALOG_STYLE_MSGBOX, "Business Information", msg, "Back", "");
                return 1;
            }
            case 1: return ER_ShowMyBusinessMenu(playerid, bid);
            case 2: { SetPVarInt(playerid, "MyBizAction", 1); ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Owner Deposit To Safe", "Enter cash amount to deposit into the business safe:", "Deposit", "Back"); return 1; }
            case 3: { SetPVarInt(playerid, "MyBizAction", 2); ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Owner Withdraw From Safe", "Enter amount to withdraw from the business safe:", "Withdraw", "Back"); return 1; }
            case 4: return ER_ShowMyBusinessProducts(playerid, bid);
            case 5:
            {
                Businesses[idx][bLocked] = !Businesses[idx][bLocked];
                new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `locked`=%d WHERE `id`=%d", Businesses[idx][bLocked], bid);
                mysql_tquery(MainPipeline, q); ER_UpdateBusinessLabel(idx); ER_SendBusinessLockRP(playerid, idx, Businesses[idx][bLocked] ? true : false); return ER_ShowMyBusinessMenu(playerid, bid);
            }
            case 6: { SetPlayerCheckpoint(playerid, Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], 4.0); SetPVarInt(playerid, "TrackBusiness", bid); ER_Send(playerid, COLOR_GREEN, "Business location marked on your map."); return 1; }
            case 7: { new refund = Businesses[idx][bPrice] / 2; PlayerInfo[playerid][pCash] += refund; GivePlayerMoney(playerid, refund); new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `owner_type`=0,`owner_id`=0,`owner_name`='Nobody',`locked`=0 WHERE `id`=%d", bid); mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid); return ER_Send(playerid, COLOR_GREEN, "Business sold for 50 percent of its price."); }
        }
        return 1;
    }

    if(dialogid == DIALOG_MY_BUSINESS_MENU + 50)
    {
        if(!response) return 1;
        return ER_ShowMyBusinessMenu(playerid, GetPVarInt(playerid, "MyBusiness"), GetPVarInt(playerid, "MyBizRemote") ? true : false);
    }

    if(dialogid == DIALOG_MY_BUSINESS_INPUT)
    {
        if(!response) return ER_ShowMyBusinessMenu(playerid, GetPVarInt(playerid, "MyBusiness"));
        new bid = GetPVarInt(playerid, "MyBusiness"), idx = ER_FindBusinessIndexBySQLID(bid), amount = strval(inputtext), action = GetPVarInt(playerid, "MyBizAction");
        if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");
        if(!ER_PlayerCanManageBusiness(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to manage this business.");
        if(amount <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid amount.");
        new q[192];
        if(action == 1)
        {
            if(PlayerInfo[playerid][pCash] < amount) return ER_Send(playerid, COLOR_GREY, "You do not have enough cash.");
            PlayerInfo[playerid][pCash] -= amount; GivePlayerMoney(playerid, -amount); Businesses[idx][bSafeBalance] += amount;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=%d WHERE `id`=%d", Businesses[idx][bSafeBalance], bid); mysql_tquery(MainPipeline, q);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `cash`=%d WHERE `id`=%d", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pID]); mysql_tquery(MainPipeline, q);
            ER_Send(playerid, COLOR_GREEN, "Cash deposited into the business safe.");
            return ER_ShowMyBusinessMenu(playerid, bid);
        }
        if(action == 2)
        {
            if(Businesses[idx][bSafeBalance] < amount) return ER_Send(playerid, COLOR_GREY, "The business safe does not have that much cash.");
            Businesses[idx][bSafeBalance] -= amount; PlayerInfo[playerid][pCash] += amount; GivePlayerMoney(playerid, amount);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=%d WHERE `id`=%d", Businesses[idx][bSafeBalance], bid); mysql_tquery(MainPipeline, q);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `cash`=%d WHERE `id`=%d", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pID]); mysql_tquery(MainPipeline, q);
            ER_Send(playerid, COLOR_GREEN, "Cash withdrawn from the business safe.");
            return ER_ShowMyBusinessMenu(playerid, bid);
        }
        if(action == 3 || action == 4)
        {
            if(Businesses[idx][bType] != BUSINESS_TYPE_GUNSTORE) return ER_Send(playerid, COLOR_GREY, "This business does not use owner material storage.");
            if(action == 3)
            {
                if(PlayerInfo[playerid][pMaterials] < amount) return ER_Send(playerid, COLOR_GREY, "You do not have enough materials.");
                if(Businesses[idx][bMaterials] + amount > Businesses[idx][bMaterialsCapacity]) return ER_Send(playerid, COLOR_GREY, "The business material safe cannot hold that much.");
                PlayerInfo[playerid][pMaterials] -= amount;
                Businesses[idx][bMaterials] += amount;
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `materials`=%d WHERE `id`=%d", Businesses[idx][bMaterials], bid); mysql_tquery(MainPipeline, q);
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `materials`=%d WHERE `id`=%d", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]); mysql_tquery(MainPipeline, q);
                ER_Send(playerid, COLOR_GREEN, "Materials added to the Ammu-Nation safe.");
                return ER_ShowMyBusinessMenu(playerid, bid);
            }
            if(Businesses[idx][bMaterials] < amount) return ER_Send(playerid, COLOR_GREY, "The business material safe does not have that much.");
            Businesses[idx][bMaterials] -= amount;
            PlayerInfo[playerid][pMaterials] += amount;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `materials`=%d WHERE `id`=%d", Businesses[idx][bMaterials], bid); mysql_tquery(MainPipeline, q);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `materials`=%d WHERE `id`=%d", PlayerInfo[playerid][pMaterials], PlayerInfo[playerid][pID]); mysql_tquery(MainPipeline, q);
            ER_Send(playerid, COLOR_GREEN, "Materials withdrawn from the Ammu-Nation safe.");
            return ER_ShowMyBusinessMenu(playerid, bid);
        }
        if(action >= 10 && action <= 11)
        {
            new pid = GetPVarInt(playerid, "MyBusinessProduct");
            if(pid <= 0) return ER_ShowMyBusinessProducts(playerid, bid);
            mysql_format(MainPipeline, q, sizeof(q), "SELECT `price`,`min_price`,`max_price`,`restock_cost`,`stock`,`stock_capacity`,`admin_enabled` FROM `business_products` WHERE `id`=%d AND `business_id`=%d LIMIT 1", pid, bid);
            mysql_tquery(MainPipeline, q, "ER_OnOwnerProductValidated", "iiiii", playerid, bid, pid, action, amount);
            return 1;
        }
        return 1;
    }

    if(dialogid == DIALOG_MY_BUSINESS_PRODUCTS)
    {
        if(!response) return ER_ShowMyBusinessMenu(playerid, GetPVarInt(playerid, "MyBusiness"));
        if(listitem < 0 || listitem >= ER_BuyProductCount[playerid]) return 1;
        SetPVarInt(playerid, "MyBusinessProduct", ER_BuyProductID[playerid][listitem]);
        new prodBid = GetPVarInt(playerid, "MyBusiness"), prodBidx = ER_FindBusinessIndexBySQLID(prodBid);
        if(prodBidx != -1 && Businesses[prodBidx][bType] == BUSINESS_TYPE_GAS)
            ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_PRODUCT_OPTIONS, DIALOG_STYLE_LIST, "Gas Product", "Set Price Per Gallon\nRestock Gas Gallons\nToggle Gas On/Off", "Select", "Back");
        else
            ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_PRODUCT_OPTIONS, DIALOG_STYLE_LIST, "Product Options", "Change Sell Price\nRestock Product\nToggle Product On/Off", "Select", "Back");
        return 1;
    }

    if(dialogid == DIALOG_MY_BUSINESS_PRODUCT_OPTIONS)
    {
        if(!response) return ER_ShowMyBusinessProducts(playerid, GetPVarInt(playerid, "MyBusiness"));
        SetPVarInt(playerid, "MyBizAction", 10 + listitem);
        new optBid = GetPVarInt(playerid, "MyBusiness"), optBidx = ER_FindBusinessIndexBySQLID(optBid);
        if(listitem == 0)
        {
            if(optBidx != -1 && Businesses[optBidx][bType] == BUSINESS_TYPE_GAS)
                ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Set Gas Price", "Enter price per gallon:", "Save", "Back");
            else
                ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Change Product Price", "Enter new product price:", "Save", "Back");
        }
        else if(listitem == 1)
        {
            if(optBidx != -1 && Businesses[optBidx][bType] == BUSINESS_TYPE_GAS)
                ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Restock Gas", "Enter gallons to restock:\nThis uses cash from the gas station safe based on restock cost per gallon.", "Restock", "Back");
            else
                ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Restock Product", "Enter amount of stock to restock:\nAmmu-Nation uses materials from the business safe; other businesses use cash safe balance.", "Restock", "Back");
        }
        else if(listitem == 2)
        {
            new pid = GetPVarInt(playerid, "MyBusinessProduct"), bid = GetPVarInt(playerid, "MyBusiness"), q[192];
            mysql_format(MainPipeline, q, sizeof(q), "SELECT `price`,`min_price`,`max_price`,`restock_cost`,`stock`,`stock_capacity`,`admin_enabled` FROM `business_products` WHERE `id`=%d AND `business_id`=%d LIMIT 1", pid, bid);
            mysql_tquery(MainPipeline, q, "ER_OnOwnerProductValidated", "iiiii", playerid, bid, pid, 12, 0);
            return 1;
        }
        return 1;
    }


    if(dialogid == DIALOG_BUSINESS_INVITE_INPUT)
    {
        if(!response) return ER_ShowMyBusinessMenu(playerid, GetPVarInt(playerid, "MyBusiness"), true);
        new bid = GetPVarInt(playerid, "MyBusiness"), idx = ER_FindBusinessIndexBySQLID(bid);
        if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");
        if(Businesses[idx][bOwnerType] != BUSINESS_OWNER_PLAYER || Businesses[idx][bOwnerID] != PlayerInfo[playerid][pID]) return ER_Send(playerid, COLOR_GREY, "You do not own this business.");
        new target;
        if(sscanf(inputtext, "u", target) || target == INVALID_PLAYER_ID || !IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
        if(target == playerid) return ER_Send(playerid, COLOR_GREY, "You cannot invite yourself.");
        ER_BusinessInviteFrom[target] = playerid;
        ER_BusinessInviteID[target] = bid;
        new msg[160];
        format(msg, sizeof(msg), "%s has invited you to visit their business, %s. Use /accept invitation or /reject invitation.", ER_GetName(playerid), Businesses[idx][bName]);
        ER_Send(target, COLOR_YELLOW, msg);
        format(msg, sizeof(msg), "You invited %s to visit %s.", ER_GetName(target), Businesses[idx][bName]);
        ER_Send(playerid, COLOR_GREEN, msg);
        return 1;
    }

    if(dialogid == DIALOG_BUSINESS_LIST)
    {
        if(response && listitem >= 0 && listitem < BusinessCount) ER_ShowBusinessEditor(playerid, Businesses[listitem][bSQLID]);
        return 1;
    }

    if(dialogid == DIALOG_BUSINESS_EDITOR)
    {
        if(!response) return 1;
        new bid = GetPVarInt(playerid, "EditingBusiness"), idx = ER_FindBusinessIndexBySQLID(bid);
        if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");

        switch(listitem)
        {
            case 0:
            {
                SetPVarInt(playerid, "BizEditAction", 1);
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Business Name", "Enter the new business name:", "Save", "Back");
                return 1;
            }
            case 1:
            {
                SetPVarInt(playerid, "BizEditAction", 2);
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Business Type", "Enter type name or ID:\n1 - 24/7 Store\n2 - Restaurant\n3 - Clothes Store\n4 - Gun Store\n5 - Dealership\n6 - Bar / Club\n7 - Gas Station\n8 - Bank\n9 - Gym", "Save", "Back");
                return 1;
            }
            case 2:
            {
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_OWNER_TYPE, DIALOG_STYLE_LIST, "Set Business Owner", "None / For Sale\nPlayer\nFamily\nFaction", "Select", "Back");
                return 1;
            }
            case 3:
            {
                SetPVarInt(playerid, "BizEditAction", 4);
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Business Price", "Enter new price:", "Save", "Back");
                return 1;
            }
            case 4:
            {
                GetPlayerPos(playerid, Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ]);
                GetPlayerFacingAngle(playerid, Businesses[idx][bExtA]);
                Businesses[idx][bExtInt] = GetPlayerInterior(playerid);
                Businesses[idx][bExtVW] = GetPlayerVirtualWorld(playerid);
                new q[256];
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `ext_x`=%f,`ext_y`=%f,`ext_z`=%f,`ext_a`=%f,`ext_int`=%d,`ext_vw`=%d WHERE `id`=%d", Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], Businesses[idx][bExtA], Businesses[idx][bExtInt], Businesses[idx][bExtVW], bid);
                mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, INVALID_PLAYER_ID);
                ER_Send(playerid, COLOR_GREEN, "Business exterior position saved.");
                return ER_ShowBusinessEditor(playerid, bid);
            }
            case 5:
            {
                GetPlayerPos(playerid, Businesses[idx][bIntX], Businesses[idx][bIntY], Businesses[idx][bIntZ]);
                GetPlayerFacingAngle(playerid, Businesses[idx][bIntA]);
                Businesses[idx][bIntInt] = GetPlayerInterior(playerid);
                new q[256];
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `int_x`=%f,`int_y`=%f,`int_z`=%f,`int_a`=%f,`int_int`=%d WHERE `id`=%d", Businesses[idx][bIntX], Businesses[idx][bIntY], Businesses[idx][bIntZ], Businesses[idx][bIntA], Businesses[idx][bIntInt], bid);
                mysql_tquery(MainPipeline, q);
                ER_Send(playerid, COLOR_GREEN, "Business interior position saved. Interior VW was not changed.");
                return ER_ShowBusinessEditor(playerid, bid);
            }
            case 6:
            {
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_INTERIORS, DIALOG_STYLE_LIST, "Interior Options", "Use Default Interior For Type\nSet Interior Position To My Current Position\nReset Interior VW To Business ID\nSet Interior VW Manually", "Select", "Back");
                return 1;
            }
            case 7:
            {
                GetPlayerPos(playerid, Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ]);
                GetPlayerFacingAngle(playerid, Businesses[idx][bSafeA]);
                Businesses[idx][bSafeInt] = GetPlayerInterior(playerid);
                Businesses[idx][bSafeVW] = GetPlayerVirtualWorld(playerid);
                new q[256];
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_x`=%f,`safe_y`=%f,`safe_z`=%f,`safe_a`=%f,`safe_int`=%d,`safe_vw`=%d WHERE `id`=%d", Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ], Businesses[idx][bSafeA], Businesses[idx][bSafeInt], Businesses[idx][bSafeVW], bid);
                mysql_tquery(MainPipeline, q);
                ER_Send(playerid, COLOR_GREEN, "Business counter/service position saved.");
                return ER_ShowBusinessEditor(playerid, bid);
            }
            case 8:
            {
                SetPVarInt(playerid, "BizEditAction", 9);
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Business Materials", "Enter new materials amount:", "Save", "Back");
                return 1;
            }
            case 9:
            {
                SetPVarInt(playerid, "BizEditAction", 10);
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Business Safe Balance", "Enter new safe balance:", "Save", "Back");
                return 1;
            }
            case 10: return ER_ShowBusinessProductsAdmin(playerid, bid);
            case 11:
            {
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_PICKUP, DIALOG_STYLE_LIST, "Pickup Icon", "Default For Type\nBlue Business Icon\nWhite Arrow / Door\nStore\nClothes\nFood\nGun\nDealership / Car\nGas Station\nBank / Money\nBar / Club\nGym\nCustom Model ID", "Select", "Back");
                return 1;
            }
            case 12:
            {
                Businesses[idx][bLocked] = !Businesses[idx][bLocked];
                new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `locked`=%d WHERE `id`=%d", Businesses[idx][bLocked], bid); mysql_tquery(MainPipeline, q); ER_UpdateBusinessLabel(idx);
                ER_SendBusinessLockRP(playerid, idx, Businesses[idx][bLocked] ? true : false);
                return ER_ShowBusinessEditor(playerid, bid);
            }
            case 13:
            {
                Businesses[idx][bEnabled] = !Businesses[idx][bEnabled];
                new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `enabled`=%d WHERE `id`=%d", Businesses[idx][bEnabled], bid); mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid);
                ER_Send(playerid, COLOR_GREEN, "Business status updated. If disabled, it will disappear from the loaded list.");
                return 1;
            }
            case 14:
            {
                ER_ReloadBusinessBySQLID(bid, playerid);
                return ER_ShowBusinessEditor(playerid, bid);
            }
            case 15:
            {
                if(Businesses[idx][bType] == BUSINESS_TYPE_DEALERSHIP && ER_CountDealerVehForBiz(bid) > 0)
                {
                    new msg[160]; format(msg, sizeof(msg), "This dealership has %d linked vehicle(s). Delete/disable this business and disable its dealership vehicles?", ER_CountDealerVehForBiz(bid));
                    return ShowPlayerDialog(playerid, DIALOG_BUSINESS_DELETE_CONFIRM, DIALOG_STYLE_MSGBOX, "Confirm Dealership Delete", msg, "Confirm", "Cancel");
                }
                new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `enabled`=0 WHERE `id`=%d", bid); mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid);
                DeletePVar(playerid, "EditingBusiness");
                return ER_Send(playerid, COLOR_GREEN, "Business deleted/disabled.");
            }
            case 16:
            {
                if(Businesses[idx][bType] == BUSINESS_TYPE_BANK) ShowPlayerDialog(playerid, DIALOG_BUSINESS_TYPE_SETTINGS, DIALOG_STYLE_LIST, "Bank Settings", "Set Counter Position\nCreate ATM Here\nEdit ATMs", "Select", "Back");
                else if(Businesses[idx][bType] == BUSINESS_TYPE_DEALERSHIP) ShowPlayerDialog(playerid, DIALOG_BUSINESS_TYPE_SETTINGS, DIALOG_STYLE_LIST, "Dealership Settings", "Create Dealership Vehicle\nEdit Dealership Vehicles\nSet Purchased Vehicle Spawn Position", "Select", "Back");
                else if(Businesses[idx][bType] == BUSINESS_TYPE_GAS) ShowPlayerDialog(playerid, DIALOG_BUSINESS_TYPE_SETTINGS, DIALOG_STYLE_LIST, "Gas Station Settings", "Set Counter Position\nCreate Fuel Pump Here\nEdit Fuel Pumps", "Select", "Back");
                else ShowPlayerDialog(playerid, DIALOG_BUSINESS_TYPE_SETTINGS, DIALOG_STYLE_LIST, "Business Type Settings", "Set Counter Position\nEdit Products / Stock", "Select", "Back");
                return 1;
            }
            case 17:
            {
                Businesses[idx][bLockable] = !Businesses[idx][bLockable];
                new q[160]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `lockable`=%d WHERE `id`=%d", Businesses[idx][bLockable], bid); mysql_tquery(MainPipeline, q); ER_UpdateBusinessLabel(idx);
                ER_Send(playerid, COLOR_GREEN, "Business lockable option updated.");
                return ER_ShowBusinessEditor(playerid, bid);
            }
            case 18:
            {
                Businesses[idx][bEnterable] = !Businesses[idx][bEnterable];
                new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `enterable`=%d WHERE `id`=%d", Businesses[idx][bEnterable], bid); mysql_tquery(MainPipeline, q); ER_UpdateBusinessLabel(idx);
                ER_Send(playerid, COLOR_GREEN, "Business enterable option updated. /managebusiness still works at pickup.");
                return ER_ShowBusinessEditor(playerid, bid);
            }
            case 19:
            {
                Businesses[idx][bCustomExt] = !Businesses[idx][bCustomExt];
                new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `custom_ext`=%d WHERE `id`=%d", Businesses[idx][bCustomExt], bid); mysql_tquery(MainPipeline, q);
                ER_Send(playerid, COLOR_GREEN, "Business CustomExt stream freeze toggled.");
                return ER_ShowBusinessEditor(playerid, bid);
            }
            case 20:
            {
                Businesses[idx][bCustomInt] = !Businesses[idx][bCustomInt];
                new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `custom_int`=%d WHERE `id`=%d", Businesses[idx][bCustomInt], bid); mysql_tquery(MainPipeline, q);
                ER_Send(playerid, COLOR_GREEN, "Business CustomInt stream freeze toggled.");
                return ER_ShowBusinessEditor(playerid, bid);
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_BUSINESS_INPUT)
    {
        if(!response) return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        new bid = GetPVarInt(playerid, "EditingBusiness"), idx = ER_FindBusinessIndexBySQLID(bid), action = GetPVarInt(playerid, "BizEditAction");
        if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");
        new q[512];
        switch(action)
        {
            case 1:
            {
                if(isnull(inputtext)) return ER_Send(playerid, COLOR_GREY, "Business name cannot be empty.");
                format(Businesses[idx][bName], 64, "%s", inputtext);
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `name`='%e' WHERE `id`=%d", inputtext, bid);
            }
            case 2:
            {
                new type = ER_ParseBusinessType(inputtext);
                if(!type) return ER_ShowBusinessTypes(playerid);
                if(Businesses[idx][bType] == BUSINESS_TYPE_DEALERSHIP && type != BUSINESS_TYPE_DEALERSHIP && ER_CountDealerVehForBiz(bid) > 0)
                {
                    SetPVarInt(playerid, "PendingBusinessType", type);
                    new msg[180]; format(msg, sizeof(msg), "This dealership has %d linked vehicle(s). Changing the type will disable the linked dealership vehicles. Continue?", ER_CountDealerVehForBiz(bid));
                    return ShowPlayerDialog(playerid, DIALOG_BUSINESS_TYPE_CONFIRM, DIALOG_STYLE_MSGBOX, "Confirm Type Change", msg, "Confirm", "Cancel");
                }
                Businesses[idx][bType] = type;
                new typeName[32]; ER_GetBusinessTypeName(type, typeName, sizeof(typeName));
                new Float:ix, Float:iy, Float:iz, Float:ia, iint, ivw;
                ER_SetBusinessInteriorDefaults(type, bid, ix, iy, iz, ia, iint, ivw);
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `type`=%d,`name`='%e',`pickup_model`=%d,`pickup_type`=23,`int_x`=%f,`int_y`=%f,`int_z`=%f,`int_a`=%f,`int_int`=%d,`int_vw`=%d WHERE `id`=%d", type, typeName, ER_DefaultBusinessPickup(type), ix, iy, iz, ia, iint, ivw, bid);
                mysql_tquery(MainPipeline, q, "ER_OnBizTypeUpdated", "iii", playerid, bid, type);
                DeletePVar(playerid, "BizEditAction");
                return 1;
            }
            case 4:
            {
                new price = strval(inputtext); if(price < 0) price = 0;
                Businesses[idx][bPrice] = price;
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `price`=%d,`price_mode`=1 WHERE `id`=%d", price, bid);
            }
            case 9:
            {
                new amount = strval(inputtext); if(amount < 0) amount = 0;
                Businesses[idx][bMaterials] = amount;
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `materials`=%d WHERE `id`=%d", amount, bid);
            }
            case 10:
            {
                new amount = strval(inputtext); if(amount < 0) amount = 0;
                Businesses[idx][bSafeBalance] = amount;
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=%d WHERE `id`=%d", amount, bid);
            }
            case 20:
            {
                new amount = strval(inputtext); if(amount < 0) amount = 0;
                new pid = GetPVarInt(playerid, "EditingBusinessProduct");
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `stock`=%d WHERE `id`=%d", amount, pid);
                mysql_tquery(MainPipeline, q);
                DeletePVar(playerid, "EditingBusinessProduct");
                DeletePVar(playerid, "BizEditAction");
                ER_Send(playerid, COLOR_GREEN, "Product stock updated.");
                return ER_ShowBusinessProductsAdmin(playerid, bid);
            }
            case 21:
            {
                new price = strval(inputtext); if(price < 0) price = 0;
                new pid = GetPVarInt(playerid, "EditingBusinessProduct");
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `price`=%d WHERE `id`=%d", price, pid);
                mysql_tquery(MainPipeline, q);
                DeletePVar(playerid, "EditingBusinessProduct");
                DeletePVar(playerid, "BizEditAction");
                ER_Send(playerid, COLOR_GREEN, "Product price updated.");
                return ER_ShowBusinessProductsAdmin(playerid, bid);
            }
            case 22:
            {
                new amount = strval(inputtext); if(amount < 0) amount = 0;
                new pid = GetPVarInt(playerid, "EditingBusinessProduct");
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `min_price`=%d WHERE `id`=%d", amount, pid);
                mysql_tquery(MainPipeline, q); DeletePVar(playerid, "EditingBusinessProduct"); DeletePVar(playerid, "BizEditAction"); ER_Send(playerid, COLOR_GREEN, "Minimum price updated."); return ER_ShowBusinessProductsAdmin(playerid, bid);
            }
            case 23:
            {
                new amount = strval(inputtext); if(amount < 0) amount = 0;
                new pid = GetPVarInt(playerid, "EditingBusinessProduct");
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `max_price`=%d WHERE `id`=%d", amount, pid);
                mysql_tquery(MainPipeline, q); DeletePVar(playerid, "EditingBusinessProduct"); DeletePVar(playerid, "BizEditAction"); ER_Send(playerid, COLOR_GREEN, "Maximum price updated."); return ER_ShowBusinessProductsAdmin(playerid, bid);
            }
            case 24:
            {
                new amount = strval(inputtext); if(amount < 0) amount = 0;
                new pid = GetPVarInt(playerid, "EditingBusinessProduct");
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `restock_cost`=%d WHERE `id`=%d", amount, pid);
                mysql_tquery(MainPipeline, q); DeletePVar(playerid, "EditingBusinessProduct"); DeletePVar(playerid, "BizEditAction"); ER_Send(playerid, COLOR_GREEN, "Restock cost updated."); return ER_ShowBusinessProductsAdmin(playerid, bid);
            }
            case 25:
            {
                new amount = strval(inputtext); if(amount < 0) amount = 0;
                new pid = GetPVarInt(playerid, "EditingBusinessProduct");
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `stock_capacity`=%d,`stock`=LEAST(`stock`,%d) WHERE `id`=%d", amount, amount, pid);
                mysql_tquery(MainPipeline, q); DeletePVar(playerid, "EditingBusinessProduct"); DeletePVar(playerid, "BizEditAction"); ER_Send(playerid, COLOR_GREEN, "Max stock updated."); return ER_ShowBusinessProductsAdmin(playerid, bid);
            }
            case 30:
            {
                new vw = strval(inputtext); if(vw < 0) vw = 0;
                Businesses[idx][bIntVW] = vw;
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `int_vw`=%d WHERE `id`=%d", vw, bid);
            }
            case 40:
            {
                new model = strval(inputtext); if(model <= 0) model = ER_DefaultBusinessPickup(Businesses[idx][bType]);
                Businesses[idx][bPickupModel] = model;
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `pickup_model`=%d,`pickup_type`=23 WHERE `id`=%d", model, bid);
            }
            case 60:
            {
                new target;
                if(sscanf(inputtext, "u", target) || target == INVALID_PLAYER_ID || !IsPlayerConnected(target) || !PlayerInfo[target][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "Invalid player.");
                DeletePVar(playerid, "BizEditAction");
                return ER_SetBusinessOwnerToPlayer(playerid, PlayerInfo[target][pID], PlayerInfo[target][pName]);
            }
            default: return ER_ShowBusinessEditor(playerid, bid);
        }
        mysql_tquery(MainPipeline, q);
        DeletePVar(playerid, "BizEditAction");
        ER_ReloadBusinessBySQLID(bid, playerid);
        ER_Send(playerid, COLOR_GREEN, "Business setting saved.");
        return ER_ShowBusinessEditor(playerid, bid);
    }

    if(dialogid == DIALOG_BUSINESS_OWNER_TYPE)
    {
        if(!response) return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        new bid = GetPVarInt(playerid, "EditingBusiness");
        if(listitem == 0)
        {
            new q[160]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `owner_type`=0,`owner_id`=0,`owner_name`='Nobody' WHERE `id`=%d", bid);
            mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid);
            ER_Send(playerid, COLOR_GREEN, "Business owner cleared.");
            return ER_ShowBusinessEditor(playerid, bid);
        }
        if(listitem == 1) return ShowPlayerDialog(playerid, DIALOG_BUSINESS_OWNER_PLAYER_MODE, DIALOG_STYLE_LIST, "Select Player Owner", "Online Player\nOffline Player", "Select", "Back");
        if(listitem == 2)
        {
            new list[2048];
            for(new i; i < FamilyCount; i++) format(list, sizeof(list), "%s%d - %s\n", list, Families[i][fSQLID], Families[i][fName]);
            if(isnull(list)) format(list, sizeof(list), "No families found.");
            return ShowPlayerDialog(playerid, DIALOG_BUSINESS_OWNER_FAMILY, DIALOG_STYLE_LIST, "Select Family Owner", list, "Select", "Back");
        }
        if(listitem == 3)
        {
            new list[2048];
            for(new i; i < FactionCount; i++) format(list, sizeof(list), "%s%d - %s\n", list, Factions[i][facSQLID], Factions[i][facName]);
            if(isnull(list)) format(list, sizeof(list), "No factions found.");
            return ShowPlayerDialog(playerid, DIALOG_BUSINESS_OWNER_FACTION, DIALOG_STYLE_LIST, "Select Faction Owner", list, "Select", "Back");
        }
        return 1;
    }

    if(dialogid == DIALOG_BUSINESS_OWNER_PLAYER_MODE)
    {
        if(!response) return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        if(listitem == 0)
        {
            SetPVarInt(playerid, "BizEditAction", 60);
            ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Online Player Owner", "Enter online player ID/name:", "Save", "Back");
            return 1;
        }
        new q[128]; mysql_format(MainPipeline, q, sizeof(q), "SELECT `id`,`username` FROM `accounts` ORDER BY `id` ASC LIMIT 100");
        mysql_tquery(MainPipeline, q, "ER_ShowBizOfflineOwnersCB", "i", playerid);
        return 1;
    }


    if(dialogid == DIALOG_BUSINESS_OWNER_FAMILY)
    {
        if(!response) return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        if(listitem < 0 || listitem >= FamilyCount) return 1;
        new bid = GetPVarInt(playerid, "EditingBusiness"), q[256];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `owner_type`=2,`owner_id`=%d,`owner_name`='%e' WHERE `id`=%d", Families[listitem][fSQLID], Families[listitem][fName], bid);
        mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid); ER_Send(playerid, COLOR_GREEN, "Business owner set to family.");
        return ER_ShowBusinessEditor(playerid, bid);
    }

    if(dialogid == DIALOG_BUSINESS_OWNER_FACTION)
    {
        if(!response) return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        if(listitem < 0 || listitem >= FactionCount) return 1;
        new bid = GetPVarInt(playerid, "EditingBusiness"), q[256];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `owner_type`=3,`owner_id`=%d,`owner_name`='%e' WHERE `id`=%d", Factions[listitem][facSQLID], Factions[listitem][facName], bid);
        mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid); ER_Send(playerid, COLOR_GREEN, "Business owner set to faction.");
        return ER_ShowBusinessEditor(playerid, bid);
    }


    if(dialogid == DIALOG_BUSINESS_OWNER_OFFLINE)
    {
        if(!response) return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        if(listitem < 0 || listitem >= ER_BuyProductCount[playerid]) return 1;
        new accountid = ER_BuyProductID[playerid][listitem], ownerName[24];
        strmid(ownerName, inputtext, 0, sizeof(ownerName)-1);
        new dash = strfind(inputtext, " - ");
        if(dash != -1) strmid(ownerName, inputtext, dash + 3, sizeof(ownerName)-1);
        return ER_SetBusinessOwnerToPlayer(playerid, accountid, ownerName);
    }

    if(dialogid == DIALOG_BUSINESS_INTERIORS)
    {
        if(!response) return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        new bid = GetPVarInt(playerid, "EditingBusiness"), idx = ER_FindBusinessIndexBySQLID(bid);
        if(idx == -1) return 1;
        new q[256];
        if(listitem == 0)
        {
            new Float:x, Float:y, Float:z, Float:a, interior, vw = Businesses[idx][bIntVW];
            ER_SetBusinessInteriorDefaults(Businesses[idx][bType], bid, x, y, z, a, interior, vw);
            if(Businesses[idx][bIntVW] > 0) vw = Businesses[idx][bIntVW];
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `int_x`=%f,`int_y`=%f,`int_z`=%f,`int_a`=%f,`int_int`=%d,`int_vw`=%d WHERE `id`=%d", x, y, z, a, interior, vw, bid);
            mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid);
            ER_Send(playerid, COLOR_GREEN, "Default interior selected. VW was kept unless it was empty.");
            return ER_ShowBusinessEditor(playerid, bid);
        }
        if(listitem == 1)
        {
            GetPlayerPos(playerid, Businesses[idx][bIntX], Businesses[idx][bIntY], Businesses[idx][bIntZ]); GetPlayerFacingAngle(playerid, Businesses[idx][bIntA]); Businesses[idx][bIntInt] = GetPlayerInterior(playerid);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `int_x`=%f,`int_y`=%f,`int_z`=%f,`int_a`=%f,`int_int`=%d WHERE `id`=%d", Businesses[idx][bIntX], Businesses[idx][bIntY], Businesses[idx][bIntZ], Businesses[idx][bIntA], Businesses[idx][bIntInt], bid);
            mysql_tquery(MainPipeline, q); ER_Send(playerid, COLOR_GREEN, "Interior position saved. VW was not changed.");
            return ER_ShowBusinessEditor(playerid, bid);
        }
        if(listitem == 2)
        {
            Businesses[idx][bIntVW] = bid;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `int_vw`=%d WHERE `id`=%d", bid, bid);
            mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid);
            ER_Send(playerid, COLOR_GREEN, "Interior VW reset to Business ID.");
            return ER_ShowBusinessEditor(playerid, bid);
        }
        if(listitem == 3)
        {
            SetPVarInt(playerid, "BizEditAction", 30);
            ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Manual Interior VW", "Enter manual interior virtual world:", "Save", "Back");
            return 1;
        }
        return 1;
    }

    if(dialogid == DIALOG_BUSINESS_PICKUP)
    {
        if(!response) return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        new bid = GetPVarInt(playerid, "EditingBusiness"), idx = ER_FindBusinessIndexBySQLID(bid), model = 1274;
        if(idx == -1) return 1;
        switch(listitem)
        {
            case 0: model = ER_DefaultBusinessPickup(Businesses[idx][bType]);
            case 1: model = 1272;
            case 2: model = 1318;
            case 3: model = 1274;
            case 4: model = 1275;
            case 5: model = 2768;
            case 6: model = 1242;
            case 7: model = 1239;
            case 8: model = 1650;
            case 9: model = 1274;
            case 10: model = 1544;
            case 11: model = 1240;
            case 12:
            {
                SetPVarInt(playerid, "BizEditAction", 40);
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Custom Pickup Model", "Enter pickup model ID:", "Save", "Back");
                return 1;
            }
        }
        new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `pickup_model`=%d,`pickup_type`=23 WHERE `id`=%d", model, bid); mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid); ER_Send(playerid, COLOR_GREEN, "Business pickup updated.");
        return ER_ShowBusinessEditor(playerid, bid);
    }

    if(dialogid == DIALOG_BUSINESS_PRODUCTS)
    {
        if(!response) return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        if(listitem < 0 || listitem >= ER_BuyProductCount[playerid]) return 1;
        SetPVarInt(playerid, "EditingBusinessProduct", ER_BuyProductID[playerid][listitem]);
        ShowPlayerDialog(playerid, DIALOG_BUSINESS_PRODUCTS + 100, DIALOG_STYLE_LIST, "Product Edit", "Set Stock\nSet Price\nSet Minimum Price\nSet Maximum Price\nSet Restock Cost\nSet Max Stock\nToggle Admin Enabled\nToggle Owner Enabled", "Select", "Back");
        return 1;
    }

    if(dialogid == DIALOG_BUSINESS_PRODUCTS + 100)
    {
        if(!response) return ER_ShowBusinessProductsAdmin(playerid, GetPVarInt(playerid, "EditingBusiness"));
        new pid = GetPVarInt(playerid, "EditingBusinessProduct");
        if(!pid) return 1;
        if(listitem == 0)
        {
            SetPVarInt(playerid, "BizEditAction", 20);
            ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Set Product Stock", "Enter new stock amount:", "Save", "Back");
            return 1;
        }
        if(listitem == 1)
        {
            SetPVarInt(playerid, "BizEditAction", 21);
            ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Set Product Price", "Enter new price:", "Save", "Back");
            return 1;
        }
        if(listitem == 2) { SetPVarInt(playerid, "BizEditAction", 22); ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Set Minimum Price", "Enter minimum sell price:", "Save", "Back"); return 1; }
        if(listitem == 3) { SetPVarInt(playerid, "BizEditAction", 23); ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Set Maximum Price", "Enter maximum sell price:", "Save", "Back"); return 1; }
        if(listitem == 4) { SetPVarInt(playerid, "BizEditAction", 24); ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Set Restock Cost", "Enter restock cost per unit:", "Save", "Back"); return 1; }
        if(listitem == 5) { SetPVarInt(playerid, "BizEditAction", 25); ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Set Max Stock", "Enter product max stock:", "Save", "Back"); return 1; }
        new q[160];
        if(listitem == 6) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `admin_enabled`=IF(`admin_enabled`=1,0,1) WHERE `id`=%d", pid);
        else if(listitem == 7) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `owner_enabled`=IF(`owner_enabled`=1,0,1) WHERE `id`=%d", pid);
        else return 1;
        mysql_tquery(MainPipeline, q);
        ER_Send(playerid, COLOR_GREEN, "Product setting updated.");
        return ER_ShowBusinessProductsAdmin(playerid, GetPVarInt(playerid, "EditingBusiness"));
    }

    if(dialogid == DIALOG_BUSINESS_TYPE_SETTINGS)
    {
        if(!response) return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        new bid = GetPVarInt(playerid, "EditingBusiness"), idx = ER_FindBusinessIndexBySQLID(bid);
        if(idx == -1) return 1;

        // Important: dealership option 0 is Create Dealership Vehicle, not Set Counter Position.
        if(Businesses[idx][bType] == BUSINESS_TYPE_DEALERSHIP)
        {
            if(listitem == 0)
            {
                ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_CREATE, DIALOG_STYLE_INPUT, "Create Dealership Vehicle", "Enter vehicle model/name and price:\nExample: Sultan 85000", "Create", "Back");
                return 1;
            }
            if(listitem == 1) return ER_ShowDealershipVehicles(playerid, bid);
            if(listitem == 2)
            {
                new Float:x, Float:y, Float:z, Float:a;
                GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
                new q[512];
                Businesses[idx][bSafeX] = x; Businesses[idx][bSafeY] = y; Businesses[idx][bSafeZ] = z; Businesses[idx][bSafeA] = a;
                Businesses[idx][bSafeInt] = GetPlayerInterior(playerid); Businesses[idx][bSafeVW] = GetPlayerVirtualWorld(playerid);
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_x`=%f,`safe_y`=%f,`safe_z`=%f,`safe_a`=%f,`safe_int`=%d,`safe_vw`=%d WHERE `id`=%d", x, y, z, a, Businesses[idx][bSafeInt], Businesses[idx][bSafeVW], bid);
                mysql_tquery(MainPipeline, q);
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `spawn_x`=%f,`spawn_y`=%f,`spawn_z`=%f,`spawn_a`=%f,`spawn_int`=%d,`spawn_vw`=%d WHERE `business_id`=%d", x, y, z, a, Businesses[idx][bSafeInt], Businesses[idx][bSafeVW], bid);
                mysql_tquery(MainPipeline, q, "ER_OnDealerSpawnSaved", "ii", playerid, bid);
                return 1;
            }
            return ER_ShowBusinessEditor(playerid, bid);
        }

        if(Businesses[idx][bType] == BUSINESS_TYPE_GAS)
        {
            if(listitem == 0)
            {
                GetPlayerPos(playerid, Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ]); GetPlayerFacingAngle(playerid, Businesses[idx][bSafeA]); Businesses[idx][bSafeInt] = GetPlayerInterior(playerid); Businesses[idx][bSafeVW] = GetPlayerVirtualWorld(playerid);
                new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_x`=%f,`safe_y`=%f,`safe_z`=%f,`safe_a`=%f,`safe_int`=%d,`safe_vw`=%d WHERE `id`=%d", Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ], Businesses[idx][bSafeA], Businesses[idx][bSafeInt], Businesses[idx][bSafeVW], bid); mysql_tquery(MainPipeline, q);
                ER_Send(playerid, COLOR_GREEN, "Gas station counter/service position saved.");
                return ER_ShowBusinessEditor(playerid, bid);
            }
            if(listitem == 1)
            {
                new Float:px, Float:py, Float:pz, pq[256]; GetPlayerPos(playerid, px, py, pz);
                mysql_format(MainPipeline, pq, sizeof(pq), "INSERT INTO `gas_pumps` (`business_id`,`x`,`y`,`z`,`vw`,`interior`,`enabled`) VALUES (%d,%f,%f,%f,%d,%d,1)", bid, px, py, pz, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
                mysql_tquery(MainPipeline, pq, "ER_OnGasPumpCreated", "i", playerid);
                return 1;
            }
            if(listitem == 2) return ER_ShowGasPumpListForBusiness(playerid, bid);
            return ER_ShowBusinessEditor(playerid, bid);
        }

        if(Businesses[idx][bType] == BUSINESS_TYPE_BANK)
        {
            if(listitem == 0)
            {
                GetPlayerPos(playerid, Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ]); GetPlayerFacingAngle(playerid, Businesses[idx][bSafeA]); Businesses[idx][bSafeInt] = GetPlayerInterior(playerid); Businesses[idx][bSafeVW] = GetPlayerVirtualWorld(playerid);
                new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_x`=%f,`safe_y`=%f,`safe_z`=%f,`safe_a`=%f,`safe_int`=%d,`safe_vw`=%d WHERE `id`=%d", Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ], Businesses[idx][bSafeA], Businesses[idx][bSafeInt], Businesses[idx][bSafeVW], bid); mysql_tquery(MainPipeline, q);
                ER_Send(playerid, COLOR_GREEN, "Bank counter/service position saved.");
                return ER_ShowBusinessEditor(playerid, bid);
            }
            if(listitem == 1) return ER_CreateBusinessATMAtPlayer(playerid, bid);
            if(listitem == 2) { DeletePVar(playerid, "ATMListOwnerMode"); SetPVarInt(playerid, "ATMListBusiness", bid); return ER_ShowBusinessATMs(playerid, bid); }
            return ER_ShowBusinessEditor(playerid, bid);
        }

        if(listitem == 0)
        {
            GetPlayerPos(playerid, Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ]); GetPlayerFacingAngle(playerid, Businesses[idx][bSafeA]); Businesses[idx][bSafeInt] = GetPlayerInterior(playerid); Businesses[idx][bSafeVW] = GetPlayerVirtualWorld(playerid);
            new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_x`=%f,`safe_y`=%f,`safe_z`=%f,`safe_a`=%f,`safe_int`=%d,`safe_vw`=%d WHERE `id`=%d", Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ], Businesses[idx][bSafeA], Businesses[idx][bSafeInt], Businesses[idx][bSafeVW], bid); mysql_tquery(MainPipeline, q);
            ER_Send(playerid, COLOR_GREEN, "Business counter/service position saved.");
            return ER_ShowBusinessEditor(playerid, bid);
        }
        if(listitem == 1) return ER_ShowBusinessProductsAdmin(playerid, bid);
        return ER_Send(playerid, COLOR_GREEN, "This business type uses the product/catalog settings. Use Products / Owner Menu to configure stock, prices, and materials.");
    }


    if(dialogid == DIALOG_BUSINESS_ATM_LIST)
    {
        if(!response)
        {
            if(GetPVarInt(playerid, "ATMListOwnerMode"))
            {
                DeletePVar(playerid, "ATMListOwnerMode");
                return ER_ShowMyBusinessMenu(playerid, GetPVarInt(playerid, "ATMListBusiness"));
            }
            return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        }
        new pvarName[32]; format(pvarName, sizeof(pvarName), "ATMList_%d", listitem);
        new atmId = GetPVarInt(playerid, pvarName);
        if(!atmId) return ER_Send(playerid, COLOR_GREY, "Invalid ATM.");
        SetPVarInt(playerid, "SelectedATM", atmId);

        if(GetPVarInt(playerid, "ATMListOwnerMode"))
        {
            new aidx = ER_FindATMIndexBySQLID(atmId);
            if(aidx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid ATM.");
            SetPlayerCheckpoint(playerid, BusinessATMs[aidx][atmX], BusinessATMs[aidx][atmY], BusinessATMs[aidx][atmZ], 3.0);
            SetPVarInt(playerid, "TrackATM", atmId);
            ER_Send(playerid, COLOR_GREEN, "ATM location marked on your map. Go there to refill or collect fees.");
            return 1;
        }

        ShowPlayerDialog(playerid, DIALOG_BUSINESS_ATM_OPTIONS, DIALOG_STYLE_LIST, "ATM Options", "Edit Position\nMove To My Position\nToggle Enabled\nDelete ATM", "Select", "Back");
        return 1;
    }

    if(dialogid == DIALOG_BUSINESS_ATM_OPTIONS)
    {
        if(!response) return ER_ShowBusinessATMs(playerid, GetPVarInt(playerid, "EditingBusiness"));
        new atmId = GetPVarInt(playerid, "SelectedATM");
        new aidx = ER_FindATMIndexBySQLID(atmId);
        if(aidx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid ATM.");
        if(listitem == 0)
        {
            if(BusinessATMs[aidx][atmObjectID])
            {
                SetPVarInt(playerid, "EditingATM", atmId);
                EditDynamicObject(playerid, BusinessATMs[aidx][atmObjectID]);
                return ER_Send(playerid, COLOR_GREEN, "Move the ATM with your mouse and click save.");
            }
            return ER_Send(playerid, COLOR_GREY, "ATM object is not loaded.");
        }
        if(listitem == 1)
        {
            new Float:x, Float:y, Float:z, Float:a;
            GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
            BusinessATMs[aidx][atmX] = x; BusinessATMs[aidx][atmY] = y; BusinessATMs[aidx][atmZ] = z;
            BusinessATMs[aidx][atmRX] = 0.0; BusinessATMs[aidx][atmRY] = 0.0; BusinessATMs[aidx][atmRZ] = a;
            BusinessATMs[aidx][atmVW] = GetPlayerVirtualWorld(playerid); BusinessATMs[aidx][atmInt] = GetPlayerInterior(playerid);
            new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_atms` SET `x`=%f,`y`=%f,`z`=%f,`rx`=0.0,`ry`=0.0,`rz`=%f,`vw`=%d,`interior`=%d WHERE `id`=%d", x, y, z, a, BusinessATMs[aidx][atmVW], BusinessATMs[aidx][atmInt], atmId);
            mysql_tquery(MainPipeline, q); ER_RecreateATMWorld(aidx);
            return ER_Send(playerid, COLOR_GREEN, "ATM moved to your position.");
        }
        if(listitem == 2)
        {
            BusinessATMs[aidx][atmEnabled] = !BusinessATMs[aidx][atmEnabled];
            new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_atms` SET `enabled`=%d WHERE `id`=%d", BusinessATMs[aidx][atmEnabled], atmId); mysql_tquery(MainPipeline, q);
            if(BusinessATMs[aidx][atmEnabled]) ER_RecreateATMWorld(aidx); else { if(BusinessATMs[aidx][atmObjectID]) DestroyDynamicObject(BusinessATMs[aidx][atmObjectID]); if(BusinessATMs[aidx][atmLabelID]) DestroyDynamic3DTextLabel(BusinessATMs[aidx][atmLabelID]); BusinessATMs[aidx][atmObjectID]=0; BusinessATMs[aidx][atmLabelID]=Text3D:0; }
            return ER_Send(playerid, COLOR_GREEN, "ATM status updated.");
        }
        if(listitem == 3)
        {
            new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_atms` SET `enabled`=0 WHERE `id`=%d", atmId); mysql_tquery(MainPipeline, q);
            if(BusinessATMs[aidx][atmObjectID]) DestroyDynamicObject(BusinessATMs[aidx][atmObjectID]);
            if(BusinessATMs[aidx][atmLabelID]) DestroyDynamic3DTextLabel(BusinessATMs[aidx][atmLabelID]);
            BusinessATMs[aidx][atmEnabled] = 0; BusinessATMs[aidx][atmObjectID] = 0; BusinessATMs[aidx][atmLabelID] = Text3D:0;
            return ER_Send(playerid, COLOR_GREEN, "ATM deleted/disabled.");
        }
        return 1;
    }

    if(dialogid == DIALOG_DEALERSHIP_CREATE)
    {
        if(!response) return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        new modelstr[32], price;
        if(sscanf(inputtext, "s[32]d", modelstr, price)) return ER_Send(playerid, COLOR_GREY, "USAGE: [model/name] [price] | Example: Sultan 85000");
        new model = ER_FindVehicleModel(modelstr);
        if(model < 400 || model > 611) return ER_Send(playerid, COLOR_GREY, "Invalid vehicle model/name.");
        if(price < 1) return ER_Send(playerid, COLOR_GREY, "Invalid vehicle price.");
        new bid = GetPVarInt(playerid, "EditingBusiness"), bidx = ER_FindBusinessIndexBySQLID(bid);
        if(bidx == -1 || Businesses[bidx][bType] != BUSINESS_TYPE_DEALERSHIP) return ER_Send(playerid, COLOR_GREY, "Invalid dealership.");
        new Float:x, Float:y, Float:z, Float:a;
        GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
        new Float:buyX = x, Float:buyY = y, Float:buyZ = z, Float:buyA = a, buyInt = GetPlayerInterior(playerid), buyVW = GetPlayerVirtualWorld(playerid);
        new useBusinessDealerSpawn = (Businesses[bidx][bSafeX] != 0.0 || Businesses[bidx][bSafeY] != 0.0 || Businesses[bidx][bSafeZ] != 0.0);
        if(useBusinessDealerSpawn)
        {
            buyX = Businesses[bidx][bSafeX]; buyY = Businesses[bidx][bSafeY]; buyZ = Businesses[bidx][bSafeZ]; buyA = Businesses[bidx][bSafeA];
            buyInt = Businesses[bidx][bSafeInt]; buyVW = Businesses[bidx][bSafeVW];
        }
        for(new di; !useBusinessDealerSpawn && di < DealershipDisplayCount; di++) if(DealershipDisplay[di][ddBusinessID] == bid)
        {
            buyX = DealershipDisplay[di][ddSpawnX]; buyY = DealershipDisplay[di][ddSpawnY]; buyZ = DealershipDisplay[di][ddSpawnZ]; buyA = DealershipDisplay[di][ddSpawnA];
            buyInt = DealershipDisplay[di][ddSpawnInt]; buyVW = DealershipDisplay[di][ddSpawnVW];
            break;
        }
        SetPVarInt(playerid, "DealerCreateBusiness", bid);
        SetPVarInt(playerid, "DealerCreateModel", model);
        SetPVarInt(playerid, "DealerCreatePrice", price);
        SetPVarFloat(playerid, "DealerCreateX", x); SetPVarFloat(playerid, "DealerCreateY", y); SetPVarFloat(playerid, "DealerCreateZ", z); SetPVarFloat(playerid, "DealerCreateA", a);
        SetPVarInt(playerid, "DealerCreateInt", GetPlayerInterior(playerid)); SetPVarInt(playerid, "DealerCreateVW", GetPlayerVirtualWorld(playerid));
        new q[512], vehName[32];
        format(vehName, sizeof(vehName), "%s", ER_GetVehicleModelName(model));
        mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `dealership_vehicles` (`business_id`,`veh_modelid`,`veh_name`,`color1`,`color2`,`x`,`y`,`z`,`a`,`interior`,`vw`,`price`,`stock`,`stock_capacity`,`spawn_x`,`spawn_y`,`spawn_z`,`spawn_a`,`spawn_int`,`spawn_vw`,`enabled`) VALUES (%d,%d,'%e',1,1,%f,%f,%f,%f,%d,%d,%d,10,10,%f,%f,%f,%f,%d,%d,1)", bid, model, vehName, x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), price, buyX, buyY, buyZ, buyA, buyInt, buyVW);
        mysql_tquery(MainPipeline, q, "ER_OnDealerMetaCreated", "ii", playerid, bid);
        return 1;
    }

    if(dialogid == DIALOG_DEALERSHIP_LIST)
    {
        if(!response)
        {
            if(GetPVarInt(playerid, "DealerOwnerMode")) return ER_ShowMyBusinessMenu(playerid, GetPVarInt(playerid, "MyBusiness"));
            return ER_ShowBusinessEditor(playerid, GetPVarInt(playerid, "EditingBusiness"));
        }
        new pvarName[32]; format(pvarName, sizeof(pvarName), "DealerList_%d", listitem);
        new dealerId = GetPVarInt(playerid, pvarName);
        if(!dealerId) return ER_Send(playerid, COLOR_GREY, "Invalid dealership vehicle.");
        SetPVarInt(playerid, "SelectedDealerVehicle", dealerId);
        if(GetPVarInt(playerid, "DealerOwnerMode")) return ER_ShowOwnDealerVehOpts(playerid, dealerId);
        return ER_ShowDealershipVehicleEditor(playerid, dealerId);
    }

    if(dialogid == DIALOG_DEALERSHIP_OWNER_OPTIONS)
    {
        if(!response) return ER_ShowDealershipVehicles(playerid, GetPVarInt(playerid, "MyBusiness"), 1);
        new dealerId = GetPVarInt(playerid, "SelectedDealerVehicle");
        new didx = ER_FindDealershipDisplayBySQL(dealerId);
        if(didx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid dealership vehicle.");
        new bidx = ER_FindBusinessIndexBySQLID(DealershipDisplay[didx][ddBusinessID]);
        if(bidx == -1 || !ER_PlayerCanManageBusiness(playerid, bidx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to manage this dealership.");
        if(listitem == 0) { SetPVarInt(playerid, "DealerOwnerAction", 1); return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_OWNER_INPUT, DIALOG_STYLE_INPUT, "Set Vehicle Price", "Enter new vehicle sell price:", "Save", "Back"); }
        if(listitem == 1) { SetPVarInt(playerid, "DealerOwnerAction", 2); return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_OWNER_INPUT, DIALOG_STYLE_INPUT, "Restock Vehicle", "Enter amount to add to stock. This cannot exceed the admin stock capacity.", "Restock", "Back"); }
        if(listitem == 2)
        {
            new q[160];
            DealershipDisplay[didx][ddEnabled] = DealershipDisplay[didx][ddEnabled] ? 0 : 1;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `enabled`=%d WHERE `id`=%d", DealershipDisplay[didx][ddEnabled], dealerId);
            mysql_tquery(MainPipeline, q);
            if(DealershipDisplay[didx][ddEnabled]) ER_RespawnDealerVehBySQL(dealerId); else ER_RemoveDealershipDisplayIndex(didx);
            ER_Send(playerid, COLOR_GREEN, "Dealership vehicle availability updated.");
            return ER_ShowDealershipVehicles(playerid, GetPVarInt(playerid, "MyBusiness"), 1);
        }
        return 1;
    }

    if(dialogid == DIALOG_DEALERSHIP_OWNER_INPUT)
    {
        if(!response) return ER_ShowOwnDealerVehOpts(playerid, GetPVarInt(playerid, "SelectedDealerVehicle"));
        new amount = strval(inputtext);
        if(amount <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid amount.");
        new dealerId = GetPVarInt(playerid, "SelectedDealerVehicle"), didx = ER_FindDealershipDisplayBySQL(dealerId), action = GetPVarInt(playerid, "DealerOwnerAction");
        if(didx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid dealership vehicle.");
        new bidx = ER_FindBusinessIndexBySQLID(DealershipDisplay[didx][ddBusinessID]);
        if(bidx == -1 || !ER_PlayerCanManageBusiness(playerid, bidx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to manage this dealership.");
        new q[192];
        if(action == 1)
        {
            DealershipDisplay[didx][ddPrice] = amount;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `price`=%d WHERE `id`=%d", amount, dealerId);
            mysql_tquery(MainPipeline, q);
            ER_RefreshDealerLabel(didx);
            ER_Send(playerid, COLOR_GREEN, "Vehicle sell price updated.");
            return ER_ShowOwnDealerVehOpts(playerid, dealerId);
        }
        if(action == 2)
        {
            if(DealershipDisplay[didx][ddStock] + amount > DealershipDisplay[didx][ddStockCapacity]) return ER_Send(playerid, COLOR_GREY, "You cannot restock above the admin stock capacity.");
            DealershipDisplay[didx][ddStock] += amount;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `stock`=%d WHERE `id`=%d", DealershipDisplay[didx][ddStock], dealerId);
            mysql_tquery(MainPipeline, q);
            ER_RefreshDealerLabel(didx);
            ER_Send(playerid, COLOR_GREEN, "Vehicle stock updated.");
            return ER_ShowOwnDealerVehOpts(playerid, dealerId);
        }
        return 1;
    }

    if(dialogid == DIALOG_DEALERSHIP_OPTIONS)
    {
        if(!response) return ER_ShowDealershipVehicles(playerid, GetPVarInt(playerid, "EditingBusiness"));
        new dealerId = GetPVarInt(playerid, "SelectedDealerVehicle");
        new didx = ER_FindDealershipDisplayBySQL(dealerId);
        if(didx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid dealership vehicle.");
        new q[512];
        if(listitem == 0) { SetPVarInt(playerid, "DealerEditAction", 5); return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_EDIT_INPUT, DIALOG_STYLE_INPUT, "Edit Vehicle Model", "Enter model ID or vehicle name:\nExample: 560 or Sultan", "Save", "Back"); }
        if(listitem == 1) return ER_ShowDealerModMenu(playerid, dealerId);
        if(listitem == 2)
        {
            new Float:x, Float:y, Float:z, Float:a; GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `x`=%f,`y`=%f,`z`=%f,`a`=%f,`interior`=%d,`vw`=%d WHERE `id`=%d", x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), dealerId);
            mysql_tquery(MainPipeline, q);
            DealershipDisplay[didx][ddX] = x; DealershipDisplay[didx][ddY] = y; DealershipDisplay[didx][ddZ] = z; DealershipDisplay[didx][ddA] = a; DealershipDisplay[didx][ddInt] = GetPlayerInterior(playerid); DealershipDisplay[didx][ddVW] = GetPlayerVirtualWorld(playerid);
            if(DealershipDisplay[didx][ddSpawnedID] && DealershipDisplay[didx][ddSpawnedID] != INVALID_VEHICLE_ID)
            {
                SetVehiclePos(DealershipDisplay[didx][ddSpawnedID], x, y, z);
                SetVehicleZAngle(DealershipDisplay[didx][ddSpawnedID], a);
                SetVehicleVirtualWorld(DealershipDisplay[didx][ddSpawnedID], DealershipDisplay[didx][ddVW]);
                LinkVehicleToInterior(DealershipDisplay[didx][ddSpawnedID], DealershipDisplay[didx][ddInt]);
            }
            ER_RefreshDealerLabel(didx);
            return ER_Send(playerid, COLOR_GREEN, "Dealership display vehicle moved.");
        }
        if(listitem == 3)
        {
            new Float:x, Float:y, Float:z, Float:a; GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `spawn_x`=%f,`spawn_y`=%f,`spawn_z`=%f,`spawn_a`=%f,`spawn_int`=%d,`spawn_vw`=%d WHERE `id`=%d", x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), dealerId);
            mysql_tquery(MainPipeline, q, "ER_OnDealerSpawnSaved", "ii", playerid, DealershipDisplay[didx][ddBusinessID]);
            return 1;
        }
        if(listitem == 4)
        {
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `spawn_x`=`x`,`spawn_y`=`y`,`spawn_z`=`z`,`spawn_a`=`a`,`spawn_int`=`interior`,`spawn_vw`=`vw` WHERE `id`=%d", dealerId);
            mysql_tquery(MainPipeline, q);
            DealershipDisplay[didx][ddSpawnX] = DealershipDisplay[didx][ddX]; DealershipDisplay[didx][ddSpawnY] = DealershipDisplay[didx][ddY]; DealershipDisplay[didx][ddSpawnZ] = DealershipDisplay[didx][ddZ]; DealershipDisplay[didx][ddSpawnA] = DealershipDisplay[didx][ddA]; DealershipDisplay[didx][ddSpawnInt] = DealershipDisplay[didx][ddInt]; DealershipDisplay[didx][ddSpawnVW] = DealershipDisplay[didx][ddVW];
            return ER_Send(playerid, COLOR_GREEN, "Purchase spawn reset to the display vehicle position.");
        }
        if(listitem == 5) { SetPVarInt(playerid, "DealerEditAction", 1); return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_EDIT_INPUT, DIALOG_STYLE_INPUT, "Set Dealership Vehicle Price", "Enter new price:", "Save", "Back"); }
        if(listitem == 6) { SetPVarInt(playerid, "DealerEditAction", 2); return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_EDIT_INPUT, DIALOG_STYLE_INPUT, "Set Stock", "Enter stock and capacity:\nExample: 9 10", "Save", "Back"); }
        if(listitem == 7) { SetPVarInt(playerid, "DealerEditAction", 3); return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_EDIT_INPUT, DIALOG_STYLE_INPUT, "Set Colors", "Enter color1 color2:\nExample: 1 1", "Save", "Back"); }
        if(listitem == 8) return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_LINK_MODE, DIALOG_STYLE_LIST, "Link Dealership Vehicle", "Write Business ID\nSelect Existing Dealership", "Select", "Back");
        if(listitem == 9)
        {
            new wasEnabled = DealershipDisplay[didx][ddEnabled];
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `enabled`=%d WHERE `id`=%d", wasEnabled ? 0 : 1, dealerId); mysql_tquery(MainPipeline, q);
            DealershipDisplay[didx][ddEnabled] = wasEnabled ? 0 : 1;
            if(wasEnabled) ER_RemoveDealershipDisplayIndex(didx); else ER_RespawnDealerVehBySQL(dealerId);
            return ER_Send(playerid, COLOR_GREEN, wasEnabled ? "Dealership vehicle disabled." : "Dealership vehicle enabled.");
        }
        if(listitem == 10)
        {
            return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_TOGGLE_DELETE, DIALOG_STYLE_MSGBOX, "Delete Dealership Vehicle", "Are you sure you want to delete/disable this dealership vehicle?\nThis will NOT touch owned/player vehicles.", "Delete", "Back");
        }
        return 1;
    }

    if(dialogid == DIALOG_DEALERSHIP_TOGGLE_DELETE)
    {
        if(!response) return ER_ShowDealershipVehicleEditor(playerid, GetPVarInt(playerid, "SelectedDealerVehicle"));
        new dealerId = GetPVarInt(playerid, "SelectedDealerVehicle"), q[128];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `enabled`=0 WHERE `id`=%d", dealerId); mysql_tquery(MainPipeline, q);
        new didx = ER_FindDealershipDisplayBySQL(dealerId);
        if(didx != -1) ER_RemoveDealershipDisplayIndex(didx);
        return ER_Send(playerid, COLOR_GREEN, "Dealership vehicle deleted/disabled. Owned vehicles were not touched.");
    }

    if(dialogid == DIALOG_DEALERSHIP_MOD_MENU)
    {
        if(!response) return ER_ShowDealershipVehicleEditor(playerid, GetPVarInt(playerid, "SelectedDealerVehicle"));
        new pvar[32]; format(pvar, sizeof(pvar), "DealerModSlot%d", listitem);
        new slot = GetPVarInt(playerid, pvar);
        new dealerId = GetPVarInt(playerid, "SelectedDealerVehicle"), didx = ER_FindDealershipDisplayBySQL(dealerId);
        if(didx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid dealership vehicle.");
        if(slot == 90)
        {
            SetPVarInt(playerid, "DealerModAction", 3);
            return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_MOD_INPUT, DIALOG_STYLE_INPUT, "Set Paintjob", "Enter paintjob ID (-1 to clear):", "Save", "Back");
        }
        if(slot == 91)
        {
            new q[2048];
            ER_ClearDealerModsLive(didx);
            DealershipDisplay[didx][ddPaintjob] = -1; DealershipDisplay[didx][ddNos] = 0; DealershipDisplay[didx][ddUnlimitedNos] = 0;
            DealershipDisplay[didx][ddModSpoiler] = 0; DealershipDisplay[didx][ddModHood] = 0; DealershipDisplay[didx][ddModRoof] = 0;
            DealershipDisplay[didx][ddModSideskirtL] = 0; DealershipDisplay[didx][ddModSideskirtR] = 0; DealershipDisplay[didx][ddModLamps] = 0; DealershipDisplay[didx][ddModNitro] = 0;
            DealershipDisplay[didx][ddModExhaust] = 0; DealershipDisplay[didx][ddModWheels] = 0; DealershipDisplay[didx][ddModStereo] = 0; DealershipDisplay[didx][ddModHydraulics] = 0;
            DealershipDisplay[didx][ddModFrontBumper] = 0; DealershipDisplay[didx][ddModRearBumper] = 0; DealershipDisplay[didx][ddModVentRight] = 0; DealershipDisplay[didx][ddModVentLeft] = 0;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `paintjob`=-1,`nos`=0,`unlimited_nos`=0,`mod_spoiler`=0,`mod_hood`=0,`mod_roof`=0,`mod_sideskirt_l`=0,`mod_sideskirt_r`=0,`mod_lamps`=0,`mod_nitro`=0,`mod_exhaust`=0,`mod_wheels`=0,`mod_stereo`=0,`mod_hydraulics`=0,`mod_front_bumper`=0,`mod_rear_bumper`=0,`mod_vent_right`=0,`mod_vent_left`=0 WHERE `id`=%d", dealerId);
            mysql_tquery(MainPipeline, q, "ER_OnDealerVehicleModSaved", "ii", playerid, dealerId);
            return 1;
        }
        if(slot == 92)
        {
            new q[160];
            DealershipDisplay[didx][ddUnlimitedNos] = DealershipDisplay[didx][ddUnlimitedNos] ? 0 : 1;
            DealershipDisplay[didx][ddNos] = DealershipDisplay[didx][ddUnlimitedNos] ? 1010 : 0;
            DealershipDisplay[didx][ddModNitro] = DealershipDisplay[didx][ddUnlimitedNos] ? 1010 : 0;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `nos`=%d,`unlimited_nos`=%d,`mod_nitro`=%d WHERE `id`=%d", DealershipDisplay[didx][ddNos], DealershipDisplay[didx][ddUnlimitedNos], DealershipDisplay[didx][ddModNitro], dealerId);
            mysql_tquery(MainPipeline, q, "ER_OnDealerVehicleModSaved", "ii", playerid, dealerId);
            ER_ApplyDealershipVehicleMods(didx);
            return 1;
        }
        SetPVarInt(playerid, "DealerModSlot", slot);
        return ER_ShowDealerComponentList(playerid, slot);
    }

    if(dialogid == DIALOG_DEALERSHIP_MOD_SELECT)
    {
        if(!response) return ER_ShowDealerModMenu(playerid, GetPVarInt(playerid, "SelectedDealerVehicle"));
        new dealerId = GetPVarInt(playerid, "SelectedDealerVehicle"), didx = ER_FindDealershipDisplayBySQL(dealerId);
        if(didx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid dealership vehicle.");
        new pvar[32]; format(pvar, sizeof(pvar), "VehModComp%d", listitem);
        new component = GetPVarInt(playerid, pvar);
        new slot = GetPVarInt(playerid, "DealerModSlot");
        if(component > 0 && !ER_IsComponentCompatible(DealershipDisplay[didx][ddModel], component)) return ER_Send(playerid, COLOR_GREY, "This component is not compatible with the selected vehicle.");
        if(slot == 3 || slot == 4)
        {
            ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModSideskirtL]);
            ER_RemoveDealerComponentLive(didx, DealershipDisplay[didx][ddModSideskirtR]);
            ER_SetDealerSideSkirtSet(didx, component);
            ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModSideskirtL]);
            ER_AddDealerComponent(didx, DealershipDisplay[didx][ddModSideskirtR]);
        }
        else
        {
            ER_RemoveDealerComponentLive(didx, ER_GetDealerModComponentBySlot(didx, slot));
            switch(slot)
            {
                case 0: DealershipDisplay[didx][ddModSpoiler] = component;
                case 1: DealershipDisplay[didx][ddModHood] = component;
                case 2: DealershipDisplay[didx][ddModRoof] = component;
                case 5: DealershipDisplay[didx][ddModLamps] = component;
                case 7: DealershipDisplay[didx][ddModExhaust] = component;
                case 8: DealershipDisplay[didx][ddModWheels] = component;
                case 9: DealershipDisplay[didx][ddModStereo] = component;
                case 10: DealershipDisplay[didx][ddModHydraulics] = component;
                case 11: DealershipDisplay[didx][ddModFrontBumper] = component;
                case 12: DealershipDisplay[didx][ddModRearBumper] = component;
                case 13: DealershipDisplay[didx][ddModVentRight] = component;
                case 14: DealershipDisplay[didx][ddModVentLeft] = component;
            }
        }
        if(!(slot == 3 || slot == 4)) ER_AddDealerComponent(didx, component);
        new q[2048];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `mod_spoiler`=%d,`mod_hood`=%d,`mod_roof`=%d,`mod_sideskirt_l`=%d,`mod_sideskirt_r`=%d,`mod_lamps`=%d,`mod_exhaust`=%d,`mod_wheels`=%d,`mod_stereo`=%d,`mod_hydraulics`=%d,`mod_front_bumper`=%d,`mod_rear_bumper`=%d,`mod_vent_right`=%d,`mod_vent_left`=%d WHERE `id`=%d", DealershipDisplay[didx][ddModSpoiler], DealershipDisplay[didx][ddModHood], DealershipDisplay[didx][ddModRoof], DealershipDisplay[didx][ddModSideskirtL], DealershipDisplay[didx][ddModSideskirtR], DealershipDisplay[didx][ddModLamps], DealershipDisplay[didx][ddModExhaust], DealershipDisplay[didx][ddModWheels], DealershipDisplay[didx][ddModStereo], DealershipDisplay[didx][ddModHydraulics], DealershipDisplay[didx][ddModFrontBumper], DealershipDisplay[didx][ddModRearBumper], DealershipDisplay[didx][ddModVentRight], DealershipDisplay[didx][ddModVentLeft], dealerId);
        mysql_tquery(MainPipeline, q, "ER_OnDealerVehicleModSaved", "ii", playerid, dealerId);
        return 1;
    }

    if(dialogid == DIALOG_DEALERSHIP_MOD_INPUT)
    {
        if(!response) return ER_ShowDealerModMenu(playerid, GetPVarInt(playerid, "SelectedDealerVehicle"));
        new dealerId = GetPVarInt(playerid, "SelectedDealerVehicle"), action = GetPVarInt(playerid, "DealerModAction"), q[160];
        if(action == 3)
        {
            new paintjob = strval(inputtext); if(paintjob < -1 || paintjob > 3) return ER_Send(playerid, COLOR_GREY, "Invalid paintjob.");
            new didx = ER_FindDealershipDisplayBySQL(dealerId); if(didx != -1) { DealershipDisplay[didx][ddPaintjob] = paintjob; if(DealershipDisplay[didx][ddSpawnedID] && DealershipDisplay[didx][ddSpawnedID] != INVALID_VEHICLE_ID && paintjob >= 0) ChangeVehiclePaintjob(DealershipDisplay[didx][ddSpawnedID], paintjob); }
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `paintjob`=%d WHERE `id`=%d", paintjob, dealerId);
            mysql_tquery(MainPipeline, q, "ER_OnDealerVehicleModSaved", "ii", playerid, dealerId);
            return 1;
        }
        return ER_ShowDealerModMenu(playerid, dealerId);
    }

    if(dialogid == DIALOG_DEALERSHIP_EDIT_INPUT)
    {
        if(!response) return ER_ShowDealershipVehicleEditor(playerid, GetPVarInt(playerid, "SelectedDealerVehicle"));
        new dealerId = GetPVarInt(playerid, "SelectedDealerVehicle"), action = GetPVarInt(playerid, "DealerEditAction");
        new didx = ER_FindDealershipDisplayBySQL(dealerId);
        if(didx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid dealership vehicle.");
        new q[2048];
        if(action == 1)
        {
            new price = strval(inputtext); if(price < 1) return ER_Send(playerid, COLOR_GREY, "Invalid price.");
            DealershipDisplay[didx][ddPrice] = price;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `price`=%d WHERE `id`=%d", price, dealerId);
        }
        else if(action == 2)
        {
            new vehstock, capacity;
            if(sscanf(inputtext, "dd", vehstock, capacity)) return ER_Send(playerid, COLOR_GREY, "USAGE: [stock] [capacity]");
            if(vehstock < 0) vehstock = 0;
            if(capacity < 0) capacity = 0;
            if(vehstock > capacity) vehstock = capacity;
            DealershipDisplay[didx][ddStock] = vehstock;
            DealershipDisplay[didx][ddStockCapacity] = capacity;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `stock`=%d,`stock_capacity`=%d WHERE `id`=%d", vehstock, capacity, dealerId);
        }
        else if(action == 3)
        {
            new c1, c2; if(sscanf(inputtext, "dd", c1, c2)) return ER_Send(playerid, COLOR_GREY, "USAGE: [color1] [color2]");
            DealershipDisplay[didx][ddColor1] = c1; DealershipDisplay[didx][ddColor2] = c2;
            if(DealershipDisplay[didx][ddSpawnedID] && DealershipDisplay[didx][ddSpawnedID] != INVALID_VEHICLE_ID) ChangeVehicleColor(DealershipDisplay[didx][ddSpawnedID], c1, c2);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `color1`=%d,`color2`=%d WHERE `id`=%d", c1, c2, dealerId);
        }
        else if(action == 4)
        {
            new bid = strval(inputtext), bidx = ER_FindBusinessIndexBySQLID(bid);
            if(bidx == -1 || Businesses[bidx][bType] != BUSINESS_TYPE_DEALERSHIP) return ER_Send(playerid, COLOR_GREY, "That business is not a dealership.");
            DealershipDisplay[didx][ddBusinessID] = bid;
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `business_id`=%d WHERE `id`=%d", bid, dealerId);
        }
        else if(action == 5)
        {
            new model = ER_FindVehicleModel(inputtext);
            if(model < 400 || model > 611) return ER_Send(playerid, COLOR_GREY, "Invalid vehicle model/name.");
            DealershipDisplay[didx][ddModel] = model; DealershipDisplay[didx][ddPaintjob] = -1; DealershipDisplay[didx][ddNos] = 0; DealershipDisplay[didx][ddUnlimitedNos] = 0;
            DealershipDisplay[didx][ddModSpoiler] = 0; DealershipDisplay[didx][ddModHood] = 0; DealershipDisplay[didx][ddModRoof] = 0; DealershipDisplay[didx][ddModSideskirtL] = 0; DealershipDisplay[didx][ddModSideskirtR] = 0;
            DealershipDisplay[didx][ddModLamps] = 0; DealershipDisplay[didx][ddModNitro] = 0; DealershipDisplay[didx][ddModExhaust] = 0; DealershipDisplay[didx][ddModWheels] = 0; DealershipDisplay[didx][ddModStereo] = 0;
            DealershipDisplay[didx][ddModHydraulics] = 0; DealershipDisplay[didx][ddModFrontBumper] = 0; DealershipDisplay[didx][ddModRearBumper] = 0; DealershipDisplay[didx][ddModVentRight] = 0; DealershipDisplay[didx][ddModVentLeft] = 0;
            new dealerVehName[32], qMods[2048];
            format(dealerVehName, sizeof(dealerVehName), "%s", ER_GetVehicleModelName(model));

            // Save the model/name in a small standalone query first. This keeps model changes permanent
            // even if an older database is missing the optional dealership mod columns.
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `veh_modelid`=%d,`veh_name`='%e' WHERE `id`=%d", model, dealerVehName, dealerId);
            mysql_tquery(MainPipeline, q);

            // Clear model-specific mods after changing model. Requires the FIX8/FIX10 dealership mod migration.
            mysql_format(MainPipeline, qMods, sizeof(qMods), "UPDATE `dealership_vehicles` SET `paintjob`=-1,`nos`=0,`unlimited_nos`=0,`mod_spoiler`=0,`mod_hood`=0,`mod_roof`=0,`mod_sideskirt_l`=0,`mod_sideskirt_r`=0,`mod_lamps`=0,`mod_nitro`=0,`mod_exhaust`=0,`mod_wheels`=0,`mod_stereo`=0,`mod_hydraulics`=0,`mod_front_bumper`=0,`mod_rear_bumper`=0,`mod_vent_right`=0,`mod_vent_left`=0 WHERE `id`=%d", dealerId);
            mysql_tquery(MainPipeline, qMods);

            DeletePVar(playerid, "DealerEditAction");
            ER_RespawnDealerVehBySQL(dealerId);
            ER_Send(playerid, COLOR_GREEN, "Dealership vehicle model saved permanently and display vehicle respawned.");
            return ER_ShowDealershipVehicleEditor(playerid, dealerId);
        }
        else return ER_ShowDealershipVehicleEditor(playerid, dealerId);
        mysql_tquery(MainPipeline, q, "ER_OnDealerVehicleSettingSaved", "ii", playerid, dealerId); DeletePVar(playerid, "DealerEditAction");
        return 1;
    }

    if(dialogid == DIALOG_DEALERSHIP_LINK_MODE)
    {
        if(!response) return ER_ShowDealershipVehicleEditor(playerid, GetPVarInt(playerid, "SelectedDealerVehicle"));
        if(listitem == 0) { SetPVarInt(playerid, "DealerEditAction", 4); return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_EDIT_INPUT, DIALOG_STYLE_INPUT, "Link By Business ID", "Enter dealership business ID:", "Save", "Back"); }
        new list[2048], line[128], count;
        for(new i; i < BusinessCount; i++) if(Businesses[i][bType] == BUSINESS_TYPE_DEALERSHIP && Businesses[i][bEnabled])
        {
            format(line, sizeof(line), "%d - %s\n", Businesses[i][bSQLID], Businesses[i][bName]); strcat(list, line, sizeof(list));
            new pvar[32]; format(pvar, sizeof(pvar), "DealerLink_%d", count); SetPVarInt(playerid, pvar, Businesses[i][bSQLID]); count++;
        }
        SetPVarInt(playerid, "DealerLinkCount", count);
        if(!count) format(list, sizeof(list), "No dealerships found.");
        return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_LINK_LIST, DIALOG_STYLE_LIST, "Select Dealership", list, "Select", "Back");
    }

    if(dialogid == DIALOG_DEALERSHIP_LINK_LIST)
    {
        if(!response) return ER_ShowDealershipVehicleEditor(playerid, GetPVarInt(playerid, "SelectedDealerVehicle"));
        new pvar[32]; format(pvar, sizeof(pvar), "DealerLink_%d", listitem);
        new bid = GetPVarInt(playerid, pvar), dealerId = GetPVarInt(playerid, "SelectedDealerVehicle");
        new didx = ER_FindDealershipDisplayBySQL(dealerId);
        new bidx = ER_FindBusinessIndexBySQLID(bid);
        if(bidx == -1 || Businesses[bidx][bType] != BUSINESS_TYPE_DEALERSHIP) return ER_Send(playerid, COLOR_GREY, "Invalid dealership.");
        new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `business_id`=%d WHERE `id`=%d", bid, dealerId); mysql_tquery(MainPipeline, q);
        if(didx != -1) DealershipDisplay[didx][ddBusinessID] = bid;
        ER_RespawnDealerVehBySQL(dealerId); ER_Send(playerid, COLOR_GREEN, "Dealership vehicle linked to selected dealership.");
        return ER_ShowDealershipVehicleEditor(playerid, dealerId);
    }


    if(dialogid == DIALOG_BUSINESS_DELETE_CONFIRM)
    {
        new bid = GetPVarInt(playerid, "EditingBusiness");
        if(!response) return ER_ShowBusinessEditor(playerid, bid);
        new q[160]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `enabled`=0 WHERE `business_id`=%d", bid); mysql_tquery(MainPipeline, q);
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `enabled`=0 WHERE `id`=%d", bid); mysql_tquery(MainPipeline, q);
        ER_LoadDealershipDisplays(); ER_ReloadBusinessBySQLID(bid, playerid); DeletePVar(playerid, "EditingBusiness");
        return ER_Send(playerid, COLOR_GREEN, "Dealership business and linked dealership vehicles disabled.");
    }

    if(dialogid == DIALOG_BUSINESS_TYPE_CONFIRM)
    {
        new bid = GetPVarInt(playerid, "EditingBusiness"), idx = ER_FindBusinessIndexBySQLID(bid);
        if(idx == -1) return 1;
        if(!response) return ER_ShowBusinessEditor(playerid, bid);
        new type = GetPVarInt(playerid, "PendingBusinessType"), typeName[32], q[512];
        ER_GetBusinessTypeName(type, typeName, sizeof(typeName));
        new Float:ix, Float:iy, Float:iz, Float:ia, iint, ivw; ER_SetBusinessInteriorDefaults(type, bid, ix, iy, iz, ia, iint, ivw);
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `enabled`=0 WHERE `business_id`=%d", bid); mysql_tquery(MainPipeline, q);
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `type`=%d,`name`='%e',`pickup_model`=%d,`pickup_type`=23,`int_x`=%f,`int_y`=%f,`int_z`=%f,`int_a`=%f,`int_int`=%d,`int_vw`=%d WHERE `id`=%d", type, typeName, ER_DefaultBusinessPickup(type), ix, iy, iz, ia, iint, ivw, bid);
        mysql_tquery(MainPipeline, q, "ER_OnBizTypeUpdated", "iii", playerid, bid, type);
        DeletePVar(playerid, "PendingBusinessType"); DeletePVar(playerid, "BizEditAction"); ER_LoadDealershipDisplays();
        return 1;
    }

    if(dialogid == DIALOG_DEALERSHIP_BUY)
    {
        if(!response)
        {
            DeletePVar(playerid, "BuyDealerDisplay");
            RemovePlayerFromVehicle(playerid);
            return 1;
        }
        RemovePlayerFromVehicle(playerid);
        return ER_ProcessDealershipPurchase(playerid, GetPVarInt(playerid, "BuyDealerDisplay"));
    }

    if(dialogid == DIALOG_BUY_PHONE_NUMBER)
    {
        if(!response) return 1;
        new number, digits = ER_GetPhoneDigits();
        new minPhone = ER_GetPhoneMinForDigits(digits);
        new maxPhone = ER_GetPhoneMaxForDigits(digits);

        if(strlen(inputtext) != digits)
        {
            new msg[96];
            format(msg, sizeof(msg), "Phone number must be exactly %d digits.", digits);
            ER_Send(playerid, COLOR_GREY, msg);
            return ER_ShowPhoneNumberBuyDialog(playerid, true);
        }

        new bool:hasNonZero = false;
        for(new i = 0; i < digits; i++)
        {
            if(inputtext[i] < '0' || inputtext[i] > '9')
            {
                ER_Send(playerid, COLOR_GREY, "Phone number must contain digits only.");
                return ER_ShowPhoneNumberBuyDialog(playerid, true);
            }
            if(inputtext[i] != '0') hasNonZero = true;
        }

        if(!hasNonZero)
        {
            ER_Send(playerid, COLOR_GREY, "Phone number cannot be all zeros.");
            return ER_ShowPhoneNumberBuyDialog(playerid, true);
        }

        number = strval(inputtext);
        if(number < minPhone || number > maxPhone)
        {
            new msg[128];
            format(msg, sizeof(msg), "Phone number must be between %d and %d.", minPhone, maxPhone);
            ER_Send(playerid, COLOR_GREY, msg);
            return ER_ShowPhoneNumberBuyDialog(playerid, true);
        }
        new q[192];
        mysql_format(MainPipeline, q, sizeof(q), "SELECT `id` FROM `accounts` WHERE `phone`=%d AND `id`<>%d LIMIT 1", number, PlayerInfo[playerid][pID]);
        mysql_tquery(MainPipeline, q, "ER_OnPhoneNumberChecked", "ii", playerid, number);
        return 1;
    }

    if(dialogid == DIALOG_BUY_CLOTHES_TOYS)
    {
        if(!response) return 1;
        if(listitem == 0) return ER_ShowClothesGrid(playerid, 0);
        if(listitem == 1) return ER_ShowToyShopGrid(playerid, 0);
        return 1;
    }
    if(dialogid == DIALOG_BUY_PRODUCTS)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= ER_BuyProductCount[playerid]) return 1;
        new pid = ER_BuyProductID[playerid][listitem];
        new q[128]; mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `business_products` WHERE `id`=%d LIMIT 1", pid); mysql_tquery(MainPipeline, q, "ER_OnBuyProductSelected", "ii", playerid, ER_BuyBusinessSQL[playerid]);
        return 1;
    }
    return 0;
}


stock ER_GetPhoneDigits()
{
    if(ServerCore[scPhoneDigits] < 4) return 4;
    if(ServerCore[scPhoneDigits] > 9) return 9;
    return ServerCore[scPhoneDigits];
}

stock ER_GetPhoneMinForDigits(digits)
{
    new phoneMinValue = 1;
    for(new i = 1; i < digits; i++) phoneMinValue *= 10;
    return phoneMinValue;
}

stock ER_GetPhoneMaxForDigits(digits)
{
    new phoneMaxValue = 1;
    for(new i = 0; i < digits; i++) phoneMaxValue *= 10;
    return phoneMaxValue - 1;
}

stock ER_ShowPhoneNumberBuyDialog(playerid, bool:retry)
{
    new digits = ER_GetPhoneDigits();
    new phoneMinValue = ER_GetPhoneMinForDigits(digits);
    new phoneMaxValue = ER_GetPhoneMaxForDigits(digits);
    new body[192], zeros[12];
    for(new i = 0; i < digits; i++) zeros[i] = '0';
    zeros[digits] = '\0';

    if(retry) format(body, sizeof(body), "Enter another %d-digit phone number between %d and %d:\n\n%s is not allowed.", digits, phoneMinValue, phoneMaxValue, zeros);
    else format(body, sizeof(body), "Enter a %d-digit phone number between %d and %d:\n\n%s is not allowed.", digits, phoneMinValue, phoneMaxValue, zeros);
    return ShowPlayerDialog(playerid, DIALOG_BUY_PHONE_NUMBER, DIALOG_STYLE_INPUT, "Select Phone Number", body, "Buy", "Cancel");
}

forward ER_OnBuyProductSelected(playerid, businessid);
public ER_OnBuyProductSelected(playerid, businessid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows; cache_get_row_count(rows); if(!rows) return 1;
    new productid, price, productStock, productKey[32], productName[64];
    cache_get_value_name_int(0, "id", productid); cache_get_value_name_int(0, "price", price); cache_get_value_name_int(0, "stock", productStock); cache_get_value_name(0, "product_key", productKey, sizeof(productKey)); cache_get_value_name(0, "product_name", productName, sizeof(productName));
    if(productStock <= 0) return ER_Send(playerid, COLOR_GREY, "This product is out of stock.");

    // Items that a player can only carry one of must be checked before taking money.
    if((!strcmp(productKey, "vehlock_alarm", true) || !strcmp(productKey, "vehlock_industrial", true)) && PlayerInfo[playerid][pVehicleLock] > 0)
    {
        return ER_Send(playerid, COLOR_GREY, "You can only carry one vehicle security item at a time. Install or remove your current one first.");
    }
    if(!strcmp(productKey, "hotwire_tool", true) && PlayerInfo[playerid][pHotwireKits] > 0) return ER_Send(playerid, COLOR_GREY, "You already have hotwire tools. Use them before buying another pack.");
    if(!strcmp(productKey, "mp3", true) && PlayerInfo[playerid][pHasMP3]) return ER_Send(playerid, COLOR_GREY, "You already own an MP3 player.");
    if(!strcmp(productKey, "radio", true) && PlayerInfo[playerid][pHasRadio]) return ER_Send(playerid, COLOR_GREY, "You already own a radio.");
    if(!strcmp(productKey, "phone", true))
    {
        ER_PendingPhoneProductID[playerid] = productid;
        ER_PendingPhoneBusinessID[playerid] = businessid;
        ER_PendingPhonePrice[playerid] = price;
        return ER_ShowPhoneNumberBuyDialog(playerid, false);
    }

    new weaponProductID = ER_GetWeaponIDFromProductKey(productKey);
    new weaponMatCost = 0;
    new bidx = ER_FindBusinessIndexBySQLID(businessid);
    if(weaponProductID > 0)
    {
        weaponMatCost = ER_GetWeaponMatCost(weaponProductID);
        if(weaponMatCost < 0) return ER_Send(playerid, COLOR_GREY, "This weapon has no enabled material-cost row.");
        if(bidx == -1) return ER_Send(playerid, COLOR_GREY, "Business data not loaded. Try again.");
        if(Businesses[bidx][bMaterials] < weaponMatCost) return ER_Send(playerid, COLOR_GREY, "This Ammu-Nation does not have enough materials for that weapon.");
    }

    if(PlayerInfo[playerid][pCash] < price) return ER_Send(playerid, COLOR_GREY, "You do not have enough cash.");
    PlayerInfo[playerid][pCash] -= price;
    GivePlayerMoney(playerid, -price);

    if(!strcmp(productKey, "mp3", true)) PlayerInfo[playerid][pHasMP3] = 1;
    else if(!strcmp(productKey, "radio", true)) PlayerInfo[playerid][pHasRadio] = 1;
    else if(!strcmp(productKey, "phone_credit", true)) PlayerInfo[playerid][pPhonebook] = 1;
    else if(!strcmp(productKey, "rope", true)) PlayerInfo[playerid][pRope] = ER_MinInt(5, PlayerInfo[playerid][pRope] + 5);
    else if(!strcmp(productKey, "cigarettes", true) || !strcmp(productKey, "cigar", true)) PlayerInfo[playerid][pCigar]++;
    else if(!strcmp(productKey, "sprunk", true) || !strcmp(productKey, "soda", true)) PlayerInfo[playerid][pSprunk]++;
    else if(!strcmp(productKey, "vehlock_alarm", true)) PlayerInfo[playerid][pVehicleLock] = 1;
    else if(!strcmp(productKey, "vehlock_industrial", true)) PlayerInfo[playerid][pVehicleLock] = 2;
    else if(!strcmp(productKey, "hotwire_tool", true)) PlayerInfo[playerid][pHotwireKits] = 10;
    else if(weaponProductID > 0) GivePlayerWeapon(playerid, weaponProductID, 99999);
    else if(!strcmp(productKey, "armor_50", true)) SetPlayerArmour(playerid, 50.0);
    else if(!strcmp(productKey, "armor_100", true)) SetPlayerArmour(playerid, 100.0);

    new q[384];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `stock`=`stock`-1 WHERE `id`=%d AND `stock`>0", productid);
    mysql_tquery(MainPipeline, q);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=`safe_balance`+%d WHERE `id`=%d", price, businessid);
    mysql_tquery(MainPipeline, q);
    bidx = ER_FindBusinessIndexBySQLID(businessid);
    if(bidx != -1) Businesses[bidx][bSafeBalance] += price;

    if(PlayerInfo[playerid][pID] > 0)
    {
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `cash`=%d,`phone`=%d,`phonebook`=%d,`has_radio`=%d,`vehicle_lock`=%d,`rope`=%d,`sprunk`=%d,`cigar`=%d,`has_mp3`=%d,`hotwire_kits`=%d WHERE `id`=%d",
            PlayerInfo[playerid][pCash], PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pPhonebook], PlayerInfo[playerid][pHasRadio], PlayerInfo[playerid][pVehicleLock], PlayerInfo[playerid][pRope], PlayerInfo[playerid][pSprunk], PlayerInfo[playerid][pCigar], PlayerInfo[playerid][pHasMP3], PlayerInfo[playerid][pHotwireKits], PlayerInfo[playerid][pID]);
        mysql_tquery(MainPipeline, q);
    }

    new msg[128];
    if(!strcmp(productKey, "rope", true)) format(msg, sizeof(msg), "You bought %s for %s. You received 5 ropes.", productName, ER_FormatMoney(price));
    else if(!strcmp(productKey, "hotwire_tool", true)) format(msg, sizeof(msg), "You bought %s for %s. You received 10 hotwire tools.", productName, ER_FormatMoney(price));
    else format(msg, sizeof(msg), "You bought %s for %s.", productName, ER_FormatMoney(price));
    ER_Send(playerid, COLOR_GREEN, msg);
    return 1;
}



forward ER_OnPhoneNumberChecked(playerid, number);
public ER_OnPhoneNumberChecked(playerid, number)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows; cache_get_row_count(rows);
    if(rows)
    {
        ER_Send(playerid, COLOR_GREY, "This phone number is already taken.");
        return ER_ShowPhoneNumberBuyDialog(playerid, true);
    }

    new productid = ER_PendingPhoneProductID[playerid];
    new businessid = ER_PendingPhoneBusinessID[playerid];
    new price = ER_PendingPhonePrice[playerid];
    if(productid <= 0 || businessid <= 0 || price <= 0) return ER_Send(playerid, COLOR_GREY, "Phone purchase expired. Please use /buy again.");
    if(PlayerInfo[playerid][pCash] < price) return ER_Send(playerid, COLOR_GREY, "You do not have enough cash.");

    new q[384];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `stock`=`stock`-1 WHERE `id`=%d AND `stock`>0", productid);
    mysql_tquery(MainPipeline, q);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=`safe_balance`+%d WHERE `id`=%d", price, businessid);
    mysql_tquery(MainPipeline, q);
    new bidx = ER_FindBusinessIndexBySQLID(businessid);
    if(bidx != -1) Businesses[bidx][bSafeBalance] += price;

    PlayerInfo[playerid][pCash] -= price;
    GivePlayerMoney(playerid, -price);
    PlayerInfo[playerid][pPhone] = number;

    if(PlayerInfo[playerid][pID] > 0)
    {
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `cash`=%d,`phone`=%d WHERE `id`=%d", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pID]);
        mysql_tquery(MainPipeline, q);
    }

    ER_PendingPhoneProductID[playerid] = 0;
    ER_PendingPhoneBusinessID[playerid] = 0;
    ER_PendingPhonePrice[playerid] = 0;
    new msg[128]; format(msg, sizeof(msg), "You bought a cellphone with number %d for %s.", number, ER_FormatMoney(price));
    return ER_Send(playerid, COLOR_GREEN, msg);
}



forward ER_OnDealerVehicleSettingSaved(playerid, dealerId);
public ER_OnDealerVehicleSettingSaved(playerid, dealerId)
{
    new didx = ER_FindDealershipDisplayBySQL(dealerId);
    if(didx != -1) ER_RefreshDealerLabel(didx);
    ER_Send(playerid, COLOR_GREEN, "Dealership vehicle setting saved.");
    return ER_ShowDealershipVehicleEditor(playerid, dealerId);
}

forward ER_OnDealerVehicleModSaved(playerid, dealerId);
public ER_OnDealerVehicleModSaved(playerid, dealerId)
{
    new didx = ER_FindDealershipDisplayBySQL(dealerId);
    if(didx != -1) ER_ApplyDealershipVehicleMods(didx);
    ER_Send(playerid, COLOR_GREEN, "Dealership vehicle mod saved to SQL.");
    return ER_ShowDealerModMenu(playerid, dealerId);
}

forward ER_OnDealerSpawnSaved(playerid, businessid);
public ER_OnDealerSpawnSaved(playerid, businessid)
{
    ER_Send(playerid, COLOR_GREEN, "Dealership purchased vehicle spawn position saved.");
    return ER_ShowBusinessEditor(playerid, businessid);
}

// Deprecated: dealership displays no longer create/link normal owned vehicle SQL rows.


forward ER_OnDealerMetaCreated(playerid, businessid);
public ER_OnDealerMetaCreated(playerid, businessid)
{
    ER_LoadDealershipDisplays();
    ER_Send(playerid, COLOR_GREEN, "Dealership vehicle created. It is stored only in dealership_vehicles and does not affect owned vehicles.");
    return ER_ShowBusinessEditor(playerid, businessid);
}

stock ER_ShowDealershipVehicleEditor(playerid, dealerSqlId)
{
    new didx = ER_FindDealershipDisplayBySQL(dealerSqlId);
    if(didx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid dealership vehicle ID. Use /editdealershipveh [Vehicle ID].");
    SetPVarInt(playerid, "SelectedDealerVehicle", dealerSqlId);
    SetPVarInt(playerid, "EditingBusiness", DealershipDisplay[didx][ddBusinessID]);
    new title[96], list[1024];
    format(title, sizeof(title), "Dealership Vehicle ID %d", dealerSqlId);
    format(list, sizeof(list), "Edit Vehicle Model: %s\nVehicle Mods\nMove Display Car To Me\nSet Custom Purchase Spawn To Me\nReset Purchase Spawn To Display Position\nSet Price: %s\nSet Stock / Capacity: %d/%d\nSet Colors\nLink To Another Dealership\n%s\nDelete Vehicle", ER_GetVehicleModelName(DealershipDisplay[didx][ddModel]), ER_FormatMoney(DealershipDisplay[didx][ddPrice]), DealershipDisplay[didx][ddStock], DealershipDisplay[didx][ddStockCapacity], DealershipDisplay[didx][ddEnabled] ? "Disable Vehicle" : "Enable Vehicle");
    return ShowPlayerDialog(playerid, DIALOG_DEALERSHIP_OPTIONS, DIALOG_STYLE_LIST, title, list, "Select", "Back");
}

CMD:editdealershipveh(playerid, params[])
{
    new dealerSqlId;
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return 0;
    if(sscanf(params, "d", dealerSqlId)) return ER_Send(playerid, COLOR_GREY, "USAGE: /editdealershipveh [Vehicle ID]");
    return ER_ShowDealershipVehicleEditor(playerid, dealerSqlId);
}
alias:editdealershipveh("editdealershipvehicle")

stock ER_ProcessDealershipPurchase(playerid, dealerSqlId)
{
    new didx = ER_FindDealershipDisplayBySQL(dealerSqlId);
    if(didx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid dealership vehicle.");
    if(DealershipDisplay[didx][ddStock] <= 0) return ER_Send(playerid, COLOR_GREY, "This vehicle is out of stock.");

    new owned;
    for(new i; i < VehicleCount; i++) if(VehicleInfo[i][vOwnerPID] == PlayerInfo[playerid][pID]) owned++;
    if(owned >= ER_GetMaxVehicles(playerid)) return ER_Send(playerid, COLOR_GREY, "You have reached your vehicle ownership limit.");
    if(PlayerInfo[playerid][pCash] < DealershipDisplay[didx][ddPrice]) return ER_Send(playerid, COLOR_GREY, "You cannot afford this vehicle.");

    PlayerInfo[playerid][pCash] -= DealershipDisplay[didx][ddPrice];
    GivePlayerMoney(playerid, -DealershipDisplay[didx][ddPrice]);

    new bidx = ER_FindBusinessIndexBySQLID(DealershipDisplay[didx][ddBusinessID]);
    if(bidx != -1) Businesses[bidx][bSafeBalance] += DealershipDisplay[didx][ddPrice];

    new Float:sx = DealershipDisplay[didx][ddSpawnX], Float:sy = DealershipDisplay[didx][ddSpawnY], Float:sz = DealershipDisplay[didx][ddSpawnZ], Float:sa = DealershipDisplay[didx][ddSpawnA];
    new sint = DealershipDisplay[didx][ddSpawnInt], svw = DealershipDisplay[didx][ddSpawnVW];
    if(sx == 0.0 && sy == 0.0 && sz == 0.0)
    {
        sx = DealershipDisplay[didx][ddX]; sy = DealershipDisplay[didx][ddY] + 4.0; sz = DealershipDisplay[didx][ddZ]; sa = DealershipDisplay[didx][ddA];
        sint = DealershipDisplay[didx][ddInt]; svw = DealershipDisplay[didx][ddVW];
    }

    SetPVarInt(playerid, "DealerBuyModel", DealershipDisplay[didx][ddModel]);
    SetPVarInt(playerid, "DealerBuyBusiness", DealershipDisplay[didx][ddBusinessID]);
    SetPVarInt(playerid, "DealerBuyPrice", DealershipDisplay[didx][ddPrice]);
    SetPVarInt(playerid, "DealerBuyDealer", dealerSqlId);
    SetPVarFloat(playerid, "DealerBuyX", sx); SetPVarFloat(playerid, "DealerBuyY", sy); SetPVarFloat(playerid, "DealerBuyZ", sz); SetPVarFloat(playerid, "DealerBuyA", sa);
    SetPVarInt(playerid, "DealerBuyInt", sint); SetPVarInt(playerid, "DealerBuyVW", svw);

    new q[2048];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `vehicles` (`owner_pid`,`family_id`,`faction_id`,`model`,`color1`,`color2`,`paintjob`,`x`,`y`,`z`,`a`,`interior`,`vw`,`lock_type`,`nos`,`unlimited_nos`,`mod_spoiler`,`mod_hood`,`mod_roof`,`mod_sideskirt_l`,`mod_sideskirt_r`,`mod_lamps`,`mod_nitro`,`mod_exhaust`,`mod_wheels`,`mod_stereo`,`mod_hydraulics`,`mod_front_bumper`,`mod_rear_bumper`,`mod_vent_right`,`mod_vent_left`,`enabled`) VALUES (%d,0,0,%d,%d,%d,%d,%f,%f,%f,%f,%d,%d,0,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,1)", PlayerInfo[playerid][pID], DealershipDisplay[didx][ddModel], DealershipDisplay[didx][ddColor1], DealershipDisplay[didx][ddColor2], DealershipDisplay[didx][ddPaintjob], sx, sy, sz, sa, sint, svw, DealershipDisplay[didx][ddNos], DealershipDisplay[didx][ddUnlimitedNos], DealershipDisplay[didx][ddModSpoiler], DealershipDisplay[didx][ddModHood], DealershipDisplay[didx][ddModRoof], DealershipDisplay[didx][ddModSideskirtL], DealershipDisplay[didx][ddModSideskirtR], DealershipDisplay[didx][ddModLamps], DealershipDisplay[didx][ddModNitro], DealershipDisplay[didx][ddModExhaust], DealershipDisplay[didx][ddModWheels], DealershipDisplay[didx][ddModStereo], DealershipDisplay[didx][ddModHydraulics], DealershipDisplay[didx][ddModFrontBumper], DealershipDisplay[didx][ddModRearBumper], DealershipDisplay[didx][ddModVentRight], DealershipDisplay[didx][ddModVentLeft]);
    mysql_tquery(MainPipeline, q, "ER_OnDealerVehiclePurchased", "i", playerid);
    return 1;
}

forward ER_OnDealerVehiclePurchased(playerid);
public ER_OnDealerVehiclePurchased(playerid)
{
    new vehicleSqlId = cache_insert_id();
    new model = GetPVarInt(playerid, "DealerBuyModel");
    new price = GetPVarInt(playerid, "DealerBuyPrice");
    new businessid = GetPVarInt(playerid, "DealerBuyBusiness");
    new dealerSqlId = GetPVarInt(playerid, "DealerBuyDealer");
    new didx = ER_FindDealershipDisplayBySQL(dealerSqlId);
    new Float:x = GetPVarFloat(playerid, "DealerBuyX"), Float:y = GetPVarFloat(playerid, "DealerBuyY"), Float:z = GetPVarFloat(playerid, "DealerBuyZ"), Float:a = GetPVarFloat(playerid, "DealerBuyA");
    new interior = GetPVarInt(playerid, "DealerBuyInt"), vw = GetPVarInt(playerid, "DealerBuyVW");

    if(VehicleCount < MAX_DYNAMIC_VEHICLES)
    {
        new idx = VehicleCount;
        VehicleInfo[idx][vSQLID] = vehicleSqlId;
        VehicleInfo[idx][vOwnerPID] = PlayerInfo[playerid][pID];
        VehicleInfo[idx][vFamilyID] = 0; VehicleInfo[idx][vFactionID] = 0; VehicleInfo[idx][vModel] = model; VehicleInfo[idx][vColor1] = DealershipDisplay[didx][ddColor1]; VehicleInfo[idx][vColor2] = DealershipDisplay[didx][ddColor2]; VehicleInfo[idx][vPaintjob] = DealershipDisplay[didx][ddPaintjob];
        VehicleInfo[idx][vNos] = DealershipDisplay[didx][ddNos]; VehicleInfo[idx][vUnlimitedNos] = DealershipDisplay[didx][ddUnlimitedNos];
        VehicleInfo[idx][vModSpoiler] = DealershipDisplay[didx][ddModSpoiler]; VehicleInfo[idx][vModHood] = DealershipDisplay[didx][ddModHood]; VehicleInfo[idx][vModRoof] = DealershipDisplay[didx][ddModRoof];
        VehicleInfo[idx][vModSideskirtL] = DealershipDisplay[didx][ddModSideskirtL]; VehicleInfo[idx][vModSideskirtR] = DealershipDisplay[didx][ddModSideskirtR]; VehicleInfo[idx][vModLamps] = DealershipDisplay[didx][ddModLamps];
        VehicleInfo[idx][vModNitro] = DealershipDisplay[didx][ddModNitro]; VehicleInfo[idx][vModExhaust] = DealershipDisplay[didx][ddModExhaust]; VehicleInfo[idx][vModWheels] = DealershipDisplay[didx][ddModWheels];
        VehicleInfo[idx][vModStereo] = DealershipDisplay[didx][ddModStereo]; VehicleInfo[idx][vModHydraulics] = DealershipDisplay[didx][ddModHydraulics]; VehicleInfo[idx][vModFrontBumper] = DealershipDisplay[didx][ddModFrontBumper];
        VehicleInfo[idx][vModRearBumper] = DealershipDisplay[didx][ddModRearBumper]; VehicleInfo[idx][vModVentRight] = DealershipDisplay[didx][ddModVentRight]; VehicleInfo[idx][vModVentLeft] = DealershipDisplay[didx][ddModVentLeft];
        VehicleInfo[idx][vX] = x; VehicleInfo[idx][vY] = y; VehicleInfo[idx][vZ] = z; VehicleInfo[idx][vA] = a; VehicleInfo[idx][vInt] = interior; VehicleInfo[idx][vVW] = vw; VehicleInfo[idx][vLockType] = 0;
        VehicleInfo[idx][vSpawnedID] = CreateVehicle(model, x, y, z, a, VehicleInfo[idx][vColor1], VehicleInfo[idx][vColor2], -1);
        SetVehicleVirtualWorld(VehicleInfo[idx][vSpawnedID], vw); LinkVehicleToInterior(VehicleInfo[idx][vSpawnedID], interior);

        // Important: increment before ER_ApplyVehicleMods because it validates idx against VehicleCount.
        VehicleCount++;
        ER_ApplyVehicleMods(idx);
        SetTimerEx("ER_ReapplyLoadedVehicleMods", 1000, false, "i", idx);
        PutPlayerInVehicle(playerid, VehicleInfo[idx][vSpawnedID], 0);
    }

    new q[384];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `cash`=%d WHERE `id`=%d", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pID]); mysql_tquery(MainPipeline, q);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=`safe_balance`+%d WHERE `id`=%d", price, businessid); mysql_tquery(MainPipeline, q);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `dealership_vehicles` SET `stock`=`stock`-1 WHERE `id`=%d AND `stock`>0", dealerSqlId); mysql_tquery(MainPipeline, q);
    if(didx != -1 && DealershipDisplay[didx][ddStock] > 0) DealershipDisplay[didx][ddStock]--;

    DeletePVar(playerid, "DealerBuyModel"); DeletePVar(playerid, "DealerBuyPrice"); DeletePVar(playerid, "DealerBuyBusiness"); DeletePVar(playerid, "DealerBuyDealer");
    DeletePVar(playerid, "DealerBuyX"); DeletePVar(playerid, "DealerBuyY"); DeletePVar(playerid, "DealerBuyZ"); DeletePVar(playerid, "DealerBuyA"); DeletePVar(playerid, "DealerBuyInt"); DeletePVar(playerid, "DealerBuyVW");
    new msg[128]; format(msg, sizeof(msg), "You purchased a %s for %s.", ER_GetVehicleModelName(model), ER_FormatMoney(price));
    return ER_Send(playerid, COLOR_GREEN, msg);
}

#define ER_BANK_BAG_ATTACH_SLOT 8
#define ER_BANK_BAG_MODEL 1550

stock ER_AttachBankCashBag(playerid)
{
    if(IsPlayerAttachedObjectSlotUsed(playerid, ER_BANK_BAG_ATTACH_SLOT)) RemovePlayerAttachedObject(playerid, ER_BANK_BAG_ATTACH_SLOT);
    // Secured bank cash bag attached to the player's back/chest area.
    SetPlayerAttachedObject(playerid, ER_BANK_BAG_ATTACH_SLOT, ER_BANK_BAG_MODEL, 1, -0.1200, -0.1700, -0.0200, 0.0000, 85.0000, 0.0000, 0.8500, 0.8500, 0.8500);
    return 1;
}

stock ER_ClearBankCashBag(playerid)
{
    if(IsPlayerAttachedObjectSlotUsed(playerid, ER_BANK_BAG_ATTACH_SLOT)) RemovePlayerAttachedObject(playerid, ER_BANK_BAG_ATTACH_SLOT);
    DeletePVar(playerid, "BankCashBag");
    DeletePVar(playerid, "BankCashBagBusiness");
    return 1;
}

stock ER_RefreshBankCashBag(playerid)
{
    if(GetPVarInt(playerid, "BankCashBag") > 0) return ER_AttachBankCashBag(playerid);
    return ER_ClearBankCashBag(playerid);
}

#define ER_BANK_ACTION_REFILL_ATM 1
#define ER_BANK_ACTION_COLLECT_ATM 2
#define ER_BANK_ATM_ACTION_TIME 7000

stock ER_IsDoingBankATMAction(playerid)
{
    return GetPVarInt(playerid, "BankATMAction");
}

stock ER_CancelBankATMAction(playerid)
{
    if(GetPVarInt(playerid, "BankATMAction"))
    {
        new tid = GetPVarInt(playerid, "BankATMActionTimer");
        if(tid) KillTimer(tid);
        TogglePlayerControllable(playerid, 1);
        ClearAnimations(playerid);
        GameTextForPlayer(playerid, "~r~ATM service cancelled", 1500, 3);
    }
    DeletePVar(playerid, "BankATMAction");
    DeletePVar(playerid, "BankATMActionAmount");
    DeletePVar(playerid, "BankATMActionATM");
    DeletePVar(playerid, "BankATMActionTimer");
    return 1;
}

stock ER_StartBankATMAction(playerid, action, aidx, amount)
{
    if(GetPVarInt(playerid, "BankATMAction")) return ER_Send(playerid, COLOR_GREY, "You are already servicing an ATM.");

    SetPVarInt(playerid, "BankATMAction", action);
    SetPVarInt(playerid, "BankATMActionAmount", amount);
    SetPVarInt(playerid, "BankATMActionATM", aidx);

    TogglePlayerControllable(playerid, 0);
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 1, 0, 0, 0, 0, 1);

    new Float:x, Float:y, Float:z, rp[160]; GetPlayerPos(playerid, x, y, z);
    if(action == ER_BANK_ACTION_REFILL_ATM)
    {
        format(rp, sizeof(rp), "* %s kneels down and begins refilling the ATM from a secured cash bag.", ER_GetName(playerid));
        GameTextForPlayer(playerid, "~w~Refilling ATM...~n~~y~Please wait", ER_BANK_ATM_ACTION_TIME, 3);
    }
    else
    {
        format(rp, sizeof(rp), "* %s unlocks the ATM service panel and starts collecting the stored service fees.", ER_GetName(playerid));
        GameTextForPlayer(playerid, "~w~Collecting ATM fees...~n~~y~Please wait", ER_BANK_ATM_ACTION_TIME, 3);
    }
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

    new tid = SetTimerEx("ER_FinishBankATMAction", ER_BANK_ATM_ACTION_TIME, false, "i", playerid);
    SetPVarInt(playerid, "BankATMActionTimer", tid);
    return 1;
}

forward ER_FinishBankATMAction(playerid);
public ER_FinishBankATMAction(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new action = GetPVarInt(playerid, "BankATMAction");
    new amount = GetPVarInt(playerid, "BankATMActionAmount");
    new aidx = GetPVarInt(playerid, "BankATMActionATM");

    DeletePVar(playerid, "BankATMAction");
    DeletePVar(playerid, "BankATMActionAmount");
    DeletePVar(playerid, "BankATMActionATM");
    DeletePVar(playerid, "BankATMActionTimer");

    TogglePlayerControllable(playerid, 1);
    ClearAnimations(playerid);

    if(aidx < 0 || aidx >= BusinessATMCount) return ER_Send(playerid, COLOR_GREY, "ATM service failed. Invalid ATM.");
    if(ER_GetNearestATM(playerid) != aidx) return ER_Send(playerid, COLOR_GREY, "ATM service cancelled because you moved away.");

    new bidx = ER_FindBusinessIndexBySQLID(BusinessATMs[aidx][atmBusinessID]);
    if(bidx == -1 || !ER_PlayerCanManageBusiness(playerid, bidx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to service this ATM.");

    if(action == ER_BANK_ACTION_REFILL_ATM)
    {
        if(amount <= 0) return ER_Send(playerid, COLOR_GREY, "ATM refill failed. Invalid amount.");
        if(BusinessATMs[aidx][atmCash] >= ATM_CASH_MAX) return ER_Send(playerid, COLOR_GREY, "This ATM is already at the $50,000 cash cap.");
        if(BusinessATMs[aidx][atmCash] + amount > ATM_CASH_MAX) return ER_Send(playerid, COLOR_GREY, "ATM refill failed because it would exceed the $50,000 cash cap.");

        new bag = GetPVarInt(playerid, "BankCashBag");
        if(bag < amount) return ER_Send(playerid, COLOR_GREY, "Your secured cash bag does not have enough cash.");

        bag -= amount;
        if(bag > 0) { SetPVarInt(playerid, "BankCashBag", bag); ER_AttachBankCashBag(playerid); }
        else ER_ClearBankCashBag(playerid);

        BusinessATMs[aidx][atmCash] += amount;
        new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_atms` SET `atm_cash`=%d WHERE `id`=%d", BusinessATMs[aidx][atmCash], BusinessATMs[aidx][atmSQLID]); mysql_tquery(MainPipeline, q);

        new Float:x, Float:y, Float:z, rp[160]; GetPlayerPos(playerid, x, y, z);
        format(rp, sizeof(rp), "* %s finishes refilling the ATM and locks the service panel.", ER_GetName(playerid));
        ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
        new msg[128]; format(msg, sizeof(msg), "You refilled this ATM with %s.", ER_FormatMoney(amount));
        GameTextForPlayer(playerid, "~g~ATM refilled", 2000, 3);
        return ER_Send(playerid, COLOR_GREEN, msg);
    }
    else if(action == ER_BANK_ACTION_COLLECT_ATM)
    {
        if(BusinessATMs[aidx][atmFees] <= 0) return ER_Send(playerid, COLOR_GREY, "This ATM has no fees to collect.");

        new collected = BusinessATMs[aidx][atmFees];
        BusinessATMs[aidx][atmFees] = 0;
        Businesses[bidx][bSafeBalance] += collected;

        new q[192];
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_atms` SET `atm_fees`=0 WHERE `id`=%d", BusinessATMs[aidx][atmSQLID]); mysql_tquery(MainPipeline, q);
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=%d WHERE `id`=%d", Businesses[bidx][bSafeBalance], Businesses[bidx][bSQLID]); mysql_tquery(MainPipeline, q);

        new Float:x, Float:y, Float:z, rp[160]; GetPlayerPos(playerid, x, y, z);
        format(rp, sizeof(rp), "* %s finishes collecting the ATM service fees and locks the cash box.", ER_GetName(playerid));
        ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
        new msg[128]; format(msg, sizeof(msg), "You collected %s in ATM fees into the bank safe.", ER_FormatMoney(collected));
        GameTextForPlayer(playerid, "~g~ATM fees collected", 2000, 3);
        return ER_Send(playerid, COLOR_GREEN, msg);
    }
    return ER_Send(playerid, COLOR_GREY, "ATM service failed. Invalid action.");
}

CMD:collectatm(playerid, params[])
{
    #pragma unused params
    new aidx = ER_GetNearestATM(playerid);
    if(aidx == -1) return ER_Send(playerid, COLOR_GREY, "You are not near an ATM.");
    new bidx = ER_FindBusinessIndexBySQLID(BusinessATMs[aidx][atmBusinessID]);
    if(bidx == -1 || !ER_PlayerCanManageBusiness(playerid, bidx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to service this ATM.");
    if(BusinessATMs[aidx][atmFees] <= 0) return ER_Send(playerid, COLOR_GREY, "This ATM has no fees to collect.");
    return ER_StartBankATMAction(playerid, ER_BANK_ACTION_COLLECT_ATM, aidx, 0);
}

CMD:takebankcash(playerid, params[])
{
    new amount; if(sscanf(params, "d", amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /takebankcash [amount]");
    if(ER_IsDoingBankATMAction(playerid)) return ER_Send(playerid, COLOR_GREY, "Finish servicing the ATM first.");
    if(amount <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid amount.");
    if(amount > BANK_CASH_BAG_MAX) return ER_Send(playerid, COLOR_GREY, "You can only carry up to $50,000 in one secured bank cash bag.");
    if(GetPVarInt(playerid, "BankCashBag") > 0) return ER_Send(playerid, COLOR_GREY, "You are already carrying a secured bank cash bag. Store or refill it first.");
    new bidx = ER_GetBankBusinessAtCounter(playerid);
    if(bidx == -1) return ER_Send(playerid, COLOR_GREY, "You must be near a bank counter.");
    if(!ER_PlayerCanManageBusiness(playerid, bidx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to take bank cash.");
    if(Businesses[bidx][bSafeBalance] < amount) return ER_Send(playerid, COLOR_GREY, "The bank safe does not have enough cash.");
    Businesses[bidx][bSafeBalance] -= amount;
    SetPVarInt(playerid, "BankCashBag", amount);
    SetPVarInt(playerid, "BankCashBagBusiness", Businesses[bidx][bSQLID]);
    ER_AttachBankCashBag(playerid);
    new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=%d WHERE `id`=%d", Businesses[bidx][bSafeBalance], Businesses[bidx][bSQLID]); mysql_tquery(MainPipeline, q);
    new Float:x, Float:y, Float:z, rp[160]; GetPlayerPos(playerid, x, y, z);
    format(rp, sizeof(rp), "* %s removes a secured cash bag from the bank safe and carries it carefully.", ER_GetName(playerid));
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    new msg[128]; format(msg, sizeof(msg), "You took %s from the bank safe into a secured cash bag.", ER_FormatMoney(amount));
    return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:storebankcash(playerid, params[])
{
    #pragma unused params
    if(ER_IsDoingBankATMAction(playerid)) return ER_Send(playerid, COLOR_GREY, "Finish servicing the ATM first.");
    new bidx = ER_GetBankBusinessAtCounter(playerid);
    if(bidx == -1) return ER_Send(playerid, COLOR_GREY, "You must be near a bank counter.");
    if(!ER_PlayerCanManageBusiness(playerid, bidx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to store bank cash.");
    new bag = GetPVarInt(playerid, "BankCashBag");
    if(bag <= 0) return ER_Send(playerid, COLOR_GREY, "You are not carrying a secured cash bag.");
    Businesses[bidx][bSafeBalance] += bag; ER_ClearBankCashBag(playerid);
    new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=%d WHERE `id`=%d", Businesses[bidx][bSafeBalance], Businesses[bidx][bSQLID]); mysql_tquery(MainPipeline, q);
    new Float:x, Float:y, Float:z, rp[160]; GetPlayerPos(playerid, x, y, z);
    format(rp, sizeof(rp), "* %s stores a secured cash bag back inside the bank safe.", ER_GetName(playerid));
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    new msg[128]; format(msg, sizeof(msg), "You stored %s into the bank safe.", ER_FormatMoney(bag));
    return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:refillatm(playerid, params[])
{
    new amount; if(sscanf(params, "d", amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /refillatm [amount]");
    if(amount <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid amount.");
    new aidx = ER_GetNearestATM(playerid);
    if(aidx == -1) return ER_Send(playerid, COLOR_GREY, "You are not near an ATM.");
    new bidx = ER_FindBusinessIndexBySQLID(BusinessATMs[aidx][atmBusinessID]);
    if(bidx == -1 || !ER_PlayerCanManageBusiness(playerid, bidx)) return ER_Send(playerid, COLOR_GREY, "You are not authorized to refill this ATM.");
    if(BusinessATMs[aidx][atmCash] >= ATM_CASH_MAX) return ER_Send(playerid, COLOR_GREY, "This ATM is already at the $50,000 cash cap.");
    if(BusinessATMs[aidx][atmCash] + amount > ATM_CASH_MAX) return ER_Send(playerid, COLOR_GREY, "That refill would exceed the ATM $50,000 cash cap.");
    if(GetPVarInt(playerid, "BankCashBag") < amount) return ER_Send(playerid, COLOR_GREY, "Your secured cash bag does not have enough cash.");
    return ER_StartBankATMAction(playerid, ER_BANK_ACTION_REFILL_ATM, aidx, amount);
}

CMD:deposit(playerid, params[])
{
    new amount; if(sscanf(params, "d", amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /deposit [amount]");
    return ER_ProcessBankAction(playerid, amount, 1, false);
}
CMD:depo(playerid, params[])
{
    new amount; if(sscanf(params, "d", amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /depo [amount]");
    return ER_ProcessBankAction(playerid, amount, 1, false);
}

CMD:withdraw(playerid, params[])
{
    new amount; if(sscanf(params, "d", amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /withdraw [amount]");
    return ER_ProcessBankAction(playerid, amount, 2, false);
}
CMD:withd(playerid, params[])
{
    new amount; if(sscanf(params, "d", amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /withd [amount]");
    return ER_ProcessBankAction(playerid, amount, 2, false);
}

CMD:wiretransfer(playerid, params[])
{
    new target, amount; if(sscanf(params, "ud", target, amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /wiretransfer [playerid/name] [amount]");
    return ER_ProcessWireTransfer(playerid, target, amount, false);
}
CMD:wire(playerid, params[])
{
    new target, amount; if(sscanf(params, "ud", target, amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /wire [playerid/name] [amount]");
    return ER_ProcessWireTransfer(playerid, target, amount, false);
}

CMD:adeposit(playerid, params[])
{
    new amount; if(sscanf(params, "d", amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /adeposit [amount]");
    return ER_ProcessBankAction(playerid, amount, 1, true);
}
CMD:adepo(playerid, params[])
{
    new amount; if(sscanf(params, "d", amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /adepo [amount]");
    return ER_ProcessBankAction(playerid, amount, 1, true);
}

CMD:awithdraw(playerid, params[])
{
    new amount; if(sscanf(params, "d", amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /awithdraw [amount]");
    return ER_ProcessBankAction(playerid, amount, 2, true);
}
CMD:awithd(playerid, params[])
{
    new amount; if(sscanf(params, "d", amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /awithd [amount]");
    return ER_ProcessBankAction(playerid, amount, 2, true);
}

CMD:awiretransfer(playerid, params[])
{
    new target, amount; if(sscanf(params, "ud", target, amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /awiretransfer [playerid/name] [amount]");
    return ER_ProcessWireTransfer(playerid, target, amount, true);
}
CMD:awire(playerid, params[])
{
    new target, amount; if(sscanf(params, "ud", target, amount)) return ER_Send(playerid, COLOR_GREY, "USAGE: /awire [playerid/name] [amount]");
    return ER_ProcessWireTransfer(playerid, target, amount, true);
}

stock ER_AcceptBusinessInvitation(playerid)
{
    new bid = ER_BusinessInviteID[playerid], from = ER_BusinessInviteFrom[playerid];
    if(bid <= 0) return ER_Send(playerid, COLOR_GREY, "You do not have a business invitation.");
    new idx = ER_FindBusinessIndexBySQLID(bid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "That business no longer exists.");
    SetPlayerPos(playerid, Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ]);
    SetPlayerInterior(playerid, Businesses[idx][bExtInt]);
    SetPlayerVirtualWorld(playerid, Businesses[idx][bExtVW]);
    new msg[128]; format(msg, sizeof(msg), "You accepted the invitation to visit %s.", Businesses[idx][bName]); ER_Send(playerid, COLOR_GREEN, msg);
    if(IsPlayerConnected(from)) { format(msg, sizeof(msg), "%s accepted your business invitation.", ER_GetName(playerid)); ER_Send(from, COLOR_GREEN, msg); }
    ER_BusinessInviteID[playerid] = 0; ER_BusinessInviteFrom[playerid] = INVALID_PLAYER_ID;
    return 1;
}

stock ER_RejectBusinessInvitation(playerid)
{
    new from = ER_BusinessInviteFrom[playerid];
    if(ER_BusinessInviteID[playerid] <= 0) return ER_Send(playerid, COLOR_GREY, "You do not have a business invitation.");
    if(IsPlayerConnected(from)) { new msg[96]; format(msg, sizeof(msg), "%s rejected your business invitation.", ER_GetName(playerid)); ER_Send(from, COLOR_GREY, msg); }
    ER_BusinessInviteID[playerid] = 0; ER_BusinessInviteFrom[playerid] = INVALID_PLAYER_ID;
    return ER_Send(playerid, COLOR_GREEN, "Business invitation rejected.");
}

CMD:reject(playerid, params[])
{
    new what[24];
    if(sscanf(params, "s[24]", what)) return ER_Send(playerid, COLOR_GREY, "USAGE: /reject [invitation]");
    if(!strcmp(what, "invitation", true) || !strcmp(what, "business", true)) return ER_RejectBusinessInvitation(playerid);
    return ER_Send(playerid, COLOR_GREY, "USAGE: /reject [invitation]");
}

CMD:buybusiness(playerid, params[])
{
    new idx = ER_GetNearestBusiness(playerid, false);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "You are not near a business.");
    if(Businesses[idx][bOwnerType] != BUSINESS_OWNER_NONE || Businesses[idx][bOwnerID] != 0) return ER_Send(playerid, COLOR_GREY, "This business is already owned.");
    new owned; for(new i; i < BusinessCount; i++) if(Businesses[i][bOwnerType] == BUSINESS_OWNER_PLAYER && Businesses[i][bOwnerID] == PlayerInfo[playerid][pID]) owned++;
    if(owned >= ER_GetMaxBusinesses(playerid)) return ER_Send(playerid, COLOR_GREY, "You have reached your business ownership limit.");
    if(PlayerInfo[playerid][pCash] < Businesses[idx][bPrice]) return ER_Send(playerid, COLOR_GREY, "You do not have enough cash.");
    PlayerInfo[playerid][pCash] -= Businesses[idx][bPrice]; GivePlayerMoney(playerid, -Businesses[idx][bPrice]);
    new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `owner_type`=1,`owner_id`=%d,`owner_name`='%e',`locked`=1 WHERE `id`=%d", PlayerInfo[playerid][pID], PlayerInfo[playerid][pName], Businesses[idx][bSQLID]); mysql_tquery(MainPipeline, q);
    ER_ReloadBusinessBySQLID(Businesses[idx][bSQLID], playerid); return ER_Send(playerid, COLOR_GREEN, "Business purchased.");
}

CMD:sellbusiness(playerid, params[])
{
    new idx = ER_GetNearestBusiness(playerid, false);
    if(idx == -1) idx = ER_GetNearestBusiness(playerid, true);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "You are not near your business.");
    if(Businesses[idx][bOwnerType] != BUSINESS_OWNER_PLAYER || Businesses[idx][bOwnerID] != PlayerInfo[playerid][pID]) return ER_Send(playerid, COLOR_GREY, "You do not own this business.");
    new refund = Businesses[idx][bPrice] / 2;
    PlayerInfo[playerid][pCash] += refund; GivePlayerMoney(playerid, refund);
    new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `owner_type`=0,`owner_id`=0,`owner_name`='Nobody',`locked`=0 WHERE `id`=%d", Businesses[idx][bSQLID]); mysql_tquery(MainPipeline, q);
    ER_ReloadBusinessBySQLID(Businesses[idx][bSQLID], playerid); return ER_Send(playerid, COLOR_GREEN, "Business sold for 50 percent of its price.");
}

// NGRP-inspired lightweight business robbery flow: safe, editable through normal business safe balance.
CMD:robbusiness(playerid, params[])
{
    new idx = ER_GetNearestBusiness(playerid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "You are not near a business.");
    if(Businesses[idx][bSafeBalance] < 1000) return ER_Send(playerid, COLOR_GREY, "This business safe does not have enough cash to rob.");
    if(GetPVarInt(playerid, "RobbingBusiness")) return ER_Send(playerid, COLOR_GREY, "You are already robbing a business.");
    SetPVarInt(playerid, "RobbingBusiness", Businesses[idx][bSQLID]);
    SetPVarInt(playerid, "RobBusinessSeconds", 45);
    TogglePlayerControllable(playerid, 0);
    GameTextForPlayer(playerid, "~r~Robbing Business...", 3000, 3);
    SendClientMessageToAll(COLOR_LIGHTRED, "Dispatch: A business robbery has been reported.");
    SetTimerEx("ER_BusinessRobberyTick", 1000, false, "i", playerid);
    return 1;
}
forward ER_BusinessRobberyTick(playerid);
public ER_BusinessRobberyTick(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new bid = GetPVarInt(playerid, "RobbingBusiness"), seconds = GetPVarInt(playerid, "RobBusinessSeconds"), idx = ER_FindBusinessIndexBySQLID(bid);
    if(idx == -1 || !IsPlayerInRangeOfPoint(playerid, 6.0, Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ]))
    {
        TogglePlayerControllable(playerid, 1); DeletePVar(playerid, "RobbingBusiness"); DeletePVar(playerid, "RobBusinessSeconds");
        return ER_Send(playerid, COLOR_GREY, "Business robbery canceled.");
    }
    if(seconds > 0)
    {
        new gt[64]; format(gt, sizeof(gt), "~r~Robbing Business...~n~~w~%d seconds", seconds);
        GameTextForPlayer(playerid, gt, 1500, 3);
        SetPVarInt(playerid, "RobBusinessSeconds", seconds - 1);
        SetTimerEx("ER_BusinessRobberyTick", 1000, false, "i", playerid);
        return 1;
    }
    new take = Businesses[idx][bSafeBalance] / 5;
    if(take > 50000) take = 50000;
    if(take < 1000) take = 1000;
    if(take > Businesses[idx][bSafeBalance]) take = Businesses[idx][bSafeBalance];
    Businesses[idx][bSafeBalance] -= take;
    GivePlayerMoney(playerid, take); PlayerInfo[playerid][pCash] += take;
    new q[160]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=`safe_balance`-%d WHERE `id`=%d", take, bid); mysql_tquery(MainPipeline, q);
    TogglePlayerControllable(playerid, 1); DeletePVar(playerid, "RobbingBusiness"); DeletePVar(playerid, "RobBusinessSeconds");
    new msg[128]; format(msg, sizeof(msg), "You robbed %s from the business safe.", ER_FormatMoney(take));
    return ER_Send(playerid, COLOR_GREEN, msg);
}
