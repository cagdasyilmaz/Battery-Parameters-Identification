function RLS_Parameters = RC_Values_to_RLS_Parameters(RC_Values)

    % Sampling time of the system is T = 1
    T = 1;  % Take this value as an function argument when sampling time 
            % is changed
    
    
    % a = R_0;
    % b = R_1 * C_1 *R_2 * C*2;
    % c = R_1 * C_1 + R_2 * C_2;
    % d = R_0 + R_1 + R_2;
    % f = R_0 * R_1 *C_1 + R_0 * R_2 * C_2 + R_1 * R_2 * C_2 + R_2 * R_1 *C_1;
    
    a = RC_Values(1);
    b = RC_Values(2) * RC_Values(3) * RC_Values(4) * RC_Values(5);
    c = RC_Values(2) * RC_Values(3) + RC_Values(4) * RC_Values(5);
    d = RC_Values(1) + RC_Values(2) + RC_Values(4);
    f = RC_Values(1) * RC_Values(2) * RC_Values(3) + ...
        RC_Values(1) * RC_Values(4) * RC_Values(5) + ...
        RC_Values(2) * RC_Values(4) * RC_Values(5) + ...
        RC_Values(4) * RC_Values(2) * RC_Values(3);
    
   theta_1 = (8*b - 2*T^(2))/(4*b + 2*c*T + T^(2));  
   theta_2 = (4*c*T)/(4*b + 2*c*T + T^(2)) - 1;
   theta_3 = -1*(4*a*b + 2*f*T + d*T^(2))/(4*b + 2*c*T + T^(2));
   theta_4 = (8*a*b - 2*d*T^(2))/(4*b + 2*c*T + T^(2));
   theta_5 = -1*(4*a*b - 2*f*T + d*T^(2))/(4*b + 2*c*T + T^(2));
   
   %% Return this value as Recursive Least Square Parameters
   RLS_Parameters = [theta_1; theta_2; theta_3; theta_4; theta_5];
   
end