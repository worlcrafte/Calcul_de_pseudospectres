function [X,Y,sigmin] = gridPseudospectrum_par(A, epsilon,thread,m)
    % A: The matrix for which to analyze the pseudospectrum
    % epsilon: The perturbation level 
    % m: The number of points per unit in the grid
    % use gershgorinRegion_par to determine the region of interest
    [xmin, xmax, ymin, ymax] = gershgorinRegion_par(A,thread, min(epsilon));
    
    % create the grid of points
    x = linspace(xmin, xmax, m);
    y = linspace(ymin, ymax, m);
    [X, Y] = meshgrid(x, y);

    Z = X + 1i*Y;
    
    n = size(A, 1);
    sigmin = zeros(size(Z));
    p =gcp('nocreate');

    % open a parallel pool if it's not already open
    if isempty(p)     
        p=parpool(thread);
    end
    % calculate the pseudospectrum in parallel
    ppm = ParforProgressbar(numel(Z),'showWorkerProgress', true);
    e = eye(n);
    parfor (k = 1:numel(Z), thread)
        sigmin(k) = min(svd(Z(k)*e - A));
        
        
        ppm.increment();
    end
    delete(ppm);
end
