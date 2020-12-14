% Creating a report file

function report_file

fid = fopen('cikis.txt','w+');
assignin ('base', 'fid', fid);
fprintf(fid, '3D georeferencing of Pléiades 1A&1B primary, SPOT 6&7 primary and Göktürk 1 L2A tri-stereo images by Prof. Hüseyin TOPAN, Dr. Gürsu AYTEKÝN, Zonguldak Bülent Ecevit University, December 2020, Zonguldak, Turkey\n\n', 's');
fprintf(fid,'Date: %4d %2d %2d %2d %2d %2.0f\n\n', clock);