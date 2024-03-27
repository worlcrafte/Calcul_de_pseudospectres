function stress_test(size_from,size_to,step,m_point_to_evaluate,thread_from, thread_to,rand_function,epsilon,gui)
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
    [~,n] = size(size_matrix);
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
    begining = 1;
    if thread_from ~=1
        threads = [1 thread_from:thread_to];
        begining = 2;
    else 
        threads =  thread_from:thread_to;
    end
    %   time sampling
    for n = size_matrix
        for t = threads
            tic
            gridPseudospectrum_par(A,epsilon,t,m_point_to_evaluate);
            time_mesurment(i,j) = toc;
            i=i+1;
        end
        j=j+1;
        A = rand_function(n);
        i=1;
    end
    % generate a vector for the x axe
    disp(time_mesurment)
    [~,n] = size(size_matrix);
    [~,m] = size(threads);
    speedup = zeros(thread_to-thread_from+1,n);
    efficiency = zeros(thread_to-thread_from+1,n);
    i=1;
    for j = 1:n 
        best = time_mesurment(1,j);
        a = best./time_mesurment(begining:m,j);
        speedup(:,j) = a(:);
        disp(speedup);
        efficiency(:,j) = a./threads(begining:m)';
        i=i+1;
    end

    %Histogramme
    figure(1);
    disp("speedup : ");
    disp(speedup);
    barh(size_matrix(:).^2,speedup');
    xlabel('speedup');
    ylabel('size matrices');
    t = num2cell(string(threads(begining:m)));
    legend(t{:});
    title_name = sprintf('Bar graph of computational speedup vs number of threads for various instance sizes with %i points to evalueate', m_point_to_evaluate);
    title(title_name);

    figure(2);
    barh(size_matrix(:).^2,efficiency');
    xlabel('Efficiency');
    ylabel('size matrices');
    %t = num2cell(string(threads(begining:m)));
    legend(t{:});
    title_name = sprintf('Bar graph of computational speedup vs number of threads for various instance sizes with %i points to evalueate', m_point_to_evaluate);
    title(title_name);
    %Just plot
    [~,n] =size(size_matrix);
    txt = "size matrix :" + string(size_matrix(:).^2);
    txt= num2cell(txt);
    h = zeros(n,1);
    figure(3);
    h(1) = plot(threads(begining:m),speedup(:,1), "-o");
    title_name = sprintf("Graph of Computational Speedup vs Number of Threads for various Instance Sizes with %i points to evalueate", m_point_to_evaluate);
    title(title_name);
    ylabel('Speedup');
    xlabel('Number of workers');
    hold on;
    for i = 2:n
        figure(3);
        h(i) = plot(threads(begining:m),speedup(:,i), '-o');
    end
    legend(txt{:});
    hold off;

     %Just plot
    [~,n] =size(size_matrix);
    txt = "size matrix :" + string(size_matrix(:).^2);
    txt= num2cell(txt);
    h = zeros(n,1);
    figure(4);
    h(1) = plot(threads(begining:m),efficiency(:,1), "-o");
    title_name = sprintf("Graph of Computational efficiency vs Number of Threads for various Instance Sizes with %i points to evalueate", m_point_to_evaluate);
    title(title_name);
    ylabel('Efficiency');
    xlabel('Number of workers');
    hold on;
    for i = 2:n
        figure(3);
        h(i) = plot(threads(begining:m),efficiency(:,i), '-o');
    end
    legend(txt{:});
    hold off;


    % number of mesurement realised
    %[~,n] =size(size_matrix);
    
    % vector of plots for legend
    %h = zeros(n,1);
    %txt = "size matrix : " + string(size_matrix(1));
    % generate plots
    %time_mesurment = time_mesurment * 
    
    %disp(time_mesurment);

    %h(1) = plot(gui,threads,log10(time_mesurment(1,:)),'DisplayName',txt);
    
    %title('Measured time');
    %xlabel('Number of thread used');
    %ylabel('log10 of the measured time in ms');
    %hold(gui,'on');
    %for i = 2:n
     %   txt = "size matrix : " + string(size_matrix(i));
      %  h(i) = plot(gui,threads,log10(time_mesurment(i,:)),'DisplayName',txt);
    %end
    
    %hold(gui,"off");
    %legend(gui);
end

