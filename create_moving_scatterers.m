function layoutParams = create_moving_scatterers(layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

% Number of Vehicles:
num_vehicles = 0;
while num_vehicles<=0
    num_vehicles = round(layoutParams.traffic_density*layoutParams.arc_length/1000 + 5*randn(1,1));
end
if layoutParams.opp_direction
    directions = randi([0 1], num_vehicles, 1); 
    directions(directions==0) = -1;
else
    directions = ones(num_vehicles, 1);
end

layoutParams.num_moving_scatterers = num_vehicles;

%% Initialize Speeds per vehicle:
mean_speed = (layoutParams.lower_speed + layoutParams.higher_speed)/2;
std_speed = (layoutParams.higher_speed - layoutParams.lower_speed)/4;

speeds = mean_speed + std_speed*randn(num_vehicles, 1);

lanes = zeros(num_vehicles, 1);
if layoutParams.num_lanes>1
    
    if layoutParams.num_lanes == 2
        lanes(speeds<=mean_speed) = 1;
        lanes(speeds>mean_speed) = 2;
    elseif layoutParams.num_lanes>2
        step = (-layoutParams.lower_speed + layoutParams.higher_speed)/(layoutParams.num_lanes - 1); % keep the last lane for bypass...
        lanes = (layoutParams.num_lanes - 1)*ones(num_vehicles, 1);
        for kk = 1 : (layoutParams.num_lanes - 2)
            lanes(speeds<layoutParams.lower_speed+kk*step) = kk;
        end
    end
    
else
    lanes = ones(num_vehicles, 1); 
end
locations_x = layoutParams.box_length*rand(num_vehicles, 1);
% Check vehicle distances (at least 50 m seperation in intialization)
for kk = 1 : num_vehicles
    flag = 1;
    counter = 1;
    while flag ==1
        tmp = locations_x(kk) - locations_x;
        tmp(kk) = [];
        if min(abs(tmp))>10
            flag = 0;
        else
            locations_x(kk) = layoutParams.box_length*rand(1, 1);
        end
        counter = counter + 1;
        if counter>100
            keyboard
        end
    end
end

locations_y = zeros(num_vehicles, 1);
for kk = 1 : layoutParams.num_lanes
    ind = (directions == 1) & (lanes == kk);
    tmp = locations_x(ind);
    tmp_y = interp1(layoutParams.x_axis, layoutParams.own_lane_cordinates(:,kk), tmp, 'pchip');
    locations_y(ind) = tmp_y;
end
if layoutParams.opp_direction
    for kk = 1 : layoutParams.num_lanes
        ind = (directions == -1) & (lanes == kk);
        tmp = locations_x(ind);
        tmp_y = interp1(layoutParams.x_axis, layoutParams.opp_lane_cordinates(:,kk), tmp, 'pchip');
        locations_y(ind) = tmp_y;
    end
end
% scatter(locations_x, locations_y)
layoutParams.moving_scatterers_loc = [locations_x locations_y];
layoutParams.moving_scatterers_speed = speeds;
layoutParams.moving_scatterers_lanes = lanes;
layoutParams.moving_scatterers_direction = directions;




