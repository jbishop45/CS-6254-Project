%% FUNCTION: generate_data
%   INPUTS:
%       size_X  = (2 x 1 INT) or (1 x 1 INT) size of the matrix to be generated. 
%           size_X(1) = number of rows 
%           size_X(2) = number of cols
%       r       =  (INT) rank of matrix to be generated
%       mag     =  (REAL NUMBER) "magiance" of the data to be generated. 
%                   Essentially the magnitude of random matrix to be generated
%       type    =  (STRING) how the random matrix is generated
%           -'UAR' = uniformly at random. [rand] used
%           -'Gaussian' = Gaussian. [randn] used
%       frac    =  (REAL NUMBER IN [0,1]) roughly the fraction of entries of 
%                   Y to be observed.
%       noise   =  magiance the additive Gaussian noise
%
%   OUTPUTS:
%       Y = matrix with entries Y_ij = y_ij if (i,j) is observed and 
%           Y_ij = 0 if (i,j) is not observed
%       M = matrix with entries M_ij = 1 if (i,j) is observed and M_ij = 0
%           and M_ij = 0 if (i,j) is not observed
%       X = true underlying matrix 

function [Y, M, X] = generate_data(size_X, r, mag, type, frac, noise)
    %Get size of matrix
    if(length(size_X) == 1)
        D1 = size_X;
        D2 = size_X;
    else
        D1 = size_X(1);
        D2 = size_X(2);
    end
    
    %Check how we want to generate X. Use [rand]/[randn] appropriately
    X = zeros(D1, D2);
    if(strcmp(type, 'UAR'))
        X = mag*rand(D1, r)*rand(r, D2);
    elseif (strcmp(type, 'Gaussian'))
        X = mag*randn(D1, r)*rand(r, D2);
    end
    
    %Create a mask and take roughly "frac" of the entries. Equivalent to
    %Bernoulli sampling each entry to see if it observed or not.
    M = rand(D1, D2);
    M(M > frac) = 1;
    M(M < frac) = 0;
    M = logical(1 - M);
    
    %Generate the observed data with element-wise multiplication
    Y = M .* X + sqrt(noise)*randn(D1, D2);
end