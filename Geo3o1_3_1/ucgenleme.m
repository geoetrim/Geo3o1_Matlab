figure('Color', 'white')
t = delaunay(gcp_deneme(: , 3 , 1), gcp_deneme (: , 2 , 1));

hold on

% trimesh(t , gcp_deneme(: , 3 , 1), gcp_deneme(: , 2 , 1)), zeros(size(gcp_deneme(: , 2 , 1) , 1), 'EdgeColor','r', 'FaceColor','none')
defaultFaceColor  = [0.6875 0.8750 0.8984];
trisurf(t , gcp_deneme(: , 3 , 1), gcp_deneme(: , 2 , 1), gcp_deneme(: , 18 , 1), 'FaceColor', defaultFaceColor, 'FaceAlpha',0.9);
plot3(gcp_deneme(: , 3 , 1), gcp_deneme(: , 2 , 1), gcp_deneme(: , 18 , 1), '.r')
% axis([-4, 4, -4, 4, 0, 25]);
set(gca,'XDir','normal','YDir','reverse');
grid
hold on; plot3(icp_deneme(: , 3 , 1), icp_deneme(: , 2 , 1), icp_deneme(: , 18 , 1), '*')
% plot3(-2.6,-2.6,0,'*b','LineWidth', 1.6)
% plot3([-2.6 -2.6]',[-2.6 -2.6]',[0 13.52]','-b','LineWidth',1.6)
% hold off
% 
% view(322.5, 30);
% 
% text(-2.0, -2.6, 'Xq', 'FontWeight', 'bold', ...
% 'HorizontalAlignment','center', 'BackgroundColor', 'none');