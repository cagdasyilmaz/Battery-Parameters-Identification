clc;
clear all
close all;

load('BAT_data.mat');


%% Find the Charge, Discharge and Idle States 
 % Add a state of the battery 

i = -1 * i;
 
SoC(:,2) = 0; %% add initially all state is zero

for time_index = 1:length(t_vec)
    
    if( i(time_index) > 0 ) % battery is discharging
        SoC(time_index, 2 ) = -1;  
        
    elseif( i(time_index) < 0 ) % battery is charging
        SoC(time_index, 2 ) = 1;  
    
    else
         SoC(time_index, 2 ) = 0; % battery is iddle
    end
    
end 
%%

%% Determine First Discharge Region and Find Charge Capacity as Ah
select_first_discharge = [];

for time_index = 2:length(t_vec)-1
    
    if SoC(time_index,2) == -1
        % Calculate cell nominal capacity
        % Coulombic efficiency (eta) taken as one for discharging
        
        eta = 1;
        delta_t = t_vec(time_index) - t_vec(time_index-1); 
        
        nominal_capacity = (i(time_index-1) * eta * delta_t ) / ...
                 (0.01 * (SoC(time_index-1,1) - SoC(time_index,1))); 
        
        select_first_discharge = [select_first_discharge; ...
              time_index i(time_index) SoC(time_index,1) nominal_capacity];
    end
        
    if SoC(time_index-1,2) == -1 && SoC(time_index,2) ~= -1 
        break
    end

end

% Q => 1129.4 Ampere-Second
% Q => 313.7 maH | 0.3137 Ah

%%

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

% Interploate Or Extrapolate To New ‘x’ Values
OCV_SOC_y_Disc = interp1(SOC_OCV_Discharge(:,2), ...
                         SOC_OCV_Discharge(:,3), OCV_SOC_x(:), 'spline', ...
                         'extrap'); 
                     
% Interploate Or Extrapolate To New ‘x’ Values                     
OCV_SOC_y_Charge = interp1(SOC_OCV_Charge(:,2), ...
                         SOC_OCV_Charge(:,3), OCV_SOC_x(:), 'spline', ...
                         'extrap'); 

% Mean Of Y Values
OCV_SOC_y_mean = mean([OCV_SOC_y_Disc OCV_SOC_y_Charge], 2);                            

% Axes for Curve Fitting Application 
SoC_OCV_x_axis =  0.01 * OCV_SOC_x;
SoC_OCV_y_axis =  OCV_SOC_x;
%%

%% Determination of the Parameters Identification Region
%  Constant discharge pulse start at t =  28785 sec
%  Then this pulse ends at t = 31109 sec and a rest period start
%  Battery stayes at rest until t = 32908 sec  

Param_Identification_Vec =  [t_vec(28784:32909) i(28784:32909) ...
                             SoC(28784:32909,1) u(28784:32909)];
                        
                         
% INITIALIZATION
% ************************************************************************* 
%Inital guess of circuit values comes from "main_depracated.m"
R_0 = 0.1402; R_1 = 0.1152; tau_1 = 3.2236;
R_2 = 0.1136; tau_2 = 2.4826;

C_1 = tau_1 / R_1; C_2 = tau_2 / R_2; % capacitor values

RC_Values = [R_0; R_1; C_1; R_2; C_2];

% Get the initial parameter vector Look Eqn (25)
theta_vector = RC_Values_to_RLS_Parameters(RC_Values);

% Check the following function to calculcation are valid or not!
RLS_Parameters_to_RC_Values(theta_vector);

% initial estimation error covariance  
% Take P vector as large as big 
% http://www.cs.tut.fi/~tabus/course/ASP/LectureNew10.pdf (page - 8)

delta = 10e10;
P = delta * eye(5);
% *************************************************************************

% ESTIMATION ALGORITM
% *************************************************************************
% Take two sample before 

% RC Vector
RC_Vector = [];

for index = 3:1:length(Param_Identification_Vec(:,1))
    
    y_k_1 = Param_Identification_Vec(index-1,4) - ...
                OCV_SOC_Function(Param_Identification_Vec(index-1,3));
    
    y_k_2 = Param_Identification_Vec(index-2,4) - ...
                OCV_SOC_Function(Param_Identification_Vec(index-2,3));
     
    I_k = Param_Identification_Vec(index,2);
    
    I_k_1 = Param_Identification_Vec(index-1,2);
    
    I_k_2 = Param_Identification_Vec(index-2,2);
    
    phi_vector = [y_k_1; y_k_2; I_k; I_k_1; I_k_2];
    
    
    % Calculate gain vector 
    K = P * phi_vector * (phi_vector' * P * phi_vector + 1)^(-1);
    
    % Update estimation error covariance
    P = (eye(5) - K * phi_vector') * P;
    
    % Update the recursive least square paramater vector
    y_k = Param_Identification_Vec(index,4) -...
            OCV_SOC_Function(Param_Identification_Vec(index,3));
                
    theta_vector = theta_vector + K * (y_k - phi_vector' * theta_vector);
    
    RC_Vector = [RC_Vector; Param_Identification_Vec(index,1) ...
        RLS_Parameters_to_RC_Values(theta_vector)'];
    
end
% *************************************************************************

% Remove first and second rows of the vector
Param_Identification_Vec(1:2,:) = [];

%%

Plotter