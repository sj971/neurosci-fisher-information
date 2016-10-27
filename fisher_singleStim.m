function [rmse, ThC, ThS] = fisher_singleStim(pars, data, paramType, plotting)
%function [rmse, ThC, ThS] = fisher_singleStim(pars, data, paramType, plotting)

if any(pars < 0)
    
    rmse = Inf;
    
else
    
    % set number of subpopulations and neurons per subpopulation
    npop = 8;
    N = round(256/npop);
      
    % create logorithmically-spaced c50 values
    cRange = [1e-2 3];
    logCRange = log10(cRange);
    logContrasts = linspace(logCRange(1), logCRange(2), npop);
    c50 = 10.^logContrasts;
            
    % set other relevant parameters
    a = 0; % set baseline to zero
    switch paramType
        case 'constant'
            
            % set tuning parameters
            k_b = pars(1);
            k_n = pars(2);
            gamma = pars(3);
            
            % create constant b/n vectors
            b = k_b * ones(size(logContrasts));
            n = k_n * ones(size(logContrasts));
            
        case 'expansive'
            
            % set tuning parameters
            k_b = pars(1); % scale on beta
            k_n = pars(2); % scale on exponent
            gamma = pars(3);
            m_b = pars(4); % power on beta (range: 0:5)
            m_n = pars(5); % power on exponent (range: 0:5)
            
            % create expansive b/n vectors
            b = k_b * exp(m_b * logContrasts);
            n = k_n * exp(m_n * logContrasts);

    end
    
    % prepare orientation tuning function indices
    jkl = 0:(N-1); % neuron indices
    phi = (2*pi*jkl/N) - pi; % preferred directions of neurons (-pi:pi)
    s = 0.0;
    
    % pedestals
    if plotting % full curve for plots
        
        c = (0.02:0.01:0.8)';
        
    else % for running optimization
        
        c = [.02 .1 .2 .4 .8]';
        
    end
         
    % compute orientation tuning functions
    h = cell(1, npop);
    hprime = cell(1, npop);
    for np = 1:npop
        
        [h{np}, hprime{np}] = compute_h_hprime(s, phi, a, b(np), gamma);
     
    end;
    
    % prepare variables for storing model thresholds
    CVarMat  = zeros(1, length(c));
    SVarMat  = zeros(1, length(c));
    
    % run through each stimulus condition
    for ii = 1:length(c)
        
        % calculate FIM (2x2) for this condition
        JMAT = zeros(2, 2, npop);
        
        for np = 1:npop
            
            parsThisPop = [n(np) c50(np)];
            [g, gprime] = compute_g_gprime(c(ii), parsThisPop);
            common_denom = (h{np} * g);
            
            JMAT(1, 1, np) = sum( (h{np} * gprime).^2 ./ common_denom );           
            JMAT(1, 2, np) = sum( ( (h{np} * gprime) .* (hprime{np} * g) ) ./ common_denom );            
            JMAT(2, 1, np) = sum( ( (hprime{np} * g) .* (h{np} * gprime) ) ./ common_denom );           
            JMAT(2, 2, np) = sum( (hprime{np} * g).^2 ./ common_denom );
            
        end;
        
        % calculate covariance matrix and save diagonal entries
        cvMat       = inv(sum(JMAT, 3));
        CVarMat(ii) = cvMat(1, 1);
        SVarMat(ii) = cvMat(2, 2);
        
    end;
    
    % scale for cumulative Gaussian approximation of sigma (see Weiji's
    % notes)
    scaleForFI = erfinv(0.5)*sqrt(2);

    % calculate thresholds etc.
    if plotting % full curve for plots
        
        % calculate model thresholds
        ThC = sqrt(CVarMat)*scaleForFI;
        ThS = sqrt(SVarMat)*scaleForFI;
        ThS = ThS/2; % map to -(pi/2):(pi/2), as this is the measured thresholds space (see notes)
        rmse = 0;
        
    else % for running optimization
        
        % calculate model thresholds and SE
        ThC = sqrt(CVarMat)*scaleForFI; % model
        data_c = data{1}; % data
        SE_c = (data_c - ThC).^2;
        ThS = sqrt(SVarMat)*scaleForFI;
        ThS = ThS/2; % map to -(pi/2):(pi/2), as this is the measured thresholds space (see notes)
        data_s = data{2};
        SE_s = (data_s - ThS).^2;
        
        % compute overall rmse
        rmse = sqrt(mean([SE_c SE_s]));
    
    end
    
end