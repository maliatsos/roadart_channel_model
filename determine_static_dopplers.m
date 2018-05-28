function  [doppler_static, doppler_signs, doppler_bridges]  = determine_static_dopplers(snapshot, linkParams, static_phi_aods, sign_phi_aods, bridge_phi_aods,...
    static_phi_aoas, sign_phi_aoas, bridge_phi_aoas)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

doppler_static1 = 0.277777778*linkParams.speed_tx(snapshot)*cos(static_phi_aods-linkParams.direction_of_movement_tx(snapshot))/linkParams.lambda;
doppler_signs1 = 0.277777778*linkParams.speed_tx(snapshot)*cos(sign_phi_aods-linkParams.direction_of_movement_tx(snapshot))/linkParams.lambda;
doppler_bridges1 = 0.277777778*linkParams.speed_tx(snapshot)*cos(bridge_phi_aods-linkParams.direction_of_movement_tx(snapshot))/linkParams.lambda;

doppler_static2 = 0.277777778*linkParams.speed_rx(snapshot)*cos(static_phi_aoas-linkParams.direction_of_movement_rx(snapshot))/linkParams.lambda;
doppler_signs2 = 0.277777778*linkParams.speed_rx(snapshot)*cos(sign_phi_aoas-linkParams.direction_of_movement_rx(snapshot))/linkParams.lambda;
doppler_bridges2 = 0.277777778*linkParams.speed_rx(snapshot)*cos(bridge_phi_aoas-linkParams.direction_of_movement_rx(snapshot))/linkParams.lambda;

doppler_static = doppler_static1 + doppler_static2;
doppler_signs =  doppler_signs1 + doppler_signs2;
doppler_bridges = doppler_bridges1 + doppler_bridges2;