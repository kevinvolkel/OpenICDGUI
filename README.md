# OpenICDGUI


EMEDIC folder contains the GUI for the Open ICD test automation platform.

The two other folders are source codes for the server and client used in the platform. The NetSerMuxADC folder conatins the source code for the server side that also communicates with the mbed. The Open ICD side Zip file contains the source code for program that is the client side and algorithm.

To run the GUI, in the EMEDIC folder get to the codegenTestFiles folder. In the codegenTestFiles folder run the panel4Edit.m file to open MATLAB. Run the script ad the GUI will pop up. Users can enter a test file in a text box along with selecting the mbed's COM port and the NI device's IDnumber. Clicking Test ICD runs the test file for the ICD device. Clicking Test Algorihtm tests the Open ICD algorithm against the test file. The disconnect button kills the process of sending a test file to either the Device or the Algorithm. The tool bar allows the user to manipulate the figure windows that plot the current atrial, ventricular, and shock EGMS. A test file that compares the performance of both the algorithm and real device can be compiled by clicking the compile test file button. In order to compile a test file, you have to both test the algorithm and the ICD device so that there are log files for the algorithm and device.

The MbedSoftware file contains the source code for the mbed microcontroller.
