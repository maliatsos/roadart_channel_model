function layoutParams = create_signage_scatterers(layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

param = layoutParams.signage_density; % In signs per km

% Determine number of signs:
num_signs = round(param*layoutParams.arc_length/1000 + 2*randn(1,1));
if num_signs<0
    num_signs = 0;
end

% Determine number of bridges:
num_bridges = round(param*layoutParams.arc_length/50000 + randn(1,1));
if num_bridges<0
    num_bridges = 0;
end

%% Determine location of signs and bridges:

tmp = layoutParams.box_length/num_signs:layoutParams.box_length/num_signs:layoutParams.box_length;
signage_location_x = tmp' + 10*randn(length(tmp),1);

% Select some signs for the one and other direction:
if layoutParams.opp_direction
    one_direction_signs = round(num_signs) - randi(round(num_signs/2),1,1);
    other_direction_signs = num_signs - one_direction_signs;
else
    other_direction_signs = round(num_signs/10);
    one_direction_signs = num_signs - other_direction_signs;
end

if other_direction_signs<0
    other_direction_signs = 0;
end

one_direction_index = datasample(1:num_signs,one_direction_signs,'Replace',false);
other_direction_index = setdiff(1:num_signs, one_direction_index);

% Create signs for one direction:
Dx = 0;
Dy = 8;
sign_loc_one_x = signage_location_x(sort(one_direction_index));
sign_loc_one_y = interp1(layoutParams.x_axis, layoutParams.road_side2, sign_loc_one_x, 'pchip');
sign_loc_one_x = sign_loc_one_x + Dx;
sign_loc_one_y = sign_loc_one_y - Dy;

% Create signs for other direction:
sign_loc_other_x = signage_location_x(sort(other_direction_index));
sign_loc_other_y = interp1(layoutParams.x_axis, layoutParams.road_side1, sign_loc_other_x, 'pchip');
sign_loc_other_x = sign_loc_other_x + Dx;
sign_loc_other_y = sign_loc_other_y + Dy;


% Exclude signs out of the box:
ind = sign_loc_other_x<0;
sign_loc_other_x(ind) =[];
sign_loc_other_y(ind) = [];
ind = sign_loc_one_x<0;
sign_loc_one_x(ind) =[];
sign_loc_one_y(ind) =[];
ind = sign_loc_other_x>layoutParams.box_length;
sign_loc_other_x(ind) =[];
sign_loc_other_y(ind) =[];
ind = sign_loc_one_x>layoutParams.box_length;
sign_loc_one_x(ind) =[];
sign_loc_one_y(ind) =[];
ind = sign_loc_other_y<0;
sign_loc_other_x(ind) =[];
sign_loc_other_y(ind) = [];
ind = sign_loc_one_y<0;
sign_loc_one_x(ind) =[];
sign_loc_one_y(ind) =[];
ind = sign_loc_other_y>layoutParams.box_length;
sign_loc_other_x(ind) =[];
sign_loc_other_y(ind) =[];
ind = sign_loc_one_y>layoutParams.box_length;
sign_loc_one_x(ind) =[];
sign_loc_one_y(ind) =[];

% plot(layoutParams.x_axis, layoutParams.road_side1, '-r')
% hold all
% plot(layoutParams.x_axis, layoutParams.road_side2, '-r')
% scatter(sign_loc_one_x, sign_loc_one_y,'Marker','x');
% scatter(sign_loc_other_x, sign_loc_other_y,'Marker','x');
% Location of scatterers - 1.5m height assumed.
sign_scatterers = [sign_loc_one_x sign_loc_one_y 1.5*ones(length(sign_loc_one_x),1); sign_loc_other_x sign_loc_other_y 1.5*ones(length(sign_loc_other_x),1)];
num_signs = length(sign_scatterers);


layoutParams.sign_scatterers = sign_scatterers;
layoutParams.num_signs = num_signs;


%% Location of bridges:
x_bridges = zeros(num_bridges,1);
y_bridges = zeros(num_bridges, 1);
for kk = 1 : num_bridges
    tmp = layoutParams.box_length*rand(1,1);
    x_bridges(kk) = tmp;
    if layoutParams.opp_direction
        y_bridges(kk) = interp1(layoutParams.x_axis, layoutParams.barrier_cordinates, tmp);
    else
        y_bridges(kk) = interp1(layoutParams.x_axis, layoutParams.own_lane_cordinates(:,round(length(layoutParams.own_lane_cordinates)/2), tmp));
    end
end
layoutParams.bridge_scatterers = [x_bridges y_bridges layoutParams.bridge_height*ones(num_bridges,1)];
layoutParams.num_bridges = num_bridges;

% scatter(layoutParams.bridge_scatterers(:,1), layoutParams.bridge_scatterers(:,2),'Marker','diamond','MarkerFaceColor',[0 0 0],'MarkerEdgeColor',[0 0 0]);
