% Jacobian matrix of Look angles for Pléiades
% Recoded by Hüseyin Topan, BEÜ, March 2016
% Functional model is Functional_Model_3.m
% Do not use gcp(: , 16) or gcp(: , 17) instead of tan(psiy) and tan(psix),
% respectively, at the differantial formulation below since psiy and psix were updated
% (adjusted) and reused at bundle adjustment stage.

function B = Jacobian_LA_3(gcp);

psiy = gcp(: , 18);
psix = gcp(: , 19);

for i = 1 : length(psix)
    B (2 * i - 1, 2 * i - 1) = - (1 + (tan(psiy(i)))^2);
    B (2 * i,     2 * i)     =    1 + (tan(psix(i)))^2 ;
end