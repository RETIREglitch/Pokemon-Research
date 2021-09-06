import json
from os import stat
# from os import stat
import pathlib
# from typing import Type
from functools import lru_cache

path = str(pathlib.Path(__file__).parent.resolve())

class ChunkSimulator():
    def __init__(self,game_type=0,base_ptr=0x0226D2ac):
        self.game_type = game_type
        self.base_ptr = base_ptr
        self.texture_memory_offset = 0


        self.game = ["dp","pt","hgss"][self.game_type]

        self.path_chunk_data = path + "/chunk_data.json"
        self.json_chunk_data = self.load_json(self.path_chunk_data)

        self.game_data = self.json_chunk_data.get(self.game)
        self.all_pointer_values = [] # remove final build
        
        self.simulated_memory = self.simulate_memory()

        print(hex(min(self.all_pointer_values))) # remove final build
        print(hex(max(self.all_pointer_values))) # remove final build
        
        self.id_list = [0xD8,0xD7]
        self.check_for_tiles()

    def simulate_memory(self):
        simulated_memory = []
        for c_id in self.game_data:
            c_data = self.game_data[c_id]
            
            c_ptrs = c_data["chunk_pointers"]
            print(f"Primary texture set {c_id}\nSecondary texture sets:")
            map_ids = c_data["map_ids"]
            for t_set in map_ids:
                print(f"{t_set}: {map_ids[t_set]}")
               
            initial_memory = c_data["texture_data"]
            simulated_memory.append(self.simulate_memory_instance(initial_memory,self.base_ptr,c_ptrs))
        return simulated_memory


    def simulate_memory_instance(self,initial_mem,base_ptr,c_ptrs):
        for ptr_i in range(len(c_ptrs)):
                ptr = c_ptrs[ptr_i]
                print(f"\t{ptr_i+1}. {hex(ptr+base_ptr)}")
                split_ptr = ChunkSimulator.split_dword_into_bytes(ptr+base_ptr)
                self.all_pointer_values.append(ptr) # remove final build
                # for i in split_ptr:
                #     print(f"\t{hex(i)}")
        
    @lru_cache    
    def check_for_tiles(self):
        #use self.id_list
        return None

    def load_chunks(self,id,d1,d2):
        chunk_data,chunk_ptrs_offs = self.multi_get_data(d1,d2,chunk_dat=True,chunk_ptrs=True)
        chunk_ptr_indexes = ChunkSimulator.multi_offset_to_array_index(chunk_ptrs_offs,self.base_ptr)
    
    def offset_to_array_index():
        return None

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



if __name__ == '__main__':
    chunksim = ChunkSimulator()