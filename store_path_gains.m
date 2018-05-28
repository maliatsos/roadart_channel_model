function [path_gains_v2v, path_gains_static, path_gains_signs, path_gains_bridges] = store_path_gains(snapshot, linkParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

path_gains_v2v = [];
path_gains_signs = [];
path_gains_bridges = [];
path_gains_static = [];

time = floor(linkParams.time_axis(snapshot)/linkParams.vehicular_sampling_period)+1;
if linkParams.total_num_v2v_scatterers(time)>0
    path_gains_v2v = linkParams.path_gains_v2v(logical(linkParams.actives_v2v(:,time)),time);
end
if linkParams.total_num_building_scatterers(time)>0
    path_gains_static = linkParams.path_gains_buildings(logical(linkParams.actives_buildings(:,time)),time);
end
if linkParams.total_num_sign_scatterers(time)>0
    path_gains_signs = linkParams.path_gains_signs(logical(linkParams.actives_signs(:,time)),time);
end
if linkParams.total_num_bridge_scatterers(time)>0
    path_gains_bridges = linkParams.path_gains_bridges(logical(linkParams.actives_bridges(:,time)),time);
end