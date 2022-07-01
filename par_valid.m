% Parameter validation test
% Confirmed by Adjustment Computations, Charles D. GHILANI and Paul R.
% WOLF

function [tsnc, kor] = par_valid (A, v, dx, Qxx, Sc)

%===== Loading file id =====
fid = evalin('base', 'fid');

if Sc == 0 %ICP is not available.
    nSc = 0;
elseif Sc > 0
    nSc = length(Sc);
end

% Q = inv(A' * A); %Bilinmeyenlerin ters aðýrlýk matrisi

f = length (A (: , 1)) - length (dx); %degree of freedom

mo = sqrt ((v' * v) / f);

for i = 1 : length (Qxx)
    m (i) = mo * sqrt (Qxx (i , i));
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
        kor(i , j) = Qxx(i , j) / sqrt(Qxx(i , i) * Qxx(j, j));
    end
end
assignin('base','kor', kor)

%Writting the correlation among EOPs into file.
fprintf(fid,'Correlation among EOPs:\n');
for i = 1 : (length(Qxx) - 3 * nSc)
    for j = 1 : (length(Qxx) - 3 * nSc)
        fprintf(fid,'%+1.2f ', kor(i , j));
        if j == (length(Qxx) - 3 * nSc);
            fprintf(fid,'\n');
        end
    end
end
fprintf(fid,'\n');