function stress_test(size_from,size_to,step,m_point_to_evaluate,thread_from, thread_to,rand_function,epsilon)
%STRESS_TEST Summary of this function goes here
%   Detailed explanation goes here
    A = rand_function(size_from);
    size_matrix = size_from:step:size_to;
    [n,~] = size(size_matrix);
    time_mesurment = zeros(thread_to-thread_from,n);
    i=1;
    j=1;
    p = gcp('nocreate');
    % delete the previous parpool to create a new one with all possible
    % workers.
    if ~ isempty(p)
        %delete(p);
    end
    %parpool();

    for n = size_matrix
        for t = thread_from:thread_to
            tic
            gridPseudospectrum_par(A,epsilon,t,m_point_to_evaluate);
            time_mesurment(j,i) = toc;
            i=i+1;
        end
        j=j+1;
        A = rand_function(n);
        i=1;
    end 
    threads = thread_from:thread_to;
    [~,n] =size(size_matrix);
    h = zeros(n,1);
    h(1) = plot(threads,time_mesurment(1,:));
    hold on;
    for i = 2:n
        h(i) = plot(threads,time_mesurment(i,:));
    end
    
    hold off;
end

