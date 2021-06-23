% Finding H, M, S in the XML file.
% Recoded by Ali CAM, BEÜ, 2015

function time1 = tm(dt)

start  = find(dt == 'T');
finish = find(dt == 'Z');
center = find(dt == ':');

time1(1) = str2num(dt(1 , start + 1 : center(1) - 1));
time1(2) = str2num(dt(1 , center(1) + 1 : center(2) - 1));
time1(3) = str2num(dt(1 , center(2) + 1 : finish - 1));

time1 = hms2s(time1);