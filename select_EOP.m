%EOP selection
%Recoded by Prof. Hüseyin Topan, ZBEÜ, 2022

function select_EOP
sensor_id = evalin('base','sensor_id');
fid = evalin('base', 'fid');

Sp = [1];
assignin('base', 'Sp', Sp)

fprintf(fid,'Selected EOPs:\n');
if sensor_id == 1 || sensor_id == 3
    for i = 1 : length(Sp)
        if     Sp(i) ==  1; fprintf(fid,' 1 t_start  \n');
        elseif Sp(i) ==  2; fprintf(fid,' 2 t_period \n');
        elseif Sp(i) ==  3; fprintf(fid,' 3 t_offset \n');
        elseif Sp(i) ==  4; fprintf(fid,' 4 t_scale  \n');
        elseif Sp(i) ==  5; fprintf(fid,' 5 Xs0      \n');
        elseif Sp(i) ==  6; fprintf(fid,' 6 Xs1      \n');
        elseif Sp(i) ==  7; fprintf(fid,' 7 Xs2      \n');
        elseif Sp(i) ==  8; fprintf(fid,' 8 Ys0      \n');
        elseif Sp(i) ==  9; fprintf(fid,' 9 Ys1      \n');
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
elseif sensor_id == 2
    for i = 1 : length(Sp)
        if     Sp(i) ==  1; fprintf(fid,' 1 Xs0  \n');
        elseif Sp(i) ==  2; fprintf(fid,' 2 Xs1  \n');
        elseif Sp(i) ==  3; fprintf(fid,' 3 Xs2  \n');
        elseif Sp(i) ==  4; fprintf(fid,' 4 Ys0  \n');
        elseif Sp(i) ==  5; fprintf(fid,' 5 Ys1  \n');
        elseif Sp(i) ==  6; fprintf(fid,' 6 Ys2  \n');
        elseif Sp(i) ==  7; fprintf(fid,' 7 Zs0  \n');
        elseif Sp(i) ==  8; fprintf(fid,' 8 Zs1  \n');
        elseif Sp(i) ==  9; fprintf(fid,' 9 Zs2  \n');
        elseif Sp(i) == 10; fprintf(fid,'10 Q0n_0\n');
        elseif Sp(i) == 11; fprintf(fid,'11 Q0n_1\n');
        elseif Sp(i) == 12; fprintf(fid,'12 Q0n_2\n');
        elseif Sp(i) == 13; fprintf(fid,'13 Q1n_0\n');
        elseif Sp(i) == 14; fprintf(fid,'14 Q1n_1\n');
        elseif Sp(i) == 15; fprintf(fid,'15 Q1n_2\n');
        elseif Sp(i) == 16; fprintf(fid,'16 Q2n_0\n');
        elseif Sp(i) == 17; fprintf(fid,'17 Q2n_1\n');
        elseif Sp(i) == 18; fprintf(fid,'18 Q2n_2\n');
        elseif Sp(i) == 19; fprintf(fid,'19 Q3n_0\n');
        elseif Sp(i) == 20; fprintf(fid,'20 Q3n_1\n');
        elseif Sp(i) == 21; fprintf(fid,'21 Q3n_2\n');
        end
    end
end
fprintf(fid,'\n');