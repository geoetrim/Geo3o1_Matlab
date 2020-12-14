%3D geopositioning of Pl�iades 1A&1B primary, SPOT 6&7 primary and G�kt�rk 1 L2A tri-stereo images
%Recoded and modified by Prof. H�seyin TOPAN, Dr. G�rsu AYTEK�N, Zonguldak B�lent Ecevit University, December 2020, Zonguldak, Turkey
%Reference: Pl�iades Imagery User Guide
%For more information: topan@beun.edu.tr, htopan@yahoo.com

clear; clc; close all
format  longEng
if exist('cikis.txt','var') == 1; delete('cikis.txt'); end

report_file

display('3D Georeferencing of Pl�iades primary tristereo images, by H�seyin TOPAN (ZBE�, 2020)')

%%
display('==== Loading and Preprocessing ====')
for i = 1 : 2
    %===== Loading of data =====
    loading(i)
end

for i = 1 : 2
    %===== Preprocessing =====
    prepro(i);
end
%%
display('==== Bundle Adjustment ====')
bndl