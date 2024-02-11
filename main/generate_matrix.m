function res = generate_matrix(N)
    mu = 1;
    sigma = 5;
    rng('Default');
    for i = 1:N
        for j = 1:N
            res(i,j) = random('Normal',mu,sigma);
        end
    end
end

