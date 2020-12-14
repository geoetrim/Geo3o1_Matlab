% Exporting data from XML file for Göktürk 1
% Recoded by Ali Cam, Gürsu Aytekin & Hüseyin Topan, ZBEÜ, 2020

function xml_read_GKT(i)

if i > 1
   t_start  = evalin('base', 't_start');
   t_end    = evalin('base', 't_end');
   t_period = evalin('base', 't_period');
   satpv    = evalin('base', 'satpv');
   t_offset = evalin('base', 't_offset');
   t_scale  = evalin('base', 't_scale');
   Q        = evalin('base', 'Q');
   XLOS_0   = evalin('base', 'XLOS_0');
   XLOS_1   = evalin('base', 'XLOS_1');
   YLOS_0   = evalin('base', 'YLOS_0');
   t_center = evalin('base', 't_center');
end

[FileName_meta PathName_meta] = uigetfile('*.*','XML File');
fid = evalin('base', 'fid');
fprintf(fid, 'Metadata file: %1s \n\n', [PathName_meta FileName_meta]);

%% xml to struct
xml = xml2struct( [PathName_meta FileName_meta] );

%% Exporting
t_start (i) = tm(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.UTC_Sensor_Model_Range.START.Text);
t_end   (i) = tm(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.UTC_Sensor_Model_Range.END.Text);
t_period(i) = str2num(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.SENSOR_LINE_PERIOD.Text);
assignin('base', 't_start', t_start)
assignin('base', 't_end', t_end)
assignin('base', 't_period', t_period)
if i > 1
    assignin('base', 't_period', t_period / 1e3)
end

for j = 1 : 33
    Sat_P(j,:) = str2num(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.Sensor_Ephemeris.Point_List.Point{1, j}.LOCATION_VALUES.Text);
    Sat_V(j,:) = str2num(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.Sensor_Ephemeris.Point_List.Point{1, j}.VELOCITY_VALUES.Text);
    Sat_t(j,:) = tm(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.Sensor_Ephemeris.Point_List.Point{1, j}.UTC_TIME.Text);
end

satpv(: , : , i) = [Sat_t Sat_P Sat_V];
assignin('base', 'satpv', satpv)

t_offset(i) = str2num(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.Sensor_Attitudes.OFFSET.Text);
t_scale(i)  = str2num(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.Sensor_Attitudes.SCALE.Text);
assignin('base', 't_offset', t_offset);
assignin('base', 't_scale', t_scale);

Q0 = str2num(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.Sensor_Attitudes.Polynomial_Models.Q0.COEFFICIENTS.Text);
Q1 = str2num(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.Sensor_Attitudes.Polynomial_Models.Q1.COEFFICIENTS.Text);
Q2 = str2num(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.Sensor_Attitudes.Polynomial_Models.Q2.COEFFICIENTS.Text);
Q3 = str2num(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.Sensor_Attitudes.Polynomial_Models.Q3.COEFFICIENTS.Text);
Q(:, :, i) = [Q0; Q1; Q2; Q3];
assignin('base', 'Q', Q);

XLOS      = (xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.Sensor_Viewing_Model.Viewing_Directions.PsiX_Model.COEFFICIENTS.Text);
XLOS_0(i) = str2num(XLOS(1 : 19));
XLOS_1(i) = str2num(XLOS(20 : end));
YLOS_0(i) = str2num(xml.GKT_Dimap_Document.Geometric_Data.Sensor_Model_Characteristics.Sensor_Viewing_Model.Viewing_Directions.PsiY_Model.COEFFICIENTS.Text);
assignin('base', 'XLOS_0', XLOS_0)
assignin('base', 'XLOS_1', XLOS_1)
assignin('base', 'YLOS_0', YLOS_0)

t_center(i) = tm(xml.GKT_Dimap_Document.Data_Strip.Geometric_Header_List.Located_Geometric_Header{1, 2}.UTC_TIME.Text);
assignin('base', 't_center', t_center)
