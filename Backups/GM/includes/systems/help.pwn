#if defined _ER_HELP_INCLUDED
    #endinput
#endif
#define _ER_HELP_INCLUDED

CMD:help(playerid, params[])
{
    SendClientMessage(playerid, COLOR_HELP, "*** ACCOUNT *** /stats /inventory /changepass /togphone /number");
    SendClientMessage(playerid, COLOR_HELP, "*** CHAT *** /s(hout) /l(ow) /b /g /newb(ie) /me /do /accent");
    SendClientMessage(playerid, COLOR_HELP, "*** PHONE/RADIO *** /call /p(ickup) /h(angup) /sms /setfreq /pr /fbackup");
    SendClientMessage(playerid, COLOR_HELP, "*** GENERAL *** /pay /give /use /tie /buy /mp3 /toys /buyinsurance /togfreehospital");
    SendClientMessage(playerid, COLOR_HELP, "*** VEHICLE *** /veh(icle) /veh(icle)lock /park /trackveh(icle) /vehicles /vehiclehelp");
    SendClientMessage(playerid, COLOR_HELP, "*** OTHER HELP *** /jobhelp /familyhelp /factionhelp /househelp /businesshelp /ahelp");
    return 1;
}

CMD:vehiclehelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_HELP, "*** VEHICLE HELP *** /veh(icle) engine /veh(icle) lights /veh(icle) hood /veh(icle) trunk /veh(icle) windows");
    SendClientMessage(playerid, COLOR_HELP, "*** VEHICLE HELP *** /veh(icle)lock /park /trackveh(icle) /vehicles");
    return 1;
}
alias:vehiclehelp("vehhelp")

CMD:jobhelp(playerid, params[]) { return ER_Send(playerid, COLOR_HELP, "Job help placeholder. Job commands will be listed here later."); }
CMD:familyhelp(playerid, params[]) { return ER_Send(playerid, COLOR_HELP, "Family help placeholder. Family commands will be listed here later."); }
CMD:factionhelp(playerid, params[]) { return ER_Send(playerid, COLOR_HELP, "Faction help placeholder. Faction commands will be listed here later."); }
CMD:househelp(playerid, params[]) { SendClientMessage(playerid, COLOR_HELP, "*** HOUSE HELP *** /buyhouse /sellhouse /myhouses /housestorage(/hstorage) /enter /exit /lock"); return 1; }
CMD:businesshelp(playerid, params[]) { SendClientMessage(playerid, COLOR_HELP, "*** BUSINESS HELP *** /buy /buybusiness /sellbusiness /mybusinesses /businesssettings /enter /exit"); return 1; }

CMD:ahelp(playerid, params[])
{
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return 0;

    SendClientMessage(playerid, COLOR_HELP, "*** ADMIN LEVELS *** 1 Moderator | 2 Junior Admin | 4 Senior Admin | 5 Lead Admin | 1337 Head Admin | 99999 Executive");

    if(ER_IsAdmin(playerid, ADMIN_MOD))
    {
        SendClientMessage(playerid, COLOR_HELP, "*** MODERATOR *** /a /goto /gethere");
        SendClientMessage(playerid, COLOR_HELP, "*** GENERAL *** /kick /reports /check /spec placeholders");
        SendClientMessage(playerid, COLOR_HELP, "*** VEHICLE SYSTEM *** /aveh [model/name] [c1] [c2] /allvehicles");
    }
    if(ER_IsAdmin(playerid, ADMIN_JUNIOR))
    {
        SendClientMessage(playerid, COLOR_HELP, "*** JUNIOR ADMIN *** /createpveh /trackveh /vehicles");
        SendClientMessage(playerid, COLOR_HELP, "*** HOSPITAL SYSTEM *** /edithospitals /edithospital");
    }
    if(ER_IsAdmin(playerid, ADMIN_SENIOR))
    {
        SendClientMessage(playerid, COLOR_HELP, "*** SENIOR ADMIN *** /createhospital /createbusiness [type/id] /editbusinesses /editbusiness");
        SendClientMessage(playerid, COLOR_HELP, "*** BUSINESS SYSTEM *** /createbusiness [type/id] /editbusinesses /editbusiness");
    }
    if(ER_IsAdmin(playerid, ADMIN_LEAD))
    {
        SendClientMessage(playerid, COLOR_HELP, "*** LEAD ADMIN *** /createfamily /editfamilies /editfamily");
        SendClientMessage(playerid, COLOR_HELP, "*** FAMILY SYSTEM *** /createfamily /editfamilies /editfamily");
        SendClientMessage(playerid, COLOR_HELP, "*** FACTION SYSTEM *** /createfaction /editfactions /editfaction");
        SendClientMessage(playerid, COLOR_HELP, "*** HOUSE SYSTEM *** /createhouse /edithouse /createdoor /editdoor /reload /serversettings");
    }
    if(ER_IsAdmin(playerid, ADMIN_HEAD))
    {
        SendClientMessage(playerid, COLOR_HELP, "*** HEAD ADMIN *** /createvehicle /editvehicles /editvehicle /deletevehicle /createaudio");
        SendClientMessage(playerid, COLOR_HELP, "*** JOB SYSTEM *** placeholder");
    }
    if(ER_IsAdmin(playerid, ADMIN_EXEC))
    {
        SendClientMessage(playerid, COLOR_HELP, "*** EXECUTIVE ADMIN *** /setadmin /setvip /osetstat");
    }
    return 1;
}
