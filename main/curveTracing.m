

function curveTracing(A,epsilon,d0,tol)
    
    %[~, s_min, ~] = svd(A);

    %s = diag(s_min);
    s = eig(A);
    figure();
    hold on;
    i=1;
    for lambda0=s.'
        disp(i);
        points = Prediction_correction(A,epsilon, lambda0, d0, tol);
        scatter(real(points), imag(points));
        i=i+1;
    end
    hold off;

end

function points = Prediction_correction(A, epsilon, lambda0, d0, tol)
% input : 
%       - A: matrix
%       - epsilon: 
%       - K: number of points to be determined
%       - lambda0: epsilon-pseudoeigenvalue of A. La valeur propre choisie.
%       - d0: search direction for the first point
%       - tol: relative accuracy of the first point
% Explanation :
% prendre une valeur propre et appelé curve tracing avec. Puis faure demême avec   
%

    disp("lambda : ");
    disp(lambda0);
    disp("fin");
    % Step 0: Compute the first point z1
    theta0 = epsilon;
    %? lambda seul fct ?
    z1_new = lambda0 + theta0 * d0;
    %z1_new = lambda0;
    Id = eye(size(A));
    [~, s_min, ~] = svds(z1_new .* Id - A, 1, 'smallest'); % g(z_new)
    
    % Newton iteration for the first point
    disp("g(z_new) computed")
    k=0;


    while abs(s_min - epsilon) / epsilon > tol
        z1_old = z1_new;
        % compute the singular triplet for z1_old * I - A
        [u_min, s_min, v_min] = svds(z1_old .* Id - A, 1, 'smallest');
        % compute the next Newton iterate z1_new (equation 2.2)
        theta = (s_min - epsilon)/real(conj(d0) * conj(v_min).' * u_min);
        z1_new = z1_old - theta * d0;
        k=k+1;
    end
    disp("Newton done")
    z1 = z1_new;
    points = z1;
    first_point = z1;
    % computing subsequent points
    %Il faut partir d'un point initiale et lorsqu'on a finit le tours avec
    %une certaine tolérence on stop
    %k=2;
    while 1
        % step 1: Prediction
        [u_min, ~, v_min] = svds(z1 * Id - A, 1, 'smallest');
        rk = 1i*conj(v_min).' * u_min / abs(conj(v_min).' * u_min); % check
        % determine the steplength tau
        tau = 0.1; % i fix steplength on 0.1, result must be correct. might change later.
        zbar_k = z1 + tau * rk; %?

        % step 2: Correction (via one Newton step)
        % compute the singular triplet for zbar_k * I - A
        [u_min, s_min, v_min] = svds(zbar_k * Id - A, 1, 'smallest');
        % compute the corrected point z_k (equation 2.3)
        z_k = zbar_k - (s_min-epsilon)/(conj(u_min).' * v_min);
        
        points = [points z_k];
        %disp(points)
        z1 = z_k;
        if abs(z1-first_point)<=epsilon
            break
        end
    end
    disp("finished");
end