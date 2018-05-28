function  [doppler_v2v, relative_speed_rx, relative_speed_tx]  = determine_moving_dopplers(snapshot, vehicle_ids, linkParams, v2v_phi_aoas, v2v_phi_aods, instant_speed, recorded_direction)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

% Determine speed for scatterers:
scatterer_speed = zeros(length(vehicle_ids), 1);
scatterer_direction = zeros(length(vehicle_ids), 1);
time_axis = 0:linkParams.vehicular_sampling_period:linkParams.sim_duration;
for kk = 1:length(vehicle_ids)
    ind2 = find(~isnan(instant_speed(vehicle_ids(kk),1:end-1)));
    scatterer_speed(kk) = interp1(time_axis(ind2), instant_speed(vehicle_ids(kk),ind2), linkParams.time_axis(snapshot), 'pchip');
    scatterer_direction(kk) = interp1(time_axis(ind2), recorded_direction(vehicle_ids(kk), ind2), linkParams.time_axis(snapshot), 'pchip');
end

% Determine relative speed (Tx part):
relative_speed_tx = [linkParams.speed_tx(snapshot).*cos(linkParams.direction_of_movement_tx(snapshot))- scatterer_speed.*cos(scatterer_direction),  linkParams.speed_tx(snapshot).*sin(linkParams.direction_of_movement_tx(snapshot)) - scatterer_speed.*sin(scatterer_direction)];
relative_speed_rx = [linkParams.speed_rx(snapshot).*cos(linkParams.direction_of_movement_rx(snapshot))- scatterer_speed.*cos(scatterer_direction),  linkParams.speed_rx(snapshot).*sin(linkParams.direction_of_movement_rx(snapshot)) - scatterer_speed.*sin(scatterer_direction)];

relative_speed_tx = sqrt(sum(abs(relative_speed_tx).^2,2));
relative_speed_rx = sqrt(sum(abs(relative_speed_rx).^2,2));

doppler1 = 0.277777778*relative_speed_tx.*cos(v2v_phi_aods-linkParams.direction_of_movement_tx(snapshot))/linkParams.lambda;
doppler2 = 0.277777778*relative_speed_rx.*cos(v2v_phi_aoas-linkParams.direction_of_movement_rx(snapshot))/linkParams.lambda;

doppler_v2v = doppler1 + doppler2;
