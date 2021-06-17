import json
import time

import sys
from PyQt5.QtWidgets import QApplication, QWidget,QPushButton,QMessageBox
from PyQt5.QtCore import Qt
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
        self.width = 1600
        self.height = 980

        self.square_sizes = [40,60]
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
        self.prepare_settings()
        self.prepare_ram()
        self.update_ram(False)
        self.setChildrenFocusPolicy(Qt.NoFocus)
        self.show()

    def setChildrenFocusPolicy (self, policy):
        def recursiveSetChildFocusPolicy (parentQWidget):
            for childQWidget in parentQWidget.findChildren(QWidget):
                childQWidget.setFocusPolicy(policy)
                recursiveSetChildFocusPolicy(childQWidget)
        recursiveSetChildFocusPolicy(self)

    def keyPressEvent (self, event):
        if event.key() == 16777234:
            self.direction_request("left")
        if event.key()  == 16777235:
            self.direction_request("up")
        if event.key() == 16777236:
            self.direction_request("right")
        if event.key()  == 16777237:
            self.direction_request("down")

        if event.key()  == 32:
            self.load_selected_map()

    def prepare_ram(self):
        for i in range(len(mapdata.ram_section)):
            self.ram_addresses.append(QPushButton(str(i), self))
            self.ram_addresses[i].resize(self.square_sizes[0],self.square_sizes[0])
            self.ram_addresses[i].move(10+self.square_sizes[0]*(i%30),10+self.square_sizes[0]*(i//30))
            self.ram_addresses[i].setFont(QFont("Arial", 10))

    def prepare_directions(self):
        directions = ["up","left","down","right"]
        direction_signs = ["^","v",">","<"]
        for i in range(4):
            self.directions.append(QPushButton(directions[i],self))
            self.directions[i].resize(self.square_sizes[1],self.square_sizes[1])
            self.directions[i].setText(directions[i])
            self.directions[i].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : white")
            self.directions[i].setFont(QFont("Arial", 6))
        
        self.directions[0].clicked.connect(lambda:self.direction_request(directions[0])) # for some reason this affects all buttons when inside a loop
        self.directions[1].clicked.connect(lambda:self.direction_request(directions[1]))
        self.directions[2].clicked.connect(lambda:self.direction_request(directions[2]))
        self.directions[3].clicked.connect(lambda:self.direction_request(directions[3]))

        self.directions[0].move(1400,830)
        self.directions[1].move(1330,900)
        self.directions[2].move(1400,900)
        self.directions[3].move(1470,900)


    def prepare_settings(self):
        options = ["steps","maps"]
        
    def direction_request(self,direction):
        address = mapdata.pos_to_offset() - 2250
        self.reset_map_color(address)
        mapdata.move_player(direction)
        address = mapdata.pos_to_offset() - 2250
        self.update_map_color(address)
        if self.update_on_move:
            self.load_selected_map()

    def reset_map_color(self,address):
        if (address >= 0) & (address < len(self.ram_addresses)) :
            background_color = mapdata.map_id_to_color(mapdata.ram_section[address])
            self.ram_addresses[address].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : {background_color}")
            self.ram_addresses[address].setFont(QFont("Arial", 6))

    def load_selected_map(self):
        address = mapdata.pos_to_offset() - 2250 
        if (address >= 0) & (address < len(self.ram_addresses)):       
                    mapdata.map_ids = [mapdata.ram_section[address]]
                    mapdata.load_consecutive_maps(mapdata.map_ids)
                    self.update_ram()
            



    def update_map_color(self,address,background_color="white"):
        if (address >= 0) & (address < len(self.ram_addresses)):

            self.ram_addresses[address].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : {background_color}")
            self.ram_addresses[address].setFont(QFont("Arial", 6))

    def update_ram(self,show=True):
        with open("Files/gen 4 scripts/mapchainer/ramdumps.json","r") as file:
            json_obj = json.load(file)
            for i in range(len(mapdata.ram_section)):

                # confirm_value = json_obj[str(0)][i]
                # if mapdata.ram_section[i] != confirm_value:
                #     if self.hex == True:
                #         self.ram_addresses.append(QPushButton(f"{hex(mapdata.ram_section[i])},{confirm_value}|", self))
                #     else: 
                #         self.ram_addresses.append(QPushButton(f"{mapdata.ram_section[i]},{confirm_value}|", self))
                # else:

                if self.hex == True:
                    self.ram_addresses[i].setText(str(hex(mapdata.ram_section[i])))
                else: 
                    self.ram_addresses[i].setText(str(mapdata.ram_section[i]))

                # print(self.map_id_to_color(self.ram_section[i]))
                # if mapdata.ram_section[i] != confirm_value:
                #     self.ram_addresses[i].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : white")
                # else:

                background_color = mapdata.map_id_to_color(mapdata.ram_section[i])
                if i == mapdata.pos_to_offset()-2250:
                    background_color = "white"
                self.ram_addresses[i].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : {background_color}")
                self.ram_addresses[i].setFont(QFont("Arial", 6))
        file.close()
        if show:
            self.show()



    
if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = App()
    sys.exit(app.exec_())
