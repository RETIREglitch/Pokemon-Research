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
        self.row_position = 0
        self.col_position = 0
        self.follow_cam = True
        self.calc_range()
        self.initUI()


    def initUI(self):
        self.setWindowTitle(self.title)
        self.setStyleSheet("background-color: #111")
        self.setGeometry(self.left, self.top, self.width, self.height)
        self.prepare_directions()
        self.prepare_ram()
        self.prepare_savestates()
        self.update_ram()
        self.prepare_settings()

        self.setChildrenFocusPolicy(Qt.NoFocus,Qt.ClickFocus)
        self.update_map_color(mapdata.pos_to_offset())

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
            if self.follow_cam:
                self.col_position -= 1
            self.calc_range()
            self.direction_request("left")

        if event.key()  == 16777235: # up arrow
            if self.follow_cam:
                self.row_position -= 1
            self.calc_range()
            self.direction_request("up")

        if event.key() == 16777236: # right arrow
            if self.follow_cam:
                self.col_position += 1
            self.calc_range()
            self.direction_request("right")

        if event.key()  == 16777237: # down arrow
            if self.follow_cam:
                self.row_position += 1
                # print(self.global_address)
            self.calc_range()
            self.direction_request("down")

        if event.key()  == 32: # spacebar
            address = mapdata.pos_to_offset()
            mapdata.prev_map_id = mapdata.current_map_id
            mapdata.current_map_id = mapdata.ram_section[address]
            self.load_selected_map(address)
            self.update_map_color(address)
            self.update_fields_from_data()



        if event.key() == 16777220: # enter
            self.setFocus()
        # if event.text() == 's':
        #     mapdata.add_save_state(0,mapdata.ram_section.copy(),mapdata.x_pos,mapdata.y_pos)

    def calc_range(self):
        self.range_start = self.return_row() * mapdata.map_width
        if self.range_start > len(mapdata.ram_section) - 900:
            self.range_start = len(mapdata.ram_section) - 900
        if 0 > self.range_start: 
            self.range_start = 0

    def return_row(self):
        if mapdata.multiply_steps:
            return self.row_position * mapdata.steps
        return (self.row_position*mapdata.steps)//32
        
    def prepare_ram(self):
        for i in range(30*30):
            self.ram_addresses.append(QPushButton(str(i), self))
            self.ram_addresses[i].resize(self.square_sizes[0],self.square_sizes[0])
            self.ram_addresses[i].move(10+self.square_sizes[0]*(i%30),10+self.square_sizes[0]*(i//30))
            self.ram_addresses[i].setFont(QFont("Arial", 10))
            self.ram_addresses[i].index = i
            self.ram_addresses[i].value = i
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
        settings = [{'title':"Move by:",'input_type': int,'default':mapdata.steps},{'title':"X coordinate:",'input_type': int,'default':mapdata.x_pos},{'title':"Y coordinate:",'input_type': int,'default':mapdata.y_pos}]
        self.text_fields = []
        self.text_labels = []
        spacing = 72
        inner_spacing = 40
        for i in range(len(settings)):
            self.text_labels.append(QLabel(settings[i].get('title'),self))
            self.text_labels[i].resize(200,32)
            self.text_labels[i].move(horizontal_offset,vertical_offset+i*spacing)
            self.text_labels[i].setStyleSheet(f"border-width: 0px; border-style: solid;color : white")
            self.text_labels[i].setFont(QFont("Arial", 12))

            self.text_fields.append(QLineEdit(self))
            self.text_fields[i].resize(100,24)
            self.text_fields[i].move(horizontal_offset,vertical_offset+inner_spacing+i*spacing)

            self.text_fields[i].setStyleSheet(f"border-width: 1px; border-style: solid;border-color: white;color:white;")
            self.text_fields[i].setFont(QFont("Arial", 10))
            self.text_fields[i].editingFinished.connect(self.send_input) # or textEdited
            self.text_fields[i].textEdited.connect(self.validate_input)
            self.text_fields[i].input_type = settings[i].get('input_type')
            self.text_fields[i].default = settings[i].get('default')
            self.text_fields[i].setText(str(self.text_fields[i].default))
            self.text_fields[i].value = self.text_fields[i].default
            self.text_fields[i].index = i

        self.step_type = QRadioButton(self)
        self.step_type.resize(100,24)
        self.step_type.move(horizontal_offset+ 120,vertical_offset+inner_spacing)
        self.step_type.status = ["steps","maps"]
        self.step_type.state = 0
        self.step_type.setText(self.step_type.status[self.step_type.state])
        self.step_type.setStyleSheet(f"border-width: 0px; border-style: solid;color : white")
        self.step_type.setFont(QFont("Arial", 10))
        self.step_type.toggled.connect(self.toggle_radio_button)
        self.step_type.index = 0

    def prepare_savestates(self):
        horizontal_offset = 960
        vertical_offset = 300
        self.savestate_button = []
        spacing = 32
        for i in range(mapdata.max_save_states):
            self.savestate_button.append(QPushButton(f"State {i+1}",self))
            self.savestate_button[i].resize(100,24)
            self.savestate_button[i].move(horizontal_offset+(i//(mapdata.max_save_states//2))*140,vertical_offset+(i%(mapdata.max_save_states//2))*spacing)
            self.savestate_button[i].setStyleSheet(f"border-width: 1px; border-style: solid;border-color: white;color:white;")
            self.savestate_button[i].setFont(QFont("Arial", 10))
            self.savestate_button[i].index = i
            self.savestate_button[i].clicked.connect(self.handle_savestate)
        
        self.savestate_state_button = QPushButton("SAVE",self)
        self.savestate_state_button.resize(66,24)
        self.savestate_state_button.move(horizontal_offset+88,vertical_offset-40)
        self.savestate_state_button.setStyleSheet(f"border-width: 1px; border-style: solid;border-color: white;color:white;")
        self.savestate_state_button.setFont(QFont("Arial", 10))
        self.savestate_state_button.status = ["save","load"]
        self.savestate_state_button.state = 0
        self.savestate_state_button.clicked.connect(self.change_state_loading)

    @pyqtSlot()
    def change_state_loading(self):
        sender = self.sender()
        new_state = (sender.state +1)%2
        sender.state = new_state
        sender.setText(sender.status[new_state].upper())

    @pyqtSlot()
    def handle_savestate(self):
        sender = self.sender()
        if self.savestate_state_button.status[self.savestate_state_button.state] == "load":
            mapdata.load_save_state(sender.index)
            address = mapdata.pos_to_offset()

            self.update_ram()
            mapdata.prev_map_id = -1
            mapdata.current_map_id = -1
            self.update_map_color(address)
            self.update_fields_from_data()
        else:
            mapdata.add_save_state(sender.index,mapdata.ram_section.copy(),mapdata.x_pos,mapdata.y_pos)

    @pyqtSlot()
    def validate_input(self):
        sender = self.sender()
        if sender.input_type == int:
            if len(sender.text()) == 1:
                if sender.text()[0] == '-':
                    return
            if not self.is_digit(sender.text()):
                # print(sender.text())
                sender.setText(str(sender.text())[:-1])

    @pyqtSlot()
    def send_input(self):
        sender = self.sender()
        text = sender.text()
        if text == "":
            if sender.index in [0,2]:
                sender.setText(str(sender.default))
                sender.value = sender.default
            else:
                sender.setText(str(0))
                sender.value = 0
            text = sender.text()
        if text == "-":
            sender.setText(str(0))
            sender.value = 0

            text = sender.text()
        sender.value = int(text)
        self.update_data_from_fields()

    @pyqtSlot()
    def toggle_radio_button(self):
        sender = self.sender()
        new_state = (sender.state +1)%2
        sender.state = new_state
        sender.setText(sender.status[new_state])

        self.update_data_from_fields()
            
    def update_data_from_fields(self):
        mapdata.steps = self.text_fields[0].value
        mapdata.multiply_steps = [False,True][self.step_type.state]


        address1 = mapdata.pos_to_offset()
        mapdata.x_pos = self.text_fields[1].value
        mapdata.y_pos = self.text_fields[2].value
        address2 = mapdata.pos_to_offset()
        self.reset_and_update_map_color(address1,address2)

    def update_fields_from_data(self):
        data = [mapdata.steps,mapdata.x_pos,mapdata.y_pos]
        for i in range(len(self.text_fields)):
            self.text_fields[i].setText(str(data[i]))
            self.text_fields[i].value = data[i]

    @pyqtSlot()
    def select_map_by_click(self):
        button_index = self.sender().index
        address1 = mapdata.pos_to_offset()
        self.button_to_pos(button_index)
        address2 = mapdata.pos_to_offset()
        self.reset_and_update_map_color(address1,address2)
        self.update_fields_from_data()

    def button_to_pos(self,index,map_width=30):
        mapdata.x_pos = (index%30)*32
        mapdata.y_pos = ((index)//map_width)*32

    @pyqtSlot()
    def direction_request_by_click(self):
        direction = self.sender().text()
        self.direction_request(direction)

    def direction_request(self,direction):

        address1 = mapdata.pos_to_offset()
        mapdata.move_player(direction)
        address2 = mapdata.pos_to_offset()


        if self.update_on_move:
            if  0 <= address1 < len(mapdata.ram_section):
                if 0 <= address2 < len(mapdata.ram_section):
                    mapdata.prev_map_id = mapdata.current_map_id
                    mapdata.current_map_id = mapdata.ram_section[mapdata.pos_to_offset()]
                    self.load_selected_map(mapdata.pos_to_offset())
                    self.update_ram()
        self.update_map_color(address2)
        self.update_fields_from_data()
        
    def reset_map_color(self,address):
        index = address - self.range_start
        background_color = mapdata.map_id_to_color(self.ram_addresses[index].value)
        self.ram_addresses[index].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : {background_color}")
        self.ram_addresses[index].setFont(QFont("Arial", 6))

    def update_map_color(self,address,background_color="white"):
        index = address - self.range_start
        print(self.range_start)
        if 0 <= index <= len(mapdata.ram_section):
            self.ram_addresses[index].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : {background_color}")
            self.ram_addresses[index].setFont(QFont("Arial", 6))

    def reset_and_update_map_color(self,address1,address2):
        self.reset_map_color(address1)
        self.update_map_color(address2)

    def load_selected_map(self,address):
        if  0 <= address < len(mapdata.ram_section):
            mapdata.load_ram_data(mapdata.current_map_id)

    def update_ram(self):
        for i in range(self.range_start,self.range_start+900):
            if self.hex == True:
                self.ram_addresses[i-self.range_start].setText(str(hex(mapdata.ram_section[i])))
            else:
                self.ram_addresses[i-self.range_start].setText(str(mapdata.ram_section[i]))
            self.ram_addresses[i-self.range_start].value = mapdata.ram_section[i]
            self.ram_addresses[i-self.range_start].index = i

            background_color = mapdata.map_id_to_color(mapdata.ram_section[i])
            self.ram_addresses[i-self.range_start].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : {background_color}")
            self.ram_addresses[i-self.range_start].setFont(QFont("Arial", 6))

    @staticmethod
    def is_digit(n):
        try:
            int(n)
            return True
        except ValueError:
            return  False


    
if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = App()
    sys.exit(app.exec_())
