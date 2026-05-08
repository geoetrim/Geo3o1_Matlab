%Selection of ignored points

function Sip = ignored_points

sensor_id = evalin('base','sensor_id');
sensor_name = evalin('base','sensor_name');

if sensor_id == 1
    % Pléiades-1A Zonguldak
    Sip = [1 3 14 17:19 25 27 28 30:35 37 43 45 46 50 51 52 55 58 59 61:66 70 71 74 78 80 82 83 85 89 91 93 94 96 97 104 106 111 114 117 118 120 122:124 134 138 141 143 146 167 168 176 178 185 195 246 247 249 251 252 255 259 272 274:276 293 294 306 2591];
elseif sensor_id == 2
    if strcmp(sensor_name, 'S6_SENSOR') == 1
    elseif strcmp(sensor_name, 'PNEO_SENSOR') == 1
        Sip = [33 123];
%         Sip = [5 7 10 12 22 27 31 32 46 47 50 71 73 74 85 88 120 122 123 181 185];
    end
elseif sensor_id == 3
    %Göktürk-1 Zonguldak
    Sip = [18 21 24 25 32 35 37 45 51 52 55 60 63 65 66 74 78 79 85 94 117 122 183 185 218 227 263 512 518];% for Geo3o1
    % Sip = [18 19 21 25 27 32 35 46 51 52 54 55 58 59 60 63 65 66 71 74 79 80 84 85 90 94 98 117 122 183 207 259 289 509 515 516 512 518];%for 3D RFM ground to image
end
if exist('Sip','var')
    Sip = Sip;
else Sip = [];
end