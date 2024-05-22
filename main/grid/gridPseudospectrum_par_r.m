function [X,Y,sigmin] = gridPseudospectrum_par_r(A, thread,xmin,xmax,ymin,ymax,m)
    % A: The matrix for which to analyze the pseudospectrum
    % epsilon: The perturbation level to adjust the Gershgorin disks
    % m: The number of points per unit in the grid
    [n, ~] = size(A);
    % create the grid of points
    x = linspace(xmin, xmax, m);
    y = linspace(ymin, ymax, m);
    [X, Y] = meshgrid(x, y);
    Z = X + 1i*Y;
    
    n = size(A, 1);
    sigmin = zeros(size(Z));
    p=gcp('nocreate');
    % open a parallel pool if it's not already open
    if isempty(p)     
        p=parpool(thread);
    end

    %setappdata(f,'canceling',0);
    % calculate the pseudospectrum in parallel
    parfor (k = 1:numel(Z), thread)
        sigmin(k) = min(svd(Z(k)*eye(n) - A));
    end
    disp(m);
end
