function pathlosses = pathloss_NLoS(distances, linkParams)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

A = 37.8;
B = 36.5; 
C = 23;

pathlosses = A*log10(distances) + B + C*log10(linkParams.frequency/5/1e9);
