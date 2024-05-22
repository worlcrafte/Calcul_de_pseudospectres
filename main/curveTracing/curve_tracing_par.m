function [eigen_values,points] = curve_tracing_par(A,epsilon,d0,tol_Newton, tol_turn,thread,step)
% input : 
%       - A         : The matrix for which to analyze the pseudospectrum 
%       - epsilon   : The perturbation level 
%       - d0        : The first point direction
%       - tol_Newton: Relative accuracy for Newton s method
%       - tol_turn  : Relative accuracy for stopping criterium
%       - thread    : Number of cores used
%       - step      : steplength in prediction correction algorithm
% output :
%       - eigen_values   : The eigen values of A
%       - points         : The "shape" of the peseudo spectra
% Explanation :
%          Compute the pseudo spectra with a given matrix.
%
   
    eigen_values = eig(A);
    %pred = zeros(numel(eigen_values),1);
    [siz,~] = size(eigen_values);
    points = cell(1,siz);

    ppm = ParforProgressbar(siz,'showWorkerProgress', true);
    parfor (lambda0=1:siz,thread)
        
        points{lambda0} = Prediction_correction(A,epsilon, eigen_values(lambda0), d0, tol_Newton, tol_turn,step);

        ppm.increment();
    end

    delete(ppm);
end

function points = Prediction_correction(A, epsilon, lambda0, d0, tol_Newton, tol_turn,step)
% input : 
%       - A         : The matrix for which to analyze the pseudospectrum 
%       - epsilon   : The perturbation level 
%       - lambda0   : epsilon-pseudoeigenvalue of A. The eigen value chosen
%       - d0        : The first point direction
%       - tol_Newton: Relative accuracy for Newton s method
%       - tol_turn  : Relative accuracy for stopping criterium
%       - step      : steplength in prediction correction algorithm
% output :
%       - points    : All the points that have been computed.
% Explanation :
%           For a given eigen value, compute the pseudo spectra.
%

    disp("lambda : ");
    disp(lambda0);
    disp("fin");
    % Step 0: Compute the first point z1
    theta0 = epsilon;
    z1_new = lambda0 + 0.5*theta0 * d0;
    Id = eye(size(A));   
    [~, s_min, ~] = svds(z1_new .* Id - A, 1, 'smallest'); % g(z_new)
    
    % Newton iteration for the first point
    disp("g(z_new) computed")
    k=1;


    while abs(s_min - epsilon) / epsilon > tol_Newton
        z1_old = z1_new;
        % compute the singular triplet for z1_old * I - A
        [u_min, s_min, v_min] = svds(z1_old .* Id - A, 1, 'smallest');
        % compute the next Newton iterate z1_new (equation 2.2)
        theta = (s_min - epsilon)/real(conj(d0) * v_min' * u_min);
        z1_new = z1_old - theta * d0; 
        k=k+1;
        if k >= 50 
           z1_new = z1_old - tol_Newton*theta * d0;
        end
    end
    disp("Newton done")
    z1 = z1_new;
    points = z1;
    first_point = z1;
    % computing subsequent points
    k=0;
    while 1
        
        % step 1: Prediction
        [u_min, ~, v_min] = svds(z1 * Id - A, 1, 'smallest');
        rk = 1i*v_min' * u_min / abs(v_min' * u_min); % check
        % determine the steplength tau
        tau = step; 
        zbar_k = z1 + tau * rk; 

        % step 2: Correction (via one Newton step)
        % compute the singular triplet for zbar_k * I - A   
        [u_min, s_min, v_min] = svds(zbar_k * Id - A, 1, 'smallest');
        % compute the corrected point z_k (equation 2.3)
        z_k = zbar_k - (s_min-epsilon)/(u_min' * v_min);
        
        points = [points z_k];
        z1 = z_k;
        if abs(z1-first_point)<=tol_turn
            break
        end
        % If we are between 2 components and the algorithm is stuck, we
        % stop it.
        if k>1000
            disp("break");
            disp(lambda0);
            break
        end
        k=k+1;
    end
    disp("finished");
end