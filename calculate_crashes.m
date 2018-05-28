function calculate_crashes(vehicles, layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

for kk = 1 : layoutParams.num_moving_scatterers
    ind = find(layoutParams.moving_scatterers_direction == vehicles(kk).direction & layoutParams.moving_scatterers_lanes == vehicles(kk).lane);
    dd = sqrt(abs(layoutParams.moving_scatterers_loc(ind,1)-vehicles(kk).x).^2 + abs(layoutParams.moving_scatterers_loc(ind,2)-vehicles(kk).y).^2);
    dd(dd<0.00001)=[];
    [xx, ii] = sort(dd);
    if length(xx)>1
        if xx(2)<10
            fprintf('crash!! bug\n');
            return
        end
    end
end
