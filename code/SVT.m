%% FUNCTION: Singular Value Thresholding (SVT) Algorithm
%   Adapted from Algorithm.1 in https://arxiv.org/abs/0810.3286
%   INPUTS:
%       Y = matrix with entries Y_ij = y_ij if (i,j) is observed and 
%           Y_ij = 0 if (i,j) is not observed
%       omega = matrix with entries omega_ij = 1 if (i,j) is observed and
%               omega_ij = 0 if (i,j) is not observed
%       step = step size
%       epi = tolerance
%       tau = parameter
%       inc = increment
%       MAX_ITER = scalar, maximum number of iterations of algorithm
%
%   OUTPUTS:
%       X_hat = "completed" matrix.
%       iter = number of iterations elapsed.

function [X_hat, iter] = SVT(Y,omega,step,epi,tau,inc,MAX_ITER)
    X_hat = zeros(size(Y));
    %initialization
    k0 = ceil(tau/(step*norm(Y,2)));
    Yk = k0*step*Y; %Y0
    rk = 0; % r0
    %iteration
    for k = 1:MAX_ITER
        sk = rk + 1;
        [U,S,V] = svd(Yk,'econ');
        while sk <= min(length(U),length(V))
            sk = sk + inc;
            sig = diag(S);
            if sig(sk - inc) <= tau
                break
            end
        end
        rk = sum(sig>tau);
        S2 = diag(diag(S)-tau);
        X_hat = U(:,1:rk)*S2(1:rk,1:rk)*V(:,1:rk)';
        if norm((X_hat-Y).*omega,'fro')/norm(Y,'fro') <= epi
            break
        end
        Yk = omega.*(Yk+step*(Y-X_hat));
    end
    iter = k;
end