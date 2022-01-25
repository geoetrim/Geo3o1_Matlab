<<<<<<< HEAD:appvalue.m
%Estimation of polynomial coefficients
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
dx = (A' * A) \ (A' * L);

% v = A * dx - L;
% 
=======
%Estimation of polynomial coefficients
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
dx = (A' * A) \ (A' * L);

% v = A * dx - L;
% 
>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc:Geo3o1_3_1/appvalue.m
% tsnc = par_valid (A, v, dx);