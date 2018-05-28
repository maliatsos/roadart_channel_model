function layoutParams = create_road(layoutParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017
if isempty(layoutParams.num_lanes)
    layoutParams.num_lanes = 2; 
end
if isempty(layoutParams.lane_width)
    layoutParams.lane_width = 3; % in meters 
end
if min(layoutParams.lane_width<2.2) || max(layoutParams.lane_width>8)
    error('Lane width not acceptable'); 
end
if length(layoutParams.lane_width)==1
    layoutParams.lane_width = layoutParams.lane_width*ones(layoutParams.num_lanes, 1);
end
if isempty(layoutParams.barrier_flag)
    layoutParams.barrier_flag = 0;  % No barriers
else
    if isempty(layoutParams.barrier_width)
        layoutParams.barrier_width = 1; % one meter default
    end
end
if ~layoutParams.barrier_flag
    layoutParams.barrier_width = 0;
end

% Calculate street width:
one_direction_width = sum(layoutParams.lane_width);

if layoutParams.opp_direction 
    layoutParams.road_width = 2*one_direction_width + layoutParams.barrier_width;
else
    layoutParams.road_width = one_direction_width;
end

x = linspace(-1.2, 1.2, layoutParams.turn_factor+2)';
y = 2*rand(length(x),1) - 1;

roadPoly1 = polyfit(x, y, layoutParams.turn_factor+1);
x_new = linspace(-1.1, 1.1, 1000)';
side1 = polyval(roadPoly1, x_new);
% Limit y in -1 to 1:
ind = abs(x_new)<=1;
y = y/max(abs(side1(ind)));
roadPoly1 = polyfit(x, y, layoutParams.turn_factor+1);
x_new = linspace(-1.1, 1.1, 1000)';
side1 = polyval(roadPoly1, x_new);

difPoly1 = zeros(size(roadPoly1));
for kk = 1 : length(roadPoly1)-1
    difPoly1(kk) = (layoutParams.turn_factor+2-kk)*roadPoly1(kk); 
end
difPoly1 = difPoly1(1:end-1);
z = roots(difPoly1);
ind = [];
for kk = 1 : length(z)
    if ~isreal(z(kk))
        ind = [ind kk];
    else
        if z(kk)<-1.1 || z(kk)>1.1
            ind = [ind kk];
        end
    end
end
z(ind) = [];
x2 = z;
y_normalizer = layoutParams.road_width/layoutParams.box_length;

d = [y_normalizer; (0.5:layoutParams.num_lanes)'.*layoutParams.lane_width/layoutParams.box_length];
if layoutParams.opp_direction
    d = [d; y_normalizer/2; (y_normalizer/2+(0.5:layoutParams.num_lanes)'.*layoutParams.lane_width/layoutParams.box_length)];
end

tmp = polyval(roadPoly1, z);
y2 = zeros(length(z), length(d));
for ll = 1 : length(d)
    y2(:, ll) = tmp - d(ll);
end
% Find peaks at the derivatives:
locs = 1:20:length(x_new);
x3 = x_new(locs);
locs = locs(abs(x3)<1.1);
x3 = x3(abs(x3)<1.1);

x4 = zeros(length(x3), length(d));
y4 = zeros(length(x3), length(d));    
options = optimset('TolX', 1e-12, 'TolFun', 1e-14, 'Display', 'Off');

for ll = 1 : length(d)
    for kk = 1 : length(locs)
        
        yy1 = polyval(roadPoly1, x3(kk));
        xx1 = [x3(kk); yy1];
        xx2 = x_new(locs(kk)+1);
        slope = polyval(difPoly1, xx1(1));
        perpend_slope = -1/slope;
        perpend_const = xx1(2) - perpend_slope*xx1(1);
        dd = d(ll);
        tmp = fsolve(@(xx)myFun2(xx, xx1, perpend_slope, perpend_const, dd), xx1(1), options);
        
        if ((xx1(1)<xx2) && slope>0) ||  ((xx1(1)>xx2) && slope<0)
            tmp = fsolve(@(xx)myFun2(xx, xx1, perpend_slope, perpend_const, dd), xx1(1)+0.1, options);
        elseif ((xx1(1)>xx2) && slope>0) ||  ((xx1(1)<xx2) && slope<0)
            tmp = fsolve(@(xx)myFun2(xx, xx1, perpend_slope, perpend_const, dd), xx1(1)-0.1, options);
        end
        x4(kk, ll) = tmp;
        y4(kk, ll) = perpend_slope*tmp+perpend_const;
        
    end
end
xx = [repmat(x2, 1, length(d)); x4];

x_plot = linspace(-1,1, 1000).';
results = zeros(length(x_plot), length(d));
for ll = 1 : length(d)
    yy2 = [y2(:,ll); y4(:,ll)];
    [xx1, ind] =sort(xx(:,ll));
    yy2 = yy2(ind);
    
    % Set up fittype and options.
    ft = fittype( 'smoothingspline' );
    opts = fitoptions( 'Method', 'SmoothingSpline' );
    opts.SmoothingParam = 0.999991186893206;
    [fitresult1, ~] = fit( xx1, yy2, ft, opts );
    results(:,ll) = fitresult1(x_plot);
end

yy1 = polyval(roadPoly1, xx(:,1));
[xx1, ind] =sort(xx(:,1));
yy2 = yy1(ind);
% Set up fittype and options.
ft = fittype( 'smoothingspline' );
opts = fitoptions( 'Method', 'SmoothingSpline' );
opts.SmoothingParam = 0.999991186893206;
[fitresult1, ~] = fit( xx1, yy2, ft, opts );
road_side1 = fitresult1(x_plot);


x_plot = (x_plot + 1)/2;
x_plot = layoutParams.box_length*x_plot;
layoutParams.road_side1 = layoutParams.box_length/2*(road_side1 + 1);
layoutParams.road_side2 = layoutParams.box_length/2*(results(:,1)+ 1);
layoutParams.x_axis = x_plot;

if layoutParams.opp_direction
    layoutParams.barrier_cordinates = layoutParams.box_length/2*(results(:,2+layoutParams.num_lanes)+1); 
    layoutParams.opp_lane_cordinates = layoutParams.box_length/2*(results(:, 2:layoutParams.num_lanes+1)+1);
    layoutParams.opp_lane_derivatives = diff(layoutParams.opp_lane_cordinates)./repmat(diff(layoutParams.x_axis), 1, layoutParams.num_lanes);
    layoutParams.own_lane_cordinates = layoutParams.box_length/2*(results(:, end:-1:layoutParams.num_lanes+3)+1);
    layoutParams.own_lane_derivatives = diff(layoutParams.own_lane_cordinates)./repmat(diff(layoutParams.x_axis), 1, layoutParams.num_lanes);
    layoutParams.own_lane_derivatives = [layoutParams.own_lane_derivatives; layoutParams.own_lane_derivatives(end,:)];
    layoutParams.opp_lane_derivatives = [layoutParams.opp_lane_derivatives; layoutParams.opp_lane_derivatives(end,:)];
else
    layoutParams.barrier_cordinates = [];
    layoutParams.opp_lane_cordinates = [];
    layoutParams.own_lane_cordinates =  results(:, end:-1:2);
    layoutParams.own_lane_derivatives = diff(layoutParams.own_lane_cordinates)./repmat(diff(layoutParams.x_axis), 1, layoutParams.num_lanes);
    layoutParams.own_lane_derivatives = [layoutParams.own_lane_derivatives; layoutParams.own_lane_derivatives(end,:)];
end


layoutParams.arc_length = arclength(x_plot, layoutParams.road_side1);



% plot(x_plot, layoutParams.road_side1, '-r');
% hold all
% xlim([0 layoutParams.box_length]);
% ylim([0 layoutParams.box_length]);
% plot(x_plot, layoutParams.road_side2,'-r');
% plot(x_plot, layoutParams.own_lane_cordinates, '-b');
