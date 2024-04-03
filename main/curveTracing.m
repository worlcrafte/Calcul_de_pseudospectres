function [points] = curveTracing(A, epsilon,K, lambda0, d0, tol, max_it)
% input : 
%       - A: matrix
%       - epsilon: 
%       - K: number of points to be determined
%       - lambda0: epsilon-pseudoeigenvalue of A
%       - d0: search direction for the first point
%       - tol: relative accuracy of the first point
% Explanation :
%   
%
    
    % Step 0: Compute the first point z1
    theta0 = epsilon;
    %? lambda seul fct ?
    z1_new = lambda0 + theta0 * d0;
    Id = eye(size(A));
    [~, s_min, ~] = svds(z1_new .* Id - A, 1, 'smallest'); % g(z_new)
    % Newton iteration for the first point
    disp("g(z_new) computed")
    k=0;
    while abs(s_min - epsilon) / epsilon > tol
        z1_old = z1_new;
        % compute the singular triplet for z1_old * I - A
        [u_min, s_min, v_min] = svds(z1_old * Id - A, 1, 'smallest');
        % compute the next Newton iterate z1_new (equation 2.2)
        theta = (s_min - epsilon)/real(conj(d0) * conj(v_min).' * u_min);
        z1_new = z1_old - theta * d0;
        k=k+1;
        if k>max_it
            disp("maximal number of iterations reach");
            %quit(1);
        end
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
        disp(points)
        z1 = z_k;
        if abs(z1-first_point)<=epsilon
            break
        end
    end
    disp("finished")
    m=200;
    [xmin, xmax, ymin, ymax] = gershgorinRegion(A, min(epsilon));
    
    % Create the grid of points
    x = linspace(xmin, xmax, m);
    y = linspace(ymin, ymax, m);
    [X, Y] = meshgrid(x, y);
    var = real(points)
    contourf(real(X), imag(Y), log10(points), epsilon); % Use contourf for colored fill
    %colorbar;
    title('Log10 of the smallest singular value of (\lambdaI - A)');
    xlabel('Real part (\lambda)');
    ylabel('Imaginary part (\lambda)');
    grid on;
end