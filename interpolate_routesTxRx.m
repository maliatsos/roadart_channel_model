function [route_tx, route_rx, speed_tx, speed_rx] = interpolate_routesTxRx(id_tx, id_rx, record_route_x, record_route_y, instant_speed, linkParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

route_tx = interp1(0:linkParams.vehicular_sampling_period:linkParams.sim_duration, record_route_x(id_tx,:), 0:linkParams.time_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period, 'pchip','extrap');
tmp = interp1(0:linkParams.vehicular_sampling_period:linkParams.sim_duration, record_route_y(id_tx,:), 0:linkParams.time_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period, 'pchip','extrap');
route_tx = [route_tx' tmp'];


route_rx = interp1(0:linkParams.vehicular_sampling_period:linkParams.sim_duration, record_route_x(id_rx,:), 0:linkParams.time_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period, 'pchip','extrap');
tmp = interp1(0:linkParams.vehicular_sampling_period:linkParams.sim_duration, record_route_y(id_rx,:), 0:linkParams.time_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period,'pchip','extrap');
route_rx = [route_rx' tmp'];

speed_tx = interp1(0:linkParams.vehicular_sampling_period:linkParams.sim_duration, instant_speed(id_tx,:), 0:linkParams.time_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period,'pchip','extrap');
speed_rx = interp1(0:linkParams.vehicular_sampling_period:linkParams.sim_duration, instant_speed(id_rx,:), 0:linkParams.time_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period,'pchip','extrap');
