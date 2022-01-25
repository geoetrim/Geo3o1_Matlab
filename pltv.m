<<<<<<< HEAD
%Plot residuals of GCPs and ICPs from stereo images
%dgcp or dicp are in pixel unit
%May differ than the older version(s)
%Recoded by Prof. Dr. Hüseyin Topan, Jan 2022, ZBEÜ, Zonguldak

function pltv(points, process_id)

gsd = evalin('base','gsd');
divider = 10; %i.e. the image column is divided by 10
formatSpec = '%.2f'; %Define decimals in scale plotting

%% Estimate coordinate difference
if process_id == 0
    gcp = points;
    dgcp = points(: , 4 : 6) - points(: , 13 : 15);
else %if ICPs are existing
    Sc = evalin('base', 'Sc');
    [gcp, icp, ~] = fndicp(points(: , : , 1), Sc);
    dgcp = gcp(: , 4 : 6) - gcp(: , 13 : 15);
    dicp = icp(: , 4 : 6) - icp(: , 13 : 15);
end

%% Define scale(s)
column_size = evalin('base','column_size');
if process_id == 0
    mgcp = evalin('base','mdg_direct');
elseif process_id == 1 %For the pre-adjustment step
    mgcp = evalin('base','mdg'); %#ok<NASGU>
    micp = evalin('base','mdi'); %#ok<NASGU>
elseif process_id == 2 %for the bundle adjustment step
    mgcp = evalin('base','mgcp'); %#ok<NASGU>
    micp = evalin('base','micp'); %#ok<NASGU>
end
mo_gcp    = sqrt(mgcp * mgcp');
scale_gcp = (column_size * gsd) / (divider * mo_gcp);
if process_id == 2
    scale_gcp = scale_gcp * 1e2;
end
if process_id > 0
    mo_icp    = sqrt(micp * micp');
    scale_icp = (column_size * gsd) / (divider * mo_icp);
end

%% ===== Set geometric properties of figure =====
=======
<<<<<<< HEAD:pltv_dene.m
%Plot residuals of GCPs and ICPs from stereo images
%dgcp or dicp are in pixel unit
%May differ than the older version(s)
%Recoded by Hüseyin Topan, November 2017, BEÜ, Zonguldak

function pltv(gcp, icp, j)

p = 0.5; %1 pixel = 50 cm for Pléiades primary panchromatic images

%% Estimate coordinate difference in pixel unit
if icp ~= 0
    Sc = evalin('base', 'Sc');
    [gcp1, icp1, fc] = fndicp(gcp(: , : , 1), Sc);
    gcp = [];
    gcp = gcp1;
    dgcp = (gcp1(: , 4 : 6) - gcp1(: , 13 : 15)) / p; % Difference in pixel unit
    dicp = (icp1(: , 4 : 6) - icp1(: , 13 : 15)) / p; % Difference in pixel unit
else
    dgcp = (gcp(: , 4 : 6) - gcp(: , 13 : 15)) / p;
end

%% Define scale(s)
scale_gcp = 1e5;
if icp ~=0
    if j == 1 %For the pre-adjustment step
        mgcp = evalin('base', 'mdg'); %#ok<NASGU>
        micp = evalin('base', 'mdi'); %#ok<NASGU>
    elseif j == 3 %for the bundle adjustment step
        mgcp = evalin('base', 'mgcp'); %#ok<NASGU>
        micp = evalin('base', 'micp'); %#ok<NASGU>
    end
    scale_icp = scale_gcp / (sqrt(micp * micp') / sqrt(mgcp * mgcp'));
    assignin('base' , 'scale_icp', (scale_icp / p) / 1e3)
end

>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc
figure
hold on
box on
set(gca,'XGrid','off','YGrid','off');                                                                                                                                                                            
set(gca,'XDir','normal','YDir','reverse');
set(gca,'XColor','black','YColor','black');
set(gca,'FontSize',14);
set(gca,'DataAspectRatio',[1 1 1]);
<<<<<<< HEAD
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
=======

if j == 0
    title('Residuals of estimated XYZ from raw EOPs and LOS angles');
elseif j == 1
    title('Residuals of estimated XYZ from stereo image with adjusted look angles at GCPs and ICPs');
elseif j == 2
    title('Residuals of estimated XYZ from stereo image with adjusted look angles and EOPs at GCPs and ICPs');
elseif j == 3
    title('Residuals at GCPs and ICPs after bundle adjustment');
end

xlabel('c (pixel)','FontSize',16);
ylabel('r (pixel)','FontSize',16);

% ylim([0 12000]);
% xlim([0 12000]);

%===== Plotting for GCPs =====
>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc
hndl1 = quiver(gcp(:, 3, 1), gcp(:, 2, 1), scale_gcp * dgcp(:, 1), scale_gcp * dgcp(:, 2), 0, 'o');
set(hndl1,'MarkerSize',3);
set(hndl1,'Color','black');
set(hndl1,'LineWidth',1.5);
<<<<<<< HEAD
% ===== Plotting in height =====
=======

>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc
hndl2 = quiver(gcp(:, 3, 1), gcp(:, 2, 1), 0   * dgcp(:, 1), scale_gcp * dgcp(:, 3), 0, 'o');
set(hndl2,'MarkerSize',3);
set(hndl2,'Color','black');
set(hndl2,'LineWidth',1.5);
<<<<<<< HEAD
%===== Scale plotting =====
if process_id == 2 %Scale for GCPs is multiplied by 1e2
    multiplier = 1e2;
else multiplier = 1;
end
hndl4 = quiver((column_size * gsd) / divider, (column_size * gsd) / divider, (scale_gcp / multiplier) * mo_gcp, 0, 0, 'o');
set(hndl4,'LineWidth',1.5);
set(hndl4,'MarkerSize',1.5);
set(hndl4,'Color','black');
text(2 * (column_size * gsd) / divider + (scale_gcp / multiplier) * mo_gcp, (column_size * gsd) / divider, num2str(mo_gcp), 'FontSize',15);
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
    hndl8 = quiver((column_size * gsd) / divider, (column_size * gsd) / divider, scale_icp * mo_icp, 0, 0, 'o');
    set(hndl8,'LineWidth',1.5);
    set(hndl8,'MarkerSize',1.5);
    set(hndl8,'Color','black');
    text(2 * (column_size * gsd) / divider + scale_icp * mo_icp, 3 * (column_size * gsd) / divider, num2str(mo_icp, formatSpec), 'FontSize',15);
end
=======

%===== Scale plotting =====
hndl5 = quiver(2500, 2500,   (scale_gcp / p) / 1e3, 0, 0, 'o');
set(hndl5,'LineWidth',1.5);
set(hndl5,'MarkerSize',1.5);
set(hndl5,'Color','black');
text(2500 +  (scale_gcp / p) / 1e3, 2500,' 0.5 mm', 'FontSize',15);

hold on

if icp ~= 0
    %===== Plotting for ICPs =====
    hndl3 = quiver(icp1(:, 3), icp1(:, 2), scale_icp * dicp(:, 1), scale_icp * dicp(:, 2), 0, 'o');
    set(hndl3,'MarkerSize',5);
    set(hndl3,'Color','black');
    set(hndl3,'LineWidth',1.5);

    hndl4 = quiver(icp1(:, 3), icp1(:, 2), 0   * dicp(:, 1), scale_icp * dicp(:, 3), 0, 'o');
    set(hndl4,'MarkerSize',7);
    set(hndl4,'Color','black');
    set(hndl4,'LineWidth',1.5);
    
%     hndl6 = quiver(2500, 5000,  scale_icp / p, 0, 0, 'o');
%     set(hndl6,'LineWidth',1.5);
%     set(hndl6,'MarkerSize',6);
%     set(hndl6,'Color','black');
%     text(600 +  scale_icp / p, 5000,' 50 m for ICPs', 'FontSize',15);
end

gcp_id = int2str(gcp(: , 1));
icp_id = int2str(icp(: , 1));

for i = 1 : length(gcp(:,1))
    text(gcp(i , 3), gcp(i , 2), gcp_id(i , :),'FontSize',7.5);
end
% for i = 1 : length(icp(:,1))
%     text(icp1(i , 3), icp1(i , 2), icp_id(i , :),'FontSize',7.5);
% end
=======
%Plot residuals of GCPs and ICPs from stereo images
%dgcp or dicp are in pixel unit
%May differ than the older version(s)
%Recoded by Hüseyin Topan, November 2017, BEÜ, Zonguldak

function pltv(gcp, icp, j)

p = 0.5; %1 pixel = 50 cm for Pléiades primary panchromatic images

%% Estimate coordinate difference in pixel unit
if icp ~= 0
    Sc = evalin('base', 'Sc');
    [gcp1, icp1, fc] = fndicp(gcp(: , : , 1), Sc);
    gcp = [];
    gcp = gcp1;
    dgcp = (gcp1(: , 4 : 6) - gcp1(: , 13 : 15)) / p; % Difference in pixel unit
    dicp = (icp1(: , 4 : 6) - icp1(: , 13 : 15)) / p; % Difference in pixel unit
else
    dgcp = (gcp(: , 4 : 6) - gcp(: , 13 : 15)) / p;
end

%% Define scale(s)
scale_gcp = 2e6;
if icp ~=0
    if j == 1 %For the pre-adjustment step
        mgcp = evalin('base', 'mdg'); %#ok<NASGU>
        micp = evalin('base', 'mdi'); %#ok<NASGU>
    elseif j == 3 %for the bundle adjustment step
        mgcp = evalin('base', 'mgcp'); %#ok<NASGU>
        micp = evalin('base', 'micp'); %#ok<NASGU>
    end
    scale_icp = scale_gcp / (sqrt(micp * micp') / sqrt(mgcp * mgcp'));
    assignin('base' , 'scale_icp', (scale_icp / p) / 1e3)
end

figure
hold on
box on
set(gca,'XGrid','off','YGrid','off');                                                                                                                                                                            
set(gca,'XDir','normal','YDir','reverse');
set(gca,'XColor','black','YColor','black');
set(gca,'FontSize',14);
set(gca,'DataAspectRatio',[1 1 1]);

if j == 0
    title('Residuals of estimated XYZ from raw EOPs and LOS angles');
elseif j == 1
    title('Residuals of estimated XYZ from stereo image with adjusted look angles at GCPs and ICPs');
elseif j == 2
    title('Residuals of estimated XYZ from stereo image with adjusted look angles and EOPs at GCPs and ICPs');
elseif j == 3
    title('Residuals at GCPs and ICPs after bundle adjustment');
end

xlabel('c (pixel)','FontSize',16);
ylabel('r (pixel)','FontSize',16);

% ylim([0 12000]);
% xlim([0 12000]);

%===== Plotting for GCPs =====
hndl1 = quiver(gcp(:, 3, 1), gcp(:, 2, 1), scale_gcp * dgcp(:, 1), scale_gcp * dgcp(:, 2), 0, 'o');
set(hndl1,'MarkerSize',3);
set(hndl1,'Color','black');
set(hndl1,'LineWidth',1.5);

hndl2 = quiver(gcp(:, 3, 1), gcp(:, 2, 1), 0   * dgcp(:, 1), scale_gcp * dgcp(:, 3), 0, 'o');
set(hndl2,'MarkerSize',3);
set(hndl2,'Color','black');
set(hndl2,'LineWidth',1.5);

%===== Scale plotting =====
hndl5 = quiver(2500, 2500,   (scale_gcp / p) / 1e3, 0, 0, 'o');
set(hndl5,'LineWidth',1.5);
set(hndl5,'MarkerSize',1.5);
set(hndl5,'Color','black');
text(2500 +  (scale_gcp / p) / 1e3, 2500,' 0.5 mm', 'FontSize',15);

hold on

if icp ~= 0
    %===== Plotting for ICPs =====
    hndl3 = quiver(icp1(:, 3), icp1(:, 2), scale_icp * dicp(:, 1), scale_icp * dicp(:, 2), 0, 'o');
    set(hndl3,'MarkerSize',5);
    set(hndl3,'Color','black');
    set(hndl3,'LineWidth',1.5);

    hndl4 = quiver(icp1(:, 3), icp1(:, 2), 0   * dicp(:, 1), scale_icp * dicp(:, 3), 0, 'o');
    set(hndl4,'MarkerSize',7);
    set(hndl4,'Color','black');
    set(hndl4,'LineWidth',1.5);
    
%     hndl6 = quiver(2500, 5000,  scale_icp / p, 0, 0, 'o');
%     set(hndl6,'LineWidth',1.5);
%     set(hndl6,'MarkerSize',6);
%     set(hndl6,'Color','black');
%     text(600 +  scale_icp / p, 5000,' 50 m for ICPs', 'FontSize',15);
end
return
>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc:pltv.m
>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc
