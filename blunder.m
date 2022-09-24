function fid = blunder
% Blunder test for Geo3o1
% Prof. H�seyin Topan, ZBE�, July 2022

f   = length (A (: , 1)) - length (dx) - nSc; %degree of freedom
mo  = sqrt ((v1' * v1) / f);
Qvv = B' * B - B' * A * Qxx * A' * B; %Mikhail and Ackerman, 1971, page: 116  
% Test value for Pope method
for i = 1 : length(v1)
    T_Pope(i) = abs(v1(i)) / (mo * sqrt(Qvv(i , i)));
end

%------------------- T-student da��l�m�na g�re -------------------------
alfa = 0.05 / length(A(: , 1)); % Yan�lma olas�l��� g�ven aral���, H. Demirel, Dengeleme Hesab�, 2003, syf: syf.183
if alfa <= 0.001; alfa = 0.001; end

T_dist = tinv(1 - alfa / 2, (f - 1)); % t testinin s�n�r b�y�kl���
assignin('base','T_dist',T_dist)

xxx

for i = 1 : length(A(: , 1)) % H�seyin Demirel, Dengeleme Hesab�, YT�, 2003, syf.182
    So(i) = sqrt(((v' * v - v(i)^2 / Qvv(i , i)) / (length(A(: , 1)) - length(dx) - 1)));
    T_student(i) = abs(v(i)) / (So(i) * sqrt(Qvv(i , i))); % Tx
    if T_student(i) <= T_dist
      sonuc(i , 2) = 0;
    else
      sonuc(i , 2) = 1;
    end
end


    

% Normal t-student ve Fisher da��l�m y�ntemlerini i�erir.
% En az bir noktadaki uyu�umsuz �l��y� hesaplar.
% Parametreler:
% A: Katsay�lar matrisi
% V: D�zeltmeler
% g: YKN
% �zt�rk ve �erbetci (1992), Dengeleme Hesab� kitab� sayfa: 322-326
% sigma = ([Vi]/2n-u)^1/2, Normal da��l�m i�in kaba hata b�y�kl���, n: �l�� say�s� u: bilinmeyen say�s�, 
% Q = (A' * A)^1/2, Bilinmeyenlerin ters a��rl�k matrisi
% Qvv = Qll - (A * Q * A'), Qvv: D�zeltmelerin ters a��rl�k matrisi
% sigma_user = 1 % sigma_user: Kullan�c� taraf�ndan istenilen sigma (mo) de�eri
% Tn = |Vi| / sigmai * (Qvv)^1/2, Tn: Normal da��l�ma g�re hipotez testi
% Sox = (f*sigmao - (Vx / Qvxvx) * (1 / f-1)))^1/2, Sox: t-student da��l�m�na g�re kaba hata b�y�kl���
% Ti = |Vi| / Sox * (Qvv)^1/2, Ti: t-student da��l�m�na g�re hipotez testi
% mo = ((Vx' * Vx) / 2n-u), Fisher da��l�m�na g�re kaba hata b�y�kl���
% F = Vi^2 / (mo * (Qvivi)^1/2), Fisher da��l�m�na g�re hipotez test b�y�kl���
% mc = moc(Qvv)^1/2, Koordinat �iftine g�re kaba hata b�y�kl���
% Tc = ( (Vx' * Vx + Vy' * Vy) / 2*mc )^1/2, Koordinat �iftine g�re hipotez testi
% Hat�rlatmalar:
% a) Bu mod�lde "2*n" ifadesi, kar���kl��� azaltmak ad�na A matrinin sat�r b�y�kl��� ile ifade edilir.
% mx = sqrt(v(: , 1)' * v(: , 1) / (2*length(g(: , 1)) - length(dx)));
% my = sqrt(v(: , 2)' * v(: , 2) / (2*length(g(: , 1)) - length(dx)));
% mo = sqrt ((v(: , 1)' * v(: , 1) + v(: , 2)' * v(: , 2) )/ (2*length(g(: , 1)) - length(dx)));

sigma_user = 1 / scale; % apriori_sigma = 1 pixel

Qll = inv(P); %�l��lerin ters a��rl�k matrisi
    
Qvv = Qll - A * Qxx * A'; %D�zeltmelerin ters a��rl�k matrisi

%------------------- Normal da��l�ma g�re -------------------------
%Demirel, 2003, syf. 182, Baarda
for i = 1 : length(A(:,1))
    T_Baarda(i) = abs(v(i)) / (sigma_user * sqrt(Qvv(i , i)));
end
[sonuc(1,1) sonuc(2,1)] = max(T_Baarda);
   
%%    
alfa = 0.05 / length(A(: , 1)); % Yan�lma olas�l��� g�ven aral���, H. Demirel, Dengeleme Hesab�, 2003, syf: syf.183
 
if alfa <= 0.001
    alfa = 0.001;
end
%------------------- T-student da��l�m�na g�re -------------------------
T_dist = tinv(1 - alfa / 2, (length(A(: , 1)) - length(dx) - 1)); % t testinin s�n�r b�y�kl���
assignin('base','T_dist',T_dist)

for i = 1 : length(A(: , 1)) % H�seyin Demirel, Dengeleme Hesab�, YT�, 2003, syf.182
    So(i) = sqrt(((v' * v - v(i)^2 / Qvv(i , i)) / (length(A(: , 1)) - length(dx) - 1)));
    T_student(i) = abs(v(i)) / (So(i) * sqrt(Qvv(i , i))); % Tx
    if T_student(i) <= T_dist
      sonuc(i , 2) = 0;
    else
      sonuc(i , 2) = 1;
    end
end
%------------------- Tau da��l�m�na g�re -------------------------
Tau = taucv(alfa, (length(A(: , 1)) - length(dx) - 1), length(dx)); % Tau testinin s�n�r b�y�kl���

for i = 1 : length(A(: , 1)) % H�seyin Demirel, Dengeleme Hesab�, YT�, 2003, syf.182
    T_Pope(i)  = abs(v(i)) / (mo * sqrt(Qvv(i , i))); % Tx
    if T_Pope(i) <= Tau
      sonuc(i , 3) = 0;
    else
      sonuc(i , 3) = 1;
    end
end
%%
%------------------- Koordinat �iftine g�re  -------------------------
c = sqrt((length(gcp(: , 1)) - 2) * (1 - (0.05 / length(gcp(: , 1)))^(1 / (length(gcp(: , 1)) - 3))));

for i = 1 : length(gcp(: , 1))
    mv(i) = mo * sqrt(Qvv(i,i));
    Tc(i) = sqrt((v(2 * i - 1)' * v(2 * i - 1) + v(2 * i)' * v(2 * i)) / (2 * mv(i)));
    if Tc(i) <= c
          sonuc(i , 4) = 0;
       else
          sonuc(i , 4) = 1;
    end
end
%% Test sonu�lar�n� ��k�� dosyas�na yazd�rma
% "sonuc" de�i�keninde:
% 1. s�tun normal da��l�m sonu�lar�n�
% 2. s�tun t-testinin sonu�lar�n� 
% 3. s�tun Tau da��l�m� sonu�lar�n� g�sterir. 

fprintf(fid,'According to normal distribution:\n'); 
    if sonuc(1 , 1) > (3 * sigma_user) %Must be validated by a reference.
        fprintf(fid,'GCP id: %5d is outlier. \n\n',gcp(ceil(sonuc(2 , 1) / 2) , 1));
        else
        fprintf(fid,'\n');   
    end
    
fprintf(fid, 'According to student (t) distribution: \n');
for i = 1 : length(gcp(: , 1))
    if sonuc(2 * i - 1, 2) == 1
       fprintf(fid,'GCP id: %5d is outlier with "row" coordinate. \n', gcp(ceil((2 * i - 1) / 2), 1));
    end
    if sonuc(2 * i, 2) == 1
       fprintf(fid,'GCP id: %5d is outlier with "column" coordinate. \n', gcp(((2 * i) / 2), 1));
    end
end
fprintf(fid,'\n');

fprintf(fid, 'According to Tau distribution: \n');
for i = 1 : length(gcp(: , 1))
    if sonuc(2 * i - 1, 3) == 1
       fprintf(fid,'GCP id: %5d is outlier with "row" coordinate. \n', gcp(ceil((2 * i - 1) / 2), 1));
    end
    if sonuc(2 * i, 3) == 1
       fprintf(fid,'GCP id: %5d is outlier with "column" coordinate. \n', gcp(((2 * i) / 2), 1));
    end
end
fprintf(fid,'\n');

fprintf(fid, 'According to both coordinates: \n');
for i = 1 : length(gcp(: , 1))
    if sonuc(2 * i - 1, 4) == 1
       fprintf(fid,'GCP id: %5d is outlier with both coordinates. \n', gcp(ceil((2 * i - 1) / 2), 1));
    end
end
fprintf(fid,'\n');
fprintf(fid,'Total GCP number: %3d \n\n', length(gcp(: , 1))); 
