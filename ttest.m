% script created by Kostas Maliatsos for UPRC
% current version 02/12/2017

x = record_route_x(id_tx);
y = record_route_y(id_tx);

x1 = layoutParams.building_scatterers(logical(linkParams.actives_buildings(:,snapshot)),1);
y1 = layoutParams.building_scatterers(logical(linkParams.actives_buildings(:,snapshot)),2);

x2 = layoutParams.sign_scatterers(logical(linkParams.actives_signs(:,snapshot)),1);
y2 = layoutParams.sign_scatterers(logical(linkParams.actives_signs(:,snapshot)),2);

x3 = layoutParams.bridge_scatterers(logical(linkParams.actives_bridges(:,snapshot)),1);
y3 = layoutParams.bridge_scatterers(logical(linkParams.actives_bridges(:,snapshot)),2);

x4 = record_route_x(logical(linkParams.actives_v2v(:,snapshot)));
y4 = record_route_y(logical(linkParams.actives_v2v(:,snapshot)));

xxx = [x1; x2; x3;x4];
slope = (y-[y1; y2; y3;y4])./(x - xxx);
const = [y1; y2; y3;y4] - slope.*xxx;

counter = 1;
yy = zeros(201,length(slope));
for kk = 1 : length(slope)
   xx1 = min([xxx(kk), x]);
   xx2 = max([xxx(kk), x]);
   counter = 1;
   for xx = xx1:xx2
       yy(counter,kk) = slope(kk).*xx+const(kk);
       counter = counter + 1;
   end
      xx = xx1:xx2;

   plot(xx, yy(1:length(xx),kk), 'blue')
   
end

x = record_route_x(id_rx);
y = record_route_y(id_rx);

x1 = layoutParams.building_scatterers(logical(linkParams.actives_buildings(:,snapshot)),1);
y1 = layoutParams.building_scatterers(logical(linkParams.actives_buildings(:,snapshot)),2);

x2 = layoutParams.sign_scatterers(logical(linkParams.actives_signs(:,snapshot)),1);
y2 = layoutParams.sign_scatterers(logical(linkParams.actives_signs(:,snapshot)),2);

x3 = layoutParams.bridge_scatterers(logical(linkParams.actives_bridges(:,snapshot)),1);
y3 = layoutParams.bridge_scatterers(logical(linkParams.actives_bridges(:,snapshot)),2);

x4 = record_route_x(logical(linkParams.actives_v2v(:,snapshot)));
y4 = record_route_y(logical(linkParams.actives_v2v(:,snapshot)));

xxx = [x1; x2; x3;x4];
slope = (y-[y1; y2; y3;y4])./(x - xxx);
const = [y1; y2; y3;y4] - slope.*xxx;

counter = 1;
yy = zeros(201,length(slope));
for kk = 1 : length(slope)
   xx1 = min([xxx(kk), x]);
   xx2 = max([xxx(kk), x]);
   counter = 1;
   for xx = xx1:xx2
       yy(counter,kk) = slope(kk).*xx+const(kk);
       counter = counter + 1;
   end
      xx = xx1:xx2;

   plot(xx, yy(1:length(xx),kk), 'red')
   
end
