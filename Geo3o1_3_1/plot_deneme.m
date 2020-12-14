j = 0;
olc = 500;
gcp = evalin('base','t');
dg = gcp(:, 4:6);

p = 0.5;
dg = dg / p;

hold on
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
set(hndl1,'MarkerSize',3);
set(hndl1,'Color','black');
set(hndl1,'LineWidth',1.5);

hndl2 = quiver(gcp(:, 3), gcp(:, 2), 0   * dg(:, 1), olc * dg(:, 3), 0, 'o');
set(hndl2,'MarkerSize',3);
set(hndl2,'Color','black');
set(hndl2,'LineWidth',1.5);