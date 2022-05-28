import json
from os import stat
# from os import stat
import pathlib
# from typing import Type
from functools import lru_cache

path = str(pathlib.Path(__file__).parent.resolve())

class ChunkSimulator():
    def __init__(self,game_type=0,tile_search_list = [0xD8],min_base=0x226D260,base_search_list=[0x226D2AC,0x226D2F8]):
        self.game_type = game_type
        self.texture_memory_offset = 0

        self.game = ["dp","pt","hgss"][self.game_type]
        self.tile_search_list = tile_search_list
        self.min_base = min_base

        self.json_chunk_data = self.load_json(path + "/data/chunk_data.json")

        self.game_data = self.json_chunk_data.get(self.game,{})
        self.chunk_pointer_differences = [
            [-0x13C,0x86C],
            [-0x11C0,0x86C],
            [-0x11C0,0x86C],
            [-0x11C0,0x86C]
        ]       

        output = self.search_texture_sets()
        self.write_json(path + "/dumps/dump1.json",output)
        self.search_for_current_base(output,base_search_list)

    def search_texture_sets(self):
        output = []
        for texture_data in self.game_data:
            primary_texture_set = texture_data["primary_texture_set"]
            secondary_texture_sets = texture_data["secondary_texture_sets"]
            chunk_offsets = texture_data["chunk_offsets"]

            #print(f"\nPrimary texture set: {primary_texture_set}\nSecondary Texture sets:")
            for set in secondary_texture_sets: 
                id = set["id"]
                map_ids = set["map_ids"]
                #print(f" {id}: map ids:{map_ids}")

            searched_data = {"map_ids":map_ids,"chunks":{}}
            for i,offs in enumerate(chunk_offsets):
                if i%2 == 1:
                    searched_data["chunks"][f"Chunk {i+1}"] = (self.check_for_tiles(offs,i))

            output.append(searched_data)
        return output

    @lru_cache              
    def check_for_tiles(self,offs,chunk_id):
        chunk_data = {}
        chunk_ptr = offs+self.min_base
        ptrs = [chunk_ptr + self.chunk_pointer_differences[chunk_id][i] for i in range(0,2)]
        #print(f"    Chunk {chunk_id+1}")

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

                #print(f"\tRequired base: {hex(required_base)}")
                collision_type = "walkable" if tile_collision < 0x80 else "wall"
                full_ptr = (tile_lower<<16)|(tile_collision<<8)|searched_tile
                #print(f"\t  Tile: {hex(searched_tile)} {collision_type} \t({hex(full_ptr)})")
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
    
    def search_for_current_base(self,search_dict,bases):
        for base in bases:
            print(f"Results for base: {hex(base)}")
            for tile_id in self.tile_search_list:
                print(f"  Tile Id: {hex(tile_id)}:")
                for searched_data in search_dict:
                    for chunk_id,chunk in searched_data["chunks"].items():
                        for ptr,ptr_data_list in chunk.items():
                            for ptr_data in ptr_data_list:
                                if int(ptr_data["base"],16) == base:
                                    map_ids = searched_data["map_ids"]
                                    if int(ptr_data["tile"],16) == tile_id:
                                        wall= "F" if int(ptr_data["collision"],16) < 0x80 else "T"
                                        text = f"   {chunk_id} {ptr} Wall: {wall} Map Ids: {map_ids[:16]}"
                                        if len(map_ids) > 16:
                                            text += f" ... + {len(map_ids)-16} results"
                                        print(text)


                        
            print("")
                    
    @lru_cache
    def multi_offset_to_array_index(offset_list,base_ptr):
        return [ChunkSimulator.offset_to_array_index(offset,base_ptr) for offset in offset_list]

    @lru_cache
    def offset_to_address(offset,base_ptr):
        return offset + base_ptr

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
        for word in ChunkSimulator.split_dword_into_words(dword):
            bytes.extend(ChunkSimulator.split_word_into_bytes(word))
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


if __name__ == '__main__':
    chunksim = ChunkSimulator(tile_search_list=[0xD8])