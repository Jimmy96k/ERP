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
    atmEnabled
};
new BusinessATMs[MAX_BUSINESS_ATMS][E_BUSINESS_ATM];
new BusinessATMCount;
new ER_BusinessMapIcon[MAX_BUSINESSES];

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
    return 1273; // default blue house/business icon
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
    if(atm)
    {
        if(ER_GetNearestATM(playerid) == -1) return ER_Send(playerid, COLOR_GREY, "You must be near an ATM to use this command.");
    }
    else
    {
        if(ER_GetBankBusinessAtCounter(playerid) == -1) return ER_Send(playerid, COLOR_GREY, "You must be near a bank counter to use this command.");
    }
    if(action == 1) // deposit
    {
        if(PlayerInfo[playerid][pCash] < amount) return ER_Send(playerid, COLOR_GREY, "You do not have enough cash.");
        PlayerInfo[playerid][pCash] -= amount; PlayerInfo[playerid][pBank] += amount; GivePlayerMoney(playerid, -amount);
        new msg[96]; format(msg, sizeof(msg), "You deposited %s into your bank account.", ER_FormatMoney(amount)); ER_Send(playerid, COLOR_GREEN, msg);
        return 1;
    }
    if(action == 2) // withdraw
    {
        if(PlayerInfo[playerid][pBank] < amount) return ER_Send(playerid, COLOR_GREY, "You do not have enough money in the bank.");
        PlayerInfo[playerid][pBank] -= amount; PlayerInfo[playerid][pCash] += amount; GivePlayerMoney(playerid, amount);
        new msg[96]; format(msg, sizeof(msg), "You withdrew %s from your bank account.", ER_FormatMoney(amount)); ER_Send(playerid, COLOR_GREEN, msg);
        return 1;
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

stock ER_CreateBusinessATMAtPlayer(playerid, businessid)
{
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
    SetPVarFloat(playerid, "NewATMX", x); SetPVarFloat(playerid, "NewATMY", y); SetPVarFloat(playerid, "NewATMZ", z); SetPVarFloat(playerid, "NewATMRZ", a);
    SetPVarInt(playerid, "NewATMVW", GetPlayerVirtualWorld(playerid)); SetPVarInt(playerid, "NewATMInt", GetPlayerInterior(playerid));
    new q[256];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `business_atms` (`business_id`,`x`,`y`,`z`,`rx`,`ry`,`rz`,`vw`,`interior`,`enabled`) VALUES (%d,%f,%f,%f,0.0,0.0,%f,%d,%d,1)", businessid, x, y, z, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
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
        format(label, size, "%s\nOwner: %s\n%s{FFFF00}\nBusiness ID: %d", Businesses[idx][bName], Businesses[idx][bOwnerName], Businesses[idx][bLocked] ? ("{FF0000}Locked") : ("{00FF00}Unlocked"), Businesses[idx][bSQLID]);
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
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `businesses` (`name`,`type`,`owner_type`,`owner_id`,`owner_name`,`price`,`price_mode`,`materials`,`materials_capacity`,`safe_balance`,`ext_x`,`ext_y`,`ext_z`,`ext_a`,`ext_int`,`ext_vw`,`pickup_model`,`pickup_type`,`locked`,`enabled`) VALUES ('%e',%d,0,0,'Nobody',%d,0,0,2000,0,%f,%f,%f,%f,%d,%d,%d,23,0,1)", typeName, type, price, x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), pickup);
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
    new q[768];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `business_products` (`business_id`,`catalog_id`,`product_name`,`product_key`,`price`,`material_cost`,`stock`,`stock_capacity`,`admin_enabled`,`owner_enabled`) SELECT %d,c.`id`,c.`product_name`,c.`product_key`,c.`price`,c.`material_cost`,c.`default_stock_capacity`,c.`default_stock_capacity`,1,1 FROM `business_product_catalog` c LEFT JOIN `business_products` bp ON bp.`business_id`=%d AND bp.`catalog_id`=c.`id` WHERE c.`business_type`=%d AND c.`enabled`=1 AND bp.`id` IS NULL", businessid, businessid, type);
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
    new q[768];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `business_products` (`business_id`,`catalog_id`,`product_name`,`product_key`,`price`,`material_cost`,`stock`,`stock_capacity`,`admin_enabled`,`owner_enabled`) SELECT %d,`id`,`product_name`,`product_key`,`price`,`material_cost`,`default_stock_capacity`,`default_stock_capacity`,1,1 FROM `business_product_catalog` WHERE `business_type`=%d AND `enabled`=1", businessid, type);
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
stock ER_PlayerCanLockBusiness(playerid, idx)
{
    if(idx < 0 || idx >= BusinessCount) return 0;
    if(ER_IsAdmin(playerid, ADMIN_HEAD)) return 1;

    switch(Businesses[idx][bOwnerType])
    {
        case BUSINESS_OWNER_PLAYER: return Businesses[idx][bOwnerID] == PlayerInfo[playerid][pID];
        case BUSINESS_OWNER_FAMILY: return PlayerInfo[playerid][pFamily] == Businesses[idx][bOwnerID] && PlayerInfo[playerid][pFamilyRank] >= 6;
        case BUSINESS_OWNER_FACTION: return PlayerInfo[playerid][pFaction] == Businesses[idx][bOwnerID] && PlayerInfo[playerid][pFactionRank] >= 6;
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
        if(Businesses[idx][bLocked]) return ER_Send(playerid, COLOR_GREY, "This business is locked.");

        new rp[144], Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        format(rp, sizeof(rp), "* %s enters the %s.", ER_GetName(playerid), Businesses[idx][bName]);
        ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

        SetPlayerInterior(playerid, Businesses[idx][bIntInt]);
        SetPlayerVirtualWorld(playerid, Businesses[idx][bIntVW]);
        SetPlayerPos(playerid, Businesses[idx][bIntX], Businesses[idx][bIntY], Businesses[idx][bIntZ]);
        SetPlayerFacingAngle(playerid, Businesses[idx][bIntA]);
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
        new rp[144], Float:x, Float:y, Float:z;
        GetPlayerPos(playerid, x, y, z);
        format(rp, sizeof(rp), "* %s exits the %s.", ER_GetName(playerid), Businesses[i][bName]);
        ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, rp, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

        SetPlayerInterior(playerid, Businesses[i][bExtInt]);
        SetPlayerVirtualWorld(playerid, Businesses[i][bExtVW]);
        SetPlayerPos(playerid, Businesses[i][bExtX], Businesses[i][bExtY], Businesses[i][bExtZ]);
        SetPlayerFacingAngle(playerid, Businesses[i][bExtA]);
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
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `business_products` (`business_id`,`catalog_id`,`product_name`,`product_key`,`price`,`material_cost`,`stock`,`stock_capacity`,`admin_enabled`,`owner_enabled`) SELECT %d,c.`id`,c.`product_name`,c.`product_key`,c.`price`,c.`material_cost`,c.`default_stock_capacity`,c.`default_stock_capacity`,1,1 FROM `business_product_catalog` c LEFT JOIN `business_products` bp ON bp.`business_id`=%d AND bp.`product_key`=c.`product_key` WHERE c.`business_type`=%d AND c.`enabled`=1 AND bp.`id` IS NULL", Businesses[idx][bSQLID], Businesses[idx][bSQLID], Businesses[idx][bType]);
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
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `business_products` (`business_id`,`catalog_id`,`product_name`,`product_key`,`price`,`material_cost`,`stock`,`stock_capacity`,`admin_enabled`,`owner_enabled`) SELECT %d,c.`id`,c.`product_name`,c.`product_key`,c.`price`,c.`material_cost`,c.`default_stock_capacity`,c.`default_stock_capacity`,1,1 FROM `business_product_catalog` c LEFT JOIN `business_products` bp ON bp.`business_id`=%d AND bp.`product_key`=c.`product_key` WHERE c.`business_type`=%d AND c.`enabled`=1 AND bp.`id` IS NULL", bid, bid, Businesses[idx][bType]);
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
    mysql_format(MainPipeline, q, sizeof(q), "SELECT bp.`id`,bp.`product_name`,bp.`price`,bp.`stock`,bp.`stock_capacity`,bp.`admin_enabled`,bp.`owner_enabled` FROM `business_products` bp JOIN `business_product_catalog` c ON c.`id`=bp.`catalog_id` WHERE bp.`business_id`=%d AND c.`business_type`=%d ORDER BY bp.`id` ASC LIMIT 64", bid, Businesses[idx][bType]);
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

    new list[2048], name[64], price, productStock, cap, pid, ae, oe;
    ER_BuyProductCount[playerid] = 0;
    for(new r; r < rows && r < 64; r++)
    {
        cache_get_value_name_int(r, "id", pid);
        cache_get_value_name(r, "product_name", name, sizeof(name));
        cache_get_value_name_int(r, "price", price);
        cache_get_value_name_int(r, "stock", productStock);
        cache_get_value_name_int(r, "stock_capacity", cap);
        cache_get_value_name_int(r, "admin_enabled", ae);
        cache_get_value_name_int(r, "owner_enabled", oe);
        ER_BuyProductID[playerid][r] = pid;
        format(list, sizeof(list), "%s%d | %s | Price: %s | Stock: %d/%d | %s/%s\n", list, pid, name, ER_FormatMoney(price), productStock, cap, ae ? ("Admin ON") : ("Admin OFF"), oe ? ("Owner ON") : ("Owner OFF"));
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

    new title[96], list[2048], typeName[32], ownerType[32], lockText[12], statusText[12];
    ER_GetBusinessTypeName(Businesses[idx][bType], typeName, sizeof(typeName));
    ER_GetBusinessOwnerTypeName(Businesses[idx][bOwnerType], ownerType, sizeof(ownerType));
    format(lockText, sizeof(lockText), "%s", Businesses[idx][bLocked] ? ("{FF0000}Locked") : ("{00FF00}Unlocked"));
    format(statusText, sizeof(statusText), "%s", Businesses[idx][bEnabled] ? ("Enabled") : ("Disabled"));
    format(title, sizeof(title), "Business Editor - ID %d", bid);
    format(list, sizeof(list), "Name: %s\nType: %s\nOwner Type: %s\nOwner ID: %d\nPrice: %s\nSet Exterior Position\nSet Interior Position\nInterior Options\nSet Counter / Service Position\nMaterials: %d/%d\nSafe Balance: %s\nManage Products / Stock\nPickup Icon: %d\nToggle Lock: %s\nToggle Status: %s\nReload This Business\nDelete Business\nType Settings",
        Businesses[idx][bName], typeName, ownerType, Businesses[idx][bOwnerID], ER_FormatMoney(Businesses[idx][bPrice]),
        Businesses[idx][bMaterials], Businesses[idx][bMaterialsCapacity], ER_FormatMoney(Businesses[idx][bSafeBalance]),
        Businesses[idx][bPickupModel], lockText, statusText);
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

stock ER_ShowMyBusinessMenu(playerid, bid)
{
    new idx = ER_FindBusinessIndexBySQLID(bid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");
    if(Businesses[idx][bOwnerType] != BUSINESS_OWNER_PLAYER || Businesses[idx][bOwnerID] != PlayerInfo[playerid][pID]) return ER_Send(playerid, COLOR_GREY, "You do not own this business.");
    SetPVarInt(playerid, "MyBusiness", bid);
    new title[96], body[768], typeName[32], lockText[16];
    ER_GetBusinessTypeName(Businesses[idx][bType], typeName, sizeof(typeName));
    format(lockText, sizeof(lockText), "%s", Businesses[idx][bLocked] ? ("Locked") : ("Unlocked"));
    format(title, sizeof(title), "Business Settings - ID %d", bid);
    format(body, sizeof(body), "Name: %s\nType: %s\nSafe Balance: %s\nMaterials: %d/%d\nStatus: %s\n\nWithdraw Safe Money\nDeposit Safe Money\nManage Products / Stock\nToggle Lock\nTrack Business",
        Businesses[idx][bName], typeName, ER_FormatMoney(Businesses[idx][bSafeBalance]), Businesses[idx][bMaterials], Businesses[idx][bMaterialsCapacity], lockText);
    ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_MENU, DIALOG_STYLE_LIST, title, body, "Select", "Close");
    return 1;
}

CMD:mybusinesses(playerid, params[])
{
    new count, msg[144], list[1024];
    for(new i; i < BusinessCount; i++) if(Businesses[i][bOwnerType] == BUSINESS_OWNER_PLAYER && Businesses[i][bOwnerID] == PlayerInfo[playerid][pID])
    {
        ER_BuyProductID[playerid][count] = Businesses[i][bSQLID];
        format(list, sizeof(list), "%s%d - %s (ID %d)\n", list, count + 1, Businesses[i][bName], Businesses[i][bSQLID]);
        count++;
    }
    if(!count) return ER_Send(playerid, COLOR_GREY, "You do not own any businesses.");
    ER_BuyProductCount[playerid] = count;
    format(msg, sizeof(msg), "Your Businesses (%d/%d)", count, ER_GetMaxBusinesses(playerid));
    ShowPlayerDialog(playerid, DIALOG_MY_BUSINESS_LIST, DIALOG_STYLE_LIST, msg, list, "Select", "Close");
    return 1;
}

CMD:businesssettings(playerid, params[])
{
    new idx = ER_GetNearestBusiness(playerid, true);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "You are not inside your business.");
    if(Businesses[idx][bOwnerType] != BUSINESS_OWNER_PLAYER || Businesses[idx][bOwnerID] != PlayerInfo[playerid][pID]) return ER_Send(playerid, COLOR_GREY, "You do not own this business.");
    return ER_ShowMyBusinessMenu(playerid, Businesses[idx][bSQLID]);
}

stock ER_BusinessDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_MY_BUSINESS_LIST)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= ER_BuyProductCount[playerid]) return 1;
        return ER_ShowMyBusinessMenu(playerid, ER_BuyProductID[playerid][listitem]);
    }

    if(dialogid == DIALOG_MY_BUSINESS_MENU)
    {
        if(!response) return 1;
        new bid = GetPVarInt(playerid, "MyBusiness"), idx = ER_FindBusinessIndexBySQLID(bid);
        if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Invalid business.");
        if(Businesses[idx][bOwnerType] != BUSINESS_OWNER_PLAYER || Businesses[idx][bOwnerID] != PlayerInfo[playerid][pID]) return ER_Send(playerid, COLOR_GREY, "You do not own this business.");
        if(listitem <= 5) return ER_ShowMyBusinessMenu(playerid, bid);
        switch(listitem)
        {
            case 6: return ER_Send(playerid, COLOR_GREY, "Owner safe withdraw is not finished yet.");
            case 7: return ER_Send(playerid, COLOR_GREY, "Owner safe deposit is not finished yet.");
            case 8: return ER_ShowBusinessProductsAdmin(playerid, bid);
            case 9:
            {
                Businesses[idx][bLocked] = !Businesses[idx][bLocked];
                new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `locked`=%d WHERE `id`=%d", Businesses[idx][bLocked], bid);
                mysql_tquery(MainPipeline, q);
                ER_UpdateBusinessLabel(idx);
                ER_SendBusinessLockRP(playerid, idx, Businesses[idx][bLocked] ? true : false);
                return ER_ShowMyBusinessMenu(playerid, bid);
            }
            case 10:
            {
                SetPlayerCheckpoint(playerid, Businesses[idx][bExtX], Businesses[idx][bExtY], Businesses[idx][bExtZ], 4.0);
                return ER_Send(playerid, COLOR_GREEN, "Business location marked on your map.");
            }
        }
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
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_OWNER_TYPE, DIALOG_STYLE_LIST, "Owner Type", "None / For Sale\nPlayer\nFamily\nFaction", "Select", "Back");
                return 1;
            }
            case 3:
            {
                SetPVarInt(playerid, "BizEditAction", 3);
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Owner ID", "Enter owner ID for the selected owner type.\nPlayer = account ID, Family = family ID, Faction = faction ID.\nUse 0 for no owner.", "Save", "Back");
                return 1;
            }
            case 4:
            {
                SetPVarInt(playerid, "BizEditAction", 4);
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Business Price", "Enter new price:", "Save", "Back");
                return 1;
            }
            case 5:
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
            case 6:
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
            case 7:
            {
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_INTERIORS, DIALOG_STYLE_LIST, "Interior Options", "Use Default Interior For Type\nSet Interior Position To My Current Position\nReset Interior VW To Business ID\nSet Interior VW Manually", "Select", "Back");
                return 1;
            }
            case 8:
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
            case 9:
            {
                SetPVarInt(playerid, "BizEditAction", 9);
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Business Materials", "Enter new materials amount:", "Save", "Back");
                return 1;
            }
            case 10:
            {
                SetPVarInt(playerid, "BizEditAction", 10);
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_INPUT, DIALOG_STYLE_INPUT, "Business Safe Balance", "Enter new safe balance:", "Save", "Back");
                return 1;
            }
            case 11: return ER_ShowBusinessProductsAdmin(playerid, bid);
            case 12:
            {
                ShowPlayerDialog(playerid, DIALOG_BUSINESS_PICKUP, DIALOG_STYLE_LIST, "Pickup Icon", "Default For Type\nHouse Icon\nWhite Arrow / Door\nStore\nClothes\nFood\nGun\nDealership / Car\nGas Station\nBank / Money\nBar / Club\nGym\nCustom Model ID", "Select", "Back");
                return 1;
            }
            case 13:
            {
                Businesses[idx][bLocked] = !Businesses[idx][bLocked];
                new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `locked`=%d WHERE `id`=%d", Businesses[idx][bLocked], bid); mysql_tquery(MainPipeline, q); ER_UpdateBusinessLabel(idx);
                ER_SendBusinessLockRP(playerid, idx, Businesses[idx][bLocked] ? true : false);
                return ER_ShowBusinessEditor(playerid, bid);
            }
            case 14:
            {
                Businesses[idx][bEnabled] = !Businesses[idx][bEnabled];
                new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `enabled`=%d WHERE `id`=%d", Businesses[idx][bEnabled], bid); mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid);
                ER_Send(playerid, COLOR_GREEN, "Business status updated. If disabled, it will disappear from the loaded list.");
                return 1;
            }
            case 15:
            {
                ER_ReloadBusinessBySQLID(bid, playerid);
                return ER_ShowBusinessEditor(playerid, bid);
            }
            case 16:
            {
                new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `enabled`=0 WHERE `id`=%d", bid); mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid);
                DeletePVar(playerid, "EditingBusiness");
                return ER_Send(playerid, COLOR_GREEN, "Business deleted/disabled.");
            }
            case 17:
            {
                if(Businesses[idx][bType] == BUSINESS_TYPE_BANK) ShowPlayerDialog(playerid, DIALOG_BUSINESS_TYPE_SETTINGS, DIALOG_STYLE_LIST, "Bank Settings", "Set Counter Position\nCreate ATM Here\nEdit ATMs", "Select", "Back");
                else if(Businesses[idx][bType] == BUSINESS_TYPE_DEALERSHIP) ShowPlayerDialog(playerid, DIALOG_BUSINESS_TYPE_SETTINGS, DIALOG_STYLE_LIST, "Dealership Settings", "Create Dealership Vehicle\nEdit Dealership Vehicles\nSet Purchased Vehicle Spawn Position", "Select", "Back");
                else if(Businesses[idx][bType] == BUSINESS_TYPE_GAS) ShowPlayerDialog(playerid, DIALOG_BUSINESS_TYPE_SETTINGS, DIALOG_STYLE_LIST, "Gas Station Settings", "Set Counter Position\nCreate Fuel Pump Here\nEdit Fuel Pumps", "Select", "Back");
                else ShowPlayerDialog(playerid, DIALOG_BUSINESS_TYPE_SETTINGS, DIALOG_STYLE_LIST, "Business Type Settings", "Set Counter Position\nEdit Products / Stock", "Select", "Back");
                return 1;
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
                Businesses[idx][bType] = type;
                new typeName[32]; ER_GetBusinessTypeName(type, typeName, sizeof(typeName));
                new Float:ix, Float:iy, Float:iz, Float:ia, iint, ivw;
                ER_SetBusinessInteriorDefaults(type, bid, ix, iy, iz, ia, iint, ivw);
                mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `type`=%d,`name`='%e',`pickup_model`=%d,`pickup_type`=23,`int_x`=%f,`int_y`=%f,`int_z`=%f,`int_a`=%f,`int_int`=%d,`int_vw`=%d WHERE `id`=%d", type, typeName, ER_DefaultBusinessPickup(type), ix, iy, iz, ia, iint, ivw, bid);
                mysql_tquery(MainPipeline, q, "ER_OnBizTypeUpdated", "iii", playerid, bid, type);
                DeletePVar(playerid, "BizEditAction");
                return 1;
            }
            case 3:
            {
                new owner = strval(inputtext);
                Businesses[idx][bOwnerID] = owner;
                new ownerName[32];
                if(owner <= 0)
                {
                    Businesses[idx][bOwnerType] = BUSINESS_OWNER_NONE;
                    format(ownerName, sizeof(ownerName), "Nobody");
                    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `owner_type`=0,`owner_id`=0,`owner_name`='Nobody' WHERE `id`=%d", bid);
                }
                else
                {
                    format(ownerName, sizeof(ownerName), "Owner ID %d", owner);
                    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `owner_id`=%d,`owner_name`='%e' WHERE `id`=%d", owner, ownerName, bid);
                }
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
        new bid = GetPVarInt(playerid, "EditingBusiness"), idx = ER_FindBusinessIndexBySQLID(bid);
        if(idx == -1) return 1;
        new ownerType = listitem;
        Businesses[idx][bOwnerType] = ownerType;
        if(ownerType == BUSINESS_OWNER_NONE) Businesses[idx][bOwnerID] = 0;
        new ownerName[32];
        if(ownerType == BUSINESS_OWNER_NONE) format(ownerName, sizeof(ownerName), "Nobody");
        else format(ownerName, sizeof(ownerName), "Owner ID %d", Businesses[idx][bOwnerID]);
        new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `owner_type`=%d,`owner_id`=%d,`owner_name`='%e' WHERE `id`=%d", ownerType, Businesses[idx][bOwnerID], ownerName, bid);
        mysql_tquery(MainPipeline, q); ER_ReloadBusinessBySQLID(bid, playerid);
        ER_Send(playerid, COLOR_GREEN, "Owner type updated. Set Owner ID next if needed.");
        return ER_ShowBusinessEditor(playerid, bid);
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
            case 1: model = 1273;
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
        ShowPlayerDialog(playerid, DIALOG_BUSINESS_PRODUCTS + 100, DIALOG_STYLE_LIST, "Product Edit", "Set Stock\nSet Price\nToggle Admin Enabled\nToggle Owner Enabled", "Select", "Back");
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
        new q[160];
        if(listitem == 2) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `admin_enabled`=IF(`admin_enabled`=1,0,1) WHERE `id`=%d", pid);
        else if(listitem == 3) mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `owner_enabled`=IF(`owner_enabled`=1,0,1) WHERE `id`=%d", pid);
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
        if(listitem == 0)
        {
            GetPlayerPos(playerid, Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ]); GetPlayerFacingAngle(playerid, Businesses[idx][bSafeA]); Businesses[idx][bSafeInt] = GetPlayerInterior(playerid); Businesses[idx][bSafeVW] = GetPlayerVirtualWorld(playerid);
            new q[256]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_x`=%f,`safe_y`=%f,`safe_z`=%f,`safe_a`=%f,`safe_int`=%d,`safe_vw`=%d WHERE `id`=%d", Businesses[idx][bSafeX], Businesses[idx][bSafeY], Businesses[idx][bSafeZ], Businesses[idx][bSafeA], Businesses[idx][bSafeInt], Businesses[idx][bSafeVW], bid); mysql_tquery(MainPipeline, q);
            ER_Send(playerid, COLOR_GREEN, "Business counter/service position saved.");
            return ER_ShowBusinessEditor(playerid, bid);
        }
        if(Businesses[idx][bType] == BUSINESS_TYPE_BANK && listitem == 1)
        {
            return ER_CreateBusinessATMAtPlayer(playerid, bid);
        }
        return ER_Send(playerid, COLOR_GREY, "This type setting is not finished yet.");
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
    if(!strcmp(productKey, "mp3", true) && PlayerInfo[playerid][pHasMP3]) return ER_Send(playerid, COLOR_GREY, "You already own an MP3 player.");
    if(!strcmp(productKey, "radio", true) && PlayerInfo[playerid][pHasRadio]) return ER_Send(playerid, COLOR_GREY, "You already own a radio.");
    if(!strcmp(productKey, "phone", true))
    {
        ER_PendingPhoneProductID[playerid] = productid;
        ER_PendingPhoneBusinessID[playerid] = businessid;
        ER_PendingPhonePrice[playerid] = price;
        return ER_ShowPhoneNumberBuyDialog(playerid, false);
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
    else if(!strcmp(productKey, "weapon_22", true)) GivePlayerWeapon(playerid, 22, 50);
    else if(!strcmp(productKey, "weapon_23", true)) GivePlayerWeapon(playerid, 23, 50);
    else if(!strcmp(productKey, "weapon_24", true)) GivePlayerWeapon(playerid, 24, 30);
    else if(!strcmp(productKey, "weapon_25", true)) GivePlayerWeapon(playerid, 25, 20);
    else if(!strcmp(productKey, "weapon_29", true)) GivePlayerWeapon(playerid, 29, 120);
    else if(!strcmp(productKey, "weapon_33", true)) GivePlayerWeapon(playerid, 33, 30);
    else if(!strcmp(productKey, "ammo_pack", true)) GivePlayerWeapon(playerid, 22, 50);
    else if(!strcmp(productKey, "armor_50", true)) SetPlayerArmour(playerid, 50.0);
    else if(!strcmp(productKey, "armor_100", true)) SetPlayerArmour(playerid, 100.0);

    new q[384];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `business_products` SET `stock`=`stock`-1 WHERE `id`=%d AND `stock`>0", productid);
    mysql_tquery(MainPipeline, q);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=`safe_balance`+%d WHERE `id`=%d", price, businessid);
    mysql_tquery(MainPipeline, q);
    new bidx = ER_FindBusinessIndexBySQLID(businessid);
    if(bidx != -1) Businesses[bidx][bSafeBalance] += price;

    if(PlayerInfo[playerid][pID] > 0)
    {
        mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `cash`=%d,`phone`=%d,`phonebook`=%d,`has_radio`=%d,`vehicle_lock`=%d,`rope`=%d,`sprunk`=%d,`cigar`=%d,`has_mp3`=%d WHERE `id`=%d",
            PlayerInfo[playerid][pCash], PlayerInfo[playerid][pPhone], PlayerInfo[playerid][pPhonebook], PlayerInfo[playerid][pHasRadio], PlayerInfo[playerid][pVehicleLock], PlayerInfo[playerid][pRope], PlayerInfo[playerid][pSprunk], PlayerInfo[playerid][pCigar], PlayerInfo[playerid][pHasMP3], PlayerInfo[playerid][pID]);
        mysql_tquery(MainPipeline, q);
    }

    new msg[128];
    if(!strcmp(productKey, "rope", true)) format(msg, sizeof(msg), "You bought %s for %s. You received 5 ropes.", productName, ER_FormatMoney(price));
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
