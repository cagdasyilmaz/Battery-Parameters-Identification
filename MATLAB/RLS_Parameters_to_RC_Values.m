function RC_Values = RLS_Parameters_to_RC_Values(theta_vector)

    % Sampling time of the system is T = 1
    T = 1;  % Take this value as an function argument when sampling time 
            % is changed
   
    a = (theta_vector(4) - theta_vector(3) - theta_vector(5)) / ...
            (1 + theta_vector(1) - theta_vector(2));
    
    b = (T^(2) * (1 + theta_vector(1) - theta_vector(2))) / ...
            (4 * (1 - theta_vector(1) - theta_vector(2)));
            
    c = (T * (1 + theta_vector(2))) / ...
            (1 - theta_vector(1) - theta_vector(2));
        
    d = (-1 * theta_vector(3) - theta_vector(4) - theta_vector(5)) / ...
            (1 - theta_vector(1) - theta_vector(2));

    f = (T * (theta_vector(5) - theta_vector(3))) / ...
            (1 - theta_vector(1) - theta_vector(2));
    
    % Time constant of the circuit
    tau_1 = (c + sqrt(c^2 - 4*b))/2;
    
    tau_2 = (c - sqrt(c^2 - 4*b))/2;
            
    R_0 = a;
    
    R_1 = (tau_1 * (d - a) + a * c - f) / (tau_1 - tau_2); 
    
    C_1 = tau_1 / R_1;
    
    R_2 = d - a - R_1;
    
    C_2 = tau_2 / R_2;
    
    
    % Return this value as RC Values at estimation time
    RC_Values = [R_0; R_1; C_1; R_2; C_2];
   
end