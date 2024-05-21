function res = toeplitz_matrix(n)
    syms k a;
    T(a,k) = 1/(pi*(a-k+1/2));
    res = zeros(n,n);
    for i=1:n
        for z=1:n
            res(i,z)=T(i,z);
        end
    end
end

