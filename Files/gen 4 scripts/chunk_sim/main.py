import json
# from os import stat
import pathlib
# from typing import Type
from functools import lru_cache

path = str(pathlib.Path(__file__).parent.resolve())

class ChunkSimulator():
    def __init__(self,game_type=0,base_ptr=0x0226D360):
        self.game_type = game_type
        self.base_ptr = base_ptr
        self.texture_memory_offset = 0


        self.game = ["dp","pt","hgss"][self.game_type]

        self.path_chunk_data = path + "/chunk_data.json"
        self.json_chunk_data = self.load_json(self.path_chunk_data)

        self.game_data = self.json_chunk_data.get(self.game)
        # self.iterate_all_chunks([0xD8,0xD7])
        self.create_simulated_memory()
        print(self.simulated_memory_sets)

    def iterate_all_chunks(self,ids):
        for c_id in self.game_data:
            c_data = self.game_data[c_id]
            c_ptrs = c_data["chunk_pointers"]
            print(f"Creating chunks for texture set {c_id}")
            
            for ptr_i in range(len(c_ptrs)):
                ptr = c_ptrs[ptr_i]
                print(f"{ptr_i}. {ptr}")

                for prev_memory_state in self.simulated_memory_sets:
                    self.simulate_tilewriting(prev_memory_state,ptr,)

    def simulate_chunk(ptr):

        pass

    def create_simulated_memory_for_texture_set(self,texture_set):
        texture_set_data = self.game_data.get(texture_set)
        return texture_set_data

    def create_simulated_memory(self):
        simulated_memory_sets = {}
        for texture_set in self.game_data:
            simulated_memory_sets[texture_set] = self.create_simulated_memory_for_texture_set(texture_set)
        self.simulated_memory_sets  = simulated_memory_sets

    def load_chunks(self,id,d1,d2):
        chunk_data,chunk_ptrs_offs = self.multi_get_data(d1,d2,chunk_dat=True,chunk_ptrs=True)
        chunk_ptr_indexes = ChunkSimulator.multi_offset_to_array_index(chunk_ptrs_offs,self.base_ptr)

    def multi_get_data():
        pass

    
    def offset_to_array_index():
        return None

    @lru_cache
    def multi_offset_to_array_index(offset_list,base_ptr):
        return [ChunkSimulator.offset_to_array_index(offset,base_ptr) for offset in offset_list]

    @lru_cache
    def offset_to_address(offset,base_ptr):
        return offset + base_ptr

    @staticmethod
    def load_json(file):
        with open(file,"r") as file_:
            json_obj = json.load(file_)
        return json_obj



if __name__ == '__main__':
    chunksim = ChunkSimulator()