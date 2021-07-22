import json
import pathlib

file_path = str(pathlib.Path(__file__).parent.resolve()) + '/map_data.json'

def search_maps(requested_map_ids):
    return_map_id_list = {}
    with open(file_path,"r") as file:
        json_obj = json.load(file)
        for map_id,map_obj in json_obj.items():
            map_id = int(map_id)
            for map_data,map_value in map_obj.items():
                if map_data in ["sprites","objects","warps","triggers"]:
                    map_data_elements = map_obj.get(map_data,{})
                    for element_id, element_obj in map_data_elements.items():
                        for variable,value in element_obj.items():
                            if value > 558: # error handler makes invalid id's into map id 3
                                value = 3
                            if (value in requested_map_ids):
                                if return_map_id_list.get(map_id) == None:
                                    return_map_id_list[map_id] = []
                                if value not in return_map_id_list[map_id]:
                                    return_map_id_list[map_id].append(value)
    file.close()
    return return_map_id_list

def reverse_chain(chain):
    reversed_chain = {}
    for k,v in chain.items():
        for value in v:
            if value in reversed_chain.keys():
                reversed_chain[value].append(k)
            else:
                reversed_chain[value] = [k]
    return reversed_chain


def get_chains(range_search,requested_map_ids):
    chains = []
    for i in range(len(requested_map_ids)):
        chains.append([{requested_map_ids[i]:[]}])


    print("Requested Map Ids:")
    for map_request in chains:
        for i in range(range_search):
            map_request.append({})
            maps_to_search = list(map_request[i].keys())
            map_request[i+1] = search_maps(maps_to_search)

        print("\nRequest")

        for i in range(len(map_request)):
            if i != 0:
                print(f"Chain {i}:")
                reversed_chain = reverse_chain(map_request[i])
                for k,v in reversed_chain.items():
                    print(f"\tMap ID {k} is written by: {v}")


input_map_ids = [int(i) for i in input("Give the map ids to search for, seperated by a comma > ").strip(" ").split(",")]
requested_map_ids = input_map_ids.copy()
range_search = input("Input how many recursive searches > ")

if range_search != "":
    range_search = int(range_search)
    if range_search > 3:
        range_search = 3
else:
    range_search = 1

chain_depth_list = get_chains(range_search,requested_map_ids)
