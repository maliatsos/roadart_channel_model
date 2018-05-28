function [v2v_delays, static_delays, sign_delays, bridge_delays] = path_delays(v2v_distances, static_distances, sign_distances, bridge_distances)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

c = 299792458;
v2v_delays = v2v_distances/c;
static_delays = static_distances/c;
sign_delays = sign_distances/c;
bridge_delays = bridge_distances/c;

