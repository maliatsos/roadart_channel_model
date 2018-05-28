function btn = zoom_overtake2(id_tx, id_rx, record_route_x, record_route_y, layoutParams, results, linkParams, snapshot)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

persistent check
% if isempty(xx1)
    xx1 = min([record_route_x(id_tx)-120, record_route_x(id_rx)-120]);
    xx2 = max([record_route_x(id_tx)+120, record_route_x(id_rx)+120]);
    yy1 = min([record_route_y(id_tx)-150, record_route_y(id_rx)-150]);
    yy2 = max([record_route_y(id_tx)+150, record_route_y(id_rx)+150]);
% end


set(gcf,'units','normalized','outerposition',[0.05 0.05 0.72 0.95]);
plot(layoutParams.x_axis, layoutParams.road_side1, '-r', 'LineWidth', 2)
if isempty(check)
    btn = uicontrol('Style', 'togglebutton', 'String', 'Find the scatterers',...
        'Position', [0 0 140 50], 'Callback', {@test_callback,layoutParams,record_route_x,record_route_y,id_tx,id_rx,linkParams, snapshot});    
end
hold all
set(gca, 'Color', [1 0.968627450980392 0.92156862745098],'Position',[0.0349309504467912 0.0709259259259259 0.959911275600254 0.923287037037036]);
if snapshot == 1
   pause 
end
plot(layoutParams.x_axis, layoutParams.road_side2, '-r', 'LineWidth', 2)
scatter(layoutParams.sign_scatterers(:,1), layoutParams.sign_scatterers(:,2), 80, 'Marker','x','LineWidth',3);
scatter(layoutParams.bridge_scatterers(:,1), layoutParams.bridge_scatterers(:,2), 160, 'Marker','diamond','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
scatter(layoutParams.building_scatterers(:,1), layoutParams.building_scatterers(:,2), 240, 'Marker', 'square', 'MarkerFaceColor',[0.867 0.488 0], 'MarkerEdgeColor',[0.867 0.488 0]);
scatter(record_route_x, record_route_y, 18, 'MarkerEdgeColor',[0 1 0],'MarkerFaceColor',[0 1 0]);
scatter(record_route_x(id_tx), record_route_y(id_tx), 24, 'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
scatter(record_route_x(id_rx), record_route_y(id_rx), 24, 'MarkerFaceColor',[1 0 0], 'MarkerEdgeColor',[1 0 0]);
axis([xx1, xx2, yy1, yy2])
drawnow
% axis equal
hold off

pause(0.2)
if snapshot == 180
    xx1 = min([record_route_x(id_tx)-120, record_route_x(id_rx)-120]);
    xx2 = max([record_route_x(id_tx)+120, record_route_x(id_rx)+120]);
    yy1 = min([record_route_y(id_tx)-150, record_route_y(id_rx)-150]);
    yy2 = max([record_route_y(id_tx)+150, record_route_y(id_rx)+150]);
    set(gcf,'units','normalized','outerposition',[0.05 0.1 0.9 0.9]);
    plot(layoutParams.x_axis, layoutParams.road_side1, '-r', 'LineWidth', 2)
    hold all
    set(gca, 'Color', [1 0.968627450980392 0.92156862745098],'Position',[0.0349309504467912 0.0709259259259259 0.959911275600254 0.923287037037036]);
    plot(layoutParams.x_axis, layoutParams.road_side2, '-r', 'LineWidth', 2)
    scatter(layoutParams.sign_scatterers(:,1), layoutParams.sign_scatterers(:,2), 80, 'Marker','x','LineWidth',3);
    scatter(layoutParams.bridge_scatterers(:,1), layoutParams.bridge_scatterers(:,2), 160, 'Marker','diamond','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
    scatter(layoutParams.building_scatterers(:,1), layoutParams.building_scatterers(:,2), 240, 'Marker', 'square', 'MarkerFaceColor',[0.867 0.488 0], 'MarkerEdgeColor',[0.867 0.488 0]);
    scatter(record_route_x, record_route_y, 18, 'MarkerEdgeColor',[0 1 0],'MarkerFaceColor',[0 1 0]);
    scatter(record_route_x(id_tx), record_route_y(id_tx), 24, 'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
    scatter(record_route_x(id_rx), record_route_y(id_rx), 24, 'MarkerFaceColor',[1 0 0], 'MarkerEdgeColor',[1 0 0]);
    axis([xx1, xx2, yy1, yy2])
    drawnow
    scatter(record_route_x(logical(linkParams.actives_v2v(:,snapshot))), record_route_y(logical(linkParams.actives_v2v(:,snapshot))), 100, 'Marker', 'o', 'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor',[1 0.9 0]);
    scatter(layoutParams.building_scatterers(logical(linkParams.actives_buildings(:,snapshot)),1), layoutParams.building_scatterers(logical(linkParams.actives_buildings(:,snapshot)),2), 300, 'Marker', 'o', 'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor',[1 0.9 0]);
    scatter(layoutParams.sign_scatterers(logical(linkParams.actives_signs(:,snapshot)),1), layoutParams.sign_scatterers(logical(linkParams.actives_signs(:,snapshot)),2), 100, 'Marker', 'o', 'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor',[1 0.9 0]);
    scatter(layoutParams.bridge_scatterers(logical(linkParams.actives_bridges(:,snapshot)),1), layoutParams.bridge_scatterers(logical(linkParams.actives_bridges(:,snapshot)),2), 300, 'Marker', 'o', 'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor',[1 0.9 0]);    
    set(btn, 'String', 'Use RIMAX');
    keyboard
end

end

function test_callback(hObject,callbackdata, layoutParams,record_route_x,record_route_y,id_tx,id_rx, linkParams,  snapshot)

xx1 = min([record_route_x(id_tx)-150, record_route_x(id_rx)-150]);
xx2 = max([record_route_x(id_tx)+150, record_route_x(id_rx)+150]);
yy1 = min([record_route_y(id_tx)-150, record_route_y(id_rx)-150]);
yy2 = max([record_route_y(id_tx)+150, record_route_y(id_rx)+150]);

hold off
set(gcf,'units','normalized','outerposition',[0.05 0.1 0.9 0.9]);
plot(layoutParams.x_axis, layoutParams.road_side1, '-r', 'LineWidth', 2)
hold all
set(gca, 'Color', [1 0.968627450980392 0.92156862745098],'Position',[0.0349309504467912 0.0709259259259259 0.939911275600254 0.943287037037036]);
plot(layoutParams.x_axis, layoutParams.road_side2, '-r', 'LineWidth', 2)
scatter(layoutParams.sign_scatterers(:,1), layoutParams.sign_scatterers(:,2), 80, 'Marker','x','LineWidth',3);
scatter(layoutParams.bridge_scatterers(:,1), layoutParams.bridge_scatterers(:,2), 160, 'Marker','diamond','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
scatter(layoutParams.building_scatterers(:,1), layoutParams.building_scatterers(:,2), 240, 'Marker', 'square', 'MarkerFaceColor',[0.867 0.488 0], 'MarkerEdgeColor',[0.867 0.488 0]);
scatter(record_route_x, record_route_y, 18, 'MarkerEdgeColor',[0 1 0],'MarkerFaceColor',[0 1 0]);
scatter(record_route_x(id_tx), record_route_y(id_tx), 24, 'MarkerFaceColor',[1 0 0],'MarkerEdgeColor',[1 0 0]);
scatter(record_route_x(id_rx), record_route_y(id_rx), 24, 'MarkerFaceColor',[1 0 0], 'MarkerEdgeColor',[1 0 0]);
hObject.String = 'Use RIMAX';
axis([xx1, xx2, yy1, yy2])
drawnow
scatter(record_route_x(logical(linkParams.actives_v2v(:,snapshot))), record_route_y(logical(linkParams.actives_v2v(:,snapshot))), 100, 'Marker', 'o', 'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor',[1 0.9 0]);        
scatter(layoutParams.building_scatterers(logical(linkParams.actives_buildings(:,snapshot)),1), layoutParams.building_scatterers(logical(linkParams.actives_buildings(:,snapshot)),2), 300, 'Marker', 'o', 'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor',[1 0.9 0]);        
scatter(layoutParams.sign_scatterers(logical(linkParams.actives_signs(:,snapshot)),1), layoutParams.sign_scatterers(logical(linkParams.actives_signs(:,snapshot)),2), 100, 'Marker', 'o', 'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor',[1 0.9 0]);    
scatter(layoutParams.bridge_scatterers(logical(linkParams.actives_bridges(:,snapshot)),1), layoutParams.bridge_scatterers(logical(linkParams.actives_bridges(:,snapshot)),2), 300, 'Marker', 'o', 'MarkerFaceColor',[1 0.9 0],'MarkerEdgeColor',[1 0.9 0]);    

pause(0.5);
waitfor(hObject, 'Value', 0);
hObject.Callback = 'return';%{@test_callback,layoutParams,record_route_x,record_route_y,id_tx,id_rx};

end

function test_callback2(hObject,callbackdata, layoutParams,record_route_x,record_route_y,id_tx,id_rx)

end