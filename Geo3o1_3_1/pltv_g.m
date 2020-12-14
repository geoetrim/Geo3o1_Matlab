%Plot residuals of GCPs from stereo images
%Recoded bu Hüseyin Topan, BEÜ, March 2016
%dg in pixel unit

function pltv_g(gcp, j)

figure
hold on

olc = 100;

dg = gcp(: , 4 : 6 , 1) - gcp(: , 13 : 15 , 1);

assignin('base','dg',dg);

% m --> pixel
p = 0.5;
dg = dg / p;

box on
set(gca,'XGrid','off','YGrid','off');                                                                                                                                                                            
set(gca,'XDir','normal','YDir','reverse');
set(gca,'XColor','black','YColor','black');
set(gca,'FontSize',14);
set(gca,'DataAspectRatio',[1 1 1]);

if j == 0
    title('Residuals of estimated XYZ from stereo image with raw look angles and EOPs at GCPs');
elseif j == 1
    title('Residuals of estimated XYZ from stereo image with adjusted look angles at GCPs');
elseif j == 2
    title('Residuals of estimated XYZ from stereo image with adjusted look angles and parameters at GCPs');
elseif j == 3
    title('Residuals at GCPs after bundle adjustment');
end

xlabel('c (pixel)','FontSize',16);
ylabel('r (pixel)','FontSize',16);

% ylim([0 12000]);
% xlim([0 12000]);

%===== Plotting for GCPs =====
hndl1 = quiver(gcp(:, 3), gcp(:, 2), olc * dg(:, 1), olc * dg(:, 2), 0, 'o');
set(hndl1,'MarkerSize',1.5);
set(hndl1,'Color','black');
set(hndl1,'LineWidth',1.5);

hndl2 = quiver(gcp(:, 3), gcp(:, 2), 0   * dg(:, 1), olc * dg(:, 3), 0, 'o');
set(hndl2,'MarkerSize',1.5);
set(hndl2,'Color','black');
set(hndl2,'LineWidth',1.5);

hndl3 = quiver(5000, 5000, olc * 20, 0, 0, 'o');
set(hndl3,'LineWidth',1.5);
set(hndl3,'MarkerSize',1.5);
set(hndl3,'Color','black');
text(6000 + olc * 20, 5000,' 10 m', 'FontSize',15);