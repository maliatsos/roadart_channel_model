function direction_of_movement = direction_movement(route)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

dif_x = diff(route(:,1));
dif_y = diff(route(:,2));

direction_of_movement = atan(dif_y./dif_x);
ind = dif_x<0 & dif_y<0;
direction_of_movement(ind) = -pi+direction_of_movement(ind);
ind = dif_x<0 & dif_y>0;
direction_of_movement(ind) = pi-direction_of_movement(ind);
