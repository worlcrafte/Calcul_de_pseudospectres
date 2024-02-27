function [X,Y,sigmin] = gridPseudospectrum_par_r(A, thread,xmin,xmax,ymin,ymax)
    % A: The matrix for which to analyze the pseudospectrum
    % epsilon: The perturbation level to adjust the Gershgorin disks
    % m: The number of points per unit in the grid
    [n, ~] = size(A);
    m = n*n;
    % create the grid of points
    x = linspace(xmin, xmax, m);
    y = linspace(ymin, ymax, m);
    [X, Y] = meshgrid(x, y);
    Z = X + 1i*Y;
    
    n = size(A, 1);
    sigmin = zeros(size(Z));

    % open a parallel pool if it's not already open
    if isempty(gcp('nocreate'))     
        parpool('Threads');
    end

    %setappdata(f,'canceling',0);
    % calculate the pseudospectrum in parallel
    WaitMessage = parfor_wait(numel(Z), 'Waitbar', true);
    parfor (k = 1:numel(Z), thread)
        sigmin(k) = min(svd(Z(k)*eye(n) - A));
        %if t.ID == 1
         %   disp(i);
            
        
        %end
        %progressbar(p/100);
        WaitMessage.Send;
        %waitbar(p/100,f,'test');
        %showTimeToCompletion( p/100, [], [], startTime );
    end
    disp(m);
    %faire une interface graphique, choisir un epsilon, puis encadrer les
    %valeurs trouver avec la souris, puis recalculer le pseudo spectre dans
    %la zone encarer. faire une barre de défilement. 
    % Dans l'interface graphique pouvoir choisir le nombre de coeur (plus
    % tard choisir l'algo qu'on veut choisir. (Graphique user interface. )
    % Visualize the pseudospectrum
    %contourf(X, Y, log10(sigmin), epsilon); % Use contourf for colored fill
    %contour(X,Y,sigmin, epsilon);
    %colorbar;
    %title('Log10 of the smallest singular value of (\lambdaI - A)');
    %xlabel('Real part (\lambda)');
    %ylabel('Imaginary part (\lambda)');
    %grid on;
end
