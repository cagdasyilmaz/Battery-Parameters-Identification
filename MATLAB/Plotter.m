 close all;

%% Current vs Time Plot ---------------------------------------------------
f = figure;
%subplot(3,1,1);
plot(t_vec(9761:25820), i(9761:25820),'LineWidth', 2, 'Color', 'b');

grid on
title('$Current\,vs\,\,Time$ ',...
      'fontsize',18, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 18, 'interpreter', 'latex')
ylabel('$Current\,[Amper(I)]$','fontsize', 18, 'interpreter', 'latex')

l = legend('$Measured$','$Reference$','Location','SouthEast');
set(l, 'interpreter', 'latex', 'fontsize', 18)

saveas(f,'image_name','eps2c');
%%

%% SoC vs Time Plot -------------------------------------------------------
figure;

subplot(2,1,1);
plot(t_vec, SoC(:,1),'LineWidth', 2, 'Color', 'b');

grid on
title('$SoC\,\,vs\,\,Time$ ',...
      'fontsize',18, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 18, 'interpreter', 'latex')
ylabel('$State\,of\,Charge\,[\%]$','fontsize', 18, 'interpreter', 'latex')

l = legend('$Measured$','$Reference$','Location','SouthEast');
set(l, 'interpreter', 'latex', 'fontsize', 18)

subplot(2,1,2);
plot(t_vec, SoC(:,2), 'o','LineWidth', 2, 'Color', 'b');

grid on
title('$Charge\,\,State\,\,(1\,Charging,\,\,0\,Idle,\,\,-1\,Discharging)\,\,vs\,\,Time$ ',...
      'fontsize',18, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 18, 'interpreter', 'latex')
ylabel('$Charge\,\,State$','fontsize', 18, 'interpreter', 'latex')

l = legend('$Measured$','$Reference$','Location','SouthEast');
set(l, 'interpreter', 'latex', 'fontsize', 18)

%%

%% Battery Voltage vs Time Plot -------------------------------------------
figure;
%subplot(3,1,3);

plot(t_vec, u,'LineWidth', 2, 'Color', 'b');

grid on
title('$Battery\,Voltage\,vs\,\,Time$ ',...
      'fontsize',18, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 18, 'interpreter', 'latex')
ylabel('$Battery\,Voltage\,[Volt(V)]$','fontsize', 18, 'interpreter', 'latex')

l = legend('$Measured$','$Reference$','Location','NorthEast');
set(l, 'interpreter', 'latex', 'fontsize', 18)

%%

%% Open Circuit Voltage vs SoC --------------------------------------------

f = figure;

plot(SOC_OCV_Discharge(1:end,2), SOC_OCV_Discharge(1:end,3), ...
    'LineWidth', 2, 'Color', 'b');

hold on

plot(SOC_OCV_Charge(1:end,2), SOC_OCV_Charge(1:end,3), ...
     'LineWidth', 2, 'Color', 'r');

hold on

plot(OCV_SOC_x, OCV_SOC_y_mean, ...
     'LineWidth', 2, 'Color', 'g');

%xlim([0 100])
%ylim([3.3 4.2])

grid on
title('$OCP\,vs\,\,SOC$ ',...
      'fontsize',18, 'fontweight','b', 'interpreter', 'latex')
xlabel('$State\,of\,Charge[\%]$','fontsize', 18, 'interpreter', 'latex')
ylabel('$Open\,Circuit\,Voltage\,[Volt(V)]$','fontsize', 18, 'interpreter', 'latex')


l = legend('$Discharging\,\,with\,\,C/3$', ...
           '$Charging\,\,with\,\,C/3$', ...
            '$Average$','Location','SouthEast');
set(l, 'interpreter', 'latex', 'fontsize', 18)

%%

%% Parameter Identification Interval Plot ---------------------------------
f = figure;

subplot(2,1,1)
plot(Param_Identification_Vec(:,1), Param_Identification_Vec(:,2),'LineWidth', 2, 'Color', 'b');

grid on
title('$Current\,vs\,\,Time$ ',...
      'fontsize',18, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 18, 'interpreter', 'latex')
ylabel('$Current\,[(A)]$','fontsize', 18, 'interpreter', 'latex')


subplot(2,1,2)
plot(Param_Identification_Vec(:,1), Param_Identification_Vec(:,4),'LineWidth', 2, 'Color', 'b');

grid on
title('$Battery\,Voltage\,vs\,\,Time$ ',...
      'fontsize',18, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 18, 'interpreter', 'latex')
ylabel('$Voltage\,[(V)]$','fontsize', 18, 'interpreter', 'latex')

%saveas(f,'image_name','eps2c');


f = figure;

subplot(5,1,1)
plot(RC_Vector(65:end,1), RC_Vector(65:end,2),'LineWidth', 2, 'Color', 'b');

grid on
title('$R_{0}\,vs\,\,Time$ ',...
      'fontsize', 12, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 12, 'interpreter', 'latex')
ylabel('$R_{0}\,[(Ohm)]$','fontsize', 12, 'interpreter', 'latex')

subplot(5,1,2)
plot(RC_Vector(65:end,1), RC_Vector(65:end,3),'LineWidth', 2, 'Color', 'b');

grid on
title('$R_{1}\,vs\,\,Time$ ',...
      'fontsize',12, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 12, 'interpreter', 'latex')
ylabel('$R_{1}\,[(Ohm)]$','fontsize', 12, 'interpreter', 'latex')

subplot(5,1,3)
plot(RC_Vector(65:end,1), RC_Vector(65:end,4),'LineWidth', 2, 'Color', 'b');

grid on
title('$C_{1}\,vs\,\,Time$ ',...
      'fontsize',12, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 12, 'interpreter', 'latex')
ylabel('$C_{1}\,[(Farad)]$','fontsize', 12, 'interpreter', 'latex')

subplot(5,1,4)
plot(RC_Vector(65:end,1), RC_Vector(65:end,5),'LineWidth', 2, 'Color', 'b');

grid on
title('$R_{2}\,vs\,\,Time$ ',...
      'fontsize',12, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 12, 'interpreter', 'latex')
ylabel('$R_{2}\,[(Ohm)]$','fontsize', 12, 'interpreter', 'latex')

subplot(5,1,5)
plot(RC_Vector(65:end,1), RC_Vector(65:end,6),'LineWidth', 2, 'Color', 'b');

grid on
title('$C_{2}\,vs\,\,Time$ ',...
      'fontsize',12, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 12, 'interpreter', 'latex')
ylabel('$C_{2}\,[(Farad)]$','fontsize', 12, 'interpreter', 'latex')

%saveas(f,'image_name','eps2c');
%%
