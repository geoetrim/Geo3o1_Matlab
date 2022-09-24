%Parameter and check point selection
%Recoded by Prof. Hüseyin Topan, ZBEÜ, 2022

function Spc
sensor_id = evalin('base','sensor_id');
fid = evalin('base', 'fid');

if sensor_id == 1
    %% ===== Check point selection for Pléiades 1A Zonguldak =====
%     Sc = [24 47 98 170 207 228 261 268 271 302];
    Sc = [15 24 47 54 72 098 100 112 0170 183 0207 224 0228 239 248 0261 0268 0271 289 0302];
    %% ===== Check point selection for Pléiades 1A Karaman =====
%     Sc = [134 149 202 219 9025];
elseif sensor_id == 2
    %% ===== Check point selection for SPOT 6 Zonguldak =====
    Sc = [24 47 98 170 207 22 218 302 510 514];
%     Sc = [15 24 047 54 72 098 100 112 0170 183 207 224 0228 239 248 0261 0268 0271 289 0302];
elseif sensor_id == 3
    %% ===== Check point selection for Göktürk 1 Zonguldak =====
%     Sc = [19 33 71 58 89 207 216 260];
    Sc = [6 19 33 71 58 80 84 89 97 120 186 207 216 260];
end

assignin('base', 'Sc', Sc)

%% ===== Parameter selection =====
% Select parameter(s)
Sp = [1];
assignin('base', 'Sp', Sp)

fprintf(fid,'Selected EOPs:\n');

for i = 1 : length(Sp)
    if Sp(i) == 1; fprintf(fid,' 1 t_start \n');
        elseif Sp(i) == 2;  fprintf(fid,' 2 t_period \n');
        elseif Sp(i) == 3;  fprintf(fid,' 3 t_offset \n');
        elseif Sp(i) == 4;  fprintf(fid,' 4 t_scale  \n');
        elseif Sp(i) == 5;  fprintf(fid,' 5 Xs0      \n');
        elseif Sp(i) == 6;  fprintf(fid,' 6 Xs1      \n');
        elseif Sp(i) == 7;  fprintf(fid,' 7 Xs2      \n');
        elseif Sp(i) == 8;  fprintf(fid,' 8 Ys0      \n');
        elseif Sp(i) == 9;  fprintf(fid,' 9 Ys1      \n');
        elseif Sp(i) == 10; fprintf(fid,'10 Ys2      \n');
        elseif Sp(i) == 11; fprintf(fid,'11 Zs0      \n');
        elseif Sp(i) == 12; fprintf(fid,'12 Zs1      \n');
        elseif Sp(i) == 13; fprintf(fid,'13 Zs2      \n');
        elseif Sp(i) == 14; fprintf(fid,'14 Q0_0     \n');
        elseif Sp(i) == 15; fprintf(fid,'15 Q0_1     \n');
        elseif Sp(i) == 16; fprintf(fid,'16 Q0_2     \n');
        elseif Sp(i) == 17; fprintf(fid,'17 Q0_3     \n');
        elseif Sp(i) == 18; fprintf(fid,'18 Q1_0     \n');
        elseif Sp(i) == 19; fprintf(fid,'19 Q1_1     \n');
        elseif Sp(i) == 20; fprintf(fid,'20 Q1_2     \n');
        elseif Sp(i) == 21; fprintf(fid,'21 Q1_3     \n');
        elseif Sp(i) == 22; fprintf(fid,'22 Q2_0     \n');
        elseif Sp(i) == 23; fprintf(fid,'23 Q2_1     \n');
        elseif Sp(i) == 24; fprintf(fid,'24 Q2_2     \n');
        elseif Sp(i) == 25; fprintf(fid,'25 Q2_3     \n');
        elseif Sp(i) == 26; fprintf(fid,'26 Q3_0     \n');
        elseif Sp(i) == 27; fprintf(fid,'27 Q3_1     \n');
        elseif Sp(i) == 28; fprintf(fid,'28 Q3_2     \n');
        elseif Sp(i) == 29; fprintf(fid,'29 Q3_3     \n');
    end
end
fprintf(fid,'\n');
        
%  1 t_period
%  2 t_offset
%  3 t_scale
%  4 t_scale
% 
%  5 Xs0    6 Xs1    7 Xs2 
%  8 Ys0    9 Ys1   10 Ys2    
% 11 Zs0   12 Zs1   13 Zs2 
%  
% 14 Q0_0    15 Q0_1    16 Q0_2    17 Q0_3
% 18 Q1_0    19 Q1_1    20 Q1_2    21 Q1_3
% 22 Q2_0    23 Q2_1    24 Q2_2    25 Q2_3
% 26 Q3_0    27 Q3_1    28 Q3_2    29 Q3_3