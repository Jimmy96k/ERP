#if defined _ER_TOYS_INCLUDED
    #endinput
#endif
#define _ER_TOYS_INCLUDED

new ER_ToyShopID[MAX_PLAYERS][64];
new ER_ToyShopCount[MAX_PLAYERS];

stock ER_LoadToyCatalog()
{
    printf("[Toys] Toy catalog uses SQL on demand.");
    return 1;
}

stock ER_LoadPlayerToys(playerid)
{
    if(PlayerInfo[playerid][pID] <= 0) return 0;
    new q[128]; mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `player_toys` WHERE `account_id`=%d ORDER BY `slot` ASC LIMIT %d", PlayerInfo[playerid][pID], MAX_PLAYER_TOYS);
    mysql_tquery(MainPipeline, q, "ER_OnPlayerToysLoad", "i", playerid);
    return 1;
}
forward ER_OnPlayerToysLoad(playerid);
public ER_OnPlayerToysLoad(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows; cache_get_row_count(rows); PlayerToyCount[playerid] = 0;
    for(new r; r < rows && r < MAX_PLAYER_TOYS; r++)
    {
        cache_get_value_name_int(r, "id", PlayerToys[playerid][r][ptSQLID]);
        cache_get_value_name_int(r, "slot", PlayerToys[playerid][r][ptSlot]);
        cache_get_value_name(r, "toy_name", PlayerToys[playerid][r][ptName], 32);
        cache_get_value_name_int(r, "modelid", PlayerToys[playerid][r][ptModel]);
        cache_get_value_name_int(r, "bone", PlayerToys[playerid][r][ptBone]);
        cache_get_value_name_float(r, "offset_x", PlayerToys[playerid][r][ptOffX]);
        cache_get_value_name_float(r, "offset_y", PlayerToys[playerid][r][ptOffY]);
        cache_get_value_name_float(r, "offset_z", PlayerToys[playerid][r][ptOffZ]);
        cache_get_value_name_float(r, "rot_x", PlayerToys[playerid][r][ptRotX]);
        cache_get_value_name_float(r, "rot_y", PlayerToys[playerid][r][ptRotY]);
        cache_get_value_name_float(r, "rot_z", PlayerToys[playerid][r][ptRotZ]);
        cache_get_value_name_float(r, "scale_x", PlayerToys[playerid][r][ptScaleX]);
        cache_get_value_name_float(r, "scale_y", PlayerToys[playerid][r][ptScaleY]);
        cache_get_value_name_float(r, "scale_z", PlayerToys[playerid][r][ptScaleZ]);
        cache_get_value_name_int(r, "enabled", PlayerToys[playerid][r][ptEnabled]);
        cache_get_value_name_int(r, "auto_wear", PlayerToys[playerid][r][ptAutoWear]);
        if(PlayerToys[playerid][r][ptEnabled] && PlayerToys[playerid][r][ptAutoWear]) ER_AttachToy(playerid, r);
        PlayerToyCount[playerid]++;
    }
    return 1;
}

stock ER_AttachToy(playerid, slot)
{
    if(slot < 0 || slot >= PlayerToyCount[playerid]) return 0;
    SetPlayerAttachedObject(playerid, slot, PlayerToys[playerid][slot][ptModel], PlayerToys[playerid][slot][ptBone], PlayerToys[playerid][slot][ptOffX], PlayerToys[playerid][slot][ptOffY], PlayerToys[playerid][slot][ptOffZ], PlayerToys[playerid][slot][ptRotX], PlayerToys[playerid][slot][ptRotY], PlayerToys[playerid][slot][ptRotZ], PlayerToys[playerid][slot][ptScaleX], PlayerToys[playerid][slot][ptScaleY], PlayerToys[playerid][slot][ptScaleZ]);
    return 1;
}
stock ER_RemoveToy(playerid, slot)
{
    if(IsPlayerAttachedObjectSlotUsed(playerid, slot)) RemovePlayerAttachedObject(playerid, slot);
    return 1;
}

stock ER_ShowToyShopGrid(playerid, page)
{
    #pragma unused page
    // SA-MP model previews need textdraw work; this version opens a paged toy catalog list and keeps the same data path.
    new q[128]; mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `toy_catalog` WHERE `enabled`=1 ORDER BY id ASC LIMIT 64");
    mysql_tquery(MainPipeline, q, "ER_OnToyShopLoad", "i", playerid);
    return 1;
}
forward ER_OnToyShopLoad(playerid);
public ER_OnToyShopLoad(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows; cache_get_row_count(rows); if(!rows) return ER_Send(playerid, COLOR_GREY, "No toys are available.");
    new list[2048], name[32], price, model, id;
    ER_ToyShopCount[playerid] = 0;
    for(new r; r < rows && r < 64; r++)
    {
        cache_get_value_name_int(r, "id", id); cache_get_value_name(r, "name", name, sizeof(name)); cache_get_value_name_int(r, "modelid", model); cache_get_value_name_int(r, "price", price);
        ER_ToyShopID[playerid][r] = id;
        format(list, sizeof(list), "%s%s - Model %d - %s\n", list, name, model, ER_FormatMoney(price));
        ER_ToyShopCount[playerid]++;
    }
    ShowPlayerDialog(playerid, DIALOG_BUY_TOYS_PAGE, DIALOG_STYLE_LIST, "Buy Toys", list, "Buy", "Cancel");
    return 1;
}

stock ER_ShowClothesGrid(playerid, page)
{
    #pragma unused page
    // Placeholder list for now; each selection previews/buys a skin. Textdraw grid can be added on top of this catalog path.
    new list[1024];
    new skins[] = {7, 15, 20, 22, 23, 26, 28, 29, 46, 60, 98, 101, 102, 103, 104, 105, 106, 107, 108, 109};
    for(new i; i < sizeof(skins); i++) format(list, sizeof(list), "%sSkin %d - $500\n", list, skins[i]);
    ShowPlayerDialog(playerid, DIALOG_BUY_CLOTHES_PAGE, DIALOG_STYLE_LIST, "Buy Clothes", list, "Buy", "Cancel");
    return 1;
}

stock ER_ShowToysMenu(playerid)
{
    ER_LoadPlayerToys(playerid);
    new list[2048];
    for(new i; i < PlayerToyCount[playerid]; i++) format(list, sizeof(list), "%sSlot %d - %s - %s - Auto: %s\n", list, i + 1, PlayerToys[playerid][i][ptName], PlayerToys[playerid][i][ptEnabled] ? ("ON") : ("OFF"), PlayerToys[playerid][i][ptAutoWear] ? ("YES") : ("NO"));
    if(isnull(list)) return ER_Send(playerid, COLOR_GREY, "You do not own any toys.");
    ShowPlayerDialog(playerid, DIALOG_TOYS_LIST, DIALOG_STYLE_LIST, "My Toys", list, "Select", "Close");
    return 1;
}
CMD:toys(playerid, params[])
{
    return ER_ShowToysMenu(playerid);
}

stock ER_ToysDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    #pragma unused inputtext
    if(dialogid == DIALOG_BUY_CLOTHES_PAGE)
    {
        if(!response) return 1;
        new skins[] = {7, 15, 20, 22, 23, 26, 28, 29, 46, 60, 98, 101, 102, 103, 104, 105, 106, 107, 108, 109};
        if(listitem < 0 || listitem >= sizeof(skins)) return 1;
        new price = 500, businessid = ER_BuyBusinessSQL[playerid];
        if(PlayerInfo[playerid][pCash] < price) return ER_Send(playerid, COLOR_GREY, "You do not have enough cash.");
        PlayerInfo[playerid][pCash] -= price; GivePlayerMoney(playerid, -price); PlayerInfo[playerid][pSkin] = skins[listitem]; SetPlayerSkin(playerid, skins[listitem]);
        new q[192]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=`safe_balance`+%d WHERE `id`=%d", price, businessid); mysql_tquery(MainPipeline, q);
        return ER_Send(playerid, COLOR_GREEN, "Clothes purchased and skin saved.");
    }
    if(dialogid == DIALOG_BUY_TOYS_PAGE)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= ER_ToyShopCount[playerid]) return 1;
        new q[128]; mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `toy_catalog` WHERE `id`=%d LIMIT 1", ER_ToyShopID[playerid][listitem]); mysql_tquery(MainPipeline, q, "ER_OnToyBuySelected", "i", playerid); return 1;
    }
    if(dialogid == DIALOG_TOYS_LIST)
    {
        if(!response) return 1; if(listitem < 0 || listitem >= PlayerToyCount[playerid]) return 1; SetPVarInt(playerid, "EditingToySlot", listitem); ShowPlayerDialog(playerid, DIALOG_TOYS_MENU, DIALOG_STYLE_LIST, "Toy Options", "Toggle On/Off\nAuto Wear On/Off\nEdit Position\nReset Position\nDelete Toy", "Select", "Back"); return 1;
    }
    if(dialogid == DIALOG_TOYS_MENU)
    {
        if(!response) return ER_ShowToysMenu(playerid); new slot = GetPVarInt(playerid, "EditingToySlot"); if(slot < 0 || slot >= PlayerToyCount[playerid]) return 1; new sqlid = PlayerToys[playerid][slot][ptSQLID];
        if(listitem == 0) { PlayerToys[playerid][slot][ptEnabled] = !PlayerToys[playerid][slot][ptEnabled]; if(PlayerToys[playerid][slot][ptEnabled]) ER_AttachToy(playerid, slot); else ER_RemoveToy(playerid, slot); new q[128]; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `player_toys` SET `enabled`=%d WHERE `id`=%d",PlayerToys[playerid][slot][ptEnabled],sqlid); mysql_tquery(MainPipeline,q); return ER_Send(playerid,COLOR_GREEN,"Toy toggled."); }
        if(listitem == 1) { PlayerToys[playerid][slot][ptAutoWear] = !PlayerToys[playerid][slot][ptAutoWear]; new q[128]; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `player_toys` SET `auto_wear`=%d WHERE `id`=%d",PlayerToys[playerid][slot][ptAutoWear],sqlid); mysql_tquery(MainPipeline,q); return ER_Send(playerid,COLOR_GREEN,"Toy auto-wear updated."); }
        if(listitem == 2) { ER_AttachToy(playerid, slot); EditAttachedObject(playerid, slot); return ER_Send(playerid,COLOR_GREEN,"Use the mouse editor, then click save. Saving callback will be wired next."); }
        return ER_Send(playerid, COLOR_GREY, "This toy option is reserved for next code pass.");
    }
    return 0;
}
forward ER_OnToyBuySelected(playerid);
public ER_OnToyBuySelected(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new rows; cache_get_row_count(rows); if(!rows) return 1;
    if(PlayerToyCount[playerid] >= ER_GetMaxToys(playerid)) return ER_Send(playerid, COLOR_GREY, "You have reached your toy slot limit.");
    new price, model, bone, name[32]; cache_get_value_name_int(0, "price", price); cache_get_value_name_int(0, "modelid", model); cache_get_value_name_int(0, "bone", bone); cache_get_value_name(0, "name", name, sizeof(name));
    if(PlayerInfo[playerid][pCash] < price) return ER_Send(playerid, COLOR_GREY, "You do not have enough cash.");
    PlayerInfo[playerid][pCash] -= price; GivePlayerMoney(playerid, -price);
    new slot = PlayerToyCount[playerid], q[512];
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `player_toys` (`account_id`,`slot`,`toy_name`,`modelid`,`bone`,`offset_x`,`offset_y`,`offset_z`,`rot_x`,`rot_y`,`rot_z`,`scale_x`,`scale_y`,`scale_z`,`enabled`,`auto_wear`) VALUES (%d,%d,'%e',%d,%d,0.0,0.0,0.0,0.0,0.0,0.0,1.0,1.0,1.0,1,1)", PlayerInfo[playerid][pID], slot, name, model, bone); mysql_tquery(MainPipeline, q);
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `businesses` SET `safe_balance`=`safe_balance`+%d WHERE `id`=%d", price, ER_BuyBusinessSQL[playerid]); mysql_tquery(MainPipeline, q);
    ER_LoadPlayerToys(playerid); return ER_Send(playerid, COLOR_GREEN, "Toy purchased. Use /toys to wear or edit it.");
}

stock ER_OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    #pragma unused modelid
    #pragma unused boneid
    if(response != EDIT_RESPONSE_FINAL) return 0;
    if(index < 0 || index >= PlayerToyCount[playerid]) return 0;
    PlayerToys[playerid][index][ptOffX] = fOffsetX;
    PlayerToys[playerid][index][ptOffY] = fOffsetY;
    PlayerToys[playerid][index][ptOffZ] = fOffsetZ;
    PlayerToys[playerid][index][ptRotX] = fRotX;
    PlayerToys[playerid][index][ptRotY] = fRotY;
    PlayerToys[playerid][index][ptRotZ] = fRotZ;
    PlayerToys[playerid][index][ptScaleX] = fScaleX;
    PlayerToys[playerid][index][ptScaleY] = fScaleY;
    PlayerToys[playerid][index][ptScaleZ] = fScaleZ;
    new q[512];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `player_toys` SET `offset_x`=%f,`offset_y`=%f,`offset_z`=%f,`rot_x`=%f,`rot_y`=%f,`rot_z`=%f,`scale_x`=%f,`scale_y`=%f,`scale_z`=%f WHERE `id`=%d", fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, PlayerToys[playerid][index][ptSQLID]);
    mysql_tquery(MainPipeline, q);
    ER_Send(playerid, COLOR_GREEN, "Toy position saved.");
    return 1;
}
