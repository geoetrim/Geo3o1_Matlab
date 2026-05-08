clear; clc; close all; format longEng;
display(' Geo3o1: 3D georeferencing of tri-stereo images (BEUN, 2026)')
%Recoded and modified in Zonguldak Bülent Ecevit University, Jan 2026, Zonguldak, Turkey
%References: Pléiades, SPOT 6 & SPOT 7, Pléiades Neo Imagery User Guide(s)
%For more information: topan@beun.edu.tr, htopan@yahoo.com, geoetrim@gmail.com
%More info: www.github.com/geoetrim
%Run pltv3d.ipynb to plot 3D graphics in HTML 

report_file

number_images = input('\n Stereo  : 2 \n Triplet : 3 \n\n Choice  : '); assignin('base','number_images', number_images);

display('===== Loading data =====')
for i = 1 : number_images
    loading(i)
end
display('===== Preprocessing =====')
for i = 1 : number_images
    prepro(i);
end
display('===== Bundle Adjustment =====')
bndl
open('cikis.txt')
save('Geo3o1.mat');