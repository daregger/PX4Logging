close all
pos_loc(:,1:3) = sensors(:,30:32);
pos_gps(:,1:3) = sensors(:,33:35);
%big window
figure('units','normalized','outerposition',[0 0 1 1])
%prepare plotting
figure(1)
x_start = inf*ones(elements,1); 
y_start = inf*ones(elements,1); 
z_start = inf*ones(elements,1); 
x_start(1) = sensors(1,33);
y_start(1) = sensors(1,34);
z_start(1) = sensors(1,35);
x_stop = inf*ones(elements,1); 
y_stop = inf*ones(elements,1); 
z_stop = inf*ones(elements,1); 
stop_before = 0; %for incorrect ending
x_stop(elements-stop_before) = pos_gps(elements-stop_before,1);
y_stop(elements-stop_before) = pos_gps(elements-stop_before,2);
z_stop(elements-stop_before) = pos_gps(elements-stop_before,3);
%plotting
plot3(pos_gps(:,1),-pos_gps(:,2),pos_gps(:,3));
hold on
plot3(x_start,-y_start,z_start,'go','LineWidth',4);
plot3(x_stop,-y_stop,z_stop,'ro','LineWidth',4);
hold off
xlabel('lat [degree] N')
ylabel('lon [degree] E')
zlabel('alt [millimeter] AMSL')
legend('GPS measured','start','stop');
grid on
view([270 90])

%%
%big window
figure(2)
x_start = inf*ones(elements,1); 
y_start = inf*ones(elements,1); 
z_start = inf*ones(elements,1); 
x_start(1) = sensors(1,30);
y_start(1) = sensors(1,31);
z_start(1) = -sensors(1,32);
x_stop = inf*ones(elements,1); 
y_stop = inf*ones(elements,1); 
z_stop = inf*ones(elements,1); 
stop_before = 0; %for incorrect ending
x_stop(elements-stop_before) = pos_loc(elements-stop_before,1);
y_stop(elements-stop_before) = pos_loc(elements-stop_before,2);
z_stop(elements-stop_before) = -pos_loc(elements-stop_before,3);
%plotting
plot3(pos_loc(:,1),-pos_loc(:,2),-pos_loc(:,3));
hold on
plot3(x_start,-y_start,z_start,'go','LineWidth',4);
plot3(x_stop,-y_stop,z_stop,'ro','LineWidth',4);
hold off
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
legend('position\_estimator','start','stop');
grid on
view([270 90])

