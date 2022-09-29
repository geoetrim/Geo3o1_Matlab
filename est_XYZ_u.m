% Estimation of ground coordinates of GCPs via corrected EOPs and LOS.
% Coded bu Hüseyin Topan, BEÜ, December 2015.

function point = est_XYZ_u(unknwn, LOS, gcp1, gcp2, icp1, icp2, fid, model_id)

number_images = evalin('base','number_images');

% ===== Estimation of GCPs via stereo intersection =====
for i = 1 : length(gcp1(: , 1));
    
    VisPter_1 = app_VisPter_u_1(gcp1(i , :) , unknwn(: , 1), LOS(: , 1), model_id);
    
    VisPter_2 = app_VisPter_u_1(gcp2(i , :) , unknwn(: , 2), LOS(: , 2), model_id);
    
    A = [- VisPter_1, VisPter_2];
    
    Ps = est_Ps(unknwn, gcp1(i , 7), gcp2(i , 7));
    
    dPs = Ps(: , 2) - Ps(: , 1);
    
    m = (A' * A) \ (A' * dPs);                       

    gcp1(i , 13 : 15) = ((Ps(: , 1)' - m(1) * VisPter_1') + (Ps(: , 2)' - m(2) * VisPter_2')) / 2;
end

gcp2(: , 13 : 15) = gcp1(: , 13 : 15);

% ===== Estimate the difference and RMSE from the GNSS observed coordinates =====
dgcp = gcp1(: , 4 : 6) - gcp1(: , 13 : 15);
if number_images == 2
    assignin('base', 'dgcp_bundle', dgcp)
end

for i = 1 : 3
    mgcp(i) = sqrt((dgcp(: , i)' * dgcp(: , i)) / length(dgcp(: , 1)));
end
if number_images == 2
    fprintf(fid,'RMSE at GCPs after bundle adjustment\n');
end
fprintf(fid,'mX = ± %15.10f (m)\nmY = ± %15.10f (m)\nmZ = ± %15.10f (m)\n\n', mgcp);
assignin('base', 'mgcp', mgcp)

% ===== Rebuild the GCP file (GCP + ICP if exist) =====
if icp1 == 0
    point(: , : , 1) = gcp1;
    point(: , : , 2) = gcp2;
else
    point(: , : , 1) = [gcp1; icp1];
    point(: , : , 2) = [gcp2; icp2];
end

for i = 1 : 2
    point(: , : , i) = sortrows(point(: , : , i) , 1);
end

assignin('base', 'fid', fid);