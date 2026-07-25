#include <a_samp>

#define TEST_NPC_MODE "blanknpc"
#define TEST_NPC_BASE_NAME "Test_NPC"
#define TEST_NPC_SKIN 60

new g_TestNPCCount;

public OnFilterScriptInit()
{
    print("[TestNPC] Filterscript loaded. Use /spawnnpc.");
    return 1;
}

public OnFilterScriptExit()
{
    print("[TestNPC] Filterscript unloaded.");
    return 1;
}

stock SpawnTestNPCNearPlayer(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;

    new npcName[MAX_PLAYER_NAME];

    g_TestNPCCount++;

    if(g_TestNPCCount == 1)
        format(npcName, sizeof(npcName), TEST_NPC_BASE_NAME);
    else
        format(npcName, sizeof(npcName), TEST_NPC_BASE_NAME "_%d", g_TestNPCCount);

    new npcMode[] = TEST_NPC_MODE;
    ConnectNPC(npcName, npcMode);

    new msg[96];
    format(msg, sizeof(msg), "[TestNPC] Connecting NPC %s. It will spawn near you after joining.", npcName);
    SendClientMessage(playerid, 0x33AA33FF, msg);

    return 1;
}

public OnPlayerConnect(playerid)
{
    if(IsPlayerNPC(playerid))
    {
        SetSpawnInfo(playerid, 0, TEST_NPC_SKIN, 0.0, 0.0, 3.0, 0.0, 0, 0, 0, 0, 0, 0);
        SpawnPlayer(playerid);
    }
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(IsPlayerNPC(playerid))
    {
        new pname[MAX_PLAYER_NAME];
        GetPlayerName(playerid, pname, sizeof(pname));

        if(!strcmp(pname, TEST_NPC_BASE_NAME, true, strlen(TEST_NPC_BASE_NAME)))
        {
            new nearestPlayer = INVALID_PLAYER_ID;
            new Float:px, Float:py, Float:pz;

            for(new i = 0; i < MAX_PLAYERS; i++)
            {
                if(IsPlayerConnected(i) && !IsPlayerNPC(i))
                {
                    nearestPlayer = i;
                    break;
                }
            }

            if(nearestPlayer != INVALID_PLAYER_ID)
            {
                GetPlayerPos(nearestPlayer, px, py, pz);
                SetPlayerPos(playerid, px + 2.0, py, pz);
                SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(nearestPlayer));
                SetPlayerInterior(playerid, GetPlayerInterior(nearestPlayer));
                SetPlayerFacingAngle(playerid, 0.0);
            }

            SetPlayerSkin(playerid, TEST_NPC_SKIN);
            SetPlayerHealth(playerid, 100.0);
            TogglePlayerControllable(playerid, false);
        }
    }
    return 1;
}
