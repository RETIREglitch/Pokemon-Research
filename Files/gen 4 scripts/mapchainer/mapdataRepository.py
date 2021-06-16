import json

class mapdataRepository():
    def __init__(self,path_map_data = "Files/gen 4 scripts/mapchainer/map_data.json",path_map_properties="Files/gen 4 scripts/mapchainer/map_colors.json",aslr=0x226D314):
        self.path_map_data = path_map_data
        self.path_map_properties = path_map_properties
        self.aslr = aslr
        self.address = 0
        self.ram_section = [0]*(24*30) # assuming starting with clean data, and moving into a jubilife map as first id
        self.set_ram_header(self.aslr)
        self.load_ram_data(3)

    def map_id_to_color(self,map_id):
        with open(self.path_map_properties,"r") as file:
            json_obj = json.load(file)
            if map_id > 558:
                file.close()
                return json_obj["jubilife"]["color"]

            for group in json_obj:
                file.close()
                if map_id in json_obj[group]["map_ids"]:
                    return json_obj[group]["color"]

            file.close()
            return json_obj["default"]["color"]
        

    def set_ram_header(self,aslr):
        header = [0x616d,0x70,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5544,0x0,0xad8,0x0,0xfdc8,0x228,0x1a7c,0x229,0x0,0x0,0x0,0x0,0x0,0x0,0xb,0x0,0x1,0x0,0x20,0x0,0xe,0x0,0x5,0x0,0xfd8,0x229,0xff0,0x229,0x13f4,0x229,0x14a0,0x229]
        self.address = len(header)
        for i in range(len(header)):
            self.ram_section[i] = header[i]

    def load_ram_data(self,map_id):
        requested_data_instances = ["objects","sprites","warps","triggers"]
        address = self.address
        with open(self.path_map_data,"r") as file:
            json_obj = json.load(file)
            if map_id > 558:
                map_id = 3
            for map_data_type,data_instance in json_obj[str(map_id)].items():
                if map_data_type in requested_data_instances:
                    self.ram_section[address] = len(data_instance)
                    address += 1
                    self.ram_section[address] = 0x0
                    address += 1
                    for data in data_instance.values():
                        for value in data.values():
                            self.ram_section[address] = value
                            address += 1




            file.close()
            return self.ram_section
        