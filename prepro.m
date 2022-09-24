% Preprocessing of points and metadata
% Recoded by Hüseyin TOPAN (BEÜ), November 2015

function prepro(i)

fid       = evalin('base','fid');
sensor_id = evalin('base','sensor_id');
points    = evalin('base','points');
num_im    = evalin('base','number_images');
t_start   = evalin('base','t_start');
t_period  = evalin('base','t_period');
satpv     = evalin('base','satpv');
XLOS_0    = evalin('base','XLOS_0');
XLOS_1    = evalin('base','XLOS_1');
YLOS_0    = evalin('base','YLOS_0');

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
    if i > 1
        Ps_coef = evalin('base', 'Ps_coef');
    end
    Ps_coef(j , : , i) = appvalue(points(: , : , i), j + 9 , 7 , 2); % 2nd order poly.
    assignin('base', 'Ps_coef', Ps_coef)
end
% ===== Removing the points to be ignored =====
if sensor_id == 1 %Pléiades 1A Zonguldak
%     Sip=[];
    Sip = [1 3 14 17:19 25 27 28 30:35 37 43 45 46 50 51 52 55 58 59 61:66 70 71 74 78 80 82 83 85 89 91 93 94 96 97 104 106 111 114 117 118 120 122:124 134 138 141 143 146 167 168 176 178 185 195 246 247 249 251 252 255 259 272 274:276 293 294 306 2591];
elseif sensor_id == 3 %Göktürk 1 Zonguldak
    Sip = [18 21 24 25 32 35 37 45 51 52 55 60 63 65 66 74 78 79 85 94 117 122 183 185 218 227 263];
end
if i == num_im
    points = remove_ignored_point(Sip, points, fid);
    assignin('base', 'points', points)
end