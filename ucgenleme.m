% clear; clc; close all;
gcp_deneme = load('gcp_deneme.m');
icp_deneme = load('icp_deneme.m');
gcp_deneme(: , 18) = 0;
icp_deneme(: , 18) = 0;
Sip = [1 3 14 17:19 25 28 30:32 37 43 51 55 59 61 62 63 68 74 78 80 83 89 91 93 94 97 104 106 114 117 122:124 134 141 143 146 167 168 176 178 195 246 247 249 251 252 255 259 272 274:276 293 2591 ];
for i = 1 : length(Sip)
    gcp_deneme(gcp_deneme(: , 1) == Sip(i), :) = [];
    icp_deneme(icp_deneme(: , 1) == Sip(i), :) = [];
end

figure('Color', 'white')
t = delaunay(gcp_deneme(: , 3 , 1), gcp_deneme (: , 2 , 1));

hold on

% trimesh(t , gcp_deneme(: , 3 , 1), gcp_deneme(: , 2 , 1)), zeros(size(gcp_deneme(: , 2 , 1) , 1), 'EdgeColor','r', 'FaceColor','none')
defaultFaceColor  = [0.6875 0.8750 0.8984];
trisurf(t , gcp_deneme(: , 3 , 1), gcp_deneme(: , 2 , 1), gcp_deneme(: , 18 , 1), 'FaceColor', defaultFaceColor, 'FaceAlpha',0.9);
plot3(gcp_deneme(: , 3 , 1), gcp_deneme(: , 2 , 1), gcp_deneme(: , 18 , 1), '.r')
% axis([-4, 4, -4, 4, 0, 25]);
set(gca,'XDir','normal','YDir','reverse');
set(gca,'DataAspectRatio',[1 1 1]);
grid
hold on; plot3(icp_deneme(: , 3 , 1), icp_deneme(: , 2 , 1), icp_deneme(: , 18 , 1), '*')

gcp_id = int2str(gcp_deneme(: , 1 , 1));
icp_id = int2str(icp_deneme(: , 1 , 1));
for i = 1 : length(gcp_deneme(:, 1 , 1))
    text(gcp_deneme(i , 3 , 1), gcp_deneme(i , 2 , 1), gcp_id(i , :),'FontSize',7.5);
end
for i = 1 : length(icp_deneme(:, 1 , 1))
    text(icp_deneme(i , 3 , 1), icp_deneme(i , 2 , 1), icp_id(i , :),'FontSize',7.5);
end

% plot3(-2.6,-2.6,0,'*b','LineWidth', 1.6)
% plot3([-2.6 -2.6]',[-2.6 -2.6]',[0 13.52]','-b','LineWidth',1.6)
% hold off
% 
% view(322.5, 30);
% 
% text(-2.0, -2.6, 'Xq', 'FontWeight', 'bold', ...
% 'HorizontalAlignment','center', 'BackgroundColor', 'none');