time_axis = 0:linkParams.vehicular_sampling_period:linkParams.sim_duration;
figure('Color',[0.8 0.8 0.8]);
for ll = 1 : length(time_axis)
    btn = zoom_overtake2(linkParams.tx_id, linkParams.rx_id, record_route_x(:,ll), record_route_y(:,ll), layoutParams, results, linkParams, ll);
%     if ll == 180
%         break
%     end
end