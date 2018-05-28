function [vehicles, layoutParams] = calculate_distances(ids, vehicles, layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

for kk = 1 : length(ids)
    if vehicles(kk).status>0
        % Calculate distance from previous:
        if vehicles(kk).previous_vehicle_id~=0
            vehicles(kk).distance_from_prev = sqrt(abs(vehicles(kk).x - vehicles(vehicles(kk).previous_vehicle_id).x)^2 + abs(vehicles(kk).y - vehicles(vehicles(kk).previous_vehicle_id).y)^2);
        end
        % Calculate distance from next:
        if vehicles(kk).next_vehicle_id~=0
            vehicles(kk).distance_from_next = sqrt(abs(vehicles(kk).x - vehicles(vehicles(kk).next_vehicle_id).x)^2 + abs(vehicles(kk).y - vehicles(vehicles(kk).next_vehicle_id).y)^2);
        end
    else
        vehicles(kk).distance_from_prev = NaN;
        vehicles(kk).distance_from_next = NaN;
    end
end