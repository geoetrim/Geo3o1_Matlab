%Determination approximate values of unknowns with 2nd order polynomial
%Coded by Hüseyin TOPAN (ZKÜ) July 2009

function dx = appvalue(gcp, k , dxy, order)

x = gcp (: , dxy); %x-xref or y-yref

L = gcp (: , k); 

%-------------------------------
for i = 1 : length (gcp(:, 1))
    for j = 0 : order
        A(i, j + 1) = x(i)^j;
    end
end

% dx =  inv(A' * A) * A' * L;
dx =  (A' * A) \ (A' * L);

% v = A * dx - L;
% 
% tsnc = par_valid (A, v, dx);