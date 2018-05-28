function [phi_aods, phi_aoas, distances] = building_scatterer_angles2(id_scatterers, linkParams, layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

persistent max_building size_time
if isempty(max_building)
    tmp = sum(linkParams.actives_buildings);
    max_building = max(tmp); 
    size_time = length(linkParams.time_axis);
end
phi_aods = zeros(max_building,size_time);
phi_aoas = zeros(max_building,size_time);
distances = zeros(max_building,size_time);

coordinates_tx = linkParams.route_tx;
coordinates_rx = linkParams.route_rx;
direction_tx = linkParams.direction_of_movement_tx;
direction_rx = linkParams.direction_of_movement_rx;

time = floor(linkParams.time_axis/linkParams.vehicular_sampling_period)+1;


y1 = coordinates_tx(:,2);
x1 = coordinates_tx(:,1);
y2 = layoutParams.building_scatterers(id_scatterers,2);
x2 = layoutParams.building_scatterers(id_scatterers,1);
y3 = coordinates_rx(:,2);
x3 = coordinates_rx(:,1);
for kk = 1 : length(id_scatterers)
    slope = (y2(kk)-y1)./(x2(kk)-x1);
    angle_between = atan(slope);
    ind1 = (y1>y2(kk)) & (x1>x2(kk));
    angle_between(ind1) = -pi+angle_between(ind1);
    ind2 = (y1<y2(kk)) & (x1>x2(kk));
    angle_between(ind2) = pi-angle_between;
end

counter = 1;
for kk = 1 : layoutParams.num_buildings
    if linkParams.actives_buildings(kk, time)
        y1 = coordinates_tx(2);
        x1 = coordinates_tx(1);
        y2 = layoutParams.building_scatterers(kk,2);
        x2 = layoutParams.building_scatterers(kk,1);
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