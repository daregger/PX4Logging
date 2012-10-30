%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thrust angel pos estimator V3: estimat from real data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
start = 1;

%% read in data from logconv
xt = sensors(:,1);
pos_loc(:,1:3) = sensors(:,30:32);
pos_gps(:,1:3) = sensors(:,33:35);
attitude_rad(:,1:3) = sensors(:,36:38);
thrust(:,1) = sensors(:,22);

%% Model
dt=zeros(elements,1);
for i = 1:elements-1
    dt(i+1,1) = (xt(i+1,1)-xt(i,1))*10^(-6);   %Timestep [s]
end
dt(1,1) = mean(dt);
m = 0.448;   %[kg]
%plot(1:elements,dt)
attitude_deg = attitude_rad*180/pi; 
%plot(1:elements,attitude_deg(:,1));
%plot(1:elements,thrust);
F_x(:,1) = thrust(:,1).*sin(attitude_rad(:,1));    
F_y(:,1) = thrust(:,1).*sin(attitude_rad(:,2));
%plot(1:elements,F_x,1:elements,F_y); legend('F_x','F_y'); %[N]
a_x(:,1) = F_x(:,1)/m;
a_y(:,1) = F_y(:,1)/m;
%plot(1:elements,a_x,1:elements,a_y); legend('acc x','acc y'); %[m/s^2]
velocity_observe_x = 0;                       
velocity_observe_y = 0;

%% measurement conversion
%%%%%%%%%% x %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z_x(1,:) = pos_loc(:,1)';
z_x(2,:) = 0;
%%%%%%%%%% y %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
z_y(1,:) = pos_loc(:,2)';
z_y(2,:) = 0;
%plot(1:elements,z_x(1,:),1:elements,z_y(1,:));legend('pos measure x','pos measure y');

%% create vectors with ones at every time i have a new gps value
newGPS_x = zeros(1,elements);
newGPS_y = zeros(1,elements);
m=1;
for i = 1:elements-1
    if pos_loc(i+1,1) ~= pos_loc(i,1)
        newGPS_x(1,i+1) = 1;
        xt2(m,1) = xt(i,1);
        m = m+1;
    end
    if pos_loc(i+1,2) ~= pos_loc(i,2)
        newGPS_y(1,i+1) = 1;
    end
end
f_log=1/mean(dt) %Hz
%plot(1:m-1,xt2,'o')
dt2=zeros(1,m-2)
for q = 1:m-2
    dt2(1,q) = (xt2(q+1)-xt2(q))*10^(-6);
end
plot(1:m-1,dt2(1,m-2),'o')
f_gps=1/mean(dt2)
newGPS_x(1,:) = newGPS_x(1,:)'.*pos_loc(:,1);
%plot(1:elements,pos_loc(:,1),1:elements,newGPS_x(1,:),'mo')
newGPS_y(1,:) = newGPS_y(1,:)'.*pos_loc(:,2);
%plot(1:elements,pos_loc(:,2),1:elements,newGPS_y(1,:),'mo')

%% Initial condition
x_x(:,start) = [0 0]';                                % just a initial guess
P_x = 10*ones(2);                                  % not equal 0!

x_y(:,start) = [0 0]';                                % just a initial guess
P_y = 10*ones(2);                                  % not equal 0!

%% process noise variance                                                                !!!!!!!!!!!!!!!!!!!!!  TO TUNE !!!!!!!!!!!!!!!!!!!!!
q_x = [0.316 1];   %default: [0.3162 1]
q_y = [0.3162 5000];

%% measurement noise variance 
sigma_x = [sqrt(var(pos_loc(:,1))) 1.5]'     %default [sqrt(var(pos_loc(:,1))) 1]'
sigma_y = [sqrt(var(pos_loc(:,2))) 1.5]'

%% Kalman Filter iteratiion x
for k = start:elements-1
    [x_x(:,k+1),P_x] = positionKalmanFilter1D(x_x(:,k),P_x,velocity_observe_x,newGPS_x(1,k),a_x(k,1),z_x(:,k+1),sigma_x,q_x,dt(k,1));
    [x_y(:,k+1),P_y] = positionKalmanFilter1D(x_y(:,k),P_y,velocity_observe_y,1,a_y(k,1),z_y(:,k+1),sigma_y,q_y,dt(k,1));
end

%% Integral and Derivate of noisy measurement
%v_x = diff(z_x(1,:));
%p_x = cumsum(z_x(2,:));

%v_y = diff(z_y(1,:));
%p_y = cumsum(z_y(2,:));

%% 3D plot
figure('units','normalized','outerposition',[0 0 1 1])
figure(1);
plot3(xt(start:elements),z_y(1,start:elements),z_x(1,start:elements),'g');
hold on
plot3(xt(start:elements),x_y(1,start:elements),x_x(1,start:elements),'r');
hold off
xlabel('Time')
ylabel('Y Pos');
zlabel('X Pos')
grid on
legend('measurement','estimate');
%view([90 0])

%% single axis plot
% x
figure('units','normalized','outerposition',[0 0 1 1])
figure(2);
subplot(2,2,1);
plot(xt(start:elements),z_x(1,start:elements),xt(start:elements),x_x(1,start:elements));
ylabel('X Pos');
legend('measurement','estimate');
subplot(2,2,3);
plot(xt(start:elements),x_x(2,start:elements),'r');
ylabel('X Vel');
legend('estimate');

% y
subplot(2,2,2);
plot(xt(start:elements),z_y(1,start:elements),xt(start:elements),x_y(1,start:elements));
ylabel('Y Pos');
legend('measurement','estimate');
subplot(2,2,4);
plot(xt(start:elements),x_y(2,start:elements),'r');
ylabel('Y Vel');
legend('estimate');







