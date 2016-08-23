function varargout = panel4Edit(varargin)
% PANEL4EDIT MATLAB code for panel4Edit.fig
%      PANEL4EDIT, by itself, creates a new PANEL4EDIT or raises the existing
%      singleton*.
%
%      H = PANEL4EDIT returns the handle to a new PANEL4EDIT or the handle to
%      the existing singleton*.
%
%      PANEL4EDIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PANEL4EDIT.M with the given input arguments.
%
%      PANEL4EDIT('Property','Value',...) creates a new PANEL4EDIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before panel4Edit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to panel4Edit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help panel4Edit

% Last Modified by GUIDE v2.5 17-Aug-2016 16:18:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @panel4Edit_OpeningFcn, ...
                   'gui_OutputFcn',  @panel4Edit_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before panel4Edit is made visible.
function panel4Edit_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to panel4Edit (see VARARGIN)

% Choose default command line output for panel4Edit
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes panel4Edit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = panel4Edit_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

window = get(handles.listbox1,'String');
set(handles.listbox1,'String',{'Dev1';'Dev2';'Dev3'});

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%Print that the ICD is being tested in the text window
txtInfo = sprintf('Sending data to ICD');
history = get(handles.edit1, 'String');
history = strvcat(history,txtInfo);
set(handles.edit1, 'String', history);

%get the name of the master file,and values for the NI device and ComPort
handles=guidata(hObject);
mastername=handles.mastername;
communname=handles.comname;
NIID=handles.NIname;
%mastername=mastername{1};

%import the data from the master file, array of EGM files
filelist=importdata(mastername);

% set the killed variable to 0
handles=guidata(hObject);
handles.killed=0;
guidata(hObject,handles)

%put the length of the file list into handles.length
handles=guidata(hObject);
handles.length=length(filelist);
guidata(hObject,handles)

%loop for looping through each file in the masterfile
for(i= 1:length(filelist))
    %get and check the kill variable, if it was set break out of the loop
    handles=guidata(hObject);
    localkilled=handles.killed;
    if(localkilled==1) break;
    end
    %get the EGM fie name from the list
    EGM=filelist(i);
    EGM=EGM{1};
    
    %import the EGM data and plot the Atrial, Ventricular and Shock EGMs
    data = importdata(EGM);
    time = (0.001:0.001:30);
    at = data(1:end,1);
    vt = data(1:end,2);
    shk = data(1:end,3);
    guidata(hObject,handles);
    handles.input1 = time;
    handles.input2 = at;
    handles.input3 = vt;
    handles.input4 = shk;
    axes(handles.axes1)
    
    %plot atrial
    plot(handles.input1,handles.input2);
    axes(handles.axes2)
    %plot ventricular
    plot(handles.input1,handles.input3,'r');
    %plot shock
    axes(handles.axes3)
    plot(handles.input1,handles.input4,'k');
    space=' ';
    filepos=num2str(i);
    serverstring= 'START /B NetSerMuxADC';
    clientstring= 'ConsoleApplication1.exe';
    % make some strings that will be used to call the executables with
    % paramters
    serverstring=strcat(serverstring,{space},'1',{space},filepos,{space},communname);
    serverstring=serverstring{1};
    clientstring=strcat(clientstring,{space},filelist(i),{space},filepos,{space},'1',{space},'0',{space},NIID);
    clientstring=clientstring{1};
    %call the executables, always server first
    system(serverstring)
    system(clientstring)
    %check again to see if the process was killed
    handles=guidata(hObject);
    localkilled=handles.killed;
    if(localkilled~=1)
    %tell the user that an EGM file was finished
    txtInfo = sprintf('Finished EGM File');
    history = get(handles.edit1, 'String');
    history = strvcat(history,txtInfo);
    set(handles.edit1, 'String', history);
    end
end

%if the process was killed, tell the user, if not tell the user that a test
%was finished
if(localkilled~=1)
txtInfo = sprintf('Test Complete');
history = get(handles.edit1, 'String');
history = strvcat(history,txtInfo);
set(handles.edit1, 'String', history);
else
txtInfo = sprintf('Test Canceled');
history = get(handles.edit1, 'String');
history = strvcat(history,txtInfo);
set(handles.edit1, 'String', history);
end

%set killed back to 0
handles=guidata(hObject);
handles.killed=0;
guidata(hObject,handles)

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pause(0.25)

% set the killed variable
handles=guidata(hObject);
handles.killed=1;
guidata(hObject,handles)
%%kill the processes
system('TASKKILL /f /im NetSerMuxADC.exe');
system('TASKKILL /f /im ConsoleApplication1.exe');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
pause(0.25)
txtInfo = sprintf('Dev 1 Connected');
history = get(handles.edit1, 'String');
history = strvcat(history,txtInfo);
set(handles.edit1, 'String', history);

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on mouse press over axes background.
function axes1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%tell the user that the algorithm is being tested
txtInfo = sprintf('Sending data to Algorithm');
history = get(handles.edit1, 'String');
history = strvcat(history,txtInfo);
set(handles.edit1, 'String', history);

% get the NI device and Com number and the master file name 
handles=guidata(hObject);
mastername=handles.mastername;
communname=handles.comname;
NIID=handles.NIname;
%mastername=mastername{1};

%import the names in the master file 
filelist=importdata(mastername);

%set the killed variable to 0
handles=guidata(hObject);
handles.killed=0;
guidata(hObject,handles)

%get the amount of files that are going to be tested
handles=guidata(hObject);
handles.length=length(filelist);
guidata(hObject,handles);

%loop through all of the files 
for(i= 1:length(filelist))
    % check to see if the process was killed
    handles=guidata(hObject);
    localkilled=handles.killed;
    if(localkilled==1) break;
    end
    %get the name of the EGM file that is being sent 
    EGM=filelist(i);
    EGM=EGM{1};
    %import the EGM file and plot the EGM signals
    data = importdata(EGM);
    time = (0.001:0.001:30);
    at = data(1:end,1);
    vt = data(1:end,2);
    shk = data(1:end,3);
    guidata(hObject,handles);
    handles.input1 = time;
    handles.input2 = at;
    handles.input3 = vt;
    handles.input4 = shk;
    axes(handles.axes1)

    plot(handles.input1,handles.input2);
    axes(handles.axes2)

    plot(handles.input1,handles.input3,'r');
    axes(handles.axes3)

    plot(handles.input1,handles.input4,'k');
    space=' ';
    filepos=num2str(i);
    serverstring= 'START /B NetSerMuxADC';
    clientstring= 'ConsoleApplication1.exe';
    % create the strings so that the executables could be called
    serverstring=strcat(serverstring,{space},'2',{space},filepos,{space},communname);
    serverstring=serverstring{1};
    clientstring=strcat(clientstring,{space},filelist(i),{space},filepos,{space},'2',{space},'0',{space},NIID);
    clientstring=clientstring{1};
    %call the executables
    system(serverstring)
    system(clientstring)
    %check to see if the process is killed
    handles=guidata(hObject);
    localkilled=handles.killed;
    if(localkilled~=1)
    txtInfo = sprintf('Finished EGM File');
    history = get(handles.edit1, 'String');
    history = strvcat(history,txtInfo);
    set(handles.edit1, 'String', history);
    end
end
%tell the user that a test was done 
if(localkilled~=1)
txtInfo = sprintf('Test Complete');
history = get(handles.edit1, 'String');
history = strvcat(history,txtInfo);
set(handles.edit1, 'String', history);

else
txtInfo = sprintf('Test Canceled');
history = get(handles.edit1, 'String');
history = strvcat(history,txtInfo);
set(handles.edit1, 'String', history);
end
% reset the killed variable    
handles=guidata(hObject);
handles.killed=0;
guidata(hObject,handles)





function edit4_CreateFcn(hObject, eventdata, handles)
  set(hObject,'BackgroundColor','white');

function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double

%store the name of the masterfile
handles=guidata(hObject);
handles.mastername=get(hObject,'String');
guidata(hObject,handles);

% tell the user that the test file was entered
txtInfo = sprintf('Test File Entered');
history = get(handles.edit1, 'String');
history = strvcat(history,txtInfo);
set(handles.edit1, 'String', history);




% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)

%get the com value and the NI device number 
handles=guidata(hObject);
communname=handles.comname;
NIID=handles.NIname;
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB0
% handles    structure with handles and user data (see GUIDATA)

%tell the user that a test file is being compiled
txtInfo = sprintf('Compiling Test File');
history = get(handles.edit1, 'String');
history = strvcat(history,txtInfo);
set(handles.edit1, 'String', history);

% get the amount of files 
handles=guidata(hObject);
length=handles.length;
length=int2str(length);
    space=' ';

    serverstring= 'START /B NetSerMuxADC';
    clientstring= 'ConsoleApplication1.exe';
    
    serverstring=strcat(serverstring,{space},'1',{space},'1',{space},communname);
    serverstring=serverstring{1};
    clientstring=strcat(clientstring,{space},'done',{space},'1',{space},'1',{space},length,{space},NIID);
    clientstring=clientstring{1};
    %call the executable
    system(serverstring)
    system(clientstring)
 % tell the user that the test file is complete
txtInfo = sprintf('Test File Complete');
history = get(handles.edit1, 'String');
history = strvcat(history,txtInfo);
set(handles.edit1, 'String', history);




function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

%get the COM port name
handles=guidata(hObject);
handles.comname=get(hObject,'String');
guidata(hObject,handles);

%tell the user that the com port was entered 
txtInfo = sprintf('Comm Port entered');
history = get(handles.edit1, 'String');
history = strvcat(history,txtInfo);
set(handles.edit1, 'String', history);





% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


%get the NI device name
handles=guidata(hObject);
handles.NIname=get(hObject,'String');
guidata(hObject,handles);

%tell the user that an NI deivce was entered
txtInfo = sprintf('NI Device Entered');
history = get(handles.edit1, 'String');
history = strvcat(history,txtInfo);
set(handles.edit1, 'String', history);


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
