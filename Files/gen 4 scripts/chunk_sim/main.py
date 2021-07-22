import json
from os import stat
import pathlib
from typing import Type

path = str(pathlib.Path(__file__).parent.resolve())

class SimulateChunks():
    def __init__(self,game_type=0):
        self.game_type = game_type
        self.game = ["dp","pt","hgss"][self.game_type]

        self.path_chunk_data = path + "/chunk_data.json"
        self.json_chunk_data = self.load_json(self.path_chunk_data)

        self.game_data = self.json_chunk_data.get(self.game)
        map_ids = self.return_data_from_texture_set(151,15,"map_ids")
        print(map_ids)
        
        
    def get_texture_data(self,d1,d2):
        if (type(d1) is int) & (type(d2) is int):
            texture_set_str = str(d1) + " " + str(d2)
            if type(self.game_data) is dict:
                texture_set_data = self.game_data["texture_sets"].get(texture_set_str)
                if texture_set_data != None:
                    return texture_set_data,texture_set_str
                raise ValueError(f"Error: texture data not found for {texture_set_str}") 
            raise TypeError("Application failed read game data.") 
        raise TypeError("Error: invalid texture set")

    def return_data_from_texture_set(self,d1,d2,dtype):
        try:
            data = self.get_texture_data(d1,d2)
            if data != None:
                texture_set_data,texture_set_str = data
                if type(dtype) is str:
                    if dtype in ["map_ids","chunk_pointers","texture_data"]:
                        data = texture_set_data.get(dtype)
                        if data != None:
                            return data
                        raise ValueError(f"Error: data not found for texture set {texture_set_str}")
                raise TypeError("Error: not a valid data request")
        except Exception:
            pass

            

    @staticmethod
    def load_json(file):
        with open(file,"r") as file_:
            json_obj = json.load(file_)
        return json_obj



if __name__ == '__main__':
    chunksimulator = SimulateChunks()