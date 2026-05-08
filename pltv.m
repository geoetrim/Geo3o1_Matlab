%Plot residuals of GCPs and ICPs from stereo images
%dgcp or dicp are in pixel unit
%May differ than the older version(s)
%Process id = 0 is for direct georeferencing accuracy with raw look angles and EOPs
%Process id = 1 is for pre-adjustment
%Process id = 2 is for bundle adjustment
%Recoded by Prof. Dr. Hüseyin Topan, Jan 2022, ZBEÜ, Zonguldak

function pltv(points, process_id)

gsd           = evalin('base','gsd');
number_images = evalin('base','number_images');
sensor_name   = evalin('base','sensor_name');
divider = 10; %i.e. the image column is divided by 10
if strcmp(sensor_name, 'S6_SENSOR') == 1; divider = 40; end
formatSpec = '%.2f'; %Define decimals in scale plotting

%% Assigning coordinate difference
if process_id == 0
    gcp  = points;
elseif process_id > 0 %if ICPs are existing
    Sc = evalin('base', 'Sc');
    [gcp, icp, ~] = fndicp(points(: , : , 1), Sc);
end
if process_id == 0
    dgcp = evalin('base','dp_direct');
elseif process_id == 1
    dgcp = evalin('base','dgcp_pre');
    dicp = evalin('base','dicp_pre');
elseif process_id == 2
    if number_images == 2
        dgcp = evalin('base','dgcp_bundle');
    elseif number_images == 3
        dgcp = evalin('base','dgcp_triplet');
    end
    dicp = evalin('base','dicp');
end
    
%% Define scale(s) w.r.t. processes
column_size = evalin('base','column_size');
row_size    = evalin('base','row_size');
if process_id == 0
    mgcp = evalin('base','mdg_direct');
elseif process_id == 1 %For the pre-adjustment step
    mgcp = evalin('base','mdg'); %#ok<NASGU>
    micp = evalin('base','mdi'); %#ok<NASGU>
elseif process_id == 2 %for the bundle adjustment step
    mgcp = evalin('base','mgcp'); %#ok<NASGU>
    if number_images == 3
        mgcp = evalin('base','mgcp_triplet');
    end
    micp = evalin('base','micp'); %#ok<NASGU>
end
mo_gcp    = sqrt(mgcp * mgcp'); %Estimation the 3D Euclidean distance
scale_gcp = (column_size * gsd) / (divider * mo_gcp);
assignin('base','scale_gcp',scale_gcp)

if process_id > 0
    mo_icp    = sqrt(micp * micp');
    scale_icp = (column_size * gsd) / (divider * mo_icp);
    assignin('base','scale_icp',scale_icp)
end

%% ===== Set geometric properties of 2D figure =====
figure
hold on
box on
set(gca,'XGrid','off','YGrid','off');                                                                                                                                                                            
set(gca,'XDir','normal','YDir','reverse');
set(gca,'XColor','black','YColor','black');
set(gca,'FontSize',14);
set(gca,'DataAspectRatio',[1 1 1]);
xlabel('column (pixel)','FontSize',16);
ylabel('row (pixel)','FontSize',16);

%% ===== Vector plotting =====
if process_id == 0
    title('Residuals for direct georeferencing');
elseif process_id == 1
    title('Residuals for pre-adjustment');
elseif process_id == 2
    title('Residuals for bundle adjustment');
end

%% ===== Plotting for GCPs =====
% ===== Plotting in planimetry =====
hndl1 = quiver(gcp(:, 3, 1), gcp(:, 2, 1), scale_gcp * dgcp(:, 1), scale_gcp * dgcp(:, 2), 0, 'o');
set(hndl1,'MarkerSize',3);
set(hndl1,'Color','black');
set(hndl1,'LineWidth',1.5);
% ===== Plotting in height =====
hndl2 = quiver(gcp(:, 3, 1), gcp(:, 2, 1), 0   * dgcp(:, 1), scale_gcp * dgcp(:, 3), 0, 'o');
set(hndl2,'MarkerSize',3);
set(hndl2,'Color','black');
set(hndl2,'LineWidth',1.5);
%===== Scale plotting =====
hndl4 = quiver(row_size / divider, row_size / divider, column_size / divider, 0, 0, 'o');
set(hndl4,'LineWidth',1.5);
set(hndl4,'MarkerSize',1.5);
set(hndl4,'Color','black');
text(4 * row_size / divider, row_size / divider, num2str(mo_gcp), 'FontSize',15);
hold on
%% ===== Plotting for ICPs =====
if process_id > 0
    % ===== Plotting in planimetry ===== 
    hndl6 = quiver(icp(:, 3), icp(:, 2), scale_icp * dicp(:, 1), scale_icp * dicp(:, 2), 0, 'o');
    set(hndl6,'MarkerSize',5);
    set(hndl6,'Color','black');
    set(hndl6,'LineWidth',1.5);
    % ===== Plotting in height ===== 
    hndl7 = quiver(icp(:, 3), icp(:, 2), 0   * dicp(:, 1), scale_icp * dicp(:, 3), 0, 'o');
    set(hndl7,'MarkerSize',7);
    set(hndl7,'Color','black');
    set(hndl7,'LineWidth',1.5);
    %===== Scale plotting =====
    hndl8 = quiver(row_size / divider, row_size / divider, column_size / divider, 0, 0, 'o');
    set(hndl8,'LineWidth',1.5);
    set(hndl8,'MarkerSize',1.5);
    set(hndl8,'Color','black');
    text(4 * row_size / divider, 2 * row_size / divider, num2str(mo_icp, formatSpec), 'FontSize',15);
end