import json
from os import stat
# from os import stat
import pathlib
# from typing import Type
from functools import lru_cache
from colorama import Fore

movement_colors = {"Yes":Fore.GREEN,"No ":Fore.RED}
chunk_colors = {"1":Fore.LIGHTBLUE_EX,"2":Fore.GREEN,"3":Fore.LIGHTBLUE_EX,"4":Fore.LIGHTBLUE_EX}

path = str(pathlib.Path(__file__).parent.resolve())
class UtilityClass():
    @lru_cache
    def split_word_into_bytes(word):
        h_byte = (word & 0xff00)>>8
        l_byte = word & 0xff
        return [h_byte,l_byte]

    @lru_cache
    def split_dword_into_words(dword):
        h_word = (dword & 0xffff0000)>>16
        l_word = dword & 0xffff
        return [h_word,l_word]

    def split_dword_into_bytes(dword):
        bytes = []
        for word in UtilityClass.split_dword_into_words(dword):
            bytes.extend(UtilityClass.split_word_into_bytes(word))
        return bytes

    @staticmethod
    def load_json(file):
        with open(file,"r") as file_:
            json_obj = json.load(file_)
        return json_obj

    @staticmethod
    def write_json(file,json_obj):
        with open(file,"w") as file_:
            json.dump(json_obj,file_,indent=1)

class ChunkSimulator(UtilityClass):
    def __init__(self,game_type=0,min_base=0x226D260):
        self.game = ["dp","pt","hgss"][game_type]
        self.min_base = min_base
        self.json_chunk_data = self.load_json(path + "/data/chunk_data.json")
        self.game_data = self.json_chunk_data.get(self.game,{})

        self.chunk_pointer_differences = [
            [-0x13C,0x86C],
            [-0x11C0,0x86C],
            [-0x11C0,0x86C],
            [-0x11C0,0x86C]
        ]       

        # output = self.search_texture_sets()
        # if write_option == "Y":
        #     count = 0
        #     for f in pathlib.Path(path + "/dumps").iterdir():
        #         if f.is_file():
        #             count += 1
        #     self.write_json(path + f"/dumps/dump{count+1}.json",output)
        # self.sort_by_base(output,base_search_list)

        # while True:
            # tile_search_list = input("Insert tiles to search, comma seperated > ")
            # bases = input("Insert bases to search, comma seperated > ")
            # print()
            
            # try:
            #     self.tile_search_list = [int(tile,16) for tile in tile_search_list.split(",")]
            #     base_search_list = [int(base,16) for base in bases.split(",")]
            # except Exception:
            #     self.tile_search_list = [0xD8,0x10]
            #     base_search_list = [0x226D2CA,0x226D2C0]


            # output = self.search_texture_sets()
            # if write_option == "Y":
            #     count = 0
            #     for f in pathlib.Path(path + "/dumps").iterdir():
            #         if f.is_file():
            #             count += 1
            #     self.write_json(path + f"/dumps/dump{count+1}.json",output)
            # self.sort_by_base(output,base_search_list)
            # input()

    def search_texture_sets(self):
        output = []
        for texture_data in self.game_data:
            primary_texture_set = texture_data["primary_texture_set"]
            secondary_texture_sets = texture_data["secondary_texture_sets"]
            chunk_offsets = texture_data["chunk_offsets"]

            map_ids = []
            for set in secondary_texture_sets: 
                id = set["id"]
                map_ids.extend(set["map_ids"])

            searched_data = {"map_ids":map_ids,"chunks":{}}
            for i,offs in enumerate(chunk_offsets):
                searched_data["chunks"][f"Chunk {i+1}"] = (self.check_for_tiles(offs,i))

            output.append(searched_data)
        return output

    @lru_cache              
    def check_for_tiles(self,offs,chunk_id):
        chunk_data = {}
        chunk_ptr = offs+self.min_base
        ptrs = [chunk_ptr + self.chunk_pointer_differences[chunk_id][i] for i in range(0,2)]
        for i,ptr in enumerate(ptrs):
            chunk_data[f"ptr {i+1}"] = []
            tile_lower = ptr>>16
            tile_id,tile_collision = ptr & 0xFF,(ptr>>8)&0xFF
            
            for searched_tile in self.tile_search_list:
                if searched_tile%4 != 0:
                    continue
                diff = searched_tile - tile_id
                if diff < 0:
                    tile_collision += 1
                required_base = self.fix_base(self.min_base + diff)
                full_ptr = (tile_lower<<16)|(tile_collision<<8)|searched_tile
                chunk_data[f"ptr {i+1}"].append({"base":hex(required_base),"tile":hex(searched_tile),"collision":hex(tile_collision),"ptr":hex(full_ptr)})

        return chunk_data
                
    @lru_cache
    def split_into_tiles(self,ptr):
        split_ptr = []
        for word in ChunkSimulator.split_dword_into_words(ptr):
            bytes = ChunkSimulator.split_word_into_bytes(word)
            split_ptr.append({"tile_id":bytes[1],"collision":bytes[0]})
        return split_ptr

    @lru_cache
    def fix_base(self,base):
        if base < self.min_base:
            return base + 0x100
        if base > self.min_base + 0x100:
            return base - 0x100
        return base
    
    def sort_by_base(self,search_dict,bases):
        sorted_data = {}
        for base in bases:
            sorted_data[hex(base)] = {}
            print(f"{Fore.WHITE}Results for base: {hex(base)}")
            for tile_id in self.tile_search_list:
                sorted_data[hex(base)][hex(tile_id)] = []
                print(f"{Fore.WHITE}  Tile Id: {hex(tile_id)}:")
                for searched_data in search_dict:
                    for chunk_id,chunk in searched_data["chunks"].items():
                        for ptr,ptr_data_list in chunk.items():
                            for ptr_data in ptr_data_list:
                                if int(ptr_data["base"],16) == base:
                                    map_ids = sorted(searched_data["map_ids"])
                                    if int(ptr_data["tile"],16) == tile_id:
                                        free = "Yes" if int(ptr_data["collision"],16) < 0x80 else "No "
                                        sorted_data[hex(base)][hex(tile_id)].append({"chunk":int(chunk_id[-1:]),"ptr":int(ptr[-1:]),"free":free.replace(" ",""),"map_ids":map_ids})
                                        text = f"{chunk_colors[chunk_id[-1:]]}   {chunk_id} {ptr} {movement_colors[free]} Free: {free} {Fore.LIGHTBLACK_EX}Map Ids: {map_ids[:14]}"
                                        if len(map_ids) > 14:
                                            for i in range(round(len(map_ids[14:])/14)):
                                                text += "\n" + " "*37 + f"{map_ids[14:][i*14:i*14+14]}"
                                        print(text)
            print("")
        return sorted_data

    def get_all_aslr_tiles(self):
        tiles = self.load_json(path + "/data/tile_data.json")
        aslr_tiles = []
        for i,v in enumerate(tiles):
            if i%4 == 0:
                aslr_tiles.append(v)
        return aslr_tiles

    def filter_tiles(self,tile_data,pal_park=True,interaction=False,distinguishable=True):
        filtered_tiles = []
        if pal_park:
            for tile_obj in tile_data:
                if interaction and tile_obj["interaction"] == 0: continue
                if pal_park and tile_obj["checkable"]["pal_park"] == 0: continue
                if distinguishable and tile_obj["distinguishable"] == 0: continue
                if tile_obj["checkable"]["normal"]: filtered_tiles.append(tile_obj)
        return filtered_tiles

class BaseFinder(ChunkSimulator):
    def __init__(self,write_option="Y",specified_tiles=[]):
        super().__init__()
        self.init(specified_tiles)


    def init(self,specified_tiles):
        if len(specified_tiles):
            self.tile_search_list = specified_tiles
            return
        aslr_tile_list = self.get_all_aslr_tiles()
        manipable_tile_list = self.filter_tiles(aslr_tile_list)
        self.tile_search_list = [int(tile["id"],16) for tile in manipable_tile_list]

    # def determine_base(self):
    #     bases = [base for base in range (chunksim.min_base,chunksim.min_base+0x100,4)]
    #     potential_bases = self.dump_required_pointers(bases,"N")
    #     while len(potential_bases)!= 1:
    #         map_ids_to_check = self.get_statistically_best_maps(potential_bases)

    def dump_required_pointers(self,base_search_list,write_option="Y"):
        output = self.search_texture_sets()
        sorted_dump = self.sort_by_base(output,base_search_list)
        if write_option == "Y":
            count = 0
            for f in pathlib.Path(path + "/dumps").iterdir():
                if f.is_file():
                    count += 1
            self.write_json(path + f"/dumps/dump{count+1}.json",output)
            count = 0
            for f in pathlib.Path(path + "/dumps/sorted").iterdir():
                if f.is_file():
                    count += 1
            self.write_json(path + f"/dumps/sorted/dump{count+1}.json",sorted_dump)
        return

if __name__ == '__main__':
    # tile_search_list=[0xD8],base_search_list=[0x226D340]
    chunksim = BaseFinder(specified_tiles=[0xD8]) #specified_tiles=[0xD8]
    # dump to determine any ASLR layout:
    #base_search_list = [base for base in range (chunksim.min_base,chunksim.min_base+0x100,4)]
    base_search_list = [0x226d2d4]
    #base_search_list =[ i + 0x20 for i in [0x226d33c,0x226d278,0x226d30c,0x226d310,0x226d294,0x226d2d0,0x226d264,0x226d268]] #[0x226d268 + 0x20,0x226d2a4 +0x20,0x226d338 + 0x20,0x226d33c + 0x20]#[0x226D2C0]
    chunksim.dump_required_pointers(base_search_list,"N")
    input()