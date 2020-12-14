%3D geopositioning of Pléiades 1A&1B primary, SPOT 6&7 primary and Göktürk 1 L2A tri-stereo images
%Recoded and modified by Prof. Hüseyin TOPAN, Dr. Gürsu AYTEKÝN, Zonguldak Bülent Ecevit University, December 2020, Zonguldak, Turkey
%Reference: Pléiades Imagery User Guide
%For more information: topan@beun.edu.tr, htopan@yahoo.com

clear; clc; close all
format  longEng
if exist('cikis.txt','var') == 1; delete('cikis.txt'); end

report_file

display('3D Georeferencing of Pléiades primary tristereo images, by Hüseyin TOPAN (ZBEÜ, 2020)')

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