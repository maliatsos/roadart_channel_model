function  []  = determine_dopplers(linkParams, static_phi_aods, sign_phi_aods, bridge_phi_aods, v2v_phi_aods,...
    static_phi_aoas, sign_phi_aoas, bridge_phi_aoas, v2v_phi_aoas)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

cos(static_phi_aods-linkParams.direction_of_movement_tx)/linkParams.lambda;
cos(sign_phi_aods-linkParams.direction_of_movement_tx)/linkParams.lambda;
cos(bridge_phi_aods-linkParams.direction_of_movement_tx)/linkParams.lambda;

cos(static_phi_aoas-linkParams.direction_of_movement_tx)/linkParams.lambda;
cos(sign_phi_aoas-linkParams.direction_of_movement_tx)/linkParams.lambda;
cos(bridge_phi_aoas-linkParams.direction_of_movement_tx)/linkParams.lambda;
