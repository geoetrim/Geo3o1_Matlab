%Functional model for [tanpsiy -tanpsix 1]' = m * R * Pvs
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
     XLOS_0 XLOS_1 YLOS_0

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

R = R';

f1 =  (R(1 , :) * (Ps - P)) / (R(3 , :) * (Ps - P)); %tanpsiy
f2 = -(R(2 , :) * (Ps - P)) / (R(3 , :) * (Ps - P)); %tanpsix

A(1 ,  1) = diff(f1, t_start );
A(1 ,  2) = diff(f1, t_period);
A(1 ,  3) = diff(f1, t_offset);
A(1 ,  4) = diff(f1, t_scale );
A(1 ,  5) = diff(f1, Xs0     );
A(1 ,  6) = diff(f1, Xs1     );
A(1 ,  7) = diff(f1, Xs2     );
A(1 ,  8) = diff(f1, Ys0     );
A(1 ,  9) = diff(f1, Ys1     );
A(1 , 10) = diff(f1, Ys2     );
A(1 , 11) = diff(f1, Zs0     );
A(1 , 12) = diff(f1, Zs1     );
A(1 , 13) = diff(f1, Zs2     );
A(1 , 14) = diff(f1, Q0_0    );
A(1 , 15) = diff(f1, Q0_1    );
A(1 , 16) = diff(f1, Q0_2    );
A(1 , 17) = diff(f1, Q0_3    );
A(1 , 18) = diff(f1, Q1_0    );
A(1 , 19) = diff(f1, Q1_1    );
A(1 , 20) = diff(f1, Q1_2    );
A(1 , 21) = diff(f1, Q1_3    );
A(1 , 22) = diff(f1, Q2_0    );
A(1 , 23) = diff(f1, Q2_1    );
A(1 , 24) = diff(f1, Q2_2    );
A(1 , 25) = diff(f1, Q2_3    );
A(1 , 26) = diff(f1, Q3_0    );
A(1 , 27) = diff(f1, Q3_1    );
A(1 , 28) = diff(f1, Q3_2    );
A(1 , 29) = diff(f1, Q3_3    );
% A(1 , 30) = diff(f1, X       );
% A(1 , 31) = diff(f1, Y       );
% A(1 , 32) = diff(f1, Z       );
                              
A(2 ,  1) = diff(f2, t_start );
A(2 ,  2) = diff(f2, t_period);
A(2 ,  3) = diff(f2, t_offset);
A(2 ,  4) = diff(f2, t_scale );
A(2 ,  5) = diff(f2, Xs0     );
A(2 ,  6) = diff(f2, Xs1     );
A(2 ,  7) = diff(f2, Xs2     );
A(2 ,  8) = diff(f2, Ys0     );
A(2 ,  9) = diff(f2, Ys1     );
A(2 , 10) = diff(f2, Ys2     );
A(2 , 11) = diff(f2, Zs0     );
A(2 , 12) = diff(f2, Zs1     );
A(2 , 13) = diff(f2, Zs2     );
A(2 , 14) = diff(f2, Q0_0    );
A(2 , 15) = diff(f2, Q0_1    );
A(2 , 16) = diff(f2, Q0_2    );
A(2 , 17) = diff(f2, Q0_3    );
A(2 , 18) = diff(f2, Q1_0    );
A(2 , 19) = diff(f2, Q1_1    );
A(2 , 20) = diff(f2, Q1_2    );
A(2 , 21) = diff(f2, Q1_3    );
A(2 , 22) = diff(f2, Q2_0    );
A(2 , 23) = diff(f2, Q2_1    );
A(2 , 24) = diff(f2, Q2_2    );
A(2 , 25) = diff(f2, Q2_3    );
A(2 , 26) = diff(f2, Q3_0    );
A(2 , 27) = diff(f2, Q3_1    );
A(2 , 28) = diff(f2, Q3_2    );
A(2 , 29) = diff(f2, Q3_3    );
% A(2 , 30) = diff(f2, X       );
% A(2 , 31) = diff(f2, Y       );
% A(2 , 32) = diff(f2, Z       );

B(1 , 1) = diff(f1, XLOS_0);
B(1 , 2) = diff(f1, XLOS_1);
B(1 , 3) = diff(f1, YLOS_0);
B(2 , 1) = diff(f2, XLOS_0);
B(2 , 2) = diff(f2, XLOS_1);
B(2 , 3) = diff(f2, YLOS_0);

fid = fopen('A_EOP_cikis_2.txt','w+');
for i = 1 : 2
    for j = 1 : 32
        Ac = char(A(i , j));
        fprintf(fid,'A(%1d, %2d) = %s ;\n\n', i, j, Ac);
    end
end

fid = fopen('B_LOS_cikis_2.txt','w+');
for i = 1 : 2
    for j = 1 : 3
        Bc = char(B(i , j));
        fprintf(fid,'B(%1d, %1d) = %s ; \n\n', i, j, Bc);
    end
end
disp('Completed!')