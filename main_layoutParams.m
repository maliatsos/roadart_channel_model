% script created by Kostas Maliatsos for UPRC
% current version 02/12/2017

%% Create Geo-Route Params:
%% Create Layout:
layoutParams = struct('box_length', [], 'turn_factor', [], 'road_side1', [], 'road_side2', [], 'arc_length', [],...
'num_lanes', [], 'lane_width', [], 'opp_direction', [], 'barrier_flag', [], 'barrier_width', [], ...
'x_axis', [], 'own_lane_cordinates', [], 'opp_lane_cordinates', [], 'own_lane_derivatives', [], 'opp_lane_derivatives', [], 'barrier_cordinates', [],...
'signage_density', [], 'num_signs', [], 'sign_scatterers', [], 'phi_signs', [],...
'bridge_height', [], 'bridge_scatterers', [], 'num_bridges', [],...
 'lower_speed', [], 'higher_speed', [],...
'traffic_density', [], 'num_moving_scatterers', [], 'moving_scatterers_loc', [], 'moving_scatterers_speed', [], 'moving_scatterers_lanes', [],'moving_scatterers_direction',[],...
'building_density', [], 'num_buildings', [], 'building_height', [], 'phi_buildings', []);

layoutParams.num_lanes = 3;
layoutParams.box_length = 2000;
layoutParams.turn_factor = 4;
layoutParams.lane_width = 4;
layoutParams.opp_direction = 1;
layoutParams.signage_density = 15; % in signs per km
layoutParams.bridge_height = 5; % in m
layoutParams.building_density =18; % in km^2
layoutParams.building_height = 10;
layoutParams.traffic_density = 16; % vehicles per km
layoutParams.lower_speed = 40;
layoutParams.higher_speed = 90;

%% Create Transmitter / Create Receiver:
type = 'ura';
sizes = 4;
distances = 0.5;
num_tx_elements = sizes^2;
num_rx_elements = sizes^2;
distances_x = 0.5;
distances_y = 0.5;
sizes_x = 4;
sizes_y = 4;
TxParams = struct('type', type, 'sizes_x', sizes_x, 'sizes_y', sizes_y, 'distances_x', distances_x, 'distances_y', distances_y);
RxParams = struct('type', type, 'sizes_x', sizes_x, 'sizes_y', sizes_y, 'distances_x', distances_x, 'distances_y', distances_y);

%% Create the road:
layoutParams = create_road(layoutParams);
fprintf('Road created...\n');

%% Static Scatterers:
% Create signage and bridges:
layoutParams = create_signage_scatterers(layoutParams);
fprintf('Signs, bridges etc. created...\n');

% Create random buildings:
layoutParams = create_buildings(layoutParams);
fprintf('Buildings created...\n');

%% Moving Scatterers:
layoutParams = create_moving_scatterers(layoutParams);
fprintf('Vehicles initialized...\n');
vehicles = create_vehicle_objects(layoutParams);
fprintf('Vehicles created...\n');
% TxRx_initialize(layoutParams)