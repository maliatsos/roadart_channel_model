function [pathlosses_v2v, pathlosses_buildings, pathlosses_signs, pathlosses_bridges]= pathlosses_per_path(snapshot, linkParams, ...
    distances_v2v, distances_buildings, distances_signs, distances_bridges, v2v_id, building_id, sign_id, bridge_id)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

%% Determine Path losses per path
time = linkParams.time_axis(snapshot);
distances = zeros(length(v2v_id),1);
for kk = 1 : length(v2v_id)
    distances(kk) = interp1(0:linkParams.vehicular_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period, distances_v2v(v2v_id(kk),:), time, 'pchip');
end
pathlosses_v2v =  pathloss_NLoS(distances, linkParams);
distances = zeros(length(building_id),1);
for kk = 1 : length(building_id)
    distances(kk) = interp1(0:linkParams.vehicular_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period, distances_buildings(building_id(kk),:), time, 'pchip');
end
pathlosses_buildings =  pathloss_NLoS(distances, linkParams);

distances = zeros(length(sign_id),1);
for kk = 1 : length(sign_id)
    distances(kk) = interp1(0:linkParams.vehicular_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period, distances_signs(sign_id(kk),:), time, 'pchip');
end
pathlosses_signs =  pathloss_NLoS(distances, linkParams);

distances = zeros(length(bridge_id),1);
for kk = 1 : length(bridge_id)
    distances(kk) = interp1(0:linkParams.vehicular_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period, distances_bridges(bridge_id(kk),:), time, 'pchip');
end
pathlosses_bridges =  pathloss_NLoS(distances, linkParams);
