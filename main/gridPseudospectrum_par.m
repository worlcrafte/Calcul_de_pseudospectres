function gridPseudospectrum_par(A, epsilon,m)
    % A: The matrix for which to analyze the pseudospectrum
    % epsilon: The perturbation level to adjust the Gershgorin disks
    % m: The number of points per unit in the grid

    % use gershgorinRegion_par to determine the region of interest
    [xmin, xmax, ymin, ymax] = gershgorinRegion_par(A, min(epsilon));
    
    % create the grid of points
    x = linspace(xmin, xmax, m);
    y = linspace(ymin, ymax, m);
    [X, Y] = meshgrid(x, y);
    Z = X + 1i*Y;
    
    n = size(A, 1);
    sigmin = zeros(size(Z));

    % open a parallel pool if it's not already open
    if isempty(gcp('nocreate'))
        parpool;
    end
    
    % calculate the pseudospectrum in parallel
    parfor k = 1:numel(Z)
        sigmin(k) = min(svd(Z(k)*eye(n) - A));
    end
    
    % Visualize the pseudospectrum
    contourf(X, Y, log10(sigmin), 20); % Use contourf for colored fill
    %contour(X,Y,sigmin, epsilon);
    colorbar;
    title('Log10 of the smallest singular value of (\lambdaI - A)');
    xlabel('Real part (\lambda)');
    ylabel('Imaginary part (\lambda)');
    grid on;
end
