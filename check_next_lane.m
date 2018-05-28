function [vehicles, layoutParams] = check_next_lane(id, vehicles, layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

kk = id; 

ind = find((layoutParams.moving_scatterers_direction == vehicles(kk).direction) & (layoutParams.moving_scatterers_lanes == vehicles(kk).lane+1));
distances = sqrt(abs(layoutParams.moving_scatterers_loc(ind,1) - vehicles(kk).x).^2 + abs(layoutParams.moving_scatterers_loc(ind,2)- vehicles(kk).y).^2);
% If the moving vehicles in the next lane are not close
% attempt bypass:
if ~isempty(distances)
    [min_dist, ind2] = min(distances);
    if vehicles(kk).next_vehicle_id == 0
        keyboard
    end
    if min_dist>30
        vehicles(kk).previous_status = vehicles(kk).status;
        vehicles(kk).status = 2;
        vehicles(kk).details.bypassing = vehicles(kk).next_vehicle_id;
        vehicles(kk).details.speed_before_bypass = vehicles(kk).speed;
        test = max(vehicles(kk).speed, layoutParams.moving_scatterers_speed(ind(ind2)));
        vehicles(kk).details.target_speed = test;
        if vehicles(kk).next_vehicle_id~=0
            vehicles(vehicles(kk).next_vehicle_id).bypasses = vehicles(vehicles(kk).next_vehicle_id).bypasses + 1;
        end
    else
        vehicles(kk).previous_status = vehicles(kk).status;
        vehicles(kk).status = 4;
        vehicles(kk).details = [];
        vehicles(kk).details.speed_before_bypass = vehicles(kk).speed;
        if vehicles(kk).next_vehicle_id~=0
            vehicles(kk).details.target_speed = vehicles(vehicles(kk).next_vehicle_id).speed;
        else
            vehicles(kk).details.target_speed = vehicles(kk).speed + 10;
        end
        vehicles(kk).speed = vehicles(kk).details.target_speed;
        layoutParams.moving_scatterers_speed(kk) = vehicles(kk).speed;
    end
else
    vehicles(kk).previous_status = vehicles(kk).status;
    vehicles(kk).status = 2;
    vehicles(kk).details.bypassing = vehicles(kk).next_vehicle_id;
    vehicles(kk).details.speed_before_bypass = vehicles(kk).speed;
    vehicles(kk).details.target_speed = vehicles(kk).speed;
    vehicles(vehicles(kk).next_vehicle_id).bypasses = vehicles(vehicles(kk).next_vehicle_id).bypasses + 1;
end