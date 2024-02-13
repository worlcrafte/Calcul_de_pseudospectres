function res = Core_Eightool(A,epsilon,m)
    maxit = sqrt(m); 
    [xmin, xmax, ymin, ymax] = gershgorinRegion(A, min(epsilon));
    [N,~] = size(A);
    T = schur(A,'complex');
    x = linspace(xmin, xmax, m);
    y = linspace(ymin, ymax, m);
    [X, Y] = meshgrid(x, y);
    H = zeros(maxit);
    sigmin = zeros(m,m);
    for k=1:m, for j=1:m
        T1 = (x(k)+y(j)*1i)*eye(N)-T; 
        T2=T1';
        sigold = 0;
        qold = zeros(N,1);
        beta =0;
        %H = [];
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
    contourf(X, Y, log10(sigmin), 20); 
    %scatter(x,y,sigmin);
end

