% Estimation of approximate ground coordinates for control/check/tie points via direct georeferencing.

function points = est_XYZ(points, LOS, process_id, model_id)

fid = evalin('base', 'fid');

for i = 1 : length(points(: , 1 , 1));
    
    for j = 1 : 2
        VisPter(: , j) = app_VisPter(points(i , : , j) , j, LOS(: , j), model_id);
    end
    
    A = [ - VisPter(: , 1), VisPter(: , 2)];
    
    b = points(i , 10 : 12 , 2)' - points(i , 10 : 12 , 1)';
    
    m = inv(A' * A) * A' * b;
    
    points(i, 13 : 15 , 1) = ((points(i , 10 : 12 , 1) - m(1) * VisPter(: , 1)') + (points(i , 10 : 12 , 2) - m(2) * VisPter(: , 2)')) / 2;
end

points(: , 13 : 15 , 2) = points(: , 13 : 15 , 1);

dp = points(: , 4 : 6 , 1) - points(: , 13 : 15 , 1);

for i = 1 : 3
    mdg(i) = sqrt((dp(: , i)' * dp(: , i)) / length(dp(: , 1)));
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