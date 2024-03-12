function stress_test(size_from,size_to,step,m_point_to_evaluate,thread_from, thread_to,rand_function,epsilon)
% input : 
%       - size_from :   size of the matrix at the begining
%       - size_to   :   size of the matrix at the end of the test
%       - step      :   step for the size of the matrix 
%       - m_point_to_evaluate   :   the number of point to evaluate for the
%       pseudospectra algo
%       - thread_from   :   number of thread at the begining of the test
%       - thread_to     :   numbre of thread at the end of the test 
%       - rand_function :   function used to generate the matrix
%       - algo_used_for_pseudospectra : function used to compute the
%       pseudospectra of the matrix

% output    :   none 

%   Explanation :
%       Generate a plot to evaluate the performance of the algorithm
%       depending on the size of the matrix and the number of size used. We
%       will add the possibility to choose the algo used and to compare the
%       algo the user can use.

    %generate the matrix 
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
        delete(p);
    end
    parpool();
    
    %   time sampling
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
    % generate a vector for the x axe
    threads = thread_from:thread_to;
    
    % number of mesurement realised
    [~,n] =size(size_matrix);
    
    % vector of plots for legend
    h = zeros(n,1);

    % generate plots
    h(1) = plot(threads,time_mesurment(1,:));
    hold on;
    for i = 2:n
        h(i) = plot(threads,time_mesurment(i,:));
    end

    hold off;
end
