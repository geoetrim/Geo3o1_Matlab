% Preprocessing of points and metadata
% Recoded by Hüseyin TOPAN (ZBEÜ), April 2023

function prepro(i)

fid       = evalin('base','fid');
sensor_id = evalin('base','sensor_id');
points    = evalin('base','points');
num_im    = evalin('base','number_images');
t_start   = evalin('base','t_start');
t_period  = evalin('base','t_period');
satpv     = evalin('base','satpv');
Q         = evalin('base','Q');
XLOS_0    = evalin('base','XLOS_0');
XLOS_1    = evalin('base','XLOS_1');
YLOS_0    = evalin('base','YLOS_0');
sensor_name = evalin('base','sensor_name');

if sensor_id == 2
    YLOS_1    = evalin('base','YLOS_1');
    if i > 1
        Qn_point = evalin('base','Qn_point');
        Qn_coef  = evalin('base', 'Qn_coef');
    end
end

%===== (x, y) - (xo, yo) =====
for j = 2 : 3
    points(: , j + 5 , i) = points(: , j , i) - 1; %line reference = 1 (page 77)
end

%===== time of each line, from 0th hour of the date =====
points(: , 9 , i) = t_start(i) + points(: , 7 , i) * t_period(i);
assignin('base', 'points', points)

%===== Calculation of position and quaternions for each line of points =====
for j = 1 : length(points(: , 1))
    if strcmp(sensor_name,'PNEO_SENSOR') == 0 
        for k = 1 : 3
            points(j , k + 9 , i) = lagr(nonzeros(satpv(: , 1 , i)), nonzeros(satpv(: , k + 1 , i)), points(j , 9 , i));
        end
    elseif strcmp(sensor_name,'PNEO_SENSOR') == 1
        for k = 1 : 3
            points(j , k + 9 , i) = linear_interpolation(nonzeros(satpv(: , k + 1 , i)), nonzeros(satpv(: , 1 , i)), points(j , 9 , i));
        end
    end
    if sensor_id == 2
        for k = 1 : 4
            Qn_point(j , k , i) = linear_interpolation(nonzeros(Q(: , k + 1 , i)), nonzeros(Q(: , 1 , i)), points(j , 9 , i));%Linear enterpolation for Q0, Q1, Q2, Q3
        end
    end
end
if sensor_id == 2
    assignin('base', 'Qn_point', Qn_point)
end

%===== Calculation of LOS for each points =====
points(: , 16 , i) = YLOS_0(i);
if sensor_id == 2
    points(: , 16 , i) = YLOS_0(i) + YLOS_1(i) * points(: , 8 , i);
end
points(: , 17 , i) = XLOS_0(i) + XLOS_1(i) * points(: , 8 , i);
points(: , 18 , i) = atan(points(: , 16 , i));
points(: , 19 , i) = atan(points(: , 17 , i));

assignin('base', 'points', points)

%===== Calculation of satellite position's coefficients via polynomial approach =====
for j = 1 : 3
    if i > 1
        Ps_coef = evalin('base', 'Ps_coef');
    end
    Ps_coef(j , : , i) = appvalue(points(: , : , i), j + 9, points(: , 7 , i), 2);%2nd order polynomial
    assignin('base', 'Ps_coef', Ps_coef)
end
%===== Calculation of quaternions' coefficients via polynomial approach =====
if sensor_id == 2
    for j = 1 : 4
        Qn_coef(j , : , i) = appvalue(Qn_point(: , : , i), j, points(: , 7 , i), 2);%2nd order polynomial
    end
    assignin('base', 'Qn_coef', Qn_coef)
end

% ===== Removing the points to be ignored =====
Sip = ignored_points;
if i == num_im
    points = remove_ignored_point(Sip, points, fid);
    assignin('base', 'points', points)
end