function [vehicles, layoutParams] = discard_vehicles(vehicles, layoutParams, new_location_x)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

ind = find(new_location_x<0 | new_location_x>layoutParams.box_length);

for kk = 1 : length(ind)
    vehicles(ind(kk)).status = 0;
    vehicles(ind(kk)).x = NaN;
    layoutParams.moving_scatterers_loc(ind(kk),:) = NaN;
    vehicles(ind(kk)).y = NaN;
    vehicles(ind(kk)).speed = NaN;
    layoutParams.moving_scatterers_speed(ind(kk),:) = NaN;
    if vehicles(ind(kk)).previous_vehicle_id>0
        vehicles(vehicles(ind(kk)).previous_vehicle_id).next_vehicle_id = 0;
    end
end
