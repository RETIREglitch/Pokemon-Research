import json

file_path = "Files/gen 4 scripts/mapchainer/map_data.json" 

def search_maps(requested_map_ids,skip_map_list):
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
                            if (value in requested_map_ids) and (value not in skip_map_list):

                                if return_map_id_list.get(map_id) == None:
                                    return_map_id_list[map_id] = []
                                if value not in return_map_id_list[map_id]:
                                    return_map_id_list[map_id].append(value)
    file.close()
    return return_map_id_list

def get_chains(range_search,requested_map_ids):
    chains = {}
    chain_depth_list = []
    search_map_list = requested_map_ids
    skip_map_list = []

    for i in range(range_search):
        chain_depth_list.append({})

        returned_chains = search_maps(search_map_list,skip_map_list)
        for k,v_list in returned_chains.items():
            if k not in search_map_list:
                search_map_list.append(k)   
            for v in v_list:
                    if v not in skip_map_list:
                        skip_map_list.append(v)
            if chains.get(k) != None:
                for v in v_list:
                    if v not in chains[k]:
                        chains[k].append(v)
            else:
                chains[k] = v_list

            if chain_depth_list[i].get(k) != None:
                chain_depth_list[i][k].append(v)
            else:
                chain_depth_list[i][k] = v_list
                
    return chain_depth_list



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
comma_seperated_map_ids = {}
main_chain_txt = ""

print("\nChain Request:")
for i in range(len(input_map_ids)):
    print(f"\tMap {i}:> {input_map_ids[i]}")


comma_seperated_map_ids[0] = [i for i in input_map_ids]

for r in range(range_search):
    comma_seperated_map_ids[r+1] = []

    current_chain = chain_depth_list[r]
    sorted_chain_keys = sorted(current_chain)
    print(f"\nChain {r+1}:")
    for i in range(len(sorted_chain_keys)):
        v_list = sorted(current_chain[sorted_chain_keys[i]])
        print(f"\tchain {i}:> {sorted_chain_keys[i]} writes {v_list}")
        comma_seperated_map_ids[r+1].append(sorted_chain_keys[i])

print("\n")
for i in range(range_search+1):
    if i == 0:
        print("Requested map ids:")
    else:
        print(f"Chain {i}")
    print(f"\t{comma_seperated_map_ids[i]}")