% Design matrix for EOPs
% Calculates A matrix for all EOPs, and re-arranges it for selected EOPs
%
% Please check the version of the desing matrix (dm).
% Recoded by Hüseyin TOPAN (BEÜ), December 2015.

function A = A_EOP_u_3(unknwn, gcp)

Sc = evalin('base', 'Sc');
Sp = evalin('base', 'Sp');

for i = 1 : length(gcp(:, 1))
    
    %===== Checking whether point is a check point =====
    c = cp (gcp(i, 1), Sc);
    
    %===== Desing matrix related to all EOPs =====
    A1 = Jacobian_EOP_3(unknwn, gcp(i, :), c);
    
    A2(2 * i - 1 , :) = A1(1 , :);
    A2(2 * i     , :) = A1(2 , :);
end

%===== Re-arrangement A considering Sp =====
for k = 1 : length(Sp)
    A(: , k) = A2(:, Sp(k));
end