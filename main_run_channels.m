%script created by Kostas Maliatsos for UPRC
% current version 02/12/2017

results = struct('static_phi_aods', [], 'static_phi_aoas', [], 'sign_phi_aods', [], 'sign_phi_aoas', [], 'bridge_phi_aods', [], 'bridge_phi_aoas', [], ...
    'v2v_phi_aods', [], 'v2v_phi_aoas', []);
close all
message = 'Wait to generate radio channels';
msgbox(message);
size_time = length(linkParams.time_axis)-1;
c = 299792458;

% Determine active scatterers:
[linkParams, distances_v2v, distances_buildings,...
    distances_signs, distances_bridges] = determine_active_scatterers(record_route_x, record_route_y, linkParams, layoutParams);
% Determine scatterer gain:
linkParams = determine_path_gains(linkParams);

linkParams.total_num_building_scatterers = sum(linkParams.actives_buildings,1);
linkParams.total_num_sign_scatterers = sum(linkParams.actives_signs,1);
linkParams.total_num_bridge_scatterers = sum(linkParams.actives_bridges,1);
linkParams.total_num_v2v_scatterers = sum(linkParams.actives_v2v,1);

step = linkParams.vehicular_sampling_period/linkParams.time_sampling_period;

%% Initialize results:
for ll= 1 : size_time
    time = linkParams.time_axis(ll);
    kk = floor(time/linkParams.vehicular_sampling_period)+1;

    results(ll).static_ids = find(linkParams.actives_buildings(:,kk)==1);
    results(ll).static_phi_aods = zeros(linkParams.total_num_building_scatterers(kk), 1);
    results(ll).static_phi_aoas = zeros(linkParams.total_num_building_scatterers(kk), 1);
    results(ll).static_delays = zeros(linkParams.total_num_building_scatterers(kk), 1);
    results(ll).doppler_static = zeros(linkParams.total_num_building_scatterers(kk), 1);
    results(ll).static_distances = zeros(linkParams.total_num_building_scatterers(kk), 1);
    
    results(ll).sign_ids = find(linkParams.actives_signs(:,kk)==1);
    results(ll).sign_phi_aods = zeros(linkParams.total_num_sign_scatterers(kk),1);
    results(ll).sign_phi_aoas = zeros(linkParams.total_num_sign_scatterers(kk),1);
    results(ll).sign_delays = zeros(linkParams.total_num_sign_scatterers(kk),1);
    results(ll).doppler_signs = zeros(linkParams.total_num_sign_scatterers(kk),1);
    results(ll).sign_distances = zeros(linkParams.total_num_sign_scatterers(kk),1);
    
    results(ll).bridge_ids = find(linkParams.actives_bridges(:,kk)==1);
    results(ll).bridge_phi_aods = zeros(linkParams.total_num_bridge_scatterers(kk),1);
    results(ll).bridge_phi_aoas = zeros(linkParams.total_num_bridge_scatterers(kk),1);
    results(ll).bridge_delays = zeros(linkParams.total_num_bridge_scatterers(kk),1);
    results(ll).doppler_bridges = zeros(linkParams.total_num_bridge_scatterers(kk),1);
    results(ll).bridge_distances = zeros(linkParams.total_num_bridge_scatterers(kk),1);
    
    results(ll).v2v_ids = find(linkParams.actives_v2v(:,kk)==1);
    results(ll).v2v_phi_aods = zeros(linkParams.total_num_v2v_scatterers(kk),1);
    results(ll).v2v_phi_aoas = zeros(linkParams.total_num_v2v_scatterers(kk),1);
    results(ll).v2v_delays = zeros(linkParams.total_num_v2v_scatterers(kk),1);
    results(ll).doppler_v2v = zeros(linkParams.total_num_v2v_scatterers(kk),1);
    results(ll).v2v_distances = zeros(linkParams.total_num_v2v_scatterers(kk),1);
end

tic
str = ['Calculating ' , num2str(size_time-1) ,' MIMO Transmission parameters for Simulation duration  ', num2str(linkParams.sim_duration), ' sec'];
h = waitbar(0, str);

for kk = 1 : size_time
    % Determine angles from static scatterers:
    [results(kk).static_phi_aods(1:end), results(kk).static_phi_aoas(1:end), results(kk).static_distances(1:end)] = building_scatterer_angles(kk, linkParams, layoutParams);
    [results(kk).sign_phi_aods(1:end), results(kk).sign_phi_aoas(1:end), results(kk).sign_distances(1:end)] = signage_scatterer_angles(kk, linkParams, layoutParams);
    [results(kk).bridge_phi_aods(1:end), results(kk).bridge_phi_aoas(1:end), results(kk).bridge_distances(1:end)] = bridge_scatterer_angles(kk, linkParams, layoutParams);
    % Determine angles from moving scatterers:
    [results(kk).v2v_phi_aods(1:end), results(kk).v2v_phi_aoas(1:end) , results(kk).v2v_distances(1:end)] = moving_scatterers_angles(kk, record_route_x, record_route_y, linkParams, layoutParams);
    % Determine delays from all scatterers:
    [results(kk).v2v_delays(1:end), results(kk).static_delays(1:end), results(kk).sign_delays(1:end), results(kk).bridge_delays(1:end)] = ...
        path_delays(results(kk).v2v_distances, results(kk).static_distances, results(kk).sign_distances, results(kk).bridge_distances);
    % Determine dopplers for all static scatterers:
    [results(kk).doppler_static, results(kk).doppler_signs, results(kk).doppler_bridges]  = determine_static_dopplers(kk, linkParams, results(kk).static_phi_aods, results(kk).sign_phi_aods, results(kk).bridge_phi_aods,...
    results(kk).static_phi_aoas, results(kk).sign_phi_aoas, results(kk).bridge_phi_aoas);    % Determine dopplers for all static scatterers:
    % Determine dopplers for all moving scatterers:
    [results(kk).doppler_v2v, results(kk).relative_speed_rx, results(kk).relative_speed_tx]  = determine_moving_dopplers(kk, results(kk).v2v_ids, linkParams, results(kk).v2v_phi_aoas, results(kk).v2v_phi_aods, instant_speed, recorded_direction);
%     keyboard
    [results(kk).path_gains_v2v, results(kk).path_gains_buildings, results(kk).path_gains_signs, results(kk).path_gains_bridges] = store_path_gains(kk, linkParams);
    % Determine pathlosses for all
    [results(kk).pathlosses_v2v, results(kk).pathlosses_buildings, results(kk).pathlosses_signs, results(kk).pathlosses_bridges]= pathlosses_per_path(kk, linkParams, ...
    distances_v2v, distances_buildings, distances_signs, distances_bridges, results(kk).v2v_ids, results(kk).static_ids, results(kk).sign_ids, results(kk).bridge_ids);

    % TxRx distance:
    results(kk).TxRx_distance = sqrt(sum(abs(linkParams.route_rx(kk,:) - linkParams.route_tx(kk,:)).^2,2));
    results(kk).prop_delay = results(kk).TxRx_distance/c;
    
    waitbar(kk/size_time);
    
    results(kk).static_theta_aods = pi/12*ones(length(results(kk).static_phi_aods(1:end)),1);
    results(kk).static_theta_aoas = pi/12*ones(length(results(kk).static_phi_aods(1:end)),1);
    results(kk).sign_theta_aoas = zeros(length(results(kk).sign_phi_aods(1:end)),1);
    results(kk).sign_theta_aods = zeros(length(results(kk).sign_phi_aods(1:end)),1);
    results(kk).v2v_theta_aoas = zeros(length(results(kk).v2v_phi_aods(1:end)),1);
    results(kk).v2v_theta_aods = zeros(length(results(kk).v2v_phi_aods(1:end)),1);
    if ~isempty(results(kk).bridge_phi_aods)
        x = sqrt(abs(linkParams.route_tx(kk,1) - layoutParams.bridge_scatterers(results(kk).bridge_ids,1)).^2 + abs(linkParams.route_tx(kk,2) - layoutParams.bridge_scatterers(results(kk).bridge_ids,2)).^2);
        y = layoutParams.bridge_height;
        results(kk).bridge_theta_aods = atan(y./x);
        x = sqrt(abs(linkParams.route_rx(kk,1) - layoutParams.bridge_scatterers(results(kk).bridge_ids,1)).^2 + abs(linkParams.route_rx(kk,2) - layoutParams.bridge_scatterers(results(kk).bridge_ids,2)).^2);
        results(kk).bridge_theta_aoas = atan(y./x);
    else
        results(kk).bridge_theta_aoas = [];
        results(kk).bridge_theta_aods = [];
    end
    
end
toc
close(h)


str = ['Calculating ' , num2str(size_time-1) ,' MIMO Impulse Responses for Simulation duration  ', num2str(linkParams.sim_duration), ' sec'];


