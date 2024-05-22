function Curve_tracing_m(A,epsilon,d0,tol_Newton, tol_turn,thread,step)
%input:
%       A: matrix 
%       epsilon:
%       d0
%       tol_Newton
%       tol_turn
%       thread
%       gui

   
    eigen_values = eig(A);
    %pred = zeros(numel(eigen_values),1);
    [siz,~] = size(eigen_values);
    points = cell(1,siz);

    parfor (lambda0=1:siz,thread)
        %r = abs(real(lambda0) + imag(lambda0));
        %color = [r - floor(r), lambda0/siz, 1-lambda0/siz];
        
        points{lambda0} = Prediction_correction(A,epsilon, eigen_values(lambda0), d0, tol_Newton, tol_turn,step);

    end
end

function points = Prediction_correction(A, epsilon, lambda0, d0, tol_Newton, tol_turn,step)
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

    % Step 0: Compute the first point z1
    theta0 = epsilon;
    %? lambda seul fct ? Non
    %disp(theta0);   
    z1_new = lambda0 + 0.5*theta0 * d0;
    %z1_new = lambda0;
    Id = eye(size(A));   
    [~, s_min, ~] = svds(z1_new .* Id - A, 1, 'smallest'); % g(z_new)
    
    % Newton iteration for the first point
    k=1;


    while abs(s_min - epsilon) / epsilon > tol_Newton
        z1_old = z1_new;
        % compute the singular triplet for z1_old * I - A
        [u_min, s_min, v_min] = svds(z1_old .* Id - A, 1, 'smallest');
        % compute the next Newton iterate z1_new (equation 2.2)
        theta = (s_min - epsilon)/real(conj(d0) * v_min' * u_min);
        z1_new = z1_old - theta * d0; 
        k=k+1;
        if k >= 50 
           z1_new = z1_old - tol_Newton*theta * d0;
        end
        %disp(abs(s_min - epsilon) / epsilon);
    end
    z1 = z1_new;
    points = z1;
    first_point = z1;
    % computing subsequent points
    %Il faut partir d'un point initiale et lorsqu'on a finit le tours avec
    %une certaine tolérence on stop
    %k=2;
    k=0;
    while 1
        
        % step 1: Prediction
        [u_min, ~, v_min] = svds(z1 * Id - A, 1, 'smallest');
        rk = 1i*v_min' * u_min / abs(v_min' * u_min); % check
        % determine the steplength tau
        tau = step; % i fix steplength on 0.1, result must be correct. might change later.
        zbar_k = z1 + tau * rk; %?


        %! Cette partie est peut être la partie qui poserait problème lors
        %du Newton (essayer d'isoler une composante pour essayer de comprendre le problème)!!!!!!!
            
        %Dans le rapport parler des composantes connexe sur le fait qu'on
        %puisse parler de l'une à l'autre. Il faut que celui qui lit le
        %rapport le comprenne sans lire les articles.

        % step 2: Correction (via one Newton step)
        % compute the singular triplet for zbar_k * I - A   
        [u_min, s_min, v_min] = svds(zbar_k * Id - A, 1, 'smallest');
        % compute the corrected point z_k (equation 2.3)
        z_k = zbar_k - (s_min-epsilon)/(u_min' * v_min);
        
        points = [points z_k];
        z1 = z_k;
        if abs(z1-first_point)<=tol_turn
            break
        end
        if k>1000
            break
        end
        k=k+1;
    end
end