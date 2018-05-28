function [phi_aods, phi_aoas , distances] = moving_scatterers_angles(snapshot, record_route_x, record_route_y, linkParams, layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

vehicular_sampling_period = linkParams.vehicular_sampling_period;
time = floor(linkParams.time_axis(snapshot)/vehicular_sampling_period)+1;

tmp = sum(linkParams.actives_v2v);
phi_aods = zeros(tmp(time),1);
phi_aoas = zeros(tmp(time),1);
distances = zeros(tmp(time),1);

y1 = linkParams.route_tx(snapshot,2);
x1 = linkParams.route_tx(snapshot,1);
y3 = linkParams.route_rx(snapshot,2);
x3 = linkParams.route_rx(snapshot,1);
direction_tx = linkParams.direction_of_movement_tx;
direction_rx = linkParams.direction_of_movement_rx;

%% Calculate distances:

counter = 1;
for kk = 1 : layoutParams.num_moving_scatterers
    
    if (kk~= linkParams.tx_id && kk~= linkParams.rx_id) && linkParams.actives_v2v(kk,time)
        x2 = interp1(0:linkParams.vehicular_sampling_period:linkParams.sim_duration, record_route_x(kk,:), linkParams.time_axis(snapshot));
        y2 = interp1(0:linkParams.vehicular_sampling_period:linkParams.sim_duration, record_route_y(kk,:), linkParams.time_axis(snapshot));
        
        slope = (y2 - y1)/(x2-x1);
        angle_between = atan(slope);
        if y1>y2 && x1>x2
            angle_between = -pi+angle_between;
        elseif y2>y1 && x1>x2
            angle_between = pi-angle_between;
        end
        phi_aods(counter) = angle_between - direction_tx(kk);
        
        slope = (y2 - y3)/(x2-x3);
        angle_between = atan(slope);
        if y3>y2 && x3>x2
            angle_between = -pi+angle_between;
        elseif y2>y3 && x3>x2
            angle_between = pi-angle_between;
        end
        phi_aoas(counter) = angle_between - direction_rx(kk);
        distances(counter) = sqrt(abs(x2-x1)^2 + abs(y2-y1)^2) + sqrt(abs(x2-x3)^2 + abs(y2-y3)^2);

        counter = counter + 1;
    end
    
end