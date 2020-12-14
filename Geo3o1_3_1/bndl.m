% Block adjustment for Pléiades images
% Gauss-Helmert Model: A.x + B.v + w = 0
% Coded by Hüseyin TOPAN (BEÜ), March 2016

function bndl

%% ===== D E F I N A T I O N S and L O A D I N G =====
%===== Iteration limit =====
iteration_limit = 1; if iteration_limit == 1; display('Attention! Total iteration: 1'); end

%===== Loading file id =====
fid = evalin('base', 'fid');

%===== Select functional model ID =====
model_id = 3;
fprintf(fid, 'Functional Model ID: %1d \n\n', model_id);

%===== Loading all points =====
points = evalin('base', 'points');

%===== GCP-ICP separation =====
Spc; Sc = evalin('base','Sc');
for i = 1 : 2
    [gcp(: , : , i), icp(: , : , i), fc] = fndicp(points(: , : , i), Sc);
end

%===== Loading look angles into one column array =====
XLOS_0 = evalin('base', 'XLOS_0');
XLOS_1 = evalin('base', 'XLOS_1');
YLOS_0 = evalin('base', 'YLOS_0');
LOS    = [XLOS_0; XLOS_1; YLOS_0];

%===== Each parameters into one variable (array format) =====
unknwn = P2U;

%===== Estimation of ~XYZ for all points via raw parameters =====
points = est_XYZ(points, LOS, 0 , model_id);
% pltv(points, 0 , 0)

%===== Load parameter set (Sp) and check point IDs (Sc) =====
Spc
Sp  = evalin('base', 'Sp');
Sc  = evalin('base', 'Sc');

%% ===== I T E R A T I O N =====
for j = 1 : iteration_limit; fprintf(fid, 'Bundle adjustment iteration: %2d \n\n', j);
    
    %===== Pre-adjustment for LOS angles =====
    if j == 1
        preq = 1;%input('Apply pre-adjustment? N: 0, Y: 1 >> ');
        if preq == 1 && (model_id == 1 || model_id == 3)
            [LOS, gcp, icp] = preadj(gcp, icp, unknwn, LOS, model_id); fprintf(fid, 'Pre-adjustment for LOS angles was applied.\n\n');
            gcp = est_XYZ(gcp, LOS, 1, model_id); %Estimation of ~XYZ of GCPs via pre-adjusted LOS angles
            icp = est_XYZ(icp, LOS, 2, model_id); %Estimation of ~XYZ of ICPs via pre-adjusted LOS angles
            points = [gcp ; icp];
            for j = 1 : 2;
                points(: , : , j) = sortrows(points(: , : , j), 1);
            end
%             pltv(points, Sc(1), 1)
        end
    end
    
    %===== Jacobian matrix of EOPs =====
    if exist('Sp','var') == 1
        for i = 1 : 2
            AEOP_u(: , : , i) = A_EOP_u(unknwn(: , i), LOS(:, i), points(: , : , i), model_id);
        end
        AEOP = [AEOP_u(: , : , 1)              zeros(size(AEOP_u(: , : , 1))); 
                zeros(size(AEOP_u(: , : , 1))) AEOP_u(: , : , 2)           ];
    end
        
    %===== Termination by linear dependency =====
%     assignin('base','rank_AEOP', rank(AEOP))
%     disperror
    
    %===== Jacobian matrix of dXYZ =====
    if Sc(1) > 0
        for i = 1 : 2
            AXYZ_u(:, : , i) = A_dXYZ(unknwn(: , i), points(: , : , i), fc, LOS(: , i), model_id);
        end
        AXYZ  = [AXYZ_u(: , : , 1); AXYZ_u(: , : , 2)];
    end
    
    %===== Combination of Jacobian matrices =====
    if (exist('Sp','var') == 1) && (Sc(1) == 0)
        A = AEOP;
    elseif (exist('Sp','var') == 0) && (Sc(1) > 0)
        A = AXYZ;
    elseif (exist('Sp','var') == 1) && (Sc(1) > 0)
        A = [AEOP AXYZ];
    end
    assignin('base', 'A', A)
    assignin('base','AEOP', AEOP)
    assignin('base', 'AXYZ', AXYZ)
    
    %===== Jacobian matrix of look angles and absolute term vectors ====
    for i = 1 : 2
        if model_id == 1
            B1(: , : , i) = Jacobian_LA_1(unknwn(: , i) , LOS , points(: , : , i));
            w1(: , i)     = atv_1(unknwn(: , i) , LOS, points(: , : , i));
        elseif model_id == 2
            w1(: , i)     = atv_2(unknwn(: , i) , LOS, points(: , : , i));
        elseif model_id == 3
            B1(: , : , i) = Jacobian_LA_3(points(: , : , i));
            w1(: , i)     = atv_3(unknwn(: , i) , points(: , : , i), 0);
        end
    end
    
    B = [B1(: , : , 1)                zeros(size(B1(: , : , 1)));
         zeros(size(B1(: , : , 1)))   B1(: , : , 2)            ];
    
    assignin('base','B',B)
    
    w = [w1(: , 1) ; w1(: , 2)]; %column array
    
    assignin('base','w',w)
    
    if model_id == 2
        for i = 1 : 2
            for j = 1 : length(points(:,1))
                lpsi(2 * j - 1 , i) = points(j , 16 , i);
                lpsi(2 * j ,     i) = points(j , 17 , i);
            end
        end
        dl = [lpsi(:,1) ; lpsi(:,2)] - w;
    end

%%  %===== Calculation of dx, k, v =====
    [mm nn] = size(A' * inv(B * B') * A);
    
% eig(A' * A)
% eig(A' * inv(B * B') * A)
    lamda = 0;%input('lamda= ');
    if model_id == 1 || model_id == 3
        if lamda ~= 0
            Qxx =   inv(A' * ((B * B') \ A) + lamda * eye(mm , nn)); fprintf(fid, 'Parameter estimation: Tikhonov regularization\n\n');
        elseif lamda == 0
            Qxx = inv(A' * ((B * B') \ A)); fprintf(fid, 'Parameter estimation: Cayley\n\n');
%             Qxx = pinv(A' * inv(B * B') * A); fprintf(fid, 'Parameter estimation: Moore-Penrose (pseudo) inversion\n\n');
%             Qxx = cholesky_ters(A' * inv(B * B') * A + lamda * eye(mm , nn)); fprintf(fid, 'Parameter estimation: Cholesky inversion\n\n');
%             Qxx = gauss_ters(A' * inv(B * B') * A + lamda * eye(mm , nn)); fprintf(fid, 'Parameter estimation: Gauss inversion\n\n');
%             Qxx = pivot(A' * inv(B * B') * A); fprintf(fid, 'Parameter estimation: Pivoting\n\n');
        end
        dx  = - Qxx * A' * ((B * B') \ w);
        korelat = - (B * B') \ (A * dx + w);
    elseif model_id == 2
        dx = inv(A' * A) * A' * dl;
        v1 = A * dx - dl;
    end
        v1      = B' * korelat;
%         for unnecessary = 1 : 1
%         AB = [A B];
%         dall = - pinv(AB) * w;
    
%         %% An alternative solution for dx and vl
%         A = [AEOP' * AEOP, AEOP' * AXYZ, AEOP' * B;
%              AXYZ' * AEOP, AXYZ' * AXYZ, AXYZ' * B;
%              B'    * AEOP, B'    * AXYZ, B'    * B];
%         [m n] = size(A);
%         eig(A)
%         pause
%         lamda2 = input('lamda(2)= ');
%         dall = pinv(A + lamda2 * eye (size(A))) * [AEOP'; AXYZ'; B'] * w;
%         dx = dall(1 : (2 * length(Sp) + 3 * length(Sc)));
%         v1 = dall((2 * length(Sp) + 3 * length(Sc) + 1) : length(dall));
%         end

%%     %===== Validation of EOPs =====
%     [tsnc, kor] = par_valid(A, v1, dx, Qxx, Sc);
    
    %===== Correction of EOPs =====
    if exist('Sp', 'var') == 1
        for k = 1 : length(Sp)
            for i = 1 : 2
                subunknwn (k , i) = unknwn(Sp(k) , i); % Selection of EOPs to be corrected.
            end
        end

        tunknwn = [subunknwn(: , 1); subunknwn(: , 2)] + dx(1 : 2 * length(Sp)); % Correction of EOPs to be selected.

        %===== Corrected EOPs are reloaded =====
        for k = 1 : length(Sp)
            unknwn(Sp(k) , 1) = tunknwn(k);
            unknwn(Sp(k) , 2) = tunknwn(length(Sp) + k);
        end
    end
    
    %===== Correction of look angles =====
    if model_id == 1
        LOS = LOS + reshape(v1, [3 , 2]);
    elseif model_id == 2 || model_id == 3
        v2 = reshape(v1 , 2 * length(points(: , 1 , 1)) , 2);
        for i = 1 : length(points(: , 1 , 1))
            for j = 1 : 2
                if model_id == 2
                    points(i , 16 , j) = points(i , 16 , j) + v2(2 * i - 1 , j);
                    points(i , 17 , j) = points(i , 17 , j) + v2(2 * i     , j);
                elseif model_id == 3
                    points(i , 18 , j) = points(i , 18 , j) + v2(2 * i - 1 , j);
                    points(i , 19 , j) = points(i , 19 , j) + v2(2 * i     , j);
                end
            end
        end
    end

%% ===== Calculation of RMSE on GCP/ICPs =====
    if Sc(1) > 0
        [gcp1, icp1, fc] = fndicp(points(: , : , 1), Sc);
        [gcp2, icp2, fc] = fndicp(points(: , : , 2), Sc);
    elseif Sc == 0
        gcp1 = points(: , : , 1);
        gcp2 = points(: , : , 2);
        icp1 = 0;
        icp2 = 0;
    end 
    est_XYZ_u(unknwn, LOS, gcp1, gcp2, fid, model_id, icp1, icp2);
    
    points = evalin('base', 'points');
    
    %===== Correction of XYZ of ICPs =====
    if Sc(1) > 0
        dc = reshape(dx(2 * length(Sp) + 1 : length(dx)), 3, length(Sc));
        dc = dc';
        assignin('base', 'dc', dc)
        
        for  k = 1 : length(fc)
            points(fc(k) , 13 : 15 , 1) = points(fc(k) , 13 : 15 , 1) + dc(k , :);
        end
        
        points(: , : , 2) = points(: , : , 1);

        for  k = 1 : length(fc)
            dicp(k , :) = points(fc(k), 4 : 6 , 1) - points(fc(k), 13 : 15 , 1);
        end
        
        assignin('base', 'dicp', dicp)
        
        for k = 1 : 3
            micp(k) = sqrt((dicp(: , k)' * dicp(: , k)) / length(fc));
        end
        
        assignin('base', 'micp', micp)

        fprintf(fid,'RMSE on ICPs after bundle adjustment\n');
        fprintf(fid,'mX = ± %15.10f (m)\nmY = ± %15.10f (m)\nmZ = ± %15.10f (m)\n\n', micp);
    end
    
    %===== Checking =====
    for i = 1 : 2
        if model_id == 1
            differ_w(: , i) = atv_1(unknwn(: , i), LOS, points(: , : , i)); % Must be same in the w estimation.
        elseif model_id == 3
            differ_w(: , i) = atv_3(unknwn(: , i) , points(: , : , i), 0);
        end
    end

    fprintf(fid,'Difference = %10.3f \n\n', max(max(abs(differ_w))));
    fprintf(fid,'----------------------------------------------\n\n');
    
    %===== Program's termination =====
    endthr
end

%% ===== Plotting =====
pltv(points, Sc(1), 3)

% ===== Clossing file =====
% fclose(fid);