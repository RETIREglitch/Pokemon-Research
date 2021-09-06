local struct_tools = require("common/util/structs")
local struct = struct_tools.struct
local ptr = struct_tools.ptr
local array = struct_tools.arr

--=== NITRO STRUCTS ===--

--= Defines =--

local VecFx32 = struct {
    __name = "VecFx32",
    __meta = {
        __tostring = function(self)
            return "(" .. tostring(self.x) .. "," .. tostring(self.y) .. "," .. tostring(self.z) .. ")"
        end
    }
}

--= Body =--

do
    VecFx32.x = fx32
    VecFx32.y = fx32
    VecFx32.z = fx32
end

--=== GF STRUCTS ===--

--= Defines =--

local PROC_DATA = struct {
    __name = "PROC_DATA"
}
local PROC = struct {
    __name = "_PROC"
}
local CONTROL_WORK = struct {
    __name = "_CONTROL_WORK"
}
local TCBSYS = struct {
    __name = "_TCBSYS"
}
local TCB = struct {
    __name = "_TCB"
}
local FLDMAPFUNC_DATA = struct {
    __name = "FLDMAPFUNC_DATA"
}
local FLDMAPFUNC_WORK = struct {
    __name = "FLDMAPFUNC_WORK"
}
local FLDMAPFUNC_SYS = struct {
    __name = "FLDMAPFUNC_SYS"
}
local FIELDMAP_WORK = struct {
    __name = "FIELDMAP_WORK"
}
local FIELD_OBJ = struct {
    __name = "_TAG_FIELD_OBJ"
}
local PLAYER_SAVE_DATA = struct {
    __name = "PLAYER_SAVE_DATA"
}
local PLAYER_STATE = struct {
    __name = "_TAG_PLAYER_STATE"
}
local SVBLK_INFO = struct {
    __name = "SVBLK_INFO"
}
local SVPAGE_INFO = struct {
    __name = "SVPAGE_INFO"
}
local SAVEWORK = struct {
    __name = "SAVEWORK"
}
local NEWDIVSV_WORK = struct {
    __name = "NEWDIVSV_WORK"
}
local SAVEDATA = struct {
    __name = "_SAVEDATA"
}
local GF_CAMERA_PERSP = struct {
    __name = "GF_CAMERA_PERSP"
}
local GF_CAMERA_LOOKAT = struct {
    __name = "GF_CAMERA_LOOKAT"
}
local CAMERA_ANGLE = struct {
    __name = "CAMERA_ANGLE"
}
local LOCATION_WORK = struct {
    __name = "LOCATION_WORK"
}
local GF_CAMERA = struct {
    __name = "GF_CAMERA_tag"
}
local FIELDSYS_WORK = struct {
    __name = "_FIELDSYS_WORK"
}

--= Body =--

do
    PROC_DATA.init_func = voidp
    PROC_DATA.main_func = voidp
    PROC_DATA.end_func = voidp
    PROC_DATA.overlay_id = u32
end

do
    PROC.data = PROC_DATA
    PROC.proc_seq = int
    PROC.subseq = int
    PROC.parent_work = voidp
    PROC.work = voidp
    PROC.parent = ptr(PROC)
    PROC.child = ptr(PROC)
end

do
    CONTROL_WORK.mainproc = ptr(PROC)
    CONTROL_WORK.subproc = ptr(PROC)
    CONTROL_WORK.pause_flag = BOOL
    CONTROL_WORK.end_flag = BOOL
end

do
    FLDMAPFUNC_DATA.pri = u32
    FLDMAPFUNC_DATA.work_size = u16
    FLDMAPFUNC_DATA.create_func = voidp
    FLDMAPFUNC_DATA.delete_func = voidp
    FLDMAPFUNC_DATA.update_func = voidp
    FLDMAPFUNC_DATA.draw3d_func = voidp
end

do
    TCBSYS.tcb_max = u16
    TCBSYS.tcb_stack_ptr = u16
    TCBSYS.tcb_first = TCB
    TCBSYS.tcb_stack = ptr(TCB)  -- TODO: Stack objects
    TCBSYS.tcb_table = ptr(TCB)
    TCBSYS.adding_flag = BOOL
    TCBSYS.now_chain = ptr(TCB)
    TCBSYS.next_chain = ptr(TCB)
end

do
    TCB.sys = ptr(TCBSYS)
    TCB.prev = ptr(TCB)
    TCB.next = ptr(TCB)
    TCB.pri = u32
    TCB.work = voidp
    TCB.func = voidp
    TCB.sw_flag = u32
end

do
    FLDMAPFUNC_WORK.sys = ptr(FLDMAPFUNC_SYS)
    FLDMAPFUNC_WORK.tcb = ptr(TCB)
    FLDMAPFUNC_WORK.drawtcb = ptr(TCB)
    FLDMAPFUNC_WORK.data = ptr(FLDMAPFUNC_DATA)
    FLDMAPFUNC_WORK.free_work = voidp
end

do
    FLDMAPFUNC_SYS.fsys = ptr(FIELDSYS_WORK)
    FLDMAPFUNC_SYS.heapID = int
    FLDMAPFUNC_SYS.max = int
    FLDMAPFUNC_SYS.array = ptr(FLDMAPFUNC_WORK)
    FLDMAPFUNC_SYS.drawsys = ptr(TCBSYS)
end

do
    FIELDMAP_WORK.main_mode_flag = BOOL
    FIELDMAP_WORK.fmapfunc_sys = ptr(FLDMAPFUNC_SYS)
    FIELDMAP_WORK.place_name_cont = ptr(PNC)
    FIELDMAP_WORK.weather_data = ptr(WEATHER_MANAGER)
    FIELDMAP_WORK.field_trans_anime = ptr(FIELD_ANIME)
    FIELDMAP_WORK.poketch = ptr(POKETCH_WORK)
    FIELDMAP_WORK.seedsys = ptr(SEEDSYS_WORK)
    FIELDMAP_WORK.hblanksys = ptr(FIELD_HBLANK_SYS)
    FIELDMAP_WORK.poisoneffect = ptr(POISON_EFFECT_WORK)
    FIELDMAP_WORK.Work = voidp
    -- TODO: Sub structs
end

do
    FIELD_OBJ.status_bit = u32
    FIELD_OBJ.move_bit = u32
    FIELD_OBJ.obj_id = u32
    FIELD_OBJ.zone_id = u32
    FIELD_OBJ.obj_code = u32
    FIELD_OBJ.move_code = u32
    FIELD_OBJ.event_type = u32
    FIELD_OBJ.event_flag = u32
    FIELD_OBJ.event_id = u32
    FIELD_OBJ.dir_head = int
    FIELD_OBJ.dir_disp = int
    FIELD_OBJ.dir_move = int
    FIELD_OBJ.dir_disp_old = int
    FIELD_OBJ.dir_move_old = int
    FIELD_OBJ.param0 = int
    FIELD_OBJ.param1 = int
    FIELD_OBJ.param2 = int
    FIELD_OBJ.move_limit_x = int
    FIELD_OBJ.move_limit_z = int
    FIELD_OBJ.gx_init = int
    FIELD_OBJ.gy_init = int
    FIELD_OBJ.gz_init = int
    FIELD_OBJ.gx_old = int
    FIELD_OBJ.gy_old = int
    FIELD_OBJ.gz_old = int
    FIELD_OBJ.gx_now = int
    FIELD_OBJ.gy_now = int
    FIELD_OBJ.gz_now = int
    FIELD_OBJ.vec_pos_now = VecFx32
    FIELD_OBJ.vec_draw_offs = VecFx32
    FIELD_OBJ.vec_draw_offs_outside = VecFx32
    FIELD_OBJ.vec_attr_offs = VecFx32
    FIELD_OBJ.draw_status = u32
    FIELD_OBJ.acmd_code = int
    FIELD_OBJ.acmd_seq = int
    FIELD_OBJ.now_attr = u16
    FIELD_OBJ.old_attr = u16
    FIELD_OBJ.tcb = ptr(TCB)
    FIELD_OBJ.fldobj_sys = ptr(CONST_FIELD_OBJ_SYS)
    FIELD_OBJ.move_init_proc = voidp
    FIELD_OBJ.move_proc = voidp
    FIELD_OBJ.move_delete_proc = voidp
    FIELD_OBJ.draw_init_proc = voidp
    FIELD_OBJ.draw_proc = voidp
    FIELD_OBJ.draw_delete_proc = voidp
    FIELD_OBJ.draw_push_proc = voidp
    FIELD_OBJ.draw_pop_proc = voidp
end

do
    PLAYER_SAVE_DATA.gear_type = u16
    PLAYER_SAVE_DATA.shoes_flag = u16
    PLAYER_SAVE_DATA.form = u32
end

do
    PLAYER_STATE.move_bit = u32
    PLAYER_STATE.request_bit = u32
    PLAYER_STATE.set_ac = u32
    PLAYER_STATE.se_walk_lr = u32
    PLAYER_STATE.move_value = int
    PLAYER_STATE.move_state = int
    PLAYER_STATE.form = int
    PLAYER_STATE.sex = int
    PLAYER_STATE.speed = int
    PLAYER_STATE.input_key_dir_x = int
    PLAYER_STATE.input_key_dir_z = int
    PLAYER_STATE.fldobj = ptr(FIELD_OBJ)
    PLAYER_STATE.joint_eoa = ptr(EOA)
    PLAYER_STATE.savedata = ptr(PLAYER_SAVE_DATA)
    PLAYER_STATE.save = ptr(PLAYER_SAVE_DATA)
end

do
    SAVEWORK.data = array(u8, 0x20000)
end

do
    SVPAGE_INFO.gmdataID = enum
    SVPAGE_INFO.size = u32
    SVPAGE_INFO.address = u32
    SVPAGE_INFO.crc = u16
    SVPAGE_INFO.blockID = u16
end

do
    SVBLK_INFO.id = u8
    SVBLK_INFO.start_sec = u8
    SVBLK_INFO.use_sec = u8
    SVBLK_INFO.start_ofs = u32
    SVBLK_INFO.size = u32
    SVBLK_INFO.extra = u8  -- padding
end

do
    NEWDIVSV_WORK.total_save_mode = BOOL
    NEWDIVSV_WORK.block_start = int
    NEWDIVSV_WORK.block_current = int
    NEWDIVSV_WORK.block_end = int
    NEWDIVSV_WORK.lock_id = s32
    NEWDIVSV_WORK.div_seq = int
    NEWDIVSV_WORK.g_backup = u32
    NEWDIVSV_WORK.b_backup = array(u32, 2)
end

do
    SAVEDATA.flash_exists = BOOL
    SAVEDATA.data_exists = BOOL
    SAVEDATA.new_data_flag = BOOL
    SAVEDATA.total_save_flag = BOOL
    SAVEDATA.first_status = enum
    SAVEDATA.crc_table = array(u16, 256)
    SAVEDATA.svwk = SAVEWORK
    SAVEDATA.global_counter = u32
    SAVEDATA.current_counters = array(u32, 2)
    SAVEDATA.current_side = array(u16, 2)
    SAVEDATA.pageinfo = array(SVPAGE_INFO, 36)
    SAVEDATA.blkinfo = array(SVBLK_INFO, 2)
    SAVEDATA.ndsw = NEWDIVSV_WORK
    SAVEDATA.dendou_sector_switch = int
    SAVEDATA.dendou_counter = u32
end

do
    GF_CAMERA_PERSP.fovysin = fx32
    GF_CAMERA_PERSP.fovycos = fx32
    GF_CAMERA_PERSP.aspect = fx32
    GF_CAMERA_PERSP.nearClip = fx32
    GF_CAMERA_PERSP.farClip = fx32
end

do
    GF_CAMERA_LOOKAT.camPos = VecFx32
    GF_CAMERA_LOOKAT.target = VecFx32
    GF_CAMERA_LOOKAT.camUp = VecFx32
end

do
    CAMERA_ANGLE.x = u16
    CAMERA_ANGLE.y = u16
    CAMERA_ANGLE.z = u16
    CAMERA_ANGLE.dummy = u16
end

do
    LOCATION_WORK.zone_id = int
    LOCATION_WORK.door_id = int
    LOCATION_WORK.grid_x = int
    LOCATION_WORK.grid_z = int
    LOCATION_WORK.dir = int
end

do
    GF_CAMERA.persp = GF_CAMERA_PERSP
    GF_CAMERA.lookat = GF_CAMERA_LOOKAT
    GF_CAMERA.distance = fx32
    GF_CAMERA.angle = CAMERA_ANGLE
    GF_CAMERA.view = u8
    GF_CAMERA.UNKNOWN = u8
    GF_CAMERA.perspWay = u16
    GF_CAMERA.bindTargetOld = VecFx32
    GF_CAMERA.bindTarget = ptr(VecFx32)
    GF_CAMERA.xbind = BOOL
    GF_CAMERA.ybind = BOOL
    GF_CAMERA.zbind = BOOL
    GF_CAMERA.trace = ptr(GF_CAMERA_TRACE)
end

do
    FIELDSYS_WORK.ctrl = ptr(CONTROL_WORK)
    FIELDSYS_WORK.fldmap = ptr(FIELDMAP_WORK)
    FIELDSYS_WORK.bgl = ptr(GF_BGL_INI)
    FIELDSYS_WORK.savedata = ptr(SAVEDATA)
    FIELDSYS_WORK.event = ptr(GMEVENT_CONTROL)
    FIELDSYS_WORK.eventdata = ptr(EVENT_DATA)
    FIELDSYS_WORK.subscreen = ptr(FIELD_SUBSCRN_TYPE)
    FIELDSYS_WORK.location = ptr(LOCATION_WORK)
    FIELDSYS_WORK.camera = ptr(GF_CAMERA)
    FIELDSYS_WORK.map_cont_dat = ptr(DMC)
    FIELDSYS_WORK.world = ptr(WORLD_MAP)
    FIELDSYS_WORK.mapresource = ptr(MAP_RESOURCE)
    FIELDSYS_WORK.mmdl = ptr(MMDL_WORK)
    FIELDSYS_WORK.fldobjsys = ptr(FIELD_OBJ_SYS)
    FIELDSYS_WORK.player = ptr(PLAYER_STATE)
    FIELDSYS_WORK.fes = ptr(FE)
    FIELDSYS_WORK.glst_data = ptr(GLST_DATA)
    FIELDSYS_WORK.fog_data = ptr(FOG_DATA)
    FIELDSYS_WORK.light_cont_data = ptr(LIGHT_CONT)
    FIELDSYS_WORK.field_3d_anime = ptr(FLD_3D_ANM_MNG)
    FIELDSYS_WORK.animecontmng = ptr(ANIME_CONT_MNG)
    FIELDSYS_WORK.spmatdata = ptr(SMD)
    FIELDSYS_WORK.map_tool_list = ptr(MTL_CONST)
    FIELDSYS_WORK.divmapmod = enum
    FIELDSYS_WORK.board = ptr(BOARD_WORK)
    FIELDSYS_WORK.main_mode_flag = BOOL
    FIELDSYS_WORK.undergroundradar = ptr(UG_RADAR_WORK)
    FIELDSYS_WORK.mapmode = enum
    FIELDSYS_WORK.mapmodedata = ptr(MAP_MODE_DATA)
    FIELDSYS_WORK.encount = u32 -- TODO
    FIELDSYS_WORK.union_work = ptr(COMM_UNIONROOM_WORK)
    FIELDSYS_WORK.union_view = ptr(COMM_UNIONROOM_VIEW)
    FIELDSYS_WORK.union_board = ptr(UNION_BOARD_WORK)
    FIELDSYS_WORK.tradelist_work = ptr(TRADELIST_WORK)
    FIELDSYS_WORK.tpto3d = ptr(TP_TO_3D)
    FIELDSYS_WORK.startmenu_pos = int
    FIELDSYS_WORK.swaygrass = ptr(SWAY_GRASS)
    FIELDSYS_WORK.bag_cursor = ptr(BAG_CURSOR)
    FIELDSYS_WORK.fnote = ptr(FNOTE_DATA)
    FIELDSYS_WORK.exheightlist = ptr(EHL)
    FIELDSYS_WORK.map3dobjexp = ptr(M3DOL)
    FIELDSYS_WORK.honeytree = ptr(HTD)
    FIELDSYS_WORK.btower_wk = ptr(BTOWER_SRCWORK)
    FIELDSYS_WORK.regulation = ptr(REGULATION)
    FIELDSYS_WORK.p_zukandata = ptr(ZKN_DATA_WORK)
    FIELDSYS_WORK.scope_mode_flag = BOOL
    -- TODO: Sub structs
end

return {
    FIELDSYS_WORK = FIELDSYS_WORK
}