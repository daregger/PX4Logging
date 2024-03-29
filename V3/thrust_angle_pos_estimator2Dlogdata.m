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
rot_matrix(:,1:9) = sensors(:,39:47);
rot11(1,:) = rot_matrix(:,1);
rot12(1,:) = rot_matrix(:,2);
rot13(1,:) = rot_matrix(:,3);
rot21(1,:) = rot_matrix(:,4);
rot22(1,:) = rot_matrix(:,5);
rot23(1,:) = rot_matrix(:,6);
rot31(1,:) = rot_matrix(:,7);
rot32(1,:) = rot_matrix(:,8);
rot33(1,:) = rot_matrix(:,9);
for i = 1:elements
    rot(1:3,1:3,i) = [rot11(1,i) rot12(1,i) rot13(1,i);rot21(1,i) rot22(1,i) rot23(1,i);rot31(1,i) rot32(1,i) rot33(1,i)];
end
%plot3(rot11(1,:),rot12(1,:),rot13(1,:))
%plot(xt,rot11(1,:))

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
    force(i,1) = schubkurveTobi(thrust(i,1));
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

a_x_e(1:elements,1) = zeros(elements,1);
a_y_e(1:elements,1) = zeros(elements,1);
a_z_e(1:elements,1) = zeros(elements,1);    
for i = 1:elements
    a_x_e(i,1) = rot(1,1:3)*[a_x_body(i,1);a_y_body(i,1);a_z_body(i,1)];
    a_y_e(i,1) = rot(2,1:3)*[a_x_body(i,1);a_y_body(i,1);a_z_body(i,1)];
    a_z_e(i,1) = rot(3,1:3)*[a_x_body(i,1);a_y_body(i,1);a_z_body(i,1)];
end
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
%P_x = [225 240;240 430]

x_y(:,start) = [0 0]';                                % just a initial guess
P_y = 10*ones(2);                                  % not equal 0!

%% process noise variance Q                                                               !!!!!!!!!!!!!!!!!!!!!  TO TUNE !!!!!!!!!!!!!!!!!!!!!
q_x = [1 1];   %default: [0.3162 1]
q_y = [0.3 1];

%% measurement noise variance R
sigma_x = [sqrt(var(pos_loc(:,1))) 1]'     %default [sqrt(var(pos_loc(:,1))) 1]'  6.25    
sigma_y = [sqrt(var(pos_loc(:,2))) 1]'    %sqrt(var(pos_loc(:,2))),8.39

%% Kalman Filter iteratiion x
%Test = zeros(1,start:elements-1);
for k = start:elements-1
    [x_x(:,k+1),P_x] = positionKalmanFilter1D(x_x(:,k),P_x,velocity_observe_x,0,(a_x_e(k,1))/1000,z_x(:,k+1),sigma_x,q_x,dt(k,1));      %a_x(k,1)
    [x_y(:,k+1),P_y] = positionKalmanFilter1D(x_y(:,k),P_y,velocity_observe_y,0,(a_y_e(k,1))/100,z_y(:,k+1),sigma_y,q_y,dt(k,1));
    %Test(1,k) = P_x(2,1);
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





