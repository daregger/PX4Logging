%% export to file for google earth


% resize gps_values
fac1 = 7;
fac2 = 3;
pos_gps(:,1:2) = pos_gps(:,1:2)/power(10,fac1);
pos_gps(:,3) = pos_gps(:,3)/power(10,fac2);

% create a kml file according to https://developers.google.com/kml/documentation/kml_tut
% also see https://support.google.com/earth/bin/answer.py?hl=en&answer=148072&topic=2376756&ctx=topic

runName = 'logging19102012';

% open file and overwrite content
fileId = fopen(['export-' runName '.kml'],'w+');

% define strings that should be written to file
fileStartDocumentString = ['<?xml version="1.0" encoding="UTF-8"?><kml xmlns="http://www.opengis.net/kml/2.2"><Document><name>Paths</name><description>' runName '</description>'];

fileStyleString{1} = '<Style id="blueLinebluePoly"><LineStyle><color>7fff0000</color><width>4</width></LineStyle><PolyStyle><color>7fff0000</color></PolyStyle></Style>';
fileStyleString{2} = '<Style id="greenLineGreenPoly"><LineStyle><color>7f00ff00</color><width>4</width></LineStyle><PolyStyle><color>7f00ff00</color></PolyStyle></Style>';
fileStyleString{3} = '<Style id="redLineRedPoly"><LineStyle><color>7f0000ff</color><width>4</width></LineStyle><PolyStyle><color>7f0000ff</color></PolyStyle></Style>';

filePlacemarkString{1} = '<Placemark><name>Absolute Extruded</name><description>Transparent blue wall with blue outlines</description><styleUrl>#blueLinebluePoly</styleUrl><LineString><extrude>1</extrude><tessellate>1</tessellate><altitudeMode>absolute</altitudeMode><coordinates>';
filePlacemarkString{2} = '<Placemark><name>Absolute Extruded</name><description>Transparent green wall with green outlines</description><styleUrl>#greenLineGreenPoly</styleUrl><LineString><extrude>1</extrude><tessellate>1</tessellate><altitudeMode>absolute</altitudeMode><coordinates>';
filePlacemarkString{3} = '<Placemark><name>Absolute Extruded</name><description>Transparent red wall with red outlines</description><styleUrl>#redLineRedPoly</styleUrl><LineString><extrude>1</extrude><tessellate>1</tessellate><altitudeMode>absolute</altitudeMode><coordinates>';

fileEndPlacemarkString = '</coordinates></LineString></Placemark>';
fileEndDocumentString = '</Document></kml>';


% start writing to file
fprintf(fileId,fileStartDocumentString);

% write path of every GPS    
fprintf(fileId,fileStyleString{1});
fprintf(fileId,filePlacemarkString{1});

hightOffset = 0;
% extract coordinates and height where they are not zero
maskWhereNotZero = ((pos_gps(:,2) ~= 0 & pos_gps(:,1) ~= 0 ) & pos_gps(:,3) ~= 0);
lonTemp = pos_gps(maskWhereNotZero,2);
latTemp = pos_gps(maskWhereNotZero,1);
elvTemp = pos_gps(maskWhereNotZero,3) + hightOffset; % in order to see the lines above ground

% write coordinates to file
for k=1:elements
    fprintf(fileId,'%.10f,%.10f,%.10f\n',lonTemp(k),latTemp(k),elvTemp(k));
end

% write end placemark
fprintf(fileId,fileEndPlacemarkString);


% write end of file
fprintf(fileId,fileEndDocumentString);

% close file, it should now be readable in Google Earth using File -> Open
fclose(fileId);
disp(['end matlab2googleEarth conversion' char(10)]);