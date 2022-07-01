clear; clc; close all; format  longEng
display(' 3D georeferencing of Pl�iades 1A&1B and SPOT 6&7')
display(' primary and G�kt�rk 1 L2A stereo/triplet images')
display(' by Prof. H�seyin TOPAN & Dr. G�rsu AYTEK�N')
display(' with the contribution of Mr. Ali CAM (ZBE�, 2022)')
%Recoded and modified in Zonguldak B�lent Ecevit University, June 2021, Zonguldak, Turkey
%Reference: Pl�iades Imagery User Guide
%For more information: topan@beun.edu.tr, htopan@yahoo.com, geoetrim@gmail.com
%More info: www.geoetrim.org

if exist('cikis.txt','var') == 1; delete('cikis.txt'); end

report_file

number_images = input('\n Stereo  : 2 \n Triplet : 3 \n\n Choice  : '); assignin('base','number_images', number_images);

display('===== Loading of data =====')
for i = 1 : number_images
    loading(i)
end

display('===== Preprocessing =====')
for i = 1 : number_images
    prepro(i);
end

display('===== Bundle Adjustment =====')
bndl

% open('Point_id_Gokturk_1.fig')