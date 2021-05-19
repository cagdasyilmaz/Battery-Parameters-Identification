function OCV = OCV_SOC_Function(SOC)

    x = 0.01*SOC;

    %OCV = k0 - k1/x - k2*x + k3*log(x) + k4 * log(1-x)
    
    OCV = 3.326 - 0.01763/x + 0.8426*x - 0.08054*log(x) - ...
         0.00416*log(1-x);
    
end