clear; clc; close all; format  longEng
display('3D georeferencing of Pléiades 1A&1B and SPOT 6&7 primary and Göktürk 1 L2A stereo/triplet images')
<<<<<<< HEAD
display('by Prof. Hüseyin TOPAN, Dr. Gürsu AYTEKÝN, Mr. Ali CAM (ZBEÜ, 2021)')
=======
display('by Prof. Dr. Hüseyin TOPAN, Dr. Gürsu AYTEKÝN, Mr. Ali CAM (ZBEÜ, 2021)')
>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc
%Recoded and modified in Zonguldak Bülent Ecevit University, June 2021, Zonguldak, Turkey
%Reference: Pléiades Imagery User Guide
%For more information: topan@beun.edu.tr, htopan@yahoo.com, geoetrim@gmail.com
%More info: www.geoetrim.org

if exist('cikis.txt','var') == 1; delete('cikis.txt'); end

report_file

<<<<<<< HEAD
number_images = input('\n Stereo  : 2 \n Triplet : 3 \n\n Choice  : '); assignin('base','number_images', number_images);
=======
number_images = input(' Stereo  : 2 \n Triplet : 3 \n\n Choice  : '); assignin('base','number_images', number_images);
>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc

display('===== Loading of data =====')
for i = 1 : number_images
    loading(i)
end

display('===== Preprocessing =====')
for i = 1 : number_images
    prepro(i);
end

<<<<<<< HEAD
display('===== Bundle Adjustment =====')
bndl

% open('Point_id.fig')
=======
display('==== Bundle Adjustment ====')
bndl
>>>>>>> b5027191183716bdef6b8fd73646df287573bfdc
