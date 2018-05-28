function [vehicles, layoutParams] = check_previous_lane(id, vehicles, layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

kk = id; 

ind = find((layoutParams.moving_scatterers_direction == vehicles(kk).direction) & (layoutParams.moving_scatterers_lanes == vehicles(kk).lane-1));
distances = sqrt(abs(layoutParams.moving_scatterers_loc(ind,1) - vehicles(kk).x).^2 + abs(layoutParams.moving_scatterers_loc(ind,2)- vehicles(kk).y).^2);
% If the moving vehicles in the next lane are not close
% attempt bypass:
if ~isempty(distances)
    [min_dist, ~] = min(distances);
    if min_dist>50
        vehicles(kk).previous_status = vehicles(kk).status;
        vehicles(kk).status = 1;
        vehicles(kk).speed = vehicles(kk).details.speed_before_bypass;
    else
       %%... change nothing... keep on rocking in status 2 
        
    end
else
    vehicles(kk).previous_status = vehicles(kk).status;
    vehicles(kk).status = 1;
    vehicles(kk).speed = vehicles(kk).details.speed_before_bypass;
end