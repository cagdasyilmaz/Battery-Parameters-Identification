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
% Q => 313.7 mAh | 0.3137 Ah
%%

