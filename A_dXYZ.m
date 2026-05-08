% Sub-design matrix related to d(XYZ) of check points
% Calculates A matrix for all points, and re-arranges it for selected check points
%
% Please check the version of the desing matrix (dm).
% Recoded by Hüseyin TOPAN (ZKÜ), April 2023.

function AXYZ = A_dXYZ(unknwn, points, fc, mdl)

sensor_id = evalin('base','sensor_id');

for i = 1 : length(points(: , 1))
    
%===== Sub-design matrix related to d(XYZ) of all points =====
if sensor_id == 1 || sensor_id == 3
    if mdl == 1
        AXYZ1 = Jacobian_XYZ_1(unknwn, points(i, :));
    elseif mdl == 3
        AXYZ1 = Jacobian_XYZ_3(unknwn, points(i, :));
    end
elseif sensor_id == 2
    AXYZ1 = Jacobian_XYZ_3_SPOT(unknwn, points(i, :));
end
    
    AXYZ2(2*i-1, 3*i-2) = AXYZ1(1, 1);
    AXYZ2(2*i-1, 3*i-1) = AXYZ1(1, 2);
    AXYZ2(2*i-1, 3*i  ) = AXYZ1(1, 3);
    
    AXYZ2(2*i, 3*i-2)   = AXYZ1(2, 1);
    AXYZ2(2*i, 3*i-1)   = AXYZ1(2, 2);
    AXYZ2(2*i, 3*i  )   = AXYZ1(2, 3);
end

%===== Re-arrangement AXYZ matrix for selected check points =====
for i = 1 : length(fc)
    AXYZ(:, 3*i-2) = AXYZ2(:, 3*fc(i)-2);
    AXYZ(:, 3*i-1) = AXYZ2(:, 3*fc(i)-1);
    AXYZ(:, 3*i  ) = AXYZ2(:, 3*fc(i)  ); 
end