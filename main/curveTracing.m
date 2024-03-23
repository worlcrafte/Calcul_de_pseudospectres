function [points] = curveTracing(A, epsilon, K, lambda0, d0, tol)
% input : 
%       - A: 
%       - epsilon: 
%       - K: 
%       - lambda0: 
%       - d0: 
%       - tol: 
% Explanation :
%   
    %syms z;
    %g = min(svd(Z(k)*eye(n) - A))
    
    % Step 0: Compute the first point z1
    theta0 = epsilon;
    z1_new = lambda0 + theta0 * d0;
    [~, s_min, ~] = svds(z1_new * eye(size(A)) - A, 1, 'smallest'); % g(z)
    % Newton iteration for the first point
    while abs(s_min - epsilon) / epsilon > tol
        z1_old = z1_new;
        % compute the singular triplet for z1_old * I - A
        [u_min, s_min, v_min] = svds(z1_old * eye(size(A)) - A, 1, 'smallest');
        % compute the next Newton iterate z1_new (equation 2.2)
        theta = (s_min - epsilon)/real(conj(d0) * conj(v_min) * u_min);
        z1_new = z - theta * d0;
    end
    
    z1 = z1_new;
    points = z1;
    
    % computing subsequent points
    for k = 2:K
        % step 1: Prediction
        [u_min, ~, v_min] = svds(z1 * eye(size(A)) - A, 1, 'smallest');
        r = conj(v_min) * u_min / abs(conj(v_min) * u_min); % check
        % determine the steplength tau
        tau = 0.1; % i fix steplength on 0.1, result must be correct. might change later.
        zbar_k = z1 + tau * r;

        % step 2: Correction (via one Newton step)
        % compute the singular triplet for zbar_k * I - A
        [u_min, s_min, v_min] = svds(zbar_k * eye(size(A)) - A, 1, 'smallest');
        % compute the corrected point z_k (equation 2.3)
        z_k = zbar_k - (s_min-epsilon)/(conj(u_min) * v_min);
        
        points = [points z_k];
        z1 = z_k;
    end
end