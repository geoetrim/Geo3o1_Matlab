%Loading GCPs and metadata

function loading(ni)

if ni == 1
    display('===== Choose sensor =====')
    sensor_id = input('\n Pléiades 1A&1B         : 1 \n SPOT 6&7 & Pléiades Neo: 2 \n Göktürk-1              : 3 \n\n Choice                 : '); assignin('base', 'sensor_id', sensor_id)
elseif ni > 1
    sensor_id = evalin('base','sensor_id');
end

%% ===== Read report file =====
fid = evalin('base', 'fid');

%% ===== Loading points =====
if ni > 1
    points = evalin('base', 'points');
    PathName_points = evalin('base', 'PathName_points');
end
if ni == 1
    PathName_points = [];
end
[FileName_points, PathName_points] = uigetfile('*.txt*;*.gcp','Point File', PathName_points);
p = load([PathName_points FileName_points]);
points(:, :, ni) = sortrows(p, 1);
assignin('base', 'PathName_points', PathName_points)
assignin('base', 'FileName_points', FileName_points)
assignin ('base', 'points', points)
fprintf(fid, '%1d. Point file: %1s \n\n', ni, [PathName_points FileName_points]);

%% ===== Loading metadata file =====
if sensor_id == 1% Pléiades 1A&1B
    xml_read_PHR(ni)
elseif sensor_id == 2% SPOT 6&7, Pléiades Neo
    xml_read_SPOT(ni)
elseif sensor_id == 3 % Göktürk 1 level 2A
    xml_read_GKT_1(ni)
end
