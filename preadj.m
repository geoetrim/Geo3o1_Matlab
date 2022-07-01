%Preadjustment of look angles using GCPs
%Recoded by Hüseyin Topan, May 2021, ZBEÜ, Zonguldak

function [LOS, gcp, icp] = preadj(gcp, icp, unknwn, LOS, model_id)

number_images = evalin('base', 'number_images');
sensor_id = evalin('base', 'sensor_id');

%===== Jacobian matrix of look angles and absolute term vectors ====
for i = 1 : number_images %for each stereopairs
    if model_id == 1
        B1(: , : , i) = Jacobian_LA_1(unknwn(: , i) , LOS , gcp(: , : , i));
        w1(: , i)     = atv_1(unknwn(: , i) , LOS , gcp(: , : , i));
    elseif model_id == 3
        B1(: , : , i) = Jacobian_LA_3(gcp(: , : , i));
        w1(: , i)     = atv_3(unknwn(: , i) , gcp(: , : , i), 1);
    end
end

B = blkdiag(B1(: , : , 1), B1(: , : , 2));
w = [w1(: , 1) ; w1(: , 2)]; %column array

if number_images == 3
    B = blkdiag(B, B1(: , : , 3));
    w = [w ; w1(: , 3)];
end

%===== Residuals =====
v1 = -(B' * B) \ (B' * w);%i.e. =(-inv(B' * B) * B' * w)

if model_id == 1
    LOS = LOS + reshape(v1, [3 , 2]);
elseif model_id == 3
    v2 = reshape(v1 , 2 * length(gcp(: , 1 , 1)) , number_images);%[array, row, column]
        for i = 1 : length(gcp(: , 1 , 1))
            for j = 1 : number_images
                gcp(i , 18 , j) = gcp(i , 18 , j) + v2(2 * i - 1 , j);
                gcp(i , 19 , j) = gcp(i , 19 , j) + v2(2 * i     , j);
            end
        end
end

%===== Estimation of look angles of ICPs =====
for j = 1 : number_images %for each stereopairs
    for k = 1 : 2 %psiy and psix
        coef_psi(k , : , j) = appvalue(gcp(: , : , j), k + 17 , 8 , 1);
    end
end
assignin('base','coef_psi',coef_psi)

for j = 1 : number_images
    % Normalize the points into ±1
%     display('Attention! Normalization is applying!...')
%     for i = 1 : length(gcp(: , 1))
%         gcp_norm(i , 7 , j) = ((2 *  gcp(i , 7 , j) - max(gcp(: , 7 , j)) - min(gcp(: , 7 , j))) / (max(gcp(: , 7 , j)) - min(gcp(: , 7 , j))));
%         gcp_norm(i , 8 , j) = ((2 *  gcp(i , 8 , j) - max(gcp(: , 8 , j)) - min(gcp(: , 8 , j))) / (max(gcp(: , 8 , j)) - min(gcp(: , 8 , j))));
%         gcp_norm(i , 18 , j) = ((2 *  gcp(i , 18 , j) - max(gcp(: , 18 , j)) - min(gcp(: , 18 , j))) / (max(gcp(: , 18 , j)) - min(gcp(: , 18 , j))));
%     end
%     for i = 1 : length(icp(: , 1))
%         icp_norm(i , 7 , j) = ((2 *  gcp(i , 7 , j) - max(gcp(: , 7 , j)) - min(gcp(: , 7 , j))) / (max(gcp(: , 7 , j)) - min(gcp(: , 7 , j))));
%         icp_norm(i , 8 , j) = ((2 *  gcp(i , 8 , j) - max(gcp(: , 8 , j)) - min(gcp(: , 8 , j))) / (max(gcp(: , 8 , j)) - min(gcp(: , 8 , j))));
%     end
    % Re-normalization
%     icp(: , 18 , j) = ((icp_norm(: , 18 , j) * (max(gcp(: , 18 , j)) - min(gcp(: , 18 , j))) + max(gcp(: , 18 , j)) + min(gcp(: , 18 , j))) / 2);
%
    % visit https://uk.mathworks.com/help/matlab/math/interpolating-scattered-data.html
    
    % Method 1 ( John D'Errico (2020). Surface Fitting using gridfit (https://www.mathworks.com/matlabcentral/fileexchange/8998-surface-fitting-using-gridfit), MATLAB Central File Exchange. Retrieved July 31, 2020.)
    % [z, x , y] = gridfit(gcp(: , 7 , j), gcp(: , 8 , j) , gcp(: , 18 , j), length(gcp(: , 1 , 1)) * 10, length(gcp(: , 1 , 1)) * 10);
    % icp(: , 18 , j) = griddata(x , y , z , icp(: , 7 , j), icp(: , 8 , j), 'cubic');
    
    % Method 2
    % icp(: , 18 , j) = griddata(gcp(: , 7 , j), gcp(: , 8 , j) , gcp(: , 18 , j), icp(: , 7 , j), icp(: , 8 , j), 'cubic');
    
    % Method 3
%     F = scatteredInterpolant(gcp(: , 7 , j), gcp(: , 8 , j) , gcp(: , 18 , j), 'natural');
%     F.Method = 'natural';
%     icp(: , 18 , j) = F(icp(: , 7 , j), icp(: , 8 , j));
    
    % Method 4 (BÖHHBÜY)
    if sensor_id == 1 | sensor_id == 3 %Suggested for Pléiades 1A and Göktürk-1
        for i = 1 : length(icp(: , 1 , 1))
            for k = 1 : 2
                icp(i , k + 17 , j) = appvalue_psi(icp(i , 7 : 8 , j), gcp(: , : , j), k + 17);
            end
        end
    % Method 5 Polynomial 
    elseif sensor_id == 2 %Suggested for Pléiades 1A
        for i = 1 : length(icp(: , 1 , 1))
            for k = 1 : 2
                icp(i , k + 17 , j) = coef_psi(k , : , j) * [1 icp(i , 8 , j)]';% icp(i , 8 , j)^2]';%  icp(i , 8 , j)^3]';% icp(i , 8 , j)^4]'% icp(i , 8 , j)^5]'; % Select according to the order of polynomial. PS: Erase " ]'; "
            end
        end
    end
end
% 
% % Use the results from Surfer Software
% for j = 1 : 2;
%     for k = 1 : 2
%         [FileName_icp PathName_icp] = uigetfile('*.*','ICP Surfer');
%         icp(: , k + 17 , k) = load([PathName_icp FileName_icp]);
%     end
% end