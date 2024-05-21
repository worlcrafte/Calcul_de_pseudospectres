function gridPseudospectrum(A, epsilon, m)
    % A: The matrix for which to analyze the pseudospectrum
    % epsilon: The perturbation level to adjust the Gershgorin disks
    % m: The number of points per unit in the grid

    % use gershgorinRegion to determine the region of interest
    [xmin, xmax, ymin, ymax] = gershgorinRegion(A, min(epsilon));
    
    % Create the grid of points
    x = linspace(xmin, xmax, m);
    y = linspace(ymin, ymax, m);
    [X, Y] = meshgrid(x, y);
    Z = X + 1i*Y;

    n = size(A, 1);
    sigmin = zeros(size(Z));

    % Calculate the pseudospectrum
    for k = 1:numel(Z)
        sigmin(k) = min(svd(Z(k)*eye(n) - A));
    end

    % Visualize the pseudospectrum
    epsilon(2) = epsilon(1);
    figure(1);
    [C,h ] = contourf(X, Y, (sigmin), (epsilon));
    clabel(C, h);
    title('Log10 of the smallest singular value of (\lambdaI - A)');
    xlabel('Real part (\lambda)');
    ylabel('Imaginary part (\lambda)');
    grid("on");
end
