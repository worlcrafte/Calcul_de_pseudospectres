function [h,pred] = display_grid_curve(A,epsilon,d0,tol_Newton, tol_turn,gui)
%input:
%       A: matrix 
%       epsilon:
%       d0
%       tol
    m = 100;
    %[~, s_min, ~] = svd(A);
    [X, Y, sigmin] = gridPseudospectrum_par(A, epsilon, 1,m);

    %s = diag(s_min);
    s = eig(A);
    %figure();
    hold(gui,'on');
    [~,h] = contourf(gui,X, Y, log10(sigmin), log10([epsilon epsilon]));  % Utilisation de log10 pour un meilleur affichage
    i=1;
    pred = zeros(numel(s),1);
    for lambda0=s.'
        points = Prediction_correction(A,epsilon, lambda0, d0, tol_Newton, tol_turn);
        pred(i) = scatter(gui,real(points), imag(points), 'filled');
        i=i+1;
    end
    hold(gui,"off");
    axis(gui,"equal");
    xlabel(gui,'Real part (\lambda)');
    ylabel(gui,'Imaginary part (\lambda)');
    title(gui,'Combined Pseudospectrum Visualization');
    grid(gui,'on');
    %[~,limit] = size(pred);
    %for i=1:limit
    %    pred(i).Visible= false;
    %end
    %h.Visible = 'on';
end

function points = Prediction_correction(A, epsilon, lambda0, d0, tol_Newton, tol_turn)
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
    %? lambda seul fct ? Non
    disp(theta0);   
    z1_new = lambda0 + theta0 * d0;
    %z1_new = lambda0;
    Id = eye(size(A));   
    [~, s_min, ~] = svds(z1_new .* Id - A, 1, 'smallest'); % g(z_new)
    
    % Newton iteration for the first point
    disp("g(z_new) computed")
    k=0;


    while abs(s_min - epsilon) / epsilon > tol_Newton
        z1_old = z1_new;
        % compute the singular triplet for z1_old * I - A
        [u_min, s_min, v_min] = svds(z1_old .* Id - A, 1, 'smallest');
        % compute the next Newton iterate z1_new (equation 2.2)
        theta = (s_min - epsilon)/real(conj(d0) * v_min' * u_min);
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
        rk = 1i*v_min' * u_min / abs(v_min' * u_min); % check
        % determine the steplength tau
        tau = 0.1; % i fix steplength on 0.1, result must be correct. might change later.
        zbar_k = z1 + tau * rk; %?

        % step 2: Correction (via one Newton step)
        % compute the singular triplet for zbar_k * I - A
        [u_min, s_min, v_min] = svds(zbar_k * Id - A, 1, 'smallest');
        % compute the corrected point z_k (equation 2.3)
        z_k = zbar_k - (s_min-epsilon)/(u_min' * v_min);
        
        points = [points z_k];
        %disp(points)
        z1 = z_k;
        disp(abs(z1-first_point));
        if abs(z1-first_point)<=tol_turn
            break
        end
    end
    disp("finished");
end