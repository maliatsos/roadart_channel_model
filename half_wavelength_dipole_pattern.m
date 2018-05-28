function B = half_wavelength_dipole_pattern(phi, theta)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

B = zeros(length(theta), length(phi));
for mm = 1 : length(phi)
    for nn = 1 : length(theta)
        if abs(theta(nn)-0)>1e-12 && abs(theta(nn)-pi)>1e-12 
            B(nn, mm) = cos(pi*cos(theta(nn))/2)/sin(theta(nn));
        else
            B(nn, mm) = 0;
        end
    end
end
