clc;
clear all
close all;

load('BAT_data.mat');

%% Find the Charge, Discharge and Idle States 
 % Add a state of the battery 
i = -1 * i;
 
SoC(:,2) = 0; %% add initially all state is zero

for time_index = 1:length(t_vec)-1
    
    if( i(time_index) > 0 ) % battery is discharging
        SoC(time_index, 2 ) = -1;  
        
    elseif( i(time_index) < 0 ) % battery is charging
        SoC(time_index, 2 ) = 1;  
    
    else
         SoC(time_index, 2 ) = 0; % battery is iddle
    end
    
end 
%%

%% Adaptive Extended Kalman Filter Algorithm with Recursive Least Square
  
%Inital guess of circuit values comes from previous RLS
R_0 = 0.089; R_1 = 0.2802; C_1 = 2.135e+03;
R_2 = 0.00836; C_2 = 20.61;

RC_Values = [R_0; R_1; C_1; R_2; C_2];

% Get the initial parameter vector Look Eqn (25)
theta_vector = RC_Values_to_RLS_Parameters(RC_Values);

% Check the following function to calculcation are valid or not!
%RLS_Parameters_to_RC_Values(theta_vector);

delta = 0.01;
P_RLS = delta * eye(5);

% RC Vector
RC_Vector = [];

% Initially take U1 and U2 same and SOC from measurement   
SOC_init = 0.01 * SoC(1,1);
U_1 = (u(1) - OCV_SOC_Function(SoC(1,1)) - R_0 * i(1)) /2;
U_2 = U_1; % Indeed, U1 is not equal to U2, this is just initiation
x_prior_1 = [U_1; U_2; SOC_init];

% Initial State Covariance Matrix
P = [0 0 0; 0 0 0; 0 0 0];

% Initial process noise input with covariance
Q = [0.1 0 0; 0 0.1 0; 0 0 0.01];

% Coulumb efficiency
eta = 1;

% Total Capacity
Total_Capacity = 1129.4; %Ampere-Second 

% Number of Residual for Adaptive Law
M = 5;

%Adaptive Law H 
H = 0;

State_Log = []; % State_Log_Vector
Simulation_Output_Log = []; % Output With Simulation
Output_Error = []; % Terminal Voltage Error

% T represents the sampling time
T = 1;
for index = 1:1:length(i)
    
    %  Recursive Least Sqaure estimates Circuit Parameters
    if(index < 3)
        
        RC_Vector = [RC_Vector; index RC_Values'];
        
    else
        
        y_k_1 = u(index-1) - OCV_SOC_Function(SoC(index-1,1));
    
        y_k_2 = u(index-2) - OCV_SOC_Function(SoC(index-2,1));
     
        I_k = i(index);
    
        I_k_1 = i(index-1);
    
        I_k_2 = i(index-2);
    
        phi_vector = [y_k_1; y_k_2; I_k; I_k_1; I_k_2];
    
    
        % Calculate gain vector 
        K_RLS = P_RLS * phi_vector * ...
                        (phi_vector' * P_RLS * phi_vector + 1)^(-1);
    
        % Update estimation error covariance
        P_RLS = (eye(5) - K_RLS * phi_vector') * P_RLS;
    
        % Update the recursive least square paramater vector
        y_k = u(index) - OCV_SOC_Function(SoC(index,1));
                
        theta_vector = theta_vector + ...
                            K_RLS * (y_k - phi_vector' * theta_vector);
    
        RC_Values = RLS_Parameters_to_RC_Values(theta_vector);
        RC_Vector = [RC_Vector; index RC_Values'];
    end
    %

tau_1 = RC_Values(2)*RC_Values(3);
tau_2 = RC_Values(4)*RC_Values(5);
    
A_d = [exp(-T/tau_1) 0 0; ...
       0 exp(-T/tau_2) 0; ...
       0 0 1];

if( i(index) < 0 ) %charging
    eta = 0.95;
else
   eta = 1;        %discharging or zero terminal current
end

   
B_d = [RC_Values(2)*(1-exp(-T/tau_1)); ...
       RC_Values(4)*(1-exp(-T/tau_2)); ...
       -(eta*T)/Total_Capacity]; 

%State Estimation Propagation
x_priori = A_d * x_prior_1 + B_d * i(index);

%State Estimation Covariance
P = A_d * P * A_d' + Q;

%Error Innovation

y_k_sim = OCV_SOC_Function(SoC(index,1)) - x_priori(1) - x_priori(2) - ...
                                            RC_Values(1) * i(index);

terminal_voltage_error = u(index) - y_k_sim;

                
Output_Error = [Output_Error; index terminal_voltage_error];

if( length(Output_Error) < M + 1 )
    
    for j = 1:1:length(Output_Error(:,2))
        H = H + (1/M)*(Output_Error(j,2))^2;
    end
    
else
    
    for j = (length(Output_Error(:,2))- M + 1):1:length(Output_Error(:,2))
        H = H + (1/M)*(Output_Error(j,2))^2;
    end
    
end

% Matrix C
C_d = [-1 -1 Derivative_Of_OCV_SOC_Function(SoC(index,1))];

%measurements with noise covariance 
%R = H - C_d * P * C_d';  
R = 0.8;

% Kalman Gain Matrix
K = P * C_d' * (C_d * P * C_d' + R)^(-1);

%State Estimate Measurement Update
x_posteriori = x_priori + K * terminal_voltage_error;

%State Covariance Measurement Update
Q = K*H*K';

P = (eye(3) - K * C_d) * P * (eye(3) - K * C_d)' + K * R * K';

x_prior_1 = x_posteriori;

y_k_sim = OCV_SOC_Function(SoC(index,1)) - ...
            x_posteriori(1) - x_posteriori(2) - RC_Values(1) * i(index);

Simulation_Output_Log = [Simulation_Output_Log; index y_k_sim];                                         
                                        
State_Log = [State_Log; index x_posteriori'];

% At the end assign to residul value zero for new calculation
H = 0;
end
%%
