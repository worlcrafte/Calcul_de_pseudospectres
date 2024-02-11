function res = Core_Eightool(A,m,epsilon)
    maxit = m; 
    [N,~] = size(A);
    T = schur(A,'complex');
    x = linspace(-1.5,1.5, m);
    y = linspace(-1.5,1.5, m);
    for k=1:m, for j=1:m
        T1 = (x(k)+y(j)*1i)*eye(N)-T; 
        T2=T1';
        sigold = 0;
        qold = zeros(N,1);
        beta =0;
        H = [];
        q = randn(N,1) + 1i * randn(N,1);
        q = q/norm(q);
        for p=1:maxit
            v = T1\(T2\q) - beta*qold;
            alpha = real(q'*v);
            v = v-alpha*q;
            beta = norm(v);
            qold = q;
            q = v/beta;
            H(p+1,p) = beta;
            H(p,p+1) = beta;
            H(p,p) = alpha;
            sig = max(eig(H(1:p, 1:p)));
            if abs(sigold/sig-1)< epsilon, break, end
            sigold = sig;
        end
        sigmin(j,k) = sqrt(sig);
    end,end
    contour(x,y,log10(sigmin));
    %scatter(x,y,sigmin);
end

