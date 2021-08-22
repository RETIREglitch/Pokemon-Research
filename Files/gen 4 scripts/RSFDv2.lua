-------------------------------------------------
----    RSFD - Routing Script For Dummies    ----
-------------------------------------------------
--              by RETIREglitch                --
-------------------------------------------------
--  base pointer addresses provided by Ganix   --
--  void formula based on void.lua by MKdasher --
-------------------------------------------------

-- DATA TABLES

local map_id_list = {
	Goal = {
		color = '#f7bbf3',
		ids = {333,332}
		},
	Chains= {
		color = '#DfA',
		ids = {469,406,385,40, 442, 450, 457, 499, 501,342, 406, 501, 502, 503}
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

local tile_names = {
			"nothing","nothing","Grass","Grass","4","Cave","Cave","7","Cave","9","10", "Haunted House","Cave wall","13","14","15",
			"Pond","Water","Water","WaterF","Water","Water","Puddle","ShallW","24","Water","26","27","28","29","30","31",
			"Ice","Sand","Water","35","Cave","Cave","38","39","40","41","Water","43","44","45","46","47",
			"Onesided Wall","Onesided Wall","Onesided Wall","Onesided Wall","Doublesided Wall","Doublesided Wall","Doublesided Wall","Doublesided Wall","Ledge (R)","Ledge (L)","Ledge (U)","Ledge (D)","60","61","62","Ledge Corner",
			"Spin (R)","Spin (L)","Spin (U)","Spin (D)","68","69","70","71","72","Stair","Stair","Rockclimb (V)","Rockclimb (H)","77","78","79",
			"Water","Water","Water","Water","84","85","Raised Model","Raised Model","Raised Model","Raised Model","90","91","92","93","Warp","Warp",
			"Warp","Warp","Doormat","Doormat","Doormat","Doormat","Warp","Warp","Warp","Warp","Warp","Warp","Warp","Warp","Warp","Warp",
			"Start Bridge","Bridge","Bridge (C)","Bridge (W)","Bridge","Bridge (Sn)","Bike Bridge","Bike Bridge","Bike Bridge","Bike Bridge","Bike Bridge","Bike Bridge (G)","Bike Bridge (W)","Bike Bridge","126","127",
			"Counter","129","130","PC","132","Map","Television","135","Bookcases","137","138","139","140","141","Book","143",
			"144","145","146","147","148","149","150","151","152","153","154","155","156","157","158","159",
			"Soil","Deep Snow 1","Deep Snow 2","Deep Snow 3","Mud","Mud (B)","Mud Grass","Mud Grass (B)","Snow","Melting snow","170","171","172","173","174","175",
			"176","177","178","179","180","181","182","183","184","185","186","187","188","189","190","191",
			"192","193","194","195","196","197","198","199","200","201","202","203","204","205","206","207",
			"208","209","210","211","212","213","214","Bike ramp (R)","Bikeramp (L)","Slope top","Slope bottom","Bikestall","220","221","222","223",
			"Bookcases","Bookcases","Bookcases","227","Thrashbin","Misc Objects","230","231","232","233","234","235","236","237","238","239",
			"240","241","242","243","244","245","246","247","248","249","250","251","252","253","254","Unloaded"
} -- 6 is tree in HGSS

tile_id_list = {
	Grass = {
        color = '#40a',
        ids = {0x2,0x7B}
    },
	Normal = {
        color = nil,
        ids = {0xff}
    },
	Warps = {
        color = '#f03',
        ids ={0x5E,0x5f,0x62,0x63,0x69,0x65,0x6f,0x6D,0x6A,0x6C,0x6E}
	},
	Cave = {
        color = '#bb7410',
        ids = {0x6,0x8,0xC}
	},
	Water = {
        color = '#4888f',
        ids = {0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x17,0x19,0x22,0x2A,0x7C}
    },
    Sand = {
        color = '#e3c',
        ids = {0x21,0x21}
	},
	DeepSnow1 = {
        color = '#8da9cb',
        ids = {0xA1}
    },
    DeepSnow2 = {
        color = '#6483a7',
        ids = {0xA2}
    },
    DeepSnow3 = {
        color = '#52749d',
        ids = {0xA3}
	},
    Mud = {
        color = '#92897',
        ids = {0xA4}
    },
    MudBlocking = {
        color = '#92704',
        ids = {0xA5}
    },
    MudGrass = {
        color = '#4090',
        ids = {0xA6}
    },
    MudGrassBlocking = {
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
        ids = {0x70,0x71,0x72,0x73,0x74,0x75}
	},
    BikeBridge= {
        color = '#C7A55',
        ids = {0x76,0x77,0x78,0x79,0x7A,0x7D}
		-- BikeBridge 0x7C moves to water, 0x7B moved to grass
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
	-- Trees = {
    --     color = '#CCCCC',
    --     ids = {0x6}
    -- }, -- HGSS, remove 0x6 from cave list if used
}

tile_ids = {}

for k,v in pairs(tile_id_list) do
	for i=1,#tile_id_list[k]['ids'] do
		tile_ids[tile_id_list[k]['ids'][i]] = tile_id_list[k]['color']
	end
end



script_commands = {
	[0x1BA] = {
		color = "white",
		param_count = 0
	},
	default = {
		color = "white",
		param_count = 0
	},
	stopcode = {
		color = "#666666",
		param_count = 0

	},
	[0] = {
		color = "#666666",
		param_count = 0
	},
}

script_command_names = { 
	[0x0] = 'Nop', 
	[0x1] = 'Dummy',         
	[0x2] = 'End', 
	[0x3] = 'TimeWait',      
	[0x4] = 'LoadRegValue',  
	[0x5] = 'LoadRegWData',  
	[0x6] = 'LoadRegAdrs',   
	[0x7] = 'LoadAdrsValue', 
	[0x8] = 'LoadAdrsReg',   
	[0x9] = 'LoadRegReg',    
	[0xa] = 'LoadAdrsAdrs',  
	[0xb] = 'CmpRegReg',     
	[0xc] = 'CmpRegValue',   
	[0xd] = 'CmpRegAdrs',    
	[0xe] = 'CmpAdrsReg',    
	[0xf] = 'CmpAdrsValue',  
	[0x10] = 'CmpAdrsAdrs',  
	[0x11] = 'CmpWkValue',   
	[0x12] = 'CmpWkWk',      
	[0x13] = 'VMMachineAdd',
	[0x14] = 'ChangeCommonScr',
	[0x15] = 'ChangeLocalScr',
	[0x16] = 'GlobalJump',
	[0x17] = 'ObjIDJump',
	[0x18] = 'BgIDJump',
	[0x19] = 'PlayerDirJump',
	[0x1a] = 'GlobalCall',
	[0x1b] = 'Ret',
	[0x1c] = 'IfJump',
	[0x1d] = 'IfCall',
	[0x1e] = 'FlagSet',
	[0x1f] = 'FlagReset',
	[0x20] = 'FlagCheck',
	[0x21] = 'FlagCheckWk',
	[0x22] = 'FlagSetWk',
	[0x23] = 'TrainerFlagSet',
	[0x24] = 'TrainerFlagReset',
	[0x25] = 'TrainerFlagCheck',
	[0x26] = 'WkAdd',
	[0x27] = 'WkSub',
	[0x28] = 'LoadWkValue',
	[0x29] = 'LoadWkWk',
	[0x2a] = 'LoadWkWkValue',
	[0x2b] = 'TalkMsgAllPut',
	[0x2c] = 'TalkMsg',
	[0x2d] = 'TalkMsgSp',
	[0x2e] = 'TalkMsgNoSkip',
	[0x2f] = 'TalkConSioMsg',
	[0x30] = 'ABKeyWait',
	[0x31] = 'LastKeyWait',
	[0x32] = 'NextAnmLastKeyWait',
	[0x33] = 'TalkWinOpen',
	[0x34] = 'TalkWinClose',
	[0x35] = 'TalkWinCloseNoClear',
	[0x36] = 'BoardMake',
	[0x37] = 'InfoBoardMake',
	[0x38] = 'BoardReq',
	[0x39] = 'BoardWait',
	[0x3a] = 'BoardMsg',
	[0x3b] = 'BoardEndWait',
	[0x3c] = 'MenuReq',
	[0x3d] = 'BgScroll',
	[0x3e] = 'YesNoWin',
	[0x3f] = 'GuinnessWin',
	[0x40] = 'BmpMenuInit',
	[0x41] = 'BmpMenuInitEx',
	[0x42] = 'BmpMenuMakeList',
	[0x43] = 'BmpMenuStart',
	[0x44] = 'BmpListInit',
	[0x45] = 'BmpListInitEx',
	[0x46] = 'BmpListMakeList',
	[0x47] = 'BmpListStart',
	[0x48] = 'BmpMenuHVStart',
	[0x49] = 'SePlay',
	[0x4a] = 'SeStop',
	[0x4b] = 'SeWait',
	[0x4c] = 'VoicePlay',
	[0x4d] = 'VoicePlayWait',
	[0x4e] = 'MePlay',
	[0x4f] = 'MeWait',
	[0x50] = 'BgmPlay',
	[0x51] = 'BgmStop',
	[0x52] = 'BgmNowMapPlay',
	[0x53] = 'BgmSpecialSet',
	[0x54] = 'BgmFadeOut',
	[0x55] = 'BgmFadeIn',
	[0x56] = 'BgmPlayerPause',
	[0x57] = 'PlayerFieldDemoBgmPlay',
	[0x58] = 'CtrlBgmFlagSet',
	[0x59] = 'PerapDataCheck',
	[0x5a] = 'PerapRecStart',
	[0x5b] = 'PerapRecStop',
	[0x5c] = 'PerapSave',
	[0x5d] = 'SndClimaxDataLoad',
	[0x5e] = 'ObjAnime',
	[0x5f] = 'ObjAnimeWait',
	[0x60] = 'ObjPauseAll',
	[0x61] = 'ObjPauseClearAll',
	[0x62] = 'ObjPause',
	[0x63] = 'ObjPauseClear',
	[0x64] = 'ObjAdd',
	[0x65] = 'ObjDel',
	[0x66] = 'VanishDummyObjAdd',
	[0x67] = 'VanishDummyObjDel',
	[0x68] = 'ObjTurn',
	[0x69] = 'PlayerPosGet',
	[0x6a] = 'ObjPosGet',
	[0x6b] = 'PlayerPosOffsetSet',
	[0x6c] = 'NotZoneDelSet',
	[0x6d] = 'MoveCodeChange',
	[0x6e] = 'PairObjIdSet',
	[0x6f] = 'AddGold',
	[0x70] = 'SubGold',
	[0x71] = 'CompGold',
	[0x72] = 'GoldWinWrite',
	[0x73] = 'GoldWinDel',
	[0x74] = 'GoldWrite',
	[0x75] = 'CoinWinWrite',
	[0x76] = 'CoinWinDel',
	[0x77] = 'CoinWrite',
	[0x78] = 'CheckCoin',
	[0x79] = 'AddCoin',
	[0x7a] = 'SubCoin',
	[0x7b] = 'AddItem',
	[0x7c] = 'SubItem',
	[0x7d] = 'AddItemChk',
	[0x7e] = 'CheckItem',
	[0x7f] = 'WazaMachineItemNoCheck',
	[0x80] = 'GetPocketNo',
	[0x81] = 'AddPCBoxItem',
	[0x82] = 'CheckPCBoxItem',
	[0x83] = 'AddGoods',
	[0x84] = 'SubGoods',
	[0x85] = 'AddGoodsChk',
	[0x86] = 'CheckGoods',
	[0x87] = 'AddTrap',
	[0x88] = 'SubTrap',
	[0x89] = 'AddTrapChk',
	[0x8a] = 'CheckTrap',
	[0x8b] = 'AddTreasure',
	[0x8c] = 'SubTreasure',
	[0x8d] = 'AddTreasureChk',
	[0x8e] = 'CheckTreasure',
	[0x8f] = 'AddTama',
	[0x90] = 'SubTama',
	[0x91] = 'AddTamaChk',
	[0x92] = 'CheckTama',
	[0x93] = 'CBItemNumGet',
	[0x94] = 'CBItemNumAdd',
	[0x95] = 'UnknownFormGet',
	[0x96] = 'AddPokemon',
	[0x97] = 'AddTamago',
	[0x98] = 'ChgPokeWaza',
	[0x99] = 'ChkPokeWaza',
	[0x9a] = 'ChkPokeWazaGroup',
	[0x9b] = 'RevengeTrainerSearch',
	[0x9c] = 'SetWeather',
	[0x9d] = 'InitWeather',
	[0x9e] = 'UpdateWeather',
	[0x9f] = 'GetMapPosition',
	[0xa0] = 'GetTemotiPokeNum',
	[0xa1] = 'SetMapProc',
	[0xa2] = 'WiFiAutoReg',
	[0xa3] = 'WiFiP2PMatchEventCall',
	[0xa4] = 'WiFiP2PMatchSetDel',
	[0xa5] = 'MsgBoyEvent',
	[0xa6] = 'ImageClipSetProc',
	[0xa7] = 'ImageClipPreviewTvProc',
	[0xa8] = 'ImageClipPreviewConProc',
	[0xa9] = 'CustomBallEventCall',
	[0xaa] = 'TMapBGSetProc',
	[0xab] = 'BoxSetProc',
	[0xac] = 'OekakiBoardSetProc',
	[0xad] = 'CallTrCard',
	[0xae] = 'TradeListSetProc',
	[0xaf] = 'RecordCornerSetProc',
	[0xb0] = 'DendouSetProc',
	[0xb1] = 'PcDendouSetProc',
	[0xb2] = 'WorldTradeSetProc',
	[0xb3] = 'DPWInitProc',
	[0xb4] = 'FirstPokeSelectProc',
	[0xb5] = 'FirstPokeSelectSetAndDel',
	[0xb6] = 'EyeTrainerMoveSet',
	[0xb7] = 'EyeTrainerMoveCheck',
	[0xb8] = 'EyeTrainerTypeGet',
	[0xb9] = 'EyeTrainerIdGet',
	[0xba] = 'NameIn',
	[0xbb] = 'NameInPoke',
	[0xbc] = 'WipeFadeStart',
	[0xbd] = 'WipeFadeCheck',
	[0xbe] = 'MapChange',
	[0xbf] = 'KabeNobori',
	[0xc0] = 'Naminori',
	[0xc1] = 'Takinobori',
	[0xc2] = 'Sorawotobu',
	[0xc3] = 'HidenFlash',
	[0xc4] = 'HidenKiribarai',
	[0xc5] = 'CutIn',
	[0xc6] = 'ConHeroChange',
	[0xc7] = 'BicycleCheck',
	[0xc8] = 'BicycleReq',
	[0xc9] = 'CyclingRoadSet',
	[0xca] = 'PlayerFormGet',
	[0xcb] = 'PlayerReqBitOn',
	[0xcc] = 'PlayerReqStart',
	[0xcd] = 'PlayerName',
	[0xce] = 'RivalName',
	[0xcf] = 'SupportName',
	[0xd0] = 'PokemonName',
	[0xd1] = 'ItemName',
	[0xd2] = 'PocketName',
	[0xd3] = 'ItemWazaName',
	[0xd4] = 'WazaName',
	[0xd5] = 'NumberName',
	[0xd6] = 'NickName',
	[0xd7] = 'PoketchName',
	[0xd8] = 'TrTypeName',
	[0xd9] = 'MyTrTypeName',
	[0xda] = 'PokemonNameExtra',
	[0xdb] = 'FirstPokemonName',
	[0xdc] = 'RivalPokemonName',
	[0xdd] = 'SupportPokemonName',
	[0xde] = 'FirstPokeNoGet',
	[0xdf] = 'GoodsName',
	[0xe0] = 'TrapName',
	[0xe1] = 'TamaName',
	[0xe2] = 'ZoneName',
	[0xe3] = 'GenerateInfoGet',
	[0xe4] = 'TrainerIdGet',
	[0xe5] = 'TrainerBattleSet',
	[0xe6] = 'TrainerMessageSet',
	[0xe7] = 'TrainerTalkTypeGet',
	[0xe8] = 'RevengeTrainerTalkTypeGet',
	[0xe9] = 'TrainerTypeGet',
	[0xea] = 'TrainerBgmSet',
	[0xeb] = 'TrainerLose',
	[0xec] = 'TrainerLoseCheck',
	[0xed] = 'SeacretPokeRetryCheck',
	[0xee] = '2vs2BattleCheck',
	[0xef] = 'DebugBattleSet',
	[0xf0] = 'DebugTrainerFlagSet',
	[0xf1] = 'DebugTrainerFlagOnJump',
	[0xf2] = 'ConnectSelParentWin',
	[0xf3] = 'ConnectSelChildWin',
	[0xf4] = 'ConnectDebugParentWin',
	[0xf5] = 'ConnectDebugChildWin',
	[0xf6] = 'DebugSioEncount',
	[0xf7] = 'DebugSioContest',
	[0xf8] = 'ConSioTimingSend',
	[0xf9] = 'ConSioTimingCheck',
	[0xfa] = 'ConSystemCreate',
	[0xfb] = 'ConSystemExit',
	[0xfc] = 'ConJudgeNameGet',
	[0xfd] = 'ConBreederNameGet',
	[0xfe] = 'ConNickNameGet',
	[0xff] = 'ConNumTagSet',
	[0x100] = 'ConSioParamInitSet',
	[0x101] = 'ContestProc',
	[0x102] = 'ConRankNameGet',
	[0x103] = 'ConTypeNameGet',
	[0x104] = 'ConVictoryBreederNameGet',
	[0x105] = 'ConVictoryItemNoGet',
	[0x106] = 'ConVictoryNickNameGet',
	[0x107] = 'ConRankingCheck',
	[0x108] = 'ConVictoryEntryNoGet',
	[0x109] = 'ConMyEntryNoGet',
	[0x10a] = 'ConObjCodeGet',
	[0x10b] = 'ConPopularityGet',
	[0x10c] = 'ConDeskModeGet',
	[0x10d] = 'ConHaveRibbonCheck',
	[0x10e] = 'ConRibbonNameGet',
	[0x10f] = 'ConAcceNoGet',
	[0x110] = 'ConEntryParamGet',
	[0x111] = 'ConCameraFlashSet',
	[0x112] = 'ConCameraFlashCheck',
	[0x113] = 'ConHBlankStop',
	[0x114] = 'ConHBlankStart',
	[0x115] = 'ConEndingSkipCheck',
	[0x116] = 'ConRecordDisp',
	[0x117] = 'ConMsgPrintFlagSet',
	[0x118] = 'ConMsgPrintFlagReset',
	[0x119] = 'ChkTemotiPokerus',
	[0x11a] = 'TemotiPokeSexGet',
	[0x11b] = 'SpLocationSet',
	[0x11c] = 'ElevatorNowFloorGet',
	[0x11d] = 'ElevatorFloorWrite',
	[0x11e] = 'GetShinouZukanSeeNum',
	[0x11f] = 'GetShinouZukanGetNum',
	[0x120] = 'GetZenkokuZukanSeeNum',
	[0x121] = 'GetZenkokuZukanGetNum',
	[0x122] = 'ChkZenkokuZukan',
	[0x123] = 'GetZukanHyoukaMsgID',
	[0x124] = 'WildBattleSet',
	[0x125] = 'FirstBattleSet',
	[0x126] = 'CaptureBattleSet',
	[0x127] = 'HoneyTree',
	[0x128] = 'GetHoneyTreeState',
	[0x129] = 'HoneyTreeBattleSet',
	[0x12a] = 'HoneyAfterTreeBattleSet',
	[0x12b] = 'TSignSetProc',
	[0x12c] = 'ReportSaveCheck',
	[0x12d] = 'ReportSave',
	[0x12e] = 'ImageClipTvSaveDataCheck',
	[0x12f] = 'ImageClipConSaveDataCheck',
	[0x130] = 'ImageClipTvSaveTitle',
	[0x131] = 'GetPoketch',
	[0x132] = 'GetPoketchFlag',
	[0x133] = 'PoketchAppAdd',
	[0x134] = 'PoketchAppCheck',
	[0x135] = 'CommTimingSyncStart',
	[0x136] = 'CommTempDataReset',
	[0x137] = 'UnionParentCardTalkNo',
	[0x138] = 'UnionGetInfoTalkNo',
	[0x139] = 'UnionBeaconChange',
	[0x13a] = 'UnionConnectTalkDenied',
	[0x13b] = 'UnionConnectTalkOk',
	[0x13c] = 'UnionTrainerNameRegist',
	[0x13d] = 'UnionReturnSetUp',
	[0x13e] = 'UnionConnectCutRestart',
	[0x13f] = 'UnionGetTalkNumber',
	[0x140] = 'UnionIdSet',
	[0x141] = 'UnionResultGet',
	[0x142] = 'UnionObjAllVanish',
	[0x143] = 'UnionScriptResultSet',
	[0x144] = 'UnionParentStartCommandSet',
	[0x145] = 'UnionChildSelectCommandSet',
	[0x146] = 'UnionConnectStart',
	[0x147] = 'ShopCall',
	[0x148] = 'FixShopCall',
	[0x149] = 'FixGoodsCall',
	[0x14a] = 'FixSealCall',
	[0x14b] = 'GameOverCall',
	[0x14c] = 'SetWarpId',
	[0x14d] = 'GetMySex',
	[0x14e] = 'PcKaifuku',
	[0x14f] = 'UgManShopNpcRandomPlace',
	[0x150] = 'CommDirectEnd',
	[0x151] = 'CommDirectEnterBtlRoom',
	[0x152] = 'CommPlayerSetDir',
	[0x153] = 'UnionMapChange',
	[0x154] = 'UnionViewSetUpTrainerTypeSelect',
	[0x155] = 'UnionViewGetTrainerType',
	[0x156] = 'UnionViewMyStatusSet',
	[0x157] = 'SysFlagZukanGet',
	[0x158] = 'SysFlagZukanSet',
	[0x159] = 'SysFlagShoesGet',
	[0x15a] = 'SysFlagShoesSet',
	[0x15b] = 'SysFlagBadgeGet',
	[0x15c] = 'SysFlagBadgeSet',
	[0x15d] = 'SysFlagBadgeCount',
	[0x15e] = 'SysFlagBagGet',
	[0x15f] = 'SysFlagBagSet',
	[0x160] = 'SysFlagPairGet',
	[0x161] = 'SysFlagPairSet',
	[0x162] = 'SysFlagPairReset',
	[0x163] = 'SysFlagOneStepGet',
	[0x164] = 'SysFlagOneStepSet',
	[0x165] = 'SysFlagOneStepReset',
	[0x166] = 'SysFlagGameClearGet',
	[0x167] = 'SysFlagGameClearSet',
	[0x168] = 'SetUpDoorAnime',
	[0x169] = 'Wait3DAnime',
	[0x16a] = 'Free3DAnime',
	[0x16b] = 'OpenDoor',
	[0x16c] = 'CloseDoor',
	[0x16d] = 'GetSodateyaName',
	[0x16e] = 'GetSodateyaZiisan',
	[0x16f] = 'InitWaterGym',
	[0x170] = 'PushWaterGymButton',
	[0x171] = 'InitGhostGym',
	[0x172] = 'MoveGhostGymLift',
	[0x173] = 'InitSteelGym', 
	[0x174] = 'InitCombatGym',
	[0x175] = 'InitElecGym',
	[0x176] = 'RotElecGymGear',
	[0x177] = 'GetPokeCount',
	[0x178] = 'BagSetProc',
	[0x179] = 'BagGetResult',
	[0x17a] = 'PocketCheck',
	[0x17b] = 'NutsName',
	[0x17c] = 'SeikakuName',
	[0x17d] = 'SeedGetStatus',
	[0x17e] = 'SeedGetType',
	[0x17f] = 'SeedGetCompost',
	[0x180] = 'SeedGetGroundStatus',
	[0x181] = 'SeedGetNutsCount',
	[0x182] = 'SeedSetCompost',
	[0x183] = 'SeedSetNuts',
	[0x184] = 'SeedSetWater',
	[0x185] = 'SeedTakeNuts',
	[0x186] = 'SxyPosChange',
	[0x187] = 'ObjPosChange',
	[0x188] = 'SxyMoveCodeChange',
	[0x189] = 'SxyDirChange',
	[0x18a] = 'SxyExitPosChange',
	[0x18b] = 'SxyBgPosChange',
	[0x18c] = 'ObjDirChange',
	[0x18d] = 'TimeWaitIconAdd',
	[0x18e] = 'TimeWaitIconDel',
	[0x18f] = 'ReturnScriptWkSet',
	[0x190] = 'ABKeyTimeWait',
	[0x191] = 'PokeListSetProc',
	[0x192] = 'UnionPokeListSetProc',
	[0x193] = 'PokeListGetResult',
	[0x194] = 'ConPokeListSetProc',
	[0x195] = 'ConPokeListGetResult',
	[0x196] = 'ConPokeStatusSetProc',
	[0x197] = 'PokeStatusGetResult',
	[0x198] = 'TemotiMonsNo',
	[0x199] = 'MonsOwnChk',
	[0x19a] = 'GetPokeCount2',
	[0x19b] = 'GetPokeCount3',
	[0x19c] = 'GetPokeCount4',
	[0x19d] = 'GetTamagoCount',
	[0x19e] = 'UgShopMenuInit',
	[0x19f] = 'UgShopTalkStart',
	[0x1a0] = 'UgShopTalkEnd',
	[0x1a1] = 'UgShopTalkRegisterItemName',
	[0x1a2] = 'UgShopTalkRegisterTrapName',
	[0x1a3] = 'SubMyGold',
	[0x1a4] = 'HikitoriPoke',
	[0x1a5] = 'HikitoriList',
	[0x1a6] = 'MsgSodateyaAishou',
	[0x1a7] = 'MsgExpandBuf',
	[0x1a8] = 'DelSodateyaEgg',
	[0x1a9] = 'GetSodateyaEgg',
	[0x1aa] = 'HikitoriRyoukin',
	[0x1ab] = 'CompMyGold',
	[0x1ac] = 'TamagoDemo',
	[0x1ad] = 'SodateyaPokeList',
	[0x1ae] = 'SodatePokeLevelStr',
	[0x1af] = 'MsgAzukeSet',
	[0x1b0] = 'SetSodateyaPoke',
	[0x1b1] = 'ObjVisible',
	[0x1b2] = 'ObjInvisible',
	[0x1b3] = 'MailBox',
	[0x1b4] = 'GetMailBoxDataNum',
	[0x1b5] = 'RankingView',
	[0x1b6] = 'GetTimeZone',
	[0x1b7] = 'GetRand',
	[0x1b8] = 'GetRandNext',
	[0x1b9] = 'GetNatsuki',
	[0x1ba] = 'AddNatsuki',
	[0x1bb] = 'SubNatsuki',
	[0x1bc] = 'HikitoriListNameSet',
	[0x1bd] = 'PlayerDirGet',
	[0x1be] = 'GetSodateyaAishou',
	[0x1bf] = 'GetSodateyaTamagoCheck',
	[0x1c0] = 'TemotiPokeChk',
	[0x1c1] = 'OokisaRecordChk',
	[0x1c2] = 'OokisaRecordSet',
	[0x1c3] = 'OokisaTemotiSet',
	[0x1c4] = 'OokisaKirokuSet',
	[0x1c5] = 'OokisaKurabeInit',
	[0x1c6] = 'WazaListSetProc',
	[0x1c7] = 'WazaListGetResult',
	[0x1c8] = 'WazaCount',
	[0x1c9] = 'WazaDel',
	[0x1ca] = 'TemotiWazaNo',
	[0x1cb] = 'TemotiWazaName',
	[0x1cc] = 'FNoteStartSet',
	[0x1cd] = 'FNoteDataMake',
	[0x1ce] = 'FNoteDataSave',
	[0x1cf] = 'SysFlagKairiki',
	[0x1d0] = 'SysFlagFlash',
	[0x1d1] = 'SysFlagKiribarai',
	[0x1d2] = 'ImcAcceAddItem',
	[0x1d3] = 'ImcAcceAddItemChk',
	[0x1d4] = 'ImcAcceCheckItem',
	[0x1d5] = 'ImcBgAddItem',
	[0x1d6] = 'ImcBgCheckItem',
	[0x1d7] = 'NutMixerProc',
	[0x1d8] = 'NutMixerPlayStateCheck',
	[0x1d9] = 'BTowerAppSetProc',
	[0x1da] = 'BattleTowerWorkClear',
	[0x1db] = 'BattleTowerWorkInit',
	[0x1dc] = 'BattleTowerWorkRelease',
	[0x1dd] = 'BattleTowerTools',
	[0x1de] = 'BattleTowerGetSevenPokeData',
	[0x1df] = 'BattleTowerIsPrizeGet',
	[0x1e0] = 'BattleTowerIsPrizemanSet',
	[0x1e1] = 'BattleTowerSendBuf',
	[0x1e2] = 'BattleTowerRecvBuf',
	[0x1e3] = 'BattleTowerGetLeaderRoomID',
	[0x1e4] = 'BattleTowerIsLeaderDataExist',
	[0x1e5] = 'RecordInc',
	[0x1e6] = 'RecordGet',
	[0x1e7] = 'RecordSet',
	[0x1e8] = 'ZukanChkShinou',
	[0x1e9] = 'ZukanChkNational',
	[0x1ea] = 'ZukanRecongnizeShinou',
	[0x1eb] = 'ZukanRecongnizeNational',
	[0x1ec] = 'UrayamaEncountSet',
	[0x1ed] = 'UrayamaEncountNoChk',
	[0x1ee] = 'PokeMailChk',
	[0x1ef] = 'PaperplaneSet',
	[0x1f0] = 'PokeMailDel',
	[0x1f1] = 'KasekiCount',
	[0x1f2] = 'ItemListSetProc',
	[0x1f3] = 'ItemListGetResult',
	[0x1f4] = 'ItemNoToMonsNo',
	[0x1f5] = 'KasekiItemNo',
	[0x1f6] = 'PokeLevelChk',
	[0x1f7] = 'ApprovePoisonDead',
	[0x1f8] = 'FinishMapProc',
	[0x1f9] = 'DebugWatch',
	[0x1fa] = 'TalkMsgAllPutOtherArc',
	[0x1fb] = 'TalkMsgOtherArc',
	[0x1fc] = 'TalkMsgAllPutPMS',
	[0x1fd] = 'TalkMsgPMS',
	[0x1fe] = 'TalkMsgTowerApper',
	[0x1ff] = 'TalkMsgNgPokeName',
	[0x200] = 'GetBeforeZoneID',
	[0x201] = 'GetNowZoneID',
	[0x202] = 'SafariControl',
	[0x203] = 'ColosseumMapChangeIn',
	[0x204] = 'ColosseumMapChangeOut',
	[0x205] = 'WifiEarthSetProc',
	[0x206] = 'CallSafariScope',
	[0x207] = 'CommGetCurrentID',
	[0x208] = 'PokeWindowPut',
	[0x209] = 'PokeWindowDel',
	[0x20a] = 'BtlSearcherEventCall',
	[0x20b] = 'BtlSearcherDirMvSet',
	[0x20c] = 'MsgAutoGet',
	[0x20d] = 'ClimaxDemoCall',
	[0x20e] = 'InitSafariTrain',
	[0x20f] = 'MoveSafariTrain',
	[0x210] = 'CheckSafariTrain',
	[0x211] = 'PlayerHeightValid',
	[0x212] = 'GetPokeSeikaku',
	[0x213] = 'ChkPokeSeikakuAll',
	[0x214] = 'UnderGroundTalkCount',
	[0x215] = 'NaturalParkWalkCountClear',
	[0x216] = 'NaturalParkWalkCountGet',
	[0x217] = 'NaturalParkAccessoryNoGet',
	[0x218] = 'GetNewsPokeNo',
	[0x219] = 'NewsCountSet',
	[0x21a] = 'NewsCountChk',
	[0x21b] = 'StartGenerate',
	[0x21c] = 'AddMovePoke',
	[0x21d] = 'RandomGroup',
	[0x21e] = 'OshieWazaCount',
	[0x21f] = 'RemaindWazaCount',
	[0x220] = 'OshieWazaListSetProc',
	[0x221] = 'RemaindWazaListSetProc',
	[0x222] = 'OshieWazaListGetResult',
	[0x223] = 'RemaindWazaListGetResult',
	[0x224] = 'NormalWazaListSetProc',
	[0x225] = 'NormalWazaListGetResult',
	[0x226] = 'FldTradeAlloc',
	[0x227] = 'FldTradeMonsno',
	[0x228] = 'FldTradeChgMonsno',
	[0x229] = 'FldTradeEvent',
	[0x22a] = 'FldTradeDel',
	[0x22b] = 'ZukanTextVerUp',
	[0x22c] = 'ZukanSexVerUp',
	[0x22d] = 'ZenkokuZukanFlag',
	[0x22e] = 'ChkRibbonCount',
	[0x22f] = 'ChkRibbonCountAll',
	[0x230] = 'ChkRibbon',
	[0x231] = 'SetRibbon',
	[0x232] = 'RibbonName',
	[0x233] = 'ChkPrmExp',
	[0x234] = 'ChkWeek',
	[0x235] = 'BroadcastTV',
	[0x236] = 'TVEntryWatchHideItem',
	[0x237] = 'TVInterview',
	[0x238] = 'TVInterviewerCheck',
	[0x239] = 'RegulationListCall',
	[0x23a] = 'AshiatoChk',
	[0x23b] = 'PcRecoverAnm',
	[0x23c] = 'ElevatorAnm',
	[0x23d] = 'CallShipDemo',
	[0x23e] = 'MysteryPostMan',
	[0x23f] = 'DebugPrintWork',
	[0x240] = 'DebugPrintFlag',
	[0x241] = 'DebugPrintWorkStationed',
	[0x242] = 'DebugPrintFlagStationed',
	[0x243] = 'PMSInputSingleProc',
	[0x244] = 'PMSInputDoubleProc',
	[0x245] = 'PMSBuf',
	[0x246] = 'PMVersionGet',
	[0x247] = 'FrontPokemon',
	[0x248] = 'TemotiPokeType',
	[0x249] = 'AikotobaKabegamiSet',
	[0x24a] = 'GetUgHataNum',
	[0x24b] = 'SetUpPasoAnime',
	[0x24c] = 'StartPasoOnAnime',
	[0x24d] = 'StartPasoOffAnime',
	[0x24e] = 'GetKujiAtariNum',
	[0x24f] = 'KujiAtariChk',
	[0x250] = 'KujiAtariInit',
	[0x251] = 'NickNamePC',
	[0x252] = 'PokeBoxCountEmptySpace',
	[0x253] = 'PokeParkControl',
	[0x254] = 'PokeParkDepositCount',
	[0x255] = 'PokeParkTransMons',
	[0x256] = 'PokeParkGetScore',
	[0x257] = 'AcceShopCall',
	[0x258] = 'ReportDrawProcSet',
	[0x259] = 'ReportDrawProcDel',
	[0x25a] = 'DendouBallAnm',
	[0x25b] = 'InitFldLift',
	[0x25c] = 'MoveFldLift',
	[0x25d] = 'CheckFldLift',
	[0x25e] = 'SetupRAHCyl',
	[0x25f] = 'StartRAHCyl',
	[0x260] = 'AddScore',
	[0x261] = 'AcceName',
	[0x262] = 'PartyMonsNoCheck',
	[0x263] = 'PartyDeokisisuFormChange',
	[0x264] = 'CheckMinomuchiComp',
	[0x265] = 'PoketchHookSet',
	[0x266] = 'PoketchHookReset',
	[0x267] = 'SlotMachine',
	[0x268] = 'GetNowHour',
	[0x269] = 'ObjShakeAnm',
	[0x26a] = 'ObjBlinkAnm',
	[0x26b] = '_D20R0106Legend_IsUnseal',
	[0x26c] = 'DressingImcAcceCheck',
	[0x26d] = 'TalkMsgUnknownFont',
	[0x26e] = 'AgbCartridgeVerGet',
	[0x26f] = 'UnderGroundTalkCountClear',
	[0x270] = 'HideMapStateChange',
	[0x271] = 'NameInStone',
	[0x272] = 'MonumantName',
	[0x273] = 'ImcBgNameSet',
	[0x274] = 'CompCoin',
	[0x275] = 'SlotRentyanChk',
	[0x276] = 'AddCoinChk',
	[0x277] = 'LevelJijiiNo',
	[0x278] = 'PokeLevelGet',
	[0x279] = 'ImcAcceSubItem',
	[0x27a] = 'c08r0801ScopeCameraSet',
	[0x27b] = 'LevelJijiiInit',
	[0x27c] = 'TVEntryParkInfo',
	[0x27d] = 'NewNankaiWordSet',
	[0x27e] = 'RegularCheck',
	[0x27f] = 'NankaiWordCompleteCheck',
	[0x280] = 'NumberNameEx',
	[0x281] = 'TemotiPokeContestStatusGet',
	[0x282] = 'BirthDayCheck',
	[0x283] = 'SndInitialVolSet',
	[0x284] = 'AnoonSeeNum',
	[0x285] = 'D17SystemMapSelect',
	[0x286] = 'UnderGroundToolGiveCount',
	[0x287] = 'UnderGroundKasekiDigCount',
	[0x288] = 'UnderGroundTrapHitCount',
	[0x289] = 'PofinAdd',
	[0x28a] = 'PofinAddCheck',
	[0x28b] = 'IsHaihuEventEnable',
	[0x28c] = 'PokeWindowPutPP',
	[0x28d] = 'PokeWindowAnm',
	[0x28e] = 'PokeWindowAnmWait',
	[0x28f] = 'DendouNumGet',
	[0x290] = 'SodateyaPokeListSetProc',
	[0x291] = 'SodateyaPokeListGetResult',
	[0x292] = 'GetRandomHit',
	[0x293] = 'UnderGroundTalkCount2',
	[0x294] = 'BtlPointWinWrite',
	[0x295] = 'BtlPointWinDel',
	[0x296] = 'BtlPointWrite',
	[0x297] = 'CheckBtlPoint',
	[0x298] = 'AddBtlPoint',
	[0x299] = 'SubBtlPoint',
	[0x29a] = 'CompBtlPoint',
	[0x29b] = 'GetBtlPointGift',
	[0x29c] = 'UnionViewGetTrainerTypeNo',
	[0x29d] = 'BmpMenuMakeList16',
	[0x29e] = 'HidenEffStart',
	[0x29f] = 'Zishin',
	[0x2a0] = 'TrainerMultiBattleSet',
	[0x2a1] = 'ObjAnimePos',
	[0x2a2] = 'UgBallCheck',
	[0x2a3] = 'CheckMyGSID',
	[0x2a4] = 'GetFriendDataNum',
	[0x2a5] = 'NpcTradePokeListSetProc',
	[0x2a6] = 'GetCoinGift',
	[0x2a7] = 'AusuItemCheck',
	[0x2a8] = 'SubWkCoin',
	[0x2a9] = 'CompWkCoin',
	[0x2aa] = 'AikotobaOkurimonoChk',
	[0x2ab] = 'CBSealKindNumGet',
	[0x2ac] = 'WifiHusiginaokurimonoOpenFlagSet',
	[0x2ad] = 'MoveCodeGet',
	[0x2ae] = 'BgmPlayCheck',
	[0x2af] = 'UnionGetCardTalkNo',
	[0x2b0] = 'WirelessIconEasy',
	[0x2b1] = 'WirelessIconEasyEnd',
	[0x2b2] = 'SaveFieldObj',
	[0x2b3] = 'SealName',
	[0x2b4] = 'TalkObjPauseAll',
	[0x2b5] = 'SetEscapeLocation',
	[0x2b6] = 'FieldObjBitSetFellowHit',
	[0x2b7] = 'DameTamagoChkAll',
	[0x2b8] = 'TVEntryWatchChangeName',
	[0x2b9] = 'UnionBmpMenuStart',
	[0x2ba] = 'UnionBattleStartCheck',
	[0x2bb] = 'CommDirectEndTiming',
	[0x2bc] = 'HaifuPokeRetryCheck',
	[0x2bd] = 'SpWildBattleSet',
	[0x2be] = 'GetCardRank',
	[0x2bf] = 'BicycleReqNonBgm',
	[0x2c0] = 'TalkMsgSpAuto',
	[0x2c1] = 'ReportInfoWinOpen',
	[0x2c2] = 'ReportInfoWinClose',
	[0x2c3] = 'FieldScopeModeSet',
	[0x2c6] = 'SpinTradeUnion',
	[0x2c7] = 'CheckVersionGame',
	[0x2ca] = 'FloralClockAnimation',
	[0x328] = 'PortalEffect',
	[0x347] = 'DisplayFloor',
	[0x402] = 'ExitMarsh'
}

data_tables = {
	--1 DP and PD demo
	{	
		item_struct_offs = 0x838,
		step_counter_offs = 0x1384,

		-- start of structure offsets/structure data
		player_live_struct_offs = 0x1440,
		signature_offs = 0x5B15,
		signature_size = 0x600,
	
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
		opcode_pointer =  0x29500, -- affected by bt

		memory_state_check_val = 0x2C9EC,
	
		menu_data = 0x29434,
		current_pocket_index_offs = 0x2977C,
		hall_of_fame_struct_offs = 0x2C298,
		hall_of_fame_entry_size = 0x3C,


		ug_revealing_circle_struct_offs = 0x115150,
		ug_trap_struct_offs = 0x12B5B0,
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

generic_npc_struct = { -- -0x10 everything bitch
	sprite_id_16 = start_npc_struct + 0x10,
	obj_code_16 = start_npc_struct + 0x12,
	move_code_16 = start_npc_struct + 0x14,
	event_type_16 = start_npc_struct + 0x16,
	event_flag_16 = start_npc_struct + 0x18,
	
	event_index_16 = start_npc_struct + 0x20,
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
	current_subchunk_8 = 0xAD,
	x_target_subpixel_16 = 0xCC,
	x_target_16 = 0xCE,
	y_target_subpixel_16 = 0xD0,
	y_target_16 = 0xD2,
	z_target_subpixel_16 = 0xD4,
	z_target_16 = 0xD6,
	load_state = 0xE4,
	
	
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
	{"mails_pocket",start_item_struct + 0x4EC, start_item_struct + 0x51C},
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

script_execution_struct = {
	opcode_pointer = data_table["opcode_pointer"]
}

start_hall_of_fame_struct = data_table["hall_of_fame_struct_offs"]
start_species_struct = 0x20

hall_of_fame_struct = {
	specie_struct = {
		species_id_16 = 0x4,
		level_16 = 0x6,
		pid_32 = 0x8,
		tid_16 = 0xC,
		sid_16 = 0xE,
		poke_name = 0x10,
		trainer_name = 0x26,
		move_1_16 = 0x36,
		move_2_16 = 0x38,
		move_3_16 = 0x3A,
		move_4_16 = 0x3C,
		dummy_16 = 0x3E
		},
	year_16 = 0x168,
	month_8 = 0x18A,
	day_8 = 0x18C
}

-- MATH, INPUT, FORMATTING, NON-GAMEPLAY RELATED FUNCTIONS

function fmt(arg,len)
    return string.format("%0"..len.."X", bit.band(4294967295, arg))
end

function print_to_screen(x,y,txt,clr,screen)
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

function check_btn_ints()
	for i=0,9 do
		if check_key(""..i) or check_key("Number"..i) then return i end 
	end 
end

hex_num = {"A","B","C","D","E","F"}

function check_btn_hex()
	for i=0,9 do
		if check_key(""..i) or check_key("Number"..i) then return i end 
	end 

	for i,hex in ipairs(hex_num) do
		if check_key(hex) then return i+9 end
	end 
end


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

function check_keys_continuous(btns)
	pressed_key_count = 0
	for btn =1,#btns do
		if key[btns[btn]] then 	
				pressed_key_count = pressed_key_count + 1
		end 
	end
	return pressed_key_count
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
	stylus_.touch = false
	stylus.set(stylus_)
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
			-- debug_print("item found with id "..fmt(item_id,4).." or id "..fmt(item_id2,4).." at addr "..fmt(current_addr,8).." in "..item_pocket_struct[pocket_id+1][1])
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
				-- debug_print("item found with id "..fmt(item_id,4).." at addr "..fmt(current_addr,8).." in "..item_pocket_struct[pocket_id+1][1])
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

item_list = {
	[0x1AC]="Explorer Kit",
	[0x4F]="Repel"}

function use_item(item_id,menu_open)
	debug_print("Using item: "..item_list[item_id])
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
			debug_print("crash handler")
			press_button("A")
			sleep(2)
			wait_frames(650)
			press_button("A")
			wait_frames(80)
			press_button("A")
			wait_frames(200)
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
	debug_print("Ledgecancel performed")
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
	debug_print("resetting")
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
	debug_print("Performing wrong warp")
	mash_button("A",400)
	wait_frames(350)
	mash_button("A",8)
	wait_frames(600)
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
	debug_print("Graphic reload")
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
	tap_touch_screen(115,120,1)
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
	if show_steps then debug_print(steps.." N") end
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
	if show_steps then debug_print(steps.." W") end
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
	if show_steps then debug_print(steps.." S") end
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
	if show_steps then debug_print(steps.." E") end
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
	debug_print("Trying to get encounter...")
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
	debug_print("Catching Pokemon")
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


function nib(byte)
	l_nib = bit.rshift(byte,4)
	h_nib = bit.band(byte,0xF)
	return {l_nib,h_nib}

end 

function bin(num,bits)
	local t = {}
	for b=bits,1,-1 do
		rest = math.fmod(num,2)
		t[b] = rest
		num = (num-rest)/2
	end 
	return t
end 

start_signature_x = 30
start_signature_y = 70

function write_signature(byte_array)
	row = 0
	col = 0
	region = 0

	for byte = 0,#byte_array do

		row = (row + 1)%8
	end 



end

show_steps = true 

function auto_calc_input()
	for i = 0,calc_input do
	end 
end 

function press_equal_sign()

end 

function auto_movement()
	press_button("down",2)
	wait_frames(20)
	press_button("X",2)
	mash_button("A",20)
	-- print("Hello")
	-- -- press_buttons({"up","down","left","right"},60)
	-- tap_touch_screen(35,71,2)
	-- tap_touch_screen(65,121,2)
end 

map_editing =  false 

function toggle_map_editing()
	map_editing = not map_editing 
	temp_map_id = ""
end


function change_map_id()
	value = check_btn_ints()
	if value ~= nil then 
		temp_map_id = temp_map_id..value
		memory.writeword(base + live_struct["map_id_32"],tonumber(temp_map_id))
	end
	if (#temp_map_id > 4) or (key.enter) then
		temp_map_id = tonumber(temp_map_id)
		if temp_map_id > 65535 then
			temp_map_id = 65535
		end 
		memory.writeword(base + live_struct["map_id_32"],temp_map_id)
		map_editing = false
	end
end 

memory_editing = false


function toggle_memory_addr_editing()
	memory_editing = not memory_editing
	temp_memory_addr = 0
	temp_str_memory_addr = "0"
end

function change_memory_addr()
	value = check_btn_hex()
	if value ~= nil then 
		if #temp_str_memory_addr < 7 then 
			temp_memory_addr = bit.lshift(temp_memory_addr,4) + value 
			temp_str_memory_addr = fmt(temp_memory_addr,0)
			return
		end 
	end

	if key.enter then
		memview_addr = temp_memory_addr - temp_memory_addr%16
		memory_editing = false
		scroll = 0
		return
	end

	if check_key("backspace") then 
		temp_memory_addr = bit.rshift(temp_memory_addr,4)
		temp_str_memory_addr = fmt(temp_memory_addr,0)
	end

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
	x_phys_32 = memory.readword(base + player_struct["x_phys_32"] + memory_shift)
	z_phys_32 = memory.readword(base + player_struct["z_phys_32"] + memory_shift) 
	map_id_phys_32 =  memory.readword(base + live_struct["map_id_32"])
	print_to_screen(10,30,"Physical:","yellow")
	print_to_screen(20,40,"X: "..x_phys_32..","..fmt(x_phys_32,4),"yellow")
	print_to_screen(20,50,"Z: "..z_phys_32..","..fmt(z_phys_32,4),"yellow")
	print_to_screen(20,60,"Map Id: "..map_id_phys_32..","..fmt(map_id_phys_32,4),"yellow")
	x_stored_warp_16 = memory.readword(base + live_struct["x_stored_warp_16"])
	z_stored_warp_16 = memory.readword(base + live_struct["z_stored_warp_16"])	
	print_to_screen(10,70,"Stored Warp:","yellow")
	print_to_screen(20,80,"X: "..x_stored_warp_16..","..fmt(x_stored_warp_16,4),"yellow")
	print_to_screen(20,90,"Z: "..z_stored_warp_16..","..fmt(z_stored_warp_16,4),"yellow")
	
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
	show_objects()
	show_triggers()
	show_warps()
	-- data that is unique to overworld
end 

--
menu_id = 0
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

			print_to_screen(3 + row*25,3 + col*10,c_map_id,clr,2)
		end 
	end 
end

function split_word_into_bytes(word)
	h_byte = bit.rshift(word,8)
	l_byte = bit.band(word,0xFF)
	return {l_byte,h_byte}
end 

-- Loadlines and grid

grid = false
loadlines = true 
maplines = false
mapmodellines = false

function toggle_grid()
	grid = not grid
end 

function toggle_loadlines()
	loadlines = not loadlines
end 

function toggle_maplines()
	maplines = not maplines
end

function toggle_mapmodellines()
	mapmodellines = not mapmodellines
end

function show_boundary_lines()
	if grid then show_gridlines() end
	if loadlines then show_loadlines() end
	if maplines then show_maplines() end
	if mapmodellines then show_mapmodellines() end 
end 

function show_gridlines()
	for i = 0,15 do draw_line(i*16+7,0,0,200, "#0FB58") end 
	for i = 0,7 do draw_line(0,i*13,256,0, "#0FB58") end
	for i = 0,6 do draw_line(0,7*13+15.5*i,256,0, "#0FB58") end
end 

function show_loadlines()
	x_cam_16 = memory.readword(base + player_struct["x_cam_16"] + memory_shift)
	z_cam_16 = memory.readword(base + player_struct["z_cam_16"] + memory_shift)

	add_x = 0
	add_y = 0
	if x_cam_16 > 0x7FFF then 
		add_x = 1
	end 
	if z_cam_16 > 0x7FFF then 
		add_y = 1
	end 

	x_line = (-x_cam_16+23)%32 - add_x
	z_line = (-z_cam_16+23)%32 - add_y + add_x
	draw_line(x_line*16+7,0,0,200, "red")
	if z_line < 14 then 
		if z_line > 7 then draw_line(0,7*13+(z_line-7)*15.5,256,0, "red") return end
		draw_line(0,13*z_line,256,0, "red")
	end 
end

function show_maplines()
	x_phys_32 = memory.readdword(base + player_struct["x_phys_32"] + memory_shift)
	z_phys_32 = memory.readdword(base + player_struct["z_phys_32"] + memory_shift)

	add_x = 0
	add_y = 0
	if x_phys_32 > 0x7FFF then 
		add_x = 1
	end 
	if z_phys_32 > 0x7FFF then 
		add_y = 1
	end 

	x_line = (-x_phys_32+7)%32 + add_x
	z_line = (-z_phys_32+7)%32 + add_y
	draw_line(x_line*16+7,0,0,200, "blue")
	if z_line < 14 then 
		if z_line > 7 then draw_line(0,7*13+(z_line-7)*15.5,256,0, "blue") return end
		draw_line(0,13*z_line,256,0, "blue")
	end 

end  

function show_mapmodellines()
	x_cam_16 = memory.readword(base + player_struct["x_cam_16"] + memory_shift)
	z_cam_16 = memory.readword(base + player_struct["z_cam_16"] + memory_shift)
	x_line = (-x_cam_16+7)%32
	z_line = (-z_cam_16+7)%32
	draw_line(x_line*16+7,0,0,200, "orange")
	if z_line < 14 then 
		if z_line > 7 then draw_line(0,7*13+(z_line-7)*15.5,256,0, "orange") return end
		draw_line(0,13*z_line,256,0, "orange")
	end

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
	show_tile_data()
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

show_load_calculations = false

function toggle_load_calculations()
	show_load_calculations = not show_load_calculations
end 

debug_tile_print = false
function toggle_debug_tile_print()
	debug_tile_print = not debug_tile_print
end 

function show_tile_data()
	tile_id = memory.readbyte(base + player_struct["tile_type_16_1"] + memory_shift)
	-- current_tile_2 = memory.readbyte(base + player_struct["tile_type_16_2"] + memory_shift) -- slower
	print_to_screen(143,15,"Tile: "..tile_id..","..fmt(tile_id,2),'yellow')
	print_to_screen(143,25,tile_names[tile_id+1],'yellow')

	start_chunk_struct = memory.readdword(base+data_table["chunk_calculation_ptr"])
	print_to_screen(143,35,"Loading:",'yellow')
	load_state = memory.readbyte(start_chunk_struct + chunk_struct["load_state"])
	if load_state == 0 then
		print_to_screen(198,35,"true",'green')
		
	else 
		print_to_screen(198,35,"false",'red')
	end
	
	if show_load_calculations then 
		x_target_16 = memory.readword(start_chunk_struct + chunk_struct["x_target_16"])
		z_target_16 = memory.readword(start_chunk_struct + chunk_struct["z_target_16"])
		print_to_screen(143,45,"Target:",'yellow')
		print_to_screen(143,55,"    X: "..x_target_16..","..fmt(x_target_16,4),'yellow')
		print_to_screen(143,65,"    Z: "..z_target_16..","..fmt(z_target_16,4),'yellow')

		x_cam_16 = memory.readword(base + player_struct["x_cam_16"] + memory_shift)
		z_cam_16 = memory.readword(base + player_struct["z_cam_16"] + memory_shift) 

		print_to_screen(143,75,"Graphical:",'yellow')
		print_to_screen(143,85,"    X: "..x_cam_16..","..fmt(x_cam_16,4),'yellow')
		print_to_screen(143,95,"    Z: "..z_cam_16..","..fmt(z_cam_16,4),'yellow')
	end 

end 

function show_tiles_ow(additional_offset)
	start_chunk_struct = memory.readdword(base+data_table["chunk_calculation_ptr"])
	print_to_screen(153,140,"0x"..fmt(start_chunk_struct,8))
	chunk_pointer_offs = chunk_struct["chunk_pointer_offs"]
	chunk_pointers = {}
	print_to_screen(153,150,"Chunk addresses:")
	debug_tile_dump = ""

	for i = 1,#chunk_pointer_offs do
		chunk_pointer = memory.readdword(chunk_pointer_offs[i] + start_chunk_struct)
		print_to_screen(153,150+i*10,"0x"..fmt(chunk_pointer,7))
		for col = 0,31 do 
			-- remove unless debug version
			if col ~= 0 then 
				debug_tile_dump = debug_tile_dump.."],"
			end 
			debug_tile_dump = debug_tile_dump.."["
			--

			for row = 0,31 do 
				tile_data = memory.readword(chunk_pointer+row*2 + col*64+additional_offset)
				tile_color = get_tile_color(tile_data)
				draw_rectangle(chunk_scr_x[i]+row*4,chunk_scr_y[i] + col*3,5,4,tile_color,0,2)

				-- remove unless debug version
				if tile_color  == nil then
					tile_color = "#000"
				end 
				debug_tile_dump = debug_tile_dump.."\""..tile_color.."\","
				--

								

			end
		end 
		
		-- remove unless debug version 
		if debug_tile_print then
			if i == 1 then  
				debug_tile_dump = debug_tile_dump.."]"		
				file = io.open("dump_test.txt","a")
				io.output(file)
				io.write("\nMap_"..map_id_phys_32.."=["..debug_tile_dump.."]")
				io.close(file)
				debug_tile_print = false 
			end
		end 
		--

	end 
end

function show_collision_ow(additional_offset)
	start_chunk_struct = memory.readdword(base+data_table["chunk_calculation_ptr"])
	print_to_screen(153,140,"0x"..fmt(start_chunk_struct,8))
	chunk_pointer_offs = chunk_struct["chunk_pointer_offs"]
	chunk_pointers = {}
	print_to_screen(153,150,"Chunk addresses:")
	for i = 1,#chunk_pointer_offs do
		chunk_pointer = memory.readdword(chunk_pointer_offs[i] + start_chunk_struct)
		print_to_screen(153,150+i*10,"0x"..fmt(chunk_pointer,7))
		for row = 0,31 do 
			for col = 0,31 do 
				if (memory.readbyte(chunk_pointer+row*2 + col*64+additional_offset)) ~= 0xff then
					collision  = memory.readbyte(chunk_pointer+row*2 + col*64+1+additional_offset)
					collision_color = get_collision_color(collision)
				end 
				draw_rectangle(chunk_scr_x[i]+row*4,chunk_scr_y[i] + col*3,5,4,collision_color,0,2)
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
		draw_rectangle(chunk_scr_x[c_chunk+1]+row*4,chunk_scr_y[c_chunk+1] + col*3,5,4,"#00f0ff",0,2)
	
	end
	
end 

function show_chunks_battle_tower()
end

function show_chunks_ug()
end

function debug_script_calling()
	get_internal_pointer()
	show_script_start()
	show_script_memory()
end 

show_script = false
script_executed = false 
update_variables = false
last_script_map = 0 
script_map = -1
param_count = 0


function swap_endian(num)

	return bit.bor(bit.lshift(num%256,8),bit.rshift(num,8));
end

function get_script_command_color(cmd)
	if cmd > 716 then return script_commands['stopcode']['color'] end 
	if script_commands[cmd] then 
		return script_commands[cmd]['color']
	end 
	return script_commands['default']['color']
end 


function get_param_count(cmd) -- incompatible with uneven script params so whatever fuck this
	if cmd > 716 then return script_commands['default']['param_count'] end 
	if script_commands[cmd] then 
		return script_commands[cmd]['param_count']
	end 
	return script_commands['default']['param_count']
end 

function show_script_start()
	last_script_map = script_map 
	script_map = memory.readword(base + live_struct["map_id_32"])

	script_array_pointer = base + 0x29574 + memory_shift-- this only accounts for normal RETIRE 
	script_array_addr = memory.readdword(script_array_pointer)

	temp_script_offs_4_addr = script_array_addr + 4*3 -- 4th index, 4 bytes each (indexing from 0 instead of 1)
	temp_script_execution_start_addr = temp_script_offs_4_addr + memory.readdword(temp_script_offs_4_addr) + 0x4-- add the offset to its own address, add 4 bcs jump starts after the address

	if script_array_addr == 0 then 
		script_executed = false
		print_to_screen(143,15,"No script loaded","#00f0f")
		return 
	end 

	if last_script_map ~= script_map then
		script_executed = false
		print_to_screen(143,15,"No script loaded","#00f0f")
		return
	end 


	if not script_executed then
		if script_array_addr ~= 0 then 
			script_executed = true
			update_variables = true
		end 

	end

	if (script_executed and update_variables) then
		script_offs_4_addr = temp_script_offs_4_addr
		script_offs_4 = memory.readdword(script_offs_4_addr)
		script_execution_start_addr = temp_script_execution_start_addr
		show_script = true
		update_variables = false 
	end 

	if show_script then 
		print_to_screen(143,15,"Next Command:\n    0x"..fmt(next_opcode_addr,8),"#00f0f")
		-- print_to_screen(143,35,"Id: 0x"..fmt(opcode,0),"#00f0f")
		-- print_to_screen(143,45,script_command_names[opcode],"#00f0f") --only accurate if the last script command doesn't contain any parameters

		print_to_screen(143,65,"Script Data:","#00f0f")
		print_to_screen(153,75,"Array:  0x"..fmt(script_array_addr,0),"#00f0f")
		print_to_screen(153,85,"Offset: 0x"..fmt(script_offs_4,0),"#00f0f")
		print_to_screen(153,95,"Exec:   0x"..fmt(script_execution_start_addr,0),"#00f0f")
	else
		print_to_screen(143,15,"No script loaded","#00f0f")
	end 
	
end 

function get_internal_pointer()
	opcode_pointer = base + script_execution_struct["opcode_pointer"] + memory_shift
	next_opcode_addr = memory.readdword(opcode_pointer)
	-- opcode = memory.readword(next_opcode_addr-2)
	-- if next_opcode_addr%2 == 1 then 
	-- 	higher_byte = bit.band(memory.readword(next_opcode_addr),0xFF)
	-- 	lower_byte = bit.rshift(memory.readword(next_opcode_addr-2),8)
	-- 	opcode = bit.bor(bit.lshift(higher_byte,8),lower_byte)
	-- end 
	--print_to_screen(143,185,"Pointer addr:\n    "..fmt(opcode_pointer,8),"yellow")
end

function show_script_memory()
	memory_viewer() -- remove this later when properly implemented
end 

scroll = 0
temp_memory_addr = 0x22A044C
temp_str_memory_addr = fmt(temp_memory_addr,0)

memview_addr = temp_memory_addr - temp_memory_addr%16 

function increment_scroll()
	scroll = scroll - 16
end 

function decrement_scroll()
	scroll = scroll + 16
end 

function reset_scroll()
	scroll = 0
end 

function get_value_color(cmd)
	if script_commands[cmd] then 
		return script_commands[cmd]['color']
	end 
	return script_commands['default']['color']
end 

function memory_viewer()
	draw_rectangle(0,0,256,200,"#000000AA","#000001888",2)
	for y = 0,15 do
		for x = 0,7 do
			-- script_command = memory.readword(script_execution_start_addr+x*2+y*16)
			current_addr = memview_addr+x*2+y*16 + scroll
			value = memory.readword(current_addr)
			color = get_value_color(value)
			print_to_screen(48+x*26,20+y*10,fmt(value,4),color,2)
		end
		print_to_screen(2,20+y*10,fmt(memview_addr+y*16 + scroll,7),"#888888",2)
	end  
	for x = 0,15 do
		print_to_screen(48+x*13,8,fmt(x,0),"#888888",2)
		
	end 
	for x = 1,7 do
		gui.drawline(46+(x*26),6,46+(x*26),179,"#444444")
	end 

	print_to_screen(2,8,temp_str_memory_addr,"yellow",2)
	gui.drawline(45,6,45,179,"#888888")
	gui.drawline(0,6,0,179,"#888888")
	gui.drawline(255,6,255,179,"#888888")
	gui.drawline(0,5,256,5,"#888888")
	gui.drawline(0,17,256,17,"#888888")
	gui.drawline(0,179,256,179,"#888888")

end 

-- Change game screen

function write_image_to_calculator()
	print("Changing calculator background")
	start_a = 0x23409C0
	block_length = 0xF
	for i = 0,23 do 
		for j = 0,23 do 
		memory.writeword(start_a+block_length*i+j*2+(0xF*3*i),0xA1)
		end 
	end 

end



-- SHOW MENU DATA

menu_choices = {
	OW = {show_void_pos,show_chunks_ow,debug_script_calling,memory_viewer},
	UG = {show_void_pos,show_chunks_ug,memory_viewer},
	BT = {show_void_pos,show_chunks_bt,debug_script_calling,memory_viewer}
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
	toggle_map_editing = {"M"},
	toggle_memory_addr_editing = {"shift","U"},
	auto_movement = {"shift","M"},
	increment_menu = {"shift","V"},
	teleport_up = {"shift","up"},
	teleport_left = {"shift","left"},
	teleport_down = {"shift","down"},
	teleport_right = {"shift","right"},
	toggle_tile_view = {"shift","T"},
	toggle_player_pos = {"shift","P"},
	toggle_bounding_view = {"shift","I"},
	toggle_grid = {"shift","G"},
	toggle_loadlines = {"shift","L"},
	toggle_maplines = {"shift","K"},
	toggle_mapmodellines = {"shift","H"},
	toggle_load_calculations = {"L","C"},
	toggle_debug_tile_print = {"T","C"},
	write_image_to_calculator = {"S","C"},
	reset_scroll = {"S","space"}
}

key_configuration_cont = {
	increment_scroll = {"S","up"},
	decrement_scroll = {"S","down"}
}

function run_functions_on_keypress()
	for funct,config_keys in pairs(key_configuration) do
		if check_keys(config_keys) == #config_keys then
			loadstring(funct.."()")()
		end 
	end
end

function run_continuous_function_on_keypress()
	for funct,config_keys in pairs(key_configuration_cont) do
		if check_keys_continuous(config_keys) == #config_keys then
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
		print_to_screen(option_x + 5,option_y + 18 + i*10,function_options[i+1][2])
	end 
end 

function run_functions()
	if map_editing then change_map_id() end 
	if memory_editing then change_memory_addr() end 
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
	print_to_screen(5,15,"Base:"..fmt(base,8),'yellow')
	show_player_data()

	-- print_to_screen(5,10,fmt(base,7),"yellow")
	-- print_to_screen(5,20,memory_state,"red")
	-- print_to_screen(5,30,fmt(memory_shift,4),"red")

	-- display_options()

	-- input functions
	get_keys()
	get_joy()
	get_stylus()
	run_functions_on_keypress()
	run_continuous_function_on_keypress()
	run_functions()
end


gui.register(main_gui)


