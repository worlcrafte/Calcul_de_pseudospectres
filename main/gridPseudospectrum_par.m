function [X,Y,sigmin] = gridPseudospectrum_par(A, epsilon,thread,m)
    % A: The matrix for which to analyze the pseudospectrum
    % epsilon: The perturbation level to adjust the Gershgorin disks
    % m: The number of points per unit in the grid
    %[n, ~] = size(A);
    %m = n*n;
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
    %disp(thread);
    %ppm = ParforProgressbar(numel(Z),'showWorkerProgress', true);
    %'showWorkerProgress', true
    e = eye(n);
    parfor (k = 1:numel(Z), thread)
        sigmin(k) = min(svd(Z(k)*e - A));
        
        
     %   ppm.increment();
    end
    %delete(ppm);
    %faire une interface graphique, choisir un epsilon, puis encadrer les
    %valeurs trouver avec la souris, puis recalculer le pseudo spectre dans
    %la zone encarer. faire une barre de défilement. 
    % Dans l'interface graphique pouvoir choisir le nombre de coeur (plus
    % tard choisir l'algo qu'on veut choisir. (Graphique user interface. )
    % Visualize the pseudospectrum
    %epsilon(2) = epsilon(1);
    %[C,h ] = contourf(X, Y, (sigmin), (epsilon));
    %clabel(C, h);
    %grid on;
end
