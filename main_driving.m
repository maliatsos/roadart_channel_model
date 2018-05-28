% script created by Kostas Maliatsos for UPRC
% current version 02/12/2017
%% Main driving script:

time_axis = 0:linkParams.vehicular_sampling_period:linkParams.sim_duration;
record_route_x = zeros(layoutParams.num_moving_scatterers, length(time_axis));
record_route_y = zeros(layoutParams.num_moving_scatterers, length(time_axis));
instant_speed = zeros(layoutParams.num_moving_scatterers, length(time_axis));
recorded_direction = zeros(layoutParams.num_moving_scatterers, length(time_axis)-1);
close all
tic

h = waitbar(0,  'Please wait - the highway environment is simulated');
for ll = 1 : length(time_axis)
    [vehicles, layoutParams, record_route_x(:,ll), record_route_y(:,ll), instant_speed(:, ll)] = driving(vehicles, linkParams.vehicular_sampling_period, layoutParams);
    %     scatter(layoutParams.moving_scatterers_loc(~isnan(layoutParams.moving_scatterers_loc(:,1)),1), layoutParams.moving_scatterers_loc(~isnan(layoutParams.moving_scatterers_loc(:,1)),2));
%     btn = zoom_overtake(1, vehicles, layoutParams);

    waitbar(ll/length(time_axis));
end
% Extract direction for vehicles:

for kk = 1 : layoutParams.num_moving_scatterers
    tmp = direction_movement([record_route_x(kk,:)', record_route_y(kk,:)']);
    recorded_direction(kk,:) = tmp';
end
toc
close(h)