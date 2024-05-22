function [time_mesurment_curve,size_matrix,threads] = stress_test_curve(size_from,size_to,step_size,thread_from, thread_to,step_thread,rand_function,epsilon, ...
    tol_Newton,tol_turn,step)
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

% output    :    :   
%       - time_mesurment        :   the time mesured 
%       - size_matrix           :   list of matrix sizes used
%       - threads               :   list of number thread used 

%   Explanation :
%       Generate a plot to evaluate the performance of the algorithm
%       depending on the size of the matrix and the number of size used. We
%       will add the possibility to choose the algo used and to compare the
%       algo the user can use.

    %generate the matrix 
    d0=1i;
    size_matrix = size_from:step_size:size_to;
    i=1;
    j=1;
    barre = 1;
    p = gcp('nocreate');
    % delete the previous parpool to create a new one with all possible
    % workers.
    if isempty(p)
        parpool();
    end

    if thread_from ~=1
        threads = [1 thread_from:step_thread:thread_to];
    else 
        threads =  thread_from:step_thread:thread_to;
    end
    disp(threads);
    %   time sampling
    f =  waitbar(0,'Compute the data');
    for n = size_matrix
        A = rand_function(n);
        
        for t = threads
            %tic
            %[X,Y,~] = gridPseudospectrum_par(A, epsilon,t,m_point_to_evaluate);
            %time_mesurment_grid(i,j) = toc;
         
            tic
            Curve_tracing_m(A,epsilon,d0,tol_Newton,tol_turn,t,step);
            time_mesurment_curve(i,j) = toc;
            i=i+1;
            barre = barre+1;
            waitbar(barre/(length(size_matrix)*length(threads)),f,'Compute the data');
        end
        j=j+1;
        
        i=1;
    end
    close(f);
    disp(time_mesurment_curve);
    % generate a vector for the x axe
    
end

