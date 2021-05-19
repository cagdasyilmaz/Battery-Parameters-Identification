clc;
clear all
close all;

load('BAT_data.mat');


%% Find the Charge, Discharge and Idle States 
 % Add a state of the battery 

 i = -1 * i;

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
