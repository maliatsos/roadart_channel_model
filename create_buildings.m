function layoutParams = create_buildings(layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

% Calculate area in km^2:
area = layoutParams.box_length^2/1e6;

% Calculate the number of buildings to be created:
layoutParams.num_buildings = area*layoutParams.building_density;

layoutParams.building_scatterers = zeros(layoutParams.num_buildings,3);
for kk = 1 : layoutParams.num_buildings 
    flag = 1;
    
    coin = rand(1,1)-0.5;
    if sign(coin)==1
        flag = 1;
        while flag
            x1 = layoutParams.box_length*rand(1,1);
            y1 = interp1(layoutParams.x_axis, layoutParams.road_side1, x1, 'pchip') + 10+abs(300*randn(1,1));
            if y1<=layoutParams.box_length
                flag = 0;
            end
        end
    else
        while flag
            x1 = layoutParams.box_length*rand(1,1);
            y1 = interp1(layoutParams.x_axis, layoutParams.road_side2, x1, 'pchip') - 10-abs(300*randn(1,1));
            if y1>0
                flag = 0;
            end
        end
        
    end
    layoutParams.building_scatterers(kk,1) = x1;
    layoutParams.building_scatterers(kk,2) = y1;
    layoutParams.building_scatterers(kk,3) = layoutParams.building_height;
end
layoutParams.phi_buildings = atan(layoutParams.building_scatterers(:,2)/layoutParams.building_scatterers(:,1));

% scatter(layoutParams.building_scatterers(:,1), layoutParams.building_scatterers(:,2), 80, 'Marker', 'square');