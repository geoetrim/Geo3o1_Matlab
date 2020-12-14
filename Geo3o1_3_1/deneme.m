syms tref tper toff tscale x xref

% tcn = ((tref+tper*(x-xref))-toff)*tscale;
% 
% A(1,1) = diff(tcn,tref);
% A(1,2) = diff(tcn,tper);
% A(1,3) = diff(tcn, toff);
% A(1,4) = diff(tcn, tscale);

A= [ tscale, tscale*(x - xref), -tscale, tref - toff + tper*(x - xref)]

tref = rand(1);
tper = rand(1);
toff = rand(1);
tscale = rand(1);

x = rand(1);
xref = rand(1);

rank(A' * A)
det(A' * A)