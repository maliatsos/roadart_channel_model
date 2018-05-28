%script created by Kostas Maliatsos for UPRC
% current version 02/12/2017
%% Main LinkParams:
linkParams = struct('vehicular_sampling_period',[],'time_sampling_period',[], 'rx_sensitivity', [], 'sim_duration', [], 'maximum_distance', [],...
    'direction_of_movement_tx', [], 'direction_of_movement_rx', [], 'LoSconditions', [], 'route_tx', [], 'route_rx', [],...
    'time_axis', [], 'frequency', [], 'lambda', [], 'height_tx', [], 'height_rx', [],...
    'num_rays_buildings', [], 'num_rays_signs', [], 'num_rays_bridges', [], 'num_rays_v2v', [],...
    'bandwidth', [], 'frequency_bins', [], 'stationarity_snapshots', []);


%% Initialize Values:
linkParams.time_sampling_period = 0.0005; % In seconds
linkParams.vehicular_sampling_period = 0.1; % In seconds
linkParams.sim_duration = 20;
linkParams.time_axis = 0:linkParams.time_sampling_period:linkParams.sim_duration-linkParams.vehicular_sampling_period;

linkParams.maximum_distance = 300; % maximum tx and rx distance

linkParams.rx_sensitivity = -101; %in dBm
linkParams.height_tx = 1.5;
linkParams.height_rx = 1.5;
linkParams.frequency = 5.9*1e9;
c = 299792458;
linkParams.lambda = c/linkParams.frequency;


linkParams.num_rays_buildings = 10;
linkParams.num_rays_signs = 4;
linkParams.num_rays_bridges = 10;
linkParams.num_rays_v2v = 8;

linkParams.bandwidth = 25e6;
linkParams.frequency_bins = 128;
linkParams.stationarity_snapshots = 12;


%% Dense Multipath Components:
alpha_0 = 0.001;
alpha_1 = 0.0008;
tau_d = 0;    % IN SAMPLES not IN SECONDS!
beta_d = 0.1;
% Create DMC struct:
dmc_parameters = struct('alpha_0', alpha_0, 'alpha_1', alpha_1, 'beta_d', beta_d, 'tau_d', tau_d);

