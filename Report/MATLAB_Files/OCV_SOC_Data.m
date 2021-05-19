load('BAT_data.mat');

%% Find Open Circuit Voltage (OCV)
%  Obtain the the interval when circuit discharging with Q/3
%  Obtain the the interval when circuit charging with Q/3
%  then take the value of SoC and u at the time

% This matrix includes time, SoC, and OCV when current is zero 

SOC_OCV_Discharge = [t_vec(9761:17818) SoC(9761:17818,1) u(9761:17818)];

SOC_OCV_Charge = [t_vec(17819:25820) SoC(17819:25820,1) u(17819:25820)];


if min(SOC_OCV_Discharge(:,2)) > min(SOC_OCV_Charge(:,2))
    SOC_x_min = min(SOC_OCV_Discharge(:,2));
else
    SOC_x_min = min(SOC_OCV_Charge(:,2));
end

if max(SOC_OCV_Discharge(:,2)) > max(SOC_OCV_Charge(:,2))
    SOC_x_max = max(SOC_OCV_Charge(:,2));
else
    SOC_x_max = max(SoC_OCV_Discharge(:,2));
end

 % Create Vector Of Common X-Values
OCV_SOC_x = linspace(SOC_x_min, SOC_x_max, 8000);  

% Interploate To New Values For Discharging
OCV_SOC_y_Disc = interp1(SOC_OCV_Discharge(:,2), ...
                         SOC_OCV_Discharge(:,3), OCV_SOC_x(:), 'spline', ...
                         'extrap'); 
                     
% Interploate To New Values For Charging                     
OCV_SOC_y_Charge = interp1(SOC_OCV_Charge(:,2), ...
                         SOC_OCV_Charge(:,3), OCV_SOC_x(:), 'spline', ...
                         'extrap'); 

% Mean Of Y Values
OCV_SOC_y_mean = mean([OCV_SOC_y_Disc OCV_SOC_y_Charge], 2);                            

% Axes for Curve Fitting Application 
SoC_OCV_x_axis =  0.01 * OCV_SOC_x;
SoC_OCV_y_axis =  OCV_SOC_x;
%%                        

