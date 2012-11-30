clear all
close all
%sensorsAll = importdata('sensorsSave.mat');
sensorsAll = importdata('sensorsSave.mat');
%figure(1);scaleUP = 500; hold on; plot(scaleUP*sensorsAll(:,52),'r'); plot(sensorsAll(:,22),'b'); hold off;
%define flights from thrust vector and store start stop of the flight
flyingThreshold = 230;
FlugCnt = 0;
stateFlying = 0;
[Zeit,LogNum] = size(sensorsAll);
for i = 1:Zeit
    if stateFlying == 0
        if sensorsAll(i,22) > flyingThreshold
            stateFlying = 1;
            FlugStart(FlugCnt+1) = i;
        end
    end
    if stateFlying == 1
        if sensorsAll(i,22) < flyingThreshold
            stateFlying = 0;
            FlugStop(FlugCnt+1) = i;
            FlugCnt = FlugCnt + 1;
        end
    end
end
%FlugCnt;
flug = struct([]);
maxFlightDuration = 0;
for flight = 1:FlugCnt
    %built flug struct
    thisFlight.name = strcat('flug',num2str(flight));
    thisFlight.data = sensorsAll(FlugStart(flight):FlugStop(flight),:);
    flug = [flug; thisFlight];
    %find out maximal flight duration
    [Zeit,LogNum] = size(flug(flight,1).data);
    if Zeit > maxFlightDuration
        maxFlightDuration = Zeit;
    end
end
%%
dt=1/150;
GPS_update_freq = 1;
GPS_dt_factor = GPS_update_freq / dt

A=[0,1,0;
    0,0,-1;
    0,0,0];

    B=[0;1;0];
    C=[1,0,0];

sys_C=ss(A,B,C,[]);
sys_D=c2d(sys_C,dt);

Ad=sys_D.A;
Bd=sys_D.B;
Cd=sys_D.C;   

Observability = rank([Cd;Cd*Ad;Cd*Ad^2]);  %observable
Controllable = rank([Bd Ad*Bd Ad^2*Bd]);   %but not controllable

m=0.448;
g=9.81;

bruteforce = 0;
if bruteforce == 1 
    accThreshStart = 0.5;
    accThreshStep = 0.1;
    accThreshStop = 0.9;
    accThreshNum = round((accThreshStop-accThreshStart)/accThreshStep+1);
    accThreshIndex = 1;

    decayStart = 0.9;
    decayStep = 0.01;
    decayStop = 0.99;
    decayNum = round((decayStop-decayStart)/decayStep+1);
else
    accThreshStart = 0.1;
    accThreshStep = 0.1;
    accThreshStop = 0.1;
    accThreshNum = round((accThreshStop-accThreshStart)/accThreshStep+1);
    accThreshIndex = 1;

    decayStart = 0.995;%0.995;
    decayStep = 0.01;
    decayStop = 0.995;
    decayNum = round((decayStop-decayStart)/decayStep+1);
end

plot_val=zeros(8,maxFlightDuration,FlugCnt,decayNum,accThreshNum); %4th is x_vicon, 8th is y_vicon
error_sum = zeros(FlugCnt,decayNum,accThreshNum);

for accThresh = accThreshStart:accThreshStep:accThreshStop
    decayIndex = 1;
    for decay = decayStart:decayStep:decayStop
        % go through every flight , store Data in plot_val([pos_estimated;vel_estimated;offset];pos_vicon,iteration,flightNR)
        for flight = 1:FlugCnt
            start_sim=1;
            myData = flug(flight,1).data;
            [Zeit,LogNum] = size(myData);
            end_sim = Zeit;
            x_vicon=myData(start_sim:end_sim,48);
            y_vicon=myData(start_sim:end_sim,49);
            z_vicon=myData(start_sim:end_sim,50);
            
            roll_vicon=myData(start_sim:end_sim,51);
            pitch_vicon=-myData(start_sim:end_sim,52);
            yaw_vicon=myData(start_sim:end_sim,53);

            x_apriori=[x_vicon(1);0;0];
            P_x_apriori=100*eye(3);

            y_apriori=[y_vicon(1);0;0];
            P_y_apriori=100*eye(3);
            
            gps_update_cnt = 1;
            for i=start_sim:end_sim
                u_x_b = sin(pitch_vicon(i))*g;     %acceleration
                u_y_b = sin(roll_vicon(i))*g;      %acceleration
                R_z = [cos(yaw_vicon(i)) -sin(yaw_vicon(i));
                       sin(yaw_vicon(i)) cos(yaw_vicon(i))];
                u_x_e = R_z(1,1)*u_x_b + R_z(1,2)*u_y_b;
                u_y_e = R_z(2,1)*u_x_b + R_z(2,2)*u_y_b;
                
                % gps noise standard deviation
                sigma = 1;
                % measurement noise variance
                R=sigma*1e3;
                % process noise variance
                Q=[1e-1,0,0;
                    0,1e-1,0;
                    0,0,0];
                z_x = GPS_noiseGen(x_vicon(i),sigma);
                z_y = GPS_noiseGen(y_vicon(i),sigma);
                plot_val(4,i,flight,decayIndex,accThreshIndex) = z_x;
                plot_val(8,i,flight,decayIndex,accThreshIndex) = z_y;
                
                if gps_update_cnt == GPS_dt_factor
                    gps_update = 1;
                    gps_update_cnt = 1;
                else
                    gps_update = 0;
                    gps_update_cnt = gps_update_cnt + 1;
                end

                % x Direction
                [x_aposteriori,P_x_aposteriori]=KalmanPosition(Ad,Bd,Cd,x_apriori,P_x_apriori,u_x_e,z_x,gps_update,Q,R,accThresh,decay);
                x_apriori=x_aposteriori;
                P_x_apriori=P_x_aposteriori;
                % y Direction
                [y_aposteriori,P_y_aposteriori]=KalmanPosition(Ad,Bd,Cd,y_apriori,P_y_apriori,u_y_e,z_y,1,Q,R,accThresh,decay);
                y_apriori=y_aposteriori;
                P_y_apriori=P_y_aposteriori;
                plot_val(1:3,i,flight,decayIndex,accThreshIndex) = x_aposteriori;
                plot_val(3,i,flight,decayIndex,accThreshIndex) = u_x_e;
                plot_val(5:7,i,flight,decayIndex,accThreshIndex) = y_aposteriori;
                plot_val(7,i,flight,decayIndex,accThreshIndex) = u_y_e;
                
                % summation of position error (only when flying)
                error_sum(flight,decayIndex,accThreshIndex) = error_sum(flight,decayIndex,accThreshIndex) + sqrt((x_aposteriori(1) - x_vicon(i))^2 + (y_aposteriori(1) - y_vicon(i))^2);
            end
            % divide error through flight time
            error_sum(flight,decayIndex,accThreshIndex) = error_sum(flight,decayIndex,accThreshIndex)/((end_sim-start_sim)*dt);
        end
        decayIndex = decayIndex + 1
    end
    accThreshIndex = accThreshIndex + 1
end
%% find smallest summation error over all decay factors
% sum up errors over all flights for specific decay factor and acc threshold
total_error = sum(error_sum,1);
% rewrite matrix into 2 D array
[z,s,t] = size(total_error);
total_error2 = zeros(s,t);
for zei =1:s
    for spa = 1:t
        total_error2(zei,spa) = total_error(1,zei,spa);
    end
end
% find smallest index for decay value over the sum of all errors of all flights
[r,c]=find(total_error2==min(min(total_error2)))
best_decayFactor = decayStart + (r - 1)*decayStep
best_accThresh = accThreshStart + (c - 1)*accThreshStep

%% plot best result data
close all
figure('units','normalized','outerposition',[0 0 1 1])
%FlugCnt = 3
for flight = 1:FlugCnt
    subplot(FlugCnt,2,2*flight-1)
    plot(plot_val(4,:,flight,r,c),'g');
    hold on
    plot(plot_val(1,:,flight,r,c),'r')
    plot(plot_val(2,:,flight,r,c),'k')
    plot(plot_val(3,:,flight,r,c),'c')
    hold off
    title(strcat('error\_sum x & y=',{' '},num2str(error_sum(flight,r,c))));
    legend('x vicon','x estimate vicon','v_x estimate vicon','a\_x\_e')
    
    subplot(FlugCnt,2,2*flight)
    plot(plot_val(8,:,flight,r,c),'g');
    hold on
    plot(plot_val(5,:,flight,r,c),'r')
    plot(plot_val(6,:,flight,r,c),'k')
    plot(plot_val(7,:,flight,r,c),'c')
    hold off
    legend('y vicon','y estimate vicon','v_y estimate vicon','a\_y\_e')
end

%% highlight smalles error found
%[smallest_error idx] = min(error_sum(:,r,c));
%set(subplot(FlugCnt,1,idx),'Color',[.7 .7 .9]);

