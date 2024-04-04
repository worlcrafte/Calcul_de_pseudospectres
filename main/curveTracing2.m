function points = curveTracing2(A, epsilon, lambda0, d0, tol, max_it)
    % curve tracing algorithm for computing the pseudospectrum.

    % initialize variables
    points = lambda0; % start with the initial lambda0 as the first point
    Id = eye(size(A)); % identity matrix of size A
    z1 = lambda0; % current point being evaluated
    first_point = true; % indicator for the first point

    while true
        % step0 : prediction
        [u_min, ~, v_min] = svds(z1 * Id - A, 1, 'smallest');
        if first_point
            % update direction for the first point based on initial d0
            rk = d0;
            first_point = false; % Update flag after the first iteration
        else
            % update direction based on the latest singular vectors
            rk = 1i * conj(v_min).' * u_min / abs(conj(v_min).' * u_min);
        end
        
        % determine the step length
        tau = 0.1; % might change later 
        
        % step 1 : prediction
        zbar_k = z1 + tau * rk;

        % correction via one Newton step
        [u_min, s_min, v_min] = svds(zbar_k * Id - A, 1, 'smallest');
        theta = (s_min - epsilon) / (conj(u_min).' * v_min);
        z_k = zbar_k - theta * rk; % Correction using rk instead of d0 for general step

        % append the new point
        points = [points, z_k];

        % update the current point
        z1 = z_k;

        % break condition based on the distance to the first point and number of points
        if abs(z_k - lambda0) <= tol || length(points) >= max_it
            break
        end
    end

    disp("Curve tracing finished");
    
    
    [xmin, xmax, ymin, ymax] = gershgorinRegion(A, min(epsilon));
    
    % create the grid of points
    x = linspace(xmin, xmax);
    y = linspace(ymin, ymax);
    [X, Y] = meshgrid(x, y);
    Z = X + 1i*Y;

    % compute the pseudospectrum values for each point in the grid
    pseudoValues = arrayfun(@(z) min(svd(A - z * eye(size(A)))), Z);
    epsilon(2) = epsilon(1);
    % use contourf to plot the pseudospectrum levels
    figure;
    %[C, h] = contourf(X, Y, log10(pseudoValues),epsilon); % needs to be modified
    %clabel(C, h);
    plot(real(points), imag(points));
    %colorbar;
    title('Pseudospectral Level Curves');
    xlabel('Real Part');
    ylabel('Imaginary Part');
    axis equal;
end