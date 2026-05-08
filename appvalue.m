%Estimation of polynomial coefficients
%Coded by Hüseyin TOPAN (ZBEÜ) April 2023

function dx = appvalue(gcp, k , dxy, order)

L = gcp(: , k); 

%-------------------------------
for i = 1 : length (gcp(:, 1))
    for j = 0 : order
        A(i, j + 1) = dxy(i)^j;
    end
end

% dx =  inv(A' * A) * A' * L;
dx = (A' * A) \ (A' * L);

% v = A * dx - L;
% 
% tsnc = par_valid (A, v, dx);