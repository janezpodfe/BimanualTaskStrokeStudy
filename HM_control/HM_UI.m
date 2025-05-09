function varargout = HM_UI(varargin)
% HM_UI MATLAB code for HM_UI.fig
%      HM_UI, by itself, creates a new HM_UI or raises the existing
%      singleton*.
%
%      H = HM_UI returns the handle to a new HM_UI or the handle to
%      the existing singleton*.
%
%      HM_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HM_UI.M with the given input arguments.
%
%      HM_UI('Property','Value',...) creates a new HM_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HM_UI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HM_UI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HM_UI

% Last Modified by GUIDE v2.5 10-Jan-2019 15:38:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HM_UI_OpeningFcn, ...
                   'gui_OutputFcn',  @HM_UI_OutputFcn, ...
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


% --- Executes just before HM_UI is made visible.
function HM_UI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HM_UI (see VARARGIN)

% Choose default command line output for HM_UI
handles.output = hObject;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HM_UI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = HM_UI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tg
tg.start


% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global tg
tg.stop


function damping_value_Callback(hObject, eventdata, handles)
% hObject    handle to damping_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of damping_value as text
%        str2double(get(hObject,'String')) returns contents of damping_value as a double


global tg
input_param = getparamid(tg, 'Damping', 'Value');
setparam(tg, input_param, str2num(get(hObject,'String')));



% --- Executes during object creation, after setting all properties.
function damping_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to damping_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in start_collect.
function start_collect_Callback(hObject, eventdata, handles)
% hObject    handle to start_collect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('saveDataToFile','SimulationCommand','start');


% --- Executes on button press in stop_collect.
function stop_collect_Callback(hObject, eventdata, handles)
% hObject    handle to stop_collect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set_param('saveDataToFile','SimulationCommand','stop');



function deviationPosition_Callback(hObject, eventdata, handles)
% hObject    handle to deviationPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deviationPosition as text
%        str2double(get(hObject,'String')) returns contents of deviationPosition as a double
global tg
input_param = getparamid(tg, 'DeviationWindow', 'Value');
setparam(tg, input_param, str2num(get(hObject,'String')))


% --- Executes during object creation, after setting all properties.
function deviationPosition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deviationPosition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deviationScale_Callback(hObject, eventdata, handles)
% hObject    handle to deviationScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deviationScale as text
%        str2double(get(hObject,'String')) returns contents of deviationScale as a double
global tg
input_param = getparamid(tg, 'DeviationForScale', 'Value');
setparam(tg, input_param, str2num(get(hObject,'String')))


% --- Executes during object creation, after setting all properties.
function deviationScale_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deviationScale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deviationAngle1_Callback(hObject, eventdata, handles)
% hObject    handle to deviationAngle1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deviationAngle1 as text
%        str2double(get(hObject,'String')) returns contents of deviationAngle1 as a double

global tg
input_param = getparamid(tg, 'DeviationForAngle(degree)', 'Value');
setparam(tg, input_param, str2num(get(hObject,'String')))


% --- Executes during object creation, after setting all properties.
function deviationAngle1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deviationAngle1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function deviationAngle2_Callback(hObject, eventdata, handles)
% hObject    handle to deviationAngle2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of deviationAngle2 as text
%        str2double(get(hObject,'String')) returns contents of deviationAngle2 as a double

global tg
input_param = getparamid(tg, 'DeviationForAngle(degree)Exp2', 'Value');
setparam(tg, input_param, str2num(get(hObject,'String')))


% --- Executes during object creation, after setting all properties.
function deviationAngle2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to deviationAngle2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numberofTarget_Callback(hObject, eventdata, handles)
% hObject    handle to numberofTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberofTarget as text
%        str2double(get(hObject,'String')) returns contents of numberofTarget as a double

global tg
input_param = getparamid(tg, 'NumberOfTarget', 'Value');
setparam(tg, input_param, str2num(get(hObject,'String')))


% --- Executes during object creation, after setting all properties.
function numberofTarget_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberofTarget (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numberofRepeatation_Callback(hObject, eventdata, handles)
% hObject    handle to numberofRepeatation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numberofRepeatation as text
%        str2double(get(hObject,'String')) returns contents of numberofRepeatation as a double

global tg
input_param = getparamid(tg, 'NumberOfRepeatation', 'Value');
setparam(tg, input_param, str2num(get(hObject,'String')))


% --- Executes during object creation, after setting all properties.
function numberofRepeatation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numberofRepeatation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in save_file.
function save_file_Callback(hObject, eventdata, handles)
% hObject    handle to save_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set_param('saveDataToFile/To File','file name','b')



function nameofFile_Callback(hObject, eventdata, handles)
% hObject    handle to nameofFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nameofFile as text
%        str2double(get(hObject,'String')) returns contents of nameofFile as a double

%setparam(tg, input_param, str2num(get(hObject,'String')));
set_param('saveDataToFile/To File','file name',(get(hObject,'String')));


% --- Executes during object creation, after setting all properties.
function nameofFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nameofFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
