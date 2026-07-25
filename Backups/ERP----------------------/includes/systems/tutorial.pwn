#if defined _ER_TUTORIAL_INCLUDED
    #endinput
#endif
#define _ER_TUTORIAL_INCLUDED

#define MAX_TUTORIAL_STEPS 6

stock ER_StartTutorial(playerid)
{
	if(!ServerCore[scTutorialEnabled])
	{
		ER_ShowCharacterCreation(playerid);
		return 1;
	}

	PlayerInfo[playerid][pTutorialStep] = 0;
	TogglePlayerSpectating(playerid, true);
	SetPlayerInterior(playerid, 0);
	SetPlayerVirtualWorld(playerid, playerid + 1);
	ER_AdvanceTutorial(playerid);
	return 1;
}

stock ER_AdvanceTutorial(playerid)
{
	switch(PlayerInfo[playerid][pTutorialStep])
	{
		case 0:
		{
			InterpolateCameraPos(playerid, 1333.5521, -1388.1493, 67.2808, 1387.4829, -923.4698, 90.6020, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1333.5950, -1387.1521, 67.3258, 1387.7191, -922.5004, 90.4920, 15000, CAMERA_MOVE);
		}
		case 1:
		{
			InterpolateCameraPos(playerid, 725.9147, -1610.8770, 3.0359, 734.8999, -1962.6320, -6.3299, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 725.9500, -1611.8734, 3.0057, 734.9311, -1963.6292, -6.5201, 15000, CAMERA_MOVE);
		}
		case 2:
		{
			InterpolateCameraPos(playerid, 1104.7491, -1401.8911, 14.6202, 1145.8008, -1471.2203, 27.1695, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1105.5040, -1402.5443, 14.5450, 1145.2341, -1470.3988, 26.7043, 15000, CAMERA_MOVE);
		}
		case 3:
		{
			InterpolateCameraPos(playerid, 1517.0358, -1616.2576, 17.8788, 1520.4496, -1715.3738, 18.1261, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1517.4991, -1617.1411, 17.8737, 1521.0973, -1714.6147, 18.0459, 15000, CAMERA_MOVE);
		}
		case 4:
		{
			InterpolateCameraPos(playerid, 938.9750, -1324.3108, 14.0205, 1039.5808, -1324.3224, 14.4793, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 939.9739, -1324.3015, 14.0254, 1040.5797, -1324.3134, 14.4891, 15000, CAMERA_MOVE);
		}
		default:
		{
			InterpolateCameraPos(playerid, 1569.0149, -1812.5513, 16.1676, 1568.5962, -1889.8837, 13.8242, 15000, CAMERA_MOVE);
			InterpolateCameraLookAt(playerid, 1569.0370, -1813.5509, 16.1273, 1568.5488, -1890.8818, 13.7888, 15000, CAMERA_MOVE);
		}
	}
	ER_ShowTutorialStep(playerid);
	return 1;
}

stock ER_ShowTutorialStep(playerid)
{
	new s[2000], website[96], discord[96];

	if(ServerCore[scWebsite][0]) format(website, sizeof(website), "%s", ServerCore[scWebsite]);
	else format(website, sizeof(website), "Not set");
	if(ServerCore[scDiscord][0]) format(discord, sizeof(discord), "%s", ServerCore[scDiscord]);
	else format(discord, sizeof(discord), "Not set");

	switch(PlayerInfo[playerid][pTutorialStep])
	{
		case 0:
		{
			format(s, sizeof(s), "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n{7091B8}Welcome to Express Roleplay - Gaming!{FFFFFF}\n\nWe are an English speaking community. At ExpressRP, we specialize in Roleplay, the act of taking on the role of a character and acting as that character as you would in real life. Along the way your character learns new information and allows them to develop.\n\n{FF0000}ExpressRP Related Services{FFFFFF}:\n\t{F69500}Website{FFFFFF}: %s - Sign up on our forums and interact with the community!\n\t{F69500}Discord{FFFFFF}: %s - Connect and speak to different members of the community!\n\nPlease make sure you read this tutorial. You may press Skip if you already understand the basics.\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________", website, discord);
			ShowPlayerDialog(playerid, DIALOG_TUT_STEP, DIALOG_STYLE_MSGBOX, "ExpressRP Tutorial - Welcome", s, "Continue", "Skip");
		}
		case 1:
		{
			format(s, sizeof(s), "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n{F69500}Roleplay{FFFFFF}\n\nIn order to roleplay, you should create a character. Every character should have a story, every character needs a story! Who are they? Where do they come from? Why are they in San Andreas? That's all up to you!\n\nBut first you should get to know some of the terminology we use at Express Roleplay.\n\n\t{FF0000}In Character (IC){FFFFFF}: Anything that constitutes your character, or involves them. This is accompanied by the in-game text chat, radios, cell phones, etc.\n\t\tExample: Your character is talking to another character. You might say \"Hi, what's your name?\" This conversation is in character.\n\n\t{FF0000}Out Of Character (OOC){FFFFFF}: This is you speaking, not your character! Anything that has to do with you personally is considered out of character.\n\tCharacter should always be present with OOC brackets, in other words: (( This chat is now OOC because of the double parenthesis )).\n\n\t{FF0000}/me [action]{FFFFFF} - This allows your character to perform an action or statement.\n\t{FF0000}/do [action]{FFFFFF} - This command describes an action or statement.\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialog(playerid, DIALOG_TUT_STEP, DIALOG_STYLE_MSGBOX, "ExpressRP Tutorial - Roleplay", s, "Continue", "Skip");
		}
		case 2:
		{
			format(s, sizeof(s), "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n{F69500}Rules{FFFFFF}\n\nNext, you should learn some common roleplay rules that are vital in ensuring you have the best possible experience on ExpressRP.\n\n\t{FF0000}Metagaming (MG){FFFFFF}: Mixing IC information with OOC information, or vice versa.\n\t{FF0000}Powergaming (PG){FFFFFF}: Forcing another player into roleplay, or roleplaying the impossible.\n\t{FF0000}Deathmatching (DM){FFFFFF}: Attempting to kill another player without a sufficient roleplay reason.\n\t{FF0000}Killing On Sight (KoS){FFFFFF}: Attempting to kill another player without sufficient roleplay done beforehand.\n\t{FF0000}Revenge Killing (RK){FFFFFF}: Returning to the last place you died or engaging roleplay with the person responsible for your death.\n\nPlease read these rules carefully as you may be punished if you break one!\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialog(playerid, DIALOG_TUT_STEP, DIALOG_STYLE_MSGBOX, "ExpressRP Tutorial - Rules", s, "Continue", "Skip");
		}
		case 3:
		{
			format(s, sizeof(s), "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n{F69500}Groups{FFFFFF}\n\nIt's fun to be a civilian, but it's more fun to join a group.\n\nAt Express Roleplay, we offer a diverse selection of groups that players can join. There are many different types of groups:\n\n\t{FF0000}Government{FFFFFF}: The government imposes new laws and manages the budget of San Andreas.\n\t{FF0000}Law Enforcement Agency{FFFFFF}: Police and legal agencies enforce the law.\n\t{FF0000}Medical / Fire Department{FFFFFF}: They respond to medical emergencies and rescue calls.\n\t{FF0000}Transportation{FFFFFF}: They taxi around individuals who request service.\n\t{FF0000}Criminal Families{FFFFFF}: Groups of criminals who do illegal things.\n\nSome groups allow you to apply once you meet certain requirements!\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialog(playerid, DIALOG_TUT_STEP, DIALOG_STYLE_MSGBOX, "ExpressRP Tutorial - Groups", s, "Continue", "Skip");
		}
		case 4:
		{
			format(s, sizeof(s), "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n{F69500}Property{FFFFFF}\n\nPlayers can own different property around the server, some cost more than others. Properties are meant to enhance your roleplay experience.\n\nThere are several different types of properties:\n\n\t{FF0000}Housing{FFFFFF}: Houses are located around the server.\n\t{FF0000}Businesses{FFFFFF}: Businesses allow you to purchase different things and create economy roleplay.\n\t{FF0000}Vehicles{FFFFFF}: Players may purchase vehicles from dealerships and use them when they wish.\n\t{FF0000}Hospitals{FFFFFF}: Hospitals handle death, EMS delivery, treatment fees and insurance.\n\nYou can use /help after spawning to learn the commands.\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialog(playerid, DIALOG_TUT_STEP, DIALOG_STYLE_MSGBOX, "ExpressRP Tutorial - Property", s, "Continue", "Skip");
		}
		default:
		{
			format(s, sizeof(s), "{FFFFFF}_______________________________________________________________________________________________________________________________________________________\n\n\n{F69500}Finished{FFFFFF}\n\nWe are now finished with the tutorial.\n\nYou will now create your character details. There is no quiz/test on Express Roleplay - Gaming.\n\nPress Character to continue.\n\n\n{FFFFFF}_______________________________________________________________________________________________________________________________________________________");
			ShowPlayerDialog(playerid, DIALOG_TUT_STEP, DIALOG_STYLE_MSGBOX, "ExpressRP Tutorial - Complete", s, "Character", "Skip");
		}
	}
	return 1;
}

stock ER_ShowCharacterCreation(playerid)
{
	new s[512], gender[16], accent[32];
	format(gender, sizeof(gender), PlayerInfo[playerid][pGender] == 2 ? "Female" : "Male");
	format(accent, sizeof(accent), "%s", AccentNames[PlayerInfo[playerid][pAccent]]);
	format(s, sizeof(s), "Name:\t%s\nGender:\t%s\nDate of Birth:\t%s\nCountry:\t%s\nAccent:\t%s\nComplete",
		ER_GetName(playerid), gender, PlayerInfo[playerid][pDOB], PlayerInfo[playerid][pCountry], accent);
	ShowPlayerDialog(playerid, DIALOG_CHAR_CREATE, DIALOG_STYLE_TABLIST, "ExpressRP Character Creation", s, "Select", "");
	return 1;
}

stock ER_CompleteCharacterCreation(playerid)
{
	PlayerInfo[playerid][pTutorial] = 1;

	if(PlayerInfo[playerid][pGender] == 2) PlayerInfo[playerid][pSkin] = ServerCore[scDefaultFemaleSkin];
	else PlayerInfo[playerid][pSkin] = ServerCore[scDefaultMaleSkin];

	ER_ForceDefaultSpawn(playerid);

	if(PlayerInfo[playerid][pID] > 0)
	{
		new q[512];
		mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `tutorial`=1,`age`=%d,`dob`='%e',`country`='%e',`gender`=%d,`accent`=%d,`skin`=%d,`spawn_x`=%f,`spawn_y`=%f,`spawn_z`=%f,`spawn_a`=%f,`spawn_int`=%d,`spawn_vw`=%d WHERE `id`=%d",
			PlayerInfo[playerid][pAge], PlayerInfo[playerid][pDOB], PlayerInfo[playerid][pCountry], PlayerInfo[playerid][pGender], PlayerInfo[playerid][pAccent], PlayerInfo[playerid][pSkin],
			PlayerInfo[playerid][pSpawnX], PlayerInfo[playerid][pSpawnY], PlayerInfo[playerid][pSpawnZ], PlayerInfo[playerid][pSpawnA], PlayerInfo[playerid][pSpawnInt], PlayerInfo[playerid][pSpawnVW], PlayerInfo[playerid][pID]);
		mysql_tquery(MainPipeline, q);
	}

	ER_SpawnCharacter(playerid);
	return 1;
}

CMD:skiptut(playerid, params[])
{
	if(!PlayerInfo[playerid][pLoggedIn]) return ER_Send(playerid, COLOR_GREY, "You must be logged in first.");
	if(!ServerCore[scAllowSkipTutorial] && PlayerInfo[playerid][pAdmin] < ADMIN_MOD) return ER_Send(playerid, COLOR_GREY, "Tutorial skipping is currently disabled.");
	if(PlayerInfo[playerid][pTutorial]) return ER_Send(playerid, COLOR_GREY, "You have already completed the tutorial.");

	ER_Send(playerid, COLOR_YELLOW, "Tutorial skipped. Continue with character creation.");
	ER_ShowCharacterCreation(playerid);
	return 1;
}

stock ER_TutorialDialog(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_TUT_STEP)
	{
		if(!response)
		{
			if(ServerCore[scAllowSkipTutorial] || PlayerInfo[playerid][pAdmin] >= ADMIN_MOD)
			{
				ER_ShowCharacterCreation(playerid);
				return 1;
			}
			ER_Send(playerid, COLOR_GREY, "Tutorial skipping is currently disabled.");
			ER_ShowTutorialStep(playerid);
			return 1;
		}

		PlayerInfo[playerid][pTutorialStep]++;
		if(PlayerInfo[playerid][pTutorialStep] >= MAX_TUTORIAL_STEPS)
		{
			ER_ShowCharacterCreation(playerid);
			return 1;
		}
		ER_AdvanceTutorial(playerid);
		return 1;
	}

	if(dialogid == DIALOG_CHAR_CREATE)
	{
		if(!response) return ER_ShowCharacterCreation(playerid);
		switch(listitem)
		{
			case 0: return ER_ShowCharacterCreation(playerid);
			case 1: return ShowPlayerDialog(playerid, DIALOG_CHAR_GENDER, DIALOG_STYLE_LIST, "{FF0000}Is your character male or female?", "Male\nFemale", "Select", "Back");
			case 2: return ShowPlayerDialog(playerid, DIALOG_CHAR_MONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Select", "Back");
			case 3: return ShowPlayerDialog(playerid, DIALOG_CHAR_COUNTRY, DIALOG_STYLE_INPUT, "{FF0000}What country is your character from?", "Enter your character country.\n\nExample: United States, Egypt, Russia, Italy", "Save", "Back");
			case 4:
			{
				new list[1024];
				list[0] = EOS;
				for(new i; i < sizeof(AccentNames); i++)
				{
					format(list, sizeof(list), "%s%d. %s\n", list, i, AccentNames[i]);
				}
				return ShowPlayerDialog(playerid, DIALOG_CHAR_ACCENT, DIALOG_STYLE_LIST, "{FF0000}Select your character accent", list, "Select", "Back");
			}
			case 5: return ER_CompleteCharacterCreation(playerid);
		}
		return 1;
	}

	if(dialogid == DIALOG_CHAR_GENDER)
	{
		if(!response) return ER_ShowCharacterCreation(playerid);
		if(listitem == 0)
		{
			PlayerInfo[playerid][pGender] = 1;
			PlayerInfo[playerid][pSkin] = ServerCore[scDefaultMaleSkin];
			ER_Send(playerid, COLOR_YELLOW, "Alright, so you're a male!");
		}
		else
		{
			PlayerInfo[playerid][pGender] = 2;
			PlayerInfo[playerid][pSkin] = ServerCore[scDefaultFemaleSkin];
			ER_Send(playerid, COLOR_YELLOW, "Alright, so you're a female!");
		}
		return ER_ShowCharacterCreation(playerid);
	}

	if(dialogid == DIALOG_CHAR_MONTH)
	{
		if(!response) return ER_ShowCharacterCreation(playerid);
		SetPVarInt(playerid, "RegisterMonth", listitem + 1);

		new days, list[256];
		switch(listitem)
		{
			case 0,2,4,6,7,9,11: days = 31;
			case 3,5,8,10: days = 30;
			default: days = 28;
		}
		list[0] = EOS;
		for(new d = 1; d <= days; d++) format(list, sizeof(list), "%s%d\n", list, d);
		return ShowPlayerDialog(playerid, DIALOG_CHAR_DAY, DIALOG_STYLE_LIST, "{FF0000}Which day was your character born?", list, "Select", "Back");
	}

	if(dialogid == DIALOG_CHAR_DAY)
	{
		if(!response) return ShowPlayerDialog(playerid, DIALOG_CHAR_MONTH, DIALOG_STYLE_LIST, "{FF0000}Which month was your character born?", "January\nFebruary\nMarch\nApril\nMay\nJune\nJuly\nAugust\nSeptember\nOctober\nNovember\nDecember", "Select", "Back");
		SetPVarInt(playerid, "RegisterDay", listitem + 1);

		new year, month, day, list[512];
		getdate(year, month, day);
		list[0] = EOS;
		for(new y = year - 100; y <= year - 18; y++) format(list, sizeof(list), "%s%d\n", list, y);
		return ShowPlayerDialog(playerid, DIALOG_CHAR_YEAR, DIALOG_STYLE_LIST, "{FF0000}Which year was your character born?", list, "Select", "Back");
	}

	if(dialogid == DIALOG_CHAR_YEAR)
	{
		if(!response) return ER_ShowCharacterCreation(playerid);

		new year, month, day;
		getdate(year, month, day);

		new birthyear = (year - 100) + listitem;
		new birthmonth = GetPVarInt(playerid, "RegisterMonth");
		new birthday = GetPVarInt(playerid, "RegisterDay");

		format(PlayerInfo[playerid][pDOB], 16, "%02d/%02d/%04d", birthmonth, birthday, birthyear);
		PlayerInfo[playerid][pAge] = year - birthyear;
		if(month < birthmonth || (month == birthmonth && day < birthday)) PlayerInfo[playerid][pAge]--;

		ER_Send(playerid, COLOR_YELLOW, "Your account has been successfully registered.");
		return ER_ShowCharacterCreation(playerid);
	}

	if(dialogid == DIALOG_CHAR_COUNTRY)
	{
		if(!response) return ER_ShowCharacterCreation(playerid);
		if(strlen(inputtext) < 2 || strlen(inputtext) > 31)
		{
			ER_Send(playerid, COLOR_GREY, "Country must be between 2 and 31 characters.");
			return ER_ShowCharacterCreation(playerid);
		}
		format(PlayerInfo[playerid][pCountry], 32, "%s", inputtext);
		return ER_ShowCharacterCreation(playerid);
	}

	if(dialogid == DIALOG_CHAR_ACCENT)
	{
		if(!response) return ER_ShowCharacterCreation(playerid);
		if(listitem < 0 || listitem >= sizeof(AccentNames)) return ER_ShowCharacterCreation(playerid);
		PlayerInfo[playerid][pAccent] = listitem;
		return ER_ShowCharacterCreation(playerid);
	}

	return 0;
}
