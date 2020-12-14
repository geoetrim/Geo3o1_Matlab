%Functional model for as SPOT-5
clear all; clc;

syms X Y Z ... 
     Xs0 Xs1 Xs2 ... 
     Ys0 Ys1 Ys2 ... 
     Zs0 Zs1 Zs2 ... 
     dx dy ...
     t_start t_period t t_offset t_scale ... 
     Q0 Q0_0 Q0_1 Q0_2 Q0_3 ... 
     Q1 Q1_0 Q1_1 Q1_2 Q1_3 ... 
     Q2 Q2_0 Q2_1 Q2_2 Q2_3 ...
     Q3 Q3_0 Q3_1 Q3_2 Q3_3 ...
     psix psiy

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

Rinv = R';

pay1  = Rinv(1 , :) * (Ps - P);
pay2  = Rinv(2 , :) * (Ps - P);
payda = Rinv(3 , :) * (Ps - P);

A(1,  1) = (1 / payda) * ( diff(pay1, t_start ) - diff(payda, t_start ) * tan(psiy));
A(1,  2) = (1 / payda) * ( diff(pay1, t_period) - diff(payda, t_period) * tan(psiy));
A(1,  3) = (1 / payda) * ( diff(pay1, t_offset) - diff(payda, t_offset) * tan(psiy));
A(1,  4) = (1 / payda) * ( diff(pay1, t_scale ) - diff(payda, t_scale ) * tan(psiy));
A(1,  5) = (1 / payda) * ( diff(pay1, Xs0     ) - diff(payda, Xs0     ) * tan(psiy));
A(1,  6) = (1 / payda) * ( diff(pay1, Xs1     ) - diff(payda, Xs1     ) * tan(psiy));
A(1,  7) = (1 / payda) * ( diff(pay1, Xs2     ) - diff(payda, Xs2     ) * tan(psiy));
A(1,  8) = (1 / payda) * ( diff(pay1, Ys0     ) - diff(payda, Ys0     ) * tan(psiy));
A(1,  9) = (1 / payda) * ( diff(pay1, Ys1     ) - diff(payda, Ys1     ) * tan(psiy));
A(1, 10) = (1 / payda) * ( diff(pay1, Ys2     ) - diff(payda, Ys2     ) * tan(psiy));
A(1, 11) = (1 / payda) * ( diff(pay1, Zs0     ) - diff(payda, Zs0     ) * tan(psiy));
A(1, 12) = (1 / payda) * ( diff(pay1, Zs1     ) - diff(payda, Zs1     ) * tan(psiy));
A(1, 13) = (1 / payda) * ( diff(pay1, Zs2     ) - diff(payda, Zs2     ) * tan(psiy));
A(1, 14) = (1 / payda) * ( diff(pay1, Q0_0    ) - diff(payda, Q0_0    ) * tan(psiy));
A(1, 15) = (1 / payda) * ( diff(pay1, Q0_1    ) - diff(payda, Q0_1    ) * tan(psiy));
A(1, 16) = (1 / payda) * ( diff(pay1, Q0_2    ) - diff(payda, Q0_2    ) * tan(psiy));
A(1, 17) = (1 / payda) * ( diff(pay1, Q0_3    ) - diff(payda, Q0_3    ) * tan(psiy));
A(1, 18) = (1 / payda) * ( diff(pay1, Q1_0    ) - diff(payda, Q1_0    ) * tan(psiy));
A(1, 19) = (1 / payda) * ( diff(pay1, Q1_1    ) - diff(payda, Q1_1    ) * tan(psiy));
A(1, 20) = (1 / payda) * ( diff(pay1, Q1_2    ) - diff(payda, Q1_2    ) * tan(psiy));
A(1, 21) = (1 / payda) * ( diff(pay1, Q1_3    ) - diff(payda, Q1_3    ) * tan(psiy));
A(1, 22) = (1 / payda) * ( diff(pay1, Q2_0    ) - diff(payda, Q2_0    ) * tan(psiy));
A(1, 23) = (1 / payda) * ( diff(pay1, Q2_1    ) - diff(payda, Q2_1    ) * tan(psiy));
A(1, 24) = (1 / payda) * ( diff(pay1, Q2_2    ) - diff(payda, Q2_2    ) * tan(psiy));
A(1, 25) = (1 / payda) * ( diff(pay1, Q2_3    ) - diff(payda, Q2_3    ) * tan(psiy));
A(1, 26) = (1 / payda) * ( diff(pay1, Q3_0    ) - diff(payda, Q3_0    ) * tan(psiy));
A(1, 27) = (1 / payda) * ( diff(pay1, Q3_1    ) - diff(payda, Q3_1    ) * tan(psiy));
A(1, 28) = (1 / payda) * ( diff(pay1, Q3_2    ) - diff(payda, Q3_2    ) * tan(psiy));
A(1, 29) = (1 / payda) * ( diff(pay1, Q3_3    ) - diff(payda, Q3_3    ) * tan(psiy));
A(1, 30) = (1 / payda) * ( diff(pay1, X       ) - diff(payda, X       ) * tan(psiy));
A(1, 31) = (1 / payda) * ( diff(pay1, Y       ) - diff(payda, Y       ) * tan(psiy));
A(1, 32) = (1 / payda) * ( diff(pay1, Z       ) - diff(payda, Z       ) * tan(psiy));

A(2,  1) = (1 / payda) * ( diff(pay2, t_start ) + diff(payda, t_start ) * tan(psix));
A(2,  2) = (1 / payda) * ( diff(pay2, t_period) + diff(payda, t_period) * tan(psix));
A(2,  3) = (1 / payda) * ( diff(pay2, t_offset) + diff(payda, t_offset) * tan(psix));
A(2,  4) = (1 / payda) * ( diff(pay2, t_scale ) + diff(payda, t_scale ) * tan(psix));
A(2,  5) = (1 / payda) * ( diff(pay2, Xs0     ) + diff(payda, Xs0     ) * tan(psix));
A(2,  6) = (1 / payda) * ( diff(pay2, Xs1     ) + diff(payda, Xs1     ) * tan(psix));
A(2,  7) = (1 / payda) * ( diff(pay2, Xs2     ) + diff(payda, Xs2     ) * tan(psix));
A(2,  8) = (1 / payda) * ( diff(pay2, Ys0     ) + diff(payda, Ys0     ) * tan(psix));
A(2,  9) = (1 / payda) * ( diff(pay2, Ys1     ) + diff(payda, Ys1     ) * tan(psix));
A(2, 10) = (1 / payda) * ( diff(pay2, Ys2     ) + diff(payda, Ys2     ) * tan(psix));
A(2, 11) = (1 / payda) * ( diff(pay2, Zs0     ) + diff(payda, Zs0     ) * tan(psix));
A(2, 12) = (1 / payda) * ( diff(pay2, Zs1     ) + diff(payda, Zs1     ) * tan(psix));
A(2, 13) = (1 / payda) * ( diff(pay2, Zs2     ) + diff(payda, Zs2     ) * tan(psix));
A(2, 14) = (1 / payda) * ( diff(pay2, Q0_0    ) + diff(payda, Q0_0    ) * tan(psix));
A(2, 15) = (1 / payda) * ( diff(pay2, Q0_1    ) + diff(payda, Q0_1    ) * tan(psix));
A(2, 16) = (1 / payda) * ( diff(pay2, Q0_2    ) + diff(payda, Q0_2    ) * tan(psix));
A(2, 17) = (1 / payda) * ( diff(pay2, Q0_3    ) + diff(payda, Q0_3    ) * tan(psix));
A(2, 18) = (1 / payda) * ( diff(pay2, Q1_0    ) + diff(payda, Q1_0    ) * tan(psix));
A(2, 19) = (1 / payda) * ( diff(pay2, Q1_1    ) + diff(payda, Q1_1    ) * tan(psix));
A(2, 20) = (1 / payda) * ( diff(pay2, Q1_2    ) + diff(payda, Q1_2    ) * tan(psix));
A(2, 21) = (1 / payda) * ( diff(pay2, Q1_3    ) + diff(payda, Q1_3    ) * tan(psix));
A(2, 22) = (1 / payda) * ( diff(pay2, Q2_0    ) + diff(payda, Q2_0    ) * tan(psix));
A(2, 23) = (1 / payda) * ( diff(pay2, Q2_1    ) + diff(payda, Q2_1    ) * tan(psix));
A(2, 24) = (1 / payda) * ( diff(pay2, Q2_2    ) + diff(payda, Q2_2    ) * tan(psix));
A(2, 25) = (1 / payda) * ( diff(pay2, Q2_3    ) + diff(payda, Q2_3    ) * tan(psix));
A(2, 26) = (1 / payda) * ( diff(pay2, Q3_0    ) + diff(payda, Q3_0    ) * tan(psix));
A(2, 27) = (1 / payda) * ( diff(pay2, Q3_1    ) + diff(payda, Q3_1    ) * tan(psix));
A(2, 28) = (1 / payda) * ( diff(pay2, Q3_2    ) + diff(payda, Q3_2    ) * tan(psix));
A(2, 29) = (1 / payda) * ( diff(pay2, Q3_3    ) + diff(payda, Q3_3    ) * tan(psix));
A(2, 30) = (1 / payda) * ( diff(pay2, X       ) + diff(payda, X       ) * tan(psix));
A(2, 31) = (1 / payda) * ( diff(pay2, Y       ) + diff(payda, Y       ) * tan(psix));
A(2, 32) = (1 / payda) * ( diff(pay2, Z       ) + diff(payda, Z       ) * tan(psix));

B (1, 1) = - ( 1 + (tan(psiy))^2);
B (1, 2) =     0;
B (2, 1) =     0;
B (2, 2) =     1 + (tan(psix))^2;

fid = fopen('A_EOP_cikis_3.txt','w+');
for i = 1 : 2
    for j = 1 : 32
        Ac = char(A(i , j));
        fprintf(fid,'A(%1d, %2d) = %s ;\n\n', i, j, Ac);
    end
end

fid = fopen('B_LOS_cikis_3.txt','w+');
for i = 1 : 2
    for j = 1 : 2
        Bc = char(B(i , j));
        fprintf(fid,'B(%1d, %1d) = %s ; \n\n', i, j, Bc);
    end
end
disp('Completed!')