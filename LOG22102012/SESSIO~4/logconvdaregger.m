clear all
clc

if exist('sysvector.bin', 'file')
    fileInfo = dir('sysvector.bin');
    fileSize = fileInfo.bytes;
    
    fid = fopen('sysvector.bin', 'r');
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
        
        % local pos
        sensors(i,30:32) = fread(fid, 3, 'float', 0, 'ieee-le');
        
        % gps pos
        sensors(i,33:35) = fread(fid, 3, 'uint32', 0, 'ieee-le');
    end
    pos_loc(:,1:3) = sensors(:,30:32);
    
    pos_gps(:,1:3) = sensors(:,33:35);
    %fac1 = 7;
    %fac2 = 3;
    %pos_gps(:,1:2) = sensors(:,33:34)/power(10,fac1);
    %pos_gps(:,3) = sensors(:,35)/power(10,fac2);
    time_us = sensors(elements,1) - sensors(1,1);
    time_s = time_us*10^(-6)
    disp(['end log2matlab conversion' char(10)]);
end