function [Btx, Brx] = calculate_patterns(TxParams, RxParams, phi_aods, theta_aods, phi_aoas, theta_aoas)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

%% Calculate Patterns:
antenna_type = TxParams.type;
if strcmp(antenna_type, 'ura')
    sizes = [TxParams.sizes_x; TxParams.sizes_y];
    distances = [TxParams.distances_x; TxParams.distances_y];
    %% Create Tx Pattern:
    Btx = create_ura_pattern(distances, sizes, phi_aods, theta_aods);
end

antenna_type = RxParams.type;
if strcmp(antenna_type, 'ura')
    sizes = [RxParams.sizes_x; RxParams.sizes_y];
    distances = [RxParams.distances_x; RxParams.distances_y];    
    %% Create Rx Pattern:
    Brx = create_ura_pattern(distances, sizes, phi_aoas, theta_aoas);
end