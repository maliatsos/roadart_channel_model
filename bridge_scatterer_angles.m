function [phi_aods, phi_aoas, distances] = bridge_scatterer_angles(index, linkParams, layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

time = linkParams.time_axis(index);
vehicular_sampling_period = linkParams.vehicular_sampling_period;
coordinates_tx = linkParams.route_tx(index,:);
coordinates_rx = linkParams.route_rx(index,:);
direction_tx = linkParams.direction_of_movement_tx(index);
direction_rx = linkParams.direction_of_movement_rx(index);

time = floor(time/vehicular_sampling_period)+1;
tmp = sum(linkParams.actives_bridges,1);
phi_aods = zeros(tmp(time),1);
phi_aoas = zeros(tmp(time),1);
distances = zeros(tmp(time),1);

counter = 1;
for kk = 1 : layoutParams.num_bridges
    if linkParams.actives_bridges(kk,time)
        y1 = coordinates_tx(2);
        x1 = coordinates_tx(1);
        y2 = layoutParams.bridge_scatterers(kk,2);
        x2 = layoutParams.bridge_scatterers(kk,1);
        y3 = coordinates_rx(2);
        x3 = coordinates_rx(1);
        
        slope = (y2 - y1)/(x2-x1);
        angle_between = atan(slope);
        if y1>y2 && x1>x2
            angle_between = -pi+angle_between;
        elseif y2>y1 && x1>x2
            angle_between = pi-angle_between;
        end
        phi_aods(counter) = angle_between - direction_tx;
        
        slope = (y2 - y3)/(x2-x3);
        angle_between = atan(slope);
        if y3>y2 && x3>x2
            angle_between = -pi+angle_between;
        elseif y2>y3 && x3>x2
            angle_between = pi-angle_between;
        end
        phi_aoas(counter) = angle_between - direction_rx;
        
        distances(counter) = sqrt(abs(x2-x1)^2 + abs(y2-y1)^2) + sqrt(abs(x2-x3)^2 + abs(y2-y3)^2);
        counter = counter + 1;
    end
end