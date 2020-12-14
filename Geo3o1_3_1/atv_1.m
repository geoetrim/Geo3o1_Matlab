%Estimation of misclosure vector for Pléiades
%Coded by Hüseyin Topan, BEÜ, March 2016
% Functional model is Functional_Model_1.m

function w = atv_1(unknown, LOS, gcp)

Sc = evalin('base', 'Sc');

t_start  = unknown(1);
t_period = unknown(2);
t_offset = unknown(3); 
t_scale  = unknown(4);

Xs0  = unknown( 5);   Xs1 = unknown( 6);  Xs2 = unknown( 7);
Ys0  = unknown( 8);   Ys1 = unknown( 9);  Ys2 = unknown(10);   
Zs0  = unknown(11);   Zs1 = unknown(12);  Zs2 = unknown(13);
 
Q0_0 = unknown(14);  Q0_1 = unknown(15); Q0_2 = unknown(16); Q0_3 = unknown(17);   
Q1_0 = unknown(18);  Q1_1 = unknown(19); Q1_2 = unknown(20); Q1_3 = unknown(21);   
Q2_0 = unknown(22);  Q2_1 = unknown(23); Q2_2 = unknown(24); Q2_3 = unknown(25);    
Q3_0 = unknown(26);  Q3_1 = unknown(27); Q3_2 = unknown(28); Q3_3 = unknown(29);

XLOS_0 = LOS(1);
XLOS_1 = LOS(2);
YLOS_0 = LOS(3);

for i = 1 : length(gcp(:, 1))
    dx = gcp(i , 7);
    dy = gcp(i , 8);
    
    if exist('Sc','var') == 1
        c = cp (gcp(i, 1), Sc);
    end
    
    if c == 1 %i.e. if point is a check point
        X = gcp(i , 13);
        Y = gcp(i , 14);
        Z = gcp(i , 15);
    else                  
        X = gcp(i , 4);
        Y = gcp(i , 5);
        Z = gcp(i , 6);
    end

    Xs = Xs0  + Xs1 * dx + Xs2 * dx^2;
    Ys = Ys0  + Ys1 * dx + Ys2 * dx^2;
    Zs = Zs0  + Zs1 * dx + Zs2 * dx^2;

    Ps = [Xs; Ys; Zs];

    P = [X; Y; Z];

    t = t_start + dx * t_period;

    tcn = (t - t_offset) / t_scale;

    Q0 = Q0_0 + Q0_1 * tcn + Q0_2 * tcn^2 + Q0_3 * tcn^3;
    Q1 = Q1_0 + Q1_1 * tcn + Q1_2 * tcn^2 + Q1_3 * tcn^3;
    Q2 = Q2_0 + Q2_1 * tcn + Q2_2 * tcn^2 + Q2_3 * tcn^3;
    Q3 = Q3_0 + Q3_1 * tcn + Q3_2 * tcn^2 + Q3_3 * tcn^3;

    Q = [Q0 Q1 Q2 Q3];

    Qn = Q / sqrt (Q * Q');

    R(1 , 1) = Qn(1)^2 + Qn(2)^2 - Qn(3)^2 - Qn(4)^2;
    R(1 , 2) = 2 * (Qn(2) * Qn(3) - Qn(1) * Qn(4));
    R(1 , 3) = 2 * (Qn(2) * Qn(4) + Qn(1) * Qn(3));
    R(2 , 1) = 2 * (Qn(2) * Qn(3) + Qn(1) * Qn(4));
    R(2 , 2) = Qn(1)^2 - Qn(2)^2 + Qn(3)^2 - Qn(4)^2;
    R(2 , 3) = 2 * (Qn(3) * Qn(4) - Qn(1) * Qn(2));
    R(3 , 1) = 2 * (Qn(2) * Qn(4) - Qn(1) * Qn(3));
    R(3 , 2) = 2 * (Qn(3) * Qn(4) + Qn(1) * Qn(2));
    R(3 , 3) = Qn(1)^2 - Qn(2)^2 - Qn(3)^2 + Qn(4)^2;

    Pvs = [YLOS_0; -(XLOS_0 + XLOS_1 * dy); 1];

    w(2 * i - 1) = (Xs - X) / (Zs - Z) - ((R(1 , :) * Pvs) / (R(3 , :) * Pvs));
    w(2 * i    ) = (Ys - Y) / (Zs - Z) - ((R(2 , :) * Pvs) / (R(3 , :) * Pvs));
end

w = w';