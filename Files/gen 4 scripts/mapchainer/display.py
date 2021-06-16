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
        self.width = 640
        self.height = 480

        self.sq_sz = 40
        self.hex = True
        self.boxes = []

        self.initUI()


    def initUI(self):
        self.setWindowTitle(self.title)
        self.setGeometry(self.left, self.top, self.width, self.height)
        self.draw_boxes()
        self.show()
        

    def draw_boxes(self):
        for i in range(len(mapdata.ram_section)):
            if self.hex == True:
                self.boxes.append(QPushButton(str(hex(mapdata.ram_section[i])), self))
            else: 
                self.boxes.append(QPushButton(str(mapdata.ram_section[i]), self))
            self.boxes[i].resize(self.sq_sz,self.sq_sz)
            self.boxes[i].move(self.sq_sz*(i%30)+5,5+self.sq_sz*(i//30))
            # print(self.map_id_to_color(self.ram_section[i]))
            self.boxes[i].setStyleSheet(f"border-width: 0px; border-style: solid;background-color : {mapdata.map_id_to_color(mapdata.ram_section[i])} ")
            self.boxes[i].setFont(QFont("Arial", 6))

    
if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = App()
    sys.exit(app.exec_())
