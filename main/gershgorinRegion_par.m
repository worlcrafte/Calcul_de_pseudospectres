function [xmin, xmax, ymin, ymax] = gershgorinRegion_par(A,thread, epsilon)
    % A: The matrix for which to calculate the Gershgorin circles
    % epsilon: The level of perturbation to consider for adjusting the radii

    n = size(A, 1); 
    radii = zeros(n, 1); 
    centers = diag(A);
    p = gcp('nocreate');
    disp(p);
    % open a parallel pool if it's not already open
    if isempty(p)
        p=parpool();
    end

    % calculate the radii of the Gershgorin circles in parallel
    parfor (i = 1:n,thread)
        radii(i) = sum(abs(A(i, :))) - abs(A(i, i));
    end

    % adjust the radii with epsilon
    radii = radii + epsilon;

    % determine the region of interest
    xmin = min(real(centers) - radii);
    xmax = max(real(centers) + radii);
    ymin = min(imag(centers) - radii);
    ymax = max(imag(centers) + radii);

    % display for verification
    fprintf('Region of interest determined by the adjusted Gershgorin circles:\n');
    fprintf('Xmin: %f, Xmax: %f, Ymin: %f, Ymax: %f\n', xmin, xmax, ymin, ymax);
end
