import sys
from PyQt5.QtCore import QProcess, Qt
from PyQt5.QtWidgets import QApplication, QMainWindow, QLabel, QPushButton, QVBoxLayout, QWidget, QFileDialog

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        # Set the window title
        self.setWindowTitle("Simple Qt App")

        # Create and set up the QLabel
        self.helloLabel = QLabel("Hello", self)
        self.helloLabel.setAlignment(Qt.AlignCenter)

        # Create and set up the QPushButton
        self.browseButton = QPushButton("Browse Files", self)
        self.browseButton.clicked.connect(self.browse_files)

        # Set the central widget to a layout containing the QLabel and QPushButton
        central_widget = QWidget(self)
        layout = QVBoxLayout(central_widget)
        layout.addWidget(self.helloLabel)
        layout.addWidget(self.browseButton)
        central_widget.setLayout(layout)

        self.setCentralWidget(central_widget)

    def browse_files(self):
        file_name, _ = QFileDialog.getOpenFileName(self, "Open Excel File", "", "Excel Files (*.xlsx *.xls)")
        if file_name:
            # Execute the R script with the selected file path
            QProcess.startDetached("Rscript", ["script.R", file_name])

            # Display a message
            self.helloLabel.setText(f"Analysis started for file:\n{file_name}")
        else:
            # User canceled file selection
            self.helloLabel.setText("Hello")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())

