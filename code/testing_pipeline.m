%% FUNCTION: TESTING_PIPELINE
%   INPUTS:
%       parameters  = (STRUCT) set of sweep parameters
%           -sweep_type     (STRING) parameter to swept
%               -'dim': Dimension of matrix X. Only available for square
%               matrices at the moment.
%               -'rank': Rank of true (latent) matrix
%               -'frac': Fraction of observed entries
%           -sweep_range    (VECTOR OF POS REALS) The values we want the sweep
%                           parameter to take
%           -MC             (POS INTEGER) The number of trials we run for
%                           each entry in sweep_range
%           -size_X         (POS INTEGER) Size of matrix X (square matrices only)   
%                           ONLY USED IF sweep_type =/= 'dim'
%           -r              (POS INTEGER) Rank of matrix X
%                           ONLY USED IF sweep_type =/= 'rank'
%           -frac           (REAL NUMBER IN [0,1]) Fraction of observed
%                           entries of X
%                           ONLY USED IF sweep_type =/= 'frac'
%           -mag            (REAL NUMBER) "Magnitude" of latent matrix X
%                           generated - controls order of magnitude of the
%                           entries of X
%           -noise          (POS REAL) The variance of the additive 
%                           Gaussian noise in our observations
%           -K              Guess for true rank of X
% 
%       solver  = (STRUCT) set of solver parameters
%           -type           (STRING) Type of solver used. 
%               -'LRMC': Uses the LRMC.m file. 
%           NOT YET IMPLEMENTED    -'PGD': Uses the PGD.m file
%           -threshold      (STRUCT) threshold strut needed for LRMC
%           -max_iter       (POS INTEGER) Maximum number of iterations for
%                           solver
% 
%   OUTPUTS:
%       err_v   = (MATRIX, SIZE MC x length(sweep_range)). Matrix of
%                   normalized frobenius errors. Column i is MC errors 
%                   for fixed sweep_range(i)

function err_v = testing_pipeline(parameters, solver)
 
    %Define anon. function to compute the normalized frobenius error
    cmp_err = @(X, X_hat) norm(X - X_hat, 'fro')^2 / norm(X, 'fro')^2;
    
    %Pull items from parameters struct for ease of use later
    %Check sweep_type and only pull necessary/compatible parameters
    sweep_range = parameters.sweep_range;
    if(strcmp(parameters.sweep_type, 'dim'))
        r = parameters.r;
        frac = parameters.frac; 
    elseif(strcmp(parameters.sweep_type, 'rank'))
        size_X = parameters.size_X;
        frac = parameters.frac;
    elseif(strcmp(parameters.sweep_type, 'frac'))
        size_X = parameters.size_X;
        r = parameters.r;
    end
    mag = parameters.mag;
    rand_type = parameters.rand_type;
    noise = parameters.noise;
    
    %Define error matrix and sweep across each parameter.
    err_v = zeros(parameters.MC, length(sweep_range));
    for i = 1:length(sweep_range)
        %For a fixed parameter, perform MC trials
        for mc = 1:parameters.MC
            %Generate data according to which parameter is being swept
            %Guess for rank of X is fixed to 3 (CHANGE LATER!)
            if(strcmp(parameters.sweep_type, 'dim')) 
                [Y, M, X] = generate_data(sweep_range(i), r, mag, rand_type, frac, noise);
            elseif(strcmp(parameters.sweep_type, 'rank'))
                [Y, M, X] = generate_data(size_X, sweep_range(i), mag, rand_type, frac, noise);
            elseif(strcmp(parameters.sweep_type, 'frac'))
                [Y, M, X] = generate_data(size_X, r, mag, rand_type, sweep_range(i), noise);
            end
            
            %Check which solver to use
            if(strcmp(solver.type, 'LRMC'))
                [X_hat, ~] = LRMC(Y, M, parameters.K, solver.threshold, solver.max_iter);
            elseif(strcmp(solver.type, 'PGD'))
                [X_hat, ~] = PGD(Y, M); %FILL IN THIS LINE WHEN PGD IS DONE
            end
            
            %store error from mc-th trial
            err_v(mc, i) = cmp_err(X, X_hat); 
        end
    end
    
    
end