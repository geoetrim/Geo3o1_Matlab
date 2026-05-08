%Plot residuals of GCPs and ICPs from stereo images
%dgcp or dicp are in metric unit
%Process id = 0 is for direct georeferencing accuracy with raw look angles and EOPs
%Process id = 1 is for pre-adjustment
%Process id = 2 is for bundle adjustment
%Recoded by Prof. Dr. Hüseyin Topan, March 2026, BEÜN, Zonguldak

function pltv3d(points, process_id)

number_images = evalin('base','number_images');
sensor_name   = evalin('base','sensor_name');
divider = 10; %i.e. the figure column is divided by 10
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
    sqrt(diag(dicp*dicp'));%Needed to select proper ICP set.
elseif process_id == 2
    if number_images == 2
        dgcp = evalin('base','dgcp_bundle');
    elseif number_images == 3
        dgcp = evalin('base','dgcp_triplet');
    end
    dicp = evalin('base','dicp_bundle');
    sqrt(diag(dicp*dicp'));%Needed to select proper ICP set.
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
scale_gcp = (max(points(: , 4 , 1)) - min(points(: , 4 , 1))) / (divider * mo_gcp);

if process_id > 0
    mo_icp    = sqrt(micp * micp');
    scale_icp = (max(points(: , 4 , 1)) - min(points(: , 4 , 1))) / (divider * mo_icp);
end

%% ===== Set geometric properties of 3D figure =====
figure
hold on
box on
set(gca,'XGrid','off','YGrid','off','YGrid','off');                                                                                                                                                                            
set(gca,'FontSize',10);
set(gca,'DataAspectRatio',[1 1 1]);
xlabel('X (meter)','FontSize',10);
ylabel('Y (meter)','FontSize',10);
zlabel('Z (meter)','FontSize',10);
campos([4201909.74520472 2649589.259366621 4271549.533181506]);

%% ===== Vector plotting =====
if process_id == 0
    title('Residuals for direct georeferencing');
elseif process_id == 1
    title('Residuals for pre-adjustment');
elseif process_id == 2
    title('Residuals for bundle adjustment');
end

%% ===== Plotting for GCPs =====
hndl1 = quiver3(gcp(:, 13, 1), gcp(:, 14, 1), gcp(:, 15, 1), scale_gcp * dgcp(:, 1), scale_gcp * dgcp(:, 2), scale_gcp * dgcp(:, 3), 0, 'o');
set(hndl1,'MarkerSize',3);
set(hndl1,'Color','black');
set(hndl1,'LineWidth',1.5);
%===== Scale plotting =====
hndl2 = quiver3(max(points(: , 4 , 1)), min(points(: , 5 , 1)), max(points(: , 6 , 1)), (max(points(: , 4 , 1)) - min(points(: , 4 , 1))) / divider, 0, 0, 0, 'o');
set(hndl2,'LineWidth',1.5);
set(hndl2,'MarkerSize',1.5);
set(hndl2,'Color','black');
text(max(points(: , 4 , 1)) - 500, min(points(: , 5 , 1)), max(points(: , 6 , 1)), num2str(mo_gcp), 'FontSize', 10);
% %===== GCP ID =====
% gcp_id = int2str(gcp(:, 1, 1));
% for i = 1 : length(gcp(:, 1, 1))
%     text(gcp(i , 13) + 50, gcp(i , 14) + 50, gcp(i , 15) + 50, gcp_id(i , :),'FontSize',7.5);
% end

hold on
%% ===== Plotting for ICPs =====
if process_id > 0
    hndl3 = quiver3(icp(: , 13), icp(: , 14), icp(: , 15), scale_icp * dicp(: , 1), scale_icp * dicp(: , 2), scale_icp * dicp(: , 3), 0, 'o');
    set(hndl3,'MarkerSize',5);
    set(hndl3,'Color','black');
    set(hndl3,'LineWidth',1.5);
    text(max(points(: , 4 , 1)) - 500, min(points(: , 5 , 1)), max(points(: , 6 , 1)) - 500, num2str(mo_icp, formatSpec), 'FontSize', 10);
    %===== ICP ID =====
%     icp_id = int2str(icp(:, 1, 1));
%     for i = 1 : length(icp(:, 1, 1))
%         text(icp(i , 13) + 50, icp(i , 14) + 50, icp(i , 15) + 50, icp_id(i , :),'FontSize',7.5);
%     end
end

% Plotting for the 3D graphics in other formats
% fig2u3d(gcf);