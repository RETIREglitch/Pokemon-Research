# import json
import time
from functools import lru_cache
import sys

from PyQt5.QtWidgets import QApplication, QLabel, QMainWindow, QRadioButton, QWidget,QPushButton,QInputDialog,QLineEdit,QCompleter,QGridLayout
from PyQt5.QtCore import Qt, left
from PyQt5.QtCore import pyqtSlot
from PyQt5.QtGui import QIcon,QFont

from mapdataRepository import mapdataRepository

mapdata = mapdataRepository()

class App(QWidget):

    def __init__(self):
        super().__init__()
        self.title = "Map ID router by RETIRE"
        self.left = 20
        self.top = 40
        self.width = 1220
        self.height = 980

        self.square_sizes = [31,60]
        self.hex = False
        self.ram_addresses = []
        self.directions = []
        self.update_on_move = True

        self.initUI()


    def initUI(self):
        self.setWindowTitle(self.title)
        self.setStyleSheet("background-color: #111")
        self.setGeometry(self.left, self.top, self.width, self.height)
        self.prepare_directions()
        self.prepare_ram()
        mapdata.length_added_ram = len(mapdata.ram_section)
        self.update_ram()
        self.prepare_settings()
        self.setChildrenFocusPolicy(Qt.NoFocus,Qt.ClickFocus)
        self.show()

    def setChildrenFocusPolicy (self, policy,policy2):
        self.setFocusPolicy(policy2)
        def recursiveSetChildFocusPolicy (parentQWidget):
            for childQWidget in parentQWidget.findChildren(QWidget):
                childQWidget.setFocusPolicy(policy)
                recursiveSetChildFocusPolicy(childQWidget)
            for childQWidget in parentQWidget.findChildren(QLineEdit):
                childQWidget.setFocusPolicy(policy2)
                recursiveSetChildFocusPolicy(childQWidget)
        recursiveSetChildFocusPolicy(self)

    def keyPressEvent (self, event):
        # print(event.key())
        if event.key() == 16777234: # left arrow
            self.direction_request("left")
        if event.key()  == 16777235: # up arrow
            self.direction_request("up")
        if event.key() == 16777236: # right arrow
            self.direction_request("right")
        if event.key()  == 16777237: # down arrow
            self.direction_request("down")

        if event.key()  == 32: # spacebar
            address = mapdata.pos_to_offset()
            mapdata.prev_map_id = mapdata.current_map_id
            mapdata.current_map_id = mapdata.ram_section[address]
            self.load_selected_map(address)

        if event.key() == 16777220: # enter
            self.setFocus()
        if event.text() == 's':
            mapdata.add_save_state(mapdata.ram_section,mapdata.x_pos,mapdata.y_pos)


    def prepare_ram(self):
        for i in range(len(mapdata.ram_section)):
            self.ram_addresses.append(QPushButton(str(i), self))
            self.ram_addresses[i].resize(self.square_sizes[0],self.square_sizes[0])
            self.ram_addresses[i].move(10+self.square_sizes[0]*(i%30),10+self.square_sizes[0]*(i//30))
            self.ram_addresses[i].setFont(QFont("Arial", 10))
            self.ram_addresses[i].index = i
            self.ram_addresses[i].clicked.connect(self.select_map_by_click) 

    def prepare_directions(self):
        direction_txt = ["up","left","down","right"]
        for i in range(4):
            self.directions.append(QPushButton(str(i),self))
            self.directions[i].resize(self.square_sizes[1],self.square_sizes[1])
            self.directions[i].setText(direction_txt[i])
            self.directions[i].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : white")
            self.directions[i].setFont(QFont("Arial", 8))
            self.directions[i].clicked.connect(self.direction_request_by_click)

        horizontal_offset = 900
        vertical_offset = 810
        self.directions[0].move(horizontal_offset + 150,vertical_offset)
        self.directions[1].move(horizontal_offset+80,vertical_offset +70)
        self.directions[2].move(horizontal_offset+150,vertical_offset+70)
        self.directions[3].move(horizontal_offset+220,vertical_offset+70)

    def prepare_settings(self):
        horizontal_offset = 950
        vertical_offset = 20
        settings = [{'title':"Move by:",'input_type': int,'default':32},{'title':"placeholder",'input_type': str,'default':""}]
        self.text_fields = []
        self.text_labels = []
        spacing = 80
        for i in range(len(settings)):
            self.text_labels.append(QLabel(settings[i].get('title'),self))
            self.text_labels[i].resize(100,32)
            self.text_labels[i].move(horizontal_offset,vertical_offset+i*spacing)
            self.text_labels[i].setStyleSheet(f"border-width: 0px; border-style: solid;color : white")
            self.text_labels[i].setFont(QFont("Arial", 12))

            self.text_fields.append(QLineEdit(self))
            self.text_fields[i].resize(100,32)
            self.text_fields[i].move(horizontal_offset,vertical_offset+40+i*spacing)

            self.text_fields[i].setStyleSheet(f"border-width: 1px; border-style: solid;border-color: white;color:white;")
            self.text_fields[i].setFont(QFont("Arial", 12))
            self.text_fields[i].editingFinished.connect(self.send_input) # or textEdited
            self.text_fields[i].textEdited.connect(self.validate_input)
            self.text_fields[i].input_type = settings[i].get('input_type')
            self.text_fields[i].default = settings[i].get('default')
            self.text_fields[i].setText(str(self.text_fields[i].default))
            self.text_fields[i].value = self.text_fields[i].default
            self.text_fields[i].index = i

        self.step_type = QRadioButton(self)
        self.step_type.resize(100,32)
        self.step_type.move(horizontal_offset+ 120,vertical_offset+40)
        self.step_type.status = ["steps","maps"]
        self.step_type.state = 0
        self.step_type.setText(self.step_type.status[self.step_type.state])
        self.step_type.setStyleSheet(f"border-width: 0px; border-style: solid;color : white")
        self.step_type.setFont(QFont("Arial", 10))
        self.step_type.toggled.connect(self.toggle_radio_button)
        self.step_type.index = 0

    @pyqtSlot()
    def validate_input(self):
        sender = self.sender()
        if sender.input_type == int:
            if not sender.text().isnumeric():
                # print(sender.text())
                sender.setText(str(sender.text())[:-1])

    @pyqtSlot()
    def send_input(self):
        sender = self.sender()
        text = sender.text()
        if text == "":
            sender.setText(str(sender.default))
            text = sender.text()
        sender.value = int(text)

        self.update_fields()

    @pyqtSlot()
    def toggle_radio_button(self):
        sender = self.sender()
        new_state = (sender.state +1)%2
        sender.state = new_state
        sender.setText(sender.status[new_state])

        self.update_fields()
            
    def update_fields(self):
        mapdata.steps = self.text_fields[0].value
        if self.step_type.state == 1:
            mapdata.multiply_steps = True
        else:
            mapdata.multiply_steps = False


    

    @pyqtSlot()
    def select_map_by_click(self):
        button_index = self.sender().index
        self.reset_map_color(mapdata.pos_to_offset())
        self.button_to_pos(button_index)
        self.update_map_color(mapdata.pos_to_offset())

    def button_to_pos(self,index,map_width=30):
        mapdata.x_pos = (index%30)*32
        mapdata.y_pos = ((index+2250)//map_width)*32

    @pyqtSlot()
    def direction_request_by_click(self):
        direction = self.sender().text()
        self.direction_request(direction)

    def direction_request(self,direction):
        address1 = mapdata.pos_to_offset()
        mapdata.move_player(direction)
        address2 = mapdata.pos_to_offset()
        if self.update_on_move:
            if  (0 <= address1 < len(self.ram_addresses)) & (0 <= address2 < len(self.ram_addresses)):
                mapdata.prev_map_id = mapdata.current_map_id
                mapdata.current_map_id = mapdata.ram_section[address2]
                if mapdata.prev_map_id != mapdata.current_map_id:
                    self.load_selected_map(address2)
        self.reset_map_color(address1)
        self.update_map_color(address2)
        
    def reset_map_color(self,address):
        if  0 <= address < len(self.ram_addresses):
            background_color = mapdata.map_id_to_color(mapdata.ram_section[address])
            self.ram_addresses[address].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : {background_color}")
            self.ram_addresses[address].setFont(QFont("Arial", 6))

    def load_selected_map(self,address):
        if  0 <= address < len(self.ram_addresses):
            mapdata.load_ram_data(mapdata.current_map_id)
            self.update_ram()

    def update_map_color(self,address,background_color="white"):
        if  0 <= address < len(self.ram_addresses):

            self.ram_addresses[address].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : {background_color}")
            self.ram_addresses[address].setFont(QFont("Arial", 6))

    def update_ram(self):
        # with open("Files/gen 4 scripts/mapchainer/ramdumps.json","r") as file:
        #     json_obj = json.load(file)
        for i in range(mapdata.length_added_ram):

            # confirm_value = json_obj[str(0)][i]
            # if mapdata.ram_section[i] != confirm_value:
            #     if self.hex == True:
            #         self.ram_addresses.append(QPushButton(f"{hex(mapdata.ram_section[i])},{confirm_value}|", self))
            #     else: 
            #        self.ram_addresses.append(QPushButton(f"{mapdata.ram_section[i]},{confirm_value}|", self))
            # else: 

            if self.hex == True:
                self.ram_addresses[i].setText(str(hex(mapdata.ram_section[i])))
            else: 
                self.ram_addresses[i].setText(str(mapdata.ram_section[i]))

            # print(self.map_id_to_color(self.ram_section[i]))
            # if mapdata.ram_section[i] != confirm_value:
            #     self.ram_addresses[i].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : white")
            # else:
            if i == mapdata.pos_to_offset():
                background_color = "white"
            else:
                background_color = mapdata.map_id_to_color(mapdata.ram_section[i])
            self.ram_addresses[i].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : {background_color}")
            self.ram_addresses[i].setFont(QFont("Arial", 6))
        # file.close()



    
if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = App()
    sys.exit(app.exec_())
