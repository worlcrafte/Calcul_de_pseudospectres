function prediction_correction(A,epsilon,K,pseudo_eigenvalue,d,tol)
    %Step0 : compute the first point z1
    teta = epsilon;
    z_new = pseudo_eigenvalue + teta*d;
    [n,~] = size(A);
    I = eye(n);
    while abs(g(z_new)-epsilon)/epsilon > tol
        z_old = z_new;
        [u,s,v] = svd(z_old*I-A);
        
    end
end