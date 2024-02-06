function sigmin = grid_algo(A, m, epsilon, F,tho)
    u = linspace(-1,1,m);
    %x = linspace(-1.5,1.5, m);
    y = linspace(-1.5,1.5, m);
    Au =  @(x) sqrt(1i*F/pi) * integral(exp(-1i*F*(x-y).^2)*u(y), 0 , 1 );
    z = zeros(m);
    diff(Au);
    Au = Au-A;
    [~, U, V] = svd(Au);
    for k = 2:m
        z(k) = z(k - 1) + tho * i(V * U) / norm(V * U);
        [S, U, V] = svd(z(k) - A);
        z(k) = z(k) - (S - epsilon) / (u * v);
    end
    sigmin = z;
    %[N,~] = size(A);
    
    
    
    %for k=1:m , for j = 1:m
    %    sigmin(j,k) = min(svd((x(k)+y(j)*1i*eye(N)-A)));
    %end,end
    contour(x,y,log10(sigmin));
end
