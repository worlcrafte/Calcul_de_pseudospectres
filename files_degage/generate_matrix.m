function res = generate_matrix(N)
    mu = 1;
    sigma = 5;
    rng('default'); % set random number generator to default
    res = normrnd(mu, sigma, N); % generate N x N matrix of random numbers
end


