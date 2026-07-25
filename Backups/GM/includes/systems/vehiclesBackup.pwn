#if defined _ER_VEHICLES_INCLUDED
    #endinput
#endif
#define _ER_VEHICLES_INCLUDED

new VehicleTrackIcon[MAX_PLAYERS] = { -1, ... };

new const ER_VehicleNames[212][] =
{
	"Landstalker","Bravura","Buffalo","Linerunner","Pereniel"
	,"Sentinel","Dumper","Firetruck","Trashmaster","Stretch"
	,"Manana","Infernus","Voodoo","Pony","Mule","Cheetah"
	,"Ambulance","Leviathan","Moonbeam","Esperanto","Taxi"
	,"Washington","Bobcat","Mr Whoopee","BF Injection"
	,"Hunter","Premier","Enforcer","Securicar","Banshee"
	,"Predator","Bus","Rhino","Barracks","Hotknife","Trailer"
	,"Previon","Coach","Cabbie","Stallion","Rumpo","RC Bandit"
	,"Romero","Packer","Monster","Admiral","Squalo","Seasparrow"
	,"Pizzaboy","Tram","Trailer","Turismo","Speeder","Reefer","Tropic"
	,"Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer"
	,"PCJ-600","Faggio","Freeway","RC Baron","RC Raider","Glendale"
	,"Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard"
	,"Dinghy","Hermes","Sabre","Rustler","ZR-350","Walton","Regina"
	,"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer"
	,"Maverick","News Chopper","Rancher","FBI Rancher","Virgo"
	,"Greenwood","Jetmax","Hotring","Sandking","Blista Compact"
	,"Police Maverick","Boxville","Benson","Mesa","RC Goblin"
	,"Hotring Racer A","Hotring Racer B","Bloodring Banger"
	,"Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike"
	,"Beagle","Cropdust","Stunt","Tanker","RoadTrain","Nebula","Majestic"
	,"Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000"
	,"Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck"
	,"Willard","Forklift","Tractor","Combine","Feltzer","Remington"
	,"Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet"
	,"Clover","Sadler","Firetruck LA","Hustler","Intruder","Primo"
	,"Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite"
	,"Windsor","Monster A","Monster B","Uranus","Jester","Sultan","Stratum"
	,"Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito"
	,"Freight Flat","Streak Carriage","Kart","Mower","Duneride","Sweeper"
	,"Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400"
	,"Newsvan","Tug","Trailer 3","Emperor","Wayfarer","Euros","Hotdog"
	,"Club","Freight Carriage","Trailer 3","Andromada","Dodo","RC Cam"
	,"Launch","Police Car LSPD","Police Car SFPD","Police Car LVPD"
	,"Police Ranger","Picador","S.W.A.T.","Alpha","Phoenix","Glendale Shit"
	,"Sadler Shit","Luggage Trailer A","Luggage Trailer B","Stair Trailer"
	,"Boxville","Farm Plow","Utility Trailer"
};

stock ER_GetVehicleModelName(model)
{
	static name[32];
	if(model >= 400 && model <= 611) format(name, sizeof(name), "%s", ER_VehicleNames[model - 400]);
	else format(name, sizeof(name), "Unknown");
	return name;
}

stock ER_FindVehicleModel(const input[])
{
	if(strlen(input) == 0) return 0;
	if(input[0] >= '0' && input[0] <= '9')
	{
		new model = strval(input);
		if(model >= 400 && model <= 611) return model;
		return 0;
	}

	for(new i; i < sizeof(ER_VehicleNames); i++)
	{
		if(!strcmp(input, ER_VehicleNames[i], true)) return i + 400;
	}
	if(!strcmp(input, "nrg", true) || !strcmp(input, "nrg500", true)) return 522;
	return 0;
}

stock ER_GetVehicleAreaName(Float:x, Float:y, Float:z, dest[], size = sizeof(dest))
{
	#pragma unused z
	if(x >= 44.0 && x <= 2997.0 && y >= -2892.0 && y <= -768.0) format(dest, size, "Los Santos");
	else if(x >= -2997.0 && x <= -1213.0 && y >= -1115.0 && y <= 1659.0) format(dest, size, "San Fierro");
	else if(x >= 869.0 && x <= 2997.0 && y >= 596.0 && y <= 2997.0) format(dest, size, "Las Venturas");
	else format(dest, size, "San Andreas");
	return 1;
}

stock ER_GetVehicleLockName(locktype)
{
	static name[16];
	switch(locktype)
	{
		case 1: format(name, sizeof(name), "Alarm");
		case 2: format(name, sizeof(name), "Industrial");
		default: format(name, sizeof(name), "None");
	}
	return name;
}


stock ER_GetVehiclePaintjobName(paintjob)
{
    static name[18];
    switch(paintjob)
    {
        case -1: format(name, sizeof(name), "None");
        case 0: format(name, sizeof(name), "Paintjob 1");
        case 1: format(name, sizeof(name), "Paintjob 2");
        case 2: format(name, sizeof(name), "Paintjob 3");
        default: format(name, sizeof(name), "None");
    }
    return name;
}

stock ER_CanVehicleUsePaintjob(model)
{
    switch(model)
    {
        case 534, 535, 536, 558, 559, 560, 561, 562, 565, 567, 575, 576: return 1;
    }
    return 0;
}

stock ER_GetVehicleNOSName(nos, unlimited = 0)
{
    static name[24];

    if(unlimited)
    {
        format(name, sizeof(name), "Unlimited NOS");
        return name;
    }

    switch(nos)
    {
        case 1008: format(name, sizeof(name), "NOS 5x");
        case 1009: format(name, sizeof(name), "NOS 2x");
        case 1010: format(name, sizeof(name), "NOS 10x");
        default: format(name, sizeof(name), "None");
    }
    return name;
}


stock ER_GetVehicleComponentName(component)
{
    static name[32];
    switch(component)
    {
        case 1000: format(name, sizeof(name), "Pro Spoiler");
        case 1001: format(name, sizeof(name), "Win Spoiler");
        case 1002: format(name, sizeof(name), "Drag Spoiler");
        case 1003: format(name, sizeof(name), "Alpha Spoiler");
        case 1014: format(name, sizeof(name), "Champ Scoop Hood");
        case 1015: format(name, sizeof(name), "Fury Scoop Hood");
        case 1016: format(name, sizeof(name), "Worx Scoop Hood");
        case 1017: format(name, sizeof(name), "Right Side Skirt");
        case 1018: format(name, sizeof(name), "Upswept Exhaust");
        case 1019: format(name, sizeof(name), "Twin Exhaust");
        case 1020: format(name, sizeof(name), "Large Exhaust");
        case 1021: format(name, sizeof(name), "Medium Exhaust");
        case 1022: format(name, sizeof(name), "Small Exhaust");
        case 1023: format(name, sizeof(name), "Fury Spoiler");
        case 1024: format(name, sizeof(name), "Square Fog Lamps");
        case 1025: format(name, sizeof(name), "Offroad Wheels");
        case 1073: format(name, sizeof(name), "Shadow Rims");
        case 1074: format(name, sizeof(name), "Mega Rims");
        case 1075: format(name, sizeof(name), "Rimshine Rims");
        case 1076: format(name, sizeof(name), "Wires Rims");
        case 1077: format(name, sizeof(name), "Classic Rims");
        case 1078: format(name, sizeof(name), "Twist Rims");
        case 1079: format(name, sizeof(name), "Cutter Rims");
        case 1080: format(name, sizeof(name), "Switch Rims");
        case 1081: format(name, sizeof(name), "Grove Rims");
        case 1082: format(name, sizeof(name), "Import Rims");
        case 1083: format(name, sizeof(name), "Dollar Rims");
        case 1084: format(name, sizeof(name), "Trance Rims");
        case 1085: format(name, sizeof(name), "Atomic Rims");
        case 1086: format(name, sizeof(name), "Stereo");
        case 1087: format(name, sizeof(name), "Hydraulics");
        case 1088: format(name, sizeof(name), "Alien Roof Vent");
        case 1089: format(name, sizeof(name), "X-Flow Exhaust");
        case 1090: format(name, sizeof(name), "Right Alien Side Skirt");
        case 1091: format(name, sizeof(name), "X-Flow Side Skirt");
        case 1092: format(name, sizeof(name), "Alien Exhaust");
        case 1093: format(name, sizeof(name), "X-Flow Exhaust");
        case 1094: format(name, sizeof(name), "Alien Side Skirt");
        case 1095: format(name, sizeof(name), "X-Flow Side Skirt");
        case 1096: format(name, sizeof(name), "Ahab Rims");
        case 1097: format(name, sizeof(name), "Virtual Rims");
        case 1098: format(name, sizeof(name), "Access Rims");
        case 1099: format(name, sizeof(name), "Left Chrome Side Skirt");
        case 1100: format(name, sizeof(name), "Chrome Grill");
        case 1101: format(name, sizeof(name), "Left Chrome Flames");
        case 1102: format(name, sizeof(name), "Left Chrome Strip");
        case 1103: format(name, sizeof(name), "Convertible Roof");
        case 1104: format(name, sizeof(name), "Chrome Exhaust");
        case 1105: format(name, sizeof(name), "Slamin Exhaust");
        case 1106: format(name, sizeof(name), "Right Chrome Arches");
        case 1107: format(name, sizeof(name), "Left Chrome Strip");
        case 1108: format(name, sizeof(name), "Right Chrome Strip");
        case 1109: format(name, sizeof(name), "Chrome Rear Bullbars");
        case 1110: format(name, sizeof(name), "Slamin Rear Bullbars");
        case 1111: format(name, sizeof(name), "Front Sign");
        case 1112: format(name, sizeof(name), "Front Sign");
        case 1113: format(name, sizeof(name), "Chrome Exhaust");
        case 1114: format(name, sizeof(name), "Slamin Exhaust");
        case 1115: format(name, sizeof(name), "Chrome Front Bullbars");
        case 1116: format(name, sizeof(name), "Slamin Front Bullbars");
        case 1117: format(name, sizeof(name), "Chrome Front Bumper");
        case 1118: format(name, sizeof(name), "Right Chrome Trim");
        case 1119: format(name, sizeof(name), "Right Wheelcovers");
        case 1120: format(name, sizeof(name), "Left Chrome Trim");
        case 1121: format(name, sizeof(name), "Left Wheelcovers");
        case 1122: format(name, sizeof(name), "Right Chrome Flames");
        case 1123: format(name, sizeof(name), "Bullbar Chrome Bars");
        case 1124: format(name, sizeof(name), "Left Chrome Arches");
        case 1125: format(name, sizeof(name), "Bullbar Chrome Lights");
        case 1126: format(name, sizeof(name), "Chrome Exhaust");
        case 1127: format(name, sizeof(name), "Slamin Exhaust");
        case 1128: format(name, sizeof(name), "Vinyl Hardtop");
        case 1129: format(name, sizeof(name), "Chrome Exhaust");
        case 1130: format(name, sizeof(name), "Hardtop Roof");
        case 1131: format(name, sizeof(name), "Softtop Roof");
        case 1132: format(name, sizeof(name), "Slamin Exhaust");
        case 1133: format(name, sizeof(name), "Right Chrome Strip");
        case 1134: format(name, sizeof(name), "Right Chrome Strip");
        case 1135: format(name, sizeof(name), "Slamin Exhaust");
        case 1136: format(name, sizeof(name), "Chrome Exhaust");
        case 1137: format(name, sizeof(name), "Left Chrome Strip");
        case 1138: format(name, sizeof(name), "Alien Spoiler");
        case 1139: format(name, sizeof(name), "X-Flow Spoiler");
        case 1140: format(name, sizeof(name), "X-Flow Rear Bumper");
        case 1141: format(name, sizeof(name), "Alien Rear Bumper");
        case 1142: format(name, sizeof(name), "Left Oval Vents");
        case 1143: format(name, sizeof(name), "Right Oval Vents");
        case 1144: format(name, sizeof(name), "Left Square Vents");
        case 1145: format(name, sizeof(name), "Right Square Vents");
        case 1146: format(name, sizeof(name), "X-Flow Spoiler");
        case 1147: format(name, sizeof(name), "Alien Spoiler");
        case 1148: format(name, sizeof(name), "X-Flow Rear Bumper");
        case 1149: format(name, sizeof(name), "Alien Rear Bumper");
        case 1150: format(name, sizeof(name), "Alien Rear Bumper");
        case 1151: format(name, sizeof(name), "X-Flow Rear Bumper");
        case 1152: format(name, sizeof(name), "X-Flow Front Bumper");
        case 1153: format(name, sizeof(name), "Alien Front Bumper");
        case 1154: format(name, sizeof(name), "Alien Rear Bumper");
        case 1155: format(name, sizeof(name), "Alien Front Bumper");
        case 1156: format(name, sizeof(name), "X-Flow Rear Bumper");
        case 1157: format(name, sizeof(name), "X-Flow Front Bumper");
        case 1158: format(name, sizeof(name), "X-Flow Spoiler");
        case 1159: format(name, sizeof(name), "Alien Rear Bumper");
        case 1160: format(name, sizeof(name), "Alien Front Bumper");
        case 1161: format(name, sizeof(name), "X-Flow Rear Bumper");
        case 1162: format(name, sizeof(name), "Alien Spoiler");
        case 1163: format(name, sizeof(name), "X-Flow Spoiler");
        case 1164: format(name, sizeof(name), "Alien Spoiler");
        case 1165: format(name, sizeof(name), "X-Flow Front Bumper");
        case 1166: format(name, sizeof(name), "Alien Front Bumper");
        case 1167: format(name, sizeof(name), "X-Flow Rear Bumper");
        case 1168: format(name, sizeof(name), "Alien Rear Bumper");
        case 1169: format(name, sizeof(name), "Alien Front Bumper");
        case 1170: format(name, sizeof(name), "X-Flow Front Bumper");
        case 1171: format(name, sizeof(name), "Alien Front Bumper");
        case 1172: format(name, sizeof(name), "X-Flow Front Bumper");
        case 1173: format(name, sizeof(name), "X-Flow Front Bumper");
        case 1174: format(name, sizeof(name), "Chrome Front Bumper");
        case 1175: format(name, sizeof(name), "Slamin Front Bumper");
        case 1176: format(name, sizeof(name), "Chrome Rear Bumper");
        case 1177: format(name, sizeof(name), "Slamin Rear Bumper");
        case 1178: format(name, sizeof(name), "Slamin Rear Bumper");
        case 1179: format(name, sizeof(name), "Chrome Front Bumper");
        case 1180: format(name, sizeof(name), "Chrome Rear Bumper");
        case 1181: format(name, sizeof(name), "Slamin Front Bumper");
        case 1182: format(name, sizeof(name), "Chrome Front Bumper");
        case 1183: format(name, sizeof(name), "Slamin Rear Bumper");
        case 1184: format(name, sizeof(name), "Chrome Rear Bumper");
        case 1185: format(name, sizeof(name), "Slamin Front Bumper");
        case 1186: format(name, sizeof(name), "Slamin Rear Bumper");
        case 1187: format(name, sizeof(name), "Chrome Rear Bumper");
        case 1188: format(name, sizeof(name), "Slamin Front Bumper");
        case 1189: format(name, sizeof(name), "Chrome Front Bumper");
        case 1190: format(name, sizeof(name), "Slamin Front Bumper");
        case 1191: format(name, sizeof(name), "Chrome Front Bumper");
        case 1192: format(name, sizeof(name), "Chrome Rear Bumper");
        case 1193: format(name, sizeof(name), "Slamin Rear Bumper");
        default:
        {
            if(component > 0) format(name, sizeof(name), "Component %d", component);
            else format(name, sizeof(name), "None");
        }
    }
    return name;
}

stock ER_CanUseUniversalTuning(model)
{
    // Ground 4-wheel vehicles that safely support standard SA-MP rims / stereo / hydraulics.
    switch(model)
    {
        case 400,401,402,403,404,405,406,407,408,409,410,411,412,413: return 1;
        case 414,415,416,418,419,420,421,422,423,424,426,427,428,429: return 1;
        case 431,432,433,434,436,437,438,439,440,441,442,443,444,445: return 1;
        case 451,455,456,457,458,459,466,467,470,474,475,477,478,479: return 1;
        case 480,482,483,485,486,489,490,491,492,494,495,496,498,499: return 1;
        case 500,502,503,504,505,506,507,508,514,515,516,517,518,524: return 1;
        case 525,526,527,528,529,530,531,532,533,534,535,536,539,540: return 1;
        case 541,542,543,544,545,546,547,549,550,551,552,554,555,556: return 1;
        case 557,558,559,560,561,562,565,566,567,575,576,579,580,582: return 1;
        case 583,585,587,588,589,596,597,598,599,600,602,603: return 1;
    }
    return 0;
}


stock ER_CanVehicleUseNOS(model)
{
    // NOS is kept to normal road cars only.
    switch(model)
    {
        case 400,401,402,404,405,410,411,412,415,418,419,420,421,422,424,426,429,436,438,439,445,451,458,466,467,474,475,477,478,479,480,489,491,492,496,500,506,507,516,517,518,526,527,529,533,534,535,536,540,541,542,545,546,547,549,550,551,555,558,559,560,561,562,565,566,567,575,576,579,580,585,587,589,600,602,603:
            return 1;
    }
    return 0;
}

stock ER_IsComponentCompatible(model, component)
{
    if(component == 0) return 1;

    // Nitro uses your existing restriction list, so bikes/boats/aircraft/RC/trailers stay blocked.
    switch(component)
    {
        case 1008,1009,1010: return ER_CanVehicleUseNOS(model);
        case 1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1096,1097,1098: return ER_CanUseUniversalTuning(model);
        case 1086,1087: return ER_CanUseUniversalTuning(model);
    }

    switch(model)
    {
        case 400:
        {
            switch(component)
            {
                case 1013,1018,1019,1020,1021,1024: return 1;
            }
        }
        case 401:
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1013,1017,1019,1020,1142,1143: return 1;
                case 1144,1145: return 1;
            }
        }
        case 404:
        {
            switch(component)
            {
                case 1000,1002,1007,1013,1016,1017,1019,1020,1021: return 1;
            }
        }
        case 405:
        {
            switch(component)
            {
                case 1000,1001,1014,1018,1019,1020,1021,1023: return 1;
            }
        }
        case 410:
        {
            switch(component)
            {
                case 1001,1003,1007,1013,1017,1019,1020,1021,1023,1024: return 1;
            }
        }
        case 415:
        {
            switch(component)
            {
                case 1001,1003,1007,1017,1018,1019,1023: return 1;
            }
        }
        case 418:
        {
            switch(component)
            {
                case 1002,1006,1016,1020,1021: return 1;
            }
        }
        case 420:
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1019,1021: return 1;
            }
        }
        case 421:
        {
            switch(component)
            {
                case 1000,1014,1016,1018,1019,1020,1021,1023: return 1;
            }
        }
        case 422:
        {
            switch(component)
            {
                case 1007,1013,1017,1019,1020,1021: return 1;
            }
        }
        case 426:
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1019,1021: return 1;
            }
        }
        case 436:
        {
            switch(component)
            {
                case 1001,1003,1006,1007,1013,1017,1019,1020,1021,1022: return 1;
            }
        }
        case 439:
        {
            switch(component)
            {
                case 1001,1003,1007,1013,1017,1023,1142,1143,1144,1145: return 1;
            }
        }
        case 477:
        {
            switch(component)
            {
                case 1006,1007,1017,1018,1019,1020,1021: return 1;
            }
        }
        case 478:
        {
            switch(component)
            {
                case 1004,1005,1012,1013,1020,1021,1022,1024: return 1;
            }
        }
        case 489:
        {
            switch(component)
            {
                case 1000,1002,1004,1005,1006,1013,1016,1018,1019,1020,1024: return 1;
            }
        }
        case 491:
        {
            switch(component)
            {
                case 1003,1007,1014,1017,1018,1019,1020,1021,1023,1142,1143,1144: return 1;
                case 1145: return 1;
            }
        }
        case 492:
        {
            switch(component)
            {
                case 1000,1004,1005,1006,1016: return 1;
            }
        }
        case 496:
        {
            switch(component)
            {
                case 1001,1002,1003,1006,1007,1011,1017,1019,1020,1023,1142,1143: return 1;
            }
        }
        case 500:
        {
            switch(component)
            {
                case 1013,1019,1020,1021,1024: return 1;
            }
        }
        case 516:
        {
            switch(component)
            {
                case 1000,1002,1004,1007,1015,1016,1017,1018,1019,1020,1021: return 1;
            }
        }
        case 517:
        {
            switch(component)
            {
                case 1002,1003,1007,1016,1017,1018,1019,1020,1023,1142,1143,1144: return 1;
                case 1145: return 1;
            }
        }
        case 518:
        {
            switch(component)
            {
                case 1001,1003,1005,1006,1007,1013,1017,1018,1020,1023,1142,1143: return 1;
                case 1144,1145: return 1;
            }
        }
        case 527:
        {
            switch(component)
            {
                case 1001,1007,1014,1015,1017,1018,1020,1021: return 1;
            }
        }
        case 529:
        {
            switch(component)
            {
                case 1001,1003,1006,1007,1011,1012,1017,1018,1019,1020,1023: return 1;
            }
        }
        case 534:
        {
            switch(component)
            {
                case 1100,1101,1106,1122,1123,1124,1125,1126,1127,1178,1179,1180: return 1;
                case 1185: return 1;
            }
        }
        case 535:
        {
            switch(component)
            {
                case 1109,1110,1113,1114,1115,1116,1117,1118,1119,1120,1121: return 1;
            }
        }
        case 536:
        {
            switch(component)
            {
                case 1103,1104,1105,1107,1108,1128,1181,1182,1183,1184: return 1;
            }
        }
        case 540:
        {
            switch(component)
            {
                case 1001,1004,1006,1007,1017,1018,1019,1020,1023,1024,1142,1143: return 1;
                case 1144,1145: return 1;
            }
        }
        case 542:
        {
            switch(component)
            {
                case 1014,1015,1018,1019,1020,1021,1144,1145: return 1;
            }
        }
        case 546:
        {
            switch(component)
            {
                case 1001,1002,1004,1006,1007,1017,1018,1019,1023,1024,1142,1143: return 1;
                case 1144,1145: return 1;
            }
        }
        case 547:
        {
            switch(component)
            {
                case 1000,1003,1016,1018,1019,1020,1021,1142,1143: return 1;
            }
        }
        case 549:
        {
            switch(component)
            {
                case 1001,1003,1007,1011,1012,1017,1018,1019,1020,1023,1142,1143: return 1;
                case 1144,1145: return 1;
            }
        }
        case 550:
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1018,1019,1020,1023,1142,1143,1144: return 1;
                case 1145: return 1;
            }
        }
        case 551:
        {
            switch(component)
            {
                case 1002,1003,1005,1006,1016,1018,1019,1020,1021,1023: return 1;
            }
        }
        case 558:
        {
            switch(component)
            {
                case 1088,1089,1090,1091,1092,1093,1094,1095,1163,1164,1165,1166: return 1;
                case 1167,1168: return 1;
            }
        }
        case 559:
        {
            switch(component)
            {
                case 1065,1066,1067,1068,1069,1070,1071,1072,1158,1159,1160,1161: return 1;
                case 1162,1173: return 1;
            }
        }
        case 560:
        {
            switch(component)
            {
                case 1026,1027,1028,1029,1030,1031,1032,1033,1138,1139,1140,1141: return 1;
                case 1169,1170: return 1;
            }
        }
        case 561:
        {
            switch(component)
            {
                case 1026,1027,1030,1031,1055,1056,1057,1058,1059,1060,1061,1062: return 1;
                case 1063,1064,1154,1155,1156,1157: return 1;
            }
        }
        case 562:
        {
            switch(component)
            {
                case 1034,1035,1036,1037,1038,1039,1040,1041,1146,1147,1148,1149: return 1;
                case 1171,1172: return 1;
            }
        }
        case 565:
        {
            switch(component)
            {
                case 1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1150,1151: return 1;
                case 1152,1153: return 1;
            }
        }
        case 567:
        {
            switch(component)
            {
                case 1102,1129,1130,1131,1132,1133,1186,1187,1188,1189: return 1;
            }
        }
        case 575:
        {
            switch(component)
            {
                case 1042,1043,1044,1099,1174,1175,1176,1177: return 1;
            }
        }
        case 576:
        {
            switch(component)
            {
                case 1134,1135,1136,1137,1190,1191,1192,1193: return 1;
            }
        }
        case 580:
        {
            switch(component)
            {
                case 1001,1006,1007,1017,1018,1020,1023: return 1;
            }
        }
        case 585:
        {
            switch(component)
            {
                case 1000,1001,1002,1003,1006,1007,1013,1014,1015,1016,1017,1018: return 1;
                case 1019,1020,1021,1022,1023,1024,1142,1143,1144,1145: return 1;
            }
        }
        case 589:
        {
            switch(component)
            {
                case 1000,1004,1005,1006,1007,1013,1016,1017,1018,1020,1024,1144: return 1;
                case 1145: return 1;
            }
        }
        case 600:
        {
            switch(component)
            {
                case 1004,1005,1006,1007,1013,1017,1018,1020,1022: return 1;
            }
        }
        case 603:
        {
            switch(component)
            {
                case 1001,1006,1007,1017,1018,1019,1020,1023,1024,1142,1143,1144: return 1;
                case 1145: return 1;
            }
        }
    }
    return 0;
}


stock ER_AddModRow(playerid, &count, list[], size, const name[], component)
{
    new pvar[32];
    format(pvar, sizeof(pvar), "VehModComp%d", count);
    SetPVarInt(playerid, pvar, component);
    format(list, size, "%s%s\t%d\n", list, name, component);
    count++;
    return 1;
}

stock ER_TryAddModRow(playerid, &count, list[], size, model, const name[], component)
{
    if(!ER_IsComponentCompatible(model, component)) return 0;
    return ER_AddModRow(playerid, count, list, size, name, component);
}

stock ER_TryAddModRowID(playerid, &count, list[], size, model, component)
{
    if(!ER_IsComponentCompatible(model, component)) return 0;

    new name[48];
    format(name, sizeof(name), "%s", ER_GetVehicleComponentName(component));
    return ER_AddModRow(playerid, count, list, size, name, component);
}





stock ER_GetVehicleWheelName(component)
{
    static name[24];
    switch(component)
    {
        case 1025: format(name, sizeof(name), "Offroad");
        case 1073: format(name, sizeof(name), "Shadow");
        case 1074: format(name, sizeof(name), "Mega");
        case 1075: format(name, sizeof(name), "Rimshine");
        case 1076: format(name, sizeof(name), "Wires");
        case 1077: format(name, sizeof(name), "Classic");
        case 1078: format(name, sizeof(name), "Twist");
        case 1079: format(name, sizeof(name), "Cutter");
        case 1080: format(name, sizeof(name), "Switch");
        case 1081: format(name, sizeof(name), "Grove");
        case 1082: format(name, sizeof(name), "Import");
        case 1083: format(name, sizeof(name), "Dollar");
        case 1084: format(name, sizeof(name), "Trance");
        case 1085: format(name, sizeof(name), "Atomic");
        case 1096: format(name, sizeof(name), "Ahab");
        case 1097: format(name, sizeof(name), "Virtual");
        case 1098: format(name, sizeof(name), "Access");
        default: format(name, sizeof(name), "None");
    }
    return name;
}

stock ER_ShowVehicleRimsList(playerid)
{
    new list[512];

    SetPVarInt(playerid, "VehRimComp0", 0);
    SetPVarInt(playerid, "VehRimComp1", 1025);
    SetPVarInt(playerid, "VehRimComp2", 1073);
    SetPVarInt(playerid, "VehRimComp3", 1074);
    SetPVarInt(playerid, "VehRimComp4", 1075);
    SetPVarInt(playerid, "VehRimComp5", 1076);
    SetPVarInt(playerid, "VehRimComp6", 1077);
    SetPVarInt(playerid, "VehRimComp7", 1078);
    SetPVarInt(playerid, "VehRimComp8", 1079);
    SetPVarInt(playerid, "VehRimComp9", 1080);
    SetPVarInt(playerid, "VehRimComp10", 1081);
    SetPVarInt(playerid, "VehRimComp11", 1082);
    SetPVarInt(playerid, "VehRimComp12", 1083);
    SetPVarInt(playerid, "VehRimComp13", 1084);
    SetPVarInt(playerid, "VehRimComp14", 1085);
    SetPVarInt(playerid, "VehRimComp15", 1096);
    SetPVarInt(playerid, "VehRimComp16", 1097);
    SetPVarInt(playerid, "VehRimComp17", 1098);

    format(list, sizeof(list),
        "None\nOffroad\nShadow\nMega\nRimshine\nWires\nClassic\nTwist\nCutter\nSwitch\nGrove\nImport\nDollar\nTrance\nAtomic\nAhab\nVirtual\nAccess"
    );

    return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_RIMS, DIALOG_STYLE_LIST, "Vehicle Rims", list, "Select", "Back");
}


#define ER_MOD_SPOILER      0
#define ER_MOD_HOOD         1
#define ER_MOD_ROOF         2
#define ER_MOD_SKIRT        3
#define ER_MOD_LAMPS        5
#define ER_MOD_EXHAUST      7
#define ER_MOD_FRONT        11
#define ER_MOD_REAR         12
#define ER_MOD_VENT         13
#define ER_MOD_STICKER      15

stock ER_GetComponentCategory(component)
{
    switch(component)
    {
        case 1000,1001,1002,1003,1014,1015,1016,1023,1049,1050,1058,1060,1138,1139,1146,1147,1158,1162,1163,1164:
            return ER_MOD_SPOILER;

        case 1004,1005,1011,1012:
            return ER_MOD_HOOD;

        case 1006,1032,1033,1035,1038,1053,1054,1055,1061,1067,1068,1088,1091,1103,1128,1130,1131:
            return ER_MOD_ROOF;

        case 1007,1017,1026,1027,1030,1031,1036,1039,1040,1041,1042,1047,1048,1051,1052,1056,1057,1062,1063,1069,1070,1071,1072,1090,1093,1094,1095,1099,1101,1102,1106,1107,1108,1118,1119,1120,1121,1122,1124,1133,1134,1137:
            return ER_MOD_SKIRT;

        case 1013,1024:
            return ER_MOD_LAMPS;

        case 1018,1019,1020,1021,1022,1028,1029,1034,1037,1043,1044,1045,1046,1059,1064,1065,1066,1089,1092,1104,1105,1113,1114,1126,1127,1129,1132,1135,1136:
            return ER_MOD_EXHAUST;

        case 1115,1116,1117,1152,1153,1155,1157,1160,1165,1166,1169,1170,1171,1172,1173,1174,1175,1179,1181,1182,1185,1188,1189,1190,1191:
            return ER_MOD_FRONT;

        case 1109,1110,1140,1141,1148,1149,1150,1151,1154,1156,1159,1161,1167,1168,1176,1177,1178,1180,1183,1184,1186,1187,1192,1193:
            return ER_MOD_REAR;

        case 1142,1143,1144,1145:
            return ER_MOD_VENT;
    }
    return -1;
}

stock ER_GetComponentName(component, dest[], size)
{
    switch(component)
    {
        case 1000: format(dest, size, "Pro Spoiler");
        case 1001: format(dest, size, "Win Spoiler");
        case 1002: format(dest, size, "Drag Spoiler");
        case 1003: format(dest, size, "Alpha Spoiler");
        case 1004: format(dest, size, "Champ Scoop Hood");
        case 1005: format(dest, size, "Fury Scoop Hood");
        case 1006: format(dest, size, "Roof Scoop");
        case 1007: format(dest, size, "Right Side Skirt");
        case 1011: format(dest, size, "Race Scoop Hood");
        case 1012: format(dest, size, "Worx Scoop Hood");
        case 1013: format(dest, size, "Round Fog Lamps");
        case 1014: format(dest, size, "Champ Spoiler");
        case 1015: format(dest, size, "Race Spoiler");
        case 1016: format(dest, size, "Worx Spoiler");
        case 1017: format(dest, size, "Left Side Skirt");
        case 1018: format(dest, size, "Upswept Exhaust");
        case 1019: format(dest, size, "Twin Exhaust");
        case 1020: format(dest, size, "Large Exhaust");
        case 1021: format(dest, size, "Medium Exhaust");
        case 1022: format(dest, size, "Small Exhaust");
        case 1023: format(dest, size, "Fury Spoiler");
        case 1024: format(dest, size, "Square Fog Lamps");
        case 1026: format(dest, size, "Sultan Alien Side Skirt Set");
        case 1027: format(dest, size, "Sultan Alien Side Skirt Set");
        case 1028: format(dest, size, "Sultan Alien Exhaust");
        case 1029: format(dest, size, "Sultan X-Flow Exhaust");
        case 1030: format(dest, size, "Sultan X-Flow Side Skirt Set");
        case 1031: format(dest, size, "Sultan X-Flow Side Skirt Set");
        case 1032: format(dest, size, "Sultan Alien Roof Vent");
        case 1033: format(dest, size, "Sultan X-Flow Roof Vent");
        case 1034: format(dest, size, "Elegy Alien Exhaust");
        case 1035: format(dest, size, "Elegy X-Flow Roof Vent");
        case 1036: format(dest, size, "Elegy Alien Side Skirt Set");
        case 1037: format(dest, size, "Elegy X-Flow Exhaust");
        case 1038: format(dest, size, "Elegy Alien Roof Vent");
        case 1039: format(dest, size, "Elegy X-Flow Side Skirt Set");
        case 1040: format(dest, size, "Elegy Alien Side Skirt Set");
        case 1041: format(dest, size, "Elegy X-Flow Side Skirt Set");
        case 1042: format(dest, size, "Broadway Chrome Side Skirt");
        case 1043: format(dest, size, "Broadway Slamin Exhaust");
        case 1044: format(dest, size, "Broadway Chrome Exhaust");
        case 1045: format(dest, size, "Flash X-Flow Exhaust");
        case 1046: format(dest, size, "Flash Alien Exhaust");
        case 1047: format(dest, size, "Flash Alien Side Skirt Set");
        case 1048: format(dest, size, "Flash X-Flow Side Skirt Set");
        case 1049: format(dest, size, "Flash Alien Spoiler");
        case 1050: format(dest, size, "Flash X-Flow Spoiler");
        case 1051: format(dest, size, "Flash Alien Side Skirt Set");
        case 1052: format(dest, size, "Flash X-Flow Side Skirt Set");
        case 1053: format(dest, size, "Flash X-Flow Roof");
        case 1054: format(dest, size, "Flash Alien Roof");
        case 1055: format(dest, size, "Stratum Alien Roof");
        case 1056: format(dest, size, "Stratum Alien Side Skirt Set");
        case 1057: format(dest, size, "Stratum X-Flow Side Skirt Set");
        case 1058: format(dest, size, "Stratum Alien Spoiler");
        case 1059: format(dest, size, "Stratum X-Flow Exhaust");
        case 1060: format(dest, size, "Stratum X-Flow Spoiler");
        case 1061: format(dest, size, "Stratum X-Flow Roof");
        case 1062: format(dest, size, "Stratum Alien Side Skirt Set");
        case 1063: format(dest, size, "Stratum X-Flow Side Skirt Set");
        case 1064: format(dest, size, "Stratum Alien Exhaust");
        case 1065: format(dest, size, "Jester Alien Exhaust");
        case 1066: format(dest, size, "Jester X-Flow Exhaust");
        case 1067: format(dest, size, "Jester Alien Roof");
        case 1068: format(dest, size, "Jester X-Flow Roof");
        case 1069: format(dest, size, "Jester Alien Side Skirt Set");
        case 1070: format(dest, size, "Jester X-Flow Side Skirt Set");
        case 1071: format(dest, size, "Jester Alien Side Skirt Set");
        case 1072: format(dest, size, "Jester X-Flow Side Skirt Set");
        case 1088: format(dest, size, "Uranus Alien Roof");
        case 1089: format(dest, size, "Uranus X-Flow Exhaust");
        case 1090: format(dest, size, "Uranus Alien Side Skirt Set");
        case 1091: format(dest, size, "Uranus X-Flow Roof");
        case 1092: format(dest, size, "Uranus Alien Exhaust");
        case 1093: format(dest, size, "Uranus X-Flow Side Skirt Set");
        case 1094: format(dest, size, "Uranus Alien Side Skirt Set");
        case 1095: format(dest, size, "Uranus X-Flow Side Skirt Set");
        case 1099: format(dest, size, "Broadway Chrome Side Skirt");
        case 1100: format(dest, size, "Remington Chrome Grill");
        case 1101: format(dest, size, "Remington Chrome Flames");
        case 1102: format(dest, size, "Savanna Chrome Strip");
        case 1103: format(dest, size, "Blade Convertible Roof");
        case 1104: format(dest, size, "Blade Chrome Exhaust");
        case 1105: format(dest, size, "Blade Slamin Exhaust");
        case 1106: format(dest, size, "Remington Chrome Arches");
        case 1107: format(dest, size, "Blade Left Chrome Strip");
        case 1108: format(dest, size, "Blade Right Chrome Strip");
        case 1109: format(dest, size, "Slamvan Chrome Rear Bullbar");
        case 1110: format(dest, size, "Slamvan Slamin Rear Bullbar");
        case 1111: format(dest, size, "Slamvan Front Sign");
        case 1112: format(dest, size, "Slamvan Front Sign");
        case 1113: format(dest, size, "Slamvan Chrome Exhaust");
        case 1114: format(dest, size, "Slamvan Slamin Exhaust");
        case 1115: format(dest, size, "Slamvan Chrome Front Bullbar");
        case 1116: format(dest, size, "Slamvan Slamin Front Bullbar");
        case 1117: format(dest, size, "Slamvan Chrome Front Bumper");
        case 1118: format(dest, size, "Slamvan Chrome Trim");
        case 1119: format(dest, size, "Slamvan Wheelcovers");
        case 1120: format(dest, size, "Slamvan Chrome Trim");
        case 1121: format(dest, size, "Slamvan Wheelcovers");
        case 1122: format(dest, size, "Remington Chrome Flames");
        case 1123: format(dest, size, "Remington Chrome Bullbar");
        case 1124: format(dest, size, "Remington Chrome Arches");
        case 1125: format(dest, size, "Remington Chrome Lights");
        case 1126: format(dest, size, "Remington Chrome Exhaust");
        case 1127: format(dest, size, "Remington Slamin Exhaust");
        case 1128: format(dest, size, "Blade Vinyl Hardtop");
        case 1129: format(dest, size, "Savanna Chrome Exhaust");
        case 1130: format(dest, size, "Savanna Hardtop Roof");
        case 1131: format(dest, size, "Savanna Softtop Roof");
        case 1132: format(dest, size, "Savanna Slamin Exhaust");
        case 1133: format(dest, size, "Savanna Chrome Strip");
        case 1134: format(dest, size, "Tornado Chrome Strip");
        case 1135: format(dest, size, "Tornado Slamin Exhaust");
        case 1136: format(dest, size, "Tornado Chrome Exhaust");
        case 1137: format(dest, size, "Tornado Chrome Strip");
        case 1138: format(dest, size, "Sultan Alien Spoiler");
        case 1139: format(dest, size, "Sultan X-Flow Spoiler");
        case 1140: format(dest, size, "Sultan X-Flow Rear Bumper");
        case 1141: format(dest, size, "Sultan Alien Rear Bumper");
        case 1142: format(dest, size, "Left Oval Vents");
        case 1143: format(dest, size, "Right Oval Vents");
        case 1144: format(dest, size, "Left Square Vents");
        case 1145: format(dest, size, "Right Square Vents");
        case 1146: format(dest, size, "Elegy X-Flow Spoiler");
        case 1147: format(dest, size, "Elegy Alien Spoiler");
        case 1148: format(dest, size, "Elegy X-Flow Rear Bumper");
        case 1149: format(dest, size, "Elegy Alien Rear Bumper");
        case 1150: format(dest, size, "Flash Alien Rear Bumper");
        case 1151: format(dest, size, "Flash X-Flow Rear Bumper");
        case 1152: format(dest, size, "Flash X-Flow Front Bumper");
        case 1153: format(dest, size, "Flash Alien Front Bumper");
        case 1154: format(dest, size, "Stratum Alien Rear Bumper");
        case 1155: format(dest, size, "Stratum Alien Front Bumper");
        case 1156: format(dest, size, "Stratum X-Flow Rear Bumper");
        case 1157: format(dest, size, "Stratum X-Flow Front Bumper");
        case 1158: format(dest, size, "Jester X-Flow Spoiler");
        case 1159: format(dest, size, "Jester Alien Rear Bumper");
        case 1160: format(dest, size, "Jester Alien Front Bumper");
        case 1161: format(dest, size, "Jester X-Flow Rear Bumper");
        case 1162: format(dest, size, "Jester Alien Spoiler");
        case 1163: format(dest, size, "Uranus X-Flow Spoiler");
        case 1164: format(dest, size, "Uranus Alien Spoiler");
        case 1165: format(dest, size, "Uranus X-Flow Front Bumper");
        case 1166: format(dest, size, "Uranus Alien Front Bumper");
        case 1167: format(dest, size, "Uranus X-Flow Rear Bumper");
        case 1168: format(dest, size, "Uranus Alien Rear Bumper");
        case 1169: format(dest, size, "Sultan Alien Front Bumper");
        case 1170: format(dest, size, "Sultan X-Flow Front Bumper");
        case 1171: format(dest, size, "Elegy Alien Front Bumper");
        case 1172: format(dest, size, "Elegy X-Flow Front Bumper");
        case 1173: format(dest, size, "Jester X-Flow Front Bumper");
        case 1174: format(dest, size, "Broadway Chrome Front Bumper");
        case 1175: format(dest, size, "Broadway Slamin Front Bumper");
        case 1176: format(dest, size, "Broadway Chrome Rear Bumper");
        case 1177: format(dest, size, "Broadway Slamin Rear Bumper");
        case 1178: format(dest, size, "Remington Slamin Rear Bumper");
        case 1179: format(dest, size, "Remington Chrome Front Bumper");
        case 1180: format(dest, size, "Remington Chrome Rear Bumper");
        case 1181: format(dest, size, "Blade Slamin Front Bumper");
        case 1182: format(dest, size, "Blade Chrome Front Bumper");
        case 1183: format(dest, size, "Blade Slamin Rear Bumper");
        case 1184: format(dest, size, "Blade Chrome Rear Bumper");
        case 1185: format(dest, size, "Remington Slamin Front Bumper");
        case 1186: format(dest, size, "Savanna Slamin Rear Bumper");
        case 1187: format(dest, size, "Savanna Chrome Rear Bumper");
        case 1188: format(dest, size, "Savanna Slamin Front Bumper");
        case 1189: format(dest, size, "Savanna Chrome Front Bumper");
        case 1190: format(dest, size, "Tornado Slamin Front Bumper");
        case 1191: format(dest, size, "Tornado Chrome Front Bumper");
        case 1192: format(dest, size, "Tornado Chrome Rear Bumper");
        case 1193: format(dest, size, "Tornado Slamin Rear Bumper");
        default: format(dest, size, "Component %d", component);
    }
    return 1;
}

stock ER_ModSlotHasCompatible(model, slot)
{
    if(slot == ER_MOD_STICKER) return ER_CanVehicleUsePaintjob(model);

    for(new component = 1000; component <= 1193; component++)
    {
        if(ER_GetComponentCategory(component) == slot && ER_IsComponentCompatible(model, component))
        {
            return 1;
        }
    }
    return 0;
}

stock ER_GetFirstCompatibleComponent(model, slot)
{
    for(new component = 1000; component <= 1193; component++)
    {
        if(ER_GetComponentCategory(component) == slot && ER_IsComponentCompatible(model, component))
        {
            return component;
        }
    }
    return 0;
}

stock ER_GetMatchingSideSkirt(component)
{
    switch(component)
    {
        case 1007: return 1017;
        case 1017: return 1007;
        case 1026: return 1027;
        case 1027: return 1026;
        case 1030: return 1031;
        case 1031: return 1030;
        case 1036: return 1040;
        case 1040: return 1036;
        case 1039: return 1041;
        case 1041: return 1039;
        case 1047: return 1051;
        case 1051: return 1047;
        case 1048: return 1052;
        case 1052: return 1048;
        case 1056: return 1062;
        case 1062: return 1056;
        case 1057: return 1063;
        case 1063: return 1057;
        case 1069: return 1071;
        case 1071: return 1069;
        case 1070: return 1072;
        case 1072: return 1070;
        case 1090: return 1094;
        case 1094: return 1090;
        case 1093: return 1095;
        case 1095: return 1093;
        case 1101: return 1106;
        case 1106: return 1101;
        case 1102: return 1133;
        case 1133: return 1102;
        case 1107: return 1108;
        case 1108: return 1107;
        case 1118: return 1120;
        case 1120: return 1118;
        case 1119: return 1121;
        case 1121: return 1119;
        case 1122: return 1124;
        case 1124: return 1122;
        case 1134: return 1137;
        case 1137: return 1134;
    }
    return 0;
}

stock ER_SetVehicleSideSkirts(idx, component)
{
    if(idx < 0 || idx >= VehicleCount) return 0;

    new pair = ER_GetMatchingSideSkirt(component);

    VehicleInfo[idx][vModSideskirtL] = 0;
    VehicleInfo[idx][vModSideskirtR] = 0;

    if(component > 0)
    {
        VehicleInfo[idx][vModSideskirtL] = component;
        if(pair > 0 && ER_IsComponentCompatible(VehicleInfo[idx][vModel], pair))
        {
            VehicleInfo[idx][vModSideskirtR] = pair;
        }
    }
    return 1;
}

stock ER_ShowVehicleModCategories(playerid)
{
    new sqlid = GetPVarInt(playerid, "EditingVehicleID");
    new idx = ER_FindVehicleBySQLID(sqlid);
    if(idx == -1) return ER_ShowVehicleEditor(playerid, sqlid);

    new model = VehicleInfo[idx][vModel];
    new list[512], count = 0;
    list[0] = EOS;

    new pvar[32];
    if(ER_ModSlotHasCompatible(model, ER_MOD_SPOILER)) { format(pvar, sizeof(pvar), "VehModSlot%d", count); SetPVarInt(playerid, pvar, ER_MOD_SPOILER); format(list, sizeof(list), "%sSpoiler\n", list); count++; }
    if(ER_ModSlotHasCompatible(model, ER_MOD_HOOD)) { format(pvar, sizeof(pvar), "VehModSlot%d", count); SetPVarInt(playerid, pvar, ER_MOD_HOOD); format(list, sizeof(list), "%sHood\n", list); count++; }
    if(ER_ModSlotHasCompatible(model, ER_MOD_ROOF)) { format(pvar, sizeof(pvar), "VehModSlot%d", count); SetPVarInt(playerid, pvar, ER_MOD_ROOF); format(list, sizeof(list), "%sRoof\n", list); count++; }
    if(ER_ModSlotHasCompatible(model, ER_MOD_SKIRT)) { format(pvar, sizeof(pvar), "VehModSlot%d", count); SetPVarInt(playerid, pvar, ER_MOD_SKIRT); format(list, sizeof(list), "%sSide Skirt\n", list); count++; }
    if(ER_ModSlotHasCompatible(model, ER_MOD_LAMPS)) { format(pvar, sizeof(pvar), "VehModSlot%d", count); SetPVarInt(playerid, pvar, ER_MOD_LAMPS); format(list, sizeof(list), "%sLamps\n", list); count++; }
    if(ER_ModSlotHasCompatible(model, ER_MOD_EXHAUST)) { format(pvar, sizeof(pvar), "VehModSlot%d", count); SetPVarInt(playerid, pvar, ER_MOD_EXHAUST); format(list, sizeof(list), "%sExhaust\n", list); count++; }
    if(ER_ModSlotHasCompatible(model, ER_MOD_FRONT)) { format(pvar, sizeof(pvar), "VehModSlot%d", count); SetPVarInt(playerid, pvar, ER_MOD_FRONT); format(list, sizeof(list), "%sFront Bumper\n", list); count++; }
    if(ER_ModSlotHasCompatible(model, ER_MOD_REAR)) { format(pvar, sizeof(pvar), "VehModSlot%d", count); SetPVarInt(playerid, pvar, ER_MOD_REAR); format(list, sizeof(list), "%sRear Bumper\n", list); count++; }
    if(ER_ModSlotHasCompatible(model, ER_MOD_VENT)) { format(pvar, sizeof(pvar), "VehModSlot%d", count); SetPVarInt(playerid, pvar, ER_MOD_VENT); format(list, sizeof(list), "%sVents\n", list); count++; }
    if(ER_ModSlotHasCompatible(model, ER_MOD_STICKER)) { format(pvar, sizeof(pvar), "VehModSlot%d", count); SetPVarInt(playerid, pvar, ER_MOD_STICKER); format(list, sizeof(list), "%sStickers / Paintjob\n", list); count++; }

    if(!count)
    {
        ER_Send(playerid, COLOR_GREY, "This vehicle does not have any compatible modifications.");
        return ER_ShowVehicleEditor(playerid, sqlid);
    }

    return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_MODS, DIALOG_STYLE_LIST, "Vehicle Mods", list, "Select", "Back");
}

stock ER_ShowVehicleComponentList(playerid, slot)
{
    new sqlid = GetPVarInt(playerid, "EditingVehicleID");
    new idx = ER_FindVehicleBySQLID(sqlid);
    if(idx == -1) return ER_ShowVehicleEditor(playerid, sqlid);

    if(slot == ER_MOD_STICKER)
    {
        return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_PAINTJOB, DIALOG_STYLE_LIST, "Vehicle Stickers / Paintjob", "None\nSticker 1\nSticker 2\nSticker 3", "Select", "Back");
    }

    new model = VehicleInfo[idx][vModel];
    new list[2048], count = 0, pvar[32], cname[48];

    list[0] = EOS;

    format(pvar, sizeof(pvar), "VehModComp%d", count);
    SetPVarInt(playerid, pvar, 0);
    format(list, sizeof(list), "None\t0\n");
    count++;

    for(new component = 1000; component <= 1193; component++)
    {
        if(ER_GetComponentCategory(component) == slot && ER_IsComponentCompatible(model, component))
        {
            // Show only one side-skirt row per pair.
            if(slot == ER_MOD_SKIRT)
            {
                new pair = ER_GetMatchingSideSkirt(component);
                if(pair > 0 && component > pair) continue;
            }

            ER_GetComponentName(component, cname, sizeof(cname));

            format(pvar, sizeof(pvar), "VehModComp%d", count);
            SetPVarInt(playerid, pvar, component);
            format(list, sizeof(list), "%s%s\t%d\n", list, cname, component);
            count++;
        }
    }

    if(count <= 1)
    {
        ER_Send(playerid, COLOR_GREY, "No compatible parts are available for this vehicle.");
        return ER_ShowVehicleEditor(playerid, sqlid);
    }

    return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_MOD_SELECT, DIALOG_STYLE_TABLIST, "Select Vehicle Component", list, "Select", "Back");
}

stock ER_GetVehicleModComponentBySlot(idx, slot)
{
    if(idx < 0 || idx >= VehicleCount) return 0;

    switch(slot)
    {
        case ER_MOD_SPOILER: return VehicleInfo[idx][vModSpoiler];
        case ER_MOD_HOOD: return VehicleInfo[idx][vModHood];
        case ER_MOD_ROOF: return VehicleInfo[idx][vModRoof];
        case ER_MOD_SKIRT: return VehicleInfo[idx][vModSideskirtL];
        case ER_MOD_LAMPS: return VehicleInfo[idx][vModLamps];
        case ER_MOD_EXHAUST: return VehicleInfo[idx][vModExhaust];
        case ER_MOD_FRONT: return VehicleInfo[idx][vModFrontBumper];
        case ER_MOD_REAR: return VehicleInfo[idx][vModRearBumper];
        case ER_MOD_VENT: return VehicleInfo[idx][vModVentRight];
    }
    return 0;
}

stock ER_ResetIncompatibleVehicleMods(idx)
{
    if(idx < 0 || idx >= VehicleCount) return 0;

    new model = VehicleInfo[idx][vModel];

    if(!ER_CanVehicleUseNOS(model))
    {
        VehicleInfo[idx][vNos] = 0;
        VehicleInfo[idx][vModNitro] = 0;
        VehicleInfo[idx][vUnlimitedNos] = 0;
    }

    if(!ER_CanVehicleUsePaintjob(model))
    {
        VehicleInfo[idx][vPaintjob] = -1;
    }

    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModSpoiler])) VehicleInfo[idx][vModSpoiler] = ER_GetFirstCompatibleComponent(model, ER_MOD_SPOILER);
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModHood])) VehicleInfo[idx][vModHood] = ER_GetFirstCompatibleComponent(model, ER_MOD_HOOD);
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModRoof])) VehicleInfo[idx][vModRoof] = ER_GetFirstCompatibleComponent(model, ER_MOD_ROOF);
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModLamps])) VehicleInfo[idx][vModLamps] = ER_GetFirstCompatibleComponent(model, ER_MOD_LAMPS);
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModExhaust])) VehicleInfo[idx][vModExhaust] = ER_GetFirstCompatibleComponent(model, ER_MOD_EXHAUST);
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModFrontBumper])) VehicleInfo[idx][vModFrontBumper] = ER_GetFirstCompatibleComponent(model, ER_MOD_FRONT);
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModRearBumper])) VehicleInfo[idx][vModRearBumper] = ER_GetFirstCompatibleComponent(model, ER_MOD_REAR);

    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModVentRight]) && !ER_IsComponentCompatible(model, VehicleInfo[idx][vModVentLeft]))
    {
        new vent = ER_GetFirstCompatibleComponent(model, ER_MOD_VENT);
        VehicleInfo[idx][vModVentRight] = vent;
        VehicleInfo[idx][vModVentLeft] = 0;
    }

    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModSideskirtL]) && !ER_IsComponentCompatible(model, VehicleInfo[idx][vModSideskirtR]))
    {
        ER_SetVehicleSideSkirts(idx, ER_GetFirstCompatibleComponent(model, ER_MOD_SKIRT));
    }
    else if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModSideskirtR]))
    {
        new pair = ER_GetMatchingSideSkirt(VehicleInfo[idx][vModSideskirtL]);
        if(pair > 0 && ER_IsComponentCompatible(model, pair)) VehicleInfo[idx][vModSideskirtR] = pair;
        else VehicleInfo[idx][vModSideskirtR] = 0;
    }

    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModWheels])) VehicleInfo[idx][vModWheels] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModHydraulics])) VehicleInfo[idx][vModHydraulics] = 0;

    new q[900];
    mysql_format(MainPipeline, q, sizeof(q),
        "UPDATE `vehicles` SET `paintjob`=%d,`nos`=%d,`unlimited_nos`=%d,`mod_spoiler`=%d,`mod_hood`=%d,`mod_roof`=%d,`mod_sideskirt_l`=%d,`mod_sideskirt_r`=%d,`mod_lamps`=%d,`mod_nitro`=%d,`mod_exhaust`=%d,`mod_wheels`=%d,`mod_stereo`=%d,`mod_hydraulics`=%d,`mod_front_bumper`=%d,`mod_rear_bumper`=%d,`mod_vent_right`=%d,`mod_vent_left`=%d WHERE `id`=%d",
        VehicleInfo[idx][vPaintjob], VehicleInfo[idx][vNos], VehicleInfo[idx][vUnlimitedNos], VehicleInfo[idx][vModSpoiler], VehicleInfo[idx][vModHood],
        VehicleInfo[idx][vModRoof], VehicleInfo[idx][vModSideskirtL], VehicleInfo[idx][vModSideskirtR], VehicleInfo[idx][vModLamps], VehicleInfo[idx][vModNitro],
        VehicleInfo[idx][vModExhaust], VehicleInfo[idx][vModWheels], VehicleInfo[idx][vModStereo], VehicleInfo[idx][vModHydraulics],
        VehicleInfo[idx][vModFrontBumper], VehicleInfo[idx][vModRearBumper], VehicleInfo[idx][vModVentRight], VehicleInfo[idx][vModVentLeft],
        VehicleInfo[idx][vSQLID]
    );
    mysql_tquery(MainPipeline, q);
    return 1;
}


stock ER_VehicleHasEditableMods(model)
{
    if(ER_CanVehicleUsePaintjob(model)) return 1;

    for(new component = 1000; component <= 1193; component++)
    {
        new cat = ER_GetComponentCategory(component);
        if(cat != -1 && ER_IsComponentCompatible(model, component))
        {
            return 1;
        }
    }
    return 0;
}


stock ER_SetVehicleSpawnID(idx, vehicleid)
{
    if(idx < 0 || idx >= MAX_DYNAMIC_VEHICLES) return 0;
    VehicleInfo[idx][vSpawnedID] = vehicleid;
    return 1;
}

forward ER_DelayedRespawnSavedVehicle(idx);
public ER_DelayedRespawnSavedVehicle(idx)
{
    if(idx < 0 || idx >= VehicleCount) return 0;
    if(VehicleInfo[idx][vSpawnedID] != INVALID_VEHICLE_ID && VehicleInfo[idx][vSpawnedID] != 0)
    {
        DestroyVehicle(VehicleInfo[idx][vSpawnedID]);
    }

    new veh = CreateVehicle(
        VehicleInfo[idx][vModel],
        VehicleInfo[idx][vX],
        VehicleInfo[idx][vY],
        VehicleInfo[idx][vZ],
        VehicleInfo[idx][vA],
        VehicleInfo[idx][vColor1],
        VehicleInfo[idx][vColor2],
        -1
    );
    ER_SetVehicleSpawnID(idx, veh);
    SetVehicleVirtualWorld(veh, VehicleInfo[idx][vVW]);
    LinkVehicleToInterior(veh, VehicleInfo[idx][vInt]);
    ER_ApplyVehicleMods(idx);
    return 1;
}


stock ER_SafeAddVehicleComponent(idx, component)
{
    if(component <= 0) return 0;
    if(idx < 0 || idx >= VehicleCount) return 0;
    if((component == 1008 || component == 1009 || component == 1010) && !ER_CanVehicleUseNOS(VehicleInfo[idx][vModel])) return 0;
    if(!ER_IsComponentCompatible(VehicleInfo[idx][vModel], component)) return 0;
    AddVehicleComponent(VehicleInfo[idx][vSpawnedID], component);
    return 1;
}

stock ER_ApplyVehicleMods(idx)
{
    if(idx < 0 || idx >= VehicleCount) return 0;
    new veh = VehicleInfo[idx][vSpawnedID];
    if(veh == INVALID_VEHICLE_ID || veh == 0) return 0;

    ChangeVehicleColor(veh, VehicleInfo[idx][vColor1], VehicleInfo[idx][vColor2]);

    if(VehicleInfo[idx][vPaintjob] >= 0 && ER_CanVehicleUsePaintjob(VehicleInfo[idx][vModel]))
    {
        ChangeVehiclePaintjob(veh, VehicleInfo[idx][vPaintjob]);
    }

    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vNos]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModSpoiler]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModHood]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModRoof]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModSideskirtL]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModSideskirtR]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModLamps]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModNitro]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModExhaust]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModWheels]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModStereo]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModHydraulics]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModFrontBumper]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModRearBumper]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModVentRight]);
    ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModVentLeft]);
    return 1;
}

stock ER_RespawnSavedVehicle(idx, putplayerid = INVALID_PLAYER_ID)
{
    if(idx < 0 || idx >= VehicleCount) return 0;

    if(VehicleInfo[idx][vSpawnedID] != INVALID_VEHICLE_ID && VehicleInfo[idx][vSpawnedID] != 0)
    {
        DestroyVehicle(VehicleInfo[idx][vSpawnedID]);
    }

    VehicleInfo[idx][vSpawnedID] = CreateVehicle(
        VehicleInfo[idx][vModel],
        VehicleInfo[idx][vX],
        VehicleInfo[idx][vY],
        VehicleInfo[idx][vZ],
        VehicleInfo[idx][vA],
        VehicleInfo[idx][vColor1],
        VehicleInfo[idx][vColor2],
        -1
    );

    SetVehicleVirtualWorld(VehicleInfo[idx][vSpawnedID], VehicleInfo[idx][vVW]);
    LinkVehicleToInterior(VehicleInfo[idx][vSpawnedID], VehicleInfo[idx][vInt]);
    ER_ApplyVehicleMods(idx);

    if(putplayerid != INVALID_PLAYER_ID && IsPlayerConnected(putplayerid))
    {
        PutPlayerInVehicle(putplayerid, VehicleInfo[idx][vSpawnedID], 0);
    }
    return 1;
}

stock ER_SaveVehicleTuning(idx)
{
    if(idx < 0 || idx >= VehicleCount) return 0;
    new veh = VehicleInfo[idx][vSpawnedID];
    if(veh == INVALID_VEHICLE_ID || veh == 0) return 0;

    VehicleInfo[idx][vNos] = GetVehicleComponentInSlot(veh, CARMODTYPE_NITRO);
    VehicleInfo[idx][vModNitro] = VehicleInfo[idx][vNos];
    VehicleInfo[idx][vModSpoiler] = GetVehicleComponentInSlot(veh, CARMODTYPE_SPOILER);
    VehicleInfo[idx][vModHood] = GetVehicleComponentInSlot(veh, CARMODTYPE_HOOD);
    VehicleInfo[idx][vModRoof] = GetVehicleComponentInSlot(veh, CARMODTYPE_ROOF);
    VehicleInfo[idx][vModSideskirtL] = GetVehicleComponentInSlot(veh, CARMODTYPE_SIDESKIRT);
    VehicleInfo[idx][vModSideskirtR] = 0;
    VehicleInfo[idx][vModLamps] = GetVehicleComponentInSlot(veh, CARMODTYPE_LAMPS);
    VehicleInfo[idx][vModExhaust] = GetVehicleComponentInSlot(veh, CARMODTYPE_EXHAUST);
    VehicleInfo[idx][vModWheels] = GetVehicleComponentInSlot(veh, CARMODTYPE_WHEELS);
    VehicleInfo[idx][vModStereo] = GetVehicleComponentInSlot(veh, CARMODTYPE_STEREO);
    VehicleInfo[idx][vModHydraulics] = GetVehicleComponentInSlot(veh, CARMODTYPE_HYDRAULICS);
    VehicleInfo[idx][vModFrontBumper] = GetVehicleComponentInSlot(veh, CARMODTYPE_FRONT_BUMPER);
    VehicleInfo[idx][vModRearBumper] = GetVehicleComponentInSlot(veh, CARMODTYPE_REAR_BUMPER);
    VehicleInfo[idx][vModVentRight] = GetVehicleComponentInSlot(veh, CARMODTYPE_VENT_RIGHT);
    VehicleInfo[idx][vModVentLeft] = GetVehicleComponentInSlot(veh, CARMODTYPE_VENT_LEFT);

    new q[900];
    mysql_format(MainPipeline, q, sizeof(q),
        "UPDATE `vehicles` SET `nos`=%d,`unlimited_nos`=%d,`mod_spoiler`=%d,`mod_hood`=%d,`mod_roof`=%d,`mod_sideskirt_l`=%d,`mod_sideskirt_r`=%d,`mod_lamps`=%d,`mod_nitro`=%d,`mod_exhaust`=%d,`mod_wheels`=%d,`mod_stereo`=%d,`mod_hydraulics`=%d,`mod_front_bumper`=%d,`mod_rear_bumper`=%d,`mod_vent_right`=%d,`mod_vent_left`=%d WHERE `id`=%d",
        VehicleInfo[idx][vNos], VehicleInfo[idx][vUnlimitedNos], VehicleInfo[idx][vModSpoiler], VehicleInfo[idx][vModHood], VehicleInfo[idx][vModRoof],
        VehicleInfo[idx][vModSideskirtL], VehicleInfo[idx][vModSideskirtR], VehicleInfo[idx][vModLamps], VehicleInfo[idx][vModNitro],
        VehicleInfo[idx][vModExhaust], VehicleInfo[idx][vModWheels], VehicleInfo[idx][vModStereo], VehicleInfo[idx][vModHydraulics],
        VehicleInfo[idx][vModFrontBumper], VehicleInfo[idx][vModRearBumper], VehicleInfo[idx][vModVentRight], VehicleInfo[idx][vModVentLeft],
        VehicleInfo[idx][vSQLID]
    );
    mysql_tquery(MainPipeline, q);
    return 1;
}

stock ER_GetBestVehicleEditPositionEx(playerid, sqlid, &Float:x, &Float:y, &Float:z, &Float:a, &interior, &vw)
{
    new playerveh = GetPlayerVehicleID(playerid);
    if(playerveh != 0)
    {
        GetVehiclePos(playerveh, x, y, z);
        GetVehicleZAngle(playerveh, a);
        interior = GetPlayerInterior(playerid);
        vw = GetPlayerVirtualWorld(playerid);
        return 1;
    }

    new idx = ER_FindVehicleBySQLID(sqlid);
    if(idx != -1 && VehicleInfo[idx][vSpawnedID] != INVALID_VEHICLE_ID && VehicleInfo[idx][vSpawnedID] != 0)
    {
        GetVehiclePos(VehicleInfo[idx][vSpawnedID], x, y, z);
        GetVehicleZAngle(VehicleInfo[idx][vSpawnedID], a);
        interior = VehicleInfo[idx][vInt];
        vw = VehicleInfo[idx][vVW];
        return 1;
    }

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    interior = GetPlayerInterior(playerid);
    vw = GetPlayerVirtualWorld(playerid);
    return 1;
}

stock ER_FindVehicleBySpawnID(vehicleid)
{
	for(new i; i < VehicleCount; i++)
	{
		if(VehicleInfo[i][vSpawnedID] == vehicleid) return i;
	}
	return -1;
}

stock ER_FindVehicleBySQLID(sqlid)
{
	for(new i; i < VehicleCount; i++)
	{
		if(VehicleInfo[i][vSQLID] == sqlid) return i;
	}
	return -1;
}

stock ER_GetVehicleOwnerText(ownerpid, familyid, factionid, ownername[], dest[], size = sizeof(dest))
{
	if(ownerpid > 0) format(dest, size, "Player Owned (%d) %s", ownerpid, ownername[0] ? ownername : "Unknown");
	else if(familyid > 0) format(dest, size, "Family Owned (%d)", familyid);
	else if(factionid > 0) format(dest, size, "Faction Owned (%d)", factionid);
	else format(dest, size, "None");
	return 1;
}

stock ER_LoadVehicles()
{
    mysql_tquery(MainPipeline, "SELECT * FROM `vehicles` WHERE `enabled`=1", "ER_OnVehiclesLoad");
    return 1;
}

forward ER_ReloadVehicles();
public ER_ReloadVehicles()
{
    ER_LoadVehicles();
    return 1;
}

forward ER_OnVehiclesLoad();
public ER_OnVehiclesLoad()
{
    new rows; cache_get_row_count(rows);

    for(new i; i < VehicleCount; i++)
    {
        if(VehicleInfo[i][vSpawnedID] != INVALID_VEHICLE_ID)
        {
            DestroyVehicle(VehicleInfo[i][vSpawnedID]);
        }
    }

    VehicleCount = 0;
    for(new r; r < rows && VehicleCount < MAX_DYNAMIC_VEHICLES; r++)
    {
        cache_get_value_name_int(r, "id", VehicleInfo[VehicleCount][vSQLID]);
        cache_get_value_name_int(r, "owner_pid", VehicleInfo[VehicleCount][vOwnerPID]);
        cache_get_value_name_int(r, "family_id", VehicleInfo[VehicleCount][vFamilyID]);
        cache_get_value_name_int(r, "faction_id", VehicleInfo[VehicleCount][vFactionID]);
        cache_get_value_name_int(r, "model", VehicleInfo[VehicleCount][vModel]);
        cache_get_value_name_int(r, "color1", VehicleInfo[VehicleCount][vColor1]);
        cache_get_value_name_int(r, "color2", VehicleInfo[VehicleCount][vColor2]);
        cache_get_value_name_int(r, "paintjob", VehicleInfo[VehicleCount][vPaintjob]);
        cache_get_value_name_float(r, "x", VehicleInfo[VehicleCount][vX]);
        cache_get_value_name_float(r, "y", VehicleInfo[VehicleCount][vY]);
        cache_get_value_name_float(r, "z", VehicleInfo[VehicleCount][vZ]);
        cache_get_value_name_float(r, "a", VehicleInfo[VehicleCount][vA]);
        cache_get_value_name_int(r, "interior", VehicleInfo[VehicleCount][vInt]);
        cache_get_value_name_int(r, "vw", VehicleInfo[VehicleCount][vVW]);
        cache_get_value_name_int(r, "lock_type", VehicleInfo[VehicleCount][vLockType]);
        cache_get_value_name_int(r, "nos", VehicleInfo[VehicleCount][vNos]);
        cache_get_value_name_int(r, "unlimited_nos", VehicleInfo[VehicleCount][vUnlimitedNos]);
        cache_get_value_name_int(r, "mod_spoiler", VehicleInfo[VehicleCount][vModSpoiler]);
        cache_get_value_name_int(r, "mod_hood", VehicleInfo[VehicleCount][vModHood]);
        cache_get_value_name_int(r, "mod_roof", VehicleInfo[VehicleCount][vModRoof]);
        cache_get_value_name_int(r, "mod_sideskirt_l", VehicleInfo[VehicleCount][vModSideskirtL]);
        cache_get_value_name_int(r, "mod_sideskirt_r", VehicleInfo[VehicleCount][vModSideskirtR]);
        cache_get_value_name_int(r, "mod_lamps", VehicleInfo[VehicleCount][vModLamps]);
        cache_get_value_name_int(r, "mod_nitro", VehicleInfo[VehicleCount][vModNitro]);
        cache_get_value_name_int(r, "mod_exhaust", VehicleInfo[VehicleCount][vModExhaust]);
        cache_get_value_name_int(r, "mod_wheels", VehicleInfo[VehicleCount][vModWheels]);
        cache_get_value_name_int(r, "mod_stereo", VehicleInfo[VehicleCount][vModStereo]);
        cache_get_value_name_int(r, "mod_hydraulics", VehicleInfo[VehicleCount][vModHydraulics]);
        cache_get_value_name_int(r, "mod_front_bumper", VehicleInfo[VehicleCount][vModFrontBumper]);
        cache_get_value_name_int(r, "mod_rear_bumper", VehicleInfo[VehicleCount][vModRearBumper]);
        cache_get_value_name_int(r, "mod_vent_right", VehicleInfo[VehicleCount][vModVentRight]);
        cache_get_value_name_int(r, "mod_vent_left", VehicleInfo[VehicleCount][vModVentLeft]);

        VehicleInfo[VehicleCount][vSpawnedID] = CreateVehicle(
            VehicleInfo[VehicleCount][vModel],
            VehicleInfo[VehicleCount][vX],
            VehicleInfo[VehicleCount][vY],
            VehicleInfo[VehicleCount][vZ],
            VehicleInfo[VehicleCount][vA],
            VehicleInfo[VehicleCount][vColor1],
            VehicleInfo[VehicleCount][vColor2],
            -1
        );
        SetVehicleVirtualWorld(VehicleInfo[VehicleCount][vSpawnedID], VehicleInfo[VehicleCount][vVW]);
        LinkVehicleToInterior(VehicleInfo[VehicleCount][vSpawnedID], VehicleInfo[VehicleCount][vInt]);

        // Important: increment first, because ER_ApplyVehicleMods has safety checks against VehicleCount.
        VehicleCount++;
        ER_ApplyVehicleMods(VehicleCount - 1);
        SetTimerEx("ER_ReapplyLoadedVehicleMods", 1000, false, "i", VehicleCount - 1);
    }
    printf("[Vehicles] Loaded %d vehicles.", VehicleCount);
    return 1;
}

forward ER_ReapplyLoadedVehicleMods(idx);
public ER_ReapplyLoadedVehicleMods(idx)
{
    if(idx < 0 || idx >= VehicleCount) return 0;
    return ER_ApplyVehicleMods(idx);
}

CMD:aveh(playerid, params[])
{
    new modelstr[32], model, c1 = 0, c2 = 0;
    if(!ER_IsAdmin(playerid, ADMIN_MOD)) return 0;
    if(sscanf(params, "s[32]D(0)D(0)", modelstr, c1, c2)) return ER_Send(playerid, COLOR_GREY, "USAGE: /aveh [model/name] [color1 optional] [color2 optional]");

    model = ER_FindVehicleModel(modelstr);
    if(model < 400 || model > 611) return ER_Send(playerid, COLOR_GREY, "Invalid vehicle model/name.");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
    x += (3.0 * floatsin(-a, degrees));
    y += (3.0 * floatcos(-a, degrees));
    new veh = CreateVehicle(model, x, y, z, a, c1, c2, -1);
    SetVehicleVirtualWorld(veh, GetPlayerVirtualWorld(playerid));
    LinkVehicleToInterior(veh, GetPlayerInterior(playerid));
    PutPlayerInVehicle(playerid, veh, 0);

    new msg[96];
    format(msg, sizeof(msg), "Spawned temporary %s (%d).", ER_GetVehicleModelName(model), model);
    return ER_Send(playerid, COLOR_GREEN, msg);
}

CMD:createveh(playerid, params[])
{
    new modelstr[32], model, c1 = 0, c2 = 0, q[512], Float:x, Float:y, Float:z, Float:a;
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return 0;
    if(sscanf(params, "s[32]D(0)D(0)", modelstr, c1, c2)) return ER_Send(playerid, COLOR_GREY, "USAGE: /createveh(icle) [model/name] [color1 optional] [color2 optional]");

    model = ER_FindVehicleModel(modelstr);
    if(model < 400 || model > 611) return ER_Send(playerid, COLOR_GREY, "Invalid vehicle model/name.");

    GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
    x += (3.0 * floatsin(-a, degrees));
    y += (3.0 * floatcos(-a, degrees));
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `vehicles` (`owner_pid`,`family_id`,`faction_id`,`model`,`color1`,`color2`,`paintjob`,`x`,`y`,`z`,`a`,`interior`,`vw`,`lock_type`,`enabled`) VALUES (0,0,0,%d,%d,%d,-1,%f,%f,%f,%f,%d,%d,0,1)",
        model, c1, c2, x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
    SetPVarInt(playerid, "CreateVehModel", model);
    SetPVarInt(playerid, "CreateVehColor1", c1);
    SetPVarInt(playerid, "CreateVehColor2", c2);
    SetPVarFloat(playerid, "CreateVehX", x);
    SetPVarFloat(playerid, "CreateVehY", y);
    SetPVarFloat(playerid, "CreateVehZ", z);
    SetPVarFloat(playerid, "CreateVehA", a);
    SetPVarInt(playerid, "CreateVehInt", GetPlayerInterior(playerid));
    SetPVarInt(playerid, "CreateVehVW", GetPlayerVirtualWorld(playerid));
    mysql_tquery(MainPipeline, q, "ER_OnAdminVehicleCreated", "i", playerid);
    return 1;
}
alias:createveh("createvehicle")

forward ER_OnAdminVehicleCreated(playerid);
public ER_OnAdminVehicleCreated(playerid)
{
    new vid = cache_insert_id();

    if(VehicleCount < MAX_DYNAMIC_VEHICLES)
    {
        new idx = VehicleCount;
        VehicleInfo[idx][vSQLID] = vid;
        VehicleInfo[idx][vOwnerPID] = 0;
        VehicleInfo[idx][vFamilyID] = 0;
        VehicleInfo[idx][vFactionID] = 0;
        VehicleInfo[idx][vModel] = GetPVarInt(playerid, "CreateVehModel");
        VehicleInfo[idx][vColor1] = GetPVarInt(playerid, "CreateVehColor1");
        VehicleInfo[idx][vColor2] = GetPVarInt(playerid, "CreateVehColor2");
        VehicleInfo[idx][vPaintjob] = -1;
        VehicleInfo[idx][vX] = GetPVarFloat(playerid, "CreateVehX");
        VehicleInfo[idx][vY] = GetPVarFloat(playerid, "CreateVehY");
        VehicleInfo[idx][vZ] = GetPVarFloat(playerid, "CreateVehZ");
        VehicleInfo[idx][vA] = GetPVarFloat(playerid, "CreateVehA");
        VehicleInfo[idx][vInt] = GetPVarInt(playerid, "CreateVehInt");
        VehicleInfo[idx][vVW] = GetPVarInt(playerid, "CreateVehVW");
        VehicleInfo[idx][vLockType] = 0;

        VehicleInfo[idx][vSpawnedID] = CreateVehicle(VehicleInfo[idx][vModel], VehicleInfo[idx][vX], VehicleInfo[idx][vY], VehicleInfo[idx][vZ], VehicleInfo[idx][vA], VehicleInfo[idx][vColor1], VehicleInfo[idx][vColor2], -1);
        SetVehicleVirtualWorld(VehicleInfo[idx][vSpawnedID], VehicleInfo[idx][vVW]);
        LinkVehicleToInterior(VehicleInfo[idx][vSpawnedID], VehicleInfo[idx][vInt]);
        PutPlayerInVehicle(playerid, VehicleInfo[idx][vSpawnedID], 0);
        VehicleCount++;
    }

    new msg[128], model = GetPVarInt(playerid, "CreateVehModel");
    format(msg, sizeof(msg), "Saved vehicle created. SQL ID: %d | %s (%d).", vid, ER_GetVehicleModelName(model), model);
    ER_Send(playerid, COLOR_GREEN, msg);
    return 1;
}

CMD:createpveh(playerid, params[])
{
    new pid, modelstr[32], model, q[512], c1 = 0, c2 = 0, Float:x, Float:y, Float:z, Float:a;
    if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return 0;
    if(sscanf(params, "ds[32]D(0)D(0)", pid, modelstr, c1, c2)) return ER_Send(playerid, COLOR_GREY, "USAGE: /createpveh [pID] [model/name] [color1 optional] [color2 optional]");

    model = ER_FindVehicleModel(modelstr);
    if(model < 400 || model > 611) return ER_Send(playerid, COLOR_GREY, "Invalid vehicle model/name.");

    GetPlayerPos(playerid, x, y, z); GetPlayerFacingAngle(playerid, a);
    x += (3.0 * floatsin(-a, degrees));
    y += (3.0 * floatcos(-a, degrees));
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `vehicles` (`owner_pid`,`family_id`,`faction_id`,`model`,`color1`,`color2`,`paintjob`,`x`,`y`,`z`,`a`,`interior`,`vw`,`enabled`) VALUES (%d,0,0,%d,%d,%d,-1,%f,%f,%f,%f,%d,%d,1)",
        pid, model, c1, c2, x, y, z, a, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
    mysql_tquery(MainPipeline, q, "ER_ReloadVehicles");
    return ER_Send(playerid, COLOR_GREEN, "Player vehicle created.");
}

CMD:vehicles(playerid, params[])
{
	new q[160];
	mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `vehicles` WHERE `owner_pid`=%d AND `enabled`=1 ORDER BY `id` ASC", PlayerInfo[playerid][pID]);
	mysql_tquery(MainPipeline, q, "ER_OnMyVehiclesDialog", "i", playerid);
	return 1;
}

forward ER_OnMyVehiclesDialog(playerid);
public ER_OnMyVehiclesDialog(playerid)
{
	new rows, list[2048], model, locktype, spawnid, Float:x, Float:y, Float:z, area[32];
	cache_get_row_count(rows);
	if(!rows) return ER_Send(playerid, COLOR_GREY, "You do not own any vehicles.");

	format(list, sizeof(list), "ID\tVehID\tVehicle\tLock\tLocation\n");
	for(new r; r < rows; r++)
	{
		new sqlid;
		cache_get_value_name_int(r, "id", sqlid);
		cache_get_value_name_int(r, "model", model);
		cache_get_value_name_int(r, "lock_type", locktype);
		cache_get_value_name_float(r, "x", x);
		cache_get_value_name_float(r, "y", y);
		cache_get_value_name_float(r, "z", z);

		spawnid = INVALID_VEHICLE_ID;
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx != -1) spawnid = VehicleInfo[idx][vSpawnedID];

		ER_GetVehicleAreaName(x, y, z, area, sizeof(area));
		format(list, sizeof(list), "%s%d\t%d\t%s\t%s\t%s\n", list, sqlid, spawnid, ER_GetVehicleModelName(model), ER_GetVehicleLockName(locktype), area);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_VEHICLES, DIALOG_STYLE_TABLIST_HEADERS, "My Vehicles", list, "Close", "");
	return 1;
}

CMD:trackveh(playerid, params[])
{
	new q[160];
	mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `vehicles` WHERE `owner_pid`=%d AND `enabled`=1 ORDER BY `id` ASC", PlayerInfo[playerid][pID]);
	mysql_tquery(MainPipeline, q, "ER_OnTrackVehicleList", "i", playerid);
	return 1;
}
alias:trackveh("trackvehicle")

forward ER_OnTrackVehicleList(playerid);
public ER_OnTrackVehicleList(playerid)
{
	new rows, list[2048], model, locktype, spawnid, Float:x, Float:y, Float:z, area[32];
	cache_get_row_count(rows);
	if(!rows) return ER_Send(playerid, COLOR_GREY, "You do not own any vehicles.");

	format(list, sizeof(list), "ID\tVehID\tVehicle\tLock\tLocation\n");
	for(new r; r < rows; r++)
	{
		new sqlid;
		cache_get_value_name_int(r, "id", sqlid);
		cache_get_value_name_int(r, "model", model);
		cache_get_value_name_int(r, "lock_type", locktype);
		cache_get_value_name_float(r, "x", x);
		cache_get_value_name_float(r, "y", y);
		cache_get_value_name_float(r, "z", z);

		spawnid = INVALID_VEHICLE_ID;
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx != -1) spawnid = VehicleInfo[idx][vSpawnedID];

		ER_GetVehicleAreaName(x, y, z, area, sizeof(area));
		format(list, sizeof(list), "%s%d\t%d\t%s\t%s\t%s\n", list, sqlid, spawnid, ER_GetVehicleModelName(model), ER_GetVehicleLockName(locktype), area);
	}
	ShowPlayerDialog(playerid, DIALOG_TRACK_VEHICLE, DIALOG_STYLE_TABLIST_HEADERS, "Track Vehicle", list, "Track", "Close");
	return 1;
}

CMD:allvehs(playerid, params[])
{
	if(!ER_IsAdmin(playerid, ADMIN_MOD)) return 0;
	mysql_tquery(MainPipeline, "SELECT v.*, a.username AS owner_name FROM `vehicles` v LEFT JOIN `accounts` a ON a.id=v.owner_pid WHERE v.enabled=1 ORDER BY v.id ASC LIMIT 150", "ER_OnAllVehiclesDialog", "i", playerid);
	return 1;
}
alias:allvehs("allvehicles")

CMD:editvehicles(playerid, params[])
{
	if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return 0;
	mysql_tquery(MainPipeline, "SELECT v.*, a.username AS owner_name FROM `vehicles` v LEFT JOIN `accounts` a ON a.id=v.owner_pid WHERE v.enabled=1 ORDER BY v.id ASC LIMIT 150", "ER_OnEditVehiclesDialog", "i", playerid);
	return 1;
}

forward ER_OnAllVehiclesDialog(playerid);
public ER_OnAllVehiclesDialog(playerid)
{
	new rows, list[4096], sqlid, model, ownerpid, familyid, factionid, spawnid, Float:x, Float:y, Float:z, area[32], owner[96], ownername[24];
	cache_get_row_count(rows);
	format(list, sizeof(list), "ID\tVehID\tModel\tOwner\tLocation\n");
	for(new r; r < rows; r++)
	{
		cache_get_value_name_int(r, "id", sqlid);
		cache_get_value_name_int(r, "model", model);
		cache_get_value_name_int(r, "owner_pid", ownerpid);
		cache_get_value_name_int(r, "family_id", familyid);
		cache_get_value_name_int(r, "faction_id", factionid);
		cache_get_value_name_float(r, "x", x);
		cache_get_value_name_float(r, "y", y);
		cache_get_value_name_float(r, "z", z);
		cache_get_value_name(r, "owner_name", ownername, sizeof(ownername));

		spawnid = INVALID_VEHICLE_ID;
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx != -1) spawnid = VehicleInfo[idx][vSpawnedID];

		ER_GetVehicleAreaName(x, y, z, area, sizeof(area));
		ER_GetVehicleOwnerText(ownerpid, familyid, factionid, ownername, owner, sizeof(owner));
		format(list, sizeof(list), "%s%d\t%d\t%s\t%s\t%s\n", list, sqlid, spawnid, ER_GetVehicleModelName(model), owner, area);
	}
	ShowPlayerDialog(playerid, DIALOG_ALL_VEHICLES, DIALOG_STYLE_TABLIST_HEADERS, "All Vehicles", list, "Close", "");
	return 1;
}

forward ER_OnEditVehiclesDialog(playerid);
public ER_OnEditVehiclesDialog(playerid)
{
	new rows, list[4096], sqlid, model, ownerpid, familyid, factionid, spawnid, Float:x, Float:y, Float:z, area[32], owner[96], ownername[24];
	cache_get_row_count(rows);
	if(!rows) return ER_Send(playerid, COLOR_GREY, "No vehicles found.");
	format(list, sizeof(list), "ID\tVehID\tModel\tOwner\tLocation\n");
	for(new r; r < rows; r++)
	{
		cache_get_value_name_int(r, "id", sqlid);
		cache_get_value_name_int(r, "model", model);
		cache_get_value_name_int(r, "owner_pid", ownerpid);
		cache_get_value_name_int(r, "family_id", familyid);
		cache_get_value_name_int(r, "faction_id", factionid);
		cache_get_value_name_float(r, "x", x);
		cache_get_value_name_float(r, "y", y);
		cache_get_value_name_float(r, "z", z);
		cache_get_value_name(r, "owner_name", ownername, sizeof(ownername));

		spawnid = INVALID_VEHICLE_ID;
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx != -1) spawnid = VehicleInfo[idx][vSpawnedID];

		ER_GetVehicleAreaName(x, y, z, area, sizeof(area));
		ER_GetVehicleOwnerText(ownerpid, familyid, factionid, ownername, owner, sizeof(owner));
		format(list, sizeof(list), "%s%d\t%d\t%s\t%s\t%s\n", list, sqlid, spawnid, ER_GetVehicleModelName(model), owner, area);
	}
	ShowPlayerDialog(playerid, DIALOG_EDIT_VEHICLE_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Edit Vehicles", list, "Edit", "Close");
	return 1;
}

CMD:editveh(playerid, params[])
{
	new vehid, sqlid;
	if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return 0;
	if(sscanf(params, "d", vehid)) return ER_Send(playerid, COLOR_GREY, "USAGE: /editveh(icle) [ingame vehicle id]");

	new idx = ER_FindVehicleBySpawnID(vehid);
	if(idx == -1) return ER_Send(playerid, COLOR_GREY, "That ingame vehicle ID is not a saved dynamic vehicle.");

	sqlid = VehicleInfo[idx][vSQLID];
	SetPVarInt(playerid, "EditingVehicleID", sqlid);
	ER_ShowVehicleEditor(playerid, sqlid);
	return 1;
}
alias:editveh("editvehicle")

CMD:deleteveh(playerid, params[])
{
	new vehid, q[128], sqlid = 0;
	if(!ER_IsAdmin(playerid, ADMIN_HEAD)) return 0;
	if(sscanf(params, "d", vehid)) return ER_Send(playerid, COLOR_GREY, "USAGE: /deleteveh(icle) [ingame vehicle id]");

	new idx = ER_FindVehicleBySpawnID(vehid);
	if(idx != -1) sqlid = VehicleInfo[idx][vSQLID];
	else sqlid = vehid; // fallback, useful if admin typed SQL ID

	mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `enabled`=0 WHERE `id`=%d", sqlid);
	mysql_tquery(MainPipeline, q, "ER_ReloadVehicles");
	return ER_Send(playerid, COLOR_GREEN, "Vehicle disabled/deleted.");
}
alias:deleteveh("deletevehicle")

stock ER_ShowVehicleEditor(playerid, sqlid)
{
	new q[256];
	mysql_format(MainPipeline, q, sizeof(q), "SELECT v.*, a.username AS owner_name FROM `vehicles` v LEFT JOIN `accounts` a ON a.id=v.owner_pid WHERE v.id=%d LIMIT 1", sqlid);
	mysql_tquery(MainPipeline, q, "ER_OnShowVehicleEditor", "i", playerid);
	return 1;
}

forward ER_OnShowVehicleEditor(playerid);
public ER_OnShowVehicleEditor(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(!rows) return ER_Send(playerid, COLOR_GREY, "Vehicle not found.");

	new sqlid, model, c1, c2, paintjob, nos, unlimitednos, hydraulics, wheels, ownerpid, familyid, factionid, spawnid, ownername[24], owner[96], list[1500], modsline[16];
	cache_get_value_name_int(0, "id", sqlid);
	cache_get_value_name_int(0, "model", model);
	cache_get_value_name_int(0, "color1", c1);
	cache_get_value_name_int(0, "color2", c2);
	cache_get_value_name_int(0, "paintjob", paintjob);
	cache_get_value_name_int(0, "nos", nos);
	cache_get_value_name_int(0, "unlimited_nos", unlimitednos);
	cache_get_value_name_int(0, "mod_hydraulics", hydraulics);
	cache_get_value_name_int(0, "mod_wheels", wheels);
	cache_get_value_name_int(0, "owner_pid", ownerpid);
	cache_get_value_name_int(0, "family_id", familyid);
	cache_get_value_name_int(0, "faction_id", factionid);
	cache_get_value_name(0, "owner_name", ownername, sizeof(ownername));

	spawnid = INVALID_VEHICLE_ID;
	new idx = ER_FindVehicleBySQLID(sqlid);
	if(idx != -1) spawnid = VehicleInfo[idx][vSpawnedID];

	ER_GetVehicleOwnerText(ownerpid, familyid, factionid, ownername, owner, sizeof(owner));

	if(ER_VehicleHasEditableMods(model)) format(modsline, sizeof(modsline), "\nMods");
	else modsline[0] = EOS;

	SetPVarInt(playerid, "EditingVehicleID", sqlid);
	format(list, sizeof(list),
		"Owner: %s\nModel: %s (%d)\nColor 1: %d\nColor 2: %d\nPaintjob: %s\nNOS: %s\nHydraulics: %s\nRims: %s%s\nPosition: Set here\nGoto Vehicle\nReset Vehicle\nReload This Vehicle\nDisable/Delete",
		owner, ER_GetVehicleModelName(model), model, c1, c2, ER_GetVehiclePaintjobName(paintjob), ER_GetVehicleNOSName(nos, unlimitednos), hydraulics ? "Installed" : "None", ER_GetVehicleWheelName(wheels), modsline);
	new title[64];
	format(title, sizeof(title), "Vehicle Editor - ID %d | VehID %d", sqlid, spawnid);
	ShowPlayerDialog(playerid, DIALOG_EDIT_VEHICLE_MENU, DIALOG_STYLE_LIST, title, list, "Select", "Close");
	return 1;
}

stock ER_SetVehicleOwner(playerid, sqlid, type, value)
{
	new q[256];
	if(type == 1)
	{
		mysql_format(MainPipeline, q, sizeof(q), "SELECT owner_pid,family_id,faction_id FROM `vehicles` WHERE `id`=%d LIMIT 1", sqlid);
		SetPVarInt(playerid, "SetOwnerType", type);
		SetPVarInt(playerid, "SetOwnerValue", value);
		mysql_tquery(MainPipeline, q, "ER_OnCheckVehicleOwnerSet", "ii", playerid, sqlid);
	}
	else if(type == 2)
	{
		mysql_format(MainPipeline, q, sizeof(q), "SELECT owner_pid,family_id,faction_id FROM `vehicles` WHERE `id`=%d LIMIT 1", sqlid);
		SetPVarInt(playerid, "SetOwnerType", type);
		SetPVarInt(playerid, "SetOwnerValue", value);
		mysql_tquery(MainPipeline, q, "ER_OnCheckVehicleOwnerSet", "ii", playerid, sqlid);
	}
	else if(type == 3)
	{
		mysql_format(MainPipeline, q, sizeof(q), "SELECT owner_pid,family_id,faction_id FROM `vehicles` WHERE `id`=%d LIMIT 1", sqlid);
		SetPVarInt(playerid, "SetOwnerType", type);
		SetPVarInt(playerid, "SetOwnerValue", value);
		mysql_tquery(MainPipeline, q, "ER_OnCheckVehicleOwnerSet", "ii", playerid, sqlid);
	}
	return 1;
}

forward ER_OnCheckVehicleOwnerSet(playerid, sqlid);
public ER_OnCheckVehicleOwnerSet(playerid, sqlid)
{
	new rows, ownerpid, familyid, factionid, type, value, q[256], err[128];
	cache_get_row_count(rows);
	if(!rows) return ER_Send(playerid, COLOR_GREY, "Vehicle not found.");

	cache_get_value_name_int(0, "owner_pid", ownerpid);
	cache_get_value_name_int(0, "family_id", familyid);
	cache_get_value_name_int(0, "faction_id", factionid);

	type = GetPVarInt(playerid, "SetOwnerType");
	value = GetPVarInt(playerid, "SetOwnerValue");

	if(value > 0)
	{
		if(type != 1 && ownerpid > 0)
		{
			format(err, sizeof(err), "Error: this vehicle is already owned by Player: %d.", ownerpid);
			ER_Send(playerid, COLOR_LIGHTRED, err);
			return ER_ShowVehicleEditor(playerid, sqlid);
		}
		if(type != 2 && familyid > 0)
		{
			format(err, sizeof(err), "Error: this vehicle is already owned by Family: %d.", familyid);
			ER_Send(playerid, COLOR_LIGHTRED, err);
			return ER_ShowVehicleEditor(playerid, sqlid);
		}
		if(type != 3 && factionid > 0)
		{
			format(err, sizeof(err), "Error: this vehicle is already owned by Faction: %d.", factionid);
			ER_Send(playerid, COLOR_LIGHTRED, err);
			return ER_ShowVehicleEditor(playerid, sqlid);
		}
	}

	switch(type)
	{
		case 1: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `owner_pid`=%d,`family_id`=0,`faction_id`=0 WHERE `id`=%d", value, sqlid);
		case 2: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `owner_pid`=0,`family_id`=%d,`faction_id`=0 WHERE `id`=%d", value, sqlid);
		case 3: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `owner_pid`=0,`family_id`=0,`faction_id`=%d WHERE `id`=%d", value, sqlid);
		default: return ER_ShowVehicleEditor(playerid, sqlid);
	}
	mysql_tquery(MainPipeline, q);
	new idx = ER_FindVehicleBySQLID(sqlid);
	if(idx != -1)
	{
		switch(type)
		{
			case 1: { VehicleInfo[idx][vOwnerPID] = value; VehicleInfo[idx][vFamilyID] = 0; VehicleInfo[idx][vFactionID] = 0; }
			case 2: { VehicleInfo[idx][vOwnerPID] = 0; VehicleInfo[idx][vFamilyID] = value; VehicleInfo[idx][vFactionID] = 0; }
			case 3: { VehicleInfo[idx][vOwnerPID] = 0; VehicleInfo[idx][vFamilyID] = 0; VehicleInfo[idx][vFactionID] = value; }
		}
	}
	ER_Send(playerid, COLOR_GREEN, "Vehicle owner updated.");
	return ER_ShowVehicleEditor(playerid, sqlid);
}

stock ER_VehicleDialog(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_TRACK_VEHICLE)
	{
		if(!response) return 1;
		new q[160];
		mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `vehicles` WHERE `owner_pid`=%d AND `enabled`=1 ORDER BY `id` ASC LIMIT %d,1", PlayerInfo[playerid][pID], listitem);
		mysql_tquery(MainPipeline, q, "ER_OnTrackVehicleSelect", "i", playerid);
		return 1;
	}

	if(dialogid == DIALOG_EDIT_VEHICLE_LIST)
	{
		if(!response) return 1;
		new q[160];
		mysql_format(MainPipeline, q, sizeof(q), "SELECT `id` FROM `vehicles` WHERE `enabled`=1 ORDER BY `id` ASC LIMIT %d,1", listitem);
		mysql_tquery(MainPipeline, q, "ER_OnEditVehicleListSelect", "i", playerid);
		return 1;
	}

	if(dialogid == DIALOG_MY_VEHICLES || dialogid == DIALOG_ALL_VEHICLES)
	{
		return 1;
	}

	if(dialogid == DIALOG_EDIT_VEHICLE_MENU)
	{
		if(!response) return 1;
		new sqlid = GetPVarInt(playerid, "EditingVehicleID");
		if(sqlid <= 0) return 1;

		new idxmenu = ER_FindVehicleBySQLID(sqlid);
		new hasmods = (idxmenu != -1 && ER_VehicleHasEditableMods(VehicleInfo[idxmenu][vModel]));

		// Map visible row to action because "Mods" is hidden when unsupported.
		new action = listitem;
		if(!hasmods && listitem >= 8) action++;

		switch(action)
		{
			case 0: ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_OWNER, DIALOG_STYLE_LIST, "Vehicle Owner", "Player\nFamily (SQL ID)\nFaction (SQL ID)\nClear Owner", "Select", "Back");
			case 1: ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_MODEL, DIALOG_STYLE_INPUT, "Vehicle Model", "Enter model ID or vehicle name:", "Save", "Back");
			case 2: ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_COLOR1, DIALOG_STYLE_INPUT, "Vehicle Color 1", "Enter color 1 number:", "Save", "Back");
			case 3: ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_COLOR2, DIALOG_STYLE_INPUT, "Vehicle Color 2", "Enter color 2 number:", "Save", "Back");
			case 4: ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_PAINTJOB, DIALOG_STYLE_LIST, "Vehicle Paintjob", "None\nPaintjob 1\nPaintjob 2\nPaintjob 3", "Select", "Back");
			case 5: ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_NOS, DIALOG_STYLE_LIST, "Vehicle NOS", "Unlimited NOS\nNone\nNOS 2x\nNOS 5x\nNOS 10x", "Select", "Back");
			case 6: ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_HYDRAULICS, DIALOG_STYLE_LIST, "Vehicle Hydraulics", "None\nHydraulics", "Select", "Back");
			case 7: ER_ShowVehicleRimsList(playerid);
			case 8:
			{
				new idx = ER_FindVehicleBySQLID(sqlid);
				if(idx == -1) return ER_ShowVehicleEditor(playerid, sqlid);

				if(!ER_VehicleHasEditableMods(VehicleInfo[idx][vModel]))
				{
					ER_Send(playerid, COLOR_GREY, "This vehicle does not have any compatible body modifications.");
					return ER_ShowVehicleEditor(playerid, sqlid);
				}
				ER_ShowVehicleModCategories(playerid);
			}
			case 9:
			{
				new Float:x, Float:y, Float:z, Float:a, interior, vw, q[256];
				ER_GetBestVehicleEditPositionEx(playerid, sqlid, x, y, z, a, interior, vw);

				new idx = ER_FindVehicleBySQLID(sqlid);
				if(idx != -1)
				{
					if(GetPlayerVehicleID(playerid) == VehicleInfo[idx][vSpawnedID]) ER_SaveVehicleTuning(idx);

					VehicleInfo[idx][vX] = x;
					VehicleInfo[idx][vY] = y;
					VehicleInfo[idx][vZ] = z;
					VehicleInfo[idx][vA] = a;
					VehicleInfo[idx][vInt] = interior;
					VehicleInfo[idx][vVW] = vw;

					mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `x`=%f,`y`=%f,`z`=%f,`a`=%f,`interior`=%d,`vw`=%d WHERE `id`=%d", x, y, z, a, interior, vw, sqlid);
					mysql_tquery(MainPipeline, q);

					ER_RespawnSavedVehicle(idx);
				}
				ER_Send(playerid, COLOR_GREEN, "Vehicle position has been saved and respawned at the exact location.");
				ER_ShowVehicleEditor(playerid, sqlid);
			}
			case 10:
			{
				new q[128];
				mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `vehicles` WHERE `id`=%d LIMIT 1", sqlid);
				mysql_tquery(MainPipeline, q, "ER_OnGotoVehicleSQL", "i", playerid);
			}
			case 11:
			{
				new idx = ER_FindVehicleBySQLID(sqlid);
				if(idx != -1)
				{
					ER_RespawnSavedVehicle(idx);
				}
				ER_Send(playerid, COLOR_GREEN, "Vehicle has been reset to its saved position.");
				ER_ShowVehicleEditor(playerid, sqlid);
			}
			case 12:
			{
				new idx = ER_FindVehicleBySQLID(sqlid);
				if(idx != -1)
				{
					ER_SaveVehicleTuning(idx);
					ER_RespawnSavedVehicle(idx);
				}
				ER_Send(playerid, COLOR_GREEN, "Vehicle reloaded successfully.");
				ER_ShowVehicleEditor(playerid, sqlid);
			}
			case 13:
			{
				new q[128];
				mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `enabled`=0 WHERE `id`=%d", sqlid);
				mysql_tquery(MainPipeline, q, "ER_ReloadVehicles");
				ER_Send(playerid, COLOR_GREEN, "Vehicle disabled/deleted.");
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_EDIT_VEH_OWNER)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));

		if(listitem == 0)
		{
			return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_OWNER_PLAYER_TYPE, DIALOG_STYLE_LIST, "Player Owner", "Online Player\nOffline Player SQL ID", "Select", "Back");
		}
		if(listitem == 1)
		{
			return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_SET_FAMILY, DIALOG_STYLE_INPUT, "Family Owner", "Enter family SQL ID:", "Save", "Back");
		}
		if(listitem == 2)
		{
			return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_SET_FACTION, DIALOG_STYLE_INPUT, "Faction Owner", "Enter faction SQL ID:", "Save", "Back");
		}

		new q[128], sqlid = GetPVarInt(playerid, "EditingVehicleID");
		mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `owner_pid`=0,`family_id`=0,`faction_id`=0 WHERE `id`=%d", sqlid);
		mysql_tquery(MainPipeline, q, "ER_ReloadVehicles");
		ER_Send(playerid, COLOR_GREEN, "Vehicle owner cleared.");
		return ER_ShowVehicleEditor(playerid, sqlid);
	}

	if(dialogid == DIALOG_EDIT_VEH_OWNER_PLAYER_TYPE)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));

		if(listitem == 0)
		{
			new list[1024], count = 0, name[MAX_PLAYER_NAME];
			list[0] = EOS;
			foreach(new i : Player)
			{
				if(PlayerInfo[i][pLoggedIn] && PlayerInfo[i][pID] > 0)
				{
					GetPlayerName(i, name, sizeof(name));
					new pvarname[24]; format(pvarname, sizeof(pvarname), "OwnerOnline%d", count); SetPVarInt(playerid, pvarname, i);
					format(list, sizeof(list), "%s%d\t%s\tSQL ID: %d\n", list, i, name, PlayerInfo[i][pID]);
					count++;
				}
			}
			if(!count) return ER_Send(playerid, COLOR_GREY, "No online players found.");
			return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_OWNER_ONLINE_PLAYER, DIALOG_STYLE_TABLIST, "Select Online Player", list, "Select", "Back");
		}
		return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_SET_PLAYER, DIALOG_STYLE_INPUT, "Offline Player Owner", "Enter player SQL ID:", "Save", "Back");
	}

	if(dialogid == DIALOG_EDIT_VEH_OWNER_ONLINE_PLAYER)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		new pvarname[24]; format(pvarname, sizeof(pvarname), "OwnerOnline%d", listitem); new target = GetPVarInt(playerid, pvarname);
		if(!IsPlayerConnected(target) || PlayerInfo[target][pID] <= 0) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		return ER_SetVehicleOwner(playerid, GetPVarInt(playerid, "EditingVehicleID"), 1, PlayerInfo[target][pID]);
	}

	if(dialogid == DIALOG_EDIT_VEH_SET_PLAYER || dialogid == DIALOG_EDIT_VEH_SET_FAMILY || dialogid == DIALOG_EDIT_VEH_SET_FACTION)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		new value = strval(inputtext), sqlid = GetPVarInt(playerid, "EditingVehicleID");
		if(value < 0) value = 0;
		if(dialogid == DIALOG_EDIT_VEH_SET_PLAYER) return ER_SetVehicleOwner(playerid, sqlid, 1, value);
		if(dialogid == DIALOG_EDIT_VEH_SET_FAMILY) return ER_SetVehicleOwner(playerid, sqlid, 2, value);
		if(dialogid == DIALOG_EDIT_VEH_SET_FACTION) return ER_SetVehicleOwner(playerid, sqlid, 3, value);
	}

	if(dialogid == DIALOG_EDIT_VEH_MODEL || dialogid == DIALOG_EDIT_VEH_COLOR1 || dialogid == DIALOG_EDIT_VEH_COLOR2)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));

		new sqlid = GetPVarInt(playerid, "EditingVehicleID"), q[160], value;
		if(dialogid == DIALOG_EDIT_VEH_MODEL)
		{
			value = ER_FindVehicleModel(inputtext);
			if(value < 400 || value > 611)
			{
				ER_Send(playerid, COLOR_GREY, "Invalid vehicle model/name.");
				return ER_ShowVehicleEditor(playerid, sqlid);
			}
			mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `model`=%d WHERE `id`=%d", value, sqlid);
		}
		else if(dialogid == DIALOG_EDIT_VEH_COLOR1)
		{
			value = strval(inputtext);
			mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `color1`=%d WHERE `id`=%d", value, sqlid);
		}
		else
		{
			value = strval(inputtext);
			mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `color2`=%d WHERE `id`=%d", value, sqlid);
		}
		mysql_tquery(MainPipeline, q);

		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx != -1)
		{
			if(dialogid == DIALOG_EDIT_VEH_MODEL)
			{
				VehicleInfo[idx][vModel] = value;
				ER_ResetIncompatibleVehicleMods(idx);
				ER_RespawnSavedVehicle(idx);
			}
			else if(dialogid == DIALOG_EDIT_VEH_COLOR1)
			{
				VehicleInfo[idx][vColor1] = value;
				ChangeVehicleColor(VehicleInfo[idx][vSpawnedID], VehicleInfo[idx][vColor1], VehicleInfo[idx][vColor2]);
				ER_ApplyVehicleMods(idx);
			}
			else
			{
				VehicleInfo[idx][vColor2] = value;
				ChangeVehicleColor(VehicleInfo[idx][vSpawnedID], VehicleInfo[idx][vColor1], VehicleInfo[idx][vColor2]);
				ER_ApplyVehicleMods(idx);
			}
		}

		ER_Send(playerid, COLOR_GREEN, "Vehicle updated.");
		return ER_ShowVehicleEditor(playerid, sqlid);
	}

	if(dialogid == DIALOG_EDIT_VEH_PAINTJOB)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));

		new sqlid = GetPVarInt(playerid, "EditingVehicleID");
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx == -1) return ER_ShowVehicleEditor(playerid, sqlid);

		if(!ER_CanVehicleUsePaintjob(VehicleInfo[idx][vModel]) && listitem > 0)
		{
			ER_Send(playerid, COLOR_GREY, "This vehicle model does not support paintjobs.");
			return ER_ShowVehicleEditor(playerid, sqlid);
		}

		new paintjob = -1;
		switch(listitem)
		{
			case 0: paintjob = -1;
			case 1: paintjob = 0;
			case 2: paintjob = 1;
			case 3: paintjob = 2;
		}

		VehicleInfo[idx][vPaintjob] = paintjob;

		new q[128];
		mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `paintjob`=%d WHERE `id`=%d", paintjob, sqlid);
		mysql_tquery(MainPipeline, q);

		if(paintjob >= 0) ChangeVehiclePaintjob(VehicleInfo[idx][vSpawnedID], paintjob);
		ChangeVehicleColor(VehicleInfo[idx][vSpawnedID], VehicleInfo[idx][vColor1], VehicleInfo[idx][vColor2]);
		ER_ApplyVehicleMods(idx);

		ER_Send(playerid, COLOR_GREEN, "Vehicle paintjob updated.");
		return ER_ShowVehicleEditor(playerid, sqlid);
	}

	if(dialogid == DIALOG_EDIT_VEH_NOS)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));

		new sqlid = GetPVarInt(playerid, "EditingVehicleID");
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx == -1) return ER_ShowVehicleEditor(playerid, sqlid);

		if(!ER_CanVehicleUseNOS(VehicleInfo[idx][vModel]))
		{
			ER_Send(playerid, COLOR_GREY, "This vehicle model does not support NOS.");
			return ER_ShowVehicleEditor(playerid, sqlid);
		}

		new nos = 0, unlimited = 0;
		switch(listitem)
		{
			case 0: { nos = 1010; unlimited = 1; }
			case 1: { nos = 0; unlimited = 0; }
			case 2: { nos = 1009; unlimited = 0; }
			case 3: { nos = 1008; unlimited = 0; }
			case 4: { nos = 1010; unlimited = 0; }
		}

		VehicleInfo[idx][vNos] = nos;
		VehicleInfo[idx][vUnlimitedNos] = unlimited;
		VehicleInfo[idx][vModNitro] = nos;

		new q[180];
		mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `nos`=%d,`unlimited_nos`=%d,`mod_nitro`=%d WHERE `id`=%d", nos, unlimited, nos, sqlid);
		mysql_tquery(MainPipeline, q);

		if(nos > 0) ER_SafeAddVehicleComponent(idx, nos);
		ER_Send(playerid, COLOR_GREEN, "Vehicle NOS updated.");
		return ER_ShowVehicleEditor(playerid, sqlid);
	}




	if(dialogid == DIALOG_EDIT_VEH_RIMS)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));

		new sqlid = GetPVarInt(playerid, "EditingVehicleID");
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx == -1) return ER_ShowVehicleEditor(playerid, sqlid);

		new pvar[32];
		format(pvar, sizeof(pvar), "VehRimComp%d", listitem);
		new rim = GetPVarInt(playerid, pvar);

		new oldrim = VehicleInfo[idx][vModWheels];
		VehicleInfo[idx][vModWheels] = rim;

		new q[160];
		mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `mod_wheels`=%d WHERE `id`=%d", rim, sqlid);
		mysql_tquery(MainPipeline, q);

		if(oldrim > 0 && VehicleInfo[idx][vSpawnedID] != INVALID_VEHICLE_ID)
		{
			RemoveVehicleComponent(VehicleInfo[idx][vSpawnedID], oldrim);
		}
		if(rim > 0)
		{
			ER_SafeAddVehicleComponent(idx, rim);
		}

		ER_Send(playerid, COLOR_GREEN, "Vehicle rims updated.");
		return ER_ShowVehicleEditor(playerid, sqlid);
	}


	if(dialogid == DIALOG_EDIT_VEH_HYDRAULICS)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));

		new sqlid = GetPVarInt(playerid, "EditingVehicleID");
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx == -1) return ER_ShowVehicleEditor(playerid, sqlid);

		new oldhydraulics = VehicleInfo[idx][vModHydraulics];
		new hydraulics = (listitem == 1) ? 1087 : 0;
		VehicleInfo[idx][vModHydraulics] = hydraulics;

		new q[160];
		mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `mod_hydraulics`=%d WHERE `id`=%d", hydraulics, sqlid);
		mysql_tquery(MainPipeline, q);

		if(oldhydraulics > 0 && VehicleInfo[idx][vSpawnedID] != INVALID_VEHICLE_ID)
		{
			RemoveVehicleComponent(VehicleInfo[idx][vSpawnedID], oldhydraulics);
		}
		if(hydraulics > 0)
		{
			ER_SafeAddVehicleComponent(idx, hydraulics);
		}

		ER_Send(playerid, COLOR_GREEN, "Vehicle hydraulics updated.");
		return ER_ShowVehicleEditor(playerid, sqlid);
	}


	if(dialogid == DIALOG_EDIT_VEH_MODS)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));

		new pvar[32], modslot;
		format(pvar, sizeof(pvar), "VehModSlot%d", listitem);
		modslot = GetPVarInt(playerid, pvar);
		SetPVarInt(playerid, "EditingVehicleModSlot", modslot);
		return ER_ShowVehicleComponentList(playerid, modslot);
	}

	if(dialogid == DIALOG_EDIT_VEH_MOD_SELECT)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));

		new sqlid = GetPVarInt(playerid, "EditingVehicleID");
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx == -1) return ER_ShowVehicleEditor(playerid, sqlid);

		new pvar[32];
		format(pvar, sizeof(pvar), "VehModComp%d", listitem);

		new component = GetPVarInt(playerid, pvar);
		new editSlot = GetPVarInt(playerid, "EditingVehicleModSlot");

		new oldcomponent = ER_GetVehicleModComponentBySlot(idx, editSlot);
		new oldcomponent2 = (editSlot == ER_MOD_SKIRT) ? VehicleInfo[idx][vModSideskirtR] : 0;

		if(component > 0 && !ER_IsComponentCompatible(VehicleInfo[idx][vModel], component))
		{
			ER_Send(playerid, COLOR_GREY, "This component is not compatible with the selected vehicle.");
			return ER_ShowVehicleEditor(playerid, sqlid);
		}

		switch(editSlot)
		{
			case ER_MOD_SPOILER: VehicleInfo[idx][vModSpoiler] = component;
			case ER_MOD_HOOD: VehicleInfo[idx][vModHood] = component;
			case ER_MOD_ROOF: VehicleInfo[idx][vModRoof] = component;
			case ER_MOD_SKIRT: ER_SetVehicleSideSkirts(idx, component);
			case ER_MOD_LAMPS: VehicleInfo[idx][vModLamps] = component;
			case ER_MOD_EXHAUST: VehicleInfo[idx][vModExhaust] = component;
			case ER_MOD_FRONT: VehicleInfo[idx][vModFrontBumper] = component;
			case ER_MOD_REAR: VehicleInfo[idx][vModRearBumper] = component;
			case ER_MOD_VENT:
			{
				VehicleInfo[idx][vModVentRight] = component;
				VehicleInfo[idx][vModVentLeft] = 0;
			}
		}

		new q[900];
		mysql_format(MainPipeline, q, sizeof(q),
			"UPDATE `vehicles` SET `nos`=%d,`unlimited_nos`=%d,`mod_spoiler`=%d,`mod_hood`=%d,`mod_roof`=%d,`mod_sideskirt_l`=%d,`mod_sideskirt_r`=%d,`mod_lamps`=%d,`mod_nitro`=%d,`mod_exhaust`=%d,`mod_wheels`=%d,`mod_stereo`=%d,`mod_hydraulics`=%d,`mod_front_bumper`=%d,`mod_rear_bumper`=%d,`mod_vent_right`=%d,`mod_vent_left`=%d WHERE `id`=%d",
			VehicleInfo[idx][vNos], VehicleInfo[idx][vUnlimitedNos], VehicleInfo[idx][vModSpoiler], VehicleInfo[idx][vModHood], VehicleInfo[idx][vModRoof],
			VehicleInfo[idx][vModSideskirtL], VehicleInfo[idx][vModSideskirtR], VehicleInfo[idx][vModLamps], VehicleInfo[idx][vModNitro],
			VehicleInfo[idx][vModExhaust], VehicleInfo[idx][vModWheels], VehicleInfo[idx][vModStereo], VehicleInfo[idx][vModHydraulics],
			VehicleInfo[idx][vModFrontBumper], VehicleInfo[idx][vModRearBumper], VehicleInfo[idx][vModVentRight], VehicleInfo[idx][vModVentLeft],
			sqlid
		);
		mysql_tquery(MainPipeline, q);

		if(oldcomponent > 0 && VehicleInfo[idx][vSpawnedID] != INVALID_VEHICLE_ID)
		{
			RemoveVehicleComponent(VehicleInfo[idx][vSpawnedID], oldcomponent);
		}
		if(oldcomponent2 > 0 && VehicleInfo[idx][vSpawnedID] != INVALID_VEHICLE_ID)
		{
			RemoveVehicleComponent(VehicleInfo[idx][vSpawnedID], oldcomponent2);
		}

		if(editSlot == ER_MOD_SKIRT)
		{
			if(VehicleInfo[idx][vModSideskirtL] > 0) ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModSideskirtL]);
			if(VehicleInfo[idx][vModSideskirtR] > 0) ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModSideskirtR]);
		}
		else if(component > 0)
		{
			ER_SafeAddVehicleComponent(idx, component);
		}

		ER_Send(playerid, COLOR_GREEN, "Vehicle modification updated.");
		return ER_ShowVehicleEditor(playerid, sqlid);
	}

	return 0;
}

forward ER_OnEditVehicleListSelect(playerid);
public ER_OnEditVehicleListSelect(playerid)
{
	new rows, sqlid;
	cache_get_row_count(rows);
	if(!rows) return ER_Send(playerid, COLOR_GREY, "Vehicle not found.");
	cache_get_value_name_int(0, "id", sqlid);
	SetPVarInt(playerid, "EditingVehicleID", sqlid);
	return ER_ShowVehicleEditor(playerid, sqlid);
}

forward ER_OnTrackVehicleSelect(playerid);
public ER_OnTrackVehicleSelect(playerid)
{
	new rows, Float:x, Float:y, Float:z, sqlid, model;
	cache_get_row_count(rows);
	if(!rows) return ER_Send(playerid, COLOR_GREY, "Vehicle not found.");

	cache_get_value_name_int(0, "id", sqlid);
	cache_get_value_name_int(0, "model", model);
	cache_get_value_name_float(0, "x", x);
	cache_get_value_name_float(0, "y", y);
	cache_get_value_name_float(0, "z", z);

	if(VehicleTrackIcon[playerid] != -1) DestroyDynamicMapIcon(VehicleTrackIcon[playerid]);
	VehicleTrackIcon[playerid] = CreateDynamicMapIcon(x, y, z, 55, 0xFF0000FF, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), playerid, 6000.0, MAPICON_GLOBAL);

	new msg[128];
	format(msg, sizeof(msg), "Tracking vehicle %d: %s. Red marker added to your map.", sqlid, ER_GetVehicleModelName(model));
	return ER_Send(playerid, COLOR_GREEN, msg);
}

forward ER_OnGotoVehicleSQL(playerid);
public ER_OnGotoVehicleSQL(playerid)
{
	new rows, Float:x, Float:y, Float:z, interior, vw;
	cache_get_row_count(rows);
	if(!rows) return ER_Send(playerid, COLOR_GREY, "Vehicle not found.");
	cache_get_value_name_float(0, "x", x);
	cache_get_value_name_float(0, "y", y);
	cache_get_value_name_float(0, "z", z);
	cache_get_value_name_int(0, "interior", interior);
	cache_get_value_name_int(0, "vw", vw);
	SetPlayerInterior(playerid, interior);
	SetPlayerVirtualWorld(playerid, vw);
	SetPlayerPos(playerid, x + 2.0, y, z);
	return 1;
}



stock ER_GetBestVehicleEditPosition(playerid, &Float:x, &Float:y, &Float:z, &Float:a)
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid != 0)
    {
        GetVehiclePos(vehicleid, x, y, z);
        GetVehicleZAngle(vehicleid, a);
        return vehicleid;
    }

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    return 0;
}


stock ER_PlayerCanUseVehicle(playerid, vehicleid)
{
    new idx = ER_FindVehicleBySpawnID(vehicleid);
    if(idx == -1) return 0;

    if(VehicleInfo[idx][vOwnerPID] > 0 && VehicleInfo[idx][vOwnerPID] == PlayerInfo[playerid][pID])
    {
        ER_Send(playerid, COLOR_GREEN, "You are the owner of this vehicle.");
        return 1;
    }

    if(VehicleInfo[idx][vFactionID] > 0 && VehicleInfo[idx][vFactionID] == PlayerInfo[playerid][pFaction])
    {
        ER_Send(playerid, COLOR_GREEN, "You are in a faction that owns this vehicle.");
        return 1;
    }

    if(VehicleInfo[idx][vFamilyID] > 0 && VehicleInfo[idx][vFamilyID] == PlayerInfo[playerid][pFamily])
    {
        ER_Send(playerid, COLOR_GREEN, "You are in a family that owns this vehicle.");
        return 1;
    }

    return 0;
}

stock ER_PlayerOwnsVehicleDirectly(playerid, vehicleid)
{
    new idx = ER_FindVehicleBySpawnID(vehicleid);
    if(idx == -1) return 0;
    return (VehicleInfo[idx][vOwnerPID] > 0 && VehicleInfo[idx][vOwnerPID] == PlayerInfo[playerid][pID]);
}


CMD:veh(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == 0) return ER_Send(playerid, COLOR_GREY, "You must be inside a vehicle.");
    ER_PlayerCanUseVehicle(playerid, vehicleid);

    if(isnull(params)) return ER_Send(playerid, COLOR_GREY, "USAGE: /veh(icle) [engine/lights/hood/trunk/windows]");
    return ER_Send(playerid, COLOR_GREY, "Vehicle component command placeholder. Engine/lights/hood/trunk/windows logic comes next.");
}
alias:veh("vehicle")

CMD:vehlock(playerid, params[])
{
    return ER_Send(playerid, COLOR_GREY, "Vehicle lock/unlock placeholder. Ownership lock logic comes next.");
}
alias:vehlock("vehiclelock")

CMD:park(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid == 0)
    {
        return ER_Send(playerid, COLOR_GREY, "You must be inside the vehicle you wish to park.");
    }

    if(!ER_PlayerOwnsVehicleDirectly(playerid, vehicleid))
    {
        return ER_Send(playerid, COLOR_GREY, "You cannot park a vehicle you do not personally own.");
    }

    new idx = ER_FindVehicleBySpawnID(vehicleid);

    if(idx == -1)
    {
        return ER_Send(playerid, COLOR_GREY, "This vehicle is not a saved dynamic vehicle.");
    }

    GetVehiclePos(vehicleid, VehicleInfo[idx][vX], VehicleInfo[idx][vY], VehicleInfo[idx][vZ]);
    GetVehicleZAngle(vehicleid, VehicleInfo[idx][vA]);
    VehicleInfo[idx][vInt] = GetPlayerInterior(playerid);
    VehicleInfo[idx][vVW] = GetPlayerVirtualWorld(playerid);

    ER_SaveVehicleTuning(idx);

    new q[256];
    mysql_format(MainPipeline, q, sizeof(q),
        "UPDATE `vehicles` SET `x`=%f,`y`=%f,`z`=%f,`a`=%f,`interior`=%d,`vw`=%d WHERE `id`=%d",
        VehicleInfo[idx][vX], VehicleInfo[idx][vY], VehicleInfo[idx][vZ], VehicleInfo[idx][vA],
        VehicleInfo[idx][vInt], VehicleInfo[idx][vVW], VehicleInfo[idx][vSQLID]
    );
    mysql_tquery(MainPipeline, q);

    ER_RespawnSavedVehicle(idx, playerid);

    return ER_Send(playerid, COLOR_GREEN, "Your vehicle has been parked successfully.");
}


forward ER_ReapplyVehicleModsTimer(vehicleid);
public ER_ReapplyVehicleModsTimer(vehicleid)
{
    new idx = ER_FindVehicleBySpawnID(vehicleid);
    if(idx == -1) return 0;
    ER_ApplyVehicleMods(idx);
    return 1;
}

stock ER_OnVehicleSpawn(vehicleid)
{
    new idx = ER_FindVehicleBySpawnID(vehicleid);
    if(idx == -1) return 0;
    SetTimerEx("ER_ReapplyVehicleModsTimer", 500, false, "i", vehicleid);
    return 1;
}

