clear all
clc
close all

pfad = '..\LOG01112012\SESSIO~1\';
datei = 'sysvector.bin';
dateipfad = strcat(pfad,datei);

if exist(dateipfad, 'file')
    fileInfo = dir(dateipfad);
    fileSize = fileInfo.bytes;
    
    fid = fopen(dateipfad, 'r');
    elements = int64(fileSize./(16*4+8))/4
    
    for i=1:elements       
        % timestamp
        sensors(i,1) = double(fread(fid, 1, '*uint64', 0, 'ieee-le.l64'));
        
        % gyro [rad/s] (3 channels)
        sensors(i,2:4) = fread(fid, 3, 'float', 0, 'ieee-le');
       
        % accelerometer [m/s^2] (3 channels)
        sensors(i,5:7) = fread(fid, 3, 'float', 0, 'ieee-le');
      
        % mag [gauss] (3 channels)
        sensors(i,8:10) = fread(fid, 3, 'float', 0, 'ieee-le');
       
        % baro pressure [millibar]
        sensors(i,11) = fread(fid, 1, 'float', 0, 'ieee-le');
        
        % baro alt [meter]
        sensors(i,12) = fread(fid, 1, 'float', 0, 'ieee-le');
         
        % baro temp [celcius]
        sensors(i,13) = fread(fid, 1, 'float', 0, 'ieee-le');
        
        % actuator control (4 channels) 
        sensors(i,14:17) = fread(fid, 4, 'float', 0, 'ieee-le');
        
        % actuator outputs (8 channels)
        sensors(i,18:25) = fread(fid, 8, 'float', 0, 'ieee-le');
                
        % vbat
        sensors(i,26) = fread(fid, 1, 'float', 0, 'ieee-le');
        
        % adc voltage (3 channels)
        sensors(i,27:29) = fread(fid, 3, 'float', 0, 'ieee-le');
        
        % local pos [m] (x,y,z)
        sensors(i,30:32) = fread(fid, 3, 'float', 0, 'ieee-le');
        
        % gps pos [lat degree,lot degree, alt millimeter over sea]
        sensors(i,33:35) = fread(fid, 3, 'uint32', 0, 'ieee-le');
        
        % attitude [rad]
        sensors(i,36:38) = fread(fid, 3, 'float', 0, 'ieee-le');
        
        % RotMatrix einheitsvektoren
        sensors(i,39:47) = fread(fid, 9, 'float', 0, 'ieee-le');
    end
    time_us = sensors(elements,1) - sensors(1,1);
    time_s = time_us*10^(-6)
    time_m = time_s/60
    disp(['end log2matlab conversion' char(10)]);
else
    disp(['file: ' dateipfad ' does not exist' char(10)]);
end