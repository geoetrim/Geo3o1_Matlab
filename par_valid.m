% Parameter validation and correlation tests
% Confirmed by Adjustment Computations, Charles D. Ghilani and Paul R.Wolf

function [tsnc, korxx] = par_valid (A, B, v, dx, Qxx, Sc)

fid = evalin('base', 'fid');
number_images = evalin('base', 'number_images');

if Sc == 0 %ICP is not available.
    nSc = 0;
elseif Sc > 0
    nSc = length(Sc);
end

%Qxx =   inv(A' * ((B * B') \ A)); %Bilinmeyenlerin ters aðýrlýk matrisi

f  = length(A (: , 1)) - length(dx); %degree of freedom
mo = sqrt ((v' * v) / f);

for i = 1 : length (Qxx)
    m(i) = mo * sqrt (Qxx (i , i));
end

T = tinv (0.975, f); %Test value from table

for i = 1 : length (dx)
    t (i) = abs (dx(i)) / m(i);
    if t (i) <= T
        tsnc (i) = 0; %unvalid
    else
        tsnc (i) = 1; %valid
    end
end
tscn_Sp = tsnc(1 : (length (dx) - 3 * nSc));

%Writting the validation of EOPs into file.
fprintf(fid,'Validation of EOPs:\n');
for i = 1 : length(tscn_Sp)
    if tscn_Sp == 1
        fprintf(fid,'%d th EOP is valid.\n', i);
    elseif tscn_Sp == 0
        fprintf(fid,'%d th EOP is invalid.\n', i);
    end
end
fprintf(fid,'\n');

%Estimating the correlation among EOPs
for i = 1 : (length(Qxx) - 3 * nSc)
    for j = 1 : (length(Qxx) - 3 * nSc)
        korxx(i , j) = Qxx(i , j) / sqrt(Qxx(i , i) * Qxx(j, j));
    end
end
assignin('base','kor', korxx)

%Writting the correlation among EOPs into file.
fprintf(fid,'Correlation among EOPs:\n');
for i = 1 : (length(Qxx) - 3 * nSc)
    for j = 1 : (length(Qxx) - 3 * nSc)
        fprintf(fid,'%+1.2f ', korxx(i , j));
        if j == (length(Qxx) - 3 * nSc);
            fprintf(fid,'\n');
        end
    end
end
fprintf(fid,'\n');

%Estimating the correlation among look angles and EOPs
%[1] Mikhail, 1976, syf: 116
%[2] Öztürk ve Þerbetçi, 1992, syf: 235

% N1 = B * B'; %[1] nolu kaynakta "N"
% N2 = A' * ((B * B') \ A); %[2] nolu kaynakta "N"

%Qll = eye(size(B)) - B' * inv(N1) * B + B' * inv(N1) * A * inv(A' * inv(N1) * A) * A' * inv(N1) * B; %[2] nolu kaynak
%Qlx = - B' * (N1) \ A) * inv(N2);    
Qlx = - B' * ((B * B') \ A) * inv(A' * ((B * B') \ A));
    
for i = 1 : length(Qlx(: , 1))
    for j = 1 : (length(Qxx) - 3 * nSc)
        korlx (i , j) = Qlx(i , j) / sqrt(Qxx(j , j)); %Qll = I olduðundan.
    end
end

%Writting the max correlation among look angles and EOPs into file.
fprintf(fid,'Max correlation among look angles and EOPs:\n');
for i = 1 : number_images
    fprintf(fid,'%+1.2f', max(korlx(i))');
    if i == number_images
        fprintf(fid,'\n');
    end
end

fprintf(fid,'\n\n');