function [linkParams, distances_v2v, distances_buildings,...
    distances_signs, distances_bridges] = determine_active_scatterers(record_route_x, record_route_y, linkParams, layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

step = linkParams.vehicular_sampling_period/linkParams.time_sampling_period;
y1 = linkParams.route_tx(1:step:end,2);
x1 = linkParams.route_tx(1:step:end,1);
y3 = linkParams.route_tx(1:step:end,2);
x3 = linkParams.route_tx(1:step:end,1);
distances_v2v = zeros(layoutParams.num_moving_scatterers, length(x1));
pathlosses_v2v = zeros(layoutParams.num_moving_scatterers, length(x1));
received_pwr = zeros(layoutParams.num_moving_scatterers, length(x1));
actives_v2v = zeros(layoutParams.num_moving_scatterers, length(x1));
for kk = 1 : layoutParams.num_moving_scatterers
    if kk~=linkParams.tx_id && kk~=linkParams.rx_id
        x2 = record_route_x(kk, 1:end-1)';
        y2 = record_route_y(kk, 1:end-1)';
        distances_v2v(kk, :) = sqrt(abs(x2-x1).^2 + abs(y2-y1).^2) + sqrt(abs(x2-x3).^2 + abs(y2-y3).^2);
        pathlosses_v2v(kk,:) = pathloss_NLoS(distances_v2v(kk, :), linkParams);
    else
        distances_v2v(kk, :) = NaN;
        pathlosses_v2v(kk,:) = NaN;
    end
    received_pwr(kk,:) = 36 - pathlosses_v2v(kk,:);
    actives_v2v(kk,:) = received_pwr(kk,:)>linkParams.rx_sensitivity;
end
% actives_v2v = sparse(actives_v2v);


%% Buildings:
distances_buildings = zeros(layoutParams.num_buildings, length(x1));
pathlosses_buildings = zeros(layoutParams.num_buildings, length(x1));
actives_buildings = zeros(layoutParams.num_buildings, length(x1));
for kk = 1 : layoutParams.num_buildings
    x2 = layoutParams.building_scatterers(kk,1);
    y2 = layoutParams.building_scatterers(kk,2);
    distances_buildings(kk, :) = sqrt(abs(x2-x1).^2 + abs(y2-y1).^2) + sqrt(abs(x2-x3).^2 + abs(y2-y3).^2);
    pathlosses_buildings(kk,:) = pathloss_NLoS(distances_buildings(kk, :), linkParams);
    received_pwr(kk,:) = 30 - pathlosses_buildings(kk,:);
    actives_buildings(kk,:) = received_pwr(kk,:)>linkParams.rx_sensitivity;
end
% actives_buildings = sparse(actives_buildings);

%% Signs:
distances_signs = zeros(layoutParams.num_signs, length(x1));
pathlosses_signs = zeros(layoutParams.num_signs, length(x1));
actives_signs = zeros(layoutParams.num_signs, length(x1));

for kk = 1 : layoutParams.num_signs
    x2 = layoutParams.sign_scatterers(kk,1);
    y2 = layoutParams.sign_scatterers(kk,2);
    distances_signs(kk, :) = sqrt(abs(x2-x1).^2 + abs(y2-y1).^2) + sqrt(abs(x2-x3).^2 + abs(y2-y3).^2);
    pathlosses_signs(kk,:) = pathloss_NLoS(distances_signs(kk, :), linkParams);
    received_pwr(kk,:) = 30 - pathlosses_signs(kk,:);
    actives_signs(kk,:) = received_pwr(kk,:)>linkParams.rx_sensitivity;
end
% actives_signs = sparse(actives_signs);

%% Bridges
distances_bridges = zeros(layoutParams.num_bridges, length(x1));
pathlosses_bridges = zeros(layoutParams.num_bridges, length(x1));
actives_bridges = zeros(layoutParams.num_bridges, length(x1));
for kk = 1 : layoutParams.num_bridges
    x2 = layoutParams.bridge_scatterers(kk,1);
    y2 = layoutParams.bridge_scatterers(kk,2);
    distances_bridges(kk, :) = sqrt(abs(x2-x1).^2 + abs(y2-y1).^2) + sqrt(abs(x2-x3).^2 + abs(y2-y3).^2);
    pathlosses_bridges(kk,:) = pathloss_NLoS(distances_bridges(kk, :), linkParams);
    received_pwr(kk,:) = 36 - pathlosses_bridges(kk,:);
    actives_bridges(kk,:) = received_pwr(kk,:)>linkParams.rx_sensitivity;
end


linkParams.actives_v2v = actives_v2v;
linkParams.actives_buildings = actives_buildings;
linkParams.actives_signs = actives_signs;
linkParams.actives_bridges = actives_bridges;
% actives_bridges = sparse(actives_bridges);