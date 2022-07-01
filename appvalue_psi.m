%Estimation of polynomial coefficients of psiy and psix with weighted LSE
%Reference: BÖHHBÜY, 2008, page 28
%Coded by Prof. Dr. Hüseyin TOPAN (ZBEÜ), December 2020

function psi = appvalue_psi(icp, gcp, k)

for i = 1 : length(gcp(: , 1 , 1))
%         P(i , i) = 1 / sqrt((icp(1) - gcp(i , 7))^2 + ((icp(2) - gcp(i , 8))^2)); % 1 / s
        A(i , :) = [1 gcp(i , 7 : 8)];
end

L = gcp (: , k);

dx = (A' * A) \ (A' * L);

psi = dx' * [1; icp'];