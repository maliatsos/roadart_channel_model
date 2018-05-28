function [vehicles, layoutParams, record_route_x, record_route_y ,instant_speed] = driving(vehicles, dt, layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

new_position_x = zeros(layoutParams.num_moving_scatterers, 1);
new_position_y = zeros(layoutParams.num_moving_scatterers, 1);
old_position_x = zeros(layoutParams.num_moving_scatterers, 1);
old_position_y = zeros(layoutParams.num_moving_scatterers, 1);
new_direction = zeros(layoutParams.num_moving_scatterers, 1);

for kk = 1 : layoutParams.num_moving_scatterers
    if vehicles(kk).status > 0
        speed = vehicles(kk).speed/3600*1000; % in m/sec
        ds = speed*dt;
        if vehicles(kk).direction == 1
            slope =  interp1(layoutParams.x_axis, layoutParams.own_lane_derivatives(:,vehicles(kk).lane), vehicles(kk).x);
            dx = ds*cos(atan(slope));
        else
            slope =  interp1(layoutParams.x_axis, layoutParams.opp_lane_derivatives(:,vehicles(kk).lane), vehicles(kk).x);
            dx = -ds*cos(atan(slope));
        end   
        
        new_position_x(kk) =  vehicles(kk).x + dx;
        if vehicles(kk).direction == 1
            new_position_y(kk) = interp1(layoutParams.x_axis, layoutParams.own_lane_cordinates(:,vehicles(kk).lane), new_position_x(kk));
        else
            new_position_y(kk) = interp1(layoutParams.x_axis, layoutParams.opp_lane_cordinates(:,vehicles(kk).lane), new_position_x(kk));
        end
        
        old_position_x(kk) = vehicles(kk).x;
        old_position_y(kk) = vehicles(kk).y;
               
        vehicles(kk).x = new_position_x(kk);
        vehicles(kk).y = new_position_y(kk);
        layoutParams.moving_scatterers_loc(kk,1) = new_position_x(kk);
        layoutParams.moving_scatterers_loc(kk,2) = new_position_y(kk);
    end
end

%% Determine new distances from previous and next:
[vehicles, layoutParams] = calculate_distances(1:layoutParams.num_moving_scatterers, vehicles, layoutParams);

%% First step...discard disappearing vehicles.... out of the box....
[vehicles, layoutParams] = discard_vehicles(vehicles, layoutParams, new_position_x);

%% Second step... determine next status state:
[vehicles, layoutParams] = determine_next_status2(vehicles, layoutParams);

%% Determine direction:
for kk = 1 : layoutParams.num_moving_scatterers
    if vehicles(kk).status > 0
        dy = layoutParams.moving_scatterers_loc(kk,1) - old_position_y(kk);
        dx = layoutParams.moving_scatterers_loc(kk,2) - old_position_y(kk);
        new_direction(kk) = atan(dy./dx);
        if dx<0 && dy<0
            new_direction(kk) = -pi+new_direction(kk);
        elseif dx<0 && dy>0
            new_direction(kk) = pi+new_direction(kk);
        end
        layoutParams.moving_scatterers_direction(kk) = new_direction(kk);
    end
end

% record_route_x = [record_route_x layoutParams.moving_scatterers_loc(:,1)];
record_route_x = layoutParams.moving_scatterers_loc(:,1);
record_route_y = layoutParams.moving_scatterers_loc(:,2);
instant_speed = layoutParams.moving_scatterers_speed;

% calculate_crashes(vehicles, layoutParams)
