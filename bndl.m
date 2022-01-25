% Bundle adjustment for Geo3o1
% Gauss-Helmert Model: Ax + Bv + w = 0
% Coded by Prof. Dr. Hüseyin TOPAN (ZBEÜ), June 2021

function bndl

<<<<<<< HEAD:bndl.m
%% ===== Definition and loading =====
=======
%% ===== D E F I N A T I O N S and L O A D I N G =====
>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc:Geo3o1_3_1/bndl.m
number_images = evalin('base','number_images');

%===== Loading file id =====
fid = evalin('base', 'fid');

%===== Loading all points =====
points = evalin('base', 'points');

%===== Loading look angles into one column array =====
XLOS_0 = evalin('base', 'XLOS_0');
XLOS_1 = evalin('base', 'XLOS_1');
YLOS_0 = evalin('base', 'YLOS_0');
LOS    = [XLOS_0; XLOS_1; YLOS_0];

%===== Select functional model ID =====
model_id = 3;
fprintf(fid, 'Functional Model ID: %1d \n\n', model_id);

%===== GCP-ICP separation =====
Spc
Sp = evalin('base','Sp');
Sc = evalin('base','Sc');
if Sc(1) > 0
    for i = 1 : number_images
        [gcp(: , : , i), icp(: , : , i), fc] = fndicp(points(: , : , i), Sc); %#ok<ASGLU,AGROW>
    end
end

%===== Each EOPs into one variable (array format) =====
unknwn = P2U;

%===== Estimation of ~XYZ for all points via raw look angles and EOPs =====
points = est_XYZ(points, LOS, 0 , model_id); %#ok<NASGU>

%===== Pre-adjustment for LOS angles =====
preq = 1;%input('Apply pre-adjustment? N: 0, Y: 1 >> ');
if preq == 1 && (model_id == 1 || model_id == 3)
    [LOS, gcp, icp] = preadj(gcp, icp, unknwn, LOS, model_id); fprintf(fid, 'Pre-adjustment for LOS angles was applied.\n\n');
    gcp = est_XYZ(gcp, LOS, 1, model_id); %Estimation of ~XYZ of GCPs via pre-adjusted LOS angles
    icp = est_XYZ(icp, LOS, 2, model_id); %Estimation of ~XYZ of ICPs via pre-adjusted LOS angles
    points = [gcp ; icp];
    for j = 1 : number_images
        points(: , : , j) = sortrows(points(: , : , j), 1);
    end
<<<<<<< HEAD:bndl.m
    pltv(points, 1)
=======
    pltv(points, Sc(1), 1)
>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc:Geo3o1_3_1/bndl.m
end

%% ===== I T E R A T I O N =====
iteration_limit = 1; if iteration_limit == 1; display('Attention! Total iteration = 1'); end
for j = 1 : iteration_limit; fprintf(fid, 'Bundle adjustment iteration: %2d \n\n', j);    
    %===== Jacobian matrix of EOPs =====
    if exist('Sp','var') == 1
        for i = 1 : number_images
            AEOP_u(: , : , i) = A_EOP_u(unknwn(: , i), LOS(:, i), points(: , : , i), model_id);
        end
        AEOP = blkdiag(AEOP_u(: , : , 1), AEOP_u(: , : , 2));
        if number_images == 3
            AEOP = blkdiag(AEOP, AEOP_u(: , : , 3));
        end
    end
    assignin('base','AEOP',AEOP)
    %===== Jacobian matrix of dXYZ of ICPs =====
    if Sc(1) > 0
        for i = 1 : number_images
            AXYZ_u(:, : , i) = A_dXYZ(unknwn(: , i), points(: , : , i), fc, LOS(: , i), model_id);
        end
        AXYZ = [AXYZ_u(: , : , 1); AXYZ_u(: , : , 2)];
        if number_images == 3
            AXYZ = [AXYZ; AXYZ_u(: , : , 3)];
        end
    end
    %===== Combination of Jacobian matrices =====
    if (exist('Sp','var') == 1) && (Sc(1) == 0)
        A = AEOP;
    elseif (exist('Sp','var') == 0) && (Sc(1) > 0)
        A = AXYZ;
    elseif (exist('Sp','var') == 1) && (Sc(1) > 0)
        A = [AEOP AXYZ];
    end
  
    %===== Jacobian matrix of look angles and absolute term vectors ====
    for i = 1 : number_images
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
    B = blkdiag(B1(: , : , 1), B1(: , : , 2));
    if number_images == 3
        B = blkdiag(B, B1(: , : , 3));
    end
    %===== Misclosure vector =====
    w = [w1(: , 1) ; w1(: , 2)];
    if number_images == 3
        w = [w ; w1(: , 3)];%column array
    end
    if model_id == 2
        for i = 1 : 3
            for j = 1 : length(points(:,1))
                lpsi(2 * j - 1 , i) = points(j , 16 , i);
                lpsi(2 * j ,     i) = points(j , 17 , i);
            end
        end
        dl = [lpsi(:,1) ; lpsi(:,2)] - w;
    end
%%  %===== Calculation of dx, k, v =====
    [mm , nn] = size(A' * (B * B') * A);
<<<<<<< HEAD:bndl.m
%     eig(A' * ((B * B') \ A))
    lamda = 0;%input('lamda= ');
=======
    eig(A' * ((B * B') \ A))
    lamda = input('lamda= ');
>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc:Geo3o1_3_1/bndl.m
    if model_id == 1 || model_id == 3
            Qxx =   inv(A' * ((B * B') \ A) + lamda * eye(mm , nn)); if lamda ~= 0; fprintf(fid, 'Parameter estimation: Tikhonov regularization\n\n');end
%             Qxx = pinv(A' * inv(B * B') * A); fprintf(fid, 'Parameter estimation: Moore-Penrose (pseudo) inversion\n\n');
%             Qxx = cholesky_ters(A' * inv(B * B') * A + lamda * eye(mm , nn)); fprintf(fid, 'Parameter estimation: Cholesky inversion\n\n');
%             Qxx = gauss_ters(A' * inv(B * B') * A + lamda * eye(mm , nn)); fprintf(fid, 'Parameter estimation: Gauss inversion\n\n');
%             Qxx = pivot(A' * inv(B * B') * A); fprintf(fid, 'Parameter estimation: Pivoting\n\n');
        dx  = - Qxx * A' * ((B * B') \ w);
        assignin('base','dx',dx);
        korelat = - (B * B') \ (A * dx + w);
    elseif model_id == 2
        dx = (A' * A) \ (A' * dl);
        v1 = A * dx - dl;
    end
        v1      = B' * korelat;
        for unnecessary = 1 : 1
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
        end
        
        %===== Validation of EOPs =====
%         [tsnc, kor] = par_valid(A, v1, dx, Qxx, Sc);
    
    %===== Correction of EOPs =====
    if exist('Sp', 'var') == 1
        for k = 1 : length(Sp)
            for i = 1 : number_images
                subunknwn(k , i) = unknwn(Sp(k) , i); %Selection of EOPs to be corrected.
            end
        end
        if number_images == 2
        tunknwn = [subunknwn(: , 1); subunknwn(: , 2)] + dx(1 : number_images * length(Sp)); %Correction of EOPs to be selected.
        elseif number_images == 3
            tunknwn = [subunknwn(: , 1); subunknwn(: , 2); subunknwn(: , 3)] + dx(1 : number_images * length(Sp));
        end
        %===== Corrected EOPs are reloaded into unknown vector =====
        for k = 1 : length(Sp)
            unknwn(Sp(k) , 1) = tunknwn(k);
            unknwn(Sp(k) , 2) = tunknwn(length(Sp) + k);
            if number_images == 3
                unknwn(Sp(k) , 3) = tunknwn(2 * length(Sp) + k);
            end
        end
    end
    %===== Correction of look angles =====
    if model_id == 1
        LOS = LOS + reshape(v1, [3 , 2]);
    elseif model_id == 2 || model_id == 3
        v2 = reshape(v1 , 2 * length(points(: , 1 , 1)) , number_images);
        for i = 1 : length(points(: , 1 , 1))
            for j = 1 : number_images
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
    if Sc == 0
        for i = 1 : number_images
            gcp(: , : , i) = points(: , : , i);
            icp(: , : , i) = 0;
        end
    end
    unknwn_12 = unknwn(: , 1 : 2);%Select unknown
    points_12 = est_XYZ_u(unknwn_12, LOS, gcp(: , : , 1), gcp(: , : , 2), icp(: , : , 1), icp(: , : , 2), fid, model_id);
    assignin('base','points_12',points_12)
    assignin('base','unknwn_12',unknwn_12)
    if number_images == 3
        unknwn_13 = [unknwn(: , 1) unknwn(: , 3)];%Select unknown
        points_13 = est_XYZ_u(unknwn_13, LOS, gcp(: , : , 1), gcp(: , : , 3), icp(: , : , 1), icp(: , : , 3), fid, model_id);
        assignin('base','points_13',points_13)
        assignin('base','unknwn_13',unknwn_13)
        unknwn_23 = [unknwn(: , 2) unknwn(: , 3)];%Select unknown
        points_23 = est_XYZ_u(unknwn_23, LOS, gcp(: , : , 2), gcp(: , : , 3), icp(: , : , 2), icp(: , : , 3), fid, model_id);
        assignin('base','points_23',points_23)
        assignin('base','unknwn_23',unknwn_23)
        
        %Mean values from two variances
        points(: , 13 : 15 , 1) = (points_12(: , 13 : 15 , 1) + points_13(: , 13 : 15 , 1)) / 2;
        points(: , 13 : 15 , 2) = (points_12(: , 13 : 15 , 2) + points_23(: , 13 : 15 , 1)) / 2;
        points(: , 13 : 15 , 3) = (points_13(: , 13 : 15 , 2) + points_23(: , 13 : 15 , 2)) / 2;
        
        %Calculate mean values for triplet
        for i = 1 : length(points(: , 1 , 1))
            for j = 1 : number_images
                points(i , 12 + j , 1) = sum(points(i , 12 + j , :)) / 3;
            end
        end
        points(: , : , 2) = points(: , : , 1);
        points(: , : , 3) = points(: , : , 1);
        
        [gcp_triplet(: , :), ~, ~] = fndicp(points(: , : , 1), Sc);
        
        dgcp_triplet = gcp_triplet(: , 4 : 6) - gcp_triplet(: , 13 : 15);
        
        for i = 1 : 3
            mgcp_triplet(i) = sqrt((dgcp_triplet(: , i)' * dgcp_triplet(: , i)) / length(dgcp_triplet(: , 1)));
        end
        fprintf(fid,'RMSE at GCPs after bundle adjustment for triplet set\n');
        fprintf(fid,'mX = ± %15.10f (m)\nmY = ± %15.10f (m)\nmZ = ± %15.10f (m)\n\n', mgcp_triplet);
        assignin('base', 'mgcp_triplet', mgcp_triplet)
    end
    %===== Correction of XYZ of ICPs =====
    if Sc(1) > 0
        dc = reshape(dx(number_images * length(Sp) + 1 : length(dx)), 3, length(Sc));%Export the dXYZ from dx vector 
        dc = dc';
        assignin('base','dc',dc)
        
        %Add misfits to ICP's approximate coordinates
        for  k = 1 : length(fc)
            points(fc(k) , 13 : 15 , 1) = points(fc(k) , 13 : 15 , 1) + dc(k , :);
        end
        points(: , : , 2) = points(: , : , 1);
        if number_images == 3
            points(: , : , 3) = points(: , : , 1);
        end
        
        %Estimate shift between corrected and ground-truth coordinates of ICP's
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
    
    %%===== Checking =====
    for i = 1 : number_images
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
<<<<<<< HEAD:bndl.m
pltv(points, 2)
=======
pltv(points, Sc(1), 3)
>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc:Geo3o1_3_1/bndl.m
assignin('base', 'points', points)
% ===== Clossing file =====
% fclose(fid);