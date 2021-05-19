clc;
clear all
close all;

load('BAT_data.mat');


% %% Find the Charge, Discharge and Idle States 
%  % Add a state of the battery 
% 
%  i = -1 * i;
%  
% SoC(:,2) = 0; %% add initially all state is zero
% 
% for time_index = 1:length(t_vec)-1
%     
%     if( i(time_index) > 0 ) % battery is discharging
%         SoC(time_index, 2 ) = -1;  
%         
%     elseif( i(time_index) < 0 ) % battery is charging
%         SoC(time_index, 2 ) = 1;  
%     
%     else
%          SoC(time_index, 2 ) = 0; % battery is iddle
%     end
%     
% end 
% %%
% 
% %% Determine First Discharge Region and Find Charge Capacity as Ah
% select_first_discharge = [];
% 
% for time_index = 2:length(t_vec)-1
%     
%     if SoC(time_index,2) == -1
%         % Calculate cell nominal capacity
%         % Coulombic efficiency (eta) taken as one for discharging
%         
%         eta = 1;
%         delta_t = t_vec(time_index) - t_vec(time_index-1); 
%         
%         nominal_capacity = (i(time_index-1) * eta * delta_t ) / ...
%                  (0.01 * (SoC(time_index-1,1) - SoC(time_index,1))); 
%         
%         select_first_discharge = [select_first_discharge; ...
%               time_index i(time_index) SoC(time_index,1) nominal_capacity];
%     end
%         
%     if SoC(time_index-1,2) == -1 && SoC(time_index,2) ~= -1 
%         break
%     end
% 
% end
% 
% % Q => 1129.4 Ampere-Second
% % Q => 313.7 maH | 0.3137 Ah
% 
% %%
% 
% %% Find Open Circuit Voltage (OCV)
% %  Obtain the the time when current zero
% %  then take the value of SoC and u at the time
% 
% % This matrix includes time, SoC, and OCV when current is zero 
% 
% % Charging 
% %SoC_OCV_Charging = [];
% 
% % Discharging
% %SoC_OCV_Discharging = [];
% 
% SoC_OCV = [];
% 
% for time_index = 1:length(t_vec)-1
% 
%     if( i(time_index) == 0 ) %% current is zero
%         
% %        if( SoC(time_index) < SoC(time_index + 1) )
% %        
% %            SoC_OCV_Charging = [SoC_OCV_Charging; ...
% %                                t_vec(time_index) SoC(time_index,1) u(time_index)];
% %            
% %        end
%        
% %        if( SoC(time_index) >= SoC(time_index + 1) )
% %            
% %            SoC_OCV_Discharging = [SoC_OCV_Discharging; ...
% %                                t_vec(time_index) SoC(time_index,1) u(time_index)];
% %        end
%        
%        SoC_OCV = [SoC_OCV; t_vec(time_index) SoC(time_index,1) u(time_index)];
%     
%     end
%     
% end 
% 
% SoC_OCV_x_axis =  0.01 * SoC_OCV(:,2);
% SoC_OCV_y_axis =  SoC_OCV(:,3);
% 
% %%

%% Determination of the Parameters Identification Region
%  Constant discharge pulse start at t =  28785 sec
%  Then this pulse ends at t = 31109 sec and a rest period start
%  Battery stayes at rest until t = 32908 sec  

Param_Identification_Vec =  [t_vec(28786:32909) -1*i(28786:32909) ...
                             SoC(28786:32909,1) u(28786:32909)];


%% Least Square Programming - YALMIP Configuration 

%ops = sdpsettings('solver', 'mosek', 'verbose', 0, 'debug', 0);
ops = sdpsettings('solver', 'fmincon', 'verbose', 1, 'debug', 1);
%ops = sdpsettings('solver', 'gurobi', 'verbose', 0, 'debug', 0);                         

yalmip('clear');
Theta = sdpvar(5,1,'full');

Constraints = [zeros(5,1) <= Theta <= Inf*ones(5,1)];
objective = 0;

state_vector_x = [0;0];


for index = 1:1:100 %length(Param_Identification_Vec(:,1))
    
    
    U_t_sim = OCV_SOC_Function(Param_Identification_Vec(index,3)) ...
                - [1 1] * state_vector_x ...
                - Theta(1) * Param_Identification_Vec(index,2);
   
    state_vector_x = ...
        [exp(-1/Theta(3)) 0; 0 exp(-1/Theta(5))] * state_vector_x + ...
        [Theta(2)*(1-exp(-1/Theta(3))); Theta(4)*(1-exp(-1/Theta(3)))] ...
                                    * Param_Identification_Vec(index,2);                            
    
   objective = objective + (Param_Identification_Vec(index,4)-U_t_sim)^2;
 
end

OPT = optimize(Constraints, objective, ops);
value(Theta(:,1))
                         
%%
%Plotter