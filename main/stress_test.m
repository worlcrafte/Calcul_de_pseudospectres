function stress_test(size_from,size_to,step,m_point_to_evaluate,thread_from, thread_to,rand_function,epsilon)
%STRESS_TEST Summary of this function goes here
%   Detailed explanation goes here
    A = rand_function(size_from);
    size_matrix = size_from:step:size_to;
    [n,~] = size(size_matrix);
    time_mesurment = zeros(thread_to-thread_from,n);
    i=1;
    j=1;
    for n = size_matrix
        for t = thread_from:thread_to
            tic
            gridPseudospectrum_par(A,epsilon,t,m_point_to_evaluate);
            time_mesurment(j,i) = toc;
            disp(time_mesurment);
            i=i+1;
        end
        j=j+1;
        A = rand_function(n);
        i=1;
    end 
    disp(time_mesurment);
end

