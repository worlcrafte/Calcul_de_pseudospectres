function [time_mesurment_curve,size_matrix,threads] = stress_test_curve(size_from,size_to,step_size,thread_from, thread_to,step_thread,rand_function,epsilon, ...
    tol_Newton,tol_turn,step)
% input : 
%       - size_from     :   size of the matrix at the begining
%       - size_to       :   size of the matrix at the end of the test
%       - step          :   step for the size of the matrix 
%       pseudospectra algo
%       - thread_from   :   number of thread at the begining of the test
%       - thread_to     :   numbre of thread at the end of the test 
%       - rand_function :   function used to generate the matrix
%       - tol_Newton    : Relative accuracy for Newton s method
%       - tol_turn      : Relative accuracy for stopping criterium
%       - step          : steplength in prediction correction algorithm

% output :     
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
    %Start the parpool if necessary
    p = gcp('nocreate');
    if isempty(p)
        parpool();
    end
    % Compute the list of number of cores used
    if thread_from ~=1
        threads = [1 thread_from:step_thread:thread_to];
    else 
        threads =  thread_from:step_thread:thread_to;
    end
    %   time sampling
    f =  waitbar(0,'Compute the data');
    %For each size of matrix compute the pseudo spectra using tje curve
    %tracing algorithm for each number of core needed
    for n = size_matrix
        A = rand_function(n);
        
        for t = threads
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
    
end

