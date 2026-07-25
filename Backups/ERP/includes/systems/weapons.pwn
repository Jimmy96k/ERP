#if defined _ER_WEAPONS_INCLUDED
    #endinput
#endif
#define _ER_WEAPONS_INCLUDED

stock ER_SaveCurrentWeapons(playerid)
{
    for(new slot; slot < MAX_WEAPON_SLOTS; slot++)
    {
        new weapon, ammo;
        GetPlayerWeaponData(playerid, slot, weapon, ammo);
        PlayerInfo[playerid][pPlayerWeapons][slot] = weapon;
    }
    return 1;
}

stock ER_GiveSavedWeapons(playerid)
{
    ResetPlayerWeapons(playerid);
    for(new slot; slot < MAX_WEAPON_SLOTS; slot++)
    {
        if(PlayerInfo[playerid][pPlayerWeapons][slot] > 0) GivePlayerWeapon(playerid, PlayerInfo[playerid][pPlayerWeapons][slot], 99999);
    }
    return 1;
}

stock ER_ClearSavedWeapons(playerid)
{
    ResetPlayerWeapons(playerid);
    for(new slot; slot < MAX_WEAPON_SLOTS; slot++) PlayerInfo[playerid][pPlayerWeapons][slot] = 0;
    return 1;
}

#define MAX_WEAPON_MATERIAL_COSTS 128
new ER_WMatCount;
new ER_WMatSQLID[MAX_WEAPON_MATERIAL_COSTS];
new ER_WMatWeaponID[MAX_WEAPON_MATERIAL_COSTS];
new ER_WMatName[MAX_WEAPON_MATERIAL_COSTS][32];
new ER_WMatCost[MAX_WEAPON_MATERIAL_COSTS];
new ER_WMatEnabled[MAX_WEAPON_MATERIAL_COSTS];

forward ER_OnWeaponMaterialCostsLoaded();

stock ER_LoadWeaponMaterialCosts()
{
    mysql_tquery(MainPipeline, "SELECT `id`,`weaponid`,`weapon_name`,`material_cost`,`enabled` FROM `weapon_material_costs` ORDER BY `id` ASC, `weaponid` ASC", "ER_OnWeaponMaterialCostsLoaded");
    return 1;
}

public ER_OnWeaponMaterialCostsLoaded()
{
    new rows;
    cache_get_row_count(rows);
    ER_WMatCount = 0;
    for(new r; r < rows && r < MAX_WEAPON_MATERIAL_COSTS; r++)
    {
        cache_get_value_name_int(r, "id", ER_WMatSQLID[ER_WMatCount]);
        cache_get_value_name_int(r, "weaponid", ER_WMatWeaponID[ER_WMatCount]);
        cache_get_value_name(r, "weapon_name", ER_WMatName[ER_WMatCount], 32);
        cache_get_value_name_int(r, "material_cost", ER_WMatCost[ER_WMatCount]);
        cache_get_value_name_int(r, "enabled", ER_WMatEnabled[ER_WMatCount]);
        ER_WMatCount++;
    }
    printf("[WeaponMaterialCosts] Loaded %d weapon material-cost rows.", ER_WMatCount);
    return 1;
}

stock ER_GetWeaponMatIndexByWeapon(weaponid)
{
    for(new i; i < ER_WMatCount; i++)
    {
        if(ER_WMatWeaponID[i] == weaponid && ER_WMatEnabled[i]) return i;
    }
    return -1;
}

stock ER_GetWeaponMatCost(weaponid)
{
    new idx = ER_GetWeaponMatIndexByWeapon(weaponid);
    if(idx == -1) return -1;
    return ER_WMatCost[idx];
}

stock ER_GetWeaponIDFromProductKey(productKey[])
{
    if(strfind(productKey, "weapon_", true) != 0) return 0;
    new tmp[16];
    strmid(tmp, productKey, 7, strlen(productKey), sizeof(tmp));
    return strval(tmp);
}

stock ER_GetWeaponMatDisplayName(weaponid, dest[], size = sizeof(dest))
{
    new idx = ER_GetWeaponMatIndexByWeapon(weaponid);
    if(idx != -1) format(dest, size, "%s", ER_WMatName[idx]);
    else GetWeaponName(weaponid, dest, size);
    if(!dest[0]) format(dest, size, "Weapon %d", weaponid);
    return 1;
}

stock ER_ResolveWeaponMaterial(const input[])
{
    if(!input[0]) return -1;
    new wid = strval(input);
    if(wid > 0)
    {
        if(ER_GetWeaponMatIndexByWeapon(wid) != -1) return wid;
        return -1;
    }
    new found = -1;
    for(new i; i < ER_WMatCount; i++)
    {
        if(!ER_WMatEnabled[i]) continue;
        if(strfind(ER_WMatName[i], input, true) != -1)
        {
            if(found != -1) return -2;
            found = ER_WMatWeaponID[i];
        }
    }
    return found;
}

stock ER_ShowSellGunUsage(playerid)
{
    ER_Send(playerid, COLOR_GREY, "Usage: /sellgun [playerid] [weaponname] [price]");
    ER_Send(playerid, COLOR_GREY, "Available Weapons to sell:");

    new line[160], part[48], count, lineCount;
    line[0] = EOS;
    for(new i; i < ER_WMatCount; i++)
    {
        if(!ER_WMatEnabled[i]) continue;

        format(part, sizeof(part), "%s (%d)", ER_WMatName[i], ER_WMatCost[i]);
        if(lineCount == 4)
        {
            ER_Send(playerid, COLOR_GREY, line);
            line[0] = EOS;
            lineCount = 0;
        }
        if(line[0]) strcat(line, ", ", sizeof(line));
        strcat(line, part, sizeof(line));
        lineCount++;
        count++;
    }
    if(line[0]) ER_Send(playerid, COLOR_GREY, line);
    if(!count) ER_Send(playerid, COLOR_GREY, "No weapons available to sell.");
    return 1;
}

stock ER_ShowMakeGunUsage(playerid)
{
    ER_Send(playerid, COLOR_GREY, "Usage: /makegun [weaponname]");
    ER_Send(playerid, COLOR_GREY, "Available Weapons to make:");

    new line[160], part[48], count, lineCount;
    line[0] = EOS;
    for(new i; i < ER_WMatCount; i++)
    {
        if(!ER_WMatEnabled[i]) continue;

        format(part, sizeof(part), "%s (%d)", ER_WMatName[i], ER_WMatCost[i]);
        if(lineCount == 4)
        {
            ER_Send(playerid, COLOR_GREY, line);
            line[0] = EOS;
            lineCount = 0;
        }
        if(line[0]) strcat(line, ", ", sizeof(line));
        strcat(line, part, sizeof(line));
        lineCount++;
        count++;
    }
    if(line[0]) ER_Send(playerid, COLOR_GREY, line);
    if(!count) ER_Send(playerid, COLOR_GREY, "No weapons available to make.");
    return 1;
}

stock ER_ShowWeaponCostList(playerid)
{
    new list[4096], row[96];
    for(new i; i < ER_WMatCount; i++)
    {
        format(row, sizeof(row), "%d - (%d) %s - Materials: %d - %s\n", ER_WMatSQLID[i], ER_WMatWeaponID[i], ER_WMatName[i], ER_WMatCost[i], ER_WMatEnabled[i] ? ("Enabled") : ("Disabled"));
        strcat(list, row, sizeof(list));
    }
    if(!list[0]) format(list, sizeof(list), "No weapon costs found. Use /addweapon to create one.");
    return ShowPlayerDialog(playerid, DIALOG_WEAPON_COST_LIST, DIALOG_STYLE_LIST, "Weapon Material Costs", list, "Edit", "Close");
}

stock ER_ShowWeaponCostMenu(playerid, sqlid)
{
    new idx = -1;
    for(new i; i < ER_WMatCount; i++)
    {
        if(ER_WMatSQLID[i] == sqlid) { idx = i; break; }
    }
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Weapon material-cost row not found.");
    SetPVarInt(playerid, "EditingWeaponCostID", sqlid);
    new list[256];
    format(list, sizeof(list), "Weapon ID: %d\nName: %s\nMaterial Cost: %d\nEnabled: %s", ER_WMatWeaponID[idx], ER_WMatName[idx], ER_WMatCost[idx], ER_WMatEnabled[idx] ? ("Yes") : ("No"));
    return ShowPlayerDialog(playerid, DIALOG_WEAPON_COST_MENU, DIALOG_STYLE_LIST, "Edit Weapon Material Cost", list, "Select", "Back");
}

CMD:addweapon(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new weaponid, cost, name[32], q[256];
    if(sscanf(params, "dds[32]", weaponid, cost, name)) return ER_Send(playerid, COLOR_GREY, "USAGE: /addweapon [weaponid] [materialcost] [weapon name]");
    if(weaponid < 0 || weaponid > 46) return ER_Send(playerid, COLOR_GREY, "Invalid GTA weapon ID.");
    if(cost < 0 || cost > 1000000) return ER_Send(playerid, COLOR_GREY, "Invalid material cost.");
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `weapon_material_costs` (`weaponid`,`weapon_name`,`material_cost`,`enabled`) VALUES (%d,'%e',%d,1) ON DUPLICATE KEY UPDATE `weapon_name`=VALUES(`weapon_name`),`material_cost`=VALUES(`material_cost`),`enabled`=1", weaponid, name, cost);
    mysql_tquery(MainPipeline, q);
    ER_LoadWeaponMaterialCosts();
    return ER_Send(playerid, COLOR_GREEN, "Weapon material-cost row added/updated.");
}
CMD:addweapons(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new weaponid, cost, name[32], q[256];
    if(sscanf(params, "dds[32]", weaponid, cost, name)) return ER_Send(playerid, COLOR_GREY, "USAGE: /addweapons [weaponid] [materialcost] [weapon name]");
    if(weaponid < 0 || weaponid > 46) return ER_Send(playerid, COLOR_GREY, "Invalid GTA weapon ID.");
    if(cost < 0 || cost > 1000000) return ER_Send(playerid, COLOR_GREY, "Invalid material cost.");
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `weapon_material_costs` (`weaponid`,`weapon_name`,`material_cost`,`enabled`) VALUES (%d,'%e',%d,1) ON DUPLICATE KEY UPDATE `weapon_name`=VALUES(`weapon_name`),`material_cost`=VALUES(`material_cost`),`enabled`=1", weaponid, name, cost);
    mysql_tquery(MainPipeline, q);
    ER_LoadWeaponMaterialCosts();
    return ER_Send(playerid, COLOR_GREEN, "Weapon material-cost row added/updated.");
}

CMD:editweapon(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new sqlid;
    if(sscanf(params, "D(0)", sqlid)) sqlid = 0;
    if(sqlid > 0) return ER_ShowWeaponCostMenu(playerid, sqlid);
    return ER_ShowWeaponCostList(playerid);
}
CMD:editweapons(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_SENIOR)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new sqlid;
    if(sscanf(params, "D(0)", sqlid)) sqlid = 0;
    if(sqlid > 0) return ER_ShowWeaponCostMenu(playerid, sqlid);
    return ER_ShowWeaponCostList(playerid);
}

stock ER_WeaponDialog(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_WEAPON_COST_LIST)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= ER_WMatCount) return 1;
        return ER_ShowWeaponCostMenu(playerid, ER_WMatSQLID[listitem]);
    }
    if(dialogid == DIALOG_WEAPON_COST_MENU)
    {
        if(!response) return ER_ShowWeaponCostList(playerid);
        if(listitem == 0) return ShowPlayerDialog(playerid, DIALOG_WEAPON_COST_WEAPONID, DIALOG_STYLE_INPUT, "Weapon ID", "Enter GTA weapon ID:", "Save", "Back");
        if(listitem == 1) return ShowPlayerDialog(playerid, DIALOG_WEAPON_COST_NAME, DIALOG_STYLE_INPUT, "Weapon Name", "Enter weapon display name:", "Save", "Back");
        if(listitem == 2) return ShowPlayerDialog(playerid, DIALOG_WEAPON_COST_MATS, DIALOG_STYLE_INPUT, "Material Cost", "Enter material cost:", "Save", "Back");
        if(listitem == 3) return ShowPlayerDialog(playerid, DIALOG_WEAPON_COST_ENABLED, DIALOG_STYLE_LIST, "Enabled", "No\nYes", "Save", "Back");
        return 1;
    }
    if(dialogid == DIALOG_WEAPON_COST_WEAPONID || dialogid == DIALOG_WEAPON_COST_NAME || dialogid == DIALOG_WEAPON_COST_MATS || dialogid == DIALOG_WEAPON_COST_ENABLED)
    {
        new sqlid = GetPVarInt(playerid, "EditingWeaponCostID"), q[256];
        if(!response) return ER_ShowWeaponCostMenu(playerid, sqlid);
        if(sqlid <= 0) return 1;
        if(dialogid == DIALOG_WEAPON_COST_WEAPONID)
        {
            new wid = strval(inputtext);
            if(wid < 0 || wid > 46) return ER_Send(playerid, COLOR_GREY, "Invalid GTA weapon ID.");
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `weapon_material_costs` SET `weaponid`=%d WHERE `id`=%d", wid, sqlid);
        }
        else if(dialogid == DIALOG_WEAPON_COST_NAME)
        {
            if(!inputtext[0]) return ER_Send(playerid, COLOR_GREY, "Name cannot be empty.");
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `weapon_material_costs` SET `weapon_name`='%e' WHERE `id`=%d", inputtext, sqlid);
        }
        else if(dialogid == DIALOG_WEAPON_COST_MATS)
        {
            new cost = strval(inputtext);
            if(cost < 0 || cost > 1000000) return ER_Send(playerid, COLOR_GREY, "Invalid material cost.");
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `weapon_material_costs` SET `material_cost`=%d WHERE `id`=%d", cost, sqlid);
        }
        else if(dialogid == DIALOG_WEAPON_COST_ENABLED)
        {
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `weapon_material_costs` SET `enabled`=%d WHERE `id`=%d", listitem == 1, sqlid);
        }
        mysql_tquery(MainPipeline, q);
        ER_LoadWeaponMaterialCosts();
        ER_Send(playerid, COLOR_GREEN, "Weapon material-cost setting saved.");
        return ER_ShowWeaponCostMenu(playerid, sqlid);
    }
    return 0;
}
