%Estimation of Ps and VisPter in direct georeferencing

function est_VisPter (gcp)
%% Loading
XLOS_0 = evalin('base', 'XLOS_0');
XLOS_1 = evalin('base', 'XLOS_1');
YLOS_0 = evalin('base', 'YLOS_0');

t_offset = evalin('base', 't_offset');
t_scale  = evalin('base', 't_scale');

Q = evalin('base', 'Q');

%% Estimation
VisPscan = [YLOS_0; -(XLOS_0 + XLOS_1 * gcp(: , 8)); 1];

t = gcp(: , 9);
tcn = (t - t_offset) / t_scale;

for i = 1 : 4
    for j = 1 : 4
        Q2(i , j) = Q(i , j) * tcn^(j - 1);
    end
    Q(i) = sum(Q2(i , :));
end

Q = Q';

Qn = Q / sqrt (Q' * Q);

R(1 , 1) = Qn(1)^2 + Qn(2)^2 - Qn(3)^2 - Qn(4)^2;
R(1 , 2) = 2 * (Qn(2) * Qn(3) - Qn(1) * Qn(4));
R(1 , 3) = 2 * (Qn(2) * Qn(4) + Qn(1) * Qn(3));
R(2 , 1) = 2 * (Qn(2) * Qn(3) + Qn(1) * Qn(4));
R(2 , 2) = Qn(1)^2 - Qn(2)^2 + Qn(3)^2 - Qn(4)^2;
R(2 , 3) = 2 * (Qn(3) * Qn(4) - Qn(1) * Qn(2));
R(3 , 1) = 2 * (Qn(2) * Qn(4) - Qn(1) * Qn(3));
R(3 , 2) = 2 * (Qn(3) * Qn(4) - Qn(1) * Qn(2));
R(3 , 3) = Qn(1)^2 - Qn(2)^2 - Qn(3)^2 + Qn(4)^2;

VisPter = R * VisPscan;

assignin('base', 'VisPter', VisPter);