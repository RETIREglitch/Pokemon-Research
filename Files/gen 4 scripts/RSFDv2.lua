---------------------------------------------
---- RSFD - Routing Script For Dummies ------
---------------------------------------------

---------------------------------------------
--Original versions 'void.lua' and 'loadline.lua' created by MKdasher, 
--Game version and Basepointer setup by Ganix
--RETIRE scriptcalling by Martmists
--All other features + modifications for DPPTHGSS support by RETIRE

--NOTE: don't enable infinite repel until actually in game, will reset the game if you select savefile with it active.
---------------------------------------------

-- DATA TABLES

local tile_names = {
			"nothing","nothing","Grass","Grass","4","Cave","Cave/Tree","7","Cave","9","10", "HauntH","CaveW","13","14","15",
			"Pond","Water","Water","WaterF","Water","Water","Puddle","ShallW","24","Water","26","27","28","29","30","31",
			"Ice","Sand","Water","35","Cave","Cave","38","39","40","41","Water","43","44","45","46","47",
			"OnesideW","OnesideW","OnesideW","OnesideW","OnesideW","OnesideW","OnesideW","OnesideW","LedgeR","LedgeL","LedgeU","LedgeD","60","61","62","LedgeCor",
			"SpinR","SpinL","SpinU","SpinD","68","69","70","71","72","Stair","Stair","RockCVert","RockCHor","77","78","79",
			"Water","Water","Water","Water","84","85","HightM","HightM","HightM","HightM","90","91","92","93","Warp","Warp",
			"Warp","Warp","Doormat","Doormat","Doormat","Doormat","Warp","Warp","Warp","Warp","Warp","Warp","Warp","Warp","Warp","Warp",
			"StartBr","BridgeNul","BridgeCave","BridgeWat","Bridge?","BridgeSn","BikeBr","BikeBr?","BikeBr","BikeBr","BikeBr","BBridgeEnc","BikeBr?","BikeBr","126","127",
			"Counter","129","130","PC","132","Map","Television","135","Bookcases","137","138","139","140","141","Book","143",
			"144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159",
			"Soil","SnowSp2","SnowSp1","SnowSp0","Mud","MudBlock","MudGr","MudGrBlock","Snow","MeltSnow","170","171","172","173","174","175",
			"176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191",
			"192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207",
			"208","209","210","211","212","213","214","BikeLR","BikeLL","SlopeTop","SlopeBot","bikeStall","220","221","222","223",
			"Bookcases","Bookcases","Bookcases","227","ThrashBin","Obj","230","231","232","233","234","235","236","237","238","239",
			"240","241","242","243","244","245","246","247","248","249","250","251","252","253","254","Void"
}

local map_id_list = {
	Goal = {
		color = '#f7bbf3',
		ids = {32}
		},
	Chains= {
		color = '#DfA',
		ids = {}
	},
	MysteryZone = {
		color = '#88888866',
		ids = {0}
	},
	Blackout = {
		color = 'orange',
		ids = {332, 333}
	},
	Movement = {
		color = 'purple',
		ids = {117, 177, 179, 181, 183, 192, 393,
            474, 475, 476, 477, 478, 479, 480, 481, 482, 483,
            484, 485, 486, 487, 488, 489, 490, 496}
	},
	VoidExit = {
		color = 'yellow',
		ids = {105, 114, 337, 461, 516, 186, 187}
	},
	DANGER = {
		color = 'red',
		ids = {35, 88, 93, 95, 122,133, 150 ,154, 155, 156, 176, 178, 180, 182,
				184, 185, 188, 291, 293, 295, 504, 505, 506, 507, 508, 509}
	},
	Wrongwarp = {
		color = '#666fd',
		ids = {7,37,49,70,102,124,135,152,169,174,190,421,429,436,444,453,460,495}
	},
	Jubilife = {
		color = '#66ffbbff',
		ids = {3}
	},
	Normal = {
		color = '#00bb00ff',
		ids = {}
	}
}

map_ids = {}

for k,v in pairs(map_id_list) do
	for i=1,#map_id_list[k]['ids'] do
		map_ids[map_id_list[k]['ids'][i]] = map_id_list[k]['color']
	end
end

tile_id_list = {
	Grass = {
        color = '#40a',
        ids = {0x2}
    },
	Warps = {
        color = '#f03',
        ids ={0x5E,0x5f,0x62,0x63,0x69,0x65,0x6f,0x6D,0x6A,0x6C,0x6E}
	},
	Cave = {
        color = '#bb7410',
        ids = {0x8,0xC}
	},
	Water = {
        color = '#8888f',
        ids = {0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x19,0x22,0x2A}
    },
    Sand = {
        color = '#e3c',
        ids = {0x21,0x21}
	},
	SnowSlow = {
        color = '#8da9cb',
        ids = {0xA1}
    },
    Snow2xSlow = {
        color = '#6483a7',
        ids = {0xA2}
    },
    Snow3xslow = {
        color = '#52749d',
        ids = {0xA3}
	},
    Mud = {
        color = '#92897',
        ids = {0xA4}
    },
    StuckMud = {
        color = '#92704',
        ids = {0xA5}
    },
    GrassMud = {
        color = '#4090',
        ids = {0xA6}
    },
    GrassMudStuck = {
        color = '#55906',
        ids = {0xA7}
	},
    Snow = {
        color = '#b9d0eb',
        ids = {0xA8}
	},
	TallGrass = {
        color = '#2aa615',
        ids = {0x3}		
	},
	RandomObj = {
        color = 'white',
        ids = {0xE5,0X8E,0X8f}
    },
	Spinners = {
        color = '#ffd',
        ids = {0x40,0x41,0x42,0x43}
    },
	Ice = {
        color = '#56b3e0',
        ids = {0x20,0x20}
    },
	icestair = {
        color = '#ffd',
        ids = {0x49,0x4A}
    },
	CircleWarps = {
        color = '#a0a',
        ids = {0x67}
    },
	Modelfl = {
        color = '#afb',
       ids = {0x56,0x57,0x58,} 
    },
	ModelFloor = {
        color = '#a090f',
       ids = {0x59}
    },
	OnesidedWall = {
        color = '#a090f',
       ids = {0x30,0x31,0x32,0x33,0x34,0x35,0x36,0x37}
    },
	Bikestalls = {
        color = '#0690a',
       ids = {0xDB}
    },
	Counter = {
        color = '#f7a',
        ids = {0x80}
    },
	PC = {
       color = '#0690b',
       ids = {0x83}
    },
	Map = {
       color = '#00eee',
       ids = {0x85}
    },
	TV = {
       color = '#4290e',
       ids = {0x86}
    },
	Bookcases = {
        color = '#0ddd7',
        ids = {0x88,0xE1,0xE0,0xE2}
    },
	Bin = {
        color = '#06b04',
       ids = {0xE4}
	},
    HauntedHouse = {
        color = '#A292BC',
        ids = {0xB}
    },
    Ledge = {
        color = '#D3A',
        ids = {0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F}
    },
    RockClimb = {
        color = '#C76',
        ids = {0x4B,0x4C}
    },
    Bridge = {
        color = '#C79',
        ids = {0x70,0x71,0x72,0x73,0x74,0x75,}
	},
    BridgeBike = {
        color = '#C7A55',
        ids = {0x76,0x77,0x78,0x79,0x7A,0x7B,0x7C,0x7D}
	},
    Berrysoil = {
        color = '#b2703',
        ids = {0xA0}
    },
    BikeRamp = {
        color = '#B890',
        ids = {0xD7,0xD8}
	},
    Quicksand = {
        color = '#A880',
        ids = {0xD9,0xDA}
    },
	Normal = {
        color = '',
        ids = {0xff}
    },
	Trees = {
        color = '#CCCCC',
        ids = {0x6}
    },
}

tile_ids = {}

for k,v in pairs(tile_id_list) do
	for i=1,#tile_id_list[k]['ids'] do
		tile_ids[tile_id_list[k]['ids'][i]] = tile_id_list[k]['color']
	end
end


scripts = {[0] = 1, [1] = 1, [2] = 6, [3] = 27, [4] = 4, [5] = 1, [6] = 4, [7] = 1, [8] = 4, [9] = 4, [10] = 7, [11] = 17, [12] = 3, [13] = 4, [14] = 2, [15] = 14, [16] = 7, [17] = 6, [18] = 1, [19] = 2, [20] = 2, [21] = 1, [22] = 1, [23] = 1, [24] = 4, [25] = 2, [26] = 2, [27] = 1, [28] = 11, [29] = 12, [30] = 3, [31] = 2, [32] = 1, [33] = 24, [34] = 4, [35] = 4, [36] = 4, [37] = 1, [38] = 4, [39] = 4, [40] = 12, [41] = 2, [42] = 1, [43] = 3, [44] = 3, [45] = 19, [46] = 4, [47] = 3, [48] = 4, [49] = 1, [50] = 3, [51] = 4, [52] = 2, [53] = 3, [54] = 2, [55] = 3, [56] = 3, [57] = 1, [58] = 2, [59] = 13, [60] = 3, [61] = 3, [62] = 4, [63] = 2, [64] = 1, [65] = 23, [66] = 4, [67] = 3, [68] = 7, [69] = 6, [70] = 1, [71] = 5, [72] = 2, [73] = 2, [74] = 1, [75] = 4, [76] = 3, [77] = 2, [78] = 4, [79] = 1, [80] = 4, [81] = 3, [82] = 1, [83] = 2, [84] = 5, [85] = 1, [86] = 33, [87] = 4, [88] = 6, [89] = 1, [90] = 1, [91] = 4, [92] = 1, [93] = 4, [94] = 1, [95] = 4, [96] = 1, [97] = 1, [98] = 1, [99] = 1, [100] = 120, [101] = 4, [102] = 1, [103] = 2, [104] = 2, [105] = 1, [106] = 6, [107] = 4, [108] = 3, [109] = 3, [110] = 1, [111] = 4, [112] = 9, [113] = 4, [114] = 1, [115] = 1, [116] = 5, [117] = 14, [118] = 1, [119] = 6, [120] = 16, [121] = 5, [122] = 7, [123] = 3, [124] = 1, [125] = 5, [126] = 5, [127] = 2, [128] = 2, [129] = 1, [130] = 2, [131] = 3, [132] = 30, [133] = 4, [134] = 3, [135] = 1, [136] = 21, [137] = 8, [138] = 7, [139] = 6, [140] = 6, [141] = 6, [142] = 1, [143] = 2, [144] = 3, [145] = 2, [146] = 3, [147] = 2, [148] = 3, [149] = 2, [150] = 19, [151] = 4, [152] = 1, [153] = 4, [154] = 4, [155] = 4, [156] = 4, [157] = 116, [158] = 1, [159] = 7, [160] = 2, [161] = 1, [162] = 1, [163] = 1, [164] = 4, [165] = 12, [166] = 4, [167] = 4, [168] = 4, [169] = 1, [170] = 2, [171] = 1, [172] = 3, [173] = 6, [174] = 1, [175] = 7, [176] = 3, [177] = 2, [178] = 3, [179] = 2, [180] = 3, [181] = 2, [182] = 3, [183] = 2, [184] = 3, [185] = 2, [186] = 2, [187] = 1, [188] = 17, [189] = 4, [190] = 1, [191] = 4, [192] = 7, [193] = 2, [194] = 2, [195] = 3, [196] = 1, [197] = 1, [198] = 3, [199] = 5, [200] = 7, [201] = 6, [202] = 4, [203] = 12, [204] = 1, [205] = 2, [206] = 1, [207] = 2, [208] = 1, [209] = 1, [210] = 1, [211] = 1, [212] = 1, [213] = 1, [214] = 1, [215] = 1, [216] = 1, [217] = 1, [218] = 1, [219] = 1, [220] = 14, [221] = 1, [222] = 1, [223] = 1, [224] = 1, [225] = 1, [226] = 2, [227] = 1, [228] = 1, [229] = 1, [230] = 1, [231] = 1, [232] = 1, [233] = 1, [234] = 1, [235] = 1, [236] = 1, [237] = 1, [238] = 1, [239] = 1, [240] = 1, [241] = 1, [242] = 1, [243] = 1, [244] = 9, [245] = 1, [246] = 1, [247] = 4, [248] = 1, [249] = 1, [250] = 1, [251] = 6, [252] = 1, [253] = 26, [254] = 1, [255] = 1, [256] = 7, [257] = 2, [258] = 3, [259] = 1, [260] = 2, [261] = 2, [262] = 2, [263] = 4, [264] = 6, [265] = 5, [266] = 1, [267] = 1, [268] = 2, [269] = 2, [270] = 5, [271] = 1, [272] = 1, [273] = 1, [274] = 3, [275] = 1, [276] = 1, [277] = 1, [278] = 1, [279] = 1, [280] = 1, [281] = 1, [282] = 1, [283] = 2, [284] = 6, [285] = 1, [286] = 2, [287] = 1, [288] = 2, [289] = 1, [290] = 1, [291] = 2, [292] = 1, [293] = 9, [294] = 3, [295] = 2, [296] = 2, [297] = 1, [298] = 1, [299] = 1, [300] = 1, [301] = 1, [302] = 2, [303] = 1, [304] = 1, [305] = 8, [306] = 6, [307] = 3, [308] = 4, [309] = 1, [310] = 3, [311] = 7, [312] = 7, [313] = 2, [314] = 4, [315] = 1, [316] = 4, [317] = 1, [318] = 1, [319] = 3, [320] = 2, [321] = 3, [322] = 12, [323] = 126, [324] = 1, [325] = 1, [326] = 23, [327] = 4, [328] = 3, [329] = 3, [330] = 5, [331] = 4, [332] = 1, [333] = 1, [334] = 6, [335] = 1, [336] = 10, [337] = 21, [338] = 1, [339] = 1, [340] = 5, [341] = 1, [342] = 12, [343] = 6, [344] = 6, [345] = 3, [346] = 3, [347] = 10, [348] = 2, [349] = 3, [350] = 8, [351] = 4, [352] = 1, [353] = 7, [354] = 5, [355] = 4, [356] = 9, [357] = 1, [358] = 1, [359] = 1, [360] = 1, [361] = 2, [362] = 7, [363] = 3, [364] = 2, [365] = 3, [366] = 4, [367] = 10, [368] = 7, [369] = 2, [370] = 7, [371] = 8, [372] = 4, [373] = 8, [374] = 2, [375] = 2, [376] = 3, [377] = 1, [378] = 3, [379] = 2, [380] = 4, [381] = 1, [382] = 8, [383] = 3, [384] = 3, [385] = 3, [386] = 1, [387] = 1, [388] = 2, [389] = 2, [390] = 2, [391] = 1, [392] = 4, [393] = 13, [394] = 2, [395] = 8, [396] = 7, [397] = 2, [398] = 2, [399] = 4, [400] = 2, [401] = 1, [402] = 1, [403] = 3, [404] = 1, [405] = 1, [406] = 2, [407] = 2, [408] = 1, [409] = 1, [410] = 1, [411] = 9, [412] = 1, [413] = 3, [414] = 11, [415] = 6, [416] = 1, [417] = 2, [418] = 12, [419] = 4, [420] = 4, [421] = 1, [422] = 14, [423] = 2, [424] = 2, [425] = 2, [426] = 11, [427] = 4, [428] = 4, [429] = 1, [430] = 3, [431] = 2, [432] = 3, [433] = 11, [434] = 4, [435] = 3, [436] = 1, [437] = 3, [438] = 2, [439] = 3, [440] = 2, [441] = 2, [442] = 11, [443] = 4, [444] = 1, [445] = 6, [446] = 4, [447] = 2, [448] = 2, [449] = 1, [450] = 5, [451] = 4, [452] = 4, [453] = 1, [454] = 2, [455] = 1, [456] = 1, [457] = 7, [458] = 2, [459] = 3, [460] = 1, [461] = 8, [462] = 4, [463] = 1, [464] = 3, [465] = 1, [466] = 8, [467] = 1, [468] = 1, [469] = 2, [470] = 1, [471] = 3, [472] = 1, [473] = 1, [474] = 1, [475] = 1, [476] = 1, [477] = 1, [478] = 1, [479] = 1, [480] = 1, [481] = 1, [482] = 1, [483] = 1, [484] = 1, [485] = 1, [486] = 1, [487] = 1, [488] = 1, [489] = 1, [490] = 1, [491] = 2, [492] = 4, [493] = 10, [494] = 14, [495] = 1, [496] = 1, [497] = 3, [498] = 1, [499] = 3, [500] = 1, [501] = 2, [502] = 2, [503] = 3, [504] = 2, [505] = 2, [506] = 2, [507] = 2, [508] = 2, [509] = 2, [510] = 4, [511] = 1, [512] = 1, [513] = 1, [514] = 2, [515] = 1, [516] = 1, [517] = 4, [518] = 1, [519] = 1, [520] = 1, [521] = 1, [522] = 1, [523] = 1, [524] = 1, [525] = 1, [526] = 1, [527] = 1, [528] = 1, [529] = 1, [530] = 1, [531] = 1, [532] = 1, [533] = 1, [534] = 1, [535] = 1, [536] = 1, [537] = 1, [538] = 1, [539] = 1, [540] = 1, [541] = 1, [542] = 1, [543] = 1, [544] = 1, [545] = 1, [546] = 1, [547] = 1, [548] = 1, [549] = 1, [550] = 1, [551] = 1, [552] = 1, [553] = 1, [554] = 1, [555] = 1, [556] = 1, [557] = 1, [558] = 4}
opcodes = {[0xea] = 'ActLeagueBattlers', [0x2ac] = 'ActivateMysteryGift', [0x158] = 'ActivatePokedex', [0x133] = 'ActivatePoketchApp', [0x64] = 'AddPeople', [0x5e] = 'ApplyMovement', [0x2a1] = 'ApplyMovement2', [0x1d9] = 'BattleRoomResult', [0xcb] = 'BerryHiroAnimation', [0x1d7] = 'BerryPoffin', [0x2bf] = 'BikeRide', [0xab] = 'BoxPokemon', [0x1a] = 'Call', [0xa1] = 'CallEnd', [0x36] = 'CallMessageBox', [0x3a] = 'CallMessageBoxText', [0x14] = 'CallStandard', [0x29f] = 'CameraBumpEffect', [0xa9] = 'CapsuleEditor', [0x261] = 'CheckAccessories', [0x15b] = 'CheckBadge', [0xc7] = 'CheckBike', [0x252] = 'CheckBoxesNumber', [0x78] = 'CheckCoins', [0x12e] = 'CheckDress', [0x28f] = 'CheckFirstTimeChampion', [0x20] = 'CheckFlag', [0x11c] = 'CheckFloor', [0x1f1] = 'CheckFossil', [0x14d] = 'CheckGender', [0x1b9] = 'CheckHappiness', [0x7d] = 'CheckItem', [0xec] = 'CheckLost', [0x24e] = 'CheckLottoNumber', [0x71] = 'CheckMoney', [0x99] = 'CheckMove', [0x1e9] = 'CheckNationalPokedex', [0x177] = 'CheckPartyNumber', [0x19a] = 'CheckPartyNumber2', [0x6b] = 'CheckPersonPosition', [0x249] = 'CheckPhraseBoxInput', [0x9a] = 'CheckPlaceStored', [0x1c4] = 'CheckPokemonHeight', [0x1f6] = 'CheckPokemonLevel', [0x93] = 'CheckPokemonParty', [0x1c0] = 'CheckPokemonParty2', [0x228] = 'CheckPokemonTrade', [0x1bd] = 'CheckPosition', [0x1e8] = 'CheckSinnohPokedex', [0x69] = 'CheckSpritePosition', [0x7c] = 'CheckStoreItem', [0x225] = 'CheckTeachMove', [0x85] = 'CheckUndergroundPcStatus', [0x2c7] = 'CheckVersionGame', [0x2bc] = 'CheckWildBattle2', [0x29d] = 'ChoiceMulti', [0xf2] = 'ChooseFriend', [0xba] = 'ChoosePlayerName', [0x191] = 'ChoosePokemonMenu', [0x192] = 'ChoosePokemonMenu2', [0xbb] = 'ChoosePokemonName', [0xb4] = 'ChooseStarter', [0x2a5] = 'ChooseTradePokemon', [0x1e] = 'ClearFlag', [0x16c] = 'CloseDoor', [0x34] = 'CloseMessageOnKeyPress', [0x43] = 'CloseMulti', [0x24d] = 'ClosePcAnimation', [0x37] = 'ColorMessageBox', [0x1d] = 'CompareLastResultCall', [0x1c] = 'CompareLastResultJump', [0x24f] = 'CompareLottoNumber', [0x2aa] = 'ComparePhraseBoxInput', [0x1c3] = 'ComparePokemonHeight', [0x26] = 'CompareVarsToByte', [0x6c] = 'ContinueFollow', [0x1c1] = 'CopyPokemonHeight', [0x29] = 'CopyVar', [0x239] = 'DecideRules', [0x14b] = 'DefeatGoPokecenter', [0x1c9] = 'DeleteMove', [0x15d] = 'DisableBadge', [0xa8] = 'DisplayContestPokemon', [0xa7] = 'DisplayDressedPokemon', [0x347] = 'DisplayFloor', [0x2a0] = 'DoubleBattle', [0xac] = 'DrawUnion', [0xa6] = 'DressPokemon', [0x1ac] = 'EggAnimation', [0x259] = 'ElevLgAnimation', [0x15c] = 'EnableBadge', [0x2] = 'End', [0x112] = 'EndFlash', [0xb0] = 'EndGame', [0xe6] = 'EndTrainerBattle', [0x143] = 'ExpectDecisionOther', [0x126] = 'ExplanationBattle', [0x68] = 'FacePlayer', [0x4f] = 'FadeDefaultMusic', [0xbc] = 'FadeScreen', [0x111] = 'FlashContest', [0x2ca] = 'FloralClockAnimation', [0xc2] = 'FlyAnimation', [0x6d] = 'FollowHero', [0x35] = 'FreezeMessageBox', [0x205] = 'Geonet', [0x79] = 'GiveCoins', [0x97] = 'GiveEgg', [0x6f] = 'GiveMoney', [0x96] = 'GivePokemon', [0x131] = 'GivePoketch', [0x15a] = 'GiveRunningShoes', [0x206] = 'GreatMarshBynocule', [0xb1] = 'HallFameData', [0x14e] = 'HealPokemon', [0x23b] = 'HealPokemonAnimation', [0x29e] = 'HiddenMachineEffect', [0x295] = 'HideBattlePointsBox', [0x76] = 'HideCoins', [0x73] = 'HideMoney', [0x209] = 'HidePicture', [0x2c2] = 'HideSaveBox', [0x18e] = 'HideSavingClock', [0x127] = 'HoneyTreeBattle', [0x11] = 'If', [0x12] = 'If2', [0xa5] = 'Interview', [0x16] = 'Jump', [0x27a] = 'LeagueCastleView', [0x62] = 'Lock', [0x60] = 'LockAll', [0x66] = 'LockCam', [0xeb] = 'LostGoPokecenter', [0x1b3] = 'Mailbox', [0x3c] = 'Menu', [0x2c] = 'Message', [0x2d] = 'Message2', [0x2f] = 'Message3', [0x1c6] = 'MoveInfo', [0x40] = 'Multi', [0x41] = 'Multi2', [0x44] = 'Multi3', [0x48] = 'MultiRow', [0x39] = 'NoMapMessageBox', [0x0] = 'Nop', [0x1] = 'Nop1', [0xffff] = 'OpCode', [0x178] = 'OpenBerryPouch', [0x16b] = 'OpenDoor', [0x24c] = 'OpenPcAnimation', [0x243] = 'PhraseBox1W', [0x244] = 'PhraseBox2W', [0x4c] = 'PlayCry', [0x49] = 'PlayFanfare', [0x4a] = 'PlayFanfare2', [0x50] = 'PlayMusic', [0x4e] = 'PlaySound', [0x267] = 'Pokecasino', [0x147] = 'Pokemart', [0x148] = 'Pokemart1', [0x149] = 'Pokemart2', [0x14a] = 'Pokemart3', [0xf7] = 'PokemonContest', [0x195] = 'PokemonInfo', [0x28c] = 'PokemonPartyPicture', [0x208] = 'PokemonPicture', [0x328] = 'PortalEffect', [0x168] = 'PrepareDoorAnimation', [0x24b] = 'PreparePcAnimation', [0x129] = 'RandomBattle', [0x1b5] = 'RecordList', [0xaf] = 'RecordMixingUnion', [0x63] = 'Release', [0x61] = 'ReleaseAll', [0x189] = 'ReleaseOverworld', [0x221] = 'RememberMove', [0x65] = 'RemovePeople', [0xbd] = 'ResetScreen', [0x52] = 'RestartMusic', [0x258] = 'RetSprtSave', [0x1b] = 'Return', [0x3] = 'Return2', [0xc8] = 'RideBike', [0xbf] = 'RockClimbAnimation', [0x18b] = 'SetDoorLocked', [0x18a] = 'SetDoorPassable', [0x1f] = 'SetFlag', [0x188] = 'SetOverworldMovement', [0x186] = 'SetOverworldPosition', [0x95] = 'SetPokemonPartyStored', [0x120] = 'SetPositionAfterShip', [0x23] = 'SetValue', [0x28] = 'SetVar', [0xdd] = 'SetVarAlterStored', [0xdb] = 'SetVarHeroStored', [0xda] = 'SetVarPokemonStored', [0xdc] = 'SetVarRivalStored', [0xcf] = 'SetVariableAlter', [0xd4] = 'SetVariableAttack', [0xd3] = 'SetVariableAttackItem', [0xcd] = 'SetVariableHero', [0xd1] = 'SetVariableItem', [0xd6] = 'SetVariableNickname', [0xd5] = 'SetVariableNumber', [0xd7] = 'SetVariableObject', [0xd0] = 'SetVariablePokemon', [0x1c2] = 'SetVariablePokemonHeight', [0xce] = 'SetVariableRival', [0xd8] = 'SetVariableTrainer', [0x23d] = 'ShipAnimation', [0x294] = 'ShowBattlePointsBox', [0x75] = 'ShowCoins', [0x116] = 'ShowLinkCountRecord', [0x72] = 'ShowMoney', [0x1eb] = 'ShowNationalSheet', [0x2c1] = 'ShowSaveBox', [0x18d] = 'ShowSavingClock', [0x1ea] = 'ShowSinnohSheet', [0xaa] = 'SinnohMaps', [0x2c6] = 'SpinTradeUnion', [0x257] = 'SprtSave', [0x125] = 'StarterBattle', [0xcc] = 'StopBerryHiroAnimation', [0x6e] = 'StopFollowHero', [0x51] = 'StopMusic', [0x22a] = 'StopTrade', [0x1c7] = 'StoreMove', [0x193] = 'StorePokemonMenu2', [0x198] = 'StorePokemonNumber', [0x94] = 'StorePokemonParty', [0x134] = 'StorePoketchApp', [0xde] = 'StoreStarter', [0xc0] = 'SurfAnimation', [0x54] = 'SwitchMusic', [0x5a] = 'SwitchMusic2', [0x7a] = 'TakeCoins', [0x7b] = 'TakeItem', [0x70] = 'TakeMoney', [0x224] = 'TeachMove', [0x46] = 'TextMessageScriptMulti', [0x42] = 'TextScriptMulti', [0x271] = 'ThankNameInsert', [0x229] = 'TradeChosenPokemon', [0xae] = 'TradeUnion', [0xe5] = 'TrainerBattle', [0xad] = 'TrainerCaseUnion', [0xc6] = 'Tuxedo', [0x38] = 'TypeMessageBox', [0x153] = 'UnionRoom', [0x26d] = 'UnownMessageBox', [0x77] = 'UpdateCoins', [0x74] = 'UpdateMoney', [0xa3] = 'WFC', [0xb3] = 'WFC1', [0x169] = 'WaitAction', [0x31] = 'WaitButton', [0x16a] = 'WaitClose', [0x4d] = 'WaitCry', [0x4b] = 'WaitFanfare', [0x3f] = 'WaitFor', [0x5f] = 'WaitMovement', [0xbe] = 'Warp', [0x204] = 'WarpLastElevator', [0x11b] = 'WarpMapElevator', [0xc1] = 'WaterfallAnimation', [0x124] = 'WildBattle', [0x2bd] = 'WildBattle2', [0xf3] = 'WirelessBattleWait', [0x12b] = 'WriteAutograph', [0x3e] = 'YesNoBox'}
img = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x3c, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xf8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x0, 0x11, 0x7f, 0xff, 0xff, 0xe7, 0x0, 0x0, 0x0, 0x0, 0xc3, 0xc7, 0xcf, 0xcf, 0x0, 0x0, 0x0, 0xe0, 0xf8, 0xfc, 0xf9, 0x11, 0x0, 0x0, 0x0, 0x1e, 0x7f, 0xff, 0xff, 0xe3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x80, 0xc0, 0xc0, 0x0, 0x0, 0x0, 0x30, 0x71, 0x7b, 0x7f, 0x7f, 0x0, 0x0, 0x0, 0x86, 0xcf, 0xef, 0xff, 0xfe, 0x3c, 0x3c, 0x3c, 0x3d, 0x3f, 0x3f, 0x3f, 0x3e, 0x0, 0x0, 0x0, 0x80, 0xe0, 0xf0, 0xf9, 0x79, 0x0, 0x0, 0x0, 0x1e, 0x7f, 0xff, 0xff, 0xe3, 0x0, 0x0, 0x0, 0xc, 0x1f, 0x9f, 0xdf, 0xde, 0x0, 0x0, 0x0, 0xc0, 0xf0, 0xf8, 0xfc, 0x3c, 0x1, 0x3, 0x3, 0x3, 0x0, 0x0, 0x0, 0x0, 0xfc, 0xfe, 0xde, 0x8f, 0x1e, 0x3e, 0x7c, 0x78, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0xe3, 0xe7, 0xff, 0xff, 0xff, 0x3f, 0x0, 0x0, 0xcf, 0xdf, 0xcf, 0xc7, 0xc7, 0x81, 0x0, 0x0, 0x1, 0x3, 0xf9, 0xf9, 0xf8, 0xf0, 0x0, 0x0, 0xff, 0xff, 0xe0, 0xff, 0xff, 0x7f, 0x0, 0x0, 0x80, 0x80, 0x0, 0x80, 0x80, 0x80, 0x0, 0x0, 0x3f, 0x3f, 0x1f, 0x1f, 0xf, 0xe, 0x0, 0x0, 0xfe, 0xfc, 0xfc, 0x7c, 0x78, 0x38, 0x0, 0x0, 0x3c, 0x3c, 0x3c, 0x3c, 0x3c, 0x3c, 0x0, 0x0, 0x79, 0x79, 0x79, 0x79, 0x78, 0x78, 0x0, 0x0, 0xff, 0xff, 0xe0, 0xff, 0xff, 0x7f, 0x0, 0x0, 0x9e, 0x9e, 0x1e, 0x9e, 0x9e, 0x9e, 0x0, 0x0, 0x3c, 0x3c, 0x3c, 0x3c, 0x3c, 0x3c, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x70, 0x0, 0x70, 0xf8, 0x78, 0x70, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}
steps_data = {
    [1] = 11,
    [2] = 7,
    [3] = 3
}

data_tables = {
	--1 DP and PD demo
	{	
		item_struct_offs = 0x838,
		step_counter_offs = 0x1384,

		-- start of structure offsets/structure data
		player_live_struct_offs = 0x1440,

		mapdata_and_menu_struct_offs = 0x22964,
		chunk_calculation_ptr = 0x229F0,
		matrix_struct_offs = 0x22A84,
		matrix_size = 30,

		general_npc_struct_offs = 0x248C8,
		player_npc_struct_offs = 0x24A14,

		object_struct_offs = 0x23C80,
		object_struct_size = 0x14,
		warp_struct_size = 0xC,
		trigger_struct_size = 0x10,

		npc_struct_offs =  0x24B5C,
		npc_struct_size = 0x128,

		memory_shift = {
			UG=0x8104,
			BT=0x8104,
			OW=0x0
		},
		
		memory_state_check_offs = 0x22A00, -- 0x22A00,0x22A04,0x22A20
		memory_state_check_val = 0x2C9EC,

		menu_data = 0x29434,
		current_pocket_index_offs = 0x2977C,

		ug_revealing_circle_struct_offs = 0x115150,
		ug_trap_struct_offs =0x12B5B0,
		ug_trap_struct_size = 0x6,
		

		ug_cur_gem_ptr = 0x12DBC0,
		ug_gem_struct_offs = 0x12D5E0,
		ug_gem_struct_size = 0x6,
		ug_gem_count = 0xFA,

		ug_excavation_minigame_offs = 0x12DD36,
		ug_excavation_minigame_tile_count = 0x81, -- 13 col * 9 row of 1 byte each
		ug_excavation_minigame_visual_offs = 0x534C4,

		

		-- static addresses
		bag_hovering_data_ptr = 0x2106FAC,
		menu_addr = 0x21C45BC, -- also check for underground minigame

		ug_trap_count_addr= 0x222CAD7,

		ug_init_addr = 0x2250E86,
		ug_init_val = 0x1F,

		game_state = 0x21C45B8, -- 4 = wifiroom, 5 = underground, 6 = overworld, 0x10 = battle
		battle_check = 0x221885E
	},

	--2 DP KOREAN version
	{

	},
	--3 Pl
	{

	},
	--4 HGSS
	{

	},
}

demo = false
hgss = false

game_specific_data = {
	Y = {
		game_name = "DP Demo",
		demo = true,
		language_specific_data = {
			E = {base_addr=0x02106BAC,data_table_index=1,collision_check_addr=0x2056C06,catch_chance_addr=0x223C1F4} -- US/EU ENGLISH
		}
	},
	A = {
		game_name  = "DP",
		language_specific_data = {
			D = {base_addr=0x02107100,data_table_index=1,collision_check_addr=0x2056C76,catch_chance_addr=nil}, -- GERMAN
			E = {base_addr=0x02106FC0,data_table_index=1,collision_check_addr=0x2056C06,catch_chance_addr=0x223C1F4}, -- US/EU ENGLISH
			F = {base_addr=0x02107140,data_table_index=1,collision_check_addr=0x2056C76,catch_chance_addr=nil}, -- FRENCH
			I = {base_addr=0x021070A0,data_table_index=1,collision_check_addr=0x2056C76,catch_chance_addr=nil}, -- ITALIAN
			J = {base_addr=0x02108818,data_table_index=1,collision_check_addr=0x20593E0,catch_chance_addr=nil}, -- JAPANESE
			K = {base_addr=0x021045C0,data_table_index=2,collision_check_addr=0x20570DE,catch_chance_addr=nil}, -- KOREAN
			S = {base_addr=0x02107160,data_table_index=1,collision_check_addr=0x2056C76,catch_chance_addr=nil} -- SPANISH
		}
	},
	C = {
		game_name = "Pl",
		language_specific_data = {
			D = {base_addr=0x02101EE0,data_table_index=3,collision_check_addr=0x2060CC4,catch_chance_addr=nil}, -- GERMAN
			E = {base_addr=0x02101D40,data_table_index=3,collision_check_addr=0x2060C20,catch_chance_addr=0x224A75C}, -- US/EU ENGLISH
			F = {base_addr=0x02101F20,data_table_index=3,collision_check_addr=0x2060CC4,catch_chance_addr=nil}, -- FRENCH
			I = {base_addr=0x02101EA0,data_table_index=3,collision_check_addr=0x2060CC4,catch_chance_addr=nil}, -- ITALIAN
			J = {base_addr=0x02101140,data_table_index=3,collision_check_addr=0x20604E8,catch_chance_addr=nil}, -- JAPANESE
			K = {base_addr=0x02102C40,data_table_index=3,collision_check_addr=nil,catch_chance_addr=nil}, -- KOREAN
			S = {base_addr=0x02101F40,data_table_index=3,collision_check_addr=0x2060CC4,catch_chance_addr=nil} -- SPANISH
		}
	},
	I = {
		game_name = "HGSS",
		hgss = true,
		language_specific_data = {
			D = {base_addr = 0x02111860,data_table_index=4,collision_check_addr=0x205DB46,catch_chance_addr=nil}, -- GERMAN
			E = {base_addr = 0x02111880,data_table_index=4,collision_check_addr=0x205DAA2,catch_chance_addr=nil}, -- US/EU ENGLISH
			F = {base_addr = 0x021118A0,data_table_index=4,collision_check_addr=0x205DB46,catch_chance_addr=nil}, -- FRENCH
			I = {base_addr = 0x02111820,data_table_index=4,collision_check_addr=0x205DB46,catch_chance_addr=nil}, -- ITALIAN
			J = {base_addr = 0x02110DC0,data_table_index=4,collision_check_addr=0x205D36A,catch_chance_addr=nil}, -- JAPANESE
			K = {base_addr = 0x02112280,data_table_index=4,collision_check_addr=nil,catch_chance_addr=nil}, -- KOREAN
			S = {base_addr = 0x021118C0,data_table_index=4,collision_check_addr=0x205DB46,catch_chance_addr=nil} -- SPANISH
		}
	}

}

ver = memory.readdword(0x023FFE0C)
if ver == 0 then
	ver = memory.readdword(0x027FFE0C)
end

id = bit.band(ver, 0xFF)
game_id = string.char(id)

lang_ascii = bit.band(bit.rshift(ver, 24), 0xFF)
lang = string.char(lang_ascii)

game_data = game_specific_data[game_id]
lang_data = game_data["language_specific_data"][lang]

data_table = data_tables[lang_data["data_table_index"]]


-- base struct
base_struct = {
	player_name=0x278,
	money = 0x28C,
}

-- live player struct
start_live_struct = data_table["player_live_struct_offs"]

live_struct = {
	step_counter = data_table["step_counter_offs"],
	
	map_id_32 = start_live_struct + 0xC,
	unknown_32 = start_live_struct + 0x10,
	x_pos_32_r = start_live_struct + 0x14,
	z_pos_32_r = start_live_struct + 0x18,
	y_pos_32_r = start_live_struct + 0x1C,

	map_id_last_warp_32 = start_live_struct + 0x20,
	unknown_last_warp_32 = start_live_struct + 0x24,
	x_pos_last_warp_32 = start_live_struct + 0x28,
	z_pos_last_warp_32  = start_live_struct + 0x2C,
	y_pos_last_warp_32  = start_live_struct + 0x30,

	map_id_last_warp_32 = start_live_struct + 0x34,
	unknown_last_warp_32_2 = start_live_struct + 0x24,
	x_pos_last_warp_32_2 = start_live_struct + 0x3C,
	z_pos_last_warp_32_2  = start_live_struct + 0x40,
	y_pos_last_warp_32_2  = start_live_struct + 0x44,

	map_id_stored_warp_16 = start_live_struct + 0x4C,
	x_stored_warp_16 = start_live_struct + 0x50,
	z_stored_warp_16 = start_live_struct + 0x54,
	y_stored_warp_16 = start_live_struct + 0x58,

	map_id_last_warp_from_overworld_32 = start_live_struct + 0x5C,
	unknown_last_warp_from_overworld_32 = start_live_struct + 0x60,
	x_pos_last_warp_from_overworld_32 = start_live_struct + 0x64,
	z_pos_last_warp_from_overworld_32  = start_live_struct + 0x68,
	y_pos_last_warp_from_overworld_32  = start_live_struct + 0x6C,

	maps_entered_8 = start_live_struct + 0x78, -- counts every time player changes map position in ram (in overworld, even when id remains unchanged)

	x_map_overworld_live_8 = start_live_struct + 0x7C,
	z_map_overworld_live_8 = start_live_struct + 0x7D,

	x_map_overworld_entered_1_8 = start_live_struct + 0x7E, -- updates when maps_entered_8 is set to 1
	z_map_overworld_entered_1_8 = start_live_struct + 0x7F, -- updates when maps_entered_8 is set to 1
	direction_map_entered_1_8 = start_live_struct + 0x80, -- updates when maps_entered_8 is set to 1
	unknown_entered_1_8 = start_live_struct + 0x81, -- updates when maps_entered_8 is set to 1

	x_map_overworld_entered_2_8 = start_live_struct + 0x82, -- updates when maps_entered_8 is set to 2
	z_map_overworld_entered_2_8 = start_live_struct + 0x83, -- updates when maps_entered_8 is set to 2
	direction_map_entered_2_8 = start_live_struct + 0x84, -- updates when maps_entered_8 is set to 2
	unknown_entered_2_8 = start_live_struct + 0x85, -- updates when maps_entered_8 is set to 2

	x_map_overworld_entered_3_8 = start_live_struct + 0x86, -- updates when maps_entered_8 is set to 3
	z_map_overworld_entered_3_8 = start_live_struct + 0x87, -- updates when maps_entered_8 is set to 3
	direction_map_entered_3_8 = start_live_struct + 0x88, -- updates when maps_entered_8 is set to 3
	unknown_entered_3_8 = start_live_struct + 0x89, -- updates when maps_entered_8 is set to 3

	x_map_overworld_entered_4_8 = start_live_struct + 0x8A, -- updates when maps_entered_8 is set to 4
	z_map_overworld_entered_4_8 = start_live_struct + 0x8B, -- updates when maps_entered_8 is set to 4
	direction_map_entered_4_8 = start_live_struct + 0x8C, -- updates when maps_entered_8 is set to 4
	unknown_entered_4_8 = start_live_struct + 0x8D, -- updates when maps_entered_8 is set to 4

	x_map_overworld_entered_5_8 = start_live_struct + 0x8E, -- updates when maps_entered_8 is set to 5
	z_map_overworld_entered_5_8 = start_live_struct + 0x8F, -- updates when maps_entered_8 is set to 5
	direction_map_entered_5_8 = start_live_struct + 0x90, -- updates when maps_entered_8 is set to 5
	unknown_entered_5_8 = start_live_struct + 0x91, -- updates when maps_entered_8 is set to 5

	x_map_overworld_entered_0_8 = start_live_struct + 0x92, -- updates when maps_entered_8 is set to 0
	z_map_overworld_entered_0_8 = start_live_struct + 0x93, -- updates when maps_entered_8 is set to 0
	direction_map_entered_0_8 = start_live_struct + 0x94, -- updates when maps_entered_8 is set to 0
	unknown_entered_0_8 = start_live_struct + 0x95, -- updates when maps_entered_8 is set to 0

	bike_gear_16 = start_live_struct + 0x98, -- 1 is fast, everything else slow
	unknown_mode_16 = start_live_struct + 0x9A,
	movement_mode_32 = start_live_struct + 0x9C, -- walk=0,bike=1,surf=2
	step_counter_max4_8 = start_live_struct + 0xA0, -- %4 performed
}

-- player's npc struct 
start_player_struct = data_table["player_npc_struct_offs"] -- add memory_shift

player_struct = {
	general_npc_data_ptr = start_player_struct + 0x8,
	general_player_data_ptr = start_player_struct + 0xC,
	sprite_id_32 = start_player_struct + 0x30,
	movement_32 = start_player_struct + 0x48, --crashes after 0x10
	facing_dir_32 = start_player_struct + 0x4C,
	movement_32_r = start_player_struct + 0x50,
	last_facing_dir_32 = start_player_struct + 0x54,

	-- last warp coords
	last_warp_x_32 = start_player_struct + 0x6C,
	last_warp_z_32 = start_player_struct + 0x70,
	last_warp_y_32 = start_player_struct + 0x74,

	-- final coords (updated last)
	x_32_r = start_player_struct + 0x78,
	y_32_r = start_player_struct + 0x7C,
	z_32_r = start_player_struct + 0x80,

	-- coords for interacting with terain/collision + position in ram
	x_phys_32 = start_player_struct + 0x84,
	y_phys_32 = start_player_struct + 0x88, 
	z_phys_32 = start_player_struct + 0x8C,

	-- coords used for camera position
	-- has subpixel precision
	x_cam_subpixel_16 = start_player_struct + 0x90,
	x_cam_16 = start_player_struct + 0x92,
	y_cam_subpixel_16 = start_player_struct + 0x94,
	y_cam_16 = start_player_struct + 0x96,
	z_cam_subpixel_16 = start_player_struct + 0x98,
	z_cam_16 = start_player_struct + 0x9A,

	tile_type_16_1 = start_player_struct + 0xCC,
	tile_type_16_2 = start_player_struct + 0xCE,
	sprite_ptr = start_player_struct + 0x12C,
}

start_general_npc_struct = data_table["general_npc_struct_offs"]

general_npc_struct = {
	max_npc_count = start_general_npc_struct + 0x24,
	npc_count = start_general_npc_struct + 0x28,
}

start_npc_struct = data_table["npc_struct_offs"]

generic_npc_struct = {
	sprite_id_32 = start_npc_struct + 0x10,
	movement_32 = start_npc_struct + 0x24, --crashes after 0x10
	facing_dir_32 = start_npc_struct + 0x28,
	movement_32_r = start_npc_struct + 0x2C,
	last_facing_dir_32 = start_npc_struct + 0x30,

	-- spawn location (?)
	x_spawn_32 = start_npc_struct + 0x4C,
	y_spawn_32 = start_npc_struct + 0x50,
	z_spawn_32 = start_npc_struct + 0x54,

	-- final coords (updated last)
	x_32 = start_npc_struct + 0x58,
	y_32 = start_npc_struct + 0x5C,
	z_32 = start_npc_struct + 0x60,

	-- coords for noticing player/talking to npc/collision
	x_phys_32 = start_npc_struct + 0x64,
	y_phys_32 = start_npc_struct + 0x68,
	z_phys_32 = start_npc_struct + 0x6C,

	-- coords used for camera position
	-- has subpixel precision
	x_cam_subpixel_16 = start_npc_struct + 0x70,
	x_cam_16 = start_npc_struct + 0x72,
	y_cam_subpixel_16 = start_npc_struct + 0x74,
	y_cam_16 = start_npc_struct + 0x76,
	z_cam_subpixel_16 = start_npc_struct + 0x78,
	z_cam_16 = start_npc_struct + 0x7A,

	tile_type_16_1 = start_npc_struct + 0xCC,
	tile_type_16_2 = start_npc_struct + 0xCE,

}

start_object_struct = data_table["object_struct_offs"]

object_struct = {
	warp_ptr_offs = start_object_struct + 0x38,
	trigger_ptr_offs = start_object_struct + 0x3C,
	object_count = start_object_struct + 0x40,
	runtime_index_32 = start_object_struct + 0x44,
	x_phys_32 = start_object_struct + 0x48,
	z_phys_32 = start_object_struct + 0x4C,
	y_phys_32 = start_object_struct + 0x50,
	unknown_32 = start_object_struct + 0x54
}

warp_struct = {
	warp_count = -0x4,
	x_phys_16 = 0x0,
	z_phys_16 = 0x2,
	map_id_16 = 0x4,
	warp_index_at_map_id_16 = 0x6, -- the index of the warp you will get out of at the map you teleport to
	unknown_32 = 0x8
}

trigger_struct = {
	trigger_count = -0x4,
	unknown_16 = 0x0,
	x_phys_16 = 0x2,
	z_phys_16 = 0x4,
	vert_count_16 = 0x6,
	hor_count_16 = 0x8,
	unknown_2_16 = 0xA,
	flag_index_32 = 0xC, -- not 100% certain
}


chunk_struct = {
	pointer_32 = 0x0,
	buffer_1 = {},
	buffer_2 = {},
	buffer_3 = {},
	buffer_4 = {},
	
	chunk_pointer_offs = {0x90,0x94,0x98,0x9C},
	current_chunk_8 = 0xAC,
	current_subchunk_8 = 0xAD
}

chunk_buffer_struct = {

}
start_item_struct = data_table["item_struct_offs"]

item_pocket_struct = {
	{"items_pocket",start_item_struct, start_item_struct + 0x294},
	{"medicine_pocket",start_item_struct + 0x51C,start_item_struct + 0x5BC},
	{"balls_pocket",start_item_struct + 0x6BC,start_item_struct + 0x6F8},
	{"tms_hms_pocket",start_item_struct + 0x35C,start_item_struct + 0x4EC},	
	{"berries_pocket",start_item_struct + 0x5BC,start_item_struct + 0x6BC},
	{"mails_pocket",start_item_struct + 0x4EC, start_item_struct + 0x5BC},
	{"battle_items_pocket",start_item_struct + 0x6F8,start_item_struct + 0x9A1},
	{"key_items_pocket",start_item_struct + 0x294,start_item_struct + 0x35C}
}

selected_key_item = start_item_struct + 0xC25


item_struct = {
	item_id = 0x0,
	item_count = 0x4
}

start_ug_circle_struct = data_table["ug_revealing_circle_struct_offs"]

ug_circle_struct = {
	x_center_circle_32 = start_ug_circle_struct + 0x40,
	z_center_circle_32 = start_ug_circle_struct + 0x44,
	x_subpixel_center_circle_32 = start_ug_circle_struct + 0x48,
	z_subpixel_center_circle_32 = start_ug_circle_struct + 0x4C,
	anime_frame_count = start_ug_circle_struct + 0x50,

}

start_ug_gem_struct = data_table["ug_gem_struct_offs"]

ug_gem_struct = {
	x_phys_16 = start_ug_gem_struct,
	z_phys_16 = start_ug_gem_struct+0x2,
	unknown_16 = start_ug_gem_struct+0x4, -- something to do with interacting, crashes at 0xffff

}

start_ug_trap_struct = data_table["ug_trap_struct_offs"]

ug_trap_struct = {
	x_phys_16 = start_ug_trap_struct,
	z_phys_16 = start_ug_trap_struct+0x2,
	trap_type_id_8 = start_ug_trap_struct+0x4,
	trap_array_id_8 = start_ug_trap_struct+0x5, 
}

start_ug_excavation_minigame = data_table["ug_excavation_minigame_offs"]

ug_excavation_minigame_struct = {
	tiles_start = start_ug_excavation_minigame,
	play_state = start_ug_excavation_minigame + 0x82, -- playing=0x8,win/loss=0x0
	leftover_taps_8 = start_ug_excavation_minigame + 0x89,
	screen_offs_32 = start_ug_excavation_minigame + 0x8A, -- for the shaking effect when tapping
}

start_matrix_struct = data_table["matrix_struct_offs"]

matrix_struct = {
	matrix_width_8 = start_matrix_struct + 0x54,
	matrix_height_8 = start_matrix_struct + 0x55,
	matrix_center_16 = start_matrix_struct + 0x56,
}

start_mapdata_and_menu_struct = data_table["mapdata_and_menu_struct_offs"]

mapdata_and_menu_struct = {
	side_menu_state = start_mapdata_and_menu_struct + 0x78,
	menu_index = start_mapdata_and_menu_struct + 0xF4,
}

hovering_item_struct = {
	hovering_item_text_pointer = 0x358,
	hovering_item_id = 0x360,
	unknown_16 = 0x362,
	cursor_offset_16 = 0x364,
}

-- MATH, INPUT, FORMATTING, NON-GAMEPLAY RELATED FUNCTIONS

function fmt(arg,len)
    return string.format("%0"..len.."X", bit.band(4294967295, arg))
end

function print_txt(x,y,txt,clr,screen)
	screen = screen or 1
	gui.text(x,screen_y[screen]+y,txt,clr)
end 

debug = true 

function debug_print(text)
	if debug then print(text) end 
end 

function draw_bounding_rectangle(x,y,width,height,fill,border_clr,screen)
	screen = screen or 1
	gui.box(x-(width/2),screen_y[screen]+y-(height/2),x+(width/2),screen_y[screen]+y+(height/2),fill,border_clr)
end 

function draw_rectangle(x,y,width,height,fill,border_clr,screen)
	screen = screen or 1
	gui.box(x,screen_y[screen]+y,x+width,screen_y[screen]+y+height,fill,border_clr)
end 

function draw_line(x,y,width,height,clr,screen)
	screen = screen or 1
	gui.line(x,screen_y[screen]+y,x+width,screen_y[screen]+y+height,clr)
end 


screen_options = {
	OW={-200,0},
	BT={-200,0},
	UG={0,-200}}

function set_screen_params(memory_state)
	return screen_options[memory_state]
end
	
-- INPUT FUNCTIONS 

key = {}
last_key = {}
joy = {}
last_joy = {}
stylus_ = {}
last_stylus = {}

function get_keys()
	last_key = key
	key = input.get()
end

function check_keys(btns)
	pressed_key_count = 0
	not_prev_held = false
	for btn =1,#btns do
		if key[btns[btn]] then 	
				pressed_key_count = pressed_key_count + 1
		end 
		if not last_key[btns[btn]] then
			not_prev_held = true -- check if at least 1 button wasn't previously held
		end 
	end
	if not_prev_held then
		return pressed_key_count
	end 
end 

function check_key(btn)
	if key[btn] and not last_key[btn] then
		return true
	else
		return false
	end
end

function get_joy()
	last_joy = joy
	joy = joypad.get()
end 

function get_stylus()
	last_stylus = stylus_
	stylus_ = stylus.get()
end

function is_clicking_area(x,y,x2,y2,click_type)
	click_type = click_type or "leftclick"
	if key[click_type] then 
		if (key["xmouse"] >= x) and (key["xmouse"] <= (x + x2)) then
			if (key["ymouse"] >= y) and (key["ymouse"] <= (y + y2)) then
				return true
			end
		end
	end 
end 

function wait_frames(frames)
	current_frame = emu.framecount()
	target_frame = current_frame + frames
	while current_frame < target_frame do
		emu.frameadvance()
		current_frame = emu.framecount()
		if current_frame == 0 then
		 	break
		end 
	end 
end

clock = os.clock

function sleep(n)  -- seconds
   local t0 = clock()
   while clock() - t0 <= n do
   end
end

function wait_for_reset()
	current_frame = emu.framecount()
	sleep(1)
end

function tap_touch_screen(x_,y_,frames)
	current_frame = emu.framecount()
	target_frame = current_frame + frames
	while current_frame < target_frame do
		stylus_.x = x_
		stylus_.y = y_
		stylus_.touch = true
		stylus.set(stylus_)
		emu.frameadvance()
		current_frame = emu.framecount()
	end 
end

function press_button(btn,frames)
	frames = frames or 2
	current_frame = emu.framecount()
	target_frame = current_frame + frames
	while current_frame ~= target_frame do
		joy[btn] = true 
		joypad.set(joy)
		emu.frameadvance()
		current_frame = emu.framecount()
	end 
	joy[btn] = false
end 

function press_buttons(btns,frames)
	frames = frames or 2
	current_frame = emu.framecount()
	target_frame = current_frame + frames
	while current_frame < target_frame do
		for i = 1,#btns do
			joy[btns[i]] = true
		end 
		joypad.set(joy)
		emu.frameadvance()
		current_frame = emu.framecount()
	end 
	for btn = 1,#btns do
		joy[btn] = false
	end 
end 	

-- menu selection 

function use_menu(menu_index)

	if memory.readword(base + mapdata_and_menu_struct["side_menu_state"]) == 0 then	
		press_button("X")
	end 
	
	current_menu_index = memory.readbyte(base + mapdata_and_menu_struct["menu_index"])

	if menu_index == current_menu_index then 
		wait_frames(4)
		press_button("A")
	elseif menu_index > current_menu_index then 
		btn = "down"
	else
		btn = "up"
	end 

	while menu_index ~= current_menu_index do
		press_button(btn)
		wait_frames(2)
		current_menu_index = memory.readbyte(base + mapdata_and_menu_struct["menu_index"])
	end 
	press_button("A")
end

function find_item_address_from_pocket(item_id,pocket_id,item_id2)
	item_id2 = item_id2 or item_id
	current_addr = base + item_pocket_struct[pocket_id+1][2]
	end_addr = base + item_pocket_struct[pocket_id+1][3]
	current_item_id = memory.readword(current_addr)
	while (current_addr < end_addr) and (current_item_id ~= 0) do
		current_item_id = memory.readword(current_addr)
		if (current_item_id == item_id) or (current_item_id == item_id2)  then
			debug_print("item found with id "..fmt(item_id,4).." or id "..fmt(item_id2,4).." at addr "..fmt(current_addr,8).." in "..item_pocket_struct[pocket_id+1][1])
			return  current_addr
		end 
		current_addr = current_addr + 0x4
	end 
	return nil 
end 

function find_item_address(item_id)
	for pocket_id = 0,#item_pocket_struct-1 do
		current_addr = base + item_pocket_struct[pocket_id+1][2]
		end_addr = base + item_pocket_struct[pocket_id+1][3]
		current_item_id = memory.readword(current_addr)
		while (current_addr < end_addr) and (current_item_id ~= 0) do
			current_item_id = memory.readword(current_addr)
			-- debug_print("item with id "..fmt(current_item_id,4)..item_pocket_struct[pocket_id+1][1])
			if current_item_id == item_id then
				data = {current_addr,pocket_id}
				debug_print("item found with id "..fmt(item_id,4).." at addr "..fmt(current_addr,8).." in "..item_pocket_struct[pocket_id+1][1])
				return data
			end 
			
			current_addr = current_addr + 0x4
		end 
	end
	debug_print("item with id "..fmt(item_id,4).." not found")
	return {nil,nil}
end 

function switch_to_item(item_id)
	item_data = find_item_address(item_id)
	item_address = item_data[1]
	pocket_id = item_data[2]

	if item_address == nil then
		debug_print("use_item has failed, the requested item cannot be found in any pocket")
		return
	end
	
	current_pocket_id = memory.readbyte(base + data_table["current_pocket_index_offs"])
	count_button_presses = math.abs(pocket_id - current_pocket_id)

	if pocket_id > current_pocket_id then
		direction = "right"
	else
		direction = "left"
	end

	for i = 1,count_button_presses do 
		press_button(direction)
		wait_frames(4)
	end 
	wait_frames(40)
	current_pocket_id = memory.readbyte(base + data_table["current_pocket_index_offs"])	
	hovering_item_id_offs = memory.readdword(data_table["bag_hovering_data_ptr"])

	if memory.readword(hovering_item_id_offs + hovering_item_struct["cursor_offset_16"]) == 0x5A then -- hovering over "none"
		direction = "up"
	else	
		hovering_item_id = memory.readbyte(hovering_item_id_offs + hovering_item_struct["hovering_item_id"])
		hovering_item_address = find_item_address_from_pocket(hovering_item_id,current_pocket_id,hovering_item_id+0x100)

		if hovering_item_address == nil then -- failed to find item in current pocket
			debug_print("use_item failed, item"..fmt(hovering_item_id,4).."couldn't be found in pocket "..current_pocket_id)
			debug_print("function will now return")
			return
		end

		if item_address > hovering_item_address then
			direction = "down"
		else 
			direction = "up"
		end
	end 

	-- slow, but efficient, doesn't work with none sadly
	-- count_button_presses = math.abs(item_address - hovering_item_address)/4

	-- for i = 1,count_button_presses do
	-- 	press_button(direction)
	-- 	wait_frames(8)
	-- end

	-- fast, but inefficient. the duality of man :/

	while item_id%0x100 ~= hovering_item_id do
		press_button(direction)
		wait_frames(2)
		hovering_item_id = memory.readbyte(hovering_item_id_offs + 0x360)
		-- debug_print(fmt(item_id,4),fmt(hovering_item_id,4))
		
		-- if hovering_item_id == 0xF8 then
		-- 	debug_print("Failed to find item")
		-- 	press_button("B")
		-- 	wait_frames(120)
		-- 	press_button("B")
		-- 	wait_frames(8)
		-- 	return
		-- end 
	end

	press_button("A")
	wait_frames(8)
	press_button("A")
	wait_frames(120)
end 

function use_item(item_id,menu_open)
	menu_open = menu_open or false 
	if menu_open == false then 
		use_menu(2)
		wait_frames(100)
	end 
	switch_to_item(item_id)
end

function use_explorer_kit(full,crash,reset_,menu_open)
	wait_frames(80)
	use_item(0x01AC,menu_open)

	if full then 
		mash_button("A",200)
		wait_frames(400)
		if crash then
			wait_frames(400)
			debug_print("crash A")
			press_button("A")
			sleep(2)
			wait_frames(650)
			debug_print("A 1")
			press_button("A")
			wait_frames(80)
			debug_print("A 2")
			press_button("A")
			wait_frames(200)
			debug_print("A 3")
			press_button("A")
			wait_frames(100)
			return
		end
		if reset_ then
			reset()
		end 
		return
	end 
	press_button("B")
	wait_frames(60)
end

function close_menu(close_side_menu)
	press_button("B")
	wait_frames(100)
	if close_side_menu then
		press_button("B")
	end
end

--

function ledgecancel(steps,keep_side_menu)
	steps = steps or 0
	wait_frames(steps*8+4)
	press_button("X")
	if keep_side_menu then return end
	wait_frames(4)
	press_button("B")
end 

mash_switch = {
	A = "B",
	B = "A"
}

function mash_text(frames)
	btn= "A"
	current_frame = emu.framecount()
	target_frame = current_frame + frames
	while current_frame < target_frame do
		button_release_frame = current_frame + 2
		while current_frame ~= button_release_frame do 
			joy[mash_switch[btn]] = false
			joy[btn] = true 
			joypad.set(joy)
			emu.frameadvance()
			current_frame = emu.framecount()
		end 
		btn = mash_switch[btn]
	end 
	joy[mash_switch[btn]] = false
end 

function mash_button(btn,frames)
	c_frame_mash = emu.framecount()
	target_frame_mash = c_frame_mash+ frames
	
	while c_frame_mash < target_frame_mash do
		press_button(btn)
		wait_frames(2)
		c_frame_mash = emu.framecount()
	end 
end

function mash_pal_park_text(text_box)
	text_box = text_box or 0

	if text_box == 1 then
		wait_frames(80)
		mash_button("A",620)
		wait_frames(60)
		press_button("down")
		wait_frames(90)
		mash_button("A",12)
		wait_frames(120)
		mash_button("A",200)
		wait_frames(120)
		clear_stepcounter()
		return 
	end 
end 

function save()
	use_menu(4)
	mash_button("A",200)
	wait_frames(400)
end 

function reset(reset_type,wait_for_intro)
	reset_type = reset_type or "hard"
	if reset_type == "hard" then
		-- debug_print("hard reset")
		emu.reset()
	elseif reset == "soft" then
		-- debug_print("soft reset")
		press_buttons({"start","select","L","R"},2)
		wait_for_reset()
		wait_frames(40)
	else return
	end 
	if wait_for_intro then
		wait_frames(1600) --1300 is enough, this is for demonstration purposes
		press_button("A")
		wait_frames(80)
		press_button("A")
		wait_frames(200)
		press_button("A")
		wait_frames(100)
		return
	end 
	wait_frames(450)
	press_button("A")
	wait_frames(80)
	press_button("A")
	wait_frames(200)
	press_button("A")
	wait_frames(100)
end 

function save_reset(reset_type,wait_for_intro)
	save()
	reset(reset_type,wait_for_intro)
end 

function wrong_warp_reset(wait_for_intro)
	mash_button("A",400)
	wait_frames(350)
	mash_button("A",8)
	wait_frames(200)
	reset("hard",wait_for_intro)
end 

function fast_warp(wait_for_intro)
	go_direction_wait_warp("left")
	wait_frames(200)
	clear_stepcounter()
	wait_frames(100)
	left(4)
	up(13)
	graphic_reload()
	up(2)
	right(6)
	graphic_reload()
	down(2)
	graphic_reload()
	down(3)
	right(1)
	wrong_warp_reset(wait_for_intro)
end

function get_on_bike(bike_gear,init_wait)
	init_wait = init_wait or 4
	bike_gear = bike_gear or 1
	init_wait = init_wait or 4
	wait_frames(init_wait)

	if check_bike_state() == 0 then -- walking, slow bike
		press_button("Y")
		wait_frames(8)
		if bike_gear == 1 then 
			press_button("B")
			wait_frames(8)
		end
		return
	end
	if check_bike_state() == 1 then -- on bike, slow bike
		if bike_gear == 1 then
			press_button("B")
		end 
		return
	end 
	if check_bike_state() == 2 then --on bike, fast bike
		if bike_gear == 0 then
			press_button("B")
		end 
		return
	end 
	if check_bike_state() == 4 then -- walking, fast bike
		press_button("Y")
		wait_frames(8)
		if bike_gear == 0 then 
			press_button("B")
			wait_frames(8)
		end
		return
	end
end

function graphic_reload()
	use_menu(5)
	wait_frames(100)
	press_button("B")
	wait_frames(100)
	press_button("B")
end 

-- MOVEMENT FUNCTIONS

collision_states = {
	[0x1000] = 0x1C20,
	[0x1C20] = 0x1000
}

function switch_wtw_state()
	current_collision_state = memory.readword(lang_data["collision_check_addr"])
	memory.writeword(lang_data["collision_check_addr"],collision_states[current_collision_state])
end

function set_stepcounter(steps)
	step_addr = base+live_struct["step_counter"]
	memory.writeword(step_addr,0)
end 

function clear_stepcounter()
	tap_touch_screen(115,120,4)
end 

function check_bike_state()
	bike_state = 0
	if memory.readword(base+live_struct["movement_mode_32"]) == 1 then -- on bike
		bike_state = bike_state + 1
		if memory.readword(base+live_struct["bike_gear_16"]) == 1 then -- fast gear
			bike_state = 2
		end
	else 
		if memory.readword(base+live_struct["bike_gear_16"]) == 1 then -- fast gear, but walking
			bike_state = 4
		end	
	end 	
	return bike_state
end 

function move_player(pos,target,pos_offs,j_up,j_down,j_left,j_right)
	while pos ~= target do
		joy.up = j_up
		joy.down = j_down
		joy.left = j_left
		joy.right = j_right
		joypad.set(joy)
		joy = {}
		emu.frameadvance()
		pos = memory.readdword(base + pos_offs)
	end
end 

function return_arg(input,other)
	if input == "false" then
			return false
		end
	return other
end

function up(steps,delay_before_reset,delay_after_reset,reset_stepcounter)
	delay_before_reset = delay_before_reset or 2
	delay_after_reset = delay_after_reset or 4
	reset_stepcounter = return_arg(reset_stepcounter,true)

	player_pos_y = memory.readdword(base + live_struct["z_pos_32_r"])
	target = player_pos_y - steps

	-- account for bike momentum
	if check_bike_state() == 2 then
		if steps > 3 then 
			target = target + 2
		end
	end 

	if target < 0 then
		target = 4294967295 + target + 1
	end
	
	move_player(pos,target,live_struct["z_pos_32_r"],true)
	if reset_stepcounter then
		wait_frames(delay_before_reset*30)
		clear_stepcounter()
	end 
	wait_frames(delay_after_reset*30)
end

function left(steps,delay_before_reset,delay_after_reset,reset_stepcounter)
	delay_before_reset = delay_before_reset or 2
	delay_after_reset = delay_after_reset or 4
	reset_stepcounter = return_arg(reset_stepcounter,true)

	player_pos_x = memory.readdword(base + live_struct["x_pos_32_r"])
	target = player_pos_x - steps

	-- account for bike momentum
	if check_bike_state() == 2 then
		if steps > 3 then 
			target = target + 2
		end
	end 

	if target < 0 then
		target = 4294967295 + target + 1
	end 

	move_player(pos,target,live_struct["x_pos_32_r"],false,false,true)
	
	if reset_stepcounter then
		wait_frames(delay_before_reset*30)
		clear_stepcounter()
	end 
	wait_frames(delay_after_reset*30)
end

function down(steps,delay_before_reset,delay_after_reset,reset_stepcounter)
	delay_before_reset = delay_before_reset or 2
	delay_after_reset = delay_after_reset or 4
	reset_stepcounter = return_arg(reset_stepcounter,true)

	player_pos_y = memory.readdword(base + live_struct["z_pos_32_r"])
	target = (player_pos_y + steps)%4294967296

	-- account for bike momentum
	if check_bike_state() == 2 then
		if steps > 3 then 
			target = target - 2	
		end 
	end
	move_player(pos,target,live_struct["z_pos_32_r"],false,true)
	if reset_stepcounter then
		wait_frames(delay_before_reset*30)
		clear_stepcounter()
	end 
	wait_frames(delay_after_reset*30)
end

function right(steps,delay_before_reset,delay_after_reset,reset_stepcounter)
	delay_before_reset = delay_before_reset or 2
	delay_after_reset = delay_after_reset or 4
	reset_stepcounter = return_arg(reset_stepcounter,true)

	player_pos_x = memory.readdword(base + live_struct["x_pos_32_r"])
	target = (player_pos_x + steps)%4294967296

	-- account for bike momentum
	if check_bike_state() == 2 then
		if steps > 3 then 
			target = target - 2
		end 
	end 

	move_player(pos,target,live_struct["x_pos_32_r"],false,false,false,true)
	if reset_stepcounter then
		wait_frames(delay_before_reset*30)
		clear_stepcounter()
	end 
	wait_frames(delay_after_reset*30)
end

function go_direction_wait_warp(direction,frames)
	frames = frames or 200
	wait_frames(20)
	press_button(direction)
	wait_frames(frames)
end

function check_battle_state()
	if memory.readword(data_table["battle_check"]) ~= 0 then
		return true
	end
	return false 
end 

function turn_around(frames,until_encounter)
	frames = frames or 400
	until_encounter = return_arg(until_encounter,true)
	if until_encounter then
		while not check_battle_state() do
			press_button("right",4)
			wait_frames(4)
			press_button("left",4)
			wait_frames(4)
		end 
		return
	end 
	c_frame = emu.framecount()
	t_frame = c_frame + frames
	while c_frame < t_frame do
		press_button("right",4)
		wait_frames(4)
		press_button("left",4)
		wait_frames(4)
		emu.frameadvance()
		c_frame = emu.framecount()
		if c_frame == 0 then
		 	break
		end 
	end 
end 

function throw_ball(special_fight)
	if special_fight then -- safari/pal park
		tap_touch_screen(115,120,4)
		return
	end
end 

function catch_pal_park_mon(count)
	count = count or 6
	for i=0,count-1 do
		turn_around()
		wait_frames(200)
		mash_button("A",120)
		wait_frames(100)
		throw_ball(true)
		mash_button("A",200)
		wait_frames(1000)
	end 
end 

function catching_show(leave,catch)
	mash_button("A",400)
	wait_frames(700)
	if leave then
		use_menu(8)
		wait_frames(80)
		press_button("A")
		wait_frames(320)
	end 
end 

function use_move(move)
	move = move or "surf"
	wait_frames(8)
	mash_button("A",180)
	wait_frames(108)
end 


function auto_movement()
	get_on_bike(0,0)
	right(5,0,0,"false")
	down(1,0,0,"false")
	up(1,0,0,"false")
	left(1,0,0,"false")
	get_on_bike(1,0)
	up(27,0,0,"false")
	left(37,0,0,"false")
	up(13,0,0,"false")
	right(7,0,0,"false")
	down(1)
	graphic_reload()
	go_direction_wait_warp("down")

	down(1)
	right(16)
	get_on_bike(1)
	up(430)
	left(1)
	use_explorer_kit(true,true)

	right(193)
	up(64)
	save_reset()

	left(214)
	down(479)
	graphic_reload()
	down(2)
	graphic_reload()
	down(3)
	left(2)
	wrong_warp_reset(true)
	
	wait_frames(100)
	right(704)
	down(725)
	right(16)
	use_explorer_kit(true,true)
	
	-- reset shaymin sprite:
	wait_frames(100)
	right(2)
	use_item(0x4F)
	wait_frames(30)
	press_button("A")
	wait_frames(8)
	close_menu(true)
	ledgecancel(2)
	wait_frames(60)
	down(10,0,0,"false")
	right(8,0,0,"false")
	up(8,0,0,"false")
	right(9,0,0,"false")
	up(2,0,0,"false")
	right(5)
	right(68,0,0,"false")
	wait_frames(30)
	mash_button("A",80)
	wait_frames(8)
	right(348)
	down(1995)
	right(96)
	down(160)
	right(32)
	down(160)
	right(32)
	down(96)
	right(160)
	down(32)

	wait_frames(80) -- pal park hub
	right(64)
	up(161,0,0,"false")
	wait_frames(400)
	clear_stepcounter()
	wait_frames(60)
	down(161)
	left(33,0,0,"false")
	mash_pal_park_text(1)

	left(160)
	up(551)
	left(32)
	up(224)
	right(161)
	up(1791)
	right(370)
	up(1)
	graphic_reload()

	catch_pal_park_mon()
	wait_frames(20)
	mash_button("A",32)

	-- lose the battle against shaymin

	-- remove pal park menu
	down(6,0,0,"false")
	go_direction_wait_warp("down")
	down(4,0,0,"false")
	right(3,0,0,"false")
	down(27,0,0,"false")
	left(1,0,0,"false")
	use_move()
	down(11,0,0,"false")
	left(1,0,0,"false")
	down(4,0,0,"false")
	use_move()
	down(8,0,0,"false")
	right(3,0,0,"false")
	down(6,0,0,"false")
	right(16,0,0,"false")
	up(1,0,0,"false")
	right(9,0,0,"false")
	down(1,0,0,"false")
	right(24,0,0,"false")
	down(3,0,0,"false")
	right(2,0,0,"false")
	down(2,0,0,"false")
	right(2,0,0,"false")
	down(1,0,0,"false")
	right(8,0,0,"false")
	down(2,0,0,"false")
	right(65,0,0,"false")
	up(2,0,0,"false")
	go_direction_wait_warp("up")
	up(7,0,0,"false")

	catching_show(true)
	down(7,0,0,"false")
	go_direction_wait_warp("down")

	use_menu(1)
	wait_frames(120)
	press_button("right")
	wait_frames(4)
	press_button("A")
	wait_frames(4)
	press_button("down")
	wait_frames(2)
	press_button("down")
	wait_frames(2)
	press_button("down")
	wait_frames(2)
	press_button("A")
	wait_frames(80)
	press_buttons({"up","left"},24)
	wait_frames(2)
	press_button("A")
	wait_frames(600)
	press_button("up",4)

	go_direction_wait_warp("up")
	up(2,0,0,"false")
	left(5,0,0,"false")

	--  -- capture shaymin:
	fast_warp()

	wait_frames(100)

	right(2)
	get_on_bike(1)
	use_item(0x4F)
	wait_frames(30)
	press_button("A")
	wait_frames(8)
	close_menu(true)
	ledgecancel(2)
	wait_frames(60)
	down(10,0,0,"false")
	right(8,0,0,"false")
	up(8,0,0,"false")
	right(9,0,0,"false")
	up(2,0,0,"false")
	right(5)
	right(68,0,0,"false")
	wait_frames(30)
	mash_button("A",80)
	wait_frames(8)
	right(75)

	save_reset()
	up(105,0,0,"false")

	
	debug_print("auto_movement has finished")
end 

tp_amount = 31

function teleport_up()
	z_phys_32 = memory.readdword(base + player_struct["z_phys_32"] + memory_shift)
	memory.writedword(base + player_struct["z_phys_32"] + memory_shift,z_phys_32 - tp_amount) 
	z_cam_16 = memory.readword(base + player_struct["z_cam_16"] + memory_shift)
	memory.writeword(base + player_struct["z_cam_16"] + memory_shift,z_cam_16 - tp_amount) 
end

function teleport_left()
	x_phys_32 = memory.readdword(base + player_struct["x_phys_32"] + memory_shift)
	memory.writedword(base + player_struct["x_phys_32"] + memory_shift,x_phys_32 - tp_amount) 
	x_cam_16 = memory.readword(base + player_struct["x_cam_16"] + memory_shift)
	memory.writeword(base + player_struct["x_cam_16"] + memory_shift,x_cam_16 - tp_amount) 
end

function teleport_right()
	x_phys_32 = memory.readdword(base + player_struct["x_phys_32"] + memory_shift)
	memory.writedword(base + player_struct["x_phys_32"] + memory_shift,x_phys_32 + tp_amount) 
	x_cam_16 = memory.readword(base + player_struct["x_cam_16"] + memory_shift)
	memory.writeword(base + player_struct["x_cam_16"] + memory_shift,x_cam_16 + tp_amount)
end

function teleport_down()
	z_phys_32 = memory.readdword(base + player_struct["z_phys_32"] + memory_shift)
	memory.writedword(base + player_struct["z_phys_32"] + memory_shift,z_phys_32 + tp_amount) 
	z_cam_16 = memory.readword(base + player_struct["z_cam_16"] + memory_shift)
	memory.writeword(base + player_struct["z_cam_16"] + memory_shift,z_cam_16 + tp_amount) 
end

-- GUI GAMEPLAY FUNCTIONS

function get_memory_state()
	if memory.readdword(base+data_table["memory_state_check_offs"]) == (base + data_table["memory_state_check_val"]) then -- check for ug/bt ptr
		if memory.readbyte(data_table["ug_init_addr"]) == data_table["ug_init_val"] then -- if 0x1f, is UG
			return "UG"
		end
		return "BT" 
	end 
	return "OW"
end

function show_player_data()
end

function win_ug_minigame()
	for i = 0,data_table["ug_excavation_minigame_tile_count"] do
		memory.writebyte(base+ug_excavation_minigame_struct["tiles_start"]+i,0)		
	end 
end

function remove_trap_effect()
end 

-- BOUNDING BOXES
bounding_view = false
function toggle_bounding_view()
	bounding_view = not bounding_view
end 


function show_ug_gems() 
	draw_bounding_boxes(data_table["ug_gem_count"],base + ug_gem_struct["x_phys_16"], base + ug_gem_struct["z_phys_16"],data_table["ug_gem_struct_size"],0x0,"#FFF8666","#FFF66")
end 

function show_ug_traps()
	ug_trap_count = memory.readbyte(data_table["ug_trap_count_addr"])
	draw_bounding_boxes(ug_trap_count,base + ug_trap_struct["x_phys_16"], base + ug_trap_struct["z_phys_16"],data_table["ug_trap_struct_size"],0x0,"#FFFFFF8","white")
end 

function show_objects()
	object_count = memory.readword(base+object_struct["object_count"])
	draw_bounding_boxes(object_count,base + object_struct["x_phys_32"], base + object_struct["z_phys_32"],data_table["object_struct_size"],0x0,"#9793FF8","purple")
end 

function show_triggers()
	start_trigger_struct = memory.readdword(base+object_struct["trigger_ptr_offs"])
	trigger_count = memory.readword(start_trigger_struct+trigger_struct["trigger_count"])
	for i = 0,trigger_count-1 do 
		x_phys_16 = memory.readword(start_trigger_struct + trigger_struct["x_phys_16"] + i*data_table["trigger_struct_size"])
		z_phys_16 = memory.readword(start_trigger_struct + trigger_struct["z_phys_16"] + i*data_table["trigger_struct_size"])
		vert_count_16 = memory.readword(start_trigger_struct+trigger_struct["vert_count_16"] + i*data_table["trigger_struct_size"])
		hor_count_16 = memory.readword(start_trigger_struct+trigger_struct["hor_count_16"] + i*data_table["trigger_struct_size"])
		for vert_offs = 0, vert_count_16-1 do
			x_trigger_inst = x_phys_16 + vert_offs
			for hor_offs = 0, hor_count_16-1 do
				z_trigger_inst = z_phys_16 + hor_offs
				draw_bounding_box(x_trigger_inst,z_trigger_inst,"#FFF8666","#FFF66")		
			end 
		end 
	end
end

function show_warps()
	start_warp_struct = memory.readdword(base+object_struct["warp_ptr_offs"])
	warp_count = memory.readword(start_warp_struct+warp_struct["warp_count"])
	draw_bounding_boxes(warp_count,start_warp_struct+warp_struct["x_phys_16"],start_warp_struct+warp_struct["z_phys_16"],data_table["warp_struct_size"],0x0,"#600038", "#C00058")
end 

function show_npcs()
	npc_count = memory.readbyte(base + general_npc_struct["npc_count"] + memory_shift) -1 -- subtracting player's npc from count
	print_txt(5,40,npc_count,"blue")
	if npc_count > 0 then -- prevent negative npc count when not initialized
		draw_bounding_boxes(npc_count,base + generic_npc_struct["x_phys_32"],base + generic_npc_struct["z_phys_32"],data_table["npc_struct_size"],memory_shift,"#88FFFFA0","#0FB58")
	end
end

function show_trainer_range()
	npc_count = memory.readbyte(base + general_npc_struct["npc_count"] + memory_shift) -1 -- subtracting player's npc from count
	if npc_count > 0 then -- prevent negative npc count when not initialized
		
	end
end 

function draw_bounding_boxes(count,x_start,z_start,struct_size,extra_offs,fill,border)
	for i = 0,count-1 do 
		x_phys_32 = memory.readword(x_start + i*struct_size + extra_offs)
		z_phys_32 = memory.readword(z_start + i*struct_size + extra_offs)
		draw_bounding_box(x_phys_32,z_phys_32,fill,border)
	end
end 

function draw_bounding_box(x,z,fill_clr,border_clr)
	x_v = (memory.readword(base + live_struct["x_pos_32_r"]) - x) *16
	y_v = (memory.readword(base + live_struct["z_pos_32_r"]) - z)
	if y_v > 0 then 
		y_v = y_v*13
	else
		y_v = y_v*15.5
	end
	draw_bounding_rectangle(127-x_v,99-y_v,12,12,fill_clr,border_clr)
end

function draw_player_pos(fill_clr,border_clr)
	draw_bounding_rectangle(128,99,15,14,fill_clr,border_clr)
end 

function show_bounding_boxes(memory_state)
	-- data that should always be shown
	draw_player_pos("#88FFFFA0","#0FB58")
	show_npcs()

	-- data that should only be shown when in UG (check is for excavation game)
	if memory_state == "UG" then
		-- if memory.readbyte(base+data_table["menu_addr"]) == 0 then 
		show_ug_gems()
		show_ug_traps()
		-- 	return 
		-- end
		return
	end 
	-- data that should only be shown when not in UG
	show_player_data()
	show_objects()
	show_triggers()
	show_warps()
	-- data that is unique to overworld
end 

--
menu_id = 1
menu_count = 2

function increment_menu()
	menu_id = (menu_id + 1)%menu_count
end 

function get_map_id_color(map_id)
	if map_id > 558 then return map_id_list['Jubilife']['color'] end
	return map_ids[map_id] or map_id_list['Normal']['color']
end 


function show_void_pos()
	matrix_width = memory.readbyte(base + matrix_struct["matrix_width_8"])
	matrix_center = base + matrix_struct["matrix_center_16"]

	x_phys_32 = memory.readdwordsigned(base + player_struct["x_phys_32"] + memory_shift)
	z_phys_32 = memory.readdwordsigned(base + player_struct["z_phys_32"] + memory_shift)

	x_offs = math.modf(x_phys_32 / 32) *2
	z_offs = math.modf(z_phys_32 / 32) *2 *matrix_width 

	center = (5*2) + (data_table["matrix_size"]*2*9)
	for row=0,9 do
		for col=0,18 do 
			c_map_offset = matrix_center+x_offs+z_offs + row*2 + col*2*data_table["matrix_size"]-center
			c_map_id = memory.readword(c_map_offset)
			if c_map_offset == matrix_center + x_offs+z_offs then
				clr = 'white'
			else
				clr = get_map_id_color(c_map_id)
			end

			if c_map_id > 999 then
				c_map_id = ">999"
			end 

			print_txt(3 + row*25,3 + col*10,c_map_id,clr,2)
		end 
	end 
end

function split_word_into_bytes(word)
	h_byte = bit.rshift(word,8)
	l_byte = bit.band(word,0xFF)
	return {l_byte,h_byte}
end 

-- Loadlines and grid

grid = true 
loadlines = true 
maplines = true 

function toggle_grid()
	grid = not grid
	loadlines = not loadlines
	maplines = not maplines
end 

function show_boundary_lines()
	if grid then show_gridlines() end
	if loadlines then show_loadlines() end
	if maplines then show_maplines() end
end 

function show_gridlines()
	for i = 0,15 do draw_line(i*16+7,0,0,200, "#0FB58") end 
	for i = 0,7 do draw_line(0,i*13,256,0, "#0FB58") end
	for i = 0,6 do draw_line(0,7*13+15.5*i,256,0, "#0FB58") end
end 

function show_loadlines()
	x_cam_16 = memory.readword(base + player_struct["x_cam_16"] + memory_shift)
	z_cam_16 = memory.readword(base + player_struct["z_cam_16"] + memory_shift)
	x_line = (-x_cam_16+23)%32
	z_line = (-z_cam_16+23)%32
	draw_line(x_line*16+7,0,0,200, "red")
	if z_line > 7 then draw_line(0,7*13+(z_line-7)*15.5,256,0, "red") return end
	draw_line(0,13*z_line,256,0, "red")
end

function show_maplines()
	x_phys_32 = memory.readdword(base + player_struct["x_phys_32"] + memory_shift)
	z_phys_32 = memory.readdword(base + player_struct["z_phys_32"] + memory_shift)
	x_line = (-x_phys_32+7)%32
	z_line = (-z_phys_32+7)%32
	draw_line(x_line*16+7,0,0,200, "blue")
	if z_line > 7 then draw_line(0,7*13+(z_line-7)*15.5,256,0, "blue") return end
	draw_line(0,13*z_line,256,0, "blue")

end  





function get_tile_color(tile_data)
	tile_id = bit.band(tile_data,0xff)
	collision = bit.rshift(tile_data,8)

	if tile_id == 0x00 then 
		if collision > 0x7F then return "#CCCCCC" end
		return
	end 

	return tile_ids[tile_id]

end 

function get_collision_color(collision)
	if bit.rshift(collision,7) ~= 0 then return "#CCCCCC" end
	return tile_id_list['Normal']['color']
end 

chunk_scr_x = {0,128,0,128}
chunk_scr_y = {0,0,96,96}

tile_view = true 

function toggle_tile_view()
	tile_view = not tile_view
end 

player_view = true 

function toggle_player_pos()
	player_view = not player_view
end

function show_chunks_ow()
	-- draw_rectangle(0,0,256,200,"#000022ccc",0,2)
	draw_rectangle(0,0,256,200,"#000001fff","#000001fff",2)
	
	additional_offset = 0
	x_phys_32 = memory.readdword(base + player_struct["x_phys_32"] + memory_shift)
	z_phys_32 = memory.readdword(base + player_struct["z_phys_32"] + memory_shift)
	if x_phys_32 > 0x7FFFFFF then 
		additional_offset = additional_offset -64
	end 
	if z_phys_32 > 0x7FFFFFF then 
		additional_offset = additional_offset -64
	end 

	if tile_view then 
		show_tiles_ow(additional_offset)
		if player_view then
			show_chunk_position()
		end 
		return
	end 
	show_collision_ow(additional_offset)
	if player_view then
		show_chunk_position()
		return
	end 
end 

function show_tiles_ow(additional_offset)
	print_txt(5,60,"chunks")
	start_chunk_struct = memory.readdword(base+data_table["chunk_calculation_ptr"])
	print_txt(5,70,"0x"..fmt(start_chunk_struct,8))
	chunk_pointer_offs = chunk_struct["chunk_pointer_offs"]
	chunk_pointers = {}
	for i = 1,#chunk_pointer_offs do
		chunk_pointer = memory.readdword(chunk_pointer_offs[i] + start_chunk_struct)
		print_txt(5,70+i*10,"0x"..fmt(chunk_pointer,7))
		for row = 0,31 do 
			for col = 0,31 do 
				tile_data = memory.readword(chunk_pointer+row*2 + col*64+additional_offset)
				tile_color = get_tile_color(tile_data)
				draw_rectangle(chunk_scr_x[i]+row*4,chunk_scr_y[i] + col*3,5,3,tile_color,0,2)
			end
		end 

	end 
end

function show_collision_ow(additional_offset)
	print_txt(5,60,"chunks")
	start_chunk_struct = memory.readdword(base+data_table["chunk_calculation_ptr"])
	print_txt(5,70,"0x"..fmt(start_chunk_struct,8))
	chunk_pointer_offs = chunk_struct["chunk_pointer_offs"]
	chunk_pointers = {}

	for i = 1,#chunk_pointer_offs do
		chunk_pointers[i] = memory.readdword(chunk_pointer_offs[i] + start_chunk_struct)
		print_txt(5,70+i*10,"0x"..fmt(chunk_pointers[i],7))
		for row = 0,31 do 
			for col = 0,31 do 
				collision_color = nil
				if (memory.readbyte(chunk_pointers[i]+row*2 + col*64+additional_offset)) ~= 0xff then
					collision  = memory.readbyte(chunk_pointers[i]+row*2 + col*64+1+additional_offset)
					collision_color = get_collision_color(collision)
				end 
				draw_rectangle(chunk_scr_x[i]+row*4,chunk_scr_y[i] + col*3,5,3,collision_color,0,2)
			end
		end 

	end 
end

function show_chunk_position()
	start_chunk_struct = memory.readdword(base+data_table["chunk_calculation_ptr"])
	c_chunk = memory.readbyte(chunk_struct["current_chunk_8"] + start_chunk_struct)
	if c_chunk < 4 then 
		x_phys_32 = memory.readdword(base + player_struct["x_phys_32"] + memory_shift)
		z_phys_32 = memory.readdword(base + player_struct["z_phys_32"] + memory_shift)
		if x_phys_32 > 0x7FFFFFF then 
			c_chunk = 1
		end 
		if z_phys_32 > 0x7FFFFFF then 
			z_phys_32 = z_phys_32 + 1
		end 
		row = x_phys_32%32
		col = z_phys_32%32
		draw_rectangle(chunk_scr_x[c_chunk+1]+row*4,chunk_scr_y[c_chunk+1] + col*3,5,3,"#00f0ff",0,2)
	
	end
	
end 

function show_chunks_battle_tower()
end

function show_chunks_ug()
end

-- SHOW MENU DATA

menu_choices = {
	OW = {show_void_pos,show_chunks_ow},
	UG = {show_void_pos,show_chunks_ug},
	BT = {show_void_pos,show_chunks_bt}
	}

function show_menu_choices()
end 

function show_menu(index)
	menu_count = #menu_choices[memory_state]
	menu_id = menu_id%menu_count
	menu_choices[memory_state][index+1]()
end

key_configuration = {
	switch_wtw_state = {"W"},
	auto_movement = {"shift","M"},
	increment_menu = {"shift","V"},
	teleport_up = {"shift","up"},
	teleport_left = {"shift","left"},
	teleport_down = {"shift","down"},
	teleport_right = {"shift","right"},
	toggle_tile_view = {"shift","T"},
	toggle_player_pos = {"shift","P"},
	toggle_bounding_view = {"shift","I"},
	toggle_grid = {"shift","L"}
}

function run_functions_on_keypress()
	for funct,config_keys in pairs(key_configuration) do
		if check_keys(config_keys) == #config_keys then
			loadstring(funct.."()")()
		end 
	end
end

option_x = 20
option_y = 20

function_options = {
	{show_void_pos,"Void viewer"},
	{show_chunks_ow,"Chunks viewer"}
}

function display_options()
	draw_rectangle(option_x,option_y,100,60)
	if is_clicking_area(option_x,option_y-200,100,60) then clicking_option_menu = true end
	for i = 0,#function_options-1 do
		print_txt(option_x + 5,option_y + 18 + i*10,function_options[i+1][2])
	end 
end 


function main_gui()
	base = memory.readdword(lang_data["base_addr"]) -- check base every loop in case of reset
	memory_state = get_memory_state() -- check for underground,battletower or overworld state (add: intro?)
	memory_shift = data_table["memory_shift"][memory_state] -- get memory shift based on state

	screen_y = set_screen_params(memory_state)
	
	-- main 
	if bounding_view then 
		show_bounding_boxes(memory_state)
	end 
	show_boundary_lines()
	show_menu(menu_id)

	-- temporary gui before I implement gui screens
	print_txt(5,10,fmt(base,7),"yellow")
	print_txt(5,20,memory_state,"red")
	print_txt(5,30,fmt(memory_shift,4),"red")

	-- display_options()

	-- input functions
	get_keys()
	get_joy()
	get_stylus()
	run_functions_on_keypress()
end


gui.register(main_gui)


