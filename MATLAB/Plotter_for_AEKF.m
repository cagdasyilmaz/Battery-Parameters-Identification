 close all;

%% Estimated Circuit Parameters
f = figure;

subplot(5,1,1)
plot(RC_Vector(1:end,1), RC_Vector(1:end,2),'LineWidth', 2, 'Color', 'b');

grid on
title('$R_{0}\,vs\,\,Time$ ',...
      'fontsize', 12, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 12, 'interpreter', 'latex')
ylabel('$R_{0}\,[(Ohm)]$','fontsize', 12, 'interpreter', 'latex')

subplot(5,1,2)
plot(RC_Vector(1:end,1), RC_Vector(1:end,3),'LineWidth', 2, 'Color', 'b');

grid on
title('$R_{1}\,vs\,\,Time$ ',...
      'fontsize',12, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 12, 'interpreter', 'latex')
ylabel('$R_{1}\,[(Ohm)]$','fontsize', 12, 'interpreter', 'latex')

subplot(5,1,3)
plot(RC_Vector(1:end,1), RC_Vector(1:end,4),'LineWidth', 2, 'Color', 'b');

grid on
title('$C_{1}\,vs\,\,Time$ ',...
      'fontsize',12, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 12, 'interpreter', 'latex')
ylabel('$C_{1}\,[(Farad)]$','fontsize', 12, 'interpreter', 'latex')

subplot(5,1,4)
plot(RC_Vector(1:end,1), RC_Vector(1:end,5),'LineWidth', 2, 'Color', 'b');

grid on
title('$R_{2}\,vs\,\,Time$ ',...
      'fontsize',12, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 12, 'interpreter', 'latex')
ylabel('$R_{2}\,[(Ohm)]$','fontsize', 12, 'interpreter', 'latex')

subplot(5,1,5)
plot(RC_Vector(1:end,1), RC_Vector(1:end,6),'LineWidth', 2, 'Color', 'b');

grid on
title('$C_{2}\,vs\,\,Time$ ',...
      'fontsize',12, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 12, 'interpreter', 'latex')
ylabel('$C_{2}\,[(Farad)]$','fontsize', 12, 'interpreter', 'latex') 
%% 
 
%% SoC vs Time Plot -------------------------------------------------------
f = figure;

plot(t_vec(1:index), SoC(1:index,1),'LineWidth', 2, 'Color', 'b');

hold on 

plot(State_Log(:,1), 100 * State_Log(:,4),'--','LineWidth', 2, 'Color', 'r');

grid on
title('$SoC\,\,vs\,\,Time$ ',...
      'fontsize',18, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 18, 'interpreter', 'latex')
ylabel('$State\,of\,Charge\,[\%]$','fontsize', 18, 'interpreter', 'latex')

l = legend('$Measured$','$Estimated$','Location','South');
set(l, 'interpreter', 'latex', 'fontsize', 18)
%%

%% Terminal Voltage vs Time Plot ------------------------------------------
f = figure;

plot(t_vec(1:index), u(1:index,1),'LineWidth', 2, 'Color', 'b');

hold on 

plot(Simulation_Output_Log(:,1), Simulation_Output_Log(:,2),'--','LineWidth', 2, 'Color', 'r');

grid on
title('$U_{t}\,\,vs\,\,Time$',...
      'fontsize',18, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 18, 'interpreter', 'latex')
ylabel('$U_{t}\,[(Volt)]$','fontsize', 18, 'interpreter', 'latex')

l = legend('$Measured$','$Estimated$','Location','SouthWest');
set(l, 'interpreter', 'latex', 'fontsize', 18)
saveas(f,'image_name','eps2c');
%%

%% Voltage on the RC Circuit ----------------------------------------------
f = figure;

subplot(2,1,1)
plot(State_Log(:,1), State_Log(:,2), 'LineWidth', 2, 'Color', 'b');

grid on
title('$$U_{1}\,\,vs\,\,Time$$ ',...
      'fontsize',18, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 18, 'interpreter', 'latex')
ylabel('$U_{1}\,[(Volt)]$','fontsize', 18, 'interpreter', 'latex')


subplot(2,1,2)
plot(State_Log(:,1), State_Log(:,4),'LineWidth', 2, 'Color', 'b');

grid on
title('$$U_{2}\,\,vs\,\,Time$$ ',...
      'fontsize',18, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 18, 'interpreter', 'latex')
ylabel('$U_{2}\,[(Volt)]$','fontsize', 18, 'interpreter', 'latex')
%%

%% Voltage on the RC Circuit ----------------------------------------------
f = figure;


plot(Output_Error(:,1), Output_Error(:,2), 'LineWidth', 2, 'Color', 'b');

grid on
title('$Terminal\,\,Output\,\,Error\,\,vs\,\,Time$ ',...
      'fontsize',18, 'fontweight','b', 'interpreter', 'latex')
xlabel('$Time\,[s]$','fontsize', 18, 'interpreter', 'latex')
ylabel('$e_{t}\,[(Volt)]$','fontsize', 18, 'interpreter', 'latex')

%%
