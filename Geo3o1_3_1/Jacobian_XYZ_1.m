% Jacobian matrix of XYZ of ICPs for Pléiades
% Recoded by Hüseyin Topan, BEÜ, 2015
% Functional model is Functional_Model_1.m

function A = Jacobian_XYZ_1(unknown, points);

Xs0  = unknown( 5);   Xs1 = unknown( 6);  Xs2 = unknown( 7);
Ys0  = unknown( 8);   Ys1 = unknown( 9);  Ys2 = unknown(10);   
Zs0  = unknown(11);   Zs1 = unknown(12);  Zs2 = unknown(13);
   
dx = points(7);

X = points(13);
Y = points(14);
Z = points(15);

A(1, 1) = -1/(Zs0 - Z + Zs1*dx + Zs2*dx^2) ;
A(1, 2) = 0 ;
A(1, 3) = (Xs0 - X + Xs1*dx + Xs2*dx^2)/(Zs0 - Z + Zs1*dx + Zs2*dx^2)^2 ;

A(2, 1) = 0 ;
A(2, 2) = -1/(Zs0 - Z + Zs1*dx + Zs2*dx^2) ;
A(2, 3) = (Ys0 - Y + Ys1*dx + Ys2*dx^2)/(Zs0 - Z + Zs1*dx + Zs2*dx^2)^2 ;