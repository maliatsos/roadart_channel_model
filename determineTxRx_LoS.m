function LoSconditions2 = determineTxRx_LoS(layoutParams, route_tx, route_rx, linkParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

route_size = length(0:linkParams.time_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period);

LoSconditions = zeros(length(route_tx), 1);
a = (route_rx(:,2) - route_tx(:,2))./(route_rx(:,1) - route_tx(:,1));
b = route_tx(:,2) - a.*route_tx(:,1);
for kk = 1 : length(route_tx)
    % Calculate LoS line:
    
    
    xx = linspace(route_tx(kk,1),route_rx(kk,1),100);
    yy = a(kk)*(xx) + b(kk);
    yy1 = interp1(layoutParams.x_axis, layoutParams.road_side1, xx, 'pchip');
    yy2 = interp1(layoutParams.x_axis, layoutParams.road_side2, xx, 'pchip');
    [x0, y0] = intersections(xx,yy,xx,yy1, 0);
    [x1, y1] = intersections(xx,yy,xx, yy2, 0);
    
    if isempty(x0) && isempty(x1)
        LoSconditions(kk) = 1;
    else
        LoSconditions(kk) = 0;
    end

end

% Fine Tune LoS:
LoSconditions2 = zeros(route_size, 1);
step = linkParams.vehicular_sampling_period/linkParams.time_sampling_period;
for kk = 1 : length(route_tx)-1
    if LoSconditions(kk)==LoSconditions(kk+1)
        LoSconditions2((kk-1)*step + 1 : kk*step) = LoSconditions(kk+1);
    else
        for ll = 1 : step
            xx = linspace(route_tx(kk,1),route_rx(kk,1),100);
            yy = a(kk)*(xx) + b(kk);
            yy1 = interp1(layoutParams.x_axis, layoutParams.road_side1, xx, 'pchip');
            yy2 = interp1(layoutParams.x_axis, layoutParams.road_side2, xx, 'pchip');
            [x0, y0] = intersections(xx,yy,xx,yy1, 0);
            [x1, y1] = intersections(xx,yy,xx, yy2, 0);
            if isempty(x0) && isempty(x1)
                LoSconditions2((kk-1)*step + ll) = 1;
            else
                LoSconditions2((kk-1)*step + ll) = 0;
            end
        end
    end

end