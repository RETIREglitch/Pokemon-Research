import json
import pathlib

path = str(pathlib.Path(__file__).parent.resolve())
chunk_path = path + "/chunk_data.json"

base = 0x226D320

def load_json(file):
    with open(file,"r") as file_:
        json_obj = json.load(file_)
    return json_obj

chunk_data = load_json(chunk_path)["dp"]

all_lowest_pointers = []
all_highest_pointers = []
all_pointers = []
pointer_maps = {}

def print_lowest_pointers():
    for group in chunk_data:
        map_data = chunk_data[group]
        pointers = map_data["chunk_pointers"]
        lowest_pointer = min(pointers)
        all_lowest_pointers.append(lowest_pointer)
        pointer_maps[lowest_pointer] = [group,map_data]

    all_lowest_pointers.sort()
    for pointer in all_lowest_pointers:
        group = pointer_maps[pointer]
        map_ids = group[1]["map_ids"]
        print(f"{group[0]}) {hex(pointer)}\n{map_ids}")
    print(all_lowest_pointers)


def print_highest_pointers():
    for group in chunk_data:
        map_data = chunk_data[group]
        pointers = map_data["chunk_pointers"]
        highest_pointer = max(pointers) + base
        all_highest_pointers.append(highest_pointer)
        pointer_maps[highest_pointer] = [group,map_data]

    all_highest_pointers.sort() #reverse=True
    for pointer in all_highest_pointers:
        group = pointer_maps[pointer]
        map_ids = group[1]["map_ids"]
        #print(f"{group[0]}) {hex(pointer)}\n{map_ids}")
    #print(all_highest_pointers)

def print_all_pointers():
    for group in chunk_data:
        map_data = chunk_data[group]
        pointers = map_data["chunk_pointers"]
        all_pointers.extend(pointers)

    all_pointers.sort() #reverse=True
    print(all_pointers)



# print_lowest_pointers()
# print_highest_pointers()
print_all_pointers()