from display import App 
import sys
from PyQt5.QtWidgets import QApplication

app = QApplication(sys.argv)
main = App()
sys.exit(app.exec_())