%% FUNCTION: svt 
%   Singular value thresholding algorithm for low-rank matrix completion.
%   INPUTS:
%       Y = matrix with entries Y_ij = y_ij if (i,j) is observed and 
%           Y_ij = 0 if (i,j) is not observed
%       M = matrix with entries M_ij = 1 if (i,j) is observed and M_ij = 0
%           and M_ij = 0 if (i,j) is not observed
%       tau = value of threshold for singular values
%       increment = increments number of singular vectors to compute
%       step_size = gradient descent step size
%       tol = tolerance stopping condition
%       max_iter = scalar, maximum number of iterations of algorithm
%
%   OUTPUTS:
%       X_hat = "completed" matrix.
%       iter = number of iterations elapsed.

function [x_hat, iter] = svt(Y, M, tau, increment, step_size, tol, max_iters)

    % Determine k_0 as defined in algorithm description.
    k_0 = ceil(tau / (step_size * norm(Y)));
    
    % Store Frobenius norm of input data matrix - used to check early
    % termination conditions on every iteration.
    data_norm = norm(Y);
    
    % Set some starting conditions.
    y_k = k_0 * step_size * Y;
    r_k = 0;
    
    for k = 1:max_iters
        
        % Turns out incremental SVD's in MATLAB are hard - compute full SVD
        % for the time being.
        [u, s, v] = svd(y_k);
        
        % Find index of smallest eigenvalue that still meets threshold.
        r_k = 1;
        while r_k < size(s, 1) && s(r_k + 1, r_k + 1) > tau
           r_k = r_k + 1;
        end
        
        % Compute rank r_k approximation of Y_k (normalized by threshold).
        
        % Normalize singular values above threshold and zero out those
        % below.
        for i = 1:r_k
            s(i, i) = s(i, i) - tau;
        end
        
        for i = r_k+1:size(s, 1)
            s(i, i) = 0;
        end
        
        
        % Reconstruct based on new singular values.
        x_k = u * s * v';
        
        % Check for early stopping conditions.
        if norm(x_k(M) - Y(M)) / data_norm <= tol
            break
        end
        
        % Update Y_k and zero out appropriate entries.
        y_k = y_k + step_size * (Y - x_k);
        y_k(~M) = 0;
        
    end
    
    % Set outputs.
    x_hat = x_k;
    iter = k;
    
end