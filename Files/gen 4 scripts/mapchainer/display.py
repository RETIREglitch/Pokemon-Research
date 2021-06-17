import json

import sys
from PyQt5.QtWidgets import QApplication, QWidget,QPushButton
from PyQt5.QtCore import pyqtSlot
from PyQt5.QtGui import QIcon,QFont

from mapdataRepository import mapdataRepository

mapdata = mapdataRepository()


class App(QWidget):

    def __init__(self):
        super().__init__()
        self.title = "Map ID router by RETIRE"
        self.left = 120
        self.top = 120
        self.width = 1200
        self.height = 1000

        self.sq_sz = 40
        self.hex = False
        self.boxes = []

        self.initUI()


    def initUI(self):
        self.setWindowTitle(self.title)
        self.setGeometry(self.left, self.top, self.width, self.height)
        self.draw_boxes()
        self.show()
        

    def draw_boxes(self):
        with open("Files/gen 4 scripts/mapchainer/ramdumps.json","r") as file:
            json_obj = json.load(file)
            for i in range(len(mapdata.ram_section)):
                confirm_value = json_obj[str(mapdata.test_id)][i]
                if mapdata.ram_section[i] != confirm_value:
                    if self.hex == True:
                        self.boxes.append(QPushButton(f"{hex(mapdata.ram_section[i])},{confirm_value}|", self))
                    else: 
                        self.boxes.append(QPushButton(f"{mapdata.ram_section[i]},{confirm_value}|", self))
                else:
                    if self.hex == True:
                        self.boxes.append(QPushButton(str(hex(mapdata.ram_section[i])), self))
                    else: 
                        self.boxes.append(QPushButton(str(mapdata.ram_section[i]), self))
                self.boxes[i].resize(self.sq_sz,self.sq_sz)
                self.boxes[i].move(self.sq_sz*(i%30)+5,5+self.sq_sz*(i//30))
                # print(self.map_id_to_color(self.ram_section[i]))
                if mapdata.ram_section[i] != confirm_value:
                    self.boxes[i].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : white")
                else:
                    self.boxes[i].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : {mapdata.map_id_to_color(mapdata.ram_section[i])} ")
                self.boxes[i].setFont(QFont("Arial", 6))
        file.close()

    
if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = App()
    sys.exit(app.exec_())
