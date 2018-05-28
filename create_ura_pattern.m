function b = create_ura_pattern(distances, sizes, phi, theta)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017
num_paths = length(phi);
if length(theta)~=num_paths
    error('In use of create_ura_pattern');
end
if length(sizes)==1
    sizes = [sizes; sizes];
    distances = [distances; distances];
else
    sizes = sizes(:);
    distances = distances(:);
end
num_elements = sizes(1)*sizes(2);

b = zeros(num_elements, num_paths);
Bdipole = half_wavelength_dipole_pattern_pair(phi, theta);

for mm = 1 : num_paths
    counter = 1;
    for kk = (floor(-(sizes(1)-1)/2):floor((sizes(1)-1)/2));
        m1 = exp(2i*pi*kk*distances(1).*cos(phi(mm)).*sin(theta(mm)));
        for ll = (floor(-(sizes(1)-1)/2):floor((sizes(1)-1)/2));
            m2 = exp(2i*ll*pi*distances(2)*sin(theta(mm)));
            b(counter, mm) = m1*m2*Bdipole(mm);
            counter = counter + 1;
        end
    end
end
