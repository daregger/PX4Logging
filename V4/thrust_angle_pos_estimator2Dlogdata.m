%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Thrust angel pos estimator V3: estimat from real data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
logconv;

close all
%% read in data from logconv
logstart = 1700;
logstop = elements;
elements = logstop-logstart+1;
start = 1;
xt(start:elements,1) = sensors(logstart:logstop,1);
pos_loc(start:elements,1:3) = sensors(logstart:logstop,30:32);
pos_gps(start:elements,1:3) = sensors(logstart:logstop,33:35);
attitude_rad(start:elements,1:3) = sensors(logstart:logstop,36:38);
thrust(start:elements,1) = sensors(logstart:logstop,22);
rot_matrix(start:elements,1:9) = sensors(logstart:logstop,39:47);
rot11(start:elements) = rot_matrix(start:elements,1);
rot12(start:elements) = rot_matrix(start:elements,2);
rot13(start:elements) = rot_matrix(start:elements,3);
rot21(start:elements) = rot_matrix(start:elements,4);
rot22(start:elements) = rot_matrix(start:elements,5);
rot23(start:elements) = rot_matrix(start:elements,6);
rot31(start:elements) = rot_matrix(start:elements,7);
rot32(start:elements) = rot_matrix(start:elements,8);
rot33(start:elements) = rot_matrix(start:elements,9);
for i = 1:elements
    rot(1:3,1:3,i) = [rot11(1,i) rot12(1,i) rot13(1,i);rot21(1,i) rot22(1,i) rot23(1,i);rot31(1,i) rot32(1,i) rot33(1,i)];
end

%plot3(rot11(1,:),rot12(1,:),rot13(1,:))
%plot(xt,rot11(1,:),xt,rot12(1,:),xt,rot13(1,:),xt,rot21(1,:),xt,rot22(1,:),xt,rot23(1,:),xt,rot31(1,:),xt,rot32(1,:),xt,rot33(1,:));legend('r11','r12','r13','r21','r22','r23','r31','r32','r33');

%% Model
dt=zeros(elements,1);
for i = 1:elements-1
    dt(i+1,1) = (xt(i+1,1)-xt(i,1))*10^(-6);   %Timestep [s]
end
dt(1,1) = mean(dt);
m = 0.448;   %[kg]
%plot(1:elements,dt)
%attitude_deg = attitude_rad*180/pi; plot(1:elements,attitude_deg(:,1));
force(1:elements,1) = zeros(elements,1);
for i=1:elements
    force(i,1) = thrust2force(thrust(i,1));
end
%plot(1:elements,thrust);
%plot(1:elements,force);
F_x(:,1) = force(:,1).*sin(attitude_rad(:,1));    
F_y(:,1) = force(:,1).*sin(attitude_rad(:,2));
%plot(1:elements,F_x,1:elements,F_y); legend('F_x','F_y'); %[N]
a_x_body(:,1) = F_x(:,1)/m;
a_y_body(:,1) = F_y(:,1)/m;
a_z_body(:,1) = force(:,1)/m-9.81;
%plot(1:elements,a_x_body,1:elements,a_y_body,1:elements,a_z_body); legend('acc x body','acc y body','acc z body'); %[m/s^2]

a_x_e_mean(1:elements,1) = zeros(elements,1);
a_y_e_mean(1:elements,1) = zeros(elements,1);
a_z_e_mean(1:elements,1) = zeros(elements,1);    
for i = 1:elements
    a_x_e_mean(i,1) = rot(1,1:3)*[a_x_body(i,1);a_y_body(i,1);a_z_body(i,1)];
    a_y_e_mean(i,1) = rot(2,1:3)*[a_x_body(i,1);a_y_body(i,1);a_z_body(i,1)];
    a_z_e_mean(i,1) = rot(3,1:3)*[a_x_body(i,1);a_y_body(i,1);a_z_body(i,1)];
end
% subtract mean out of acceleration if needed
a_x_e(:,1) = a_x_e_mean(:,1)% - mean(a_x_e_mean(:,1));
a_y_e(:,1) = a_y_e_mean(:,1)% - mean(a_y_e_mean(:,1));
a_z_e(:,1) = a_z_e_mean(:,1)% - mean(a_z_e_mean(:,1));

%mean(a_x_e_meanless(:,1))

%figure(2);plot(1:elements,a_x_e,1:elements,a_y_e,1:elements,a_z_e); legend('acc x earth','acc y earth','acc z earth'); %[m/s^2]

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

%% create vector with ones at every time i have a new gps value
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
dt2=zeros(1,m-2);
for q = 1:m-2
    dt2(1,q) = (xt2(q+1)-xt2(q))*10^(-6);
end
%plot(1:m-1,dt2(1,m-2),'o')
f_gps=1/mean(dt2)
newGPS_x_plot(1,:) = newGPS_x(1,:)'.*pos_loc(:,1);
%plot(1:elements,pos_loc(:,1),1:elements,newGPS_x_plot(1,:),'mo')
newGPS_y_plot(1,:) = newGPS_y(1,:)'.*pos_loc(:,2);
%plot(1:elements,pos_loc(:,2),1:elements,newGPS_y_plot(1,:),'mo')

%% Initial condition
x_x(:,start) = [0 0]';                                % just a initial guess
P_x = 10*ones(2);                                  % not equal 0!

x_y(:,start) = [0 0]';                                % just a initial guess
P_y = 10*ones(2);                                  % not equal 0!

%% process noise variance Q                                                               !!!!!!!!!!!!!!!!!!!!!  TO TUNE !!!!!!!!!!!!!!!!!!!!!
q_x = [1 5]';
q_y = [5 10]';
%q_x = [1e-10 1e-10]';
%q_y = [1e-3 1e-0]';

%% measurement noise variance R
sigma_x = 6;     %default [sqrt(var(pos_loc(:,1))) 1]'  6.25    
sigma_y = 8;  %sqrt(var(pos_loc(:,2))),8.39

%% Kalman Filter iteratiion x
%Test = zeros(1,start:elements-1);
for k = start:elements-1
    [x_x(:,k+1),P_x] = positionKalmanFilter1D(x_x(:,k),P_x,velocity_observe_x,newGPS_x(1,k),a_x_e(k,1),[z_x(1,k) 0]',[sigma_x 0]',q_x,dt(k,1));    %newGPS_x(1,k)
    [x_y(:,k+1),P_y] = positionKalmanFilter1D(x_y(:,k),P_y,velocity_observe_y,newGPS_y(1,k),a_y_e(k,1),[z_y(1,k) 0]',[sigma_y 0]',q_y,dt(k,1));  %-a_y_e(k,1
end

%figure(5)
%plot(start:elements-1,Test);
%mean(Test)
%% 3D plot
pos_plot_x = newGPS_x(1,start:elements).*z_x(1,start:elements);
pos_plot_x(pos_plot_x==0) = NaN;
pos_plot_y = newGPS_y(1,start:elements).*z_y(1,start:elements);
pos_plot_y(pos_plot_y==0) = NaN;
figure('units','normalized','outerposition',[0 0 1 1])
figure(1);
plot3(xt(start:elements),pos_plot_y,pos_plot_x,'mo');
hold on
plot3(xt(start:elements),z_y(1,start:elements),z_x(1,start:elements),'g');
plot3(xt(start:elements),x_y(1,start:elements),x_x(1,start:elements),'r');
hold off
xlabel('Time')
ylabel('Y Pos');
zlabel('X Pos')
grid on
legend('measurement','measurement','estimate');
view([90 0])

%% single axis plot
% x
figure('units','normalized','outerposition',[0 0 1 1])
figure(2);
subplot(4,2,1);
plot(xt(start:elements),z_x(1,start:elements),xt(start:elements),x_x(1,start:elements));
ylabel('X Pos earth');
legend('measurement','estimate');
subplot(4,2,3);
plot(xt(start:elements),a_x_e(start:elements,1),'r');
ylabel('X acc earth calculated');
subplot(4,2,5);
plot(xt(start:elements),a_x_body(start:elements,1),'r');
ylabel('X acc body calculated');
subplot(4,2,7);
plot(xt(start:elements),x_x(2,start:elements),'r');
ylabel('X Vel');
legend('estimate');

% y
subplot(4,2,2);
plot(xt(start:elements),z_y(1,start:elements),xt(start:elements),x_y(1,start:elements));
ylabel('Y Pos earth');
legend('measurement','estimate');
subplot(4,2,4);
plot(xt(start:elements),a_y_e(start:elements,1),'r');
ylabel('Y acc earth calcualated');
subplot(4,2,6);
plot(xt(start:elements),a_y_body(start:elements,1),'r');
ylabel('Y acc body calcualated');
subplot(4,2,8);
plot(xt(start:elements),x_y(2,start:elements),'r');
ylabel('Y Vel');
legend('estimate');





