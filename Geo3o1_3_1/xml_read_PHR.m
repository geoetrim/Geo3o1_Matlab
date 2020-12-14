% Exporting data from XML file for Pleiades 1A/1B
% Recoded by Ali Cam & Hüseyin Topan, ZBEÜ, 2015

function xml_read_PHR(i)

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
t_start (i) = tm(xml.Dimap_Document.Geometric_Data.Refined_Model.Time.Time_Range.START.Text);
t_end   (i) = tm(xml.Dimap_Document.Geometric_Data.Refined_Model.Time.Time_Range.END.Text);
t_period(i) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Time.Time_Stamp.LINE_PERIOD.Text);
assignin('base', 't_start', t_start)
assignin('base', 't_end', t_end)
assignin('base', 't_period', t_period)
if i > 1
    assignin('base', 't_period', t_period / 1e3)
end

for j = 1 : 10
    Sat_P(j,:) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Ephemeris.Point_List.Point{1, j}.LOCATION_XYZ.Text);
    Sat_V(j,:) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Ephemeris.Point_List.Point{1, j}.VELOCITY_XYZ.Text);
    Sat_t(j,:) = tm(xml.Dimap_Document.Geometric_Data.Refined_Model.Ephemeris.Point_List.Point{1, j}.TIME.Text);
end

satpv(: , : , i) = [Sat_t Sat_P Sat_V];
assignin('base', 'satpv', satpv)

t_offset(i) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Polynomial_Quaternions.OFFSET.Text);
t_scale(i)  = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Polynomial_Quaternions.SCALE.Text);
assignin('base', 't_offset', t_offset);
assignin('base', 't_scale', t_scale);

Q0 = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Polynomial_Quaternions.Q0.COEFFICIENTS.Text);
Q1 = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Polynomial_Quaternions.Q1.COEFFICIENTS.Text);
Q2 = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Polynomial_Quaternions.Q2.COEFFICIENTS.Text);
Q3 = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Polynomial_Quaternions.Q3.COEFFICIENTS.Text);
Q(:, :, i) = [Q0; Q1; Q2; Q3];
assignin('base', 'Q', Q);

XLOS_0(i) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Geometric_Calibration.Instrument_Calibration.Polynomial_Look_Angles.XLOS_0.Text);
XLOS_1(i) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Geometric_Calibration.Instrument_Calibration.Polynomial_Look_Angles.XLOS_1.Text);
YLOS_0(i) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Geometric_Calibration.Instrument_Calibration.Polynomial_Look_Angles.YLOS_0.Text);
assignin('base', 'XLOS_0', XLOS_0)
assignin('base', 'XLOS_1', XLOS_1)
assignin('base', 'YLOS_0', YLOS_0)

t_center(i) = tm(xml.Dimap_Document.Geometric_Data.Use_Area.Located_Geometric_Values{1, 2}.TIME.Text);
assignin('base', 't_center', t_center)
