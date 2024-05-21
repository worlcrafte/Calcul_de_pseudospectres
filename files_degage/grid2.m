function sigmin = grid2(A,m)
    [N,~] = size(A);
    x = linspace(-1.5,1.5, m);
    y = linspace(-1.5,1.5, m);
    maxit=m;
    sigold = 1;
    for k=1:m, for j=1:m
        B = (x(k)+y(j)*1i)*eye(N)-A;
        u = randn(N,1) +1i*randn(N,1);
        [L,U] = lu(B); Ls = L'; Us = U';
        for p=1:maxit
            u = Ls\(Us\(U\(L\u))); sig = 1/norm(u);
            if (abs(sigold/sig-1))< 1e-2; break,end
            u = sig*u; sigold = sig;
        end
        sigmin(j,k) = sqrt(sig);
    end,end
    contour(x,y,log10(sigmin));
end

