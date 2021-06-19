import json
import time
from functools import lru_cache

class mapdataRepository():
    def __init__(self,path_map_data = "Files/gen 4 scripts/mapchainer/map_data.json",path_map_properties="Files/gen 4 scripts/mapchainer/map_colors.json",aslr=0x226D314):
        self.path_map_data = path_map_data
        self.path_map_properties = path_map_properties

        self.aslr = aslr
        self.start_mapdata = self.aslr + 0x23C6E
        self.address = 0

        self.init_json()
        self.init_ram_section()
        self.init_data()
    
    @property
    def current_map_id(self):
        """ The current_map_id property. """
        return self.__current_map_id
    
    @current_map_id.setter
    def current_map_id(self, value):
        if value > 558:
            value = 3
        self.__current_map_id = value    

    @property
    def prev_map_id(self):
        """ The prev_map_id property. """
        return self.__prev_map_id
    
    @prev_map_id.setter
    def prev_map_id(self, value):
        if value > 558:
            value = 3
        self.__prev_map_id = value

    # functions

    def init_json(self):
        with open(self.path_map_properties,"r") as file:
            self.map_properties_json = json.load(file)
            file.close()

        with open(self.path_map_data,"r") as file:
            self.map_data_json = json.load(file)
            file.close()

    def init_ram_section(self):
        self.ram_section = [0]*(30*30) # assuming starting with clean data, and moving into a jubilife map as first id
        self.set_ram_header(self.aslr)
        self.save_states = []

    def init_data(self):
        self.x_pos = 380
        self.y_pos = 2400

        self.steps = 32
        self.multiply_steps = False
        self.map_ids = []
        self.current_map_id = 0
        self.prev_map_id = -1

        self.load_ram_data(self.current_map_id)
        self.add_save_state(self.ram_section,self.x_pos,self.y_pos)


    def load_save_state(self,id):
        self.ram_section = self.save_states[id]

    def add_save_state(self,ram_section,x_pos,y_pos):
        count_states = len(self.save_states)
        if count_states >= 32: #amount of savestates
            self.save_states.pop(0)
        self.save_states.append({"ram_section":ram_section,"x_pos":x_pos,"y_pos":y_pos})

        # print(self.save_states[count_states-1])
        # print(count_states)


    @lru_cache
    def map_id_to_color(self,map_id):
        if map_id > 558:
            return self.map_properties_json["jubilife"]["color"]

        for group in self.map_properties_json:
            if map_id in self.map_properties_json[group]["map_ids"]:
                return self.map_properties_json[group]["color"]
        return self.map_properties_json["default"]["color"]
        

    def set_ram_header(self,aslr):
        header = [0x616d,0x70,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x5544,0x0,0xad8,0x0,0xfdc8,0x228,0x1a7c,0x229,0x0,0x0,0x0,0x0,0x0,0x0,0xb,0x0]
        self.address_lengths_instance = len(header) # start of instance length declaration in header
        header.extend([0]*8) # add empty data for length of instances
        self.address_pointer_instances = len(header)
        header.extend([0]*8) # add empty data for pointers of instances
        self.address = len(header) # start general data after header

        for i in range(len(header)):
            self.ram_section[i] = header[i]

    def set_length_instance_in_header(self,instance_id,data):
        self.ram_section[self.address_lengths_instance+2*instance_id] = data  # add length of instance in header
        self.ram_section[self.address_lengths_instance+2*instance_id+1] = 0x0

    def set_pointer_instance_in_header(self,instance_id,address=None):
        if address == None:
            pointer = 0
        else:
            pointer = address*2 + self.start_mapdata + 0x4
        pointer_l,pointer_h = mapdataRepository.split_32_bit(pointer)
        self.ram_section[self.address_pointer_instances +2*instance_id] = pointer_l  # add pointer of instance in header
        self.ram_section[self.address_pointer_instances +2*instance_id+1] = pointer_h

    @lru_cache
    def get_map_data(self,map_id):
        if map_id > 558: # error handler converts invalid map id's to 3
            map_id = 3

        map_data = self.map_data_json[str(map_id)].items()
        return map_data

    def load_ram_data(self,map_id):
        address = self.address
        instances = ["objects","sprites","warps","triggers"] # all data present in mapdata
        current_instance = 0
        
        for _ in range(4): # clear header data
            self.set_length_instance_in_header(current_instance,0)
            self.set_pointer_instance_in_header(current_instance)
            self.ram_section[address] = 0x0 # add length of instance before instance data
            address += 1
            self.ram_section[address] = 0x0
            address += 1
            current_instance += 1    
        
        current_instance = 0
        address = self.address

        json_data = self.get_map_data(map_id)
        for map_data_type,data_instance in json_data:
            if map_data_type in instances:
                while map_data_type != instances[current_instance]: # if the instance is not in the dump, add 0 as length in header
                    self.set_length_instance_in_header(current_instance,0)
                    self.set_pointer_instance_in_header(current_instance)                        
                    self.ram_section[address] = 0x0
                    for _ in range(2):
                        self.ram_section[address] = 0  # add length of instance before instance data
                        address += 1
                    current_instance += 1

                self.set_length_instance_in_header(current_instance,len(data_instance))
                self.set_pointer_instance_in_header(current_instance,address)
                current_instance += 1

                self.ram_section[address] = len(data_instance) # add length of instance before instance data
                address += 1
                self.ram_section[address] = 0x0
                address += 1

                for data in data_instance.values():
                    for value in data.values():
                        self.ram_section[address] = value # add all values of instance
                        address += 1

        while current_instance < 4:
            for _ in range(2):
                self.ram_section[address] = 0 # add length of instance before (nonexistent) instance
                address += 1
            current_instance += 1

        self.length_added_ram = address + 4*2 + 1

    def load_consecutive_maps(self,map_id_list,waitperiod=0):
        for map_id in map_id_list:
            self.load_ram_data(map_id)
            time.sleep(waitperiod)

    def pos_to_offset(self,start_pos=2250,map_width=30):
        self.x_offs = (self.x_pos // 32)
        self.y_offs = (self.y_pos //32)*map_width
        return self.x_offs + self.y_offs - start_pos
    
    def offset_to_pos(self,map_width=30):
        self.x_pos = self.x_offs * 32
        self.y_pos = self.y_offs * 32 // map_width
        return self.x_pos,self.y_pos

    def move_player(self,direction):
        directions = ["up","left","down","right"]
        steps = self.steps
        if self.multiply_steps == True:
            steps *=  32
        if type(direction) == str:
            if direction.lower() in directions:
                if direction.lower() == directions[0]:
                    self.y_pos -= steps
                if direction.lower() == directions[1]:
                    self.x_pos -= steps
                if direction.lower() == directions[2]:
                    self.y_pos += steps
                if direction.lower() == directions[3]:
                    self.x_pos += steps
                return self.x_pos , self.y_pos


    @staticmethod
    def split_32_bit(value,endian_type=0):
        if endian_type == 1:
            return (value & 0xFFFF0000) >> 16,(value & 0xFFFF)
        else:
            return (value & 0xFFFF),(value & 0xFFFF0000) >> 16