% Approximate ground coordinates for the check/tie points via direct georeferencing.

function app_ground

gcp1 = evalin('base', 'gcp1');
gcp2 = evalin('base', 'gcp2');

for i = 1 : length(gcp1(: , 1));
    
    app_VisPter(gcp1(i , :))
    
    VisPter_1 = evalin('base', 'VisPter');
    
    app_VisPter(gcp2(i , :))

    VisPter_2 = evalin('base', 'VisPter');
    
    A = [-VisPter_1, VisPter_2];
    b = gcp1(i , 10 : 12)' - gcp2(i , 10 : 12)';
    
    m = inv(A' * A) * A' * b;
    
    gcp1(i, 13 : 15) = 1 / 2 * ((gcp1(i , 10 : 12) - m(1) * VisPter_1') + (gcp2(i , 10 : 12) - m(2) * VisPter_2'));
end

gcp2(: , 13 : 15) = gcp1(: , 13 : 15);

assignin('base', 'gcp1', gcp1);
assignin('base', 'gcp2', gcp2);