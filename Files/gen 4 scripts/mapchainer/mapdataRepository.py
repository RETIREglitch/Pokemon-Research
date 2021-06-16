import json

class mapdataRepository():
    def __init__(self,path_map_properties="Files/gen 4 scripts/mapchainer/map_colors.json"):
        self.path_map_properties = path_map_properties
        self.ram_section = [0,0,0,0,0x225,0x510,0x215,0x310,0x999,0x123,0x325,0x125,0x225,0x510,0x215,0x310,0x999,0x123,0x325,0x125,0x225,0x510,0x215,0x310,0x999,0x123,0x325,0x125,0x225,0x510,0x215,0x310,0x999,0x123,0x325,0x125,0x225,0x510,0x215,0x310,0x999,0x123,0x325,0x125]*8

    def map_id_to_color(self,map_id):
        with open(self.path_map_properties,"r") as file:
            json_obj = json.load(file)
            if map_id > 558:
                return json_obj["jubilife"]["color"]

            for group in json_obj:
                if map_id in json_obj[group]["map_ids"]:
                    return json_obj[group]["color"]
            
            return json_obj["default"]["color"]