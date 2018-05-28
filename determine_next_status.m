function [vehicles, layoutParams] = determine_next_status(vehicles, layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

%% STATUS 1:
for kk = 1 : layoutParams.num_moving_scatterers
    if vehicles(kk).status ==1

        %%  Check if status changes are necessary:
        if  vehicles(kk).next_vehicle_id~=0
            if vehicles(kk).distance_from_next<20
                %% ByPASS!! or break!!
                % is there a lane to bypass?
                if vehicles(kk).lane<layoutParams.num_lanes
                    % Check the next lane before attempting by pass....
                    if kk == 1
                       keyboard 
                    end
                    [vehicles, layoutParams] = check_next_lane(kk, vehicles, layoutParams);
                else
                    % Have to break...
                    vehicles(kk).status = 4;
                    vehicles(kk).details = [];
                    vehicles(kk).details.speed_before_bypass = vehicles(kk).speed;
                    vehicles(kk).details.target_speed = vehicles(vehicles(kk).next_vehicle_id).speed;
                    % Instantly change speed...
                    vehicles(kk).speed = vehicles(kk).details.target_speed;
                    layoutParams.moving_scatterers_speed(kk) = vehicles(kk).speed;
                    vehicles(kk).previous_status = 1;
                end
                
            end
        end
        
        if layoutParams.num_lanes>2 && vehicles(kk).lane==layoutParams.num_lanes
            % Has to change lane back in...
            [vehicles, layoutParams] = change_lanes(kk, vehicles, layoutParams, -1);
        end
        
    end
end

%% STATUS 4:
for kk = 1 : layoutParams.num_moving_scatterers
    if vehicles(kk).status == 4
        
        if vehicles(kk).lane<layoutParams.num_lanes
            % Check the next lane before attempting by pass....
            [vehicles, layoutParams] = check_next_lane(kk, vehicles, layoutParams);
            if vehicles(kk).status == 2
                vehicles(kk).speed = vehicles(kk).details.speed_before_bypass;
                layoutParams.moving_scatterers_speed(kk) = vehicles(kk).speed;
            end
        end
    end
end

%% STATUS 2:
for kk = 1 : layoutParams.num_moving_scatterers    
    if vehicles(kk).status == 2

        if vehicles(kk).previous_status == 1 || vehicles(kk).previous_status == 4
            % Change lane to overtake
            [vehicles, layoutParams] = change_lanes(kk, vehicles, layoutParams, 1);

        else
            % Bypaaaasss...
            
            % Calculate if the next vehicle is too close!:
            if vehicles(kk).distance_from_next<25
                % If so... moving to status 1 to make double overtake in one of the next loops!
                vehicles(kk).previous_status = vehicles(kk).status; 
                vehicles(kk).status = 1;
            else
                
                % Check if overtake manouvre has ended
                distance = sqrt(abs(vehicles(kk).x - vehicles(vehicles(kk).details.bypassing).x)^2 + abs(vehicles(kk).y - vehicles(vehicles(kk).details.bypassing).y)^2);
                if vehicles(kk).direction == 1
                    test = vehicles(kk).x - vehicles(vehicles(kk).details.bypassing).x;
                elseif vehicles(kk).direction == -1
                    test = vehicles(vehicles(kk).details.bypassing).x - vehicles(kk).x;
                end
                
                if distance > 40 && test>0
                    % Check the previous lane...
                    [vehicles, layoutParams] = check_previous_lane(kk, vehicles, layoutParams);
                    if vehicles(kk).status == 1
                        % Change lane back in...
                        [vehicles, layoutParams] = change_lanes(kk, vehicles, layoutParams, -1);
                    end
                end
            end
        end
    end
end

%% Last check... spare the details...
for kk = 1 : layoutParams.num_moving_scatterers
    if vehicles(kk).status ==1
        vehicles(kk).details = [];
    end
%     if kk == 1
%         fprintf('status1\n')
%         fprintf('Distance from next: %d \n', vehicles(1).distance_from_next);
%         fprintf('Distance from prev: %d \n', vehicles(1).distance_from_prev);
%         fprintf('Lane: %d \n', vehicles(1).lane);
%         fprintf('Direction: %d \n', vehicles(1).direction);
%         keyboard
%     end
    vehicles(kk).previous_status = vehicles(kk).status;
end
