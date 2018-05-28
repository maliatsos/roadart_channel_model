% script created by Kostas Maliatsos for UPRC
% current version 02/12/2017

%% Main File:
close all;
clc

%% Create LayoutParams: (edit main_layoutParams)
main_layoutParams;
% vehicles(1).speed = 160;
%% Create Measurement - Link Params:
main_linkParams;
fprintf('Link parameters defined...\n');

%% Emulate driving...:
main_driving;
% load('results.mat');
main_linkParams;
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

keyboard
