#if defined _ER_VEHICLES_INCLUDED
    #endinput
#endif
#define _ER_VEHICLES_INCLUDED

new VehicleTrackIcon[MAX_PLAYERS] = { -1, ... };

// Driver vehicle HUD copied/adapted from NGRP style textdraws.
new PlayerText:ER_VehHudBox[MAX_PLAYERS];
new PlayerText:ER_VehHudTitle[MAX_PLAYERS];
new PlayerText:ER_VehHudDivider[MAX_PLAYERS];
new PlayerText:ER_VehHudSpeed[MAX_PLAYERS];
new PlayerText:ER_VehHudFuel[MAX_PLAYERS];
new PlayerText:ER_VehHudMileage[MAX_PLAYERS];
new PlayerText:ER_VehHudSeatbelt[MAX_PLAYERS];
new PlayerText:ER_VehHudEngine[MAX_PLAYERS];
new PlayerText:ER_VehHudLights[MAX_PLAYERS];
new PlayerText:ER_VehHudHood[MAX_PLAYERS];
new PlayerText:ER_VehHudTrunk[MAX_PLAYERS];
new bool:ER_VehHudCreated[MAX_PLAYERS];
new bool:ER_VehHudVisible[MAX_PLAYERS];
new bool:ER_PlayerSeatbelt[MAX_PLAYERS];
new bool:ER_VehHudLastPosValid[MAX_PLAYERS];
new Float:ER_VehHudLastX[MAX_PLAYERS];
new Float:ER_VehHudLastY[MAX_PLAYERS];
new Float:ER_VehHudLastZ[MAX_PLAYERS];


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

stock ER_NormalizeVehicleSearch(const src[], dest[], size)
{
    new j = 0;
    for(new i = 0; src[i] != EOS && j < size - 1; i++)
    {
        if(src[i] == ' ' || src[i] == '_' || src[i] == '-' || src[i] == '.' || src[i] == '/' || src[i] == '\\')
        {
            continue;
        }
        dest[j++] = src[i];
    }
    dest[j] = EOS;
    return 1;
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

    new search[32], name[32];
    ER_NormalizeVehicleSearch(input, search, sizeof(search));

    // Very short / special aliases.
    if(!strcmp(search, "pd", true) || !strcmp(search, "lspd", true) || !strcmp(search, "policels", true) || !strcmp(search, "lapd", true)) return 596;
    if(!strcmp(search, "sfpd", true) || !strcmp(search, "policesf", true)) return 597;
    if(!strcmp(search, "lvpd", true) || !strcmp(search, "policelv", true)) return 598;
    if(!strcmp(search, "ranger", true) || !strcmp(search, "policeranger", true) || !strcmp(search, "police4x4", true)) return 599;
    if(!strcmp(search, "swat", true) || !strcmp(search, "swatvan", true) || !strcmp(search, "swatcar", true)) return 601;
    if(!strcmp(search, "fbi", true) || !strcmp(search, "fbitruck", true)) return 528;
    if(!strcmp(search, "fbirancher", true) || !strcmp(search, "fbiranch", true)) return 490;
    if(!strcmp(search, "ems", true) || !strcmp(search, "medic", true) || !strcmp(search, "ambulance", true)) return 416;
    if(!strcmp(search, "fire", true) || !strcmp(search, "firetruck", true)) return 407;
    if(!strcmp(search, "enforcer", true)) return 427;

    if(!strcmp(search, "inf", true) || !strcmp(search, "infer", true) || !strcmp(search, "infern", true) || !strcmp(search, "infernus", true)) return 411;
    if(!strcmp(search, "nr", true) || !strcmp(search, "nrg", true) || !strcmp(search, "nrg500", true)) return 522;

    // Exact normalized match.
    for(new i; i < sizeof(ER_VehicleNames); i++)
    {
        ER_NormalizeVehicleSearch(ER_VehicleNames[i], name, sizeof(name));
        if(!strcmp(search, name, true)) return i + 400;
    }

    // Prefix match: /aveh infer -> Infernus, /aveh sult -> Sultan.
    for(new i; i < sizeof(ER_VehicleNames); i++)
    {
        ER_NormalizeVehicleSearch(ER_VehicleNames[i], name, sizeof(name));
        if(strfind(name, search, true) == 0) return i + 400;
    }

    // Contains match: any piece inside the name.
    for(new i; i < sizeof(ER_VehicleNames); i++)
    {
        ER_NormalizeVehicleSearch(ER_VehicleNames[i], name, sizeof(name));
        if(strfind(name, search, true) != -1) return i + 400;
    }

    return 0;
}

stock ER_GetVehicleAreaName(Float:x, Float:y, Float:z, dest[], size)
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
    // Normal 4-wheel road vehicles only. Excludes bikes, boats, aircraft, trains, trailers, RC, and special vehicles.
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

    // Universal TransFender-type components for road cars.
    switch(component)
    {
        case 1008,1009,1010: return ER_CanVehicleUseNOS(model); // nitro
        case 1025,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1096,1097,1098: return ER_CanUseUniversalTuning(model); // wheels/rims
        case 1086,1087: return ER_CanUseUniversalTuning(model); // stereo/hydraulics
    }

    switch(model)
    {
        // =========================
        // Wheel Arch Angels
        // =========================

        case 560: // Sultan
        {
            switch(component)
            {
                // Side skirts: 1026/1027 Alien pair, 1030/1031 X-Flow pair.
                // Exhaust: 1028/1029.
                case 1026,1027,1028,1029,1030,1031,1032,1033,1138,1139,1140,1141,1169,1170: return 1;
            }
        }

        case 562: // Elegy
        {
            switch(component)
            {
                case 1034,1035,1036,1037,1038,1039,1040,1041,1146,1147,1148,1149,1171,1172: return 1;
            }
        }

        case 561: // Stratum
        {
            switch(component)
            {
                case 1055,1058,1059,1060,1061,1062,1063,1064,1067,1068,1069,1070,1154,1155,1156,1157,1158,1159: return 1;
            }
        }

        case 559: // Jester
        {
            switch(component)
            {
                case 1065,1066,1067,1068,1069,1070,1071,1072,1158,1159,1160,1161,1162,1173: return 1;
            }
        }

        case 558: // Uranus
        {
            switch(component)
            {
                case 1088,1089,1090,1091,1092,1093,1094,1095,1163,1164,1165,1166,1167,1168: return 1;
            }
        }

        case 565: // Flash
        {
            switch(component)
            {
                case 1045,1046,1047,1048,1049,1050,1051,1052,1053,1054,1055,1056,1057,1150,1151,1152,1153: return 1;
            }
        }

        // =========================
        // Lowrider / Loco Low Co
        // =========================

        case 534: // Remington
        {
            switch(component)
            {
                case 1100,1101,1106,1107,1108,1122,1124,1125,1126,1127,1178,1179,1180,1185,1186: return 1;
            }
        }

        case 535: // Slamvan
        {
            switch(component)
            {
                case 1109,1110,1113,1114,1115,1116,1117,1118,1119,1120,1121,1123,1125,1126,1127,1180,1181: return 1;
            }
        }

        case 536: // Blade
        {
            switch(component)
            {
                case 1103,1104,1105,1181,1182,1183,1184: return 1;
            }
        }

        case 567: // Savanna
        {
            switch(component)
            {
                case 1128,1129,1130,1131,1132,1133,1186,1187,1188,1189: return 1;
            }
        }

        case 575: // Broadway
        {
            switch(component)
            {
                case 1042,1043,1099,1174,1175,1176,1177: return 1;
            }
        }

        case 576: // Tornado
        {
            switch(component)
            {
                case 1134,1135,1136,1137,1190,1191,1192,1193: return 1;
            }
        }

        case 412: // Voodoo
        {
            switch(component)
            {
                case 1102,1103,1104,1105,1181,1182,1183,1184: return 1;
            }
        }

        case 566: // Tahoma
        {
            switch(component)
            {
                case 1100,1101,1121,1123,1124,1125,1126,1127: return 1;
            }
        }

        case 542: // Clover
        {
            switch(component)
            {
                case 1118,1119,1120,1121,1123: return 1;
            }
        }

        // =========================
        // TransFender body kit vehicles / partial support
        // =========================

        case 401: // Bravura
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1019,1020,1021,1022: return 1;
            }
        }

        case 405: // Sentinel
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 410: // Manana
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1019,1020,1021,1022: return 1;
            }
        }

        case 415: // Cheetah
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 418: // Moonbeam
        {
            switch(component)
            {
                case 1002,1006,1007,1016,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 420: // Taxi
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 421: // Washington
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 422: // Bobcat
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 426: // Premier
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 436: // Previon
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1019,1020,1021,1022: return 1;
            }
        }

        case 439: // Stallion
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 445: // Admiral
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 458: // Solair
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 466: // Glendale
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 467: // Oceanic
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 474: // Hermes
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 475: // Sabre
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 477: // ZR-350
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 478: // Walton
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 479: // Regina
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 489: // Rancher
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 491: // Virgo
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 492: // Greenwood
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 496: // Blista Compact
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1017,1019,1020,1021,1022: return 1;
            }
        }

        case 500: // Mesa
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 506: // Super GT
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 507: // Elegant
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 516: // Nebula
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 517: // Majestic
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 518: // Buccaneer
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 526: // Fortune
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 527: // Cadrona
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1019,1020,1021,1022: return 1;
            }
        }

        case 529: // Willard
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 540: // Vincent
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 541: // Bullet
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 545: // Hustler
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 546: // Intruder
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 547: // Primo
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 549: // Tampa
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 550: // Sunrise
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 551: // Merit
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 555: // Windsor
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 579: // Huntley
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 580: // Stafford
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 585: // Emperor
        {
            switch(component)
            {
                case 1001,1003,1004,1005,1006,1007,1017,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 587: // Euros
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 589: // Club
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1017,1019,1020,1021,1022: return 1;
            }
        }

        case 600: // Picador
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1007,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 602: // Alpha
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
        }

        case 603: // Phoenix
        {
            switch(component)
            {
                case 1000,1001,1003,1004,1005,1006,1018,1019,1020,1021,1022: return 1;
            }
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

        // Sultan
        case 1026: return 1027;
        case 1027: return 1026;
        case 1030: return 1031;
        case 1031: return 1030;

        // Elegy
        case 1036: return 1040;
        case 1040: return 1036;
        case 1039: return 1041;
        case 1041: return 1039;

        // Flash
        case 1047: return 1051;
        case 1051: return 1047;
        case 1048: return 1052;
        case 1052: return 1048;

        // Stratum
        case 1056: return 1062;
        case 1062: return 1056;
        case 1057: return 1063;
        case 1063: return 1057;

        // Jester
        case 1069: return 1070;
        case 1070: return 1069;
        case 1071: return 1072;
        case 1072: return 1071;

        // Uranus
        case 1090: return 1094;
        case 1094: return 1090;
        case 1093: return 1095;
        case 1095: return 1093;
    }
    return 0;
}

stock ER_IsPrimarySideSkirt(component)
{
    switch(component)
    {
        case 1007,1026,1030,1036,1039,1047,1048,1056,1057,1069,1071,1090,1093:
            return 1;
    }
    return 0;
}

stock ER_GetSideSkirtSetName(component, dest[], size)
{
    switch(component)
    {
        case 1007: format(dest, size, "Standard Side Skirt Set");
        case 1026: format(dest, size, "Sultan Alien Side Skirt Set");
        case 1030: format(dest, size, "Sultan X-Flow Side Skirt Set");
        case 1036: format(dest, size, "Elegy Alien Side Skirt Set");
        case 1039: format(dest, size, "Elegy X-Flow Side Skirt Set");
        case 1047: format(dest, size, "Flash Alien Side Skirt Set");
        case 1048: format(dest, size, "Flash X-Flow Side Skirt Set");
        case 1056: format(dest, size, "Stratum Alien Side Skirt Set");
        case 1057: format(dest, size, "Stratum X-Flow Side Skirt Set");
        case 1069: format(dest, size, "Jester Alien Side Skirt Set");
        case 1071: format(dest, size, "Jester X-Flow Side Skirt Set");
        case 1090: format(dest, size, "Uranus Alien Side Skirt Set");
        case 1093: format(dest, size, "Uranus X-Flow Side Skirt Set");
        default: format(dest, size, "Side Skirt Set");
    }
    return 1;
}

stock ER_SetVehicleSideSkirtSet(idx, component)
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



stock ER_CanVehicleUseHydraulics(model)
{
    // Same universal-road-car logic as rims/hydraulics. Excludes bikes/boats/air/RC/trailers.
    return ER_CanUseUniversalTuning(model);
}

stock ER_CanVehicleUseRims(model)
{
    return ER_CanUseUniversalTuning(model);
}

stock ER_CanVehicleUseNOS(model)
{
    // Exclude bikes, bicycles, boats, aircraft, trailers, trains, RC and special vehicles.
    switch(model)
    {
        case 481, 509, 510: return 0; // bicycles
        case 448, 461, 462, 463, 468, 471, 521, 522, 523, 581, 586: return 0; // bikes/quads
        case 430, 446, 452, 453, 454, 472, 473, 484, 493, 595: return 0; // boats
        case 417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553, 563, 577, 592, 593: return 0; // air
        case 435, 449, 450, 537, 538, 569, 570, 584, 590, 591, 606, 607, 608, 610, 611: return 0; // trailers/trains
        case 441, 464, 465, 501, 564, 594: return 0; // RC/special
    }
    return 1;
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

    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModSpoiler])) VehicleInfo[idx][vModSpoiler] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModHood])) VehicleInfo[idx][vModHood] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModRoof])) VehicleInfo[idx][vModRoof] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModSideskirtL])) VehicleInfo[idx][vModSideskirtL] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModSideskirtR])) VehicleInfo[idx][vModSideskirtR] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModLamps])) VehicleInfo[idx][vModLamps] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModNitro])) VehicleInfo[idx][vModNitro] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vNos])) { VehicleInfo[idx][vNos] = 0; VehicleInfo[idx][vUnlimitedNos] = 0; }
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModExhaust])) VehicleInfo[idx][vModExhaust] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModWheels])) VehicleInfo[idx][vModWheels] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModHydraulics])) VehicleInfo[idx][vModHydraulics] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModFrontBumper])) VehicleInfo[idx][vModFrontBumper] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModRearBumper])) VehicleInfo[idx][vModRearBumper] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModVentRight])) VehicleInfo[idx][vModVentRight] = 0;
    if(!ER_IsComponentCompatible(model, VehicleInfo[idx][vModVentLeft])) VehicleInfo[idx][vModVentLeft] = 0;

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

stock ER_VehicleHasEditableMods(model)
{
    // Main editable body/visual mods only. NOS/Hydraulics/Rims are edited from main menu.
    for(new component = 1000; component <= 1193; component++)
    {
        if(component == 1008 || component == 1009 || component == 1010 || component == 1025) continue;
        if(component >= 1073 && component <= 1087) continue; // rims/stereo/hydraulics
        if(ER_IsComponentCompatible(model, component)) return 1;
    }
    return 0;
}


stock ER_ModSlotHasCompatible(model, slot)
{
    switch(slot)
    {
        case 0:
        {
            if(ER_IsComponentCompatible(model, 1000)) return 1;
            if(ER_IsComponentCompatible(model, 1001)) return 1;
            if(ER_IsComponentCompatible(model, 1002)) return 1;
            if(ER_IsComponentCompatible(model, 1003)) return 1;
            if(ER_IsComponentCompatible(model, 1023)) return 1;
            if(ER_IsComponentCompatible(model, 1138)) return 1;
            if(ER_IsComponentCompatible(model, 1139)) return 1;
            if(ER_IsComponentCompatible(model, 1146)) return 1;
            if(ER_IsComponentCompatible(model, 1147)) return 1;
            if(ER_IsComponentCompatible(model, 1158)) return 1;
            if(ER_IsComponentCompatible(model, 1162)) return 1;
            if(ER_IsComponentCompatible(model, 1163)) return 1;
            if(ER_IsComponentCompatible(model, 1164)) return 1;
        }
        case 1:
        {
            if(ER_IsComponentCompatible(model, 1004)) return 1;
            if(ER_IsComponentCompatible(model, 1005)) return 1;
            if(ER_IsComponentCompatible(model, 1006)) return 1;
            if(ER_IsComponentCompatible(model, 1014)) return 1;
            if(ER_IsComponentCompatible(model, 1015)) return 1;
            if(ER_IsComponentCompatible(model, 1016)) return 1;
            if(ER_IsComponentCompatible(model, 1065)) return 1;
            if(ER_IsComponentCompatible(model, 1066)) return 1;
        }
        case 2:
        {
            if(ER_IsComponentCompatible(model, 1032)) return 1;
            if(ER_IsComponentCompatible(model, 1033)) return 1;
            if(ER_IsComponentCompatible(model, 1035)) return 1;
            if(ER_IsComponentCompatible(model, 1038)) return 1;
            if(ER_IsComponentCompatible(model, 1053)) return 1;
            if(ER_IsComponentCompatible(model, 1054)) return 1;
            if(ER_IsComponentCompatible(model, 1055)) return 1;
            if(ER_IsComponentCompatible(model, 1061)) return 1;
            if(ER_IsComponentCompatible(model, 1067)) return 1;
            if(ER_IsComponentCompatible(model, 1088)) return 1;
            if(ER_IsComponentCompatible(model, 1091)) return 1;
            if(ER_IsComponentCompatible(model, 1103)) return 1;
            if(ER_IsComponentCompatible(model, 1128)) return 1;
            if(ER_IsComponentCompatible(model, 1130)) return 1;
            if(ER_IsComponentCompatible(model, 1131)) return 1;
        }
        case 3, 4:
        {
            if(ER_IsComponentCompatible(model, 1017)) return 1;
            if(ER_IsComponentCompatible(model, 1026)) return 1;
            if(ER_IsComponentCompatible(model, 1027)) return 1;
            if(ER_IsComponentCompatible(model, 1030)) return 1;
            if(ER_IsComponentCompatible(model, 1031)) return 1;
            if(ER_IsComponentCompatible(model, 1036)) return 1;
            if(ER_IsComponentCompatible(model, 1039)) return 1;
            if(ER_IsComponentCompatible(model, 1040)) return 1;
            if(ER_IsComponentCompatible(model, 1041)) return 1;
            if(ER_IsComponentCompatible(model, 1051)) return 1;
            if(ER_IsComponentCompatible(model, 1052)) return 1;
            if(ER_IsComponentCompatible(model, 1069)) return 1;
            if(ER_IsComponentCompatible(model, 1070)) return 1;
            if(ER_IsComponentCompatible(model, 1071)) return 1;
            if(ER_IsComponentCompatible(model, 1072)) return 1;
            if(ER_IsComponentCompatible(model, 1099)) return 1;
            if(ER_IsComponentCompatible(model, 1101)) return 1;
            if(ER_IsComponentCompatible(model, 1102)) return 1;
        }
        case 5:
        {
            if(ER_IsComponentCompatible(model, 1024)) return 1;
            if(ER_IsComponentCompatible(model, 1027)) return 1;
        }
        case 7:
        {
            for(new c = 1018; c <= 1046; c++) if(ER_IsComponentCompatible(model, c)) return 1;
            for(new c = 1104; c <= 1136; c++) if(ER_IsComponentCompatible(model, c)) return 1;
        }
        case 11:
        {
            for(new c = 1115; c <= 1191; c++) if(ER_IsComponentCompatible(model, c)) return 1;
        }
        case 12:
        {
            for(new c = 1109; c <= 1193; c++) if(ER_IsComponentCompatible(model, c)) return 1;
        }
        case 13, 14:
        {
            if(ER_IsComponentCompatible(model, 1142)) return 1;
            if(ER_IsComponentCompatible(model, 1143)) return 1;
            if(ER_IsComponentCompatible(model, 1144)) return 1;
            if(ER_IsComponentCompatible(model, 1145)) return 1;
        }
    }
    return 0;
}

stock ER_AddModCategory(playerid, &count, list[], size, const name[], slot)
{
    new pvar[32];
    format(pvar, sizeof(pvar), "VehModSlot%d", count);
    SetPVarInt(playerid, pvar, slot);
    format(list, size, "%s%s\n", list, name);
    count++;
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

    if(ER_ModSlotHasCompatible(model, 0)) ER_AddModCategory(playerid, count, list, sizeof(list), "Spoiler", 0);
    if(ER_ModSlotHasCompatible(model, 1)) ER_AddModCategory(playerid, count, list, sizeof(list), "Hood", 1);
    if(ER_ModSlotHasCompatible(model, 2)) ER_AddModCategory(playerid, count, list, sizeof(list), "Roof", 2);
    if(ER_ModSlotHasCompatible(model, 3) || ER_ModSlotHasCompatible(model, 4)) ER_AddModCategory(playerid, count, list, sizeof(list), "Side Skirt", 3);
    if(ER_ModSlotHasCompatible(model, 5)) ER_AddModCategory(playerid, count, list, sizeof(list), "Lamps", 5);
    if(ER_ModSlotHasCompatible(model, 7)) ER_AddModCategory(playerid, count, list, sizeof(list), "Exhaust", 7);
    if(ER_ModSlotHasCompatible(model, 11)) ER_AddModCategory(playerid, count, list, sizeof(list), "Front Bumper", 11);
    if(ER_ModSlotHasCompatible(model, 12)) ER_AddModCategory(playerid, count, list, sizeof(list), "Rear Bumper", 12);
    if(ER_ModSlotHasCompatible(model, 13)) ER_AddModCategory(playerid, count, list, sizeof(list), "Vent Right", 13);
    if(ER_ModSlotHasCompatible(model, 14)) ER_AddModCategory(playerid, count, list, sizeof(list), "Vent Left", 14);

    if(!count)
    {
        ER_Send(playerid, COLOR_GREY, "This vehicle does not have any compatible body modifications.");
        return ER_ShowVehicleEditor(playerid, sqlid);
    }

    return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_MODS, DIALOG_STYLE_LIST, "Vehicle Mods", list, "Select", "Back");
}


stock ER_GetVehicleModComponentBySlot(idx, slot)
{
    if(idx < 0 || idx >= VehicleCount) return 0;

    switch(slot)
    {
        case 0: return VehicleInfo[idx][vModSpoiler];
        case 1: return VehicleInfo[idx][vModHood];
        case 2: return VehicleInfo[idx][vModRoof];
        case 3: return VehicleInfo[idx][vModSideskirtL];
        case 4: return VehicleInfo[idx][vModSideskirtR];
        case 5: return VehicleInfo[idx][vModLamps];
        case 7: return VehicleInfo[idx][vModExhaust];
        case 11: return VehicleInfo[idx][vModFrontBumper];
        case 12: return VehicleInfo[idx][vModRearBumper];
        case 13: return VehicleInfo[idx][vModVentRight];
        case 14: return VehicleInfo[idx][vModVentLeft];
    }
    return 0;
}

stock ER_ShowVehicleComponentList(playerid, slot)
{
    new sqlid = GetPVarInt(playerid, "EditingVehicleID");
    new idx = ER_FindVehicleBySQLID(sqlid);
    if(idx == -1) return ER_ShowVehicleEditor(playerid, sqlid);

    new model = VehicleInfo[idx][vModel];
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
        return ER_ShowVehicleEditor(playerid, sqlid);
    }

    return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_MOD_SELECT, DIALOG_STYLE_TABLIST, "Select Vehicle Component", list, "Select", "Back");
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
        ER_ResetVehicleRadio(VehicleInfo[idx][vSpawnedID]);
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

    // Unlimited NOS is a flag, but the vehicle still needs the physical 10x NOS component.
    if(VehicleInfo[idx][vUnlimitedNos])
    {
        VehicleInfo[idx][vNos] = 1010;
        VehicleInfo[idx][vModNitro] = 1010;
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
        ER_ResetVehicleRadio(VehicleInfo[idx][vSpawnedID]);
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
    SetVehicleParamsEx(VehicleInfo[idx][vSpawnedID], VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF, VEHICLE_PARAMS_OFF);
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
    #pragma unused sqlid

    new playerveh = GetPlayerVehicleID(playerid);
    if(playerveh != 0)
    {
        GetVehiclePos(playerveh, x, y, z);
        GetVehicleZAngle(playerveh, a);
        interior = GetPlayerInterior(playerid);
        vw = GetPlayerVirtualWorld(playerid);
        return 1;
    }

    // Set Pos Here should use the admin/player's current position, not the edited vehicle's old saved position.
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

stock ER_GetVehicleOwnerText(ownerpid, familyid, factionid, const ownername[], dest[], size)
{
	if(ownerpid > 0) format(dest, size, "Player Owned (%d) %s", ownerpid, ownername[0] ? ownername : "Unknown");
	else if(familyid > 0) format(dest, size, "Family Owned (%d)", familyid);
	else if(factionid > 0) format(dest, size, "Faction Owned (%d)", factionid);
	else format(dest, size, "None");
	return 1;
}

stock ER_GetVehicleOwnerTextEx(ownerpid, familyid, factionid, jobid, const ownername[], dest[], size)
{
    if(jobid > 0)
    {
        new jobName[32];
        ER_GetJobTypeName(jobid, jobName, sizeof(jobName));
        format(dest, size, "Job Type (%d) %s", jobid, jobName);
    }
    else if(ownerpid > 0)
    {
        format(dest, size, "Player Owned (%d) %s", ownerpid, ownername[0] ? ownername : "Unknown");
    }
    else if(familyid > 0)
    {
        new famidx = ER_FindFamilyIndexBySQLID(familyid);
        if(famidx != -1) format(dest, size, "Family Owned (%d) %s", familyid, Families[famidx][fName]);
        else format(dest, size, "Family Owned (%d)", familyid);
    }
    else if(factionid > 0)
    {
        new facidx = ER_FindFactionIndexBySQLID(factionid);
        if(facidx != -1) format(dest, size, "Faction Owned (%d) %s", factionid, Factions[facidx][facName]);
        else format(dest, size, "Faction Owned (%d)", factionid);
    }
    else
    {
        format(dest, size, "None");
    }
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
            ER_ResetVehicleRadio(VehicleInfo[i][vSpawnedID]);
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
        cache_get_value_name_int(r, "job_id", VehicleInfo[VehicleCount][vJobID]);
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
        cache_get_value_name_float(r, "fuel", VehicleInfo[VehicleCount][vFuel]);
        if(VehicleInfo[VehicleCount][vFuel] < 0.0) VehicleInfo[VehicleCount][vFuel] = 0.0;
        if(VehicleInfo[VehicleCount][vFuel] > 100.0) VehicleInfo[VehicleCount][vFuel] = 100.0;
        cache_get_value_name_int(r, "unlimited_fuel", VehicleInfo[VehicleCount][vUnlimitedFuel]);
        if(VehicleInfo[VehicleCount][vUnlimitedFuel] < 0) VehicleInfo[VehicleCount][vUnlimitedFuel] = 0;
        if(VehicleInfo[VehicleCount][vUnlimitedFuel] > 1) VehicleInfo[VehicleCount][vUnlimitedFuel] = 1;
        cache_get_value_name_float(r, "mileage", VehicleInfo[VehicleCount][vMileage]);
        if(VehicleInfo[VehicleCount][vMileage] < 0.0) VehicleInfo[VehicleCount][vMileage] = 0.0;

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
        VehicleInfo[VehicleCount][vWindows][0] = 1;

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
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `vehicles` (`owner_pid`,`family_id`,`faction_id`,`job_id`,`model`,`color1`,`color2`,`paintjob`,`x`,`y`,`z`,`a`,`interior`,`vw`,`lock_type`,`fuel`,`enabled`) VALUES (0,0,0,0,%d,%d,%d,-1,%f,%f,%f,%f,%d,%d,0,100.0,1)",
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
        VehicleInfo[idx][vFuel] = 100.0;
        VehicleInfo[idx][vUnlimitedFuel] = 0;

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
    mysql_format(MainPipeline, q, sizeof(q), "INSERT INTO `vehicles` (`owner_pid`,`family_id`,`faction_id`,`job_id`,`model`,`color1`,`color2`,`paintjob`,`x`,`y`,`z`,`a`,`interior`,`vw`,`fuel`,`enabled`) VALUES (%d,0,0,0,%d,%d,%d,-1,%f,%f,%f,%f,%d,%d,100.0,1)",
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
	ShowPlayerDialog(playerid, DIALOG_MY_VEHICLES, DIALOG_STYLE_TABLIST_HEADERS, "My Vehicles", list, "Select", "Close");
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


CMD:ftrackveh(playerid, params[])
{
    #pragma unused params
    if(PlayerInfo[playerid][pFaction] <= 0 && PlayerInfo[playerid][pFamily] <= 0)
        return ER_Send(playerid, COLOR_GREY, "You are not in a family or faction.");

    new q[256];
    if(PlayerInfo[playerid][pFaction] > 0)
    {
        if(PlayerInfo[playerid][pFactionRank] < ER_GetFactionVehiclePermRank(PlayerInfo[playerid][pFaction], 1))
            return ER_Send(playerid, COLOR_GREY, "Your faction rank is not high enough to track faction vehicles.");
        mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `vehicles` WHERE `faction_id`=%d AND `enabled`=1 ORDER BY `id` ASC", PlayerInfo[playerid][pFaction]);
    }
    else
    {
        if(PlayerInfo[playerid][pFamilyRank] < ER_GetFamilyVehiclePermRank(PlayerInfo[playerid][pFamily], 1))
            return ER_Send(playerid, COLOR_GREY, "Your family rank is not high enough to track family vehicles.");
        mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `vehicles` WHERE `family_id`=%d AND `enabled`=1 ORDER BY `id` ASC", PlayerInfo[playerid][pFamily]);
    }
    mysql_tquery(MainPipeline, q, "ER_OnFTrackVehicleList", "i", playerid);
    return 1;
}
alias:ftrackveh("ftrackcar")

forward ER_OnFTrackVehicleList(playerid);
public ER_OnFTrackVehicleList(playerid)
{
    new rows, list[2048], line[128], model, sqlid, Float:x, Float:y, Float:z, area[32];
    cache_get_row_count(rows);
    if(!rows) return ER_Send(playerid, COLOR_GREY, "There are no family/faction vehicles to track.");
    for(new i; i < rows; i++)
    {
        cache_get_value_name_int(i, "id", sqlid);
        cache_get_value_name_int(i, "model", model);
        cache_get_value_name_float(i, "x", x);
        cache_get_value_name_float(i, "y", y);
        cache_get_value_name_float(i, "z", z);
        new idx = ER_FindVehicleBySQLID(sqlid);
        if(idx != -1 && VehicleInfo[idx][vSpawnedID] != INVALID_VEHICLE_ID && VehicleInfo[idx][vSpawnedID] != 0)
        {
            GetVehiclePos(VehicleInfo[idx][vSpawnedID], x, y, z);
        }
        ER_GetVehicleAreaName(x, y, z, area, sizeof(area));
        format(line, sizeof(line), "%d - %s - %s\n", i + 1, ER_GetVehicleModelName(model), area);
        strcat(list, line, sizeof(list));
        new pvar[32]; format(pvar, sizeof(pvar), "FTrackVeh_%d", i);
        SetPVarInt(playerid, pvar, sqlid);
    }
    SetPVarInt(playerid, "FTrackVehCount", rows);
    ShowPlayerDialog(playerid, DIALOG_FTRACK_VEHICLE, DIALOG_STYLE_LIST, "Family/Faction Vehicles", list, "Track", "Close");
    return 1;
}

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
	new rows, list[4096], sqlid, model, ownerpid, familyid, factionid, jobid, spawnid, Float:x, Float:y, Float:z, area[32], owner[96], ownername[24];
	cache_get_row_count(rows);
	format(list, sizeof(list), "ID\tVehID\tModel\tOwner\tLocation\n");
	for(new r; r < rows; r++)
	{
		cache_get_value_name_int(r, "id", sqlid);
		cache_get_value_name_int(r, "model", model);
		cache_get_value_name_int(r, "owner_pid", ownerpid);
		cache_get_value_name_int(r, "family_id", familyid);
		cache_get_value_name_int(r, "faction_id", factionid);
		cache_get_value_name_int(r, "job_id", jobid);
		cache_get_value_name_float(r, "x", x);
		cache_get_value_name_float(r, "y", y);
		cache_get_value_name_float(r, "z", z);
		cache_get_value_name(r, "owner_name", ownername, sizeof(ownername));

		spawnid = INVALID_VEHICLE_ID;
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx != -1) spawnid = VehicleInfo[idx][vSpawnedID];

		ER_GetVehicleAreaName(x, y, z, area, sizeof(area));
		ER_GetVehicleOwnerTextEx(ownerpid, familyid, factionid, jobid, ownername, owner, sizeof(owner));
		format(list, sizeof(list), "%s%d\t%d\t%s\t%s\t%s\n", list, sqlid, spawnid, ER_GetVehicleModelName(model), owner, area);
	}
	ShowPlayerDialog(playerid, DIALOG_ALL_VEHICLES, DIALOG_STYLE_TABLIST_HEADERS, "All Vehicles", list, "Close", "");
	return 1;
}

forward ER_OnEditVehiclesDialog(playerid);
public ER_OnEditVehiclesDialog(playerid)
{
	new rows, list[4096], sqlid, model, ownerpid, familyid, factionid, jobid, spawnid, Float:x, Float:y, Float:z, area[32], owner[96], ownername[24];
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
		cache_get_value_name_int(r, "job_id", jobid);
		cache_get_value_name_float(r, "x", x);
		cache_get_value_name_float(r, "y", y);
		cache_get_value_name_float(r, "z", z);
		cache_get_value_name(r, "owner_name", ownername, sizeof(ownername));

		spawnid = INVALID_VEHICLE_ID;
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx != -1) spawnid = VehicleInfo[idx][vSpawnedID];

		ER_GetVehicleAreaName(x, y, z, area, sizeof(area));
		ER_GetVehicleOwnerTextEx(ownerpid, familyid, factionid, jobid, ownername, owner, sizeof(owner));
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


stock ER_AddVehicleEditorRow(playerid, &row, list[], size, action, const text[])
{
    new pvar[32];
    format(pvar, sizeof(pvar), "VehEditAction%d", row);
    SetPVarInt(playerid, pvar, action);
    format(list, size, "%s%s\n", list, text);
    row++;
    return 1;
}

forward ER_OnShowVehicleEditor(playerid);
public ER_OnShowVehicleEditor(playerid)
{
	new rows;
	cache_get_row_count(rows);
	if(!rows) return ER_Send(playerid, COLOR_GREY, "Vehicle not found.");

	new sqlid, model, c1, c2, paintjob, nos, unlimitednos, unlimitedfuel, hydraulics, wheels, ownerpid, familyid, factionid, jobid, spawnid, ownername[24], owner[96], list[2000];
	new row, line[128];

	cache_get_value_name_int(0, "id", sqlid);
	cache_get_value_name_int(0, "model", model);
	cache_get_value_name_int(0, "color1", c1);
	cache_get_value_name_int(0, "color2", c2);
	cache_get_value_name_int(0, "paintjob", paintjob);
	cache_get_value_name_int(0, "nos", nos);
	cache_get_value_name_int(0, "unlimited_nos", unlimitednos);
	cache_get_value_name_int(0, "unlimited_fuel", unlimitedfuel);
	cache_get_value_name_int(0, "mod_hydraulics", hydraulics);
	cache_get_value_name_int(0, "mod_wheels", wheels);
	cache_get_value_name_int(0, "owner_pid", ownerpid);
	cache_get_value_name_int(0, "family_id", familyid);
	cache_get_value_name_int(0, "faction_id", factionid);
	cache_get_value_name_int(0, "job_id", jobid);
	cache_get_value_name(0, "owner_name", ownername, sizeof(ownername));

	spawnid = INVALID_VEHICLE_ID;
	new idx = ER_FindVehicleBySQLID(sqlid);
	if(idx != -1) spawnid = VehicleInfo[idx][vSpawnedID];

	ER_GetVehicleOwnerTextEx(ownerpid, familyid, factionid, jobid, ownername, owner, sizeof(owner));
	SetPVarInt(playerid, "EditingVehicleID", sqlid);

	list[0] = EOS;

	format(line, sizeof(line), "Owner: %s", owner);
	ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 0, line);

	format(line, sizeof(line), "Model: %s (%d)", ER_GetVehicleModelName(model), model);
	ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 1, line);

	format(line, sizeof(line), "Color 1: %d", c1);
	ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 2, line);

	format(line, sizeof(line), "Color 2: %d", c2);
	ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 3, line);

	if(ER_CanVehicleUsePaintjob(model))
	{
		format(line, sizeof(line), "Paintjob: %s", ER_GetVehiclePaintjobName(paintjob));
		ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 4, line);
	}

	if(ER_CanVehicleUseNOS(model))
	{
		format(line, sizeof(line), "NOS: %s", ER_GetVehicleNOSName(nos, unlimitednos));
		ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 5, line);
	}

	if(ER_CanVehicleUseHydraulics(model))
	{
		format(line, sizeof(line), "Hydraulics: %s", hydraulics ? "Installed" : "None");
		ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 6, line);
	}

	if(ER_CanVehicleUseRims(model))
	{
		format(line, sizeof(line), "Rims: %s", ER_GetVehicleWheelName(wheels));
		ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 7, line);
	}

	if(ER_VehicleHasEditableMods(model))
	{
		ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 8, "Mods");
	}

	if(unlimitedfuel) format(line, sizeof(line), "Fuel: Unlimited");
	else format(line, sizeof(line), "Fuel: %d/100", idx != -1 ? floatround(VehicleInfo[idx][vFuel]) : 100);
	ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 14, line);

	format(line, sizeof(line), "Unlimited Fuel: %s", unlimitedfuel ? "Yes" : "No");
	ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 15, line);

	ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 9, "Position: Set here");
	ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 10, "Goto Vehicle");
	ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 11, "Reset Vehicle");
	ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 12, "Reload This Vehicle");
	ER_AddVehicleEditorRow(playerid, row, list, sizeof(list), 13, "Disable/Delete");

	new title[64];
	format(title, sizeof(title), "Vehicle Editor - ID %d | VehID %d", sqlid, spawnid);
	ShowPlayerDialog(playerid, DIALOG_EDIT_VEHICLE_MENU, DIALOG_STYLE_LIST, title, list, "Select", "Close");
	return 1;
}


stock ER_ShowVehicleOwnerMenu(playerid)
{
    return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_OWNER, DIALOG_STYLE_LIST, "Vehicle Owner", "Player Online\nPlayer Offline\nFamily\nFaction\nJob Type\nClear Owner", "Select", "Back");
}

stock ER_ShowVehicleOwnerFamilies(playerid)
{
    new list[2048], line[128], count = 0;
    list[0] = EOS;
    for(new i; i < FamilyCount && count < 100; i++)
    {
        format(line, sizeof(line), "%d - (%d) %s\n", count + 1, Families[i][fSQLID], Families[i][fName]);
        strcat(list, line, sizeof(list));
        format(line, sizeof(line), "VehOwnerFamily%d", count);
        SetPVarInt(playerid, line, Families[i][fSQLID]);
        count++;
    }
    if(!count) return ER_Send(playerid, COLOR_GREY, "No families found.");
    SetPVarInt(playerid, "VehOwnerFamilyCount", count);
    return ShowPlayerDialog(playerid, DIALOG_VEHOWN_FAMILY, DIALOG_STYLE_LIST, "Select Family Owner", list, "Select", "Back");
}

stock ER_ShowVehicleOwnerFactions(playerid)
{
    new list[2048], line[128], count = 0;
    list[0] = EOS;
    for(new i; i < FactionCount && count < 100; i++)
    {
        format(line, sizeof(line), "%d - (%d) %s\n", count + 1, Factions[i][facSQLID], Factions[i][facName]);
        strcat(list, line, sizeof(list));
        format(line, sizeof(line), "VehOwnerFaction%d", count);
        SetPVarInt(playerid, line, Factions[i][facSQLID]);
        count++;
    }
    if(!count) return ER_Send(playerid, COLOR_GREY, "No factions found.");
    SetPVarInt(playerid, "VehOwnerFactionCount", count);
    return ShowPlayerDialog(playerid, DIALOG_VEHOWN_FACTION, DIALOG_STYLE_LIST, "Select Faction Owner", list, "Select", "Back");
}

stock ER_ShowVehicleOwnerJobs(playerid)
{
    new list[1024], line[96], name[32];
    list[0] = EOS;
    for(new jobid = 1; jobid <= 11; jobid++)
    {
        ER_GetJobTypeName(jobid, name, sizeof(name));
        format(line, sizeof(line), "%d - (%d) %s\n", jobid, jobid, name);
        strcat(list, line, sizeof(list));
        format(line, sizeof(line), "VehOwnerJob%d", jobid - 1);
        SetPVarInt(playerid, line, jobid);
    }
    SetPVarInt(playerid, "VehOwnerJobCount", 11);
    return ShowPlayerDialog(playerid, DIALOG_VEHOWN_JOB, DIALOG_STYLE_LIST, "Select Job Type Owner", list, "Select", "Back");
}

stock ER_ShowVehOwnerOffline(playerid)
{
    mysql_tquery(MainPipeline, "SELECT `id`,`username` FROM `accounts` ORDER BY `id` ASC LIMIT 200", "ER_OnVehOwnerOfflinePlayers", "i", playerid);
    return 1;
}

forward ER_OnVehOwnerOfflinePlayers(playerid);
public ER_OnVehOwnerOfflinePlayers(playerid)
{
    new rows, list[4096], line[128], accountid, name[32], count = 0;
    cache_get_row_count(rows);
    list[0] = EOS;
    for(new r; r < rows && count < 200; r++)
    {
        cache_get_value_name_int(r, "id", accountid);
        cache_get_value_name(r, "username", name, sizeof(name));
        format(line, sizeof(line), "%d - (%d) %s\n", count + 1, accountid, name);
        strcat(list, line, sizeof(list));
        format(line, sizeof(line), "VehOwnerOffline%d", count);
        SetPVarInt(playerid, line, accountid);
        count++;
    }
    if(!count) return ER_Send(playerid, COLOR_GREY, "No accounts found.");
    SetPVarInt(playerid, "VehOwnerOfflineCount", count);
    return ShowPlayerDialog(playerid, DIALOG_VEHOWN_OFFLINE, DIALOG_STYLE_LIST, "Select Offline Player Owner", list, "Select", "Back");
}

stock ER_SetVehicleOwner(playerid, sqlid, type, value)
{
	new q[256];
	if(type == 1)
	{
		mysql_format(MainPipeline, q, sizeof(q), "SELECT owner_pid,family_id,faction_id,job_id FROM `vehicles` WHERE `id`=%d LIMIT 1", sqlid);
		SetPVarInt(playerid, "SetOwnerType", type);
		SetPVarInt(playerid, "SetOwnerValue", value);
		mysql_tquery(MainPipeline, q, "ER_OnCheckVehicleOwnerSet", "ii", playerid, sqlid);
	}
	else if(type == 2)
	{
		mysql_format(MainPipeline, q, sizeof(q), "SELECT owner_pid,family_id,faction_id,job_id FROM `vehicles` WHERE `id`=%d LIMIT 1", sqlid);
		SetPVarInt(playerid, "SetOwnerType", type);
		SetPVarInt(playerid, "SetOwnerValue", value);
		mysql_tquery(MainPipeline, q, "ER_OnCheckVehicleOwnerSet", "ii", playerid, sqlid);
	}
	else if(type == 3 || type == 4)
	{
		mysql_format(MainPipeline, q, sizeof(q), "SELECT owner_pid,family_id,faction_id,job_id FROM `vehicles` WHERE `id`=%d LIMIT 1", sqlid);
		SetPVarInt(playerid, "SetOwnerType", type);
		SetPVarInt(playerid, "SetOwnerValue", value);
		mysql_tquery(MainPipeline, q, "ER_OnCheckVehicleOwnerSet", "ii", playerid, sqlid);
	}
	return 1;
}

forward ER_OnCheckVehicleOwnerSet(playerid, sqlid);
public ER_OnCheckVehicleOwnerSet(playerid, sqlid)
{
	new rows, ownerpid, familyid, factionid, jobid, type, value, q[256], err[128];
	cache_get_row_count(rows);
	if(!rows) return ER_Send(playerid, COLOR_GREY, "Vehicle not found.");

	cache_get_value_name_int(0, "owner_pid", ownerpid);
	cache_get_value_name_int(0, "family_id", familyid);
	cache_get_value_name_int(0, "faction_id", factionid);
	cache_get_value_name_int(0, "job_id", jobid);

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
		if(type != 4 && jobid > 0)
		{
			format(err, sizeof(err), "Error: this vehicle is already owned by Job Type: %d.", jobid);
			ER_Send(playerid, COLOR_LIGHTRED, err);
			return ER_ShowVehicleEditor(playerid, sqlid);
		}
	}

	switch(type)
	{
		case 1: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `owner_pid`=%d,`family_id`=0,`faction_id`=0,`job_id`=0 WHERE `id`=%d", value, sqlid);
		case 2: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `owner_pid`=0,`family_id`=%d,`faction_id`=0,`job_id`=0 WHERE `id`=%d", value, sqlid);
		case 3: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `owner_pid`=0,`family_id`=0,`faction_id`=%d,`job_id`=0 WHERE `id`=%d", value, sqlid);
		case 4: mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `owner_pid`=0,`family_id`=0,`faction_id`=0,`job_id`=%d WHERE `id`=%d", value, sqlid);
		default: return ER_ShowVehicleEditor(playerid, sqlid);
	}
	mysql_tquery(MainPipeline, q);
	new idx = ER_FindVehicleBySQLID(sqlid);
	if(idx != -1)
	{
		switch(type)
		{
			case 1: { VehicleInfo[idx][vOwnerPID] = value; VehicleInfo[idx][vFamilyID] = 0; VehicleInfo[idx][vFactionID] = 0; VehicleInfo[idx][vJobID] = 0; }
			case 2: { VehicleInfo[idx][vOwnerPID] = 0; VehicleInfo[idx][vFamilyID] = value; VehicleInfo[idx][vFactionID] = 0; VehicleInfo[idx][vJobID] = 0; }
			case 3: { VehicleInfo[idx][vOwnerPID] = 0; VehicleInfo[idx][vFamilyID] = 0; VehicleInfo[idx][vFactionID] = value; VehicleInfo[idx][vJobID] = 0; }
			case 4: { VehicleInfo[idx][vOwnerPID] = 0; VehicleInfo[idx][vFamilyID] = 0; VehicleInfo[idx][vFactionID] = 0; VehicleInfo[idx][vJobID] = value; }
		}
	}
	ER_Send(playerid, COLOR_GREEN, "Vehicle owner updated.");
	return ER_ShowVehicleEditor(playerid, sqlid);
}


stock ER_ResetAllVehicleMods(idx)
{
    if(idx < 0 || idx >= VehicleCount) return 0;
    VehicleInfo[idx][vPaintjob] = -1;
    VehicleInfo[idx][vNos] = 0;
    VehicleInfo[idx][vUnlimitedNos] = 0;
    VehicleInfo[idx][vModSpoiler] = 0;
    VehicleInfo[idx][vModHood] = 0;
    VehicleInfo[idx][vModRoof] = 0;
    VehicleInfo[idx][vModSideskirtL] = 0;
    VehicleInfo[idx][vModSideskirtR] = 0;
    VehicleInfo[idx][vModLamps] = 0;
    VehicleInfo[idx][vModNitro] = 0;
    VehicleInfo[idx][vModExhaust] = 0;
    VehicleInfo[idx][vModWheels] = 0;
    VehicleInfo[idx][vModStereo] = 0;
    VehicleInfo[idx][vModHydraulics] = 0;
    VehicleInfo[idx][vModFrontBumper] = 0;
    VehicleInfo[idx][vModRearBumper] = 0;
    VehicleInfo[idx][vModVentRight] = 0;
    VehicleInfo[idx][vModVentLeft] = 0;

    new q[900];
    mysql_format(MainPipeline, q, sizeof(q),
        "UPDATE `vehicles` SET `paintjob`=-1,`nos`=0,`unlimited_nos`=0,`mod_spoiler`=0,`mod_hood`=0,`mod_roof`=0,`mod_sideskirt_l`=0,`mod_sideskirt_r`=0,`mod_lamps`=0,`mod_nitro`=0,`mod_exhaust`=0,`mod_wheels`=0,`mod_stereo`=0,`mod_hydraulics`=0,`mod_front_bumper`=0,`mod_rear_bumper`=0,`mod_vent_right`=0,`mod_vent_left`=0 WHERE `id`=%d",
        VehicleInfo[idx][vSQLID]);
    mysql_tquery(MainPipeline, q);
    ER_RespawnSavedVehicle(idx);
    return 1;
}

stock ER_SetVehicleLockType(idx, locktype)
{
    if(idx < 0 || idx >= VehicleCount) return 0;
    VehicleInfo[idx][vLockType] = locktype;
    new q[128];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `lock_type`=%d WHERE `id`=%d", locktype, VehicleInfo[idx][vSQLID]);
    mysql_tquery(MainPipeline, q);
    return 1;
}

stock ER_PlayVehicleRemoteSound(Float:x, Float:y, Float:z, world, interior)
{
    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i) || !PlayerInfo[i][pLoggedIn]) continue;
        if(GetPlayerVirtualWorld(i) != world || GetPlayerInterior(i) != interior) continue;
        if(IsPlayerInRangeOfPoint(i, 12.0, x, y, z)) PlayerPlaySound(i, 1145, x, y, z);
    }
    return 1;
}

stock ER_SendVehicleRemoteLine(playerid, vehicleid, bool:alarmMode, bool:enabled)
{
    new idx = ER_FindVehicleBySpawnID(vehicleid);
    if(idx == -1) return 0;

    new Float:x, Float:y, Float:z, msg[160];
    GetPlayerPos(playerid, x, y, z);

    if(alarmMode)
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            format(msg, sizeof(msg), "* %s %s the alarm system on their %s.", ER_GetName(playerid), enabled ? ("arms") : ("disarms"), ER_GetVehicleModelName(VehicleInfo[idx][vModel]));
        }
        else
        {
            format(msg, sizeof(msg), "* %s presses the remote and %s the alarm on their %s.", ER_GetName(playerid), enabled ? ("arms") : ("disarms"), ER_GetVehicleModelName(VehicleInfo[idx][vModel]));
        }
    }
    else
    {
        if(IsPlayerInAnyVehicle(playerid))
        {
            if(enabled)
                format(msg, sizeof(msg), "* %s locks the doors of their %s.", ER_GetName(playerid), ER_GetVehicleModelName(VehicleInfo[idx][vModel]));
            else
                format(msg, sizeof(msg), "* %s unlocks the doors of their %s.", ER_GetName(playerid), ER_GetVehicleModelName(VehicleInfo[idx][vModel]));
        }
        else
        {
            if(enabled)
                format(msg, sizeof(msg), "* %s presses the remote and locks their %s.", ER_GetName(playerid), ER_GetVehicleModelName(VehicleInfo[idx][vModel]));
            else
                format(msg, sizeof(msg), "* %s presses the remote and unlocks their %s.", ER_GetName(playerid), ER_GetVehicleModelName(VehicleInfo[idx][vModel]));
        }
    }

    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, msg, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    ER_PlayVehicleRemoteSound(x, y, z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

stock ER_SendVehicleActionLine(playerid, vehicleid, const action[])
{
    new idx = ER_FindVehicleBySpawnID(vehicleid);
    if(idx == -1) return 0;

    new Float:x, Float:y, Float:z, msg[160];
    GetPlayerPos(playerid, x, y, z);
    format(msg, sizeof(msg), "* %s %s the %s.", ER_GetName(playerid), action, ER_GetVehicleModelName(VehicleInfo[idx][vModel]));
    ER_NearbyMessage(x, y, z, CHAT_RANGE_NORMAL, COLOR_ME, msg, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

stock ER_HandleVehicleWindowText(playerid, const text[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == 0) return 0;

    new idx = ER_FindVehicleBySpawnID(vehicleid);
    if(idx == -1) return 0;

    // vWindows[0] = 1 means open, 0 means closed. Default is set open when vehicles load/spawn.
    if(VehicleInfo[idx][vWindows][0] != 0) return 0;

    new Float:x, Float:y, Float:z, msg[160];
    GetVehiclePos(vehicleid, x, y, z);

    if(PlayerInfo[playerid][pAccent] > 0)
    {
        format(msg, sizeof(msg), "%s says [windows closed, %s accent]: %s", ER_GetName(playerid), AccentNames[PlayerInfo[playerid][pAccent]], text);
    }
    else
    {
        format(msg, sizeof(msg), "%s says [windows closed]: %s", ER_GetName(playerid), text);
    }

    ER_NearbyMessage(x, y, z, CHAT_RANGE_LOW, COLOR_WHITE, msg, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
    return 1;
}

stock ER_ShowOwnedVehicleOptions(playerid, idx)
{
    if(idx < 0 || idx >= VehicleCount) return 0;
    SetPVarInt(playerid, "OwnedVehicleSQL", VehicleInfo[idx][vSQLID]);
    new title[96], list[256];
    format(title, sizeof(title), "%s - Vehicle Options", ER_GetVehicleModelName(VehicleInfo[idx][vModel]));
    format(list, sizeof(list), "Track Car\nGive Keys\nAdd Security\nRemove Security\nReset Mods");
    ShowPlayerDialog(playerid, DIALOG_MY_VEHICLE_OPTIONS, DIALOG_STYLE_LIST, title, list, "Select", "Back");
    return 1;
}

forward ER_OnMyVehicleSelected(playerid);
public ER_OnMyVehicleSelected(playerid)
{
    new rows, sqlid;
    cache_get_row_count(rows);
    if(!rows) return ER_Send(playerid, COLOR_GREY, "Vehicle not found.");
    cache_get_value_name_int(0, "id", sqlid);
    new idx = ER_FindVehicleBySQLID(sqlid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "This vehicle is not currently spawned.");
    return ER_ShowOwnedVehicleOptions(playerid, idx);
}

stock ER_VehicleDialog(playerid, dialogid, response, listitem, const inputtext[])
{
    if(dialogid == DIALOG_SKILLS_MAIN)
    {
        if(!response) return 1;
        if(listitem == 0) return ER_ShowHotwireSkill(playerid);
        return 1;
    }
    if(dialogid == DIALOG_SKILLS_HOTWIRE)
    {
        if(response) return ER_ShowSkills(playerid);
        return 1;
    }
	if(dialogid == DIALOG_TRACK_VEHICLE)
	{
		if(!response) return 1;
		new q[160];
		mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `vehicles` WHERE `owner_pid`=%d AND `enabled`=1 ORDER BY `id` ASC LIMIT %d,1", PlayerInfo[playerid][pID], listitem);
		mysql_tquery(MainPipeline, q, "ER_OnTrackVehicleSelect", "i", playerid);
		return 1;
	}


    if(dialogid == DIALOG_FTRACK_VEHICLE)
    {
        if(!response) return 1;
        new pvar[32]; format(pvar, sizeof(pvar), "FTrackVeh_%d", listitem);
        new sqlid = GetPVarInt(playerid, pvar);
        new idx = ER_FindVehicleBySQLID(sqlid);
        if(idx == -1) return ER_Send(playerid, COLOR_GREY, "This vehicle is not currently loaded.");
        if(!ER_PlayerCanUseGroupVehiclePerm(playerid, idx, 1)) return ER_Send(playerid, COLOR_GREY, "You do not have permission to track this vehicle.");
        ER_SetVehicleTrackingCheckpoint(playerid, idx);
        new msg[144];
        format(msg, sizeof(msg), "Tracking %s. Red checkpoint added to its current location.", ER_GetVehicleModelName(VehicleInfo[idx][vModel]));
        return ER_Send(playerid, COLOR_GREEN, msg);
    }

	if(dialogid == DIALOG_EDIT_VEHICLE_LIST)
	{
		if(!response) return 1;
		new q[160];
		mysql_format(MainPipeline, q, sizeof(q), "SELECT `id` FROM `vehicles` WHERE `enabled`=1 ORDER BY `id` ASC LIMIT %d,1", listitem);
		mysql_tquery(MainPipeline, q, "ER_OnEditVehicleListSelect", "i", playerid);
		return 1;
	}

	if(dialogid == DIALOG_MY_VEHICLES)
	{
		if(!response) return 1;
		new q[160];
		mysql_format(MainPipeline, q, sizeof(q), "SELECT `id` FROM `vehicles` WHERE `owner_pid`=%d AND `enabled`=1 ORDER BY `id` ASC LIMIT %d,1", PlayerInfo[playerid][pID], listitem);
		mysql_tquery(MainPipeline, q, "ER_OnMyVehicleSelected", "i", playerid);
		return 1;
	}

	if(dialogid == DIALOG_ALL_VEHICLES)
	{
		return 1;
	}


	if(dialogid == DIALOG_MY_VEHICLE_OPTIONS)
	{
		if(!response)
		{
			new q[160];
			mysql_format(MainPipeline, q, sizeof(q), "SELECT * FROM `vehicles` WHERE `owner_pid`=%d AND `enabled`=1 ORDER BY `id` ASC", PlayerInfo[playerid][pID]);
			mysql_tquery(MainPipeline, q, "ER_OnMyVehiclesDialog", "i", playerid);
			return 1;
		}
		new sqlid = GetPVarInt(playerid, "OwnedVehicleSQL");
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx == -1) return ER_Send(playerid, COLOR_GREY, "Vehicle not found.");
		if(VehicleInfo[idx][vOwnerPID] != PlayerInfo[playerid][pID]) return ER_Send(playerid, COLOR_GREY, "You do not own this vehicle.");

		switch(listitem)
		{
			case 0:
			{
				if(VehicleTrackIcon[playerid] != -1) DestroyDynamicMapIcon(VehicleTrackIcon[playerid]);
				VehicleTrackIcon[playerid] = CreateDynamicMapIcon(VehicleInfo[idx][vX], VehicleInfo[idx][vY], VehicleInfo[idx][vZ], 55, 0xFF0000FF, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), playerid, 6000.0, MAPICON_GLOBAL);
				return ER_Send(playerid, COLOR_GREEN, "Red marker added to your map for this vehicle.");
			}
			case 1:
			{
				return ER_Send(playerid, COLOR_GREY, "Key sharing will be added with the full keyholder system.");
			}
			case 2:
			{
				if(VehicleInfo[idx][vLockType] > 0) return ER_Send(playerid, COLOR_GREY, "This vehicle already has security installed.");
				if(PlayerInfo[playerid][pVehicleLock] <= 0) return ER_Send(playerid, COLOR_GREY, "You are not carrying any vehicle security item. Buy an alarm or industrial lock from a 24/7 or Gas Station.");
				new locktype = PlayerInfo[playerid][pVehicleLock];
				ER_SetVehicleLockType(idx, locktype);
				PlayerInfo[playerid][pVehicleLock] = 0;
				new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `vehicle_lock`=0 WHERE `id`=%d", PlayerInfo[playerid][pID]); mysql_tquery(MainPipeline, q);
				ER_Send(playerid, COLOR_GREEN, locktype == 1 ? ("Vehicle alarm installed.") : ("Industrial lock installed."));
				return ER_ShowOwnedVehicleOptions(playerid, idx);
			}
			case 3:
			{
				if(VehicleInfo[idx][vLockType] <= 0) return ER_Send(playerid, COLOR_GREY, "This vehicle has no security installed.");
				if(PlayerInfo[playerid][pVehicleLock] > 0) return ER_Send(playerid, COLOR_GREY, "You can only carry one vehicle security item at a time.");
				PlayerInfo[playerid][pVehicleLock] = VehicleInfo[idx][vLockType];
				ER_SetVehicleLockType(idx, 0);
				new q[128]; mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `vehicle_lock`=%d WHERE `id`=%d", PlayerInfo[playerid][pVehicleLock], PlayerInfo[playerid][pID]); mysql_tquery(MainPipeline, q);
				ER_Send(playerid, COLOR_GREEN, "Vehicle security removed and placed in your inventory.");
				return ER_ShowOwnedVehicleOptions(playerid, idx);
			}
			case 4:
			{
				ER_ResetAllVehicleMods(idx);
				return ER_Send(playerid, COLOR_GREEN, "Vehicle modifications have been reset.");
			}
		}
		return 1;
	}

	if(dialogid == DIALOG_EDIT_VEHICLE_MENU)
	{
		if(!response) return 1;
		new sqlid = GetPVarInt(playerid, "EditingVehicleID");
		if(sqlid <= 0) return 1;

		new pvar[32];
		format(pvar, sizeof(pvar), "VehEditAction%d", listitem);
		new action = GetPVarInt(playerid, pvar);

		switch(action)
		{
			case 0: ER_ShowVehicleOwnerMenu(playerid);
			case 1: ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_MODEL, DIALOG_STYLE_INPUT, "Vehicle Model", "Enter model ID or vehicle name:", "Save", "Back");
			case 2: ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_COLOR1, DIALOG_STYLE_INPUT, "Vehicle Color 1", "Enter color 1 number:", "Save", "Back");
			case 3: ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_COLOR2, DIALOG_STYLE_INPUT, "Vehicle Color 2", "Enter color 2 number:", "Save", "Back");
			case 4:
			{
				new idx = ER_FindVehicleBySQLID(sqlid);
				if(idx == -1 || !ER_CanVehicleUsePaintjob(VehicleInfo[idx][vModel])) return ER_Send(playerid, COLOR_GREY, "This vehicle does not support paintjobs.");
				ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_PAINTJOB, DIALOG_STYLE_LIST, "Vehicle Paintjob", "None\nPaintjob 1\nPaintjob 2\nPaintjob 3", "Select", "Back");
			}
			case 5:
			{
				new idx = ER_FindVehicleBySQLID(sqlid);
				if(idx == -1 || !ER_CanVehicleUseNOS(VehicleInfo[idx][vModel])) return ER_Send(playerid, COLOR_GREY, "This vehicle does not support NOS.");
				ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_NOS, DIALOG_STYLE_LIST, "Vehicle NOS", "Unlimited NOS\nNone\nNOS 2x\nNOS 5x\nNOS 10x", "Select", "Back");
			}
			case 6:
			{
				new idx = ER_FindVehicleBySQLID(sqlid);
				if(idx == -1 || !ER_CanVehicleUseHydraulics(VehicleInfo[idx][vModel])) return ER_Send(playerid, COLOR_GREY, "This vehicle does not support hydraulics.");
				ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_HYDRAULICS, DIALOG_STYLE_LIST, "Vehicle Hydraulics", "None\nHydraulics", "Select", "Back");
			}
			case 7:
			{
				new idx = ER_FindVehicleBySQLID(sqlid);
				if(idx == -1 || !ER_CanVehicleUseRims(VehicleInfo[idx][vModel])) return ER_Send(playerid, COLOR_GREY, "This vehicle does not support rims.");
				ER_ShowVehicleRimsList(playerid);
			}
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
			case 14:
			{
				new idx = ER_FindVehicleBySQLID(sqlid), msg[128];
				if(idx == -1) return ER_ShowVehicleEditor(playerid, sqlid);
				format(msg, sizeof(msg), "Enter fuel amount for this vehicle (0-100):\n\nCurrent Fuel: %d/100", floatround(VehicleInfo[idx][vFuel]));
				return ShowPlayerDialog(playerid, DIALOG_EDIT_VEH_FUEL, DIALOG_STYLE_INPUT, "Vehicle Fuel", msg, "Save", "Back");
			}
			case 15:
			{
				new idx = ER_FindVehicleBySQLID(sqlid), q[160], msg[96];
				if(idx == -1) return ER_ShowVehicleEditor(playerid, sqlid);
				VehicleInfo[idx][vUnlimitedFuel] = !VehicleInfo[idx][vUnlimitedFuel];
				mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `unlimited_fuel`=%d WHERE `id`=%d", VehicleInfo[idx][vUnlimitedFuel], sqlid);
				mysql_tquery(MainPipeline, q);
				foreach(new p : Player)
				{
					if(GetPlayerState(p) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(p) == VehicleInfo[idx][vSpawnedID]) ER_UpdateVehicleHUD(p);
				}
				format(msg, sizeof(msg), "Unlimited fuel %s.", VehicleInfo[idx][vUnlimitedFuel] ? ("enabled") : ("disabled"));
				ER_Send(playerid, COLOR_GREEN, msg);
				return ER_ShowVehicleEditor(playerid, sqlid);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_EDIT_VEH_FUEL)
	{
		new sqlid = GetPVarInt(playerid, "EditingVehicleID");
		if(!response) return ER_ShowVehicleEditor(playerid, sqlid);
		new idx = ER_FindVehicleBySQLID(sqlid);
		if(idx == -1) return ER_ShowVehicleEditor(playerid, sqlid);
		new fuel = strval(inputtext);
		if(fuel < 0 || fuel > 100) return ER_Send(playerid, COLOR_GREY, "Fuel must be between 0 and 100.");
		VehicleInfo[idx][vUnlimitedFuel] = 0;
		ER_SetVehicleFuel(idx, float(fuel));
		new q[160];
		mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `fuel`=%f,`unlimited_fuel`=0 WHERE `id`=%d", VehicleInfo[idx][vFuel], sqlid);
		mysql_tquery(MainPipeline, q);
		ER_Send(playerid, COLOR_GREEN, "Vehicle fuel updated.");
		return ER_ShowVehicleEditor(playerid, sqlid);
	}

	if(dialogid == DIALOG_EDIT_VEH_SET_JOB)
	{
		new sqlid = GetPVarInt(playerid, "EditingVehicleID");
		if(!response) return ER_ShowVehicleEditor(playerid, sqlid);
		new jobid = strval(inputtext);
		if(jobid < 0) jobid = 0;
		if(jobid > 11) return ER_Send(playerid, COLOR_GREY, "Invalid job type ID. Use 0-11.");
		return ER_SetVehicleOwner(playerid, sqlid, 4, jobid);
	}

	if(dialogid == DIALOG_EDIT_VEH_OWNER)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));

		switch(listitem)
		{
			case 0:
			{
				return ShowPlayerDialog(playerid, DIALOG_VEHOWN_PTYPE, DIALOG_STYLE_LIST, "Player Owner", "Online Player\nOffline Player", "Select", "Back");
			}
			case 1: return ER_ShowVehOwnerOffline(playerid);
			case 2: return ER_ShowVehicleOwnerFamilies(playerid);
			case 3: return ER_ShowVehicleOwnerFactions(playerid);
			case 4: return ER_ShowVehicleOwnerJobs(playerid);
		}

		new q[128], sqlid = GetPVarInt(playerid, "EditingVehicleID");
		mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `owner_pid`=0,`family_id`=0,`faction_id`=0,`job_id`=0 WHERE `id`=%d", sqlid);
		mysql_tquery(MainPipeline, q, "ER_ReloadVehicles");
		ER_Send(playerid, COLOR_GREEN, "Vehicle owner cleared.");
		return ER_ShowVehicleEditor(playerid, sqlid);
	}

	if(dialogid == DIALOG_VEHOWN_PTYPE)
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
			return ShowPlayerDialog(playerid, DIALOG_VEHOWN_ONLINE, DIALOG_STYLE_TABLIST, "Select Online Player", list, "Select", "Back");
		}
		return ER_ShowVehOwnerOffline(playerid);
	}

	if(dialogid == DIALOG_VEHOWN_ONLINE)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		new pvarname[24]; format(pvarname, sizeof(pvarname), "OwnerOnline%d", listitem); new target = GetPVarInt(playerid, pvarname);
		if(!IsPlayerConnected(target) || PlayerInfo[target][pID] <= 0) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		return ER_SetVehicleOwner(playerid, GetPVarInt(playerid, "EditingVehicleID"), 1, PlayerInfo[target][pID]);
	}


	if(dialogid == DIALOG_VEHOWN_OFFLINE)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		if(listitem < 0 || listitem >= GetPVarInt(playerid, "VehOwnerOfflineCount")) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		new key[32]; format(key, sizeof(key), "VehOwnerOffline%d", listitem);
		return ER_SetVehicleOwner(playerid, GetPVarInt(playerid, "EditingVehicleID"), 1, GetPVarInt(playerid, key));
	}

	if(dialogid == DIALOG_VEHOWN_FAMILY)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		if(listitem < 0 || listitem >= GetPVarInt(playerid, "VehOwnerFamilyCount")) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		new key[32]; format(key, sizeof(key), "VehOwnerFamily%d", listitem);
		return ER_SetVehicleOwner(playerid, GetPVarInt(playerid, "EditingVehicleID"), 2, GetPVarInt(playerid, key));
	}

	if(dialogid == DIALOG_VEHOWN_FACTION)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		if(listitem < 0 || listitem >= GetPVarInt(playerid, "VehOwnerFactionCount")) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		new key[32]; format(key, sizeof(key), "VehOwnerFaction%d", listitem);
		return ER_SetVehicleOwner(playerid, GetPVarInt(playerid, "EditingVehicleID"), 3, GetPVarInt(playerid, key));
	}

	if(dialogid == DIALOG_VEHOWN_JOB)
	{
		if(!response) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		if(listitem < 0 || listitem >= GetPVarInt(playerid, "VehOwnerJobCount")) return ER_ShowVehicleEditor(playerid, GetPVarInt(playerid, "EditingVehicleID"));
		new key[32]; format(key, sizeof(key), "VehOwnerJob%d", listitem);
		return ER_SetVehicleOwner(playerid, GetPVarInt(playerid, "EditingVehicleID"), 4, GetPVarInt(playerid, key));
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
		new oldcomponent = ER_GetVehicleModComponentBySlot(idx, GetPVarInt(playerid, "EditingVehicleModSlot"));

		if(component > 0 && !ER_IsComponentCompatible(VehicleInfo[idx][vModel], component))
		{
			ER_Send(playerid, COLOR_GREY, "This component is not compatible with the selected vehicle.");
			return ER_ShowVehicleEditor(playerid, sqlid);
		}

		switch(GetPVarInt(playerid, "EditingVehicleModSlot"))
		{
			case 0: VehicleInfo[idx][vModSpoiler] = component;
			case 1: VehicleInfo[idx][vModHood] = component;
			case 2: VehicleInfo[idx][vModRoof] = component;
			case 3, 4: ER_SetVehicleSideSkirtSet(idx, component);
			case 5: VehicleInfo[idx][vModLamps] = component;
			case 6: { VehicleInfo[idx][vModNitro] = component; VehicleInfo[idx][vNos] = component; }
			case 7: VehicleInfo[idx][vModExhaust] = component;
			case 8: VehicleInfo[idx][vModWheels] = component;
			case 9: VehicleInfo[idx][vModStereo] = component;
			case 10: VehicleInfo[idx][vModHydraulics] = component;
			case 11: VehicleInfo[idx][vModFrontBumper] = component;
			case 12: VehicleInfo[idx][vModRearBumper] = component;
			case 13: VehicleInfo[idx][vModVentRight] = component;
			case 14: VehicleInfo[idx][vModVentLeft] = component;
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

		if(VehicleInfo[idx][vSpawnedID] != INVALID_VEHICLE_ID)
		{
			new slot = GetPVarInt(playerid, "EditingVehicleModSlot");

			if(slot == 3 || slot == 4)
			{
				if(oldcomponent > 0) RemoveVehicleComponent(VehicleInfo[idx][vSpawnedID], oldcomponent);
				new oldpair = ER_GetMatchingSideSkirt(oldcomponent);
				if(oldpair > 0) RemoveVehicleComponent(VehicleInfo[idx][vSpawnedID], oldpair);

				if(component > 0)
				{
					ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModSideskirtL]);
					ER_SafeAddVehicleComponent(idx, VehicleInfo[idx][vModSideskirtR]);
				}
			}
			else
			{
				if(oldcomponent > 0) RemoveVehicleComponent(VehicleInfo[idx][vSpawnedID], oldcomponent);
				if(component > 0) ER_SafeAddVehicleComponent(idx, component);
			}
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
	new rows, sqlid, model;
	cache_get_row_count(rows);
	if(!rows) return ER_Send(playerid, COLOR_GREY, "Vehicle not found.");

	cache_get_value_name_int(0, "id", sqlid);
	cache_get_value_name_int(0, "model", model);

    new idx = ER_FindVehicleBySQLID(sqlid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "This vehicle is not currently loaded.");
    ER_SetVehicleTrackingCheckpoint(playerid, idx);

	new msg[144];
	format(msg, sizeof(msg), "Tracking vehicle %d: %s. Red checkpoint added to its current location.", sqlid, ER_GetVehicleModelName(model));
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
        return 1;
    }

    if(VehicleInfo[idx][vFactionID] > 0 && VehicleInfo[idx][vFactionID] == PlayerInfo[playerid][pFaction])
    {
        return 1;
    }

    if(VehicleInfo[idx][vFamilyID] > 0 && VehicleInfo[idx][vFamilyID] == PlayerInfo[playerid][pFamily])
    {
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


stock ER_GetFamilyVehiclePermRank(familyid, permtype)
{
    new idx = ER_FindFamilyIndexBySQLID(familyid);
    if(idx == -1) return 6;
    switch(permtype)
    {
        case 1: return Families[idx][fVehicleTrackRank];
        case 2: return Families[idx][fVehicleParkRank];
    }
    return Families[idx][fVehicleLockRank];
}

stock ER_GetFactionVehiclePermRank(factionid, permtype)
{
    new idx = ER_FindFactionIndexBySQLID(factionid);
    if(idx == -1) return 6;
    switch(permtype)
    {
        case 1: return Factions[idx][facVehicleTrackRank];
        case 2: return Factions[idx][facVehicleParkRank];
    }
    return Factions[idx][facVehicleLockRank];
}

stock ER_PlayerCanUseGroupVehiclePerm(playerid, idx, permtype)
{
    if(idx < 0 || idx >= MAX_DYNAMIC_VEHICLES) return 0;
    if(VehicleInfo[idx][vFactionID] > 0 && VehicleInfo[idx][vFactionID] == PlayerInfo[playerid][pFaction])
    {
        return (PlayerInfo[playerid][pFactionRank] >= ER_GetFactionVehiclePermRank(VehicleInfo[idx][vFactionID], permtype));
    }
    if(VehicleInfo[idx][vFamilyID] > 0 && VehicleInfo[idx][vFamilyID] == PlayerInfo[playerid][pFamily])
    {
        return (PlayerInfo[playerid][pFamilyRank] >= ER_GetFamilyVehiclePermRank(VehicleInfo[idx][vFamilyID], permtype));
    }
    return 0;
}

stock ER_SetVehicleTrackingCheckpoint(playerid, idx)
{
    if(idx < 0 || idx >= MAX_DYNAMIC_VEHICLES) return 0;
    new Float:x = VehicleInfo[idx][vX], Float:y = VehicleInfo[idx][vY], Float:z = VehicleInfo[idx][vZ];
    new vehicleid = VehicleInfo[idx][vSpawnedID];
    if(vehicleid != INVALID_VEHICLE_ID && vehicleid != 0)
    {
        GetVehiclePos(vehicleid, x, y, z);
    }
    if(VehicleTrackIcon[playerid] != -1) DestroyDynamicMapIcon(VehicleTrackIcon[playerid]);
    VehicleTrackIcon[playerid] = CreateDynamicMapIcon(x, y, z, 55, 0xFF0000FF, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid), playerid, 6000.0, MAPICON_GLOBAL);
    SetPlayerCheckpoint(playerid, x, y, z, 4.0);
    SetPVarInt(playerid, "TrackVehicle", VehicleInfo[idx][vSQLID]);
    return 1;
}


stock ER_GetNearestUsableVehicle(playerid, Float:range = 5.0)
{
    new closestVehicle = 0;
    new Float:bestDist = range + 0.001;
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    for(new i; i < MAX_DYNAMIC_VEHICLES; i++)
    {
        new vehicleid = VehicleInfo[i][vSpawnedID];
        if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0) continue;
        if(!(VehicleInfo[i][vOwnerPID] > 0 && VehicleInfo[i][vOwnerPID] == PlayerInfo[playerid][pID])
        && !(VehicleInfo[i][vFactionID] > 0 && VehicleInfo[i][vFactionID] == PlayerInfo[playerid][pFaction])
        && !(VehicleInfo[i][vFamilyID] > 0 && VehicleInfo[i][vFamilyID] == PlayerInfo[playerid][pFamily])) continue;

        new Float:vx, Float:vy, Float:vz;
        GetVehiclePos(vehicleid, vx, vy, vz);
        new Float:dist = floatsqroot(floatpower(px - vx, 2.0) + floatpower(py - vy, 2.0) + floatpower(pz - vz, 2.0));
        if(dist < bestDist)
        {
            bestDist = dist;
            closestVehicle = vehicleid;
        }
    }
    return closestVehicle;
}


stock ER_StyleVehicleHUDText(playerid, PlayerText:td, alignment = 1)
{
    PlayerTextDrawBackgroundColor(playerid, td, 255);
    PlayerTextDrawFont(playerid, td, 1);
    PlayerTextDrawLetterSize(playerid, td, 0.240000, 1.150000);
    PlayerTextDrawColor(playerid, td, -1);
    PlayerTextDrawSetOutline(playerid, td, 1);
    PlayerTextDrawSetProportional(playerid, td, 1);
    PlayerTextDrawAlignment(playerid, td, alignment);
    return 1;
}

stock Float:ER_GetVehicleSpeedKMH(vehicleid)
{
    new Float:vx, Float:vy, Float:vz;
    GetVehicleVelocity(vehicleid, vx, vy, vz);
    return floatsqroot((vx * vx) + (vy * vy) + (vz * vz)) * 180.0;
}

stock ER_CreateVehicleHUD(playerid)
{
    if(ER_VehHudCreated[playerid]) return 1;

    // NGRP-style compact box, bottom-right. Left column: speed/fuel/mileage/seatbelt. Right column: engine/lights/hood/trunk.
    ER_VehHudBox[playerid] = CreatePlayerTextDraw(playerid, 438.000000, 335.000000, "_");
    PlayerTextDrawBackgroundColor(playerid, ER_VehHudBox[playerid], 180);
    PlayerTextDrawColor(playerid, ER_VehHudBox[playerid], 0x000000AA);
    PlayerTextDrawUseBox(playerid, ER_VehHudBox[playerid], 1);
    PlayerTextDrawBoxColor(playerid, ER_VehHudBox[playerid], 0x000000AA);
    PlayerTextDrawTextSize(playerid, ER_VehHudBox[playerid], 635.000000, 0.000000);
    PlayerTextDrawLetterSize(playerid, ER_VehHudBox[playerid], 0.000000, 8.500000);
    PlayerTextDrawFont(playerid, ER_VehHudBox[playerid], 1);

    ER_VehHudTitle[playerid] = CreatePlayerTextDraw(playerid, 536.000000, 338.000000, "VEHICLE");
    ER_StyleVehicleHUDText(playerid, ER_VehHudTitle[playerid], 2);
    PlayerTextDrawLetterSize(playerid, ER_VehHudTitle[playerid], 0.280000, 1.250000);

    ER_VehHudDivider[playerid] = CreatePlayerTextDraw(playerid, 536.000000, 360.000000, "|");
    ER_StyleVehicleHUDText(playerid, ER_VehHudDivider[playerid], 2);
    PlayerTextDrawLetterSize(playerid, ER_VehHudDivider[playerid], 0.300000, 5.000000);

    ER_VehHudSpeed[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 358.000000, "~b~Speed: ~w~0 KM/H");
    ER_StyleVehicleHUDText(playerid, ER_VehHudSpeed[playerid]);

    ER_VehHudFuel[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 372.000000, "~b~Fuel: ~w~100%");
    ER_StyleVehicleHUDText(playerid, ER_VehHudFuel[playerid]);

    ER_VehHudMileage[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 386.000000, "~b~Mileage: ~w~0.0 KM");
    ER_StyleVehicleHUDText(playerid, ER_VehHudMileage[playerid]);

    ER_VehHudSeatbelt[playerid] = CreatePlayerTextDraw(playerid, 444.000000, 400.000000, "~b~Seatbelt: ~r~Not Fastened");
    ER_StyleVehicleHUDText(playerid, ER_VehHudSeatbelt[playerid]);

    ER_VehHudEngine[playerid] = CreatePlayerTextDraw(playerid, 548.000000, 358.000000, "~b~Engine: ~r~OFF");
    ER_StyleVehicleHUDText(playerid, ER_VehHudEngine[playerid]);

    ER_VehHudLights[playerid] = CreatePlayerTextDraw(playerid, 548.000000, 372.000000, "~b~Lights: ~r~OFF");
    ER_StyleVehicleHUDText(playerid, ER_VehHudLights[playerid]);

    ER_VehHudHood[playerid] = CreatePlayerTextDraw(playerid, 548.000000, 386.000000, "~b~Hood: ~r~Closed");
    ER_StyleVehicleHUDText(playerid, ER_VehHudHood[playerid]);

    ER_VehHudTrunk[playerid] = CreatePlayerTextDraw(playerid, 548.000000, 400.000000, "~b~Trunk: ~r~Closed");
    ER_StyleVehicleHUDText(playerid, ER_VehHudTrunk[playerid]);

    ER_VehHudCreated[playerid] = true;
    return 1;
}

stock ER_UpdateVehicleHUD(playerid)
{
    if(!IsPlayerConnected(playerid) || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
    new vehicleid = GetPlayerVehicleID(playerid);
    new idx = ER_FindVehicleBySpawnID(vehicleid);
    if(idx == -1)
    {
        ER_HideVehicleHUD(playerid);
        return 0;
    }

    ER_CreateVehicleHUD(playerid);

    new engine, lights, alarm, doors, bonnet, boot, objective, line[72];
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    ER_NormalizeVehicleParams(engine, lights, alarm, doors, bonnet, boot, objective);

    new model = GetVehicleModel(vehicleid);
    format(line, sizeof(line), "%s", ER_GetVehicleModelName(model));
    PlayerTextDrawSetString(playerid, ER_VehHudTitle[playerid], line);

    format(line, sizeof(line), "~b~Speed: ~w~%d KM/H", floatround(ER_GetVehicleSpeedKMH(vehicleid)));
    PlayerTextDrawSetString(playerid, ER_VehHudSpeed[playerid], line);

    format(line, sizeof(line), "~b~Fuel: ~w~%d%%", floatround(VehicleInfo[idx][vFuel]));
    PlayerTextDrawSetString(playerid, ER_VehHudFuel[playerid], line);

    format(line, sizeof(line), "~b~Mileage: ~w~%.1f KM", VehicleInfo[idx][vMileage]);
    PlayerTextDrawSetString(playerid, ER_VehHudMileage[playerid], line);

    format(line, sizeof(line), "~b~Seatbelt: %s", ER_PlayerSeatbelt[playerid] ? "~g~Fastened" : "~r~Not Fastened");
    PlayerTextDrawSetString(playerid, ER_VehHudSeatbelt[playerid], line);

    format(line, sizeof(line), "~b~Engine: %s", engine == VEHICLE_PARAMS_ON ? "~g~ON" : "~r~OFF");
    PlayerTextDrawSetString(playerid, ER_VehHudEngine[playerid], line);

    format(line, sizeof(line), "~b~Lights: %s", lights == VEHICLE_PARAMS_ON ? "~g~ON" : "~r~OFF");
    PlayerTextDrawSetString(playerid, ER_VehHudLights[playerid], line);

    format(line, sizeof(line), "~b~Hood: %s", bonnet == VEHICLE_PARAMS_ON ? "~g~Open" : "~r~Closed");
    PlayerTextDrawSetString(playerid, ER_VehHudHood[playerid], line);

    format(line, sizeof(line), "~b~Trunk: %s", boot == VEHICLE_PARAMS_ON ? "~g~Open" : "~r~Closed");
    PlayerTextDrawSetString(playerid, ER_VehHudTrunk[playerid], line);
    return 1;
}

stock ER_ShowVehicleHUD(playerid)
{
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
    ER_CreateVehicleHUD(playerid);
    ER_UpdateVehicleHUD(playerid);
    PlayerTextDrawShow(playerid, ER_VehHudBox[playerid]);
    PlayerTextDrawShow(playerid, ER_VehHudTitle[playerid]);
    PlayerTextDrawShow(playerid, ER_VehHudDivider[playerid]);
    PlayerTextDrawShow(playerid, ER_VehHudSpeed[playerid]);
    PlayerTextDrawShow(playerid, ER_VehHudFuel[playerid]);
    PlayerTextDrawShow(playerid, ER_VehHudMileage[playerid]);
    PlayerTextDrawShow(playerid, ER_VehHudSeatbelt[playerid]);
    PlayerTextDrawShow(playerid, ER_VehHudEngine[playerid]);
    PlayerTextDrawShow(playerid, ER_VehHudLights[playerid]);
    PlayerTextDrawShow(playerid, ER_VehHudHood[playerid]);
    PlayerTextDrawShow(playerid, ER_VehHudTrunk[playerid]);
    new Float:x, Float:y, Float:z;
    GetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
    ER_VehHudLastX[playerid] = x;
    ER_VehHudLastY[playerid] = y;
    ER_VehHudLastZ[playerid] = z;
    ER_VehHudLastPosValid[playerid] = true;
    ER_VehHudVisible[playerid] = true;
    return 1;
}

stock ER_HideVehicleHUD(playerid)
{
    if(!ER_VehHudCreated[playerid]) return 1;
    PlayerTextDrawHide(playerid, ER_VehHudBox[playerid]);
    PlayerTextDrawHide(playerid, ER_VehHudTitle[playerid]);
    PlayerTextDrawHide(playerid, ER_VehHudDivider[playerid]);
    PlayerTextDrawHide(playerid, ER_VehHudSpeed[playerid]);
    PlayerTextDrawHide(playerid, ER_VehHudFuel[playerid]);
    PlayerTextDrawHide(playerid, ER_VehHudMileage[playerid]);
    PlayerTextDrawHide(playerid, ER_VehHudSeatbelt[playerid]);
    PlayerTextDrawHide(playerid, ER_VehHudEngine[playerid]);
    PlayerTextDrawHide(playerid, ER_VehHudLights[playerid]);
    PlayerTextDrawHide(playerid, ER_VehHudHood[playerid]);
    PlayerTextDrawHide(playerid, ER_VehHudTrunk[playerid]);
    ER_VehHudVisible[playerid] = false;
    ER_VehHudLastPosValid[playerid] = false;
    return 1;
}

forward ER_DelayedVehicleHUD(playerid);
public ER_DelayedVehicleHUD(playerid)
{
    if(IsPlayerConnected(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) ER_ShowVehicleHUD(playerid);
    return 1;
}

stock ER_OnVehicleHudSeatEntered(playerid, vehicleid)
{
    #pragma unused vehicleid
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        ER_ShowVehicleHUD(playerid);
        SetTimerEx("ER_DelayedVehicleHUD", 500, false, "i", playerid);
        return 1;
    }
    return ER_HideVehicleHUD(playerid);
}

stock ER_OnVehicleHudSeatExited(playerid, vehicleid)
{
    #pragma unused vehicleid
    ER_PlayerSeatbelt[playerid] = false;
    return ER_HideVehicleHUD(playerid);
}

stock ER_SetVehicleFuel(idx, Float:fuel)
{
    if(idx < 0 || idx >= VehicleCount) return 0;
    if(fuel < 0.0) fuel = 0.0;
    if(fuel > 100.0) fuel = 100.0;
    VehicleInfo[idx][vFuel] = fuel;
    foreach(new p : Player)
    {
        if(GetPlayerState(p) == PLAYER_STATE_DRIVER && GetPlayerVehicleID(p) == VehicleInfo[idx][vSpawnedID]) ER_UpdateVehicleHUD(p);
    }
    new q[128];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `fuel`=%f WHERE `id`=%d", VehicleInfo[idx][vFuel], VehicleInfo[idx][vSQLID]);
    mysql_tquery(MainPipeline, q);
    return 1;
}

stock ER_SaveVehicleMileage(idx)
{
    if(idx < 0 || idx >= VehicleCount) return 0;
    new q[128];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `mileage`=%f WHERE `id`=%d", VehicleInfo[idx][vMileage], VehicleInfo[idx][vSQLID]);
    mysql_tquery(MainPipeline, q);
    return 1;
}

forward ER_VehicleHudTick();
public ER_VehicleHudTick()
{
    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i) || GetPlayerState(i) != PLAYER_STATE_DRIVER)
        {
            if(ER_VehHudVisible[i]) ER_HideVehicleHUD(i);
            continue;
        }

        new vehicleid = GetPlayerVehicleID(i);
        new idx = ER_FindVehicleBySpawnID(vehicleid);
        if(idx == -1)
        {
            ER_HideVehicleHUD(i);
            continue;
        }

        new Float:x, Float:y, Float:z;
        GetVehiclePos(vehicleid, x, y, z);
        if(ER_VehHudLastPosValid[i])
        {
            new Float:dx = x - ER_VehHudLastX[i];
            new Float:dy = y - ER_VehHudLastY[i];
            new Float:dz = z - ER_VehHudLastZ[i];
            new Float:dist = floatsqroot((dx * dx) + (dy * dy) + (dz * dz));

            // Add driven distance as kilometers. Ignore tiny jitter and teleport-sized jumps.
            if(dist > 0.50 && dist < 150.0)
            {
                new engine, lights, alarm, doors, bonnet, boot, objective;
                GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                ER_NormalizeVehicleParams(engine, lights, alarm, doors, bonnet, boot, objective);
                if(engine == VEHICLE_PARAMS_ON) VehicleInfo[idx][vMileage] += (dist / 1000.0);
            }
        }

        ER_VehHudLastX[i] = x;
        ER_VehHudLastY[i] = y;
        ER_VehHudLastZ[i] = z;
        ER_VehHudLastPosValid[i] = true;

        if(!ER_VehHudVisible[i]) ER_ShowVehicleHUD(i);
        else ER_UpdateVehicleHUD(i);
    }
    return 1;
}

forward ER_VehicleFuelTick();
public ER_VehicleFuelTick()
{
    foreach(new i : Player)
    {
        if(!IsPlayerConnected(i) || GetPlayerState(i) != PLAYER_STATE_DRIVER) continue;
        new vehicleid = GetPlayerVehicleID(i);
        new idx = ER_FindVehicleBySpawnID(vehicleid);
        if(idx == -1) continue;

        new engine, lights, alarm, doors, bonnet, boot, objective;
        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        ER_NormalizeVehicleParams(engine, lights, alarm, doors, bonnet, boot, objective);

        if(engine == VEHICLE_PARAMS_ON)
        {
            if(!VehicleInfo[idx][vUnlimitedFuel] && VehicleInfo[idx][vFuel] <= 0.0)
            {
                engine = VEHICLE_PARAMS_OFF;
                SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                ER_Send(i, COLOR_GREY, "This vehicle is out of fuel. Refill it before starting the engine again.");
            }
            else
            {
                ER_SetVehicleFuel(idx, VehicleInfo[idx][vFuel] - 1.0);
                if(VehicleInfo[idx][vFuel] <= 0.0)
                {
                    engine = VEHICLE_PARAMS_OFF;
                    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
                    ER_Send(i, COLOR_GREY, "The engine has stopped because the vehicle ran out of fuel.");
                }
            }
        }
        ER_SaveVehicleMileage(idx);
        if(ER_VehHudVisible[i]) ER_UpdateVehicleHUD(i);
    }
    return 1;
}

stock ER_NormalizeVehicleParams(&engine, &lights, &alarm, &doors, &bonnet, &boot, &objective)
{
    if(engine != VEHICLE_PARAMS_ON && engine != VEHICLE_PARAMS_OFF) engine = VEHICLE_PARAMS_OFF;
    if(lights != VEHICLE_PARAMS_ON && lights != VEHICLE_PARAMS_OFF) lights = VEHICLE_PARAMS_OFF;
    if(alarm != VEHICLE_PARAMS_ON && alarm != VEHICLE_PARAMS_OFF) alarm = VEHICLE_PARAMS_OFF;
    if(doors != VEHICLE_PARAMS_ON && doors != VEHICLE_PARAMS_OFF) doors = VEHICLE_PARAMS_OFF;
    if(bonnet != VEHICLE_PARAMS_ON && bonnet != VEHICLE_PARAMS_OFF) bonnet = VEHICLE_PARAMS_OFF;
    if(boot != VEHICLE_PARAMS_ON && boot != VEHICLE_PARAMS_OFF) boot = VEHICLE_PARAMS_OFF;
    if(objective != VEHICLE_PARAMS_ON && objective != VEHICLE_PARAMS_OFF) objective = VEHICLE_PARAMS_OFF;
    return 1;
}


stock ER_GetHotwireLevel(playerid)
{
    new level = PlayerInfo[playerid][pHotwireLevel];
    if(level < 1) level = 1;
    if(level > 5) level = 5;
    return level;
}

stock ER_GetHotwireSeconds(playerid)
{
    switch(ER_GetHotwireLevel(playerid))
    {
        case 1: return 12;
        case 2: return 10;
        case 3: return 8;
        case 4: return 6;
    }
    return 4;
}

stock ER_GetHotwireChance(playerid, vehicleid)
{
    new chance;
    switch(ER_GetHotwireLevel(playerid))
    {
        case 1: chance = 25;
        case 2: chance = 40;
        case 3: chance = 55;
        case 4: chance = 70;
        default: chance = 85;
    }

    new idx = ER_FindVehicleBySpawnID(vehicleid);
    if(idx != -1)
    {
        if(VehicleInfo[idx][vLockType] == 1) chance -= 5;       // Alarm makes it slightly harder.
        else if(VehicleInfo[idx][vLockType] == 2) chance -= 20; // Industrial lock is harder.
    }
    if(chance < 5) chance = 5;
    if(chance > 95) chance = 95;
    return chance;
}

stock ER_GetHotwireProgressNeeded(level)
{
    if(level < 1) level = 1;
    switch(level)
    {
        case 1: return 50;   // Level 1 -> 2
        case 2: return 125;  // Level 2 -> 3
        case 3: return 250;  // Level 3 -> 4
        case 4: return 450;  // Level 4 -> 5
    }
    return 0;
}

stock ER_UpdateHotwireLevel(playerid)
{
    new level = ER_GetHotwireLevel(playerid);
    new xp = PlayerInfo[playerid][pHotwireSuccess] * 3 + PlayerInfo[playerid][pHotwireFail];
    new oldLevel = level;
    while(level < 5 && xp >= ER_GetHotwireProgressNeeded(level))
    {
        level++;
    }
    PlayerInfo[playerid][pHotwireLevel] = level;
    if(level > oldLevel)
    {
        new msg[128];
        format(msg, sizeof(msg), "~g~HOTWIRING SKILL IMPROVED!~n~~w~Level %d Reached", level);
        GameTextForPlayer(playerid, msg, 4500, 4);
        format(msg, sizeof(msg), "Your hotwiring skill increased to Level %d. Success chance increased to %d%%. Hotwire time reduced by 2 seconds.", level, ER_GetHotwireChance(playerid, 0));
        ER_Send(playerid, COLOR_GREEN, msg);
    }
    return level;
}

stock ER_SaveHotwireStats(playerid)
{
    if(PlayerInfo[playerid][pID] <= 0) return 0;
    new q[192];
    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `accounts` SET `hotwire_level`=%d,`hotwire_success`=%d,`hotwire_fail`=%d,`hotwire_kits`=%d WHERE `id`=%d", PlayerInfo[playerid][pHotwireLevel], PlayerInfo[playerid][pHotwireSuccess], PlayerInfo[playerid][pHotwireFail], PlayerInfo[playerid][pHotwireKits], PlayerInfo[playerid][pID]);
    mysql_tquery(MainPipeline, q);
    return 1;
}

stock ER_ShowEngineStartingText(playerid, seconds)
{
    GameTextForPlayer(playerid, "~w~Vehicle Engine: ~g~Starting~w~...", seconds * 1000, 4);
    return 1;
}

stock ER_ShowHotwireText(playerid, seconds)
{
    new gt[64];
    format(gt, sizeof(gt), "~w~Hotwiring Vehicle... ~y~%d", seconds);
    GameTextForPlayer(playerid, gt, 1200, 4);
    return 1;
}

stock ER_ShowHotwireResult(playerid, bool:success)
{
    GameTextForPlayer(playerid, success ? ("~w~Hotwiring ~g~Succeeded") : ("~w~Hotwiring ~r~Failed"), 3000, 4);
    new msg[96];
    format(msg, sizeof(msg), "Hotwire Attempts~n~Succeeded: %d~n~Failed: %d", PlayerInfo[playerid][pHotwireSuccess], PlayerInfo[playerid][pHotwireFail]);
    GameTextForPlayer(playerid, msg, 3500, 5);
    return 1;
}

stock ER_StartHotwireAttempt(playerid, vehicleid)
{
    if(!ServerCore[scAllowVehicleHotwire])
    {
        ER_SendVehicleActionLine(playerid, vehicleid, "tries the ignition of");
        return ER_Send(playerid, COLOR_GREY, "You do not have the keys to this vehicle.");
    }
    if(GetPVarInt(playerid, "HotwireVehicle") != 0)
    {
        return ER_Send(playerid, COLOR_GREY, "You are already attempting to hotwire this vehicle.");
    }
    if(PlayerInfo[playerid][pHotwireKits] <= 0)
    {
        return ER_Send(playerid, COLOR_GREY, "You need a hotwire tool to attempt this.");
    }
    PlayerInfo[playerid][pHotwireKits]--;
    ER_SaveHotwireStats(playerid);
    SetPVarInt(playerid, "HotwireVehicle", vehicleid);
    SetPVarInt(playerid, "HotwireSeconds", ER_GetHotwireSeconds(playerid));
    SetTimerEx("ER_OnHotwireTick", 1000, false, "i", playerid);
    return 1;
}

forward ER_OnHotwireTick(playerid);
public ER_OnHotwireTick(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new vehicleid = GetPVarInt(playerid, "HotwireVehicle");
    new seconds = GetPVarInt(playerid, "HotwireSeconds");

    if(vehicleid == 0 || GetPlayerVehicleID(playerid) != vehicleid)
    {
        DeletePVar(playerid, "HotwireVehicle");
        DeletePVar(playerid, "HotwireSeconds");
        return 1;
    }

    if(seconds > 0)
    {
        ER_ShowHotwireText(playerid, seconds);

        SetPVarInt(playerid, "HotwireSeconds", seconds - 1);

        SetTimerEx("ER_OnHotwireTick", 1000, false, "i", playerid);
        return 1;
    }

    DeletePVar(playerid, "HotwireVehicle");
    DeletePVar(playerid, "HotwireSeconds");

    new bool:success = (random(100) < ER_GetHotwireChance(playerid, vehicleid));

    if(success)
    {
        GameTextForPlayer(playerid,
            "~g~Vehicle Engine:~n~~w~Starting",
            2500,
            3
        );

        ApplyAnimation(playerid,
            "PED",
            "CAR_tune_radio",
            4.1,
            0,
            0,
            0,
            0,
            0,
            1
        );

        SetTimerEx("ER_FinishVehicleStart", 2500, false, "ii", playerid, vehicleid);

        PlayerInfo[playerid][pHotwireSuccess]++;

        ER_UpdateHotwireLevel(playerid);
    }
    else
    {
        PlayerInfo[playerid][pHotwireFail]++;

        ER_UpdateHotwireLevel(playerid);

        GameTextForPlayer(playerid,
            "~w~Hotwiring Vehicle...~n~~r~Failed",
            2500,
            3
        );

        SetTimerEx("ER_ShowHotwireFailStats", 1200, false, "i", playerid);
    }

    ER_SaveHotwireStats(playerid);

    return 1;
}

forward ER_ShowHotwireFailStats(playerid);
public ER_ShowHotwireFailStats(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    ER_ShowHotwireResult(playerid, false);

    return 1;
}

forward ER_FinishVehicleStart(playerid, vehicleid);
public ER_FinishVehicleStart(playerid, vehicleid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    if(GetPlayerVehicleID(playerid) != vehicleid) return 1;

    new engine, lights, alarm, doors, bonnet, boot, objective;

    GetVehicleParamsEx(vehicleid,
        engine,
        lights,
        alarm,
        doors,
        bonnet,
        boot,
        objective
    );

    ER_NormalizeVehicleParams(
        engine,
        lights,
        alarm,
        doors,
        bonnet,
        boot,
        objective
    );

    engine = VEHICLE_PARAMS_ON;

    SetVehicleParamsEx(vehicleid,
        engine,
        lights,
        alarm,
        doors,
        bonnet,
        boot,
        objective
    );

    ER_SendVehicleActionLine(playerid, vehicleid, "successfully hotwires");

    GameTextForPlayer(playerid,
        "~g~Vehicle Started",
        3000,
        3
    );

    ER_ShowHotwireResult(playerid, true);

    return 1;
}

stock ER_ShowSkills(playerid)
{
    return ShowPlayerDialog(playerid, DIALOG_SKILLS_MAIN, DIALOG_STYLE_LIST, "Skills", "Hotwiring", "Select", "Close");
}

stock ER_ShowHotwireSkill(playerid)
{
    new level = ER_GetHotwireLevel(playerid), required = ER_GetHotwireProgressNeeded(level), body[384];
    if(level >= 5)
    {
        format(body, sizeof(body), "Hotwiring Skill\n\nLevel: 5 / 5\nSuccessful Attempts: %d\nFailed Attempts: %d\nProgress: Max Level\nHotwiring Kits: %d", PlayerInfo[playerid][pHotwireSuccess], PlayerInfo[playerid][pHotwireFail], PlayerInfo[playerid][pHotwireKits]);
    }
    else
    {
        new xp = PlayerInfo[playerid][pHotwireSuccess] * 3 + PlayerInfo[playerid][pHotwireFail];
        new remaining = required - xp;
        if(remaining < 0) remaining = 0;
        format(body, sizeof(body), "Hotwiring Skill\n\nLevel: %d / 5\nSuccessful Attempts: %d\nFailed Attempts: %d\nProgress to Next Level: %d / %d XP\nRemaining: %d XP\nHotwiring Tools: %d", level, PlayerInfo[playerid][pHotwireSuccess], PlayerInfo[playerid][pHotwireFail], xp, required, remaining, PlayerInfo[playerid][pHotwireKits]);
    }
    return ShowPlayerDialog(playerid, DIALOG_SKILLS_HOTWIRE, DIALOG_STYLE_MSGBOX, "Hotwiring", body, "Back", "Close");
}

stock ER_HandleVehicleCommand(playerid, params[])
{
    new option[24];
    if(sscanf(params, "s[24]", option)) return ER_Send(playerid, COLOR_GREY, "USAGE: /veh [engine/lights/hood/trunk/windows/lock]");

    new vehicleid = GetPlayerVehicleID(playerid);

    // /veh lock and /car lock must work both inside the vehicle and while standing near it.
    if(!strcmp(option, "lock", true))
    {
        if(vehicleid == 0) vehicleid = ER_GetNearestUsableVehicle(playerid, 6.0);
        if(vehicleid == 0) return ER_Send(playerid, COLOR_GREY, "You are not near any vehicle you have keys for.");
        if(!ER_PlayerCanUseVehicle(playerid, vehicleid)) return ER_Send(playerid, COLOR_GREY, "You do not have the keys to this vehicle.");

        new idx = ER_FindVehicleBySpawnID(vehicleid);
        if(idx == -1) return ER_Send(playerid, COLOR_GREY, "This vehicle is not saved.");
        if(VehicleInfo[idx][vLockType] <= 0) return ER_Send(playerid, COLOR_GREY, "This vehicle has no alarm or industrial lock installed.");

        new engine, lights, alarm, doors, bonnet, boot, objective;
        GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        ER_NormalizeVehicleParams(engine, lights, alarm, doors, bonnet, boot, objective);

        if(VehicleInfo[idx][vLockType] == 1)
        {
            alarm = (alarm == VEHICLE_PARAMS_ON) ? VEHICLE_PARAMS_OFF : VEHICLE_PARAMS_ON;
            SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
            ER_SendVehicleRemoteLine(playerid, vehicleid, true, alarm == VEHICLE_PARAMS_ON);
            return 1;
        }

        doors = (doors == VEHICLE_PARAMS_ON) ? VEHICLE_PARAMS_OFF : VEHICLE_PARAMS_ON;
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        ER_SendVehicleRemoteLine(playerid, vehicleid, false, doors == VEHICLE_PARAMS_ON);
        return 1;
    }

    if(vehicleid == 0) return ER_Send(playerid, COLOR_GREY, "You must be inside a vehicle.");

    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    ER_NormalizeVehicleParams(engine, lights, alarm, doors, bonnet, boot, objective);

    if(!strcmp(option, "engine", true))
    {
        new bool:hasKeys = ER_PlayerCanUseVehicle(playerid, vehicleid) ? true : false;
        if(engine == VEHICLE_PARAMS_ON)
        {
            engine = VEHICLE_PARAMS_OFF;
            SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
            ER_UpdateVehicleHUD(playerid);
            ER_SendVehicleActionLine(playerid, vehicleid, "turns off the engine of");
            return 1;
        }

        new idx = ER_FindVehicleBySpawnID(vehicleid);
        if(idx != -1 && !VehicleInfo[idx][vUnlimitedFuel] && VehicleInfo[idx][vFuel] <= 0.0)
        {
            return ER_Send(playerid, COLOR_GREY, "This vehicle is out of fuel. Refill it before starting the engine.");
        }

        if(!hasKeys && !ServerCore[scAllowVehicleEngineWithoutKeys])
        {
            return ER_StartHotwireAttempt(playerid, vehicleid);
        }

        SetPVarInt(playerid, "IgnitionVehicle", vehicleid);
        SetPVarInt(playerid, "IgnitionTarget", 1);
        if(hasKeys) ER_SendVehicleActionLine(playerid, vehicleid, "turns the key in the ignition of");
        else ER_SendVehicleActionLine(playerid, vehicleid, "tries the ignition of");
        ER_ShowEngineStartingText(playerid, 2);
        SetTimerEx("ER_OnIgnitionTimer", 1800, false, "i", playerid);
        return 1;
    }

    if(!strcmp(option, "lights", true))
    {
        lights = (lights == VEHICLE_PARAMS_ON) ? VEHICLE_PARAMS_OFF : VEHICLE_PARAMS_ON;
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        ER_UpdateVehicleHUD(playerid);
        ER_SendVehicleActionLine(playerid, vehicleid, lights == VEHICLE_PARAMS_ON ? "turns on the lights of" : "turns off the lights of");
        return 1;
    }
    if(!strcmp(option, "hood", true))
    {
        bonnet = (bonnet == VEHICLE_PARAMS_ON) ? VEHICLE_PARAMS_OFF : VEHICLE_PARAMS_ON;
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        ER_UpdateVehicleHUD(playerid);
        ER_SendVehicleActionLine(playerid, vehicleid, bonnet == VEHICLE_PARAMS_ON ? "opens the hood of" : "closes the hood of");
        return 1;
    }
    if(!strcmp(option, "trunk", true))
    {
        boot = (boot == VEHICLE_PARAMS_ON) ? VEHICLE_PARAMS_OFF : VEHICLE_PARAMS_ON;
        SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
        ER_SendVehicleActionLine(playerid, vehicleid, boot == VEHICLE_PARAMS_ON ? "opens the trunk of" : "closes the trunk of");
        return 1;
    }
    if(!strcmp(option, "windows", true))
    {
        new idx = ER_FindVehicleBySpawnID(vehicleid);
        if(idx == -1) return ER_Send(playerid, COLOR_GREY, "This vehicle is not saved.");

        VehicleInfo[idx][vWindows][0] = (VehicleInfo[idx][vWindows][0] == 0) ? 1 : 0;
        ER_UpdateVehicleHUD(playerid);
        ER_SendVehicleActionLine(playerid, vehicleid, VehicleInfo[idx][vWindows][0] ? "opens the windows of" : "closes the windows of");
        return 1;
    }
    return ER_Send(playerid, COLOR_GREY, "USAGE: /veh [engine/lights/hood/trunk/windows/lock]");
}

forward ER_OnIgnitionTimer(playerid);
public ER_OnIgnitionTimer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    new vehicleid = GetPVarInt(playerid, "IgnitionVehicle");
    new target = GetPVarInt(playerid, "IgnitionTarget");
    DeletePVar(playerid, "IgnitionVehicle");
    DeletePVar(playerid, "IgnitionTarget");
    if(vehicleid == 0 || GetPlayerVehicleID(playerid) != vehicleid) return 1;
    new engine, lights, alarm, doors, bonnet, boot, objective;
    GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    ER_NormalizeVehicleParams(engine, lights, alarm, doors, bonnet, boot, objective);
    if(target)
    {
        new idx = ER_FindVehicleBySpawnID(vehicleid);
        if(idx != -1 && !VehicleInfo[idx][vUnlimitedFuel] && VehicleInfo[idx][vFuel] <= 0.0) return ER_Send(playerid, COLOR_GREY, "This vehicle is out of fuel. Refill it before starting the engine.");
    }
    engine = target ? VEHICLE_PARAMS_ON : VEHICLE_PARAMS_OFF;
    SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
    ER_UpdateVehicleHUD(playerid);
    ER_SendVehicleActionLine(playerid, vehicleid, engine == VEHICLE_PARAMS_ON ? "starts the engine of" : "shuts off the engine of");
    return 1;
}

CMD:veh(playerid, params[])
{
    return ER_HandleVehicleCommand(playerid, params);
}
alias:veh("vehicle")

CMD:car(playerid, params[])
{
    return ER_HandleVehicleCommand(playerid, params);
}



CMD:seatbelt(playerid, params[])
{
    #pragma unused params
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ER_Send(playerid, COLOR_GREY, "You must be driving a vehicle to use a seatbelt.");
    ER_PlayerSeatbelt[playerid] = !ER_PlayerSeatbelt[playerid];
    ER_Send(playerid, COLOR_GREY, ER_PlayerSeatbelt[playerid] ? "Seatbelt fastened." : "Seatbelt unfastened.");
    ER_UpdateVehicleHUD(playerid);
    return 1;
}

CMD:sb(playerid, params[])
{
    return pc_cmd_seatbelt(playerid, params);
}
CMD:vehhud(playerid, params[])
{
    #pragma unused params
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return ER_Send(playerid, COLOR_GREY, "You must be driving a saved vehicle to show the vehicle HUD.");
    if(ER_FindVehicleBySpawnID(GetPlayerVehicleID(playerid)) == -1) return ER_Send(playerid, COLOR_GREY, "This is not a saved dynamic vehicle, so no vehicle HUD is available.");
    ER_ShowVehicleHUD(playerid);
    return ER_Send(playerid, COLOR_GREEN, "Vehicle HUD refreshed.");
}

CMD:park(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == 0) return ER_Send(playerid, COLOR_GREY, "You must be inside the vehicle you wish to park.");

    new idx = ER_FindVehicleBySpawnID(vehicleid);
    if(idx == -1) return ER_Send(playerid, COLOR_GREY, "This vehicle is not a saved dynamic vehicle.");

    if(!ER_PlayerOwnsVehicleDirectly(playerid, vehicleid) && !ER_PlayerCanUseGroupVehiclePerm(playerid, idx, 2))
    {
        return ER_Send(playerid, COLOR_GREY, "You cannot park this vehicle.");
    }

    new Float:vehhp;
    GetVehicleHealth(vehicleid, vehhp);
    if(vehhp < 800.0) return ER_Send(playerid, COLOR_GREY, "This vehicle is too damaged to park. Repair it first.");

    new Float:x, Float:y, Float:z, Float:a, q[256];
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);

    // Save current occupants and seats before vehicle recreation/respawn.
    new ParkPassengerIDs[8], ParkPassengerSeats[8], ParkPassengerCount;
    foreach(new i : Player)
    {
        if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == vehicleid && ParkPassengerCount < 8)
        {
            ParkPassengerIDs[ParkPassengerCount] = i;
            ParkPassengerSeats[ParkPassengerCount] = GetPlayerVehicleSeat(i);
            ParkPassengerCount++;
        }
    }

    VehicleInfo[idx][vX] = x;
    VehicleInfo[idx][vY] = y;
    VehicleInfo[idx][vZ] = z;
    VehicleInfo[idx][vA] = a;
    VehicleInfo[idx][vInt] = GetPlayerInterior(playerid);
    VehicleInfo[idx][vVW] = GetPlayerVirtualWorld(playerid);

    ER_SaveVehicleTuning(idx);

    // /park recreates/respawns the vehicle, so its temporary radio station is turned off.
    ER_ResetVehicleRadio(vehicleid);

    mysql_format(MainPipeline, q, sizeof(q), "UPDATE `vehicles` SET `x`=%f,`y`=%f,`z`=%f,`a`=%f,`interior`=%d,`vw`=%d WHERE `id`=%d",
        x, y, z, a, VehicleInfo[idx][vInt], VehicleInfo[idx][vVW], VehicleInfo[idx][vSQLID]);
    mysql_tquery(MainPipeline, q);

    ER_RespawnSavedVehicle(idx);

    new newveh = VehicleInfo[idx][vSpawnedID];

    for(new p; p < ParkPassengerCount; p++)
    {
        if(IsPlayerConnected(ParkPassengerIDs[p]) && newveh != INVALID_VEHICLE_ID)
        {
            PutPlayerInVehicle(ParkPassengerIDs[p], newveh, ParkPassengerSeats[p]);
        }
    }

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


stock ER_OnJobVehicleSeatEntered(playerid, vehicleid)
{
    new idx = ER_FindVehicleBySpawnID(vehicleid);
    if(idx != -1)
    {
        if(VehicleInfo[idx][vJobID] > 0 && !ER_PlayerHasJob(playerid, VehicleInfo[idx][vJobID]))
        {
            RemovePlayerFromVehicle(playerid);
            return ER_Send(playerid, COLOR_GREY, "This vehicle is restricted to that job type.");
        }
    }
    return 1;
}

stock ER_OnJobVehicleSeatExited(playerid, vehicleid)
{
    #pragma unused playerid
    #pragma unused vehicleid
    return 1;
}
