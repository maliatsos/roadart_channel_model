function [vehicles, layoutParams] = change_lanes(id, vehicles, layoutParams, change_flag)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

% fprintf('Change lane call from id %d \n', id);
kk = id;

% keyboard 

% Change lane:
if change_flag == 1
    vehicles(kk).lane = vehicles(kk).lane + 1;
    vehicles(kk).speed = vehicles(kk).details.target_speed + 10;
elseif change_flag == -1;
    vehicles(kk).lane = vehicles(kk).lane - 1;
    if ~isempty(vehicles(kk).details)
       vehicles(kk).speed = vehicles(kk).details.speed_before_bypass;
    end
end

layoutParams.moving_scatterers_speed(kk) = vehicles(kk).speed;
if vehicles(kk).direction == 1
    vehicles(kk).y = interp1(layoutParams.x_axis, layoutParams.own_lane_cordinates(:,vehicles(kk).lane), vehicles(kk).x, 'pchip');
else
    vehicles(kk).y = interp1(layoutParams.x_axis, layoutParams.opp_lane_cordinates(:,vehicles(kk).lane), vehicles(kk).x, 'pchip');
end
layoutParams.moving_scatterers_loc(kk,2) = vehicles(kk).y;

%% Find new next and new previous: % For the bypassed vehicle and the vehicle behind you:
% Bypassed:
if vehicles(kk).next_vehicle_id~=0
    vehicles(vehicles(kk).next_vehicle_id).previous_vehicle_id = vehicles(kk).previous_vehicle_id;
    if vehicles(kk).previous_vehicle_id~=0
        vehicles(vehicles(kk).next_vehicle_id).distance_from_prev = sqrt(abs(vehicles(vehicles(kk).next_vehicle_id).x - vehicles(vehicles(kk).previous_vehicle_id).x)^2 + abs(vehicles(vehicles(kk).next_vehicle_id).y - vehicles(vehicles(kk).previous_vehicle_id).y)^2);
    else
        vehicles(vehicles(kk).next_vehicle_id).distance_from_prev = [];
    end
end
% Behind you...
if vehicles(kk).previous_vehicle_id~=0
    vehicles(vehicles(kk).previous_vehicle_id).next_vehicle_id = vehicles(kk).next_vehicle_id;
    if vehicles(kk).next_vehicle_id~=0
        vehicles(vehicles(kk).previous_vehicle_id).distance_from_next = sqrt(abs(vehicles(vehicles(kk).previous_vehicle_id).x - vehicles(vehicles(kk).next_vehicle_id).x)^2+abs(vehicles(vehicles(kk).previous_vehicle_id).y - vehicles(vehicles(kk).next_vehicle_id).y)^2);
    else
        vehicles(vehicles(kk).previous_vehicle_id).distance_from_next = [];
    end
end

% Find new next and new previous: % For the current vehicle
ind = find((layoutParams.moving_scatterers_direction == vehicles(kk).direction) & (layoutParams.moving_scatterers_lanes == vehicles(kk).lane));
distances = sqrt(abs(layoutParams.moving_scatterers_loc(ind,1) - vehicles(kk).x).^2 + abs(layoutParams.moving_scatterers_loc(ind,2)- vehicles(kk).y).^2);
distances(isnan(distances)) = Inf;

[distances, ind2] = sort(distances);
ind = ind(ind2);
% Previous:
flag = 1; counter = 1;
while flag == 1
    if counter <= length(ind)
        if vehicles(kk).direction == 1
            if vehicles(ind(counter)).x < vehicles(kk).x
                flag = 0;
                vehicles(kk).previous_vehicle_id = ind(counter);
                vehicles(ind(counter)).next_vehicle_id = kk;
                vehicles(kk).distance_from_prev = distances(counter);
                vehicles(ind(counter)).distance_from_next = distances(counter);
            end
        else
            if vehicles(ind(counter)).x > vehicles(kk).x
                flag = 0;
                vehicles(kk).previous_vehicle_id = ind(counter);
                vehicles(ind(counter)).next_vehicle_id = kk;
                vehicles(kk).distance_from_prev = distances(counter);
                vehicles(ind(counter)).distance_from_next = distances(counter);
            end
        end
    else
        flag = 0;
        vehicles(kk).previous_vehicle_id = 0;
        vehicles(kk).distance_from_prev = [];
    end
    counter = counter + 1;
end
% Next:
flag = 1; counter = 1;
while flag == 1
    if counter <= length(ind)
        if vehicles(kk).direction == 1
            if vehicles(ind(counter)).x > vehicles(kk).x
                flag = 0;
                vehicles(kk).next_vehicle_id = ind(counter);
                vehicles(ind(counter)).previous_vehicle_id = kk;
                vehicles(kk).distance_from_next = distances(counter);
                vehicles(ind(counter)).distance_from_prev = distances(counter);
            end
        else
            if vehicles(ind(counter)).x < vehicles(kk).x
                flag = 0;
                vehicles(kk).next_vehicle_id = ind(counter);
                vehicles(ind(counter)).previous_vehicle_id = kk;
                vehicles(kk).distance_from_next = distances(counter);
                vehicles(ind(counter)).distance_from_prev = distances(counter);
            end
        end
    else
        flag = 0;
        vehicles(kk).next_vehicle_id = 0;
        vehicles(kk).distance_from_next = [];
    end
    counter = counter + 1;
end
layoutParams.moving_scatterers_lanes(kk) = vehicles(kk).lane;