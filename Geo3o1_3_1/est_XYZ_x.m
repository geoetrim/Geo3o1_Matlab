% Estimation of approximate ground coordinates for control/check/tie points via direct georeferencing.

function points = est_XYZ(points, LOS, process_id, model_id)

fid = evalin('base', 'fid');
number_images = evalin('base', 'number_images');

%Stereo combination
s_c = [1 2; 1 3; 2 3];
if number_images == 2;
    s_c = [1 2];
end

for i = 1 : length(points(: , 1 , 1));
    for j = 1 : number_images
        VisPter(: , j) = app_VisPter(points(i , : , j) , j, LOS(: , j), model_id);
    end
    
%     A = [ - VisPter(: , 1), VisPter(: , 2)];
%     b = points(i , 10 : 12 , 2)' - points(i , 10 : 12 , 1)';
%     m = (A' * A) \ (A' * b);
%     points(i, 13 : 15 , 1) = ((points(i , 10 : 12 , 1) - m(1) * VisPter(: , 1)') + (points(i , 10 : 12 , 2) - m(2) * VisPter(: , 2)')) / 2;

    for k = 1 : length(s_c(: , 1))
        A = [ - VisPter(: , s_c(k , 1)), VisPter(: , s_c(k , 2))];
        b = points(i , 10 : 12 , s_c(k , 2))' - points(i , 10 : 12 , s_c(k , 1))';
        m = (A' * A) \ (A' * b);
        points(i, 13 : 15 , k) = ((points(i , 10 : 12 , s_c(k , 1)) - m(1) * VisPter(: , s_c(k , 1))') + (points(i , 10 : 12 , s_c(k , 2)) - m(2) * VisPter(: , s_c(k , 2))')) / 2;
    end
end
for k = 1 : length(s_c(: , 1))
    dp = points(: , 4 : 6 , k) - points(: , 13 : 15 , k);
    
    for i = 1 : 3
        mdg(k , i) = sqrt((dp(: , i)' * dp(: , i)) / length(dp(: , 1)));
    end
end

if process_id == 1
    assignin('base','mdg',mdg)
elseif process_id == 2
    assignin('base','mdi',mdg)
end

if process_id == 0
    fprintf(fid,'RMSE of all points via direct georeferencing\n');
elseif process_id == 1
    fprintf(fid,'RMSE of GCPs via direct georeferencing following pre-adjustment\n');
elseif process_id == 2
    fprintf(fid,'RMSE of ICPs via direct georeferencing following pre-adjustment\n');
end
fprintf(fid,'mX = ± %15.10f (m)\nmY = ± %15.10f (m)\nmZ = ± %15.10f (m)\n\n', mdg);
fprintf(fid,'----------------------------------------------\n\n');

assignin('base', 'fid', fid);