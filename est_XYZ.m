% Estimation of approximate ground coordinates for control/check/tie points
% via direct georeferencing or pre-adjustment
% Process id = 0 for direct georeferencing, 
% Process id = 1 for GCPs following pre-adjustment
% Process id = 2 for ICPs following pre-adjustment
% Recoded by Hüseyin Topan, June 2021

function points = est_XYZ(points, LOS, process_id, model_id)

fid           = evalin('base', 'fid');
number_images = evalin('base','number_images');
sensor_id     = evalin('base','sensor_id');
t_center      = evalin('base','t_center');

if sensor_id == 1 || sensor_id == 3
    t_offset = evalin('base', 't_offset');
    t_scale  = evalin('base', 't_scale');
    Q = evalin('base', 'Q');
elseif sensor_id == 2
    Qn_coef = evalin('base', 'Qn_coef');
end

if process_id == 0
    %Define stereo combination for space intersection
    if number_images == 2
        sc = [1 2];
    elseif number_images == 3
        %Define the images to be used for space intersection
        space_intersection = 3; %input('Space intersection via longest-base (2) or triplet (3): ');
        assignin('base','space_intersection', space_intersection);
        if space_intersection == 2
            sc = [find(min(t_center) == t_center) find(max(t_center) == t_center)];
        elseif space_intersection == 3
            fprintf(fid, 'The longest base via %1d. and %1d. images\n\n', find(min(t_center) == t_center), find(max(t_center) == t_center));
            sc = [1 2; 1 3; 2 3];
        end
    end
    assignin('base','sc', sc)
end
if process_id > 0
    sc = evalin('base','sc');
end

%Space intersection for stereo-pair
for k = 1 : length(sc(: , 1))
    %Establishing the points files and EOPs to be used for space intersection
    for j = 1 : 2
        points_sc(: , : , j) = points(: , : , sc(k , j));
        if sensor_id == 1 || sensor_id == 3
            t_offset_sc(j)  = t_offset(sc(k , j)); assignin('base','t_offset_sc',t_offset_sc);
            t_scale_sc (j)  = t_scale (sc(k , j)); assignin('base','t_scale_sc',t_scale_sc);
            Q_sc(: , : , j) = Q(: , : , sc(k , j)); assignin('base','Q_sc',Q_sc);
        elseif sensor_id == 2
            Qn_coef_sc(: , : , j) = Qn_coef(: , : , sc(k , j)); assignin('base','Qn_coef_sc',Qn_coef_sc);
        end
    end
    assignin('base','points_sc',points_sc)
    %~XYZ estimation for each point
    for i = 1 : length(points(: , 1 , 1));
        for j = 1 : 2
            VisPter(: , j) = app_VisPter(points_sc(i , : , j) , j, LOS(: , j), model_id);
        end

        A = [ - VisPter(: , 1), VisPter(: , 2)];

        b = points_sc(i , 10 : 12 , 2)' - points_sc(i , 10 : 12 , 1)';

        m = (A' * A) \ (A' * b);

        points_est(i , 1 : 3 , k) = ((points_sc(i , 10 : 12 , 1) - m(1) * VisPter(: , 1)') + (points_sc(i , 10 : 12 , 2) - m(2) * VisPter(: , 2)')) / 2;
    end
    
    %Discrepancy between the estimated and true XYZ
    dp = points_sc(: , 4 : 6 , 1) - points_est(: , : , k);

    for i = 1 : 3
        mdg(i) = sqrt((dp(: , i)' * dp(: , i)) / length(dp(: , 1)));
    end

    if process_id == 0
        assignin('base','mdg_direct',mdg)
    elseif process_id == 1
        assignin('base','mdg',mdg)
    elseif process_id == 2
        assignin('base','mdi',mdg)
    end
    if process_id == 0
        if number_images == 2; fprintf(fid,'RMSE of all points via direct georeferencing\n');
        elseif number_images == 3 && space_intersection == 2;
            fprintf(fid,'RMSE of all points via direct georeferencing using longest-base with %1d. and %1d. images\n', min(sc), max(sc));
        elseif number_images == 3 && space_intersection == 3;
            fprintf(fid,'RMSE of all points via direct georeferencing using %1d. and %1d. images\n', sc(k , : ));
        end
    elseif process_id == 1
        if number_images == 2;
            fprintf(fid,'RMSE of GCPs following pre-adjustment\n');
        elseif number_images == 3
            space_intersection = evalin('base','space_intersection');
            if space_intersection == 2;
                fprintf(fid,'RMSE of GCPs using longest-base with %1d. and %1d. images following pre-adjustment\n', min(sc), max(sc));
            elseif number_images == 3 && space_intersection == 3;
                fprintf(fid,'RMSE of GCPs using %1d. and %1d. images following pre-adjustment\n', sc(k , : ));
            end
        end
    elseif process_id == 2
        if number_images == 2;
            fprintf(fid,'RMSE of ICPs following pre-adjustment\n');
        elseif number_images == 3
            space_intersection = evalin('base','space_intersection');
            if space_intersection == 2;
                fprintf(fid,'RMSE of ICPs using longest-base with %1d. and %1d. images following pre-adjustment\n', min(sc), max(sc));
            elseif number_images == 3 && space_intersection == 3;
                fprintf(fid,'RMSE of ICPs using %1d. and %1d. images following pre-adjustment\n', sc(k , : ));
            end
        end
    end
    fprintf(fid,'mX = ± %15.10f (m)\nmY = ± %15.10f (m)\nmZ = ± %15.10f (m)\n\n', mdg);

    assignin('base', 'fid', fid);
end

%Assigning the estimated XYZ to each image
if length(sc) == 2
    for j = 1 : 2
        points(: , 13 : 15 , j) = points_est(: , : , 1);
    end
elseif (number_images == 3) && (length(sc(: , 1)) == 3)
    %Calculate mean values for triplet
    for i = 1 : length(points(: , 1 , 1));
        for j = 1 : number_images
            points(i , 12 + j , 1) = sum(points_est(i , j , :)) / 3;
        end
    end
    %Assigning the estimated XYZ to each image
    for j = 1 : number_images 
        points(: , 13 : 15 , j) = points(: , 13 : 15 , 1);
    end
end
    
%Discrepancy between the estimated and true XYZ
dp = points(: , 4 : 6 , 1) - points(: , 13 : 15 , 1);
if process_id == 0
    assignin('base','dp_direct', dp)
elseif process_id == 1
    assignin('base','dgcp_pre', dp)
elseif process_id == 2
    assignin('base','dicp_pre', dp)
end

for i = 1 : 3
    mdg(i) = sqrt((dp(: , i)' * dp(: , i)) / length(dp(: , 1)));
end

if process_id == 1
    assignin('base','mdg',mdg)
elseif process_id == 2
    assignin('base','mdi',mdg)
end

if number_images == 3
    if process_id == 0
        fprintf(fid,'RMSE of all points via direct georeferencing using triplet set\n');
    elseif process_id == 1
        fprintf(fid,'RMSE of GCPs using triplet set following pre-adjustment\n');
    elseif process_id == 2
        fprintf(fid,'RMSE of ICPs using triplet set following pre-adjustment\n');
    end
fprintf(fid,'mX = ± %15.10f (m)\nmY = ± %15.10f (m)\nmZ = ± %15.10f (m)\n\n', mdg);
end

if process_id == 0 || process_id == 2
    fprintf(fid,'----------------------------------------------\n\n');
end
assignin('base', 'fid', fid);

if process_id == 0
    fid2 = fopen('Raw_XYZ.txt','w+');
    for i = 1 : length(points(: , 1))
        fprintf(fid2,'%15.3f %15.3f %15.3f %15.3f %15.3f %15.3f \n', points(i , 1 : 3), points(i , 13 : 15));
    end
end
