function run_fisher_singleStim(runNumber, paramType, saveOutput, analysisdirname)
% function run_fisher_singleStim(runNumber, paramType, saveOutput, analysisdirname)
%
% Input:
%   runNumber:           index of this run
%   paramType:           'constant' or 'expansive' (see May, 2015)
%   saveOutput:          0 or 1
%   analysisdirname:     analysis directory
%
% Output:
%   pars, rmse and model thresholds are appended to a .mat file


%% 1. Load data and set general parameters

% general parameters
nObservers = 7;

% load data
%cd(fullfile(analysisdirname, '/mat_files/psychophysics')) % for laptop
%cd(fullfile(analysisdirname, '/data')) % for HPC
dat_c_singleStim = load('thresholds_c_singleStim.mat');
dat_s_singleStim = load('thresholds_s_singleStim.mat');
%cd(analysisdirname)

% prepare variables for storing fit info
pars = [];
ThC = [];
ThS = [];
ThC_full = [];
ThS_full = [];
rmse = [];

% save random state for record
rng('default');
seedThisRun = sum(100*clock+runNumber);
rng(seedThisRun);


%% 2. Run stochastic search for individual observers

% get thresholds
for subjid = 1:7
    
    data_c_singleStim(subjid, :) = dat_c_singleStim.fitDat{subjid}.threshold_75;
    data_s_singleStim(subjid, :) = pi*(dat_s_singleStim.fitDat{subjid}.threshold_75)./180; %convert to radians
    
end;

% run fits for each observer and to mean
for subjid = 1:nObservers
    
    % select data to fit
    data{1} = data_c_singleStim(subjid, :);
    data{2} = data_s_singleStim(subjid, :);
   
    % set parameter bounds for search
    switch paramType
        case 'constant'
            
            % b, n, gamma
            opts.LBounds     = [1    0.1  0.1]';
            opts.UBounds     = [100  4    6  ]';
            
        case 'expansive'
            
            % k_b, k_n, gamma, m_b, m_n
            opts.LBounds     = [1    0.1  0.1  0   0]';
            opts.UBounds     = [100  4    6    5   5]';
            
    end
    
    % set some general constraints (recommended by L. Acerbi and Hansen/cmaes.m)
    pars_x0 = [opts.LBounds + 0.25 * (opts.UBounds - opts.LBounds) + rand(size(opts.LBounds)) .* (0.5 * (opts.UBounds - opts.LBounds))];
    pars_sigma = (opts.UBounds - opts.LBounds)/3;
    opts.SaveVariables = 'off';
    opts.LogModulo = 0;
    
    % find parameters that minimize RMSE using cmaes.m
    tic
             
    pars(subjid, :) = cmaes('fisher_singleStim', pars_x0, pars_sigma, opts, data, paramType, 0);
    [rmse(subjid), ThC(subjid, :), ThS(subjid, :)] = fisher_singleStim(pars(subjid, :), data, paramType, 0);
    [~, ThC_full(subjid, :), ThS_full(subjid, :)] = fisher_singleStim(pars(subjid, :), data, paramType, 1);
    
    toc
    
end;

% save to .mat file
if saveOutput == 1
    
    %cd(fullfile(analysisdirname, '/mat_files/model_fits')) % for laptop
    %cd(fullfile(analysisdirname, '/model_fits')) % for HPC
   
    filename = strcat('run', int2str(runNumber), '_singleStim_', paramType);
    save(filename, 'pars', 'rmse', 'ThC', 'ThS', 'ThC_full', 'ThS_full', 'seedThisRun');
    
    %cd(analysisdirname)
    
end;
