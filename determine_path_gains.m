function linkParams = determine_path_gains(linkParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

prev_actives = zeros(size(linkParams.actives_buildings,1),1);
path_gains_buildings = zeros(size(linkParams.actives_buildings));
for kk = 1 : size(linkParams.actives_buildings,2)
    actives = linkParams.actives_buildings(:,kk);
    ind = find(actives-prev_actives == 1);
    for ll = 1 : length(ind)
        path_gains_buildings(ind(ll), kk) = sum(exp(1i*2*pi*rand(1,linkParams.num_rays_buildings)));
    end
    ind = find((actives-prev_actives == 0) & (prev_actives == 1));
    for ll = 1 : ind
        path_gains_buildings(ind(ll), kk) = path_gains_buildings(ind(ll), kk-1);
    end
end

prev_actives = zeros(size(linkParams.actives_signs,1),1);
path_gains_signs = zeros(size(linkParams.actives_signs));
for kk = 1 : size(linkParams.actives_buildings,2)
    actives = linkParams.actives_signs(:,kk);
    ind = find(actives-prev_actives == 1);
    for ll = 1 : length(ind)
        path_gains_signs(ind(ll), kk) = sum(exp(1i*2*pi*rand(1,linkParams.num_rays_signs)));
    end
    ind = find((actives-prev_actives == 0) & (prev_actives == 1));
    for ll = 1 : ind
        path_gains_signs(ind(ll), kk) = path_gains_signs(ind(ll), kk-1);
    end
end

prev_actives = zeros(size(linkParams.actives_bridges,1),1);
path_gains_bridges = zeros(size(linkParams.actives_bridges));
for kk = 1 : size(linkParams.actives_bridges,2)
    actives = linkParams.actives_bridges(:,kk);
    ind = find(actives-prev_actives == 1);
    for ll = 1 : length(ind)
        path_gains_bridges(ind(ll), kk) = sum(exp(1i*2*pi*rand(1,linkParams.num_rays_bridges)));
    end
    ind = find((actives-prev_actives == 0) & (prev_actives == 1));
    for ll = 1 : ind
        path_gains_bridges(ind(ll), kk) = path_gains_bridges(ind(ll), kk-1);
    end
end

prev_actives = zeros(size(linkParams.actives_v2v,1),1);
path_gains_v2v = zeros(size(linkParams.actives_v2v));
for kk = 1 : size(linkParams.actives_v2v,2)
    actives = linkParams.actives_v2v(:,kk);
    ind = find(actives-prev_actives == 1);
    for ll = 1 : length(ind)
        path_gains_v2v(ind(ll), kk) = sum(exp(1i*2*pi*rand(1,linkParams.num_rays_v2v)));
    end
    ind = find((actives-prev_actives == 0) & (prev_actives == 1));
    for ll = 1 : ind
        path_gains_v2v(ind(ll), kk) = path_gains_v2v(ind(ll), kk-1);
    end
end

linkParams.path_gains_buildings = path_gains_buildings/sqrt(linkParams.num_rays_buildings);
linkParams.path_gains_signs = path_gains_signs/sqrt(linkParams.num_rays_signs);
linkParams.path_gains_bridges = path_gains_bridges/sqrt(linkParams.num_rays_bridges);
linkParams.path_gains_v2v = path_gains_v2v/sqrt(linkParams.num_rays_v2v);

