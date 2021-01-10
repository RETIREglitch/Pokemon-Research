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
jump = 31 --teleportamount by default 
modoption = 15
bt = false 
btval = 0
chunkrepos = false 
changechunk = 0
tilename = {"nothing","nothing","Grass","Grass","4","Cave","Cave/Tree","7","Cave","9","10", "HauntH","CaveW","13","14","15",
			"Pond","Water","Water","WaterF","Water","Water","Puddle","ShallW","24","Water","26","27","28","29","30","31",
			"Ice","Sand","Water","35","Cave","Cave","38","39","40","41","Water","43","44","45","46","47",
			"OnesideW","OnesideW","OnesideW","OnesideW","52","53","54","55","LedgeR","LedgeL","LedgeU","LedgeD","60","61","62","LedgeCor",
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
			
local mapId = {
	Highlight = {
		color = '#f7bbf3',
		number = {225,513}
		},
	Highlight2= {
		color = '#DfA',
		number = {}
	},
	MysteryZone = {
		color = '#88888866',
		number = {0}
	},
	Blackout = {
		color = 'orange',
		number = {332, 333}
	},
	Movement = {
		color = 'purple',
		number = {117, 177, 179, 181, 183, 192, 393,
            474, 475, 476, 477, 478, 479, 480, 481, 482, 483,
            484, 485, 486, 487, 488, 489, 490, 496}
	},
	VoidExit = {
		color = 'yellow',
		number = {105, 114, 337, 461, 516, 186, 187}
	},
	DANGER = {
		color = 'red',
		number = {35, 88, 93, 95, 122,133, 150 ,154, 155, 156, 176, 178, 180, 182,
				184, 185, 188, 291, 293, 295, 504, 505, 506, 507, 508, 509}
	},
	Wrongwarp = {
		color = '#666fd',
		number = {7,37,49,70,102,124,135,152,169,174,190,421,429,436,444,453,460,495}
	},
	Jubilife = {
		color = '#66ffbbff',
		number = {3}
	},
	Normal = {
		color = '#00bb00ff',
		number = {}
	}
}


scripts = {[0] = 1, [1] = 1, [2] = 6, [3] = 27, [4] = 4, [5] = 1, [6] = 4, [7] = 1, [8] = 4, [9] = 4, [10] = 7, [11] = 17, [12] = 3, [13] = 4, [14] = 2, [15] = 14, [16] = 7, [17] = 6, [18] = 1, [19] = 2, [20] = 2, [21] = 1, [22] = 1, [23] = 1, [24] = 4, [25] = 2, [26] = 2, [27] = 1, [28] = 11, [29] = 12, [30] = 3, [31] = 2, [32] = 1, [33] = 24, [34] = 4, [35] = 4, [36] = 4, [37] = 1, [38] = 4, [39] = 4, [40] = 12, [41] = 2, [42] = 1, [43] = 3, [44] = 3, [45] = 19, [46] = 4, [47] = 3, [48] = 4, [49] = 1, [50] = 3, [51] = 4, [52] = 2, [53] = 3, [54] = 2, [55] = 3, [56] = 3, [57] = 1, [58] = 2, [59] = 13, [60] = 3, [61] = 3, [62] = 4, [63] = 2, [64] = 1, [65] = 23, [66] = 4, [67] = 3, [68] = 7, [69] = 6, [70] = 1, [71] = 5, [72] = 2, [73] = 2, [74] = 1, [75] = 4, [76] = 3, [77] = 2, [78] = 4, [79] = 1, [80] = 4, [81] = 3, [82] = 1, [83] = 2, [84] = 5, [85] = 1, [86] = 33, [87] = 4, [88] = 6, [89] = 1, [90] = 1, [91] = 4, [92] = 1, [93] = 4, [94] = 1, [95] = 4, [96] = 1, [97] = 1, [98] = 1, [99] = 1, [100] = 120, [101] = 4, [102] = 1, [103] = 2, [104] = 2, [105] = 1, [106] = 6, [107] = 4, [108] = 3, [109] = 3, [110] = 1, [111] = 4, [112] = 9, [113] = 4, [114] = 1, [115] = 1, [116] = 5, [117] = 14, [118] = 1, [119] = 6, [120] = 16, [121] = 5, [122] = 7, [123] = 3, [124] = 1, [125] = 5, [126] = 5, [127] = 2, [128] = 2, [129] = 1, [130] = 2, [131] = 3, [132] = 30, [133] = 4, [134] = 3, [135] = 1, [136] = 21, [137] = 8, [138] = 7, [139] = 6, [140] = 6, [141] = 6, [142] = 1, [143] = 2, [144] = 3, [145] = 2, [146] = 3, [147] = 2, [148] = 3, [149] = 2, [150] = 19, [151] = 4, [152] = 1, [153] = 4, [154] = 4, [155] = 4, [156] = 4, [157] = 116, [158] = 1, [159] = 7, [160] = 2, [161] = 1, [162] = 1, [163] = 1, [164] = 4, [165] = 12, [166] = 4, [167] = 4, [168] = 4, [169] = 1, [170] = 2, [171] = 1, [172] = 3, [173] = 6, [174] = 1, [175] = 7, [176] = 3, [177] = 2, [178] = 3, [179] = 2, [180] = 3, [181] = 2, [182] = 3, [183] = 2, [184] = 3, [185] = 2, [186] = 2, [187] = 1, [188] = 17, [189] = 4, [190] = 1, [191] = 4, [192] = 7, [193] = 2, [194] = 2, [195] = 3, [196] = 1, [197] = 1, [198] = 3, [199] = 5, [200] = 7, [201] = 6, [202] = 4, [203] = 12, [204] = 1, [205] = 2, [206] = 1, [207] = 2, [208] = 1, [209] = 1, [210] = 1, [211] = 1, [212] = 1, [213] = 1, [214] = 1, [215] = 1, [216] = 1, [217] = 1, [218] = 1, [219] = 1, [220] = 14, [221] = 1, [222] = 1, [223] = 1, [224] = 1, [225] = 1, [226] = 2, [227] = 1, [228] = 1, [229] = 1, [230] = 1, [231] = 1, [232] = 1, [233] = 1, [234] = 1, [235] = 1, [236] = 1, [237] = 1, [238] = 1, [239] = 1, [240] = 1, [241] = 1, [242] = 1, [243] = 1, [244] = 9, [245] = 1, [246] = 1, [247] = 4, [248] = 1, [249] = 1, [250] = 1, [251] = 6, [252] = 1, [253] = 26, [254] = 1, [255] = 1, [256] = 7, [257] = 2, [258] = 3, [259] = 1, [260] = 2, [261] = 2, [262] = 2, [263] = 4, [264] = 6, [265] = 5, [266] = 1, [267] = 1, [268] = 2, [269] = 2, [270] = 5, [271] = 1, [272] = 1, [273] = 1, [274] = 3, [275] = 1, [276] = 1, [277] = 1, [278] = 1, [279] = 1, [280] = 1, [281] = 1, [282] = 1, [283] = 2, [284] = 6, [285] = 1, [286] = 2, [287] = 1, [288] = 2, [289] = 1, [290] = 1, [291] = 2, [292] = 1, [293] = 9, [294] = 3, [295] = 2, [296] = 2, [297] = 1, [298] = 1, [299] = 1, [300] = 1, [301] = 1, [302] = 2, [303] = 1, [304] = 1, [305] = 8, [306] = 6, [307] = 3, [308] = 4, [309] = 1, [310] = 3, [311] = 7, [312] = 7, [313] = 2, [314] = 4, [315] = 1, [316] = 4, [317] = 1, [318] = 1, [319] = 3, [320] = 2, [321] = 3, [322] = 12, [323] = 126, [324] = 1, [325] = 1, [326] = 23, [327] = 4, [328] = 3, [329] = 3, [330] = 5, [331] = 4, [332] = 1, [333] = 1, [334] = 6, [335] = 1, [336] = 10, [337] = 21, [338] = 1, [339] = 1, [340] = 5, [341] = 1, [342] = 12, [343] = 6, [344] = 6, [345] = 3, [346] = 3, [347] = 10, [348] = 2, [349] = 3, [350] = 8, [351] = 4, [352] = 1, [353] = 7, [354] = 5, [355] = 4, [356] = 9, [357] = 1, [358] = 1, [359] = 1, [360] = 1, [361] = 2, [362] = 7, [363] = 3, [364] = 2, [365] = 3, [366] = 4, [367] = 10, [368] = 7, [369] = 2, [370] = 7, [371] = 8, [372] = 4, [373] = 8, [374] = 2, [375] = 2, [376] = 3, [377] = 1, [378] = 3, [379] = 2, [380] = 4, [381] = 1, [382] = 8, [383] = 3, [384] = 3, [385] = 3, [386] = 1, [387] = 1, [388] = 2, [389] = 2, [390] = 2, [391] = 1, [392] = 4, [393] = 13, [394] = 2, [395] = 8, [396] = 7, [397] = 2, [398] = 2, [399] = 4, [400] = 2, [401] = 1, [402] = 1, [403] = 3, [404] = 1, [405] = 1, [406] = 2, [407] = 2, [408] = 1, [409] = 1, [410] = 1, [411] = 9, [412] = 1, [413] = 3, [414] = 11, [415] = 6, [416] = 1, [417] = 2, [418] = 12, [419] = 4, [420] = 4, [421] = 1, [422] = 14, [423] = 2, [424] = 2, [425] = 2, [426] = 11, [427] = 4, [428] = 4, [429] = 1, [430] = 3, [431] = 2, [432] = 3, [433] = 11, [434] = 4, [435] = 3, [436] = 1, [437] = 3, [438] = 2, [439] = 3, [440] = 2, [441] = 2, [442] = 11, [443] = 4, [444] = 1, [445] = 6, [446] = 4, [447] = 2, [448] = 2, [449] = 1, [450] = 5, [451] = 4, [452] = 4, [453] = 1, [454] = 2, [455] = 1, [456] = 1, [457] = 7, [458] = 2, [459] = 3, [460] = 1, [461] = 8, [462] = 4, [463] = 1, [464] = 3, [465] = 1, [466] = 8, [467] = 1, [468] = 1, [469] = 2, [470] = 1, [471] = 3, [472] = 1, [473] = 1, [474] = 1, [475] = 1, [476] = 1, [477] = 1, [478] = 1, [479] = 1, [480] = 1, [481] = 1, [482] = 1, [483] = 1, [484] = 1, [485] = 1, [486] = 1, [487] = 1, [488] = 1, [489] = 1, [490] = 1, [491] = 2, [492] = 4, [493] = 10, [494] = 14, [495] = 1, [496] = 1, [497] = 3, [498] = 1, [499] = 3, [500] = 1, [501] = 2, [502] = 2, [503] = 3, [504] = 2, [505] = 2, [506] = 2, [507] = 2, [508] = 2, [509] = 2, [510] = 4, [511] = 1, [512] = 1, [513] = 1, [514] = 2, [515] = 1, [516] = 1, [517] = 4, [518] = 1, [519] = 1, [520] = 1, [521] = 1, [522] = 1, [523] = 1, [524] = 1, [525] = 1, [526] = 1, [527] = 1, [528] = 1, [529] = 1, [530] = 1, [531] = 1, [532] = 1, [533] = 1, [534] = 1, [535] = 1, [536] = 1, [537] = 1, [538] = 1, [539] = 1, [540] = 1, [541] = 1, [542] = 1, [543] = 1, [544] = 1, [545] = 1, [546] = 1, [547] = 1, [548] = 1, [549] = 1, [550] = 1, [551] = 1, [552] = 1, [553] = 1, [554] = 1, [555] = 1, [556] = 1, [557] = 1, [558] = 4}
opcodes = {[0xea] = 'ActLeagueBattlers', [0x2ac] = 'ActivateMysteryGift', [0x158] = 'ActivatePokedex', [0x133] = 'ActivatePoketchApp', [0x64] = 'AddPeople', [0x5e] = 'ApplyMovement', [0x2a1] = 'ApplyMovement2', [0x1d9] = 'BattleRoomResult', [0xcb] = 'BerryHiroAnimation', [0x1d7] = 'BerryPoffin', [0x2bf] = 'BikeRide', [0xab] = 'BoxPokemon', [0x1a] = 'Call', [0xa1] = 'CallEnd', [0x36] = 'CallMessageBox', [0x3a] = 'CallMessageBoxText', [0x14] = 'CallStandard', [0x29f] = 'CameraBumpEffect', [0xa9] = 'CapsuleEditor', [0x261] = 'CheckAccessories', [0x15b] = 'CheckBadge', [0xc7] = 'CheckBike', [0x252] = 'CheckBoxesNumber', [0x78] = 'CheckCoins', [0x12e] = 'CheckDress', [0x28f] = 'CheckFirstTimeChampion', [0x20] = 'CheckFlag', [0x11c] = 'CheckFloor', [0x1f1] = 'CheckFossil', [0x14d] = 'CheckGender', [0x1b9] = 'CheckHappiness', [0x7d] = 'CheckItem', [0xec] = 'CheckLost', [0x24e] = 'CheckLottoNumber', [0x71] = 'CheckMoney', [0x99] = 'CheckMove', [0x1e9] = 'CheckNationalPokedex', [0x177] = 'CheckPartyNumber', [0x19a] = 'CheckPartyNumber2', [0x6b] = 'CheckPersonPosition', [0x249] = 'CheckPhraseBoxInput', [0x9a] = 'CheckPlaceStored', [0x1c4] = 'CheckPokemonHeight', [0x1f6] = 'CheckPokemonLevel', [0x93] = 'CheckPokemonParty', [0x1c0] = 'CheckPokemonParty2', [0x228] = 'CheckPokemonTrade', [0x1bd] = 'CheckPosition', [0x1e8] = 'CheckSinnohPokedex', [0x69] = 'CheckSpritePosition', [0x7c] = 'CheckStoreItem', [0x225] = 'CheckTeachMove', [0x85] = 'CheckUndergroundPcStatus', [0x2c7] = 'CheckVersionGame', [0x2bc] = 'CheckWildBattle2', [0x29d] = 'ChoiceMulti', [0xf2] = 'ChooseFriend', [0xba] = 'ChoosePlayerName', [0x191] = 'ChoosePokemonMenu', [0x192] = 'ChoosePokemonMenu2', [0xbb] = 'ChoosePokemonName', [0xb4] = 'ChooseStarter', [0x2a5] = 'ChooseTradePokemon', [0x1e] = 'ClearFlag', [0x16c] = 'CloseDoor', [0x34] = 'CloseMessageOnKeyPress', [0x43] = 'CloseMulti', [0x24d] = 'ClosePcAnimation', [0x37] = 'ColorMessageBox', [0x1d] = 'CompareLastResultCall', [0x1c] = 'CompareLastResultJump', [0x24f] = 'CompareLottoNumber', [0x2aa] = 'ComparePhraseBoxInput', [0x1c3] = 'ComparePokemonHeight', [0x26] = 'CompareVarsToByte', [0x6c] = 'ContinueFollow', [0x1c1] = 'CopyPokemonHeight', [0x29] = 'CopyVar', [0x239] = 'DecideRules', [0x14b] = 'DefeatGoPokecenter', [0x1c9] = 'DeleteMove', [0x15d] = 'DisableBadge', [0xa8] = 'DisplayContestPokemon', [0xa7] = 'DisplayDressedPokemon', [0x347] = 'DisplayFloor', [0x2a0] = 'DoubleBattle', [0xac] = 'DrawUnion', [0xa6] = 'DressPokemon', [0x1ac] = 'EggAnimation', [0x259] = 'ElevLgAnimation', [0x15c] = 'EnableBadge', [0x2] = 'End', [0x112] = 'EndFlash', [0xb0] = 'EndGame', [0xe6] = 'EndTrainerBattle', [0x143] = 'ExpectDecisionOther', [0x126] = 'ExplanationBattle', [0x68] = 'FacePlayer', [0x4f] = 'FadeDefaultMusic', [0xbc] = 'FadeScreen', [0x111] = 'FlashContest', [0x2ca] = 'FloralClockAnimation', [0xc2] = 'FlyAnimation', [0x6d] = 'FollowHero', [0x35] = 'FreezeMessageBox', [0x205] = 'Geonet', [0x79] = 'GiveCoins', [0x97] = 'GiveEgg', [0x6f] = 'GiveMoney', [0x96] = 'GivePokemon', [0x131] = 'GivePoketch', [0x15a] = 'GiveRunningShoes', [0x206] = 'GreatMarshBynocule', [0xb1] = 'HallFameData', [0x14e] = 'HealPokemon', [0x23b] = 'HealPokemonAnimation', [0x29e] = 'HiddenMachineEffect', [0x295] = 'HideBattlePointsBox', [0x76] = 'HideCoins', [0x73] = 'HideMoney', [0x209] = 'HidePicture', [0x2c2] = 'HideSaveBox', [0x18e] = 'HideSavingClock', [0x127] = 'HoneyTreeBattle', [0x11] = 'If', [0x12] = 'If2', [0xa5] = 'Interview', [0x16] = 'Jump', [0x27a] = 'LeagueCastleView', [0x62] = 'Lock', [0x60] = 'LockAll', [0x66] = 'LockCam', [0xeb] = 'LostGoPokecenter', [0x1b3] = 'Mailbox', [0x3c] = 'Menu', [0x2c] = 'Message', [0x2d] = 'Message2', [0x2f] = 'Message3', [0x1c6] = 'MoveInfo', [0x40] = 'Multi', [0x41] = 'Multi2', [0x44] = 'Multi3', [0x48] = 'MultiRow', [0x39] = 'NoMapMessageBox', [0x0] = 'Nop', [0x1] = 'Nop1', [0xffff] = 'OpCode', [0x178] = 'OpenBerryPouch', [0x16b] = 'OpenDoor', [0x24c] = 'OpenPcAnimation', [0x243] = 'PhraseBox1W', [0x244] = 'PhraseBox2W', [0x4c] = 'PlayCry', [0x49] = 'PlayFanfare', [0x4a] = 'PlayFanfare2', [0x50] = 'PlayMusic', [0x4e] = 'PlaySound', [0x267] = 'Pokecasino', [0x147] = 'Pokemart', [0x148] = 'Pokemart1', [0x149] = 'Pokemart2', [0x14a] = 'Pokemart3', [0xf7] = 'PokemonContest', [0x195] = 'PokemonInfo', [0x28c] = 'PokemonPartyPicture', [0x208] = 'PokemonPicture', [0x328] = 'PortalEffect', [0x168] = 'PrepareDoorAnimation', [0x24b] = 'PreparePcAnimation', [0x129] = 'RandomBattle', [0x1b5] = 'RecordList', [0xaf] = 'RecordMixingUnion', [0x63] = 'Release', [0x61] = 'ReleaseAll', [0x189] = 'ReleaseOverworld', [0x221] = 'RememberMove', [0x65] = 'RemovePeople', [0xbd] = 'ResetScreen', [0x52] = 'RestartMusic', [0x258] = 'RetSprtSave', [0x1b] = 'Return', [0x3] = 'Return2', [0xc8] = 'RideBike', [0xbf] = 'RockClimbAnimation', [0x18b] = 'SetDoorLocked', [0x18a] = 'SetDoorPassable', [0x1f] = 'SetFlag', [0x188] = 'SetOverworldMovement', [0x186] = 'SetOverworldPosition', [0x95] = 'SetPokemonPartyStored', [0x120] = 'SetPositionAfterShip', [0x23] = 'SetValue', [0x28] = 'SetVar', [0xdd] = 'SetVarAlterStored', [0xdb] = 'SetVarHeroStored', [0xda] = 'SetVarPokemonStored', [0xdc] = 'SetVarRivalStored', [0xcf] = 'SetVariableAlter', [0xd4] = 'SetVariableAttack', [0xd3] = 'SetVariableAttackItem', [0xcd] = 'SetVariableHero', [0xd1] = 'SetVariableItem', [0xd6] = 'SetVariableNickname', [0xd5] = 'SetVariableNumber', [0xd7] = 'SetVariableObject', [0xd0] = 'SetVariablePokemon', [0x1c2] = 'SetVariablePokemonHeight', [0xce] = 'SetVariableRival', [0xd8] = 'SetVariableTrainer', [0x23d] = 'ShipAnimation', [0x294] = 'ShowBattlePointsBox', [0x75] = 'ShowCoins', [0x116] = 'ShowLinkCountRecord', [0x72] = 'ShowMoney', [0x1eb] = 'ShowNationalSheet', [0x2c1] = 'ShowSaveBox', [0x18d] = 'ShowSavingClock', [0x1ea] = 'ShowSinnohSheet', [0xaa] = 'SinnohMaps', [0x2c6] = 'SpinTradeUnion', [0x257] = 'SprtSave', [0x125] = 'StarterBattle', [0xcc] = 'StopBerryHiroAnimation', [0x6e] = 'StopFollowHero', [0x51] = 'StopMusic', [0x22a] = 'StopTrade', [0x1c7] = 'StoreMove', [0x193] = 'StorePokemonMenu2', [0x198] = 'StorePokemonNumber', [0x94] = 'StorePokemonParty', [0x134] = 'StorePoketchApp', [0xde] = 'StoreStarter', [0xc0] = 'SurfAnimation', [0x54] = 'SwitchMusic', [0x5a] = 'SwitchMusic2', [0x7a] = 'TakeCoins', [0x7b] = 'TakeItem', [0x70] = 'TakeMoney', [0x224] = 'TeachMove', [0x46] = 'TextMessageScriptMulti', [0x42] = 'TextScriptMulti', [0x271] = 'ThankNameInsert', [0x229] = 'TradeChosenPokemon', [0xae] = 'TradeUnion', [0xe5] = 'TrainerBattle', [0xad] = 'TrainerCaseUnion', [0xc6] = 'Tuxedo', [0x38] = 'TypeMessageBox', [0x153] = 'UnionRoom', [0x26d] = 'UnownMessageBox', [0x77] = 'UpdateCoins', [0x74] = 'UpdateMoney', [0xa3] = 'WFC', [0xb3] = 'WFC1', [0x169] = 'WaitAction', [0x31] = 'WaitButton', [0x16a] = 'WaitClose', [0x4d] = 'WaitCry', [0x4b] = 'WaitFanfare', [0x3f] = 'WaitFor', [0x5f] = 'WaitMovement', [0xbe] = 'Warp', [0x204] = 'WarpLastElevator', [0x11b] = 'WarpMapElevator', [0xc1] = 'WaterfallAnimation', [0x124] = 'WildBattle', [0x2bd] = 'WildBattle2', [0xf3] = 'WirelessBattleWait', [0x12b] = 'WriteAutograph', [0x3e] = 'YesNoBox'}
img = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x10, 0x3c, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xf8, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x0, 0x0, 0x0, 0x11, 0x7f, 0xff, 0xff, 0xe7, 0x0, 0x0, 0x0, 0x0, 0xc3, 0xc7, 0xcf, 0xcf, 0x0, 0x0, 0x0, 0xe0, 0xf8, 0xfc, 0xf9, 0x11, 0x0, 0x0, 0x0, 0x1e, 0x7f, 0xff, 0xff, 0xe3, 0x0, 0x0, 0x0, 0x0, 0x0, 0x80, 0xc0, 0xc0, 0x0, 0x0, 0x0, 0x30, 0x71, 0x7b, 0x7f, 0x7f, 0x0, 0x0, 0x0, 0x86, 0xcf, 0xef, 0xff, 0xfe, 0x3c, 0x3c, 0x3c, 0x3d, 0x3f, 0x3f, 0x3f, 0x3e, 0x0, 0x0, 0x0, 0x80, 0xe0, 0xf0, 0xf9, 0x79, 0x0, 0x0, 0x0, 0x1e, 0x7f, 0xff, 0xff, 0xe3, 0x0, 0x0, 0x0, 0xc, 0x1f, 0x9f, 0xdf, 0xde, 0x0, 0x0, 0x0, 0xc0, 0xf0, 0xf8, 0xfc, 0x3c, 0x1, 0x3, 0x3, 0x3, 0x0, 0x0, 0x0, 0x0, 0xfc, 0xfe, 0xde, 0x8f, 0x1e, 0x3e, 0x7c, 0x78, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x1, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0xe3, 0xe7, 0xff, 0xff, 0xff, 0x3f, 0x0, 0x0, 0xcf, 0xdf, 0xcf, 0xc7, 0xc7, 0x81, 0x0, 0x0, 0x1, 0x3, 0xf9, 0xf9, 0xf8, 0xf0, 0x0, 0x0, 0xff, 0xff, 0xe0, 0xff, 0xff, 0x7f, 0x0, 0x0, 0x80, 0x80, 0x0, 0x80, 0x80, 0x80, 0x0, 0x0, 0x3f, 0x3f, 0x1f, 0x1f, 0xf, 0xe, 0x0, 0x0, 0xfe, 0xfc, 0xfc, 0x7c, 0x78, 0x38, 0x0, 0x0, 0x3c, 0x3c, 0x3c, 0x3c, 0x3c, 0x3c, 0x0, 0x0, 0x79, 0x79, 0x79, 0x79, 0x78, 0x78, 0x0, 0x0, 0xff, 0xff, 0xe0, 0xff, 0xff, 0x7f, 0x0, 0x0, 0x9e, 0x9e, 0x1e, 0x9e, 0x9e, 0x9e, 0x0, 0x0, 0x3c, 0x3c, 0x3c, 0x3c, 0x3c, 0x3c, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x70, 0x0, 0x70, 0xf8, 0x78, 0x70, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0}
steps_data = {
    [1] = 11,
    [2] = 7,
    [3] = 3
}
------------------------

DebugOffs = 0x0
ver = memory.readdword(0x023FFE0C)
if ver == 0 then
	ver = memory.readdword(0x027FFE0C)
end
id = bit.band(ver, 0xFF)
lang = bit.band(bit.rshift(ver, 24), 0xFF)
base_addr = 0

if id == 0x59 then                                     -- Pokemon D/P Demo
	if     lang == 0x45 then base_addr = 0x02106BAC    -- US / EU
	OffsArray = {0x1454,0x24AA4,0x23CC4,0x24BC0,0x248F0,
				0x75F4,0x23CBC,0x23CB8,0x22ADA,0x3E924,
				0x1384,0x57708,0x229F0,0x22A20}	
	AddrArray = {0x2056C06, 0x223C1F4}
	LanguageArray = {0x102}
	end
end

if id == 0x41 then										-- Pokemon D/P
	OffsArray = {0x1454,0x24AA4,0x23CC4,0x24BC0,0x248F0,
				0x75F4,0x23CBC,0x23CB8,0x22ADA,0x3E924,
				0x1384,0x57708,0x229F0,0x22A20}	
	AddrArray = {0x2056C06, 0x223C1F4} 
	LanguageArray = {0x00}
	
	if     lang == 0x44 then base_addr = 0x02107100    -- DE
	LanguageArray = {0x70}
	elseif lang == 0x45 then base_addr = 0x02106FC0    -- US / EU
	elseif lang == 0x46 then base_addr = 0x02107140    -- FR
	LanguageArray = {0x70}
	elseif lang == 0x49 then base_addr = 0x021070A0    -- IT
	LanguageArray = {0x70}
	elseif lang == 0x4A then 
	
	if memory.readword(0x23FFE2C) == 0xB8 then base_addr = 0x211F988 --Pokemon DP Debug
	DebugOffs = 0x4000
	else base_addr = 0x02108818   -- JP
	LanguageArray = {0x27DA}
	end 
	
	elseif lang == 0x4B then base_addr = 0x021045C0    -- KS
	elseif lang == 0x53 then base_addr = 0x02107160    -- ES
	LanguageArray = {0x70}
	end

	elseif id == 0x43 then 							 	-- Pokemon Pt
	OffsArray = {0x129C,0x238EC,0x22AE8,0x23A08,0x23738,
				0x8087,0x22AE0,0x22ADC,0x218FE,0x3D734,
				0x1198,0x0,0x21804}
	AddrArray = {0x2060C20,0x224a75c} 
	LanguageArray = {0x00}
	if     lang == 0x44 then base_addr = 0x02101EE0    -- DE
	LanguageArray = {0xA4}
	elseif lang == 0x45 then base_addr = 0x02101D40    -- US / EU
	elseif lang == 0x46 then base_addr = 0x02101F20    -- FR
	LanguageArray = {0xA4}
	elseif lang == 0x49 then base_addr = 0x02101EA0    -- IT
	LanguageArray = {0xA4}
	elseif lang == 0x4A then base_addr = 0x02101140    -- JP
	LanguageArray = {-0x738}
	elseif lang == 0x4B then base_addr = 0x02102C40    -- KS
	elseif lang == 0x53 then base_addr = 0x02101F40    -- ES
	LanguageArray = {0xA4}
	end

elseif id == 0x49 then									-- Pokemon HG/SS CFe0
	OffsArray = {0x124C,0x25DF0,0x25158,0x2603C,0x25C3C,
				0x6919,0x25150,0x2514C,0x24166,0x3FF30,
				0x0,0x0,0x24014}
	AddrArray = {0x205DAA2,} 
	LanguageArray = {0x00}
	if     lang == 0x44 then base_addr = 0x02111860    -- DE
	elseif lang == 0x45 then base_addr = 0x02111880    -- US / EU
	elseif lang == 0x46 then base_addr = 0x021118A0    -- FR
	elseif lang == 0x49 then base_addr = 0x02111820    -- IT
	elseif lang == 0x4A then base_addr = 0x02110DC0    -- JP
	elseif lang == 0x4B then base_addr = 0x02112280    -- KS
	elseif lang == 0x53 then base_addr = 0x021118C0    -- ES
	end
end 

---------------------------
local CollisionId = {
    Custom = {
        color = '#f7bbf3',
        number = {}
    },
	RandomObj = {
        color = 'white',
        number = {0xE5,0X8E,0X8f}
    },
    Grass = {
        color = '#40a',
        number = {0x2}
    },
	Trees = {
        color = '#CCCCC',
        number = {0x6}
    },
    TallGrass = {
        color = '#2aa615',
        number = {0x3}		
	},
    Cave = {
        color = '#a070006',
        number = {0x8,0xC}
	},
	Spinners = {
        color = '#ffd',
        number = {0x40,0x41,0x42,0x43}
    },
	icestair = {
        color = '#ffd',
        number = {0x49,0x4A}
    },
	Warps = {
        color = '#f03',
        number ={0x5E,0x5f,0x62,0x63,0x69,0x65,0x6f,0x6D,0x6A,0x6C,0x6E}
	},
	CircleWarps = {
        color = '#a0a',
        number = {0x67}
    },
	Modelfl = {
        color = '#afb',
       number = {0x56,0x57,0x58,} 
    },
	ModelFloor = {
        color = '#a090f',
       number = {0x59}
    },
	OnesidedWall = {
        color = '#a090f',
       number = {0x30,0x31,0x32,0x33}
    },
	Bikestalls = {
        color = '#0690a',
       number = {0xDB}
    },
	Counter = {
        color = '#f7a',
        number = {0x80}
    },
	PC = {
       color = '#0690b',
       number = {0x83}
    },
	Map = {
       color = '#00eee',
       number = {0x85}
    },
	TV = {
       color = '#4290e',
       number = {0x86}
    },
	Bookcases = {
        color = '#0ddd7',
        number = {0x88,0xE1,0xE0,0xE2}
    },
	Bin = {
        color = '#06b04',
       number = {0xE4}
	},
    HauntedHouse = {
        color = '#A292BC',
        number = {0xB}
    },
    Water = {
        color = '#8888f06',
        number = {0x10,0x13,0x15,0x16,0x17,0x22}
    },
    Ice = {
        color = '#56b3e0',
        number = {0x20,0x20}
    },
    Sand = {
        color = '#e3c',
        number = {0x21,0x21}
	},
    Ledge = {
        color = '#D3A',
        number = {0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F}
    },
    RockClimb = {
        color = '#C76',
        number = {0x4B,0x4C}
    },
    Bridge = {
        color = '#C79',
        number = {0x70,0x71,0x72,0x73,0x74,0x75,}
	},
    BridgeBike = {
        color = '#C7A55',
        number = {0x76,0x77,0x78,0x79,0x7A,0x7B,0x7C,0x7D}
	},
    Berrysoil = {
        color = '#b2703',
        number = {0xA0}
    },
    SnowSlow = {
        color = '#8da9cb',
        number = {0xA1}
    },
    Snow2xSlow = {
        color = '#6483a7',
        number = {0xA2}
    },
    Snow3xslow = {
        color = '#52749d',
        number = {0xA3}
	},
    Mud = {
        color = '#92897',
        number = {0xA4}
    },
    StuckMud = {
        color = '#92704',
        number = {0xA5}
    },
    GrassMud = {
        color = '#4090',
        number = {0xA6}
    },
    GrassMudStuck = {
        color = '#55906',
        number = {0xA7}
	},
    Snow = {
        color = '#b9d0eb',
        number = {0xA8}
	},
    BikeRamp = {
        color = '#B890',
        number = {0xD7,0xD8}
	},
    Quicksand = {
        color = '#A880',
        number = {0xD9,0xDA}
    },
    Normal = {
        color = '#8888a06',
        number = {}
    }
}

---------------------------


local base = memory.readdword(base_addr) 
local cursor = 1
local fasttoggle = true

if id == 0x41 or id == 0x43 then 
customwarpid = 510 --id of map to fly to when selecting 'FlyOptionId' 
				   --set to '3' for overworld.
customwarpx = 32
customwarpy = 34
FlyOptionId = 0x41 -- location that you want to fly to to activate warp. (default = Eterna, 0x41)

elseif id == 0x49 then
customwarpid = 2 --id of map to fly to when selecting 'FlyOptionId'
				   --set to '20' for overworld.
customwarpx = 10
customwarpy = 10 
FlyOptionId = 0x3C -- location that you want to fly to to activate warp.(default = New Bark, 0x3C)
end 

displayoffsx = {0,128,0,128}
displayoffsy = {0,0,96,96}

displayoffsxbt = {0,64,128,192,0,64,128,192,0,64,128,192,0,64,128,192}
displayoffsybt = {0,0,0,0,48,48,48,48,96,96,96,96,144,144,144,144}

debugger = false

local retireclr = '#00f0f'

local mapAddrOffset = OffsArray[9]

local map_box
local menu_box
local mapcontrol_box

local mode = 1
local mode_str = {
	"BottomScr",
	"TopScreen",
}
local max_cols = 0
local max_rows = 0

local map = {}

local x_position = 0
local y_position = 0

local map_centered = true
local menu1_opened = false
local menu2_opened = false
local x_paint = 0
local y_paint = 0

local tabl={}
local prev={}
local viewmode = 1 --default menu
Bigmap = true --press shift and B to swap ingame; 
------------------------------------------
local LiveMapIdOffs = OffsArray[1] - 0x8
local curptrmap = base + LiveMapIdOffs

local XPositionAddrOffset = OffsArray[1] 
local YPositionAddrOffset = OffsArray[1] + 0x4

local teleportX = OffsArray[2] -0xC 
local teleportXmov = OffsArray[2] +0x2
local teleportY = OffsArray[2] -0x4
local teleportYmov = OffsArray[2] + 0xA

local movementXAddrOffset = OffsArray[2] 
local movementYAddrOffset = OffsArray[2] + 0x8

local stepamountAddr = OffsArray[11]

local XPos = {0,0,0,0,0,0}
local YPos = {0,0,0,0,0,0}
local movementX = {0,0,0,0,0,0}
local movementY = {0,0,0,0,0,0}

local bnd,br,bxr=bit.band,bit.bor,bit.bxor
local rshift, lshift=bit.rshift, bit.lshift

keybinds = {
    switch_mode = "space",
    inject_code = "T",
    reset_search = "backspace",
    clear_ram = "R",
    udlr = { "up", "down", "left", "right" },
    pgup = "pageup",
    pgdown = "pagedown",
    increase = "plus",
    decrease = "minus",
    script_dump = "DO_NOT_USE"
}

cwidth = 14  -- default: 14
cheight = 16  -- default: 16

local Loadlines_view = false
local Grid_view = false
local CustomWarp = false
local Map = false 
local InfRepel = false
local Trigger = false 
local NPC = false
local Item = false
local Warp = false
local WTW = false

local PerfectCatch= false
local teleport1 = true 
local mapediting = false
local demostop = true
local flycursor = false
local Collision = false 
local chunkediting = false
local collisionediting = false 
local hex_view = false
local showid = false
local temps10 = false

local Mapborder_view = false
local Chunkborder_view = false
local temps13 = false
local temps14 = false
local temps15 = false

local CustomWarp0 = true 
-------------------------------
characterlist = {"/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/",
				 "/","/","/","/","/","/","/","/","/","/","/","/","0","1","2","3","4","5","6","7",
				 "8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R",
				 "S","T","U","V","W","X","Y","Z","a","b","c","d","e","f","g","h","i","j","k","l",
				 "m","n","o","p","q","r","s","t","u","v","w","x","y","z","A.","A.","A.","A.","A.","A.",
				 "AE","C.","E.","E.","E.","E.","I.","I.","I.","I.","D.","N.","O.","O.","O.","O.","O.",
				 "X.","O.","U.","U.","e.","i.","i.","i.","i.","a.","a.","a.","a.","a.","a.","ae","c.",
				 "e.","e.","e.","e.","i.","i.","i.","i.","a.","n.","o","o","o","o","o","%","o.","u",
				 "u","u","u","y.","|P","y.","OE","oe","S.","s.","a","o","er","re","r","P.","i.","?","!",
				 "?",",",".","...",".^","/","'","'","''","''",",,","<<",">>","(",")","Mr","Ms","+","-",
				 "*","#","=","~",":",";","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/","/",
				 "/","/","/","/","/","/","/","/"," ","e^"}
----------------------------------------------
function drawarrowleft(a,b,c)
	gui.line(a,b+3,a+2,b+5,c)
	gui.line(a,b+3,a+2,b+1,c)
	gui.line(a,b+3,a+6,b+3,c)
end
function drawarrowright(a,b,c)
	gui.line(a,b+3,a-2,b+5,c)
	gui.line(a,b+3,a-2,b+1,c)
	gui.line(a,b+3,a-6,b+3,c)
end
function drawarrowdown(a,b,c)
	gui.line(a,b,a-2,b-2,c)
	gui.line(a,b,a+2,b-2,c)
	gui.line(a,b,a,b-6,c)
end
function drawarrowup(a,b,c)
	gui.line(a,b,a-2,b+2,c)
	gui.line(a,b,a+2,b+2,c)
	gui.line(a,b,a,b+6,c)
end
function drawsquare(a,b,c,d)
	gui.box(a,b,a+4,b+4,c,d)
end

function drawsmallsquare(a,b,c,d)
	gui.box(a,b,a+3,b+1,c,d)
end

function drawvsmallsquare(a,b,c,d)
	gui.box(a,b,a+1,b,c,d)
end

function drawbigsquare(a,b,c,d)
	gui.box(a,b,a+14,b+8,c,d)
end

function isCoordInBox(x, y, box)
	return (x >= box[1] and x <= box[3] and y >= box[2] and y <= box[4])
end

function updateTab()
	tabl = input.get()
	if tabl['leftclick'] and not prev['leftclick'] or tabl['rightclick']then
	--if tabl['leftclick'] and Fasttogle == false and not prev['leftclick'] then
		x = tabl['xmouse']
		y = tabl['ymouse']
		
		-- Menu Mode --
		if isCoordInBox(x, y, {menu_box[3] - 84, menu_box[2], menu_box[3] - 72, menu_box[4]}) then
			mode = (mode - 2) % 2 + 1
		elseif isCoordInBox(x, y, {menu_box[3] - 12, menu_box[2], menu_box[3], menu_box[4]}) then
			mode = mode % 2 + 1
		end
		
		if tabl['shift'] then 
		moveval = 10
		else 
		moveval = 2
		end
		
		-- Moving Map --
		if not map_centered then
			if isCoordInBox(x, y, {menu_box[1] + 2, menu_box[2] + 28, menu_box[1] + 15, menu_box[2] + 42}) then
				x_paint = x_paint - moveval/2
			elseif isCoordInBox(x, y, {menu_box[1] + 29, menu_box[2] + 28, menu_box[1] + 42, menu_box[2] + 42}) then
				x_paint = x_paint + moveval/2
			elseif isCoordInBox(x, y, {menu_box[1] + 16, menu_box[2] + 15, menu_box[1] + 28, menu_box[2] + 29}) then
				y_paint = y_paint - moveval
			elseif isCoordInBox(x, y, {menu_box[1] + 16, menu_box[2] + 41, menu_box[1] + 28, menu_box[2] + 55}) then
				y_paint = y_paint + moveval
			end
		end
		
		-- Centered --
		if isCoordInBox(x, y, {menu_box[1] + 2, menu_box[2] + 57, 42, menu_box[2] + 69}) then
			map_centered = not map_centered
		end
		
		-- Menu open --
		if isCoordInBox(x, y, {menu_box[1] + 2, menu_box[2] + 178, menu_box[1] + 42, menu_box[2] + 190}) then
			menu1_opened = not menu1_opened
			menu2_opened = false 
		end
		
		if isCoordInBox(x, y, {menu_box[1] + 52, menu_box[2] + 178, menu_box[1] + 92, menu_box[2] + 190}) then
			menu2_opened = not menu2_opened
			menu1_opened = false 
		end
		
		-- Menu--
		if menu1_opened then
			if isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 78, menu_box[1] + 17, menu_box[2] + 90}) then
				Loadlines_view = not Loadlines_view
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 98, menu_box[1] + 17, menu_box[2] + 110}) then
				Grid_view = not Grid_view
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 118, menu_box[1] + 17, menu_box[2] + 130}) then
				CustomWarp = not CustomWarp
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 138, menu_box[1] + 17, menu_box[2] + 150}) then
				Map = not Map
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 158, menu_box[1] + 17, menu_box[2] + 170}) then
				InfRepel = not InfRepel
			-------------------------------------------row2
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 78, menu_box[1] + 97, menu_box[2] + 90}) then
				Trigger = not Trigger
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 98, menu_box[1] + 97, menu_box[2] + 110}) then
				NPC = not NPC
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 118, menu_box[1] + 97, menu_box[2] + 130}) then
				Item = not Item
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 138, menu_box[1] + 97, menu_box[2] + 150}) then
				Warp = not Warp
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 158, menu_box[1] + 97, menu_box[2] + 170}) then
				WTW = not WTW
				
			end
		end
			
		if menu2_opened then
			if isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 78, menu_box[1] + 17, menu_box[2] + 90}) then
				PerfectCatch= not PerfectCatch
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 98, menu_box[1] + 17, menu_box[2] + 110}) then
				teleport1 = not teleport1
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 118, menu_box[1] + 17, menu_box[2] + 130}) then
				mapediting = not mapediting
				teleport1 = false 
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 138, menu_box[1] + 17, menu_box[2] + 150}) then
				demostop = not demostop
			elseif isCoordInBox(x, y, {menu_box[1] + 5, menu_box[2] + 158, menu_box[1] + 17, menu_box[2] + 170}) then
				flycursor = not flycursor
			-------------------------------------------row2
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 78, menu_box[1] + 97, menu_box[2] + 90}) then
				Collision = not Collision
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 98, menu_box[1] + 97, menu_box[2] + 110}) then
				chunkediting = not chunkediting
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 118, menu_box[1] + 97, menu_box[2] + 130}) then
				hex_view = not hex_view
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 138, menu_box[1] + 97, menu_box[2] + 150}) then
				showid = not showid
			elseif isCoordInBox(x, y, {menu_box[1] + 85, menu_box[2] + 158, menu_box[1] + 97, menu_box[2] + 170}) then
				temps10 = not temps10
			-------------------------------------------row3
			elseif isCoordInBox(x, y, {menu_box[1] + 165, menu_box[2] + 78, menu_box[1] + 177, menu_box[2] + 90}) then
				Mapborder_view = not Mapborder_view
			elseif isCoordInBox(x, y, {menu_box[1] + 165, menu_box[2] + 98, menu_box[1] + 177, menu_box[2] + 110}) then
				Chunkborder_view = not Chunkborder_view
			elseif isCoordInBox(x, y, {menu_box[1] + 165, menu_box[2] + 118, menu_box[1] + 177, menu_box[2] + 130}) then
				temps13 = not temps13
			elseif isCoordInBox(x, y, {menu_box[1] + 165, menu_box[2] + 138, menu_box[1] + 177, menu_box[2] + 150}) then
				temps14 = not temps14
			elseif isCoordInBox(x, y, {menu_box[1] + 165, menu_box[2] + 158, menu_box[1] + 177, menu_box[2] + 170}) then
				temps15 = not temps15
				
			end
		end
	end
	prev = tabl
end

function printTopMenu()
	gui.box(menu_box[1], menu_box[2], menu_box[3], menu_box[4], "#00000090")
	gui.box(menu_box[3] - 12, menu_box[2], menu_box[3], menu_box[4], "#000000CC")
	gui.box(menu_box[3] - 84, menu_box[2], menu_box[3] - 72, menu_box[4], "#000000CC")
	drawarrowleft(menu_box[3] - 81, menu_box[2] + 2, '#FFF282')
	drawarrowright(menu_box[3] - 3, menu_box[2] + 2, '#FFF282')
	gui.text(menu_box[3] - 68, menu_box[2] + 2, mode_str[mode],'white')
end

function printMapControl()
	if map_centered then
	mapclr = '#666666cc'
	mapbclr = "#00006633"
	mapbclr2 = "#00006655"
	
		gui.box(menu_box[1] + 2, menu_box[2] + 57, menu_box[1] + 42, menu_box[2] + 69, "#00006633", "#00006655")
		gui.text(menu_box[1] + 5, menu_box[2] + 60,"CENTER", '#FFF282')
	else
	mapclr = 'yellow'
	mapbclr = "#00000090"
	mapbclr2 = "#00000090"
		
		gui.box(menu_box[1] + 2, menu_box[2] + 57, menu_box[1] + 42, menu_box[2] + 69, "#00000090")
		gui.text(menu_box[1] + 5, menu_box[2] + 60,"MANUAL", "yellow")
	end
		gui.box(menu_box[1] + 2,menu_box[2] + 15, menu_box[1] + 42, menu_box[2] + 55, mapbclr, mapbclr2)
		drawarrowleft(menu_box[1] + 5,menu_box[2] + 32, mapclr)
		drawarrowright(menu_box[1] + 39,menu_box[2] + 32, mapclr)
		drawarrowup(menu_box[1] + 22,menu_box[2] + 19, mapclr)
		drawarrowdown(menu_box[1] + 22,menu_box[2] + 50, mapclr)
end


function printSettingsMenu1()
    if menu1_opened or menu2_opened then
        gui.box(menu_box[1] + 2, menu_box[2] + 75, menu_box[3] - 4, menu_box[2] + 190, "#15928280")
            
        activated_clr = "#ffffffbb"
        deactivated_clr = "#00000055"
        clr = {}
        if menu1_opened then
            addresses_bool = {Loadlines_view,Grid_view,CustomWarp,Map,InfRepel,Trigger,NPC,Item,Warp,WTW}
            addresses_names = {"Loadlines","Grid","CustomWarp","Map","InfRepel","Trigger","NPC","Item","Warp","WTW"}
        else
            addresses_bool = {PerfectCatch,teleport1,mapediting,demostop,flycursor,Collision,chunkediting,hex_view,showid,temps10,
                                Mapborder_view,Chunkborder_view,temps13,temps14,temps15}
            addresses_names = {"100% catch","Teleport","Map Editor","Stoptimer","Flycursor","Collision","Chunk Edit.","Hex","Show ID","temps10",
                                "Map Border","Chunk Border","temps13","temps14","temps15"}
        end

        for i = 1,#(addresses_names) do
            if addresses_bool[i] then
                    clr[i] = activated_clr
            else
                    clr[i] = deactivated_clr
            end
        end
    
        for j = 0,(#(addresses_names)/5)-1 do
            for i = 0,4 do
                gui.box(menu_box[1] + 5 +j*80, menu_box[2] + 78 + 20*i, menu_box[1] + 17+j*80, menu_box[2] + 90 + 20*i, clr[i+1+j*5], "#ffffffff")
                gui.text(menu_box[1] + 21 +j*80, menu_box[2] + 81 + 20*i, addresses_names[i+1+j*5])
            end 
        end 

        if menu1_opened then
        i = 0
            for k,v in pairs(mapId) do
                drawsquare(menu_box[3] - 78, menu_box[2] + 81 + i, mapId[k]['color'])
                gui.text(menu_box[3] - 70, menu_box[2] + 80 + i, k, '#bbffffcc')
                i = i + 10
            end 
        end 
    end 
    gui.box(menu_box[1] + 2, menu_box[2] + 178, menu_box[1] + 42, menu_box[2] + 189, "#00006633", "#00006655")
    aux = "MENU "
        
    if menu1_opened then
        aux = "CLOSE "
    end

        gui.box(menu_box[1] + 52, menu_box[2] + 178, menu_box[1] + 92, menu_box[2] + 189, "#00006633", "#00006655")
        aux2 = "MENU "
        if menu2_opened then
            aux2 = "CLOSE "
        end
        gui.text(menu_box[1] + 4, menu_box[2] + 181, aux, "yellow")
        gui.text(menu_box[1] + 54, menu_box[2] + 181, aux2, "yellow")
end

function get_map_tile_color(maptile)
	if maptile > 558 then
		return mapId['Jubilife']['color']
	else
		for k,v in pairs(mapId) do
			for i=1,#mapId[k]['number'] do
				if mapId[k]['number'][i] == maptile then 
					return mapId[k]['color']
				end
			end
		end
	end
	return mapId['Normal']['color']
end 

function get_tile_color(maptile)
    if collisiontile%256 == 0xff then
	    return CollisionId['Normal']['color']
    end
    
    if collisiontile%256 == 0 then
	    if collisiontile >= 0x8000 then 
		    return '#CCCCC' 
		else 
		    return CollisionId['Normal']['color']
		end
	else 
		for k,v in pairs(CollisionId) do
			for i=1,#CollisionId[k]['number'] do
                if CollisionId[k]['number'][i] == collisiontile%256 then
                    return CollisionId[k]['color']
                end
			end
		end
	end
	
	--if debugtiledata then 
	--print("Warning!! unknown tile! ID:",fmt2(collisiontile)) --debug
	--debugtiledata = false
	--end
	
	return CollisionId['Normal']['color']
end  
	
function printMap()
	if Map then 
	gui.box(map_box[1], map_box[2], map_box[3], map_box[4], "#00000080")
	
	if map_centered == true then
		x_paint = map_x_pos - math.floor(max_cols / 2)
		y_paint = map_y_pos - math.floor(max_rows / 2)
	end
	
	if x_paint < 0 or max_cols == maplayoutv then
		x_paint = 0
	elseif x_paint > maplayoutv - max_cols then
		x_paint = maplayoutv - max_cols
	end
	
	for i = x_paint, x_paint + max_cols - 1, 1 do
	for j = y_paint, y_paint + max_rows - 1, 1 do
		maptile = memory.readword(pointer + mapAddrOffset + 2 * i + maplayoutv*2*j)
		color = get_map_tile_color(maptile)
		if (i == map_x_pos and j == map_y_pos) then
			gui.text(92,-190,("cur:")..bit.tohex(pointer+mapAddrOffset + 2*i + maplayoutv*2*j),'yellow')
			color = 'white'
		end
		if mode == 3 then
			drawsquare(2 + 4*(i-x_paint) + map_box[1], 2 + 4*(j-y_paint) + map_box[2], color, '#00000055')
		elseif hex_view then
			gui.text((i-x_paint)*25 + 4 + map_box[1],(j-y_paint) * 10 + 3 + map_box[2],bit.tohex(maptile, 4), color)
		else
			if maptile > 999 then
				maptile = '>999'
			end
			gui.text((i-x_paint)*25 + 4 + map_box[1],(j-y_paint) * 10 + 3 + map_box[2], maptile, color)
			end 
			
	end
	end 
	
	elseif flycursor then 
	if id == 0x41 then
		if map_centered == true then
		x_paint = flycux - math.floor(max_cols / 2)
		y_paint = flycuy- math.floor(max_rows / 2)
		end
	
		if x_paint < 0 or max_cols == maplayoutv then
		x_paint = 0
		elseif x_paint > maplayoutv - max_cols then
		x_paint = maplayoutv - max_cols
		end
	
	for i = x_paint, x_paint + max_cols - 1, 1 do
	for j = y_paint, y_paint + max_rows - 1, 1 do
		maptile = memory.readword(pointer + 0x42C30 + 2 * i + maplayoutv*2*j)
		color = get_map_tile_color(maptile)
		if (i == flycux and j == flycuy) then
			gui.text(92,-190,("cur:")..bit.tohex(base + 0x42C30 + 2*i + maplayoutv*2*j),'yellow')
			color = 'white'
		end
		if mode == 3 then
			drawsquare(2 + 4*(i-x_paint) + map_box[1], 2 + 4*(j-y_paint) + map_box[2], color, '#00000055')
		elseif hex_view then
			gui.text((i-x_paint)*25 + 4 + map_box[1],(j-y_paint) * 10 + 3 + map_box[2],bit.tohex(maptile, 4), color)
		else
			if maptile > 999 then
				maptile = '>999'
			end
			gui.text((i-x_paint)*25 + 4 + map_box[1],(j-y_paint) * 10 + 3 + map_box[2], maptile, color)
			end 
		end 
		end	
	end 		
end 
end 

function textgui()
	gui.text(menu_box[1] + 3, menu_box[2] + 2, "Base: " .. bit.tohex(base),'yellow')
	gui.text(menu_box[1] + 50, menu_box[2] + 18, "X: "..(Xpostrackerx )..","..fmt4(Xpostrackerx ),'yellow')
	gui.text(menu_box[1] + 50, menu_box[2] + 28, "Y: "..(Ypostrackery)..","..fmt4(Ypostrackery),'yellow')
	
	if mapediting then
	mapcolor = 'red'
	else 
	mapcolor = 'yellow'
	end 
	
	if customjump then
	jumpcolor = 'red'
	else 
	jumpcolor = 'yellow'
	end 
	
	if collisionediting then
	collisioncolor = 'red'
	else 
	collisioncolor = 'yellow'
	end 
	gui.text(menu_box[1] + 50, menu_box[2] + 38, "Map: "..(LiveMapId)..","..fmt4(LiveMapId),mapcolor)
	gui.text(menu_box[1] + 50, menu_box[2] + 48, "Jump: "..(jump),jumpcolor)
	gui.text(menu_box[1] + 140, menu_box[2] + 48, "Stepctr: "..(stepamount)..","..fmt4(stepamount),'yellow')
	gui.text(menu_box[1] + 140, menu_box[2] + 38, "Tile: "..(tilename[currenttile+1])..","..fmt2(currenttile),'yellow')
	--gui.text(menu_box[1] + 50, menu_box[2] + 58, "Chunk: "..(CurrentChunkv)..","..fmt2(CurrentChunkv),collisioncolor)
	--gui.text(menu_box[1] + 95, menu_box[2] + 2, (Repelsteps),'yellow')
end


function updateLayout()
	if mode == 1 then
		menu_box = {0, -192, 256, -181}
		map_box = {0, 0, 256, 192}
		max_rows = 19
		max_cols = 10
	elseif mode == 2 then
		menu_box = {0, 0, 256, 11}
		map_box = {0, -192, 256, 0}
		max_rows = 19
		max_cols = 10
	end
end

function drawLoadLines()
	if key.shift then
	 	if check_key("L") then 
		Loadlines_view = not Loadlines_view
		end
		if check_key("G") then 
		Grid_view = not Grid_view
		end
		if check_key("K") then 
		Mapborder_view	= not Mapborder_view
		end 
		if check_key("H") then 
		Chunkborder_view	= not Chunkborder_view
		end
	end 
	xmiddle = 128
	ystart = menu_box[2]
	xstartLoop = -111 - rshift(movementX[1],12)
	yend = 200
	xloadX = -(XPos[1] % 32) + 23
	xloadY = -(YPos[1] % 32) + 25

	xbordX = -(X32bit % 32) + 23
	xbordY = -(Y32bit % 32) + 25
	if NPC == true then
	gui.box(129 - rshift(movementX[1],12),-81 - rshift(movementY[1],12),144 - rshift(movementX[1],12),-95 - rshift(movementY[1],12), "#88FFFFA0", "#0FB58")
	end
	
	if X32bit > 0x7FFFFFFF then 
	negativeoffy = 0
	negativeoffx = 1
	else 
	negativeoffy = 0
	negativeoffx = 0
	end 
	
	if Y32bit > 0x7FFFFFFF then 
	negativeoffy = negativeoffy+1
	else 
	negativeoffy = 0
	end
	
	for i = -1,15,1 do
		if Grid_view then 
		gui.line((xstartLoop+i*16)+xmiddle,ystart,(xstartLoop+i*16)+xmiddle,yend, "#0FB58")
		end
		
		if Loadlines_view then
			if i == xloadX - negativeoffx then
			gui.line((xstartLoop+i*16)+xmiddle,ystart,(xstartLoop+i*16)+xmiddle,yend, "red")
			end
		end 
			
		if Chunkborder_view then
			if i == xloadX+16 + negativeoffx or i == xloadX-16 + negativeoffx then
			gui.line((xstartLoop+i*16)+xmiddle,ystart,(xstartLoop+i*16)+xmiddle,yend, "orange")
			end
		end 
		
		if Mapborder_view then 
			if i == xbordX+16 + negativeoffx or i == xbordX-16 + negativeoffx then
			gui.line((xstartLoop+i*16)+xmiddle,ystart,(xstartLoop+i*16)+xmiddle,yend, "blue")
			end
		end 
				
	end 
    ystart = ystart + 2 - rshift(movementY[1],12)
    auxy = {-95,-81,-68,-55,-42,-31,-18,-5,7,18,31,42,55,68,81,95,109,123,138,153,168,185}
    
	for i = 1,22 do
		ynum = auxy[i]
		
		if Grid_view then 
		gui.line(0,ynum + ystart, 255, ynum + ystart, "#0FB58")
		end 
		
		if Loadlines_view then 
			if i == xloadY+7 + negativeoffx then
			gui.line(0,ynum + ystart, 255, ynum + ystart, "red")
			end 
		end	
			
			
		if Chunkborder_view then
			if i == xloadY+23 + negativeoffy or i == xloadY- 9 + negativeoffy then
			gui.line(0,ynum + ystart, 255, ynum + ystart, "orange")
			end 
		end 
			
		if Mapborder_view then
			if i == xbordY+23 + negativeoffy or i == xbordY- 9 + negativeoffy then
			gui.line(0,ynum + ystart, 255, ynum + ystart, "blue")
			end
		end 
			
	end
end

function showitem()
if key.shift then
	if check_key("I") then 
		Item = not Item 
		NPC = not NPC
		Trigger = not Trigger
		Warp = not Warp
	end 	
end 
		
if Item == true then
local ItemCoordPointer = base + OffsArray[3]
local ItemAmount = memory.readword(ItemCoordPointer-4)
local ItemAmount  = ItemAmount%64
local ItemXAddr = (ItemCoordPointer+ 0x4)
local ItemYAddr = (ItemCoordPointer+ 0x8)
local ItemXa = {}
local ItemYa = {}
local colour = "yellow"
local item = 0
-------------------------------
for i = 0,ItemAmount-1 do --Track Items, do -1 because you don't wanna add i*14 on the last item, that'd be max item + 0x14
ItemXa[i] = ItemXAddr + i*0x14
ItemYa[i] = ItemYAddr + i*0x14
	DX = 15*(Xpostrackerx -memory.readword(ItemXa[i]))
	DY = 15*(Ypostrackery-memory.readword(ItemYa[i]))
	gui.box(131-rshift(movementX[1],12)- DX,-93 - rshift(movementY[1],12)-  DY,
	142 - rshift(movementX[1],12)- DX,-83 - rshift(movementY[1],12)- DY, "#9793FF8", "purple")
end
end
-------------------------------
if NPC == true then
local NpcCoordPointer = base + OffsArray[4]
local NpcAmount = memory.readword(base + OffsArray[5])
local NpcAmount = NpcAmount%64
local NpcCollXAddr = (NpcCoordPointer)
local NpcCollYAddr = (NpcCoordPointer + 0x8)
local NpcCollXa = {}
local NpcCollYa = {}
gui.text(menu_box[1] + 50, menu_box[2] + 58, "NPC: "..(NpcAmount-1)..","..fmt2(NpcAmount-1),'yellow')
-------------------------------
if id == 0x49 then 
NpcBlockSize = 0x12C
NpcNul = 3
else 
NpcBlockSize = 0x128
NpcNul = 2
end

for i = 0,NpcAmount-NpcNul do --Track NPC'select, do -2 because the NPC count tracks the player, + you don't wanna add i*0x128, that'd be max NPC + 0x128
NpcCollXa[i] = NpcCollXAddr + i*NpcBlockSize
NpcCollYa[i] = NpcCollYAddr + i*NpcBlockSize

		NPCX = 15*(Xpostrackerx -memory.readword(NpcCollXa[i]))
		NPCY = 15*(Ypostrackery-memory.readword(NpcCollYa[i]))
		boxcolor = "#88FFFFA0" edgecolor =  "#0FB58" --normal NPC
		--end 
		gui.box(131-rshift(movementX[1],12)- NPCX,-93 - rshift(movementY[1],12)- NPCY,
		142 - rshift(movementX[1],12)- NPCX,-83 - rshift(movementY[1],12)- NPCY, boxcolor, edgecolor)
		end
		 
if id == 0x49 then 	
FollowNPC = base + 0x25F10
FNpcX = memory.readword(FollowNPC)
FNpcY = memory.readword(FollowNPC+0x8)
if FNpcX ~= Xpostrackerx  or FNpcY ~= Ypostrackery then
		FNPCX = 15*(Xpostrackerx -FNpcX)
		FNPCY = 15*(Ypostrackery-FNpcY)
		gui.box(131-rshift(movementX[1],12)- FNPCX,-93 - rshift(movementY[1],12)- FNPCY,
		142 - rshift(movementX[1],12)- FNPCX,-83 - rshift(movementY[1],12)- FNPCY, "#88FFFFA0", "#0FB58")
end
gui.text(5,-20,(FNpcX),'yellow')
end
end
-------------------------------
if Trigger == true then 
local TriggerPointer = base + OffsArray[7]
local TriggerAddr= memory.readdword(TriggerPointer)
local TriggerTotalAmount = memory.readbyte(TriggerAddr - 0x4)
local TriggerTotalAmount = TriggerTotalAmount%16
local TriggerXAmount = memory.readword(TriggerAddr+0x6)
local TriggerYAmount = memory.readword(TriggerAddr+0x8)
local TriggerXAddr = (TriggerAddr+0x2)
local TriggerYAddr = (TriggerAddr + 0x4)
local TriggerX = {}
local TriggerY = {}

--gui.text(20,10,TriggerXAmount,'yellow')
--gui.text(20,20,TriggerYAmount,'yellow')
--gui.text(20,30,bit.tohex(TriggerPointer),'yellow')
--gui.text(20,40,bit.tohex(TriggerAddr),'yellow')
--gui.text(20,50,bit.tohex(TriggerTotalAmount),'yellow') 
for i = 0,TriggerTotalAmount-1 do
TriggerX[i] = TriggerXAddr + i*0x10
TriggerY[i] = TriggerYAddr + i*0x10
local TriggerXAmount = memory.readword(TriggerAddr+0x6+i*0x10)
local TriggerYAmount = memory.readword(TriggerAddr+0x8+i*0x10)
for j = 0,TriggerXAmount-1 do
for k = 0,TriggerYAmount-1 do

		TrX = 15*(Xpostrackerx -memory.readword(TriggerX[i])-j)
		TrY = 15*(Ypostrackery-memory.readword(TriggerY[i])-k)
		gui.box(131-rshift(movementX[1],12)- TrX,-93 - rshift(movementY[1],12)- TrY,
		142 - rshift(movementX[1],12)- TrX,-83 - rshift(movementY[1],12)- TrY, "#FFF8666","#FFF66")
		
		
	end
end
end	
end 

if Warp == true then 
local WarpPointer = base+OffsArray[8]
local WarpAddr = memory.readdword(WarpPointer)
local WarpAmount = memory.readdword(WarpAddr - 0x4)
local WarpAmount  = WarpAmount%64
local WarpXAddr = WarpAddr
local WarpYAddr = WarpAddr+0x2
local WarpMapId = WarpAddr+0x4
local WarpXa = {}
local WarpYa = {}

for i = 0,WarpAmount-1 do
WarpXa[i] = WarpXAddr + i*0xC
WarpYa[i] = WarpYAddr + i*0xC
	WX = 15*(Xpostrackerx -memory.readword(WarpXa[i]))
	WY = 15*(Ypostrackery-memory.readword(WarpYa[i]))
	gui.box(131-rshift(movementX[1],12)- WX,-93 - rshift(movementY[1],12)-  WY,
	142 - rshift(movementX[1],12)- WX,-83 - rshift(movementY[1],12)- WY,"#600038", "#C00058")
end
end
end  
--
-- Keypress setup and checking
--
key = {}
last_key = {}
joy = {}
last_joy = {}

function get_keys()
	last_key = key
	key = input.get()
end

function check_key(btn)
	if key[btn] and not last_key[btn] then
		return true
	else
		return false
	end
end

function up(steps)
	target = bit.band(Ypostrackery - steps, 0xFFFF)
	if target < 0 and Ypostrackery > 0 then
		target = bit.band(bit.bnot(target) - 1, 0xFFFF)
	end
	while Ypostrackery ~= target do
		joy.up = true
		joy.down = false
		joy.left = false
		joy.right = false
		joypad.set(joy)
		joy = {}
		emu.frameadvance()
	Ypostrackery = memory.readword(YPositionAddrOffset + base)
	end
end

function right(steps)
	target = bit.band(Xpostrackerx  + steps, 0xFFFF)
	if target < 0 and Xpostrackerx  > 0 then
		target = bit.band(bit.bnot(target) - 1, 0xFF)
	end
	while Xpostrackerx  ~= target do
		joy.up = false
		joy.down = false
		joy.left = false
		joy.right = true
		joypad.set(joy)
		joy = {}
		emu.frameadvance()
	Xpostrackerx  = memory.readword(XPositionAddrOffset + base)
	end
end

function down(steps)
	target = bit.band(Ypostrackery + steps, 0xFFFF)
	if target < 0 and Ypostrackery > 0 then
		target = bit.band(bit.bnot(target) - 1, 0xFFFF)
	end
	while Ypostrackery ~= target do
		joy.up = false
		joy.down = true
		joy.left = false
		joy.right = false
		joypad.set(joy)
		joy = {}
		emu.frameadvance()
	Ypostrackery = memory.readword(YPositionAddrOffset + base)
	end
end

function left(steps)
	target = bit.band(Xpostrackerx  - steps, 0xFFFF)
	while Xpostrackerx  ~= target do
		joy.up = false
		joy.down = false
		joy.left = true
		joy.right = false
		joypad.set(joy)
		joy = {}
		emu.frameadvance()
	Xpostrackerx  = memory.readword(XPositionAddrOffset + base)
	end
end

function tweak()
	if key.shift then
		if check_key("^") then
		down (4)
		right (1)
		left (1)
		up (1)
		left (14)
		down (1)
		left (4)
		down (3)
		left (7)
		up(2)
		left (6)
		up (2)
		left (1)
		right (1)
		down (1)
		right (7)
		down (3)
		right (5)
		up (3)
		right (4)
		down (6)
		right (16)
		up (7)
		left (1)
		right (1)
		down (1)
		right (12)
		down (8)
		right (8)
		elseif check_key("Y") then 
		right (15)
		up (3)
		right (8)
		up (5)
		elseif check_key("^") then 
		down (4)
		left (1)
		right (1)
		left (19)
		down (3)
		left (7)
		up(2)
		left (6)
		up (2)
		left (1)
		right (1)
		down (2)
		up (2)
		right (7)
		down (4)
		right (5)
		up (3)
		right (4)
		down (6)
		right (16)
		up (7)
		left (1)
		right (1)
		down (1)
		right (12)
		down (8)
		right (8)
		elseif check_key("^") then 
		up (4)
		right (1)
		left (1)
		down (2)
		right (1)
		
		
end
end
end

function walkthroughwalls()
if check_key("W") then
WTW = not WTW

if WTW == true then
memory.writeword(AddrArray[1] + LanguageArray[1],0x1000)
else
memory.writeword(AddrArray[1]+ LanguageArray[1],0x1C20)
end 
end 
end 

function infRepelfunc()
local RepelAddr = base + OffsArray[6]
local Repelsteps = memory.readbyte(RepelAddr)
--gui.text(menu_box[1] + 95, menu_box[2] + 2, "Repel: "..(Repelsteps),'yellow')
if InfRepel == true then
memory.writebyte(RepelAddr,0x10)
end 
end 

function CustomFly()
--select fly to eterna City to activate
if CustomWarp == true then
FlyMapIDAddr = base + OffsArray[10]
FlyMapId = memory.readdword(FlyMapIDAddr) 
FlyMapxAddr = FlyMapIDAddr + 0x8
FlyMapyAddr = FlyMapxAddr + 0x4
FlyMapx = memory.readdword(FlyMapxAddr)
FlyMapy = memory.readdword(FlyMapyAddr)  
	if FlyMapId == FlyOptionId then
	memory.writedword(FlyMapIDAddr,customwarpid)
	memory.writedword(FlyMapxAddr,customwarpx)
	memory.writedword(FlyMapyAddr,customwarpy)
	end
gui.text(menu_box[1] + 95, menu_box[2] + 2, "Warp: "..(FlyMapId),'yellow')	
end 
end 

function teleport()
if teleport1 == true then 
	if key.shift then
		if check_key("left") then
			memory.writedword(base + teleportX, (Xtel- jump))
			memory.writeword(base + teleportXmov, (telXmov - jump))
			if id == 0x41 or id == 0x43 or id == 0x59 then
			memory.writeword(base + stepamountAddr, stepamount + jump)
			end
		end
		if check_key("down") then
			memory.writedword(base + teleportY, (Ytel + jump))
			memory.writeword(base + teleportYmov, (telYmov + jump))
			if id == 0x41 or id == 0x43 or id == 0x59 then
			memory.writeword(base + stepamountAddr, stepamount + jump)
			end
		end
		if check_key("right") then
			memory.writedword(base + teleportX, (Xtel + jump))
			memory.writeword(base + teleportXmov, (telXmov + jump))
						if id == 0x41 or id == 0x43 or id == 0x59 then
			memory.writeword(base + stepamountAddr, stepamount + jump)
			end 
		end
		if check_key("up") then
			memory.writedword(base + teleportY, (Ytel  - jump))
			memory.writeword(base + teleportYmov, (telYmov - jump))
						if id == 0x41 or id == 0x43 or id == 0x59 then
			memory.writeword(base + stepamountAddr, stepamount + jump)
			end 
		end
		end 
	end
end 

function demostoptimer() 
if check_key("S") then
demostop = not demostop
end

if id == 0x59 and demostop == true then
	memory.writeword(0x2106B90,0000)
end 
end 

function Catchratemod()
if id == 0x41 or id == 0x59 then 
	CatchAddr = AddrArray[2]
	if PerfectCatch then
	memory.writeword(CatchAddr, 0x4280)
	elseif memory.readword(CatchAddr) == 0x4280 then 
	memory.writeword(CatchAddr, 0x2801)
end 

elseif id == 0x43 then 
	if memory.readdword(AddrArray[2]) == 0x4A7E497D then 
	if PerfectCatch then
	--memory.writeword(0x224A774,0xE005)
	memory.writeword(0x224A782,0x2001)
	--memory.writedword(0x224A784,0x38010400)
	elseif memory.readword(0x224A774) == 0xE005 then 
	--memory.writeword(0x224A774,0xE009)
	memory.writeword(0x224A782,0x2008)
	--memory.writedword(0x224A784,0x38010400)
	
	end
	end 
end 
end 

function writemap(value)
if mapediting then 
if in_edit then 
	value = memory.readbyte(curptrmap) + value
	memory.writebyte(curptrmap, value)
	curptrmap = curptrmap - 1
	in_edit = false
else
	memory.writebyte(curptrmap, value*0x10)
	in_edit = true
end 

if curptrmap == LiveMapIdAddr -0x1 then 
curptrmap = LiveMapIdAddr + 1
mapediting = false 
end 
end 
end 
 
function CollisionMap()
if Collision then 
	gui.box(map_box[1], map_box[2], map_box[3], map_box[4], "#00000090") 

	chunkxposo = (Xpostrackerx) % 32
	chunkyposo = ((Ypostrackery) % 32)*32
		if Xpostrackerx > 0x7fff and Ypostrackery == 0xffff then 
		else 
			if Xpostrackerx > 0x7fff then
		        slide = false 
			    chunkyposo = chunkyposo - 32
			elseif Ypostrackery == 0xffff then
			    slide = false
			    chunkyposo = -32
			else 
			    slide = true 
			end 
end 

chunkxpos = chunkxposo
chunkypos = chunkyposo

    if chunkxposo < 7  then
        chunkxpos = 7
    elseif chunkxposo > 23 then
        chunkxpos = 23
    end 

    if chunkyposo > 6*32 then
        if chunkyposo > 19*32 then
            chunkypos = 19*32 
        end 
            chunkypos = chunkypos - 6*32
        elseif slide then 
            chunkypos = 0 
    end

chunktileposo = chunkxposo + chunkyposo
chunktilepos = chunkxpos + chunkypos 

Tiledatapointer = memory.readdword(base+OffsArray[13])
CurrentChunkvAddr = Tiledatapointer + 0xAC

    if chunkediting then 
        else 
        CurrentChunkvword = memory.readbyte(CurrentChunkvAddr)
        CurrentChunkv = CurrentChunkvword
    end 

CurrentChunkpointer = Tiledatapointer + 0x90 + 0x4*CurrentChunkv 
CurrentChunk = memory.readdword(CurrentChunkpointer)

Chunkloadingv = memory.readbyte(Tiledatapointer+0xE4)
ledgetargetxaddr = Tiledatapointer+0xCE
ledgetargetx = memory.readword(ledgetargetxaddr)
ledgetargetsubx = memory.readbyte(ledgetargetxaddr-0x1)
xgraph = memory.readword(0x21CEF5A)
gui.text (100,-42,"Graph X:"..xgraph..","..fmt4(xgraph),'yellow')
gui.text (100,-32,"Chunk X:"..ledgetargetx..","..fmt4(ledgetargetx),'yellow')
gui.text (100,-22,"Sub   X:"..ledgetargetsubx..","..fmt2(ledgetargetsubx),'yellow')

gui.text (100,-12,"Halt Loading:",'yellow')
    if Chunkloadingv > 0 then
        chunkloading = false
        gui.text(180,-12,'True','green')
    else
        chunkloading = true
        gui.text(180,-12,'False','red')
    end 

    if bt then 
        gui.text(5,-20,fmt8(BTchunkpointer))
        StartChunk = BTchunkpointer + 0xE2
            if Bigmap then
            
                    if memory.readword(base + mapAddrOffset) == 0x2 then 
                        chunkamount = 16 
                        btpos = 0
                    else 
                        chunkamount = 4
                        btpos = X32bit*2 + Y32bit*64 - 898 - 32
                    end
            
                    for h = 0,chunkamount-1 do
                        CurrentChunk = StartChunk + h*2048 + changechunk*2048
                        for i = 0, 31, 1 do
                            for j = 0 ,31, 1 do
                                    
                                collisiontileAddr = (CurrentChunk + 2 * i + 32*2*j + btpos)
                                collisiontile = memory.readword(collisiontileAddr)

                                if collisiontileAddr == (StartChunk + X32bit*2 + Y32bit*64) then
                                    color = '#ff00003'
                                else 
                                    color = get_tile_color(collisiontile)
                                end 
                            
                                if memory.readword(base + mapAddrOffset) == 0x2 then 
                                    drawvsmallsquare((i)*2 + map_box[1] + displayoffsxbt[h+1],
                                    (j)*1.5 + map_box[2] + displayoffsybt[h+1],color)
                                else
                                    drawsmallsquare((i)*4 + map_box[1] + displayoffsx[h+1],
                                    (j)*3 + map_box[2] + displayoffsy[h+1],color)
                                end
                            end
                        end 
                    end 
            end 
    else
--gui.text (50,-60,"Chunkdat:"..bit.tohex(CurrentChunkv))
--gui.text(50,-70,fmt8(CurrentChunkvAddr))
--gui.text (50,-50,"Pointer:"..bit.tohex(CurrentChunkpointer))
--gui.text (50,-40,"Chunkdat:"..bit.tohex(CurrentChunk))

        if map_centered == true then
            x_paint = 1
            y_paint = 1
        end
        
        if Bigmap then
                if Xpostrackerx > 0x7fff or Ypostrackery > 0x7fff then
                    c = -64
                else 
                    c = 0
                end
	
                for h = 0,3 do
                    Chunkcalc = memory.readdword(Tiledatapointer + 0x90+ 4*h)
                        for i = 0, 31, 1 do
                            for j = 0 ,31, 1 do
                                collisiontileAddr = (Chunkcalc + 2 * i + 32*2*j + c)
                                collisiontile = memory.readword(collisiontileAddr)
                                    if collisiontileAddr == (CurrentChunk + 2*chunktileposo) then
                                        color = '#ff00003'
                                    else 
                                        color = get_tile_color(collisiontile)
                                    end 
                                    
                                drawsmallsquare((i)*4 + map_box[1] + displayoffsx[h+1],
                                (j)*3 + map_box[2] + displayoffsy[h+1],color)
                            end 	
                        end 
	            end 
	    else
	
            if x_paint <= 0 or max_cols == 32 then
                x_paint = 1
            elseif x_paint > 28 - max_cols then
                x_paint = 28 - max_cols 
            end
            
            if y_paint <= 0 then
                y_paint = 1
            elseif y_paint > 27 - max_rows then 
                y_paint = 27 - max_rows 
            end 
	
            for i = x_paint, x_paint + 15, 1 do
                for j = y_paint ,y_paint + max_rows-1, 1 do
                    collisiontileAddr = (CurrentChunk + 2 * i + 32*2*j+2*chunktilepos-64-16)
                    collisiontile = memory.readword(collisiontileAddr)	
                        if collisiontileAddr == (CurrentChunk + 2*chunktileposo) then
                            color = '#ff00003'
                        else
                            color = get_tile_color(collisiontile)
                            --debug gui.text(160,-50,fmt8(collisiontileAddr)) 
                            --debug gui.text(160,-40,fmt8(CurrentChunk+chunktilepos)) 
                        end
                        
                        if collisiontile then 
                                if showid then 
                                    gui.text((i-x_paint)*16 + 4 + map_box[1],(j-y_paint) * 10 + 3 + map_box[2], fmt2(collisiontile), color)
                                else 
                                    drawbigsquare((i-x_paint)*16+1 + map_box[1],(j-y_paint) * 10 + 1 + map_box[2],color)
                                end 
                        end 
                end 
            end 
        end

    end
end 
end 



function Customvalue()
    LiveMapIdAddr = base +  LiveMapIdOffs
        if check_key("M") then
            mapediting = not mapediting
            curptrmap = LiveMapIdAddr + 1   
        end 

        if check_key("J") then
            customjump = not customjump
                if customjump then
                    jump = 31
                end 
        end 

        if customjump then
                if key.up then 
                    jump = jump + 8
                elseif key.down then
                    jump = jump - 8
                elseif check_key("right") then 
                    jump = jump + 1
                elseif check_key("left") then 
                    jump = jump - 1
                end

                if jump < 1 then 
                    jump = 65536
                end 

                if jump > 65536 then 
                    jump = 1
                end 
        end 

        if check_key("S") and key.shift then
            showid = not showid 
        end

        if check_key("D") and key.shift then
            debugtiledata = true 
        end

        if key.shift and check_key("B") then 
                Bigmap = not Bigmap
        end 

        if check_key("V") and key.control then
            viewmode = (viewmode + 1)%5
        end 

        if check_key("C") and viewmode == 2 then 
            collisionediting = true 
            chunkediting = true 
                if key.shift then
                    collisionediting = false
                    chunkediting = false 
                end
        end 

        if collisionediting then 
                if check_key("up") then
                    CurrentChunkv = CurrentChunkv + 1
                        if CurrentChunkv > 3 then 
                            CurrentChunkv = 3
                        end
                    collisionediting = false 
                elseif check_key("down") then 
                    CurrentChunkv = CurrentChunkv -1
                        if CurrentChunkv < 0 then 
                            CurrentChunkv = 0
                        end 
                    collisionediting = false 
                end 
        end 

--gui.text(menu_box[1] + 20, menu_box[2] + 78, "curptr" .. bit.tohex(curptrmap),'yellow')
        for i, v in ipairs({0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF}) do
            if check_key(string.format("%X", i)) then writemap(v) break end
            if check_key("0") or check_key("numpad0") then writemap(0) break end
		for i = 1,9 do
			numpadv = "numpad"..i
			print(numpadv)
			if check_key(numpadv) then print(i.."Has been found")
			end
		end 
end 

function flycursorfunc()
if flycursor then 
Map = false 
Collision = false 
FlycuXAddr = base + OffsArray[12]
FlycuYAddr = FlycuXAddr + 0x4
flycux = memory.readword(FlycuXAddr)
flycuy = memory.readword(FlycuYAddr)
estimatex = 0
estimatey = 0
if id == 0x41 or id == 0x59 then
gui.text(menu_box[1] + 140, menu_box[2] + 68, "X cursor: "..fmt4(flycux),'yellow')
gui.text(menu_box[1] + 140, menu_box[2] + 78, "Y cursor: "..fmt4(flycuy),'yellow')
if flycux > 0x1C then 
if flycux < 0x8000 then 
estimatex = (flycux)/10
gui.text(menu_box[1] + 140, menu_box[2] + 88, "Left for "..round(estimatex).."s",'yellow')
else 
estimatex = (flycux - 0x8000)/10
gui.text(menu_box[1] + 140, menu_box[2] + 88, "Right for "..round(estimatex).."s",'yellow')
end 
end 
if flycuy > 0x1C then 
if flycuy < 0x8000 then 
estimatey = (flycuy)/10
gui.text(menu_box[1] + 140, menu_box[2] + 98, "Up for "..round(estimatey).."s",'yellow')
else
estimatey = (flycuy - 0x8000)/10
gui.text(menu_box[1] + 140, menu_box[2] + 98, "Down for "..round(estimatey).."s",'yellow')
end 
end
estimatetotal = estimatex + estimatey 
gui.text(menu_box[1] + 140, menu_box[2] + 108, "Total: "..round(estimatetotal).."s",'yellow')

end
end 
end 

function tilefunc()
currenttile = memory.readbyte(OffsArray[2] + base + 0x3C)
end 

function fmt8(arg)
    return string.format("%08X", bit.band(4294967295, arg))
end

function fmt4(arg)
    return string.format("%04X", bit.band(65535, arg))
end

function fmt2(arg)
    return string.format("%02X", bit.band(255, arg))
end

function string:join(tab)
    res = ""
    for i, s in ipairs(tab) do
        res = res .. s
        if i ~= #tab then
            res = res .. self
        end
    end
    return res
end

function table.map(tab, func)
    new = {}
    for i, a in ipairs(tab) do
        table.insert(new, func(a))
    end
    return new
end


function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

function debuggerprint()
if check_key("P") then  
debugger = not debugger
end 
if debugger == true then 
		joy.up = false
		joy.down = false
		joy.left = true
		joy.right = false
		joypad.set(joy)
		joy = {} 
		
if currenttile < 255 then 
	if currenttile == not lastcurrenttile then 
	print(XPos[5],YPos[5],LiveMapId,tilename[currenttile+1])
		lastcurrenttile = currenttile
		end 		
end 
end
end 

function wrongwarpdata()
if id == 0X41 then 
wrongx = memory.readword(base+0X1490)
wrongy = memory.readword(base+0x1494)
gui.text(menu_box[1] + 140, menu_box[2] + 18, "WW X: "..(wrongx)..","..fmt4(wrongx),'yellow')
gui.text(menu_box[1] + 140, menu_box[2] + 28, "WW Y: "..(wrongy)..","..fmt4(wrongy),'yellow')
end
end

function RETIRE()
	internal_execpointer = memory.readdword(base + 0x29500 + btval)
	run_ptr_sc4   = base + 0x29574
	run_ptr_sc3   = base + 0x29670
	constant_4    = memory.readdword(base + 0x29554)
	constant_3    = memory.readdword(base + 0x29650)
	menu_id       = memory.readdword(base + 0x296E0)
    map_id = map
	menu_id2        = memory.readdword(base + 0x296C4)

	if bt then
		run_ptr_sc4   = base + 0x31678
		run_ptr_sc3   = base + 0x00000
		constant_4    = memory.readdword(base + 0x31658)
		constant_3    = memory.readdword(base + 0x00000)
		menu_id       = memory.readdword(base + 0x317E4)
		menu_id2      = memory.readdword(base + 0x317C8)
	end  
	
    runtime_ptr = run_ptr_sc4
    soff = 0xC
	if lang == 0x4A then 
	constantvar = 0x20F5394
	else 
	constantvar = 0x20F355C
	end 
	
	if constant_3 == constantvar then  	
        altretire = true
        runtime_ptr = run_ptr_sc3
        soff = 0x8
	end 
	
	if constant_4 == constantvar then  	
        altretire = false
        runtime_ptr = run_ptr_sc4
        soff = 0xC
	end
    
    runtime_sc   = memory.readdword(runtime_ptr) -- Pointer to runtime values
    run_ptr  = runtime_sc + soff
    runtime  = memory.readdword(run_ptr)
    script   = runtime + run_ptr + 0x4
    script_ptr = script
    
    script_off   = script - base
    ofb = found_bytes
    found_bytes = (altretire and constant_3 == constantvar) or (not altretire and constant_4 == constantvar)
    if not ofb and found_bytes then
        curptr = script
        scroll = 0
    end
end

function reset_script()
    found_bytes = false  -- Recalculate address
    --map_scripts = {}
    script_offsets = {}
    script_count = 0
end

function get_script()
    if last_map ~= map then
        reset_script()
    end
    
    if check_key(keybinds.reset_search) then
        reset_script()
    end
    
    target_ptr = 0x00029577 + base
    if bt then
        target_ptr = target_ptr + 8000
    end
    
    if found_bytes then return end
    
    oaddr = memory.readdword(target_ptr)
	
	   if ALT_RETIRE then
        addr = oaddr + 0x4
    else
        addr = oaddr + 0x8
    end
    
    if #map_scripts == 0 then
        start = base + 0x29434
        print("Debug data at 0x"..fmt8(start))
        mem = ""
        
        for i=0, 0x1000 do
            mem = mem .. string.format("%02X ", memory.readbyte(start+i))
            if i%16 == 15 then
                mem = mem .. "\n"
            end
            
            --file = io.open("dump.txt", "w")
            --file:write(mem)
            --file:close()
        end
    
        map_scripts = { 0x00 }
    end
    
    script_count = scripts[map]
    -- script_count = memory.readdword(oaddr)
    
    if script_count > 3 then
        found_bytes = false  -- Recalculate address
        return
    end
    
    step_size = steps_data[script_count]
    
    step_addr = step_size + addr
    
    jmp_size = memory.readdword(step_addr)
    if oaddr > 0x02000000 then
        script_ptr = jmp_size + addr + step_size + 1
        print("found 13FD at 0x" .. fmt8(addr))
        print("Script address: 0x" .. fmt8(script_ptr))
        found_bytes = true
        curptr = script_ptr
        -- inject({}) -- Clear memory by default
        if jump_json_enabled then get_data_script() end
    end
    
end

function get_data_script()
    key = string.format("0x%08x", base)
    if data_json[key] == nil then
        data_json[key] = {}
    end
    data_json[key][map] = {
        fd13_addr = string.format("0x%08x", addr),
        step_size = step_size,
        script_addr = string.format("0x%08x", script_ptr),
        jump_size = string.format("0x%08x", jmp_size),
        offset = string.format("0x%08x", script_ptr - base)
    }
    file = io.open("dump.json", "w")
    file:write(json.encode(data_json, {indent=2}))
    file:close()
end

function inject(ops)  -- Pass a table!
    for i = 1, #ops do
        op = ops[i]
        memory.writebyte(script_ptr+i-1, op)
    end
end

function do_ctx()
    if check_key(keybinds.udlr[1]) then
        script_no = script_no + 1
        in_edit = false
    elseif check_key(keybinds.udlr[2]) then
        script_no = script_no - 1
        in_edit = false
    end
    
    if script_no > script_count then
        script_no = 1
    elseif script_no == 0 then
        script_no = script_count
    end
end


function do_editor()
    -- cursor movement
    curptr = math.max(curptr, script_ptr)
    
    if check_key(keybinds.udlr[1]) then
        curptr = math.max(curptr - cwidth, script_ptr)
        in_edit = false
    elseif check_key(keybinds.udlr[2]) then
        curptr = curptr + cwidth
        in_edit = false
    elseif check_key(keybinds.udlr[3]) then
        curptr = math.max(curptr - 1, script_ptr)
        in_edit = false
    elseif check_key(keybinds.udlr[4]) then
        curptr = curptr + 1
        in_edit = false
    elseif check_key(keybinds.pgup) then
        curptr = math.max(curptr - cwidth*cheight, script_ptr)
        scroll = math.max(0, scroll - cheight)
        in_edit = false
    elseif check_key(keybinds.pgdown) then
        curptr = curptr + cwidth*cheight, script_ptr
        scroll = scroll + cheight
        in_edit = false
    end
    
    function setbyte(value)
        if in_edit then
            in_edit = false
            value = value + memory.readbyte(script_ptr + 14*ypos + xpos)
            memory.writebyte(script_ptr + 14*ypos + xpos, value)
            curptr = curptr + 1
        else
            value = value * 0x10
            memory.writebyte(script_ptr + 14*ypos + xpos, value)
            in_edit = true
        end
    end
    
    for i, v in ipairs({0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8, 0x9, 0xA, 0xB, 0xC, 0xD, 0xE, 0xF}) do
        if check_key(string.format("%X", i)) then setbyte(v) break end
        if check_key("0") then setbyte(0) break end
    end
    
    -- memory manip
    if check_key(keybinds.clear_ram) then
        for ptr=script_ptr,script_ptr+(cheight*cwidth)-1 do
            memory.writebyte(ptr, 0x00)
        end
        curptr = script_ptr
    elseif check_key(keybinds.increase) then
        memory.writebyte(curptr, memory.readbyte(curptr) + 1)
    elseif check_key(keybinds.decrease) then
        memory.writebyte(curptr, memory.readbyte(curptr) - 1)
    end
    
    relpos = curptr - script_ptr
    old_xpos = xpos
    old_ypos = ypos
    xpos = relpos % cwidth
    ypos = math.floor(relpos / cwidth) - cwidth*scroll
    
    if curptr >= script_ptr + (cwidth*cheight) + cwidth*scroll then
        scroll = scroll + 1
    elseif curptr < script_ptr + cwidth*scroll then
        scroll = scroll - 1
    end
end

function show_scripts()
    h = math.min(cheight-1, math.floor(#map_scripts[script_no]/cwidth))
    for i = 0, h do
        code = ""
        if i == h then
            w = #map_scripts[script_no] % cwidth
        else
            w = cwidth
        end

        for j = 0, w-1 do
            index = cwidth*i + j
            code = code .. fmt2(map_scripts[script_no][index+1])
        end
        gui.text(5, 5 + 10*i, code)
    end
    
    gui.text(5, menu_box[1]+50, "Script: "..script_no.."/"..#map_scripts)
    gui.text(5, menu_box[1]+50, "  Addr: 0x"..fmt8(script_offsets[script_no]))
end

function show_bytecode()
    start = script_ptr + cwidth*scroll

    if not SCRIPT_MODE then
        -- Code
        for i = 0, cheight-1 do
            code = ""
            c1 = ""
            for j = 0, cwidth-1 do
                if i == 0 and j < 2 and opname ~= nil then
                    c1 = c1 .. string.format("%02X ", memory.readbyte(start + cwidth*i + j))
                else
                    code = code .. string.format("%02X ", memory.readbyte(start + cwidth*i + j))
                end
            end
            if i == 0 and opname ~= nil then
                gui.text(5, map_box[2]+5, c1, "green")
                gui.text(41, map_box[2]+ 5, code)
            else 
                gui.text(5, map_box[2]+ 5 + 10*i, code)
            end
        end
    else
        for i = 0, cheight-1 do
            before = ""
            code = ""
            after = ""
            use_after = false
            for j = 0, cwidth-1 do
                ptr = start + cwidth*i + j
            
                if i == ypos and j == xpos then
                    use_after = true
                    code = code .. string.format("%02X ", memory.readbyte(ptr))
                else
                    if use_after then
                        after = after .. string.format("%02X ", memory.readbyte(ptr))
                    else
                        before = before .. string.format("%02X ", memory.readbyte(ptr))
                    end
                end
            end
            gui.text(5,map_box[2] + 5 + 10*i, before)
            gui.text(5+6*#before, map_box[2]+ 5 + 10*i, code, "green")
            gui.text(5+6*#before + 18, map_box[2]+ 5 + 10*i, after)
        end
    end
    
    gui.text(5, map_box[2]+ 10*(cheight+1), "Cursor address: "..fmt8(curptr))
    gui.text(5, map_box[2]+ 10*(cheight+2), "Offset from script: "..fmt8(curptr - script_ptr))
end

function show_retire()
	-- Entry point
	if found_bytes then	
        gui.text(menu_box[1] + 140, menu_box[2] + 70, "Jump 0x"..fmt8(runtime),retireclr)
        gui.text(menu_box[1] + 140, menu_box[2] + 90, "Exec 0x"..fmt8(script),retireclr)
        gui.text(menu_box[1] + 140, menu_box[2] + 80, "Offs 0x"..fmt8(script_off),retireclr)
        -- gui.text(145, -125, (""):join(table.map(memory.readbyterange(script, 15), fmt2)))
        -- gui.text(145, -115, (""):join(table.map(memory.readbyterange(script+16, 15), fmt2)))
    end
	
    
    if not SCRIPT_MODE and check_key(keybinds.script_dump) then
        DISPLAY_CTX = not DISPLAY_CTX
        script_no = 1
    end
    
    if found_bytes and check_key(keybinds.switch_mode) and not DISPLAY_CTX then
        if SCRIPT_MODE then 
            -- Exit edit mode
            scroll = 0
            curptr = script_ptr
        else 
            -- Enter edit mode
            old_xpos = 0
            old_ypos = 0
            curptr = script_ptr
        end
        SCRIPT_MODE = not SCRIPT_MODE
    end
    
    if found_bytes and check_key(keybinds.inject_code) then
        inject(INJECT_CODE)
    end
    
    if SCRIPT_MODE then
        do_editor()
    end
    
    if DISPLAY_CTX then
        do_ctx()
    end
    
    -- Script information
    if DISPLAY_CTX then
        show_scripts()
    elseif found_bytes then
        if not SCRIPT_MODE then
            ptr = script_ptr
            --repeat
                first_op = memory.readbyte(ptr) + memory.readbyte(ptr+1) * 0x0100
                ptr = ptr + 2
            --until first_op ~= 0x0000
        else 
            ptr = script_ptr + 14*ypos + xpos
            first_op = memory.readbyte(ptr) + memory.readbyte(ptr+1) * 0x0100
        end
        gui.text(menu_box[1] + 140, menu_box[2] + 110, "Script:",retireclr)
        gui.text(menu_box[1] + 140, menu_box[2] + 120, " Addr 0x" .. fmt8(script_ptr),retireclr)
        gui.text(menu_box[1] + 140, menu_box[2] + 130, " Base + 0x" .. fmt8(script_ptr - base),retireclr)
        gui.text(menu_box[1] + 140, menu_box[2] + 140, " IntrlPtr:" .. fmt8(internal_execpointer),retireclr)
        opname = opcodes[first_op]
        
        if opname ~= nil then
            gui.text(menu_box[1] + 140, menu_box[2] + 153, " opcode: " .. opname,retireclr)
        end
        
        show_bytecode()
        
    end
end 

function battletower()
if id == 0x41 then 
BTchunkpointerAddr = base + OffsArray[14] 
BTchunkpointer = memory.readdword(BTchunkpointerAddr)
	if BTchunkpointer > 0 then 
	bt = true 
	btval = 0x8104
	else 
	bt = false
	btval = 0x0
	end
end 
end 

function chunkrecalc()
	if check_key("H") then
	chunkrepos = not chunkrepos 
	end
		if chunkrepos and key.shift then 
		if check_key("up") then
		changechunk = changechunk - 2
		elseif check_key("down") then
		changechunk = changechunk + 2
		elseif check_key("left") then
		changechunk = changechunk - 1
		elseif check_key("right") then
	changechunk = changechunk + 1
end 
end 
end 

function fn()
	base = memory.readdword(base_addr)
	pointer = base 
	x_position = memory.readdwordsigned(pointer + XPositionAddrOffset)
	y_position = memory.readdwordsigned(pointer + YPositionAddrOffset)
	battletower()
	if id == 0x41 or id == 0x43 or id == 0x59 then 
	maplayoutv = 30
	elseif id == 0x49 then
	maplayoutv = 47
	end
	map_width = memory.readbyte(pointer + mapAddrOffset - 1)
	map_height = memory.readbyte(pointer + mapAddrOffset - 2)
	
	map_tile_pos = (math.modf(x_position / 32) or nil) + (math.modf(y_position / 32) or nil) * map_width
	map_y_pos = math.floor(map_tile_pos / maplayoutv)
	map_x_pos = map_tile_pos - map_y_pos * maplayoutv
	
	for i = 1,4 do
		movementX[i] = movementX[i+1]
		movementY[i] = movementY[i+1]
		XPos[i] = XPos[i+1]
		YPos[i] = YPos[i+1]
	end
	movementX[5] = memory.readword(base + movementXAddrOffset)
	movementY[5] = memory.readword(base + movementYAddrOffset)
	XPos[5] = memory.readword(base + OffsArray[2]+0x2)
	YPos[5] = memory.readword(base + OffsArray[2]+0xA)
	Xpostrackerx = memory.readword(base + OffsArray[1])
	Ypostrackery = memory.readword(base + OffsArray[1]+0x4)
	
	X32bit = memory.readdword(base + OffsArray[1])
	Y32bit = memory.readdword(base + OffsArray[1]+0x4)
	
	Xtel = memory.readdword(base + teleportX)
	Ytel = memory.readdword(base + teleportY)
	telXmov = memory.readword(base + teleportXmov)
	telYmov = memory.readword(base + teleportYmov)
	stepamount = memory.readword(base + stepamountAddr)
	LiveMapId = memory.readword(base +LiveMapIdOffs)
	tilefunc()
	showitem()
	get_keys()
	updateLayout()
	drawLoadLines()
	updateTab()
	printTopMenu()
	printMapControl()
	printSettingsMenu1()
	textgui()
	infRepelfunc()
	CustomFly()
	tweak()
	walkthroughwalls()
	teleport()
	Catchratemod()
	Customvalue()
	demostoptimer()
	wrongwarpdata()
	
	if viewmode == 0 then 
	Collision = false 
	Map = false
	flycursor = false
	gui.text(225, menu_box[2] + 180, "Off",'red')
	end 
	
	if viewmode == 1 then
	Collision = false
	Map = true 
	flycursor = false
	gui.text(230, menu_box[2] + 180, "Map",'red')
	end
		
	if viewmode == 2 then
	Collision = true 
	Map = false
	flycursor = false
	gui.text(216, menu_box[2] + 180, "Chunks",'red')
	end 
	
	if viewmode == 3 then
	Collision = false
	Map = false
	if id == 0x41 then
	flycursor = true
	flycursorfunc()
	gui.text(216, menu_box[2] + 180, "flymap",'red')
	else 
	viewmode = viewmode + 1
	end
	end 
	
	if viewmode == 4 then
	Collision = false 
	Map = false
	flycursor = false
	if id == 0x41 then 
	RETIRE()
	show_retire()
	gui.text(215, menu_box[2] + 180, "RETIRE",'red')
	else 
	viewmode = 0
	end 
	end
	
	if bt then 
	gui.text(50,menu_box[2] + 70,"BT/UG",'red')
	chunkrecalc()
	end 
	
	CollisionMap()
	printMap()


	if key.comma then 
	if base ~= 0x226D34C  and base ~= 0x226D2A4 then 
	if	base ~= 0 then 
		joy.L = true
		joy.R = true 
		joy.select = true
		joy.start = true
		joypad.set(joy)
		joy = {}
		end 
		else print("Base value found!")
	--joypad.set(up)
	--print(LiveMapId,fmt8(CurrentChunkpointer),fmt8(CurrentChunkpointer-base))
	--memory.writeword(LiveMapIdAddr,LiveMapId+1)
	end
	end 
	debuggerprint()
end

gui.register(fn)