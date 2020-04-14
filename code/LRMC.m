%% FUNCTION: LRMC 
%   Adapted from chapter 9 of https://web.eecs.umich.edu/~fessler/course/551/f19-eecs551-notes-final.pdf
%   INPUTS:
%       Y = matrix with entries Y_ij = y_ij if (i,j) is observed and 
%           Y_ij = 0 if (i,j) is not observed
%       M = matrix with entries M_ij = 1 if (i,j) is observed and M_ij = 0
%           and M_ij = 0 if (i,j) is not observed
%       K = scalar, guess at rank of matrix
%       threshold = struct with the following entries
%           threshold.type = string with 3 choices:
%               -"POCS_noiseless" - assumes the observed entries are
%               noiseless and implements projection onto convex sets (POCS)
%               -"nuc_norm" - assumes noise and implements a nuclear norm
%               regularized descent.
%               -"exact_rank" - assumes noise and implements a rank
%               regularized descent.
%           threshold.beta = scalar - ONLY NEEDED IF "nuc_norm" or
%           "exact_rank" type selected.
%               -Controls the effect of nuclear norm/exact rank
%               regularization
%       max_iter = scalar, maximum number of iterations of algorithm
%
%   OUTPUTS:
%       X_hat = "completed" matrix.
%       iter = number of iterations elapsed.

function [X_hat, iter] = LRMC(Y, M, K, threshold, max_iter)
    iter = 0;
    X_hat = zeros(size(Y));
    
    while(iter < max_iter)
        X_hat(M) = Y(M);
        [U,s,V] = svd(X_hat);
        if (threshold.type == "POCS_noiseless")
            X_hat = U(:,1:K)*s(1:K, 1:K)*V(:,1:K)';
        elseif(threshold.type == "nuc_norm")
            X_hat = U*soft(s,threshold.beta)*V';
        elseif(threshold.type == "exact_rank")
            X_hat = U*hard(s,threshold.beta)*V';
        end
        
        
        iter = iter + 1;
    end
end

function s_hard = hard(s, beta)
    s_hard = s - sqrt(2*beta);
    s_hard = s_hard .* (s_hard > 0);
end

function s_soft = soft(s, beta)
    s_soft = s - beta;
    s_soft = s_soft .* (s_soft > 0);
end