function Curve_tracing_m(A,epsilon,d0,tol_Newton, tol_turn,thread,step)
%Same algorithm as curve_tracing_par but without the progress barr. For the
%description go see curve_tracing_par in curveTraing.

   
    eigen_values = eig(A);
    [siz,~] = size(eigen_values);
    points = cell(1,siz);

    parfor (lambda0=1:siz,thread)
        
        points{lambda0} = Prediction_correction(A,epsilon, eigen_values(lambda0), d0, tol_Newton, tol_turn,step);

    end
end

function points = Prediction_correction(A, epsilon, lambda0, d0, tol_Newton, tol_turn,step)

    theta0 = epsilon;
    z1_new = lambda0 + 0.5*theta0 * d0;
    Id = eye(size(A));   
    [~, s_min, ~] = svds(z1_new .* Id - A, 1, 'smallest'); % g(z_new)
    tau = step;
    k=1;


    while abs(s_min - epsilon) / epsilon > tol_Newton
        z1_old = z1_new;
        [u_min, s_min, v_min] = svds(z1_old .* Id - A, 1, 'smallest');
        theta = (s_min - epsilon)/real(conj(d0) * v_min' * u_min);
        z1_new = z1_old - theta * d0; 
        k=k+1;
        if k >= 50 
           z1_new = z1_old - tol_Newton*theta * d0;
        end
    end
    z1 = z1_new;
    points = z1;
    first_point = z1;
    k=0;
    while 1
        
        [u_min, ~, v_min] = svds(z1 * Id - A, 1, 'smallest');
        rk = 1i*v_min' * u_min / abs(v_min' * u_min);
        zbar_k = z1 + tau * rk; 
        [u_min, s_min, v_min] = svds(zbar_k * Id - A, 1, 'smallest');
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