function varargout = roadart_simulator(varargin)

%main function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

% ROADART_SIMULATOR MATLAB code for roadart_simulator.fig
%      ROADART_SIMULATOR, by itself, creates a new ROADART_SIMULATOR or raises the existing
%      singleton*.
%
%      H = ROADART_SIMULATOR returns the handle to a new ROADART_SIMULATOR or the handle to
%      the existing singleton*.
%
%      ROADART_SIMULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ROADART_SIMULATOR.M with the given input arguments.
%
%      ROADART_SIMULATOR('Property','Value',...) creates a new ROADART_SIMULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before roadart_simulator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to roadart_simulator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help roadart_simulator

% Last Modified by GUIDE v2.5 22-Apr-2016 03:32:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @roadart_simulator_OpeningFcn, ...
                   'gui_OutputFcn',  @roadart_simulator_OutputFcn, ...
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


% --- Executes just before roadart_simulator is made visible.
function roadart_simulator_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to roadart_simulator (see VARARGIN)

% Choose default command line output for roadart_simulator
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes roadart_simulator wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = roadart_simulator_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in OK.
function OK_Callback(hObject, eventdata, handles)
% hObject    handle to OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
layoutParams = struct('box_length', [], 'turn_factor', [], 'road_side1', [], 'road_side2', [], 'arc_length', [],...
'num_lanes', [], 'lane_width', [], 'opp_direction', [], 'barrier_flag', [], 'barrier_width', [], ...
'x_axis', [], 'own_lane_cordinates', [], 'opp_lane_cordinates', [], 'own_lane_derivatives', [], 'opp_lane_derivatives', [], 'barrier_cordinates', [],...
'signage_density', [], 'num_signs', [], 'sign_scatterers', [], 'phi_signs', [],...
'bridge_height', [], 'bridge_scatterers', [], 'num_bridges', [],...
 'lower_speed', [], 'higher_speed', [],...
'traffic_density', [], 'num_moving_scatterers', [], 'moving_scatterers_loc', [], 'moving_scatterers_speed', [], 'moving_scatterers_lanes', [],'moving_scatterers_direction',[],...
'building_density', [], 'num_buildings', [], 'building_height', [], 'phi_buildings', []);

tmp = (get(handles.building_density, 'String'));
layoutParams.building_density = str2double(tmp);
tmp = (get(handles.num_lanes, 'String'));
layoutParams.num_lanes = str2double(tmp);
tmp = (get(handles.box_width, 'String'));
layoutParams.box_length = str2double(tmp);
tmp = (get(handles.turn_factor, 'String'));
layoutParams.turn_factor = str2double(tmp);
tmp = (get(handles.lane_width, 'String'));
layoutParams.lane_width = str2double(tmp);
tmp = (get(handles.signage_density, 'String'));
layoutParams.signage_density = str2double(tmp);
tmp = (get(handles.bridge_height, 'String'));
layoutParams.bridge_height = str2double(tmp); % in m
tmp = (get(handles.building_height, 'String'));
layoutParams.building_height = str2double(tmp);
tmp = (get(handles.traffic_density, 'String'));
layoutParams.traffic_density = str2double(tmp);
tmp = (get(handles.low_speed, 'String'));
layoutParams.lower_speed = str2double(tmp);
tmp = (get(handles.high_speed, 'String'));
layoutParams.higher_speed = str2double(tmp);

tmp = get(handles.opp_direction, 'Value');
if tmp ==1
    layoutParams.opp_direction = 1;
else
    layoutParams.opp_direction = 0;
end
%% Create the road:
layoutParams = create_road(layoutParams);
message = sprintf(' Road created...\n');
msgbox(message)
close

%% Static Scatterers:
% Create signage and bridges:
layoutParams = create_signage_scatterers(layoutParams);
message = sprintf(' Road created...\n Signs, bridges etc. created...\n');
msgbox(message)
close

% Create random buildings:
layoutParams = create_buildings(layoutParams);
message = sprintf(' Road created...\n Signs, bridges etc. created...\n Buildings created...\n');
msgbox(message)
close

%% Moving Scatterers:
layoutParams = create_moving_scatterers(layoutParams);
message = sprintf(' Road created...\n Signs, bridges etc. created...\n Buildings created...\n Vehicles initialized...\n');
msgbox(message)
close

vehicles = create_vehicle_objects(layoutParams);
message = sprintf(' Road created...\n Signs, bridges etc. created...\n Buildings created...\n Vehicles initialized...\n Vehicles created...\n');
msgbox(message)
pause(1);
close

type = 'ura';
tmp = (get(handles.size_tx, 'String'));
tmp  = str2num(tmp);
sizes_x = tmp(1);
sizes_y = tmp(2);
tmp = (get(handles.distance_tx, 'String'));
distances_x = str2num(tmp);
distances_y = str2num(tmp);
TxParams = struct('type', type, 'sizes_x', sizes_x, 'sizes_y', sizes_y, 'distances_x', distances_x, 'distances_y', distances_y);

type = 'ura';
tmp = (get(handles.size_rx, 'String'));
tmp  = str2num(tmp);
sizes_x = tmp(1);
sizes_y = tmp(2);
tmp = (get(handles.distance_rx, 'String'));
distances_x = str2num(tmp);
distances_y = str2num(tmp);
RxParams = struct('type', type, 'sizes_x', sizes_x, 'sizes_y', sizes_y, 'distances_x', distances_x, 'distances_y', distances_y);



linkParams = struct('vehicular_sampling_period',[],'time_sampling_period',[], 'rx_sensitivity', [], 'sim_duration', [], 'maximum_distance', [],...
    'direction_of_movement_tx', [], 'direction_of_movement_rx', [], 'LoSconditions', [], 'route_tx', [], 'route_rx', [],...
    'time_axis', [], 'frequency', [], 'lambda', [], 'height_tx', [], 'height_rx', [],...
    'num_rays_buildings', [], 'num_rays_signs', [], 'num_rays_bridges', [], 'num_rays_v2v', [],...
    'bandwidth', [], 'frequency_bins', [], 'stationarity_snapshots', []);

tmp = (get(handles.time_sampling_period, 'String'));
linkParams.time_sampling_period = str2double(tmp);
tmp = (get(handles.vehicular_sampling_period, 'String'));
linkParams.vehicular_sampling_period = str2double(tmp);
tmp = (get(handles.sim_duration, 'String'));
linkParams.sim_duration  = str2double(tmp);
linkParams.time_axis = 0:linkParams.time_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period;
tmp = (get(handles.max_distance, 'String'));
linkParams.maximum_distance = str2double(tmp);
tmp = (get(handles.rx_sensitivity, 'String'));
linkParams.rx_sensitivity = str2double(tmp);
tmp = (get(handles.sim_duration, 'String'));
linkParams.sim_duration  = str2double(tmp);

tmp = (get(handles.height_tx, 'String'));
linkParams.height_tx  = str2double(tmp);
tmp = (get(handles.height_rx, 'String'));
linkParams.height_rx  = str2double(tmp);
tmp = (get(handles.frequency, 'String'));
linkParams.frequency  = str2double(tmp)*1e9;
c = 299792458;
linkParams.lambda = c/linkParams.frequency;
tmp = (get(handles.bandwidth, 'String'));
linkParams.bandwidth = str2double(tmp)*1e6;
tmp = (get(handles.frequency_bins, 'String'));
linkParams.frequency_bins = str2double(tmp);
tmp = (get(handles.stationarity_snapshots, 'String'));
linkParams.stationarity_snapshots  = str2double(tmp);
tmp = (get(handles.num_rays_building, 'String'));
linkParams.num_rays_buildings = str2double(tmp)*1e6;
tmp = (get(handles.num_rays_signs, 'String'));
linkParams.num_rays_signs = str2double(tmp);
tmp = (get(handles.num_rays_bridges, 'String'));
linkParams.num_rays_bridges  = str2double(tmp);
tmp = (get(handles.num_rays_v2v, 'String'));
linkParams.num_rays_v2v  = str2double(tmp);
message = sprintf('Link parameters defined...\n');
msgbox(message)
pause(1);
close

%% Emulate driving...:
main_driving;
% load('results.mat');

% main_linkParams;
% 
%% Find Transmitter and Receiver:
[id_tx, id_rx, distances] = find_TxRx(record_route_x, record_route_y, linkParams.maximum_distance, layoutParams);
% 
% 
%% Interpolate Route to time_sampling_period
route_tx_dec = [record_route_x(id_tx,:)' record_route_y(id_tx,:)'];
route_rx_dec = [record_route_x(id_rx,:)' record_route_y(id_rx,:)'];
linkParams.tx_id = id_tx;
linkParams.rx_id = id_rx;

[linkParams.route_tx, linkParams.route_rx, linkParams.speed_tx, linkParams.speed_rx] = interpolate_routesTxRx(id_tx, id_rx, record_route_x, record_route_y, instant_speed, linkParams);

%% Determine LoS:
linkParams.LoSconditions = determineTxRx_LoS(layoutParams, route_tx_dec, route_rx_dec, linkParams);
%% Determine direction of movement:
linkParams.direction_of_movement_tx = direction_movement(linkParams.route_tx);
linkParams.direction_of_movement_rx = direction_movement(linkParams.route_rx);

% load('results1.mat')
%% Determine building scatterers:
main_run_channels;
close all;
play_video;

% --- Executes on button press in cancel.
function cancel_Callback(hObject, eventdata, handles)
% hObject    handle to cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all
return


function num_lanes_Callback(hObject, eventdata, handles)
% hObject    handle to num_lanes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_lanes as text
%        str2double(get(hObject,'String')) returns contents of num_lanes as a double


% --- Executes during object creation, after setting all properties.
function num_lanes_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_lanes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lane_width_Callback(hObject, eventdata, handles)
% hObject    handle to lane_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lane_width as text
%        str2double(get(hObject,'String')) returns contents of lane_width as a double


% --- Executes during object creation, after setting all properties.
function lane_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lane_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function low_speed_Callback(hObject, eventdata, handles)
% hObject    handle to low_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of low_speed as text
%        str2double(get(hObject,'String')) returns contents of low_speed as a double


% --- Executes during object creation, after setting all properties.
function low_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to low_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function high_speed_Callback(hObject, eventdata, handles)
% hObject    handle to high_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of high_speed as text
%        str2double(get(hObject,'String')) returns contents of high_speed as a double


% --- Executes during object creation, after setting all properties.
function high_speed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to high_speed (see GCBO)
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



function box_width_Callback(hObject, eventdata, handles)
% hObject    handle to box_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of box_width as text
%        str2double(get(hObject,'String')) returns contents of box_width as a double


% --- Executes during object creation, after setting all properties.
function box_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to box_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function building_density_Callback(hObject, eventdata, handles)
% hObject    handle to building_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of building_density as text
%        str2double(get(hObject,'String')) returns contents of building_density as a double


% --- Executes during object creation, after setting all properties.
function building_density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to building_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function building_height_Callback(hObject, eventdata, handles)
% hObject    handle to building_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of building_height as text
%        str2double(get(hObject,'String')) returns contents of building_height as a double


% --- Executes during object creation, after setting all properties.
function building_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to building_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function signage_density_Callback(hObject, eventdata, handles)
% hObject    handle to signage_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of signage_density as text
%        str2double(get(hObject,'String')) returns contents of signage_density as a double


% --- Executes during object creation, after setting all properties.
function signage_density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to signage_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_bridges_Callback(hObject, eventdata, handles)
% hObject    handle to num_bridges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_bridges as text
%        str2double(get(hObject,'String')) returns contents of num_bridges as a double


% --- Executes during object creation, after setting all properties.
function num_bridges_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_bridges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bridge_height_Callback(hObject, eventdata, handles)
% hObject    handle to bridge_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bridge_height as text
%        str2double(get(hObject,'String')) returns contents of bridge_height as a double


% --- Executes during object creation, after setting all properties.
function bridge_height_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bridge_height (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in opp_direction.
function opp_direction_Callback(hObject, eventdata, handles)
% hObject    handle to opp_direction (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of opp_direction


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2



function barrier_width_Callback(hObject, eventdata, handles)
% hObject    handle to barrier_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of barrier_width as text
%        str2double(get(hObject,'String')) returns contents of barrier_width as a double


% --- Executes during object creation, after setting all properties.
function barrier_width_CreateFcn(hObject, eventdata, handles)
% hObject    handle to barrier_width (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function turn_factor_Callback(hObject, eventdata, handles)
% hObject    handle to turn_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of turn_factor as text
%        str2double(get(hObject,'String')) returns contents of turn_factor as a double


% --- Executes during object creation, after setting all properties.
function turn_factor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to turn_factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function traffic_density_Callback(hObject, eventdata, handles)
% hObject    handle to traffic_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of traffic_density as text
%        str2double(get(hObject,'String')) returns contents of traffic_density as a double


% --- Executes during object creation, after setting all properties.
function traffic_density_CreateFcn(hObject, eventdata, handles)
% hObject    handle to traffic_density (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4



function bandwidth_Callback(hObject, eventdata, handles)
% hObject    handle to bandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bandwidth as text
%        str2double(get(hObject,'String')) returns contents of bandwidth as a double


% --- Executes during object creation, after setting all properties.
function bandwidth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bandwidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function time_sampling_period_Callback(hObject, eventdata, handles)
% hObject    handle to time_sampling_period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of time_sampling_period as text
%        str2double(get(hObject,'String')) returns contents of time_sampling_period as a double


% --- Executes during object creation, after setting all properties.
function time_sampling_period_CreateFcn(hObject, eventdata, handles)
% hObject    handle to time_sampling_period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in antenna_type_rx.
function antenna_type_rx_Callback(hObject, eventdata, handles)
% hObject    handle to antenna_type_rx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns antenna_type_rx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from antenna_type_rx


% --- Executes during object creation, after setting all properties.
function antenna_type_rx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to antenna_type_rx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in antenna_type_tx.
function antenna_type_tx_Callback(hObject, eventdata, handles)
% hObject    handle to antenna_type_tx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns antenna_type_tx contents as cell array
%        contents{get(hObject,'Value')} returns selected item from antenna_type_tx


% --- Executes during object creation, after setting all properties.
function antenna_type_tx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to antenna_type_tx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function max_distance_Callback(hObject, eventdata, handles)
% hObject    handle to max_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_distance as text
%        str2double(get(hObject,'String')) returns contents of max_distance as a double


% --- Executes during object creation, after setting all properties.
function max_distance_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_distance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frequency_Callback(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frequency as text
%        str2double(get(hObject,'String')) returns contents of frequency as a double


% --- Executes during object creation, after setting all properties.
function frequency_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function vehicular_sampling_period_Callback(hObject, eventdata, handles)
% hObject    handle to vehicular_sampling_period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vehicular_sampling_period as text
%        str2double(get(hObject,'String')) returns contents of vehicular_sampling_period as a double


% --- Executes during object creation, after setting all properties.
function vehicular_sampling_period_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vehicular_sampling_period (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4


% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function size_rx_Callback(hObject, eventdata, handles)
% hObject    handle to size_rx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of size_rx as text
%        str2double(get(hObject,'String')) returns contents of size_rx as a double


% --- Executes during object creation, after setting all properties.
function size_rx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to size_rx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rx_sensitivity_Callback(hObject, eventdata, handles)
% hObject    handle to rx_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of rx_sensitivity as text
%        str2double(get(hObject,'String')) returns contents of rx_sensitivity as a double


% --- Executes during object creation, after setting all properties.
function rx_sensitivity_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rx_sensitivity (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function distance_rx_Callback(hObject, eventdata, handles)
% hObject    handle to distance_rx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of distance_rx as text
%        str2double(get(hObject,'String')) returns contents of distance_rx as a double


% --- Executes during object creation, after setting all properties.
function distance_rx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distance_rx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function size_tx_Callback(hObject, eventdata, handles)
% hObject    handle to size_tx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of size_tx as text
%        str2double(get(hObject,'String')) returns contents of size_tx as a double


% --- Executes during object creation, after setting all properties.
function size_tx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to size_tx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function tx_pwr_Callback(hObject, eventdata, handles)
% hObject    handle to tx_pwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of tx_pwr as text
%        str2double(get(hObject,'String')) returns contents of tx_pwr as a double


% --- Executes during object creation, after setting all properties.
function tx_pwr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tx_pwr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function distance_tx_Callback(hObject, eventdata, handles)
% hObject    handle to distance_tx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of distance_tx as text
%        str2double(get(hObject,'String')) returns contents of distance_tx as a double


% --- Executes during object creation, after setting all properties.
function distance_tx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to distance_tx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_rays_v2v_Callback(hObject, eventdata, handles)
% hObject    handle to num_rays_v2v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_rays_v2v as text
%        str2double(get(hObject,'String')) returns contents of num_rays_v2v as a double


% --- Executes during object creation, after setting all properties.
function num_rays_v2v_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_rays_v2v (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_rays_bridges_Callback(hObject, eventdata, handles)
% hObject    handle to num_rays_bridges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_rays_bridges as text
%        str2double(get(hObject,'String')) returns contents of num_rays_bridges as a double


% --- Executes during object creation, after setting all properties.
function num_rays_bridges_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_rays_bridges (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_rays_signs_Callback(hObject, eventdata, handles)
% hObject    handle to num_rays_signs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_rays_signs as text
%        str2double(get(hObject,'String')) returns contents of num_rays_signs as a double


% --- Executes during object creation, after setting all properties.
function num_rays_signs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_rays_signs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function num_rays_building_Callback(hObject, eventdata, handles)
% hObject    handle to num_rays_building (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of num_rays_building as text
%        str2double(get(hObject,'String')) returns contents of num_rays_building as a double


% --- Executes during object creation, after setting all properties.
function num_rays_building_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_rays_building (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function frequency_bins_Callback(hObject, eventdata, handles)
% hObject    handle to frequency_bins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frequency_bins as text
%        str2double(get(hObject,'String')) returns contents of frequency_bins as a double


% --- Executes during object creation, after setting all properties.
function frequency_bins_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frequency_bins (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sim_duration_Callback(hObject, eventdata, handles)
% hObject    handle to sim_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sim_duration as text
%        str2double(get(hObject,'String')) returns contents of sim_duration as a double


% --- Executes during object creation, after setting all properties.
function sim_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sim_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_rx_Callback(hObject, eventdata, handles)
% hObject    handle to height_rx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height_rx as text
%        str2double(get(hObject,'String')) returns contents of height_rx as a double


% --- Executes during object creation, after setting all properties.
function height_rx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height_rx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function height_tx_Callback(hObject, eventdata, handles)
% hObject    handle to height_tx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of height_tx as text
%        str2double(get(hObject,'String')) returns contents of height_tx as a double


% --- Executes during object creation, after setting all properties.
function height_tx_CreateFcn(hObject, eventdata, handles)
% hObject    handle to height_tx (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function stationarity_snapshots_Callback(hObject, eventdata, handles)
% hObject    handle to stationarity_snapshots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stationarity_snapshots as text
%        str2double(get(hObject,'String')) returns contents of stationarity_snapshots as a double


% --- Executes during object creation, after setting all properties.
function stationarity_snapshots_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stationarity_snapshots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
