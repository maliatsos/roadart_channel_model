function vehicles = create_vehicle_objects(layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

vehicles = struct('id', [], 'x', [], 'y', [], 'speed', [], 'direction', [], 'lane', [], 'bypasses', 0, 'previous_vehicle_id', [], 'next_vehicle_id', [],...
    'distance_from_prev', [], 'distance_from_next', [], 'status', [], 'detail', []);

for kk = 1 : layoutParams.num_moving_scatterers
    vehicles(kk).x = layoutParams.moving_scatterers_loc(kk,1);
    vehicles(kk).y = layoutParams.moving_scatterers_loc(kk,2);
    vehicles(kk).id = kk;
    vehicles(kk).speed = layoutParams.moving_scatterers_speed(kk);
    vehicles(kk).lane = layoutParams.moving_scatterers_lanes(kk);
    vehicles(kk).direction = layoutParams.moving_scatterers_direction(kk);
    
    vehicles(kk).status = 1; % 1=cruising, 2 bypassing, 3 accelerating, 4 breaking
end

%% Arrange vehicles...
for kk = 1 : layoutParams.num_moving_scatterers
    distance = sqrt(abs(layoutParams.moving_scatterers_loc(kk,1) - layoutParams.moving_scatterers_loc(:,1)).^2 + abs(layoutParams.moving_scatterers_loc(kk,2) - layoutParams.moving_scatterers_loc(:,2)).^2);
    [distance, ind] = sort(distance);
    
    flag = 1;
    counter = 2;
    tester = 0;
    
    while flag
        if (layoutParams.moving_scatterers_lanes(ind(counter)) == vehicles(kk).lane) && (layoutParams.moving_scatterers_direction(ind(counter)) == vehicles(kk).direction);
            
            % Is it the previous vehicle or the next?
            if vehicles(kk).direction == 1
                if layoutParams.moving_scatterers_loc(ind(counter),1)< vehicles(kk).x
                    if isempty(vehicles(kk).previous_vehicle_id)
                        vehicles(kk).previous_vehicle_id = ind(counter);
                        vehicles(kk).distance_from_prev = distance(counter);
                        tester = tester + 1;
                    end
                else
                    if isempty(vehicles(kk).next_vehicle_id)
                        vehicles(kk).next_vehicle_id = ind(counter);
                        vehicles(kk).distance_from_next = distance(counter);
                        tester = tester + 1;
                    end
                end
            else
                if layoutParams.moving_scatterers_loc(ind(counter),1)< vehicles(kk).x
                    if isempty(vehicles(kk).next_vehicle_id)
                        vehicles(kk).next_vehicle_id = ind(counter);
                        vehicles(kk).distance_from_next = distance(counter);
                        tester = tester + 1;
                    end
                    
                else
                    if isempty(vehicles(kk).previous_vehicle_id)
                        vehicles(kk).previous_vehicle_id = ind(counter);
                        vehicles(kk).distance_from_prev = distance(counter);
                        tester = tester + 1;
                    end
                end
                
            end
            
            if tester == 2
                flag  = 0;
            end

        end
        if counter == length(distance)
            if isempty(vehicles(kk).next_vehicle_id)
                vehicles(kk).next_vehicle_id =0;
            end
            if isempty(vehicles(kk).previous_vehicle_id)
                vehicles(kk).previous_vehicle_id =0;
            end
            flag  = 0;
        end
        counter = counter + 1;
    end
    
end