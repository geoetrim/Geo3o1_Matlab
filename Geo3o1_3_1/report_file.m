% Creating a report file

function report_file

fid = fopen('cikis.txt','w+');
assignin ('base', 'fid', fid);
fprintf(fid, '3D georeferencing of Pl�iades 1A&1B primary, SPOT 6&7 primary and G�kt�rk 1 L2A tri-stereo images by Prof. H�seyin TOPAN, Dr. G�rsu AYTEK�N, Zonguldak B�lent Ecevit University, December 2020, Zonguldak, Turkey\n\n', 's');
fprintf(fid,'Date: %4d %2d %2d %2d %2d %2.0f\n\n', clock);