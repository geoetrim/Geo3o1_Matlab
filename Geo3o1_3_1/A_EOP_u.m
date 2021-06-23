% Design matrix for EOPs
% Calculates A matrix for all EOPs, and re-arranges it for selected EOPs
%
% Please check the version of the desing matrix (dm).
% Recoded by Hüseyin TOPAN (BEÜ), December 2015.

function A = A_EOP_u(unknwn, LOS, points, mdl)

Sc = evalin('base', 'Sc');
Sp = evalin('base', 'Sp');

for i = 1 : length(points(:, 1))
    
    %===== Checking whether point is a check point =====
    c = cp (points(i, 1), Sc);
    
    %===== Desing matrix related to all EOPs =====
    if mdl == 1
        A1 = Jacobian_EOP_1(unknwn, LOS, points(i, :), c);
    elseif mdl == 2
        A1 = Jacobian_EOP_2(unknwn, LOS, points(i, :), c);
    elseif mdl == 3
        A1 = Jacobian_EOP_3(unknwn, points(i, :), c);
    end
    
    A2(2 * i - 1 , :) = A1(1 , :);
    A2(2 * i     , :) = A1(2 , :);
end

%===== Re-arrangement A considering Sp =====
for k = 1 : length(Sp)
    A(: , k) = A2(:, Sp(k));
end