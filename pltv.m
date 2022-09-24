%Plot residuals of GCPs and ICPs from stereo images
%dgcp or dicp are in pixel unit
%May differ than the older version(s)
%Recoded by Prof. Dr. Hüseyin Topan, Jan 2022, ZBEÜ, Zonguldak

function pltv(points, process_id)

gsd = evalin('base','gsd');
number_images = evalin('base','number_images');
divider = 10; %i.e. the image column is divided by 10
formatSpec = '%.2f'; %Define decimals in scale plotting

%% Estimate coordinate difference
if process_id == 0
    gcp = points;
    dgcp = points(: , 4 : 6) - points(: , 13 : 15);
elseif process_id > 0 %if ICPs are existing
    Sc = evalin('base', 'Sc');
    [gcp, icp, ~] = fndicp(points(: , : , 1), Sc);
    if process_id == 1
        dgcp = gcp(: , 4 : 6) - gcp(: , 13 : 15);
        dicp = icp(: , 4 : 6) - icp(: , 13 : 15);
    elseif process_id == 2
        dgcp = evalin('base','dgcp');%Normalde buna gerek kalmamasý, demet dengeleme sonrasýnda yukarýdakinde olduðu gibi YKN/BDN farklarýnýn nokta dosyasýndan okunup hesaplanmasý gerekiyor. Ama her nedense demet dengeleme sonunda çizim yaparken ön dengeleme sonrasý oluþan farklarý çizdiriyor. Þimdilik bu geçici çözüm uygulanmýþtýr. (23.09.2022)
        dicp = evalin('base','dicp');
    end
end
%% Define scale(s) w.r.t. processes
column_size = evalin('base','column_size');
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

if process_id > 0
    mo_icp    = sqrt(micp * micp');
    scale_icp = (column_size * gsd) / (divider * mo_icp);
end

%% ===== Set geometric properties of figure =====
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
    title('Residuals of estimated XYZ from raw EOPs and LOS angles');
elseif process_id == 1
    title('Residuals of estimated XYZ from stereo image with adjusted look angles at GCPs and ICPs');
elseif process_id == 2
    title('Residuals at GCPs and ICPs after bundle adjustment');
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
hndl4 = quiver(column_size / divider, column_size / divider, column_size / divider, 0, 0, 'o');
set(hndl4,'LineWidth',1.5);
set(hndl4,'MarkerSize',1.5);
set(hndl4,'Color','black');
% text(2 * (column_size * gsd) / divider + scale_gcp * mo_gcp, (column_size * gsd) / divider, num2str(mo_gcp), 'FontSize',15);
text(2.5 * column_size / divider, column_size / divider, num2str(mo_gcp), 'FontSize',15);
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
    hndl8 = quiver(column_size / divider, column_size / divider, column_size / divider, 0, 0, 'o');
    set(hndl8,'LineWidth',1.5);
    set(hndl8,'MarkerSize',1.5);
    set(hndl8,'Color','black');
    text(2.5 * column_size / divider, 2 * column_size / divider, num2str(mo_icp, formatSpec), 'FontSize',15);
end