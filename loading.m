%Looading GCPs and metadata

function loading(i)
if i == 1
    display('===== Choose sensor =====')
    sensor_id = input('\n Pléiades 1A&1B: 1 \n SPOT 6&7      : 2 \n Göktürk-1     : 3 \n\n Choice        : '); assignin('base', 'sensor_id', sensor_id)
elseif i > 1
    sensor_id = evalin('base','sensor_id');
end

%% ===== Read report file =====
fid = evalin('base', 'fid');

%% ===== Loading points =====
if i > 1
    points = evalin('base', 'points');
end
[FileName_points PathName_points] = uigetfile('*.*','Point File');
p = load([PathName_points FileName_points]);
points(:, :, i) = sortrows(p, 1);
assignin ('base', 'points', points);
fprintf(fid, '%1d. Point file: %1s \n\n', i, [PathName_points FileName_points]);

%% ===== Loading metadata file =====
if sensor_id == 1 || sensor_id == 2 % Pléiades 1A&1B or SPOT 6&7 primary
    xml_read_PHR(i)
elseif sensor_id == 3 % Göktürk 1 level 2A
    xml_read_GKT_1(i)
end
