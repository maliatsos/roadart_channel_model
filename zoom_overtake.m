function btn = zoom_overtake(id, vehicles, layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

persistent check
% if isempty(xx1)
    xx1 = vehicles(id).x-150;
    xx2 = vehicles(id).x+150;
    yy1 = vehicles(id).y-150;
    yy2 = vehicles(id).y+150;
% end


plot(layoutParams.x_axis, layoutParams.road_side1, '-r')
if isempty(check)
    btn = uicontrol('Style', 'togglebutton', 'String', 'Pause',...
        'Position', [20 20 50 20], 'Callback', 'keyboard');    
end
hold all
plot(layoutParams.x_axis, layoutParams.road_side2, '-r')
scatter(layoutParams.sign_scatterers(:,1), layoutParams.sign_scatterers(:,2),'Marker','x');
scatter(layoutParams.bridge_scatterers(:,1), layoutParams.bridge_scatterers(:,2),'Marker','diamond','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
scatter(layoutParams.building_scatterers(:,1), layoutParams.building_scatterers(:,2), 80, 'Marker', 'square');
scatter(layoutParams.moving_scatterers_loc(:,1), layoutParams.moving_scatterers_loc(:,2), 18, 'MarkerEdgeColor',[1 0 0]);
scatter(vehicles(id).x, vehicles(id).y, 18, 'MarkerFaceColor',[1 0 0]);
axis([xx1, xx2, yy1, yy2])
hold off
pause(0.1)