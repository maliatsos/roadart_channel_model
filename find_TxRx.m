function [id_tx, id_rx, distances] = find_TxRx(record_route_x, record_route_y, maximum_distance, layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

flag = 1;

counter = 1;
while flag
    
    if ~isnan(record_route_x(counter, end)) || ~isnan(record_route_y(counter, end))
        tmp_tx = counter;
        coordinates_tx = [record_route_x(tmp_tx, :)' record_route_y(tmp_tx, :)'];
        
        flag2 = 1;
        counter2 = 1;
        while flag2
            tmp_rx = [];
            if (~isnan(record_route_x(counter2, end)) || ~isnan(record_route_y(counter2, end))) 
                tmp_rx = counter2;
                if tmp_rx ~=tmp_tx
                    coordinates_rx = [record_route_x(tmp_rx, :)' record_route_y(tmp_rx, :)'];
                    
                    distances = sqrt((abs(coordinates_tx(:,1) - coordinates_rx(:,1)).^2 + abs(coordinates_tx(:,2) - coordinates_rx(:,2)).^2));
                    if max(distances)<=maximum_distance
                        flag2 = 0;
                        flag = 0;
                    end
                end
            end
            if counter2 == layoutParams.num_moving_scatterers
                flag2 = 0;
            end
            counter2 = counter2 + 1;
        end
    end
    if counter == layoutParams.num_moving_scatterers
        flag = 0;
    end
    counter = counter + 1;
end
id_tx = tmp_tx;
if isempty(tmp_rx)
    error('Cannot found proper Tx-Rx pair');
end
id_rx = tmp_rx;