#if defined _ER_HELP_INCLUDED
    #endinput
#endif
#define _ER_HELP_INCLUDED

stock ER_ShowMainHelp(playerid)
{
    SendClientMessage(playerid, COLOR_HELP, "____________________ ExpressRP Help ____________________");
    SendClientMessage(playerid, COLOR_HELP, "ACCOUNT: /stats /skills /inventory /accent /togphone /number");
    SendClientMessage(playerid, COLOR_HELP, "CHAT: /me /do /s(hout) /l(ow) /b /g /newb(ie) /accent");
    SendClientMessage(playerid, COLOR_HELP, "PHONE/RADIO: /call /pickup /hangup /sms /setfreq /pr /mp3 /setstation");
    SendClientMessage(playerid, COLOR_HELP, "VEHICLES: /veh /car /vehlock /park /trackveh /vehicles /vehiclehelp");
    SendClientMessage(playerid, COLOR_HELP, "WORLD: /enter /exit /lock /buy /buybusiness /buyhouse /join /myjobs /gate");
    SendClientMessage(playerid, COLOR_HELP, "GROUPS: /familyhelp /factionhelp /jobhelp /businesshelp /househelp /points /turfs");
    return 1;
}

CMD:help(playerid, params[])
{
    #pragma unused params
    return ER_ShowMainHelp(playerid);
}
CMD:ohelp(playerid, params[])
{
    #pragma unused params
    return ER_ShowMainHelp(playerid);
}

CMD:vehiclehelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_HELP, "____________________ Vehicle Help ____________________");
    SendClientMessage(playerid, COLOR_HELP, "/veh engine /veh lights /veh hood /veh trunk /veh windows /veh lock");
    SendClientMessage(playerid, COLOR_HELP, "/park /trackveh /vehicles /skills /buy security from businesses");
    return 1;
}
alias:vehiclehelp("vehhelp")

CMD:jobhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_HELP, "____________________ Job Help ____________________");
    SendClientMessage(playerid, COLOR_HELP, "/join - join at job pickup | /myjobs - view jobs | /leavejob [slot]");
    SendClientMessage(playerid, COLOR_HELP, "Job types: Mechanic, Taxi, Trucker, Pizza, Arms, Drugs, Detective, Lawyer, Bus, Garbage, Miner, Fisher, Bodyguard, Bartender, Craftsman, Boxer.");
    SendClientMessage(playerid, COLOR_HELP, "Mechanic: /fix /nos /hyd /mechduty | Taxi: /fare /ataxi | Trucker: /loadshipment /unloadshipment /searchtruck");
    SendClientMessage(playerid, COLOR_HELP, "Arms: /sellgun /getmats | Drugs: /selldrugs /sellpot /sellcrack | Detective: /find /search");
    SendClientMessage(playerid, COLOR_HELP, "Lawyer: /lawyerduty /defend /free | Fisher: /fish /sellfish | Miner: /mine /sellore | Garbage: /collecttrash /dumptrash");
    return 1;
}

CMD:familyhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_HELP, "____________________ Family Help ____________________");
    SendClientMessage(playerid, COLOR_HELP, "/families /members /f /crew(/cr) /faminvite /famkick /crewinvite /setcrew");
    SendClientMessage(playerid, COLOR_HELP, "/safedeposit /safewithdraw /locker /motd /leavefamily /familysettings /capture /captureturf");
    return 1;
}

CMD:factionhelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_HELP, "____________________ Faction Help ____________________");
    SendClientMessage(playerid, COLOR_HELP, "/factions /members /department(/dept) /division(/div) /facinvite /fackick /divinvite /setdivision");
    SendClientMessage(playerid, COLOR_HELP, "LAW: /r /d /m /badge /su /wanted /cuff /uncuff /ticket /arrest /backup /detain /tazer /mdc");
    SendClientMessage(playerid, COLOR_HELP, "EMS: /r /d /badge /heal /revive /drag /deliverpatient /triage /emslist | NEWS: /news /live /broadcast /sanhelp");
    SendClientMessage(playerid, COLOR_HELP, "/safedeposit /safewithdraw /locker /motd /leavefaction /factionsettings /capture /captureturf /locker /cades /cones /spikes");
    return 1;
}

CMD:househelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_HELP, "____________________ House Help ____________________");
    SendClientMessage(playerid, COLOR_HELP, "/buyhouse /sellhouse /myhouses /housestorage(/hstorage) /managehouse /enter /exit /lock");
    return 1;
}

CMD:businesshelp(playerid, params[])
{
    SendClientMessage(playerid, COLOR_HELP, "____________________ Business Help ____________________");
    SendClientMessage(playerid, COLOR_HELP, "/buybusiness /sellbusiness /mybusinesses /managebusiness /businesssettings /buy");
    SendClientMessage(playerid, COLOR_HELP, "Bank: /deposit /withdraw /wire | Gas: /refuel | Dealership: enter display vehicle to buy.");
    return 1;
}

stock ER_ShowAdminHelp(playerid)
{
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return 0;
    new line[128];
    format(line, sizeof(line), "____________________ Admin Help - %s ____________________", ER_AdminLevelName(PlayerInfo[playerid][pAdmin]));
    SendClientMessage(playerid, COLOR_HELP, line);
    if(ER_IsAdmin(playerid, ADMIN_MOD))
    {
        SendClientMessage(playerid, COLOR_HELP, "MOD: /a /goto /goto ls /goto allsaints /goto countygen /gethere /gotoco /nearestobj");
        SendClientMessage(playerid, COLOR_HELP, "MOD: /sethp /setarmor /givegun /mark /gotols /gotosf /gotolv");
    }
    if(ER_IsAdmin(playerid, ADMIN_SENIOR))
    {
        SendClientMessage(playerid, COLOR_HELP, "SENIOR: /createbusiness /editbusiness /edithospitals /createhouse /edithouse /createdoor /editdoor");
        SendClientMessage(playerid, COLOR_HELP, "SENIOR: /createveh /editveh /creategate /editgate /createpoint /editpoint /createturf /editturf");
    }
    if(ER_IsAdmin(playerid, ADMIN_LEAD)) SendClientMessage(playerid, COLOR_HELP, "LEAD: /createfamily /editfamilies /createfaction /editfactions /editjobs /reload");
    if(ER_IsAdmin(playerid, ADMIN_HEAD)) SendClientMessage(playerid, COLOR_HELP, "HEAD: /createjob /deletejob /serversettings /createaudio /editaudio /setstat /osetstat");
    if(ER_IsAdmin(playerid, ADMIN_EXEC)) SendClientMessage(playerid, COLOR_HELP, "EXEC: /setadmin /setvip and all owner/server controls.");
    return 1;
}
CMD:ahelp(playerid, params[])
{
    #pragma unused params
    return ER_ShowAdminHelp(playerid);
}
CMD:oahelp(playerid, params[])
{
    #pragma unused params
    return ER_ShowAdminHelp(playerid);
}
