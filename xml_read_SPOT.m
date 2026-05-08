% Exporting data from XML file for SPOT 6&7 and Pléiades Neo
% Recoded by Ali Cam & Hüseyin Topan, BEÜN, December 2025

function xml_read_SPOT(i)

if i > 1
    t_start  = evalin('base', 't_start');
    t_end    = evalin('base', 't_end');
    t_period = evalin('base', 't_period');
    t_center = evalin('base', 't_center');
    satpv    = evalin('base', 'satpv');
    Q        = evalin('base', 'Q');
    XLOS_0   = evalin('base', 'XLOS_0');
    XLOS_1   = evalin('base', 'XLOS_1');
    YLOS_0   = evalin('base', 'YLOS_0');
    YLOS_1   = evalin('base', 'YLOS_1');
    n_satpv  = evalin('base', 'n_satpv');
    n_Q      = evalin('base', 'n_Q');
end
PathName_points = evalin('base', 'PathName_points');
[FileName_meta, PathName_meta] = uigetfile('*.xml','XML File', PathName_points);
fid = evalin('base', 'fid');
fprintf(fid, '%1d. Metadata file: %1s \n\n', i, [PathName_meta, FileName_meta]);

%% xml to struct
xml = xml2struct([PathName_meta FileName_meta]);

%% Exporting
sensor_name = xml.Dimap_Document.Metadata_Identification.METADATA_PROFILE.Text;
t_start (i) = tm(xml.Dimap_Document.Geometric_Data.Refined_Model.Time.Time_Range.START.Text);
t_end   (i) = tm(xml.Dimap_Document.Geometric_Data.Refined_Model.Time.Time_Range.END.Text);
t_period(i) = 1e-6 * str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Time.Time_Stamp.LINE_PERIOD.Text);%mikrosecond to second

for k = 1 : numel(xml.Dimap_Document.Geometric_Data.Use_Area.Located_Geometric_Values)
    if strcmp(xml.Dimap_Document.Geometric_Data.Use_Area.Located_Geometric_Values{1,k}.LOCATION_TYPE.Text, 'Center')
        t_center(i) = tm(xml.Dimap_Document.Geometric_Data.Use_Area.Located_Geometric_Values{1,k}.TIME.Text);
    end
end
assignin('base', 'sensor_name', sensor_name)
assignin('base', 't_start', t_start)
assignin('base', 't_end', t_end)
assignin('base', 't_period', t_period);
assignin('base', 't_center', t_center) 

n_satpv(i) = numel(xml.Dimap_Document.Geometric_Data.Refined_Model.Ephemeris.Point_List.Point);
assignin('base', 'n_satpv', n_satpv)
if i > 1
    if n_satpv(i) > n_satpv(1)
        satpv(n_satpv(1) + 1 : n_satpv(i) , : , 1) = 0;
    elseif n_satpv(i) < n_satpv(1)
        satpv(1 : n_satpv(1) , : , i) = 0;
    end
end
for j = 1 : n_satpv(i)
    Sat_P(j , :) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Ephemeris.Point_List.Point{1, j}.LOCATION_XYZ.Text);
    Sat_V(j , :) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Ephemeris.Point_List.Point{1, j}.VELOCITY_XYZ.Text);
    Sat_t(j , :) = tm(xml.Dimap_Document.Geometric_Data.Refined_Model.Ephemeris.Point_List.Point{1, j}.TIME.Text);
end
satpv(1 : n_satpv(i) , : , i) = [Sat_t Sat_P Sat_V];
assignin('base', 'satpv', satpv)

%Nominal quaternions
n_Q(i) = numel(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Quaternion_List.Quaternion);
assignin('base', 'n_Q', n_Q)
if i > 1
    if n_Q(i) > n_Q(1)
        Q(n_Q(1) + 1 : n_Q(i) , : , 1) = 0;
    elseif n_Q(i) < n_Q(1)
        Q(1 : n_Q(1) , : , i) = 0;
    end
end
for j = 1 : n_Q(i)
    Q0(j) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Quaternion_List.Quaternion{1, j}.Q0.Text);
    Q1(j) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Quaternion_List.Quaternion{1, j}.Q1.Text);
    Q2(j) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Quaternion_List.Quaternion{1, j}.Q2.Text);
    Q3(j) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Quaternion_List.Quaternion{1, j}.Q3.Text);
    Qt(j) = tm(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Quaternion_List.Quaternion{1, j}.TIME.Text);
end
Q(1 : n_Q(i), :, i) = [Qt' Q0' Q1' Q2' Q3'];
assignin('base', 'Q', Q);

XLOS_0(i) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Geometric_Calibration.Instrument_Calibration.Band_Calibration_List.Band_Calibration.Polynomial_Look_Angles.XLOS_0.Text);
XLOS_1(i) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Geometric_Calibration.Instrument_Calibration.Band_Calibration_List.Band_Calibration.Polynomial_Look_Angles.XLOS_1.Text);
YLOS_0(i) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Geometric_Calibration.Instrument_Calibration.Band_Calibration_List.Band_Calibration.Polynomial_Look_Angles.YLOS_0.Text);
YLOS_1(i) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Geometric_Calibration.Instrument_Calibration.Band_Calibration_List.Band_Calibration.Polynomial_Look_Angles.YLOS_1.Text);
assignin('base', 'XLOS_0', XLOS_0)
assignin('base', 'XLOS_1', XLOS_1)
assignin('base', 'YLOS_0', YLOS_0)
assignin('base', 'YLOS_1', YLOS_1)

column_size = str2num(xml.Dimap_Document.Raster_Data.Raster_Dimensions.NCOLS.Text);
row_size    = str2num(xml.Dimap_Document.Raster_Data.Raster_Dimensions.NROWS.Text);
gsd         = str2num(xml.Dimap_Document.Processing_Information.Product_Settings.Sampling_Settings.RESAMPLING_SPACING.Text);
assignin('base', 'column_size', column_size)
assignin('base', 'row_size', row_size)
assignin('base', 'gsd', gsd)