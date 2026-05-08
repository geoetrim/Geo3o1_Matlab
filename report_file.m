% Creating a report file

function report_file

if exist('cikis.txt','var') == 1; delete('cikis.txt'); end

fid = fopen('cikis.txt','w+');
assignin ('base', 'fid', fid);
fprintf(fid, 'Geo3o1: 3D georeferencing of Pléiades 1A&1B&Neo primary, SPOT 6&7 primary and Göktürk 1 L2A stereo/triplet images \n\n');
fprintf(fid, 'as a sub-tool of GeoEtrim, Zonguldak Bülent Ecevit University, January 2026, Zonguldak, Türkiye\n\n');
fprintf(fid, 'by Prof. Hüseyin TOPAN: Overall conception, workflow and coding by Matlab \n');
fprintf(fid, 'by Dr. Gürsu AYTEKÝN: Understanding tri-stereo space intersection and Göktürk 1 metafile importing \n');
fprintf(fid, 'by Mr. Ali CAM: XML file importing \n');
fprintf(fid, 'by Prof. Bahattin ERDOÐAN: Interpolation of look angles of ICPs from of GCPs \n');
fprintf(fid, 'Date: %4d %2d %2d %2d %2d %2.0f\n\n', clock);