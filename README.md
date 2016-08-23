# OpenICDGUI


EMEDIC folder contains the GUI for the Open ICD test automation platform.

The two other folders are source codes for the Server and client used in the platform.

To run the GUI, in the EMEDIC folder get to the codegenTestFiles folder. In the folder run the .m file to open MATLAB. Run the script ad the GUI will pop up. Users can enter a test file in a text box along with slecting the mbed's COM port and the NI devices IDnumber. Clicking Test ICD runs the test file for the ICD device. Clicking Test Algorihtm tests the Open ICD algorithm against the test file. The disconnect button kills the process of sending a test file to either the Device or the Algorithm. The tool bar allows the user to manipulate the figure windows that plot the current atrial, ventricular, and shock EGMS.
