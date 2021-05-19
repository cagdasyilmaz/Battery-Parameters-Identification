function slope = Derivative_Of_OCV_SOC_Function(SOC)

    x = 0.01*SOC;

    % OCV = k0 - k1/x - k2*x + k3*log(x) + k4 * log(1-x)
    
    slope = 0.01763/(x^2) + 0.8426* - 0.08054/x + 0.00416 /(1-x);
     
    
end