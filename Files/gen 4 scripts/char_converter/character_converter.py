import json
import pathlib

path = str(pathlib.Path(__file__).parent.resolve())

class CharConverter():
    def __init__(self):
        self.char_map = self.load_json(path + "/char_map.json")["characters"]
        self.rev_char_map = {v: k for k, v in self.char_map.items()}

    def convert_to_ascii(self,char_array,as_string=False):
        ascii_array = []
        try:
            for c in char_array:
                c_str = hex(c)[2:].zfill(4).upper()
                ascii_array.append(self.char_map.get(c_str,"'Invalid'"))

            if as_string: return "".join(ascii_array)
            return ascii_array
        except Exception as ex:
            print(ex)

    def convert_to_ingame(self,ascii_str,as_string=False):
        char_array = []
        try: 
            for c in ascii_str:
                c_id = self.rev_char_map.get(c,c)
                for i in range(len(c_id)):
                    if c_id[i] == "0":
                        c_id = c_id[1:]
                        continue
                    break
                c_id = "0x" + c_id.lstrip("0"*(4-c_id.count("0")))
                char_array.append(c_id)

            if as_string: return "".join(char_array)
            return char_array 
        except Exception as ex:
            print(ex)

    @staticmethod
    def load_json(filename):
        with open(filename,"r",encoding="utf8") as f:
            json_obj = json.load(f)
            return json_obj

    @staticmethod
    def convert_string_array(input_str):
        try:
            if type(input_str) != str or input_str == "":
                return [0x12C,0x145,0x148,0x1DE,0x12F,0x14B,0x14B]
            return [int(i.replace("'",""),16) for i in input_str.replace("0x","").split(",")]
        except Exception as ex:
            print(f"invalid input:{ex}")
            return [0x12C,0x145,0x148,0x1DE,0x12F,0x14B,0x14B]

if __name__ == '__main__':
    converter = CharConverter()

    input_type = input("press 1 for ascii-ingame, else ingame-ascii")
    input_v = "/"

    if input_type != "1":
        while input_v != "":
             input_v =  input("\nIngame -> ASCII\n\tText to convert: ")
             input_v = converter.convert_string_array(input_v)
             ascii_txt = converter.convert_to_ascii(input_v,True)
             print(ascii_txt)

    while input_v != "":
        input_v =  input("\nASCII -> Ingame\n\tText to convert: ")
        input_v = input_v if input_v != "" else "Bad Egg"
        ingame_txt = converter.convert_to_ingame(input_v,False)
        print(ingame_txt)
