%Estimation of Ps and VisPter in direct georeferencing

function VisPter = app_VisPter (gcp , j, LOS , mdl)
%% Loading
if mdl == 1
    XLOS_0 = LOS(1);
    XLOS_1 = LOS(2);
    YLOS_0 = LOS(3);
elseif mdl == 3
    psiy = gcp(18);
    psix = gcp(19);
end

t_offset = evalin('base', 't_offset');
t_scale  = evalin('base', 't_scale');

Q = evalin('base', 'Q');

%% Estimation
if mdl == 1
    VisPscan = [YLOS_0; -(XLOS_0 + XLOS_1 * gcp(: , 8)); 1];
elseif mdl == 3
    VisPscan = [tan(psiy); -tan(psix); 1];
end

tcn = (gcp(: , 9) - t_offset(j)) / t_scale(j);

for i = 1 : 4
    for k = 1 : 4
        Q2(k) = Q(i , k , j) * tcn^(k - 1);
    end
    Q3(i) = sum(Q2);
end

Q3 = Q3';

Qn = Q3 / sqrt (Q3' * Q3);

R(1 , 1) = Qn(1)^2 + Qn(2)^2 - Qn(3)^2 - Qn(4)^2;
R(1 , 2) = 2 * (Qn(2) * Qn(3) - Qn(1) * Qn(4));
R(1 , 3) = 2 * (Qn(2) * Qn(4) + Qn(1) * Qn(3));
R(2 , 1) = 2 * (Qn(2) * Qn(3) + Qn(1) * Qn(4));
R(2 , 2) = Qn(1)^2 - Qn(2)^2 + Qn(3)^2 - Qn(4)^2;
R(2 , 3) = 2 * (Qn(3) * Qn(4) - Qn(1) * Qn(2));
R(3 , 1) = 2 * (Qn(2) * Qn(4) - Qn(1) * Qn(3));
R(3 , 2) = 2 * (Qn(3) * Qn(4) + Qn(1) * Qn(2));
R(3 , 3) = Qn(1)^2 - Qn(2)^2 - Qn(3)^2 + Qn(4)^2;

VisPter = R * VisPscan;