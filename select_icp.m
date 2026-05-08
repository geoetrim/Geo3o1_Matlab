%Selection of check points

function select_icp

sensor_id = evalin('base','sensor_id');
sensor_name = evalin('base','sensor_name');

if sensor_id == 1
    %% ===== Check point selection for Pléiades 1A Zonguldak =====
    Sc = [24 47 98 170 207 228 261 268 271 302];
%     Sc = [15 24 47 54 72 098 100 112 0170 183 0207 224 0228 239 248 0261 0268 0271 289 0302];
    %% ===== Check point selection for Pléiades 1A Karaman =====
%     Sc = [134 149 202 9019 9025];
%     Sc = [20 44 77 134 149 165 168 202 9019 9025]; %Best accuracy recorded. [0.85 0.81 1.09 m]
%     Sc = [1 6 13 20 23 26 37 39 41 44 54 58 61 62 67 77 82 99 127 134 138 141 142 147 148 149 151 153 155 164 165 166 168 170 171 174 176 179 202 210 213 219 222 224 1800 1830 1840 1850 1860 2050 2160 2231 9009 9018 9019 9025];
elseif sensor_id == 2
    if strcmp(sensor_name, 'S6_SENSOR') == 1
    %% ===== Check point selection for SPOT 6 Zonguldak =====
    Sc = [21 47 98 146 205 214 218 289 510 514];
%     Sc = [15 21 25 47 54 72 91 98 146 167 205 214 218 239 248 259 289 510 514 2621];
    elseif strcmp(sensor_name, 'PNEO_SENSOR') == 1
    %% ===== Check point selection for Pléiades Neo Zonguldak =====
%     Sc = [11 31 49 52 56 60 64 68 69 80];Used for the project report.
    Sc = [45 49 52 58 64 80 93 102 119 186];
    Sc = [Sc 11 28 35 36 51 53 55 62 107 124];
    Sc = sort(Sc);
%     ideal_points=[4 8 9 29 33 35 37 36 45 48 49 52 53 54 55 56 58 60 62 64 68 70 75 76 79 80 81 87 84 86 93 94 95 97 101 102 105 107 119 124 186];
    end
elseif sensor_id == 3
    %% ===== Check point selection for Göktürk 1 Zonguldak =====
   Sc = [19 33 71 58 89 207 216 260 509];
%    Sc = [6 19 33 71 58 80 84 89 97 120 186 207 216 260 509];
% Sc = [6 19 24 33 42 71 58 80 84 89 97 120 181 186 207 216 221 227 260 509];
%% ===== Check point selection for Göktürk 1 Kahramankazan =====
%    Sc = [11 13 15 44 131 458 463 467 471 473];
end

assignin('base', 'Sc', Sc)