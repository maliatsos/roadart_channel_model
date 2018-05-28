function pathlosses = pathloss_LoS(distances, linkParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

A = 13.9;
B = 64.4;
C = 20;

pathlosses = A*log10(distances) + B + C*log10(linkParams.frequency/5/1e9);
