#if defined _ER_GATES_INCLUDED
    #endinput
#endif
#define _ER_GATES_INCLUDED

enum E_GATE_INFO
{
    gSQLID,
    gName[64],
    gModel,
    gObjectID,
    Float:gClosedX,
    Float:gClosedY,
    Float:gClosedZ,
    Float:gClosedRX,
    Float:gClosedRY,
    Float:gClosedRZ,
    Float:gOpenX,
    Float:gOpenY,
    Float:gOpenZ,
    Float:gOpenRX,
    Float:gOpenRY,
    Float:gOpenRZ,
    gVW,
    gInt,
    gOwnerType,
    gOwnerID,
    gRank,
    Float:gMoveSpeed,
    Float:gRange,
    gOpen,
    gEnabled
};
new Gates[MAX_GATES][E_GATE_INFO];
new GateCount;
new GateEditObject[MAX_PLAYERS];

stock ER_ClearGateEditObject(playerid)
{
    if(GateEditObject[playerid])
    {
        DestroyDynamicObject(GateEditObject[playerid]);
        GateEditObject[playerid] = 0;
    }
    return 1;
}

stock ER_ClearGates()
{
    for(new i; i < GateCount; i++) if(Gates[i][gObjectID]) DestroyDynamicObject(Gates[i][gObjectID]);
    GateCount = 0;
    return 1;
}

stock ER_CreateGateObject(idx)
{
    Gates[idx][gObjectID] = CreateDynamicObject(Gates[idx][gModel], Gates[idx][gClosedX], Gates[idx][gClosedY], Gates[idx][gClosedZ], Gates[idx][gClosedRX], Gates[idx][gClosedRY], Gates[idx][gClosedRZ], Gates[idx][gVW], Gates[idx][gInt]);
    Gates[idx][gOpen] = 0;
    return 1;
}


stock ER_LoadGateRowFromCache(row, idx)
{
    cache_get_value_name_int(row,"id",Gates[idx][gSQLID]);
    cache_get_value_name(row,"name",Gates[idx][gName],64);
    cache_get_value_name_int(row,"model",Gates[idx][gModel]);
    cache_get_value_name_float(row,"closed_x",Gates[idx][gClosedX]); cache_get_value_name_float(row,"closed_y",Gates[idx][gClosedY]); cache_get_value_name_float(row,"closed_z",Gates[idx][gClosedZ]);
    cache_get_value_name_float(row,"closed_rx",Gates[idx][gClosedRX]); cache_get_value_name_float(row,"closed_ry",Gates[idx][gClosedRY]); cache_get_value_name_float(row,"closed_rz",Gates[idx][gClosedRZ]);
    cache_get_value_name_float(row,"open_x",Gates[idx][gOpenX]); cache_get_value_name_float(row,"open_y",Gates[idx][gOpenY]); cache_get_value_name_float(row,"open_z",Gates[idx][gOpenZ]);
    cache_get_value_name_float(row,"open_rx",Gates[idx][gOpenRX]); cache_get_value_name_float(row,"open_ry",Gates[idx][gOpenRY]); cache_get_value_name_float(row,"open_rz",Gates[idx][gOpenRZ]);
    cache_get_value_name_int(row,"vw",Gates[idx][gVW]); cache_get_value_name_int(row,"interior",Gates[idx][gInt]);
    cache_get_value_name_int(row,"owner_type",Gates[idx][gOwnerType]); cache_get_value_name_int(row,"owner_id",Gates[idx][gOwnerID]); cache_get_value_name_int(row,"rank",Gates[idx][gRank]);
    cache_get_value_name_float(row,"move_speed",Gates[idx][gMoveSpeed]); cache_get_value_name_float(row,"range",Gates[idx][gRange]);
    if(Gates[idx][gMoveSpeed] <= 0.0) Gates[idx][gMoveSpeed] = 2.5;
    if(Gates[idx][gRange] <= 0.0) Gates[idx][gRange] = 8.0;
    cache_get_value_name_int(row,"enabled",Gates[idx][gEnabled]);
    return 1;
}

stock ER_DestroyGateSlot(idx)
{
    if(idx < 0 || idx >= MAX_GATES) return 0;
    if(Gates[idx][gObjectID]) DestroyDynamicObject(Gates[idx][gObjectID]);
    Gates[idx][gObjectID] = 0;
    return 1;
}

stock ER_RemoveGateSlot(idx)
{
    if(idx < 0 || idx >= GateCount) return 0;
    ER_DestroyGateSlot(idx);
    Gates[idx][gEnabled] = 0;
    Gates[idx][gSQLID] = 0;
    return 1;
}

stock ER_ReloadGateBySQLID(sqlid, playerid = INVALID_PLAYER_ID)
{
    new q[128]; mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `gates` WHERE `id`=%d LIMIT 1", sqlid);
    mysql_tquery(MainPipeline, q, "ER_OnSingleGateReload", "ii", sqlid, playerid);
    return 1;
}

forward ER_OnSingleGateReload(sqlid, playerid);
public ER_OnSingleGateReload(sqlid, playerid)
{
    new rows; cache_get_row_count(rows);
    new idx = ER_FindGateIndexBySQLID(sqlid);
    if(!rows)
    {
        if(idx != -1) ER_RemoveGateSlot(idx);
        if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "Gate reloaded: not found or removed.");
        return 1;
    }
    if(idx == -1)
    {
        if(GateCount >= MAX_GATES) return 0;
        idx = GateCount++;
    }
    else ER_DestroyGateSlot(idx);
    ER_LoadGateRowFromCache(0, idx);
    if(Gates[idx][gEnabled]) ER_CreateGateObject(idx);
    if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, "Gate reloaded.");
    return 1;
}

stock ER_LoadGates()
{
    ER_ClearGates();
    mysql_tquery(MainPipeline, "SELECT * FROM `gates` WHERE `enabled`=1 ORDER BY `id` ASC", "ER_OnGatesLoad");
    return 1;
}

forward ER_OnGatesLoad();
public ER_OnGatesLoad()
{
    new rows; cache_get_row_count(rows);
    for(new r; r < rows && GateCount < MAX_GATES; r++)
    {
        cache_get_value_name_int(r,"id",Gates[GateCount][gSQLID]);
        cache_get_value_name(r,"name",Gates[GateCount][gName],64);
        cache_get_value_name_int(r,"model",Gates[GateCount][gModel]);
        cache_get_value_name_float(r,"closed_x",Gates[GateCount][gClosedX]); cache_get_value_name_float(r,"closed_y",Gates[GateCount][gClosedY]); cache_get_value_name_float(r,"closed_z",Gates[GateCount][gClosedZ]);
        cache_get_value_name_float(r,"closed_rx",Gates[GateCount][gClosedRX]); cache_get_value_name_float(r,"closed_ry",Gates[GateCount][gClosedRY]); cache_get_value_name_float(r,"closed_rz",Gates[GateCount][gClosedRZ]);
        cache_get_value_name_float(r,"open_x",Gates[GateCount][gOpenX]); cache_get_value_name_float(r,"open_y",Gates[GateCount][gOpenY]); cache_get_value_name_float(r,"open_z",Gates[GateCount][gOpenZ]);
        cache_get_value_name_float(r,"open_rx",Gates[GateCount][gOpenRX]); cache_get_value_name_float(r,"open_ry",Gates[GateCount][gOpenRY]); cache_get_value_name_float(r,"open_rz",Gates[GateCount][gOpenRZ]);
        cache_get_value_name_int(r,"vw",Gates[GateCount][gVW]); cache_get_value_name_int(r,"interior",Gates[GateCount][gInt]);
        cache_get_value_name_int(r,"owner_type",Gates[GateCount][gOwnerType]); cache_get_value_name_int(r,"owner_id",Gates[GateCount][gOwnerID]); cache_get_value_name_int(r,"rank",Gates[GateCount][gRank]);
        cache_get_value_name_float(r,"move_speed",Gates[GateCount][gMoveSpeed]); cache_get_value_name_float(r,"range",Gates[GateCount][gRange]);
        if(Gates[GateCount][gMoveSpeed] <= 0.0) Gates[GateCount][gMoveSpeed] = 2.5;
        if(Gates[GateCount][gRange] <= 0.0) Gates[GateCount][gRange] = 8.0;
        cache_get_value_name_int(r,"enabled",Gates[GateCount][gEnabled]);
        ER_CreateGateObject(GateCount); GateCount++;
    }
    printf("[Gates] Loaded %d gates.", GateCount);
    return 1;
}

stock ER_FindGateIndexBySQLID(sqlid)
{
    for(new i; i < GateCount; i++) if(Gates[i][gSQLID] == sqlid) return i;
    return -1;
}

stock ER_PlayerCanUseGate(playerid, idx)
{
    if(ER_IsAdmin(playerid, ADMIN_MOD)) return 1;
    switch(Gates[idx][gOwnerType])
    {
        case 0: return 1;
        case 1: return PlayerInfo[playerid][pID] == Gates[idx][gOwnerID];
        case 2: return PlayerInfo[playerid][pFamily] == Gates[idx][gOwnerID] && PlayerInfo[playerid][pFamilyRank] >= Gates[idx][gRank];
        case 3: return PlayerInfo[playerid][pFaction] == Gates[idx][gOwnerID] && PlayerInfo[playerid][pFactionRank] >= Gates[idx][gRank];
    }
    return 0;
}

stock ER_GetNearestGate(playerid)
{
    new vw=GetPlayerVirtualWorld(playerid), interior=GetPlayerInterior(playerid);
    for(new i; i < GateCount; i++)
    {
        if(!Gates[i][gEnabled]) continue;
        new Float:range = Gates[i][gRange] > 0.0 ? Gates[i][gRange] : 8.0;
        if(vw == Gates[i][gVW] && interior == Gates[i][gInt] && (IsPlayerInRangeOfPoint(playerid, range, Gates[i][gClosedX], Gates[i][gClosedY], Gates[i][gClosedZ]) || IsPlayerInRangeOfPoint(playerid, range, Gates[i][gOpenX], Gates[i][gOpenY], Gates[i][gOpenZ]))) return i;
    }
    return -1;
}

stock ER_ToggleGate(playerid, idx)
{
    if(idx < 0 || idx >= GateCount) return 0;
    if(!ER_PlayerCanUseGate(playerid, idx)) return ER_Send(playerid, COLOR_GREY, "You do not have access to this gate.");
    new Float:speed = Gates[idx][gMoveSpeed] > 0.0 ? Gates[idx][gMoveSpeed] : 2.5;
    if(Gates[idx][gOpen]) MoveDynamicObject(Gates[idx][gObjectID], Gates[idx][gClosedX], Gates[idx][gClosedY], Gates[idx][gClosedZ], speed, Gates[idx][gClosedRX], Gates[idx][gClosedRY], Gates[idx][gClosedRZ]);
    else MoveDynamicObject(Gates[idx][gObjectID], Gates[idx][gOpenX], Gates[idx][gOpenY], Gates[idx][gOpenZ], speed, Gates[idx][gOpenRX], Gates[idx][gOpenRY], Gates[idx][gOpenRZ]);
    Gates[idx][gOpen] = !Gates[idx][gOpen];
    return 1;
}

stock ER_ToggleNearbyGates(playerid)
{
    new vw = GetPlayerVirtualWorld(playerid), interior = GetPlayerInterior(playerid), count;
    for(new i; i < GateCount; i++)
    {
        if(!Gates[i][gEnabled]) continue;
        new Float:range = Gates[i][gRange] > 0.0 ? Gates[i][gRange] : 8.0;
        if(vw != Gates[i][gVW] || interior != Gates[i][gInt]) continue;
        if(IsPlayerInRangeOfPoint(playerid, range, Gates[i][gClosedX], Gates[i][gClosedY], Gates[i][gClosedZ]) || IsPlayerInRangeOfPoint(playerid, range, Gates[i][gOpenX], Gates[i][gOpenY], Gates[i][gOpenZ]))
        {
            if(ER_PlayerCanUseGate(playerid, i))
            {
                ER_ToggleGate(playerid, i);
                count++;
            }
        }
    }
    if(!count) return ER_Send(playerid, COLOR_GREY, "No gate found."), 1;
    return 1;
}

CMD:gate(playerid, params[])
{
    new id;
    if(sscanf(params, "D(0)", id) || id == 0) return ER_ToggleNearbyGates(playerid);
    new idx = ER_FindGateIndexBySQLID(id);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "No gate found.");
    return ER_ToggleGate(playerid, idx);
}

CMD:creategate(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new model, name[64]; if(sscanf(params, "dS(Gate)[64]", model, name)) return ER_Send(playerid, COLOR_GREY, "USAGE: /creategate [modelid] [name]");
    new Float:x,Float:y,Float:z,Float:a,q[768]; GetPlayerPos(playerid,x,y,z); GetPlayerFacingAngle(playerid,a);
    mysql_format(MainPipeline,q,sizeof(q),"INSERT INTO `gates` (`name`,`model`,`closed_x`,`closed_y`,`closed_z`,`closed_rx`,`closed_ry`,`closed_rz`,`open_x`,`open_y`,`open_z`,`open_rx`,`open_ry`,`open_rz`,`vw`,`interior`,`owner_type`,`owner_id`,`rank`,`move_speed`,`range`,`enabled`) VALUES ('%e',%d,%f,%f,%f,0.0,0.0,%f,%f,%f,%f,0.0,0.0,%f,%d,%d,0,0,0,2.5,8.0,1)",name,model,x,y,z,a,x,y,z+4.0,a,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid));
    mysql_tquery(MainPipeline,q,"ER_OnGateCreated","i",playerid); return 1;
}
forward ER_OnGateCreated(playerid);
public ER_OnGateCreated(playerid)
{
    new id=cache_insert_id(),msg[96]; ER_ReloadGateBySQLID(id, playerid); format(msg,sizeof(msg),"Gate created with ID %d. Use /editgate %d.",id,id); return ER_Send(playerid,COLOR_GREEN,msg);
}


stock ER_ShowGateEditor(playerid, id)
{
    new idx=ER_FindGateIndexBySQLID(id);
    if(idx==-1) return ER_Send(playerid,COLOR_GREY,"Invalid gate ID.");
    SetPVarInt(playerid,"EditingGate",id);
    new menu[512], Float:moveSpeed = Gates[idx][gMoveSpeed], Float:gateRange = Gates[idx][gRange];
    if(moveSpeed <= 0.0) moveSpeed = 2.5;
    if(gateRange <= 0.0) gateRange = 8.0;
    format(menu, sizeof(menu), "Goto Gate\nEdit Model ID: %d\nSet Closed Position Here\nSet Open Position Here\nEdit Closed Position Tool\nEdit Open Position Tool\nOpen = Closed Position\nClosed = Open Position\nSet Owner Type: %d\nSet Owner ID: %d\nSet Rank: %d\nMoveSpeed: %.2f\nRange: %.2f\nToggle Gate\nDelete Gate", Gates[idx][gModel], Gates[idx][gOwnerType], Gates[idx][gOwnerID], Gates[idx][gRank], moveSpeed, gateRange);
    return ShowPlayerDialog(playerid,DIALOG_GATE_EDITOR,DIALOG_STYLE_LIST,"Gate Editor",menu,"Select","Close");
}

stock ER_DeleteGateByID(playerid, id)
{
    new q[128]; mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gates` SET `enabled`=0 WHERE `id`=%d",id); mysql_tquery(MainPipeline,q); ER_ReloadGateBySQLID(id, playerid); return ER_Send(playerid,COLOR_GREEN,"Gate deleted/disabled.");
}

stock ER_SaveGateAndReload(playerid, const message[])
{
    new reloadGateId = GetPVarInt(playerid, "EditingGate");
    if(reloadGateId > 0) ER_ReloadGateBySQLID(reloadGateId, playerid);
    else ER_LoadGates();
    if(playerid != INVALID_PLAYER_ID && IsPlayerConnected(playerid)) ER_Send(playerid, COLOR_GREEN, message);
    return 1;
}

forward ER_OnGateSettingSaved(playerid);
public ER_OnGateSettingSaved(playerid)
{
    return ER_SaveGateAndReload(playerid, "Gate setting updated.");
}

forward ER_OnGateOpenEqualsClosed(playerid);
public ER_OnGateOpenEqualsClosed(playerid)
{
    return ER_SaveGateAndReload(playerid, "Gate open position copied from closed position.");
}

forward ER_OnGateClosedEqualsOpen(playerid);
public ER_OnGateClosedEqualsOpen(playerid)
{
    return ER_SaveGateAndReload(playerid, "Gate closed position copied from open position.");
}

forward ER_OnGatePosSaved(playerid, mode);
public ER_OnGatePosSaved(playerid, mode)
{
    if(mode == 1) return ER_SaveGateAndReload(playerid, "Gate closed position saved. Open position was not changed.");
    return ER_SaveGateAndReload(playerid, "Gate open position saved. Closed position was not changed.");
}

CMD:editgates(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new list[4096], line[128]; for(new i; i < GateCount; i++){format(line,sizeof(line),"%d - %s - Model %d\n",Gates[i][gSQLID],Gates[i][gName],Gates[i][gModel]); strcat(list,line,sizeof(list));}
    if(!list[0]) format(list,sizeof(list),"No gates created."); return ShowPlayerDialog(playerid,DIALOG_GATE_LIST,DIALOG_STYLE_LIST,"Gates",list,"Edit","Close");
}
CMD:editgate(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new id; if(sscanf(params,"d",id)) return ER_Send(playerid,COLOR_GREY,"USAGE: /editgate [id]");
    return ER_ShowGateEditor(playerid, id);
}
CMD:deletegate(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return ER_Send(playerid, COLOR_GREY, "You are not authorized.");
    new id; if(sscanf(params,"d",id)) return ER_Send(playerid,COLOR_GREY,"USAGE: /deletegate [id]");
    return ER_DeleteGateByID(playerid, id);
}

stock ER_GateDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_GATE_LIST)
    {
        if(!response) return 1; if(listitem < 0 || listitem >= GateCount) return 1; return ER_ShowGateEditor(playerid, Gates[listitem][gSQLID]);
    }
    if(dialogid == DIALOG_GATE_EDITOR)
    {
        if(!response) return 1; new id=GetPVarInt(playerid,"EditingGate"), idx=ER_FindGateIndexBySQLID(id); if(idx==-1) return 1; new q[512], Float:x,Float:y,Float:z,Float:a;
        SetPVarInt(playerid,"GateEditAction",listitem);
        if(listitem==0){SetPlayerVirtualWorld(playerid,Gates[idx][gVW]);SetPlayerInterior(playerid,Gates[idx][gInt]);SetPlayerPos(playerid,Gates[idx][gClosedX],Gates[idx][gClosedY],Gates[idx][gClosedZ]+1.0);return 1;}
        if(listitem==1){return ShowPlayerDialog(playerid,DIALOG_GATE_INPUT,DIALOG_STYLE_INPUT,"Gate Model ID","Enter the new dynamic object model ID:","Save","Back");}
        if(listitem==2){GetPlayerPos(playerid,x,y,z);GetPlayerFacingAngle(playerid,a);mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gates` SET `closed_x`=%f,`closed_y`=%f,`closed_z`=%f,`closed_rz`=%f,`vw`=%d,`interior`=%d WHERE `id`=%d",x,y,z,a,GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid),id);mysql_tquery(MainPipeline,q,"ER_OnGatePosSaved","ii",playerid,1);return 1;}
        if(listitem==3){GetPlayerPos(playerid,x,y,z);GetPlayerFacingAngle(playerid,a);mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gates` SET `open_x`=%f,`open_y`=%f,`open_z`=%f,`open_rz`=%f WHERE `id`=%d",x,y,z,a,id);mysql_tquery(MainPipeline,q,"ER_OnGatePosSaved","ii",playerid,2);return 1;}
        if(listitem==4 || listitem==5)
        {
            // Edit the real gate object like the ATM editor, but do NOT teleport the admin.
            // The selected mode only controls which SQL columns are saved when the editor Save button is clicked.
            SetPVarInt(playerid,"GateEditMode",listitem==4?1:2);
            SetPVarInt(playerid,"GateEditObject",Gates[idx][gObjectID]);

            if(listitem==4)
            {
                SetDynamicObjectPos(Gates[idx][gObjectID], Gates[idx][gClosedX], Gates[idx][gClosedY], Gates[idx][gClosedZ]);
                SetDynamicObjectRot(Gates[idx][gObjectID], Gates[idx][gClosedRX], Gates[idx][gClosedRY], Gates[idx][gClosedRZ]);
                Streamer_UpdateEx(playerid, Gates[idx][gClosedX], Gates[idx][gClosedY], Gates[idx][gClosedZ]);
                ER_Send(playerid, COLOR_YELLOW, "Editing gate CLOSED position. Move the object and click the editor save icon.");
            }
            else
            {
                SetDynamicObjectPos(Gates[idx][gObjectID], Gates[idx][gOpenX], Gates[idx][gOpenY], Gates[idx][gOpenZ]);
                SetDynamicObjectRot(Gates[idx][gObjectID], Gates[idx][gOpenRX], Gates[idx][gOpenRY], Gates[idx][gOpenRZ]);
                Streamer_UpdateEx(playerid, Gates[idx][gOpenX], Gates[idx][gOpenY], Gates[idx][gOpenZ]);
                ER_Send(playerid, COLOR_YELLOW, "Editing gate OPEN position. Move the object and click the editor save icon.");
            }
            EditDynamicObject(playerid, Gates[idx][gObjectID]);
            return 1;
        }
        if(listitem==6)
        {
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `gates` SET `open_x`=%f,`open_y`=%f,`open_z`=%f,`open_rx`=%f,`open_ry`=%f,`open_rz`=%f WHERE `id`=%d", Gates[idx][gClosedX], Gates[idx][gClosedY], Gates[idx][gClosedZ], Gates[idx][gClosedRX], Gates[idx][gClosedRY], Gates[idx][gClosedRZ], id);
            mysql_tquery(MainPipeline, q, "ER_OnGateOpenEqualsClosed", "i", playerid);
            Gates[idx][gOpenX] = Gates[idx][gClosedX];
            Gates[idx][gOpenY] = Gates[idx][gClosedY];
            Gates[idx][gOpenZ] = Gates[idx][gClosedZ];
            Gates[idx][gOpenRX] = Gates[idx][gClosedRX];
            Gates[idx][gOpenRY] = Gates[idx][gClosedRY];
            Gates[idx][gOpenRZ] = Gates[idx][gClosedRZ];
            Gates[idx][gOpen] = 0;
            SetDynamicObjectPos(Gates[idx][gObjectID], Gates[idx][gClosedX], Gates[idx][gClosedY], Gates[idx][gClosedZ]);
            SetDynamicObjectRot(Gates[idx][gObjectID], Gates[idx][gClosedRX], Gates[idx][gClosedRY], Gates[idx][gClosedRZ]);
            return 1;
        }
        if(listitem==7)
        {
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `gates` SET `closed_x`=%f,`closed_y`=%f,`closed_z`=%f,`closed_rx`=%f,`closed_ry`=%f,`closed_rz`=%f WHERE `id`=%d", Gates[idx][gOpenX], Gates[idx][gOpenY], Gates[idx][gOpenZ], Gates[idx][gOpenRX], Gates[idx][gOpenRY], Gates[idx][gOpenRZ], id);
            mysql_tquery(MainPipeline, q, "ER_OnGateClosedEqualsOpen", "i", playerid);
            Gates[idx][gClosedX] = Gates[idx][gOpenX];
            Gates[idx][gClosedY] = Gates[idx][gOpenY];
            Gates[idx][gClosedZ] = Gates[idx][gOpenZ];
            Gates[idx][gClosedRX] = Gates[idx][gOpenRX];
            Gates[idx][gClosedRY] = Gates[idx][gOpenRY];
            Gates[idx][gClosedRZ] = Gates[idx][gOpenRZ];
            Gates[idx][gOpen] = 1;
            SetDynamicObjectPos(Gates[idx][gObjectID], Gates[idx][gOpenX], Gates[idx][gOpenY], Gates[idx][gOpenZ]);
            SetDynamicObjectRot(Gates[idx][gObjectID], Gates[idx][gOpenRX], Gates[idx][gOpenRY], Gates[idx][gOpenRZ]);
            return 1;
        }
        if(listitem>=8 && listitem<=12) return ShowPlayerDialog(playerid,DIALOG_GATE_INPUT,DIALOG_STYLE_INPUT,"Gate Setting","Enter value:","Save","Back");
        if(listitem==13) return ER_ToggleGate(playerid,idx);
        if(listitem==14) return ShowPlayerDialog(playerid,DIALOG_GATE_DELETE_CONFIRM,DIALOG_STYLE_MSGBOX,"Delete Gate","Delete/disable this gate?","Delete","Cancel");
        return 1;
    }
    if(dialogid == DIALOG_GATE_INPUT)
    {
        if(!response) return ER_ShowGateEditor(playerid, GetPVarInt(playerid,"EditingGate"));
        new id=GetPVarInt(playerid,"EditingGate"), action=GetPVarInt(playerid,"GateEditAction"), q[180], val=strval(inputtext);
        new Float:fval = floatstr(inputtext);
        if(action==1)
        {
            if(val <= 0) return ER_Send(playerid, COLOR_GREY, "Invalid model ID.");
            mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gates` SET `model`=%d WHERE `id`=%d",val,id);
        }
        else if(action==8) mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gates` SET `owner_type`=%d WHERE `id`=%d",val,id);
        else if(action==9) mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gates` SET `owner_id`=%d WHERE `id`=%d",val,id);
        else if(action==10) mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gates` SET `rank`=%d WHERE `id`=%d",val,id);
        else if(action==11)
        {
            if(fval <= 0.0) return ER_Send(playerid, COLOR_GREY, "Invalid move speed.");
            mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gates` SET `move_speed`=%f WHERE `id`=%d",fval,id);
        }
        else if(action==12)
        {
            if(fval <= 0.0) return ER_Send(playerid, COLOR_GREY, "Invalid range.");
            mysql_format(MainPipeline,q,sizeof(q),"UPDATE `gates` SET `range`=%f WHERE `id`=%d",fval,id);
        }
        else return 1;
        mysql_tquery(MainPipeline,q,"ER_OnGateSettingSaved","i",playerid); return 1;
    }
    if(dialogid == DIALOG_GATE_DELETE_CONFIRM)
    {
        if(!response) return 1; return ER_DeleteGateByID(playerid, GetPVarInt(playerid,"EditingGate"));
    }
    return 0;
}

stock ER_OnGateObjectEdited(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    new id = GetPVarInt(playerid, "EditingGate");
    new mode = GetPVarInt(playerid, "GateEditMode");
    new editobject = GetPVarInt(playerid, "GateEditObject");
    new idx = ER_FindGateIndexBySQLID(id);

    if(idx == -1 || mode == 0 || editobject == 0 || objectid != editobject) return 0;

    if(response == EDIT_RESPONSE_UPDATE) return 1;

    if(response == EDIT_RESPONSE_FINAL)
    {
        new q[384];
        if(mode == 1)
        {
            Gates[idx][gClosedX] = x; Gates[idx][gClosedY] = y; Gates[idx][gClosedZ] = z;
            Gates[idx][gClosedRX] = rx; Gates[idx][gClosedRY] = ry; Gates[idx][gClosedRZ] = rz;
            Gates[idx][gVW] = GetPlayerVirtualWorld(playerid);
            Gates[idx][gInt] = GetPlayerInterior(playerid);
            Gates[idx][gOpen] = 0;
            SetDynamicObjectPos(Gates[idx][gObjectID], x, y, z);
            SetDynamicObjectRot(Gates[idx][gObjectID], rx, ry, rz);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `gates` SET `closed_x`=%f,`closed_y`=%f,`closed_z`=%f,`closed_rx`=%f,`closed_ry`=%f,`closed_rz`=%f,`vw`=%d,`interior`=%d WHERE `id`=%d", x, y, z, rx, ry, rz, Gates[idx][gVW], Gates[idx][gInt], id);
            mysql_tquery(MainPipeline, q, "ER_OnGatePosSaved", "ii", playerid, 1);
            DeletePVar(playerid, "GateEditMode");
            DeletePVar(playerid, "GateEditObject");
            return 1;
        }
        else
        {
            Gates[idx][gOpenX] = x; Gates[idx][gOpenY] = y; Gates[idx][gOpenZ] = z;
            Gates[idx][gOpenRX] = rx; Gates[idx][gOpenRY] = ry; Gates[idx][gOpenRZ] = rz;
            Gates[idx][gOpen] = 1;
            SetDynamicObjectPos(Gates[idx][gObjectID], x, y, z);
            SetDynamicObjectRot(Gates[idx][gObjectID], rx, ry, rz);
            mysql_format(MainPipeline, q, sizeof(q), "UPDATE `gates` SET `open_x`=%f,`open_y`=%f,`open_z`=%f,`open_rx`=%f,`open_ry`=%f,`open_rz`=%f WHERE `id`=%d", x, y, z, rx, ry, rz, id);
            mysql_tquery(MainPipeline, q, "ER_OnGatePosSaved", "ii", playerid, 2);
            DeletePVar(playerid, "GateEditMode");
            DeletePVar(playerid, "GateEditObject");
            return 1;
        }
    }

    DeletePVar(playerid, "GateEditMode");
    DeletePVar(playerid, "GateEditObject");
    new reloadGateId = GetPVarInt(playerid, "EditingGate");
    if(reloadGateId > 0) ER_ReloadGateBySQLID(reloadGateId, playerid);
    else ER_LoadGates();
    return 1;
}
