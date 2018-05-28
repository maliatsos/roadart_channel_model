function b = create_ura_beamspace(distances, sizes, phi, theta)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017
if length(sizes)==1
    sizes = [sizes; sizes];
    distances = [distances; distances];
else
    sizes = sizes(:);
    distances = distances(:);
end
num_elements = sizes(1)*sizes(2);

b = zeros(num_elements, length(theta), length(phi));
Bdipole = half_wavelength_dipole_pattern(phi, theta);

for mm = 1 : length(phi)
    for nn = 1 : length(theta)
        counter = 1;
        for kk = (floor(-(sizes(1)-1)/2):floor((sizes(1)-1)/2));
            m1 = exp(2i*pi*kk*distances(1).*cos(phi(mm)).*sin(theta(nn)));
            for ll = (floor(-(sizes(1)-1)/2):floor((sizes(1)-1)/2));
                m2 = exp(2i*ll*pi*distances(2)*sin(theta(nn)));
                b(counter, nn, mm) = m1*m2*Bdipole(nn,mm);
                counter = counter + 1;
            end
        end
    end
end
