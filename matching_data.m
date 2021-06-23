clear all; clc;

%% Selection XML file
function xml_read

[FileName_meta PathName_meta] = uigetfile('*.*','DIM File');
fprintf(fid, 'Metadata file: %1s \n\n', [PathName_meta FileName_meta]);

%% xml to struct
xml = xml2struct( [PathName_meta FileName_meta] );

%% Exporting
t_start    = xml.Dimap_Document.Geometric_Data.Refined_Model.Time.Time_Range.START.Text; 
t_end      = xml.Dimap_Document.Geometric_Data.Refined_Model.Time.Time_Range.END.Text;
t_interval = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Time.Time_Stamp.LINE_PERIOD.Text);

for i = 1 : 10
    Sat_P(i,:) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Ephemeris.Point_List.Point{1, i}.LOCATION_XYZ.Text);
    Sat_V(i,:) = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Ephemeris.Point_List.Point{1, i}.VELOCITY_XYZ.Text);
    Sat_t(i,:) = xml.Dimap_Document.Geometric_Data.Refined_Model.Ephemeris.Point_List.Point{1, i}.TIME.Text;
end

t_offset = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Polynomial_Quaternions.OFFSET.Text);
t_scale  = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Polynomial_Quaternions.SCALE.Text);
Q1       = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Polynomial_Quaternions.Q0.COEFFICIENTS.Text);
Q2       = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Polynomial_Quaternions.Q1.COEFFICIENTS.Text);
Q3       = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Polynomial_Quaternions.Q2.COEFFICIENTS.Text);
Q4       = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Attitudes.Polynomial_Quaternions.Q3.COEFFICIENTS.Text);

XLOS_0   = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Geometric_Calibration.Instrument_Calibration.Polynomial_Look_Angles.XLOS_0.Text);
XLOS_1   = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Geometric_Calibration.Instrument_Calibration.Polynomial_Look_Angles.XLOS_1.Text);
YLOS_0   = str2num(xml.Dimap_Document.Geometric_Data.Refined_Model.Geometric_Calibration.Instrument_Calibration.Polynomial_Look_Angles.YLOS_0.Text);

t_center = xml.Dimap_Document.Geometric_Data.Use_Area.Located_Geometric_Values{1, 2}.TIME.Text;