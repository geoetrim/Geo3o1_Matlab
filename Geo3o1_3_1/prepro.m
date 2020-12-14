% Preprocessing of points and Metadata
% Recoded by Hüseyin TOPAN (BEÜ), November 2015

function prepro(i)

points    = evalin('base','points');
t_start   = evalin('base', 't_start');
t_period  = evalin('base', 't_period');
satpv     = evalin('base', 'satpv');
XLOS_0    = evalin('base', 'XLOS_0');
XLOS_1    = evalin('base', 'XLOS_1');
YLOS_0    = evalin('base', 'YLOS_0');

%===== (x, y) - (xo, yo) =====
for j = 2 : 3
    points(: , j + 5 , i) = points(: , j , i) - 1; %line reference = 1 (page 77)
end

%===== time of each line, from 0th hour of the date =====
points(: , 9 , i) = t_start(i) + points(: , 7 , i) * t_period(i);

%===== Calculation of position for each line of points =====
for j = 1 : length(points(: , 1))
    for k = 1 : 3
        points(j , k + 9 , i) = lagr (satpv(: , 1 , i), satpv(: , k + 1 , i), points(j , 9 , i));
    end
end

%===== Calculation of LOS for each points =====
points(: , 16 , i) = YLOS_0(i);
points(: , 17 , i) = XLOS_0(i) + XLOS_1(i) * points(: , 8 , i);
points(: , 18 , i) = atan(points(: , 16 , i));
points(: , 19 , i) = atan(points(: , 17 , i));

assignin('base', 'points', points)

%===== Calculation of Satellite position's coefficients via polynomial approach =====
for j = 1 : 3
    if i == 2
        Ps_coef = evalin('base', 'Ps_coef');
    end
    Ps_coef(j , : , i) = appvalue(points(: , : , i), j + 9 , 7 , 2); % 2nd order poly.
    assignin('base', 'Ps_coef', Ps_coef)
end