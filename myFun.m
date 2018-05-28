function y = myFun(z, x1, x2, side11, side12, d1, d2)
%function created by Kostas Maliatsos for UPRC
% current version 02/12/2017

y = zeros(2,1);

if side12>side11
    if z(1)<x1
        x1 = 1000000;
        x2 = 1000000;
    end
else
    if z(1)>x1
        x1 = 1000000;
        x2 = 1000000;
    end
end

keyboard
y(1) = (x1-z(1))^2 + (side11-z(2))^2- d2^2;
y(2) = (x2-z(1))^2 + (side12-z(2))^2 - (d1^2+d2^2);





