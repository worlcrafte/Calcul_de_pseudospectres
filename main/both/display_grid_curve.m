function [h,pred] = display_grid_curve(A,epsilon,m,d0,tol_Newton, tol_turn, thread,step,gui)
%input:
%       A           : The matrix for which to analyze the pseudospectrum 
%       epsilon     : The perturbation level 
%       d0          : The first point direction
%       tol_Newton  : Relative accuracy for Newton s method
%       tol_turn    : Relative accuracy for stopping criterium
%       thread      : The number of cores used to compute the pseudospectra
%       step        : steplength in prediction correction algorithm
%output:
%       h           : the graph coutourf of grid
%       pred        : the graph scatter of curve tracing
%Eplaination:
%       Compute the pseudospectra using grid and curve tracing and compare
%       their result.
    
    
    %Compute pseudospectra with grid algorithm 
    [X, Y, sigmin] = gridPseudospectrum_par(A, epsilon, thread,m);
    hold(gui,'on');
    %display
    [~,h] = contourf(gui,X, Y, log10(sigmin), log10([epsilon epsilon]));  % Use log 10 for a better display
    drawnow;
    
    %Compute with curve now 
    [eigen_values,points] = curve_tracing_par(A,epsilon,d0,tol_Newton,tol_turn,thread,step);
    
    %The eigen values will be red with form 'X' 
    plot(gui,real(eigen_values), imag(eigen_values),'X', 'MarkerEdgeColor','red');
    [siz,~] = size(eigen_values);
    %take siz differents color 
    c = lines(siz);
    pred=cell(1,siz);
    %display
    for lambda0=1:siz
        color = c(lambda0,:);  
        %store the graph
        pred{lambda0} = scatter(gui,real(points{lambda0}), imag(points{lambda0}),'MarkerEdgeColor',color);
        
    end
    %information of the graph 
    hold(gui,"off");
    axis(gui,"equal");
    xlabel(gui,'Real part (\lambda)');
    ylabel(gui,'Imaginary part (\lambda)');
    title(gui,'Combined Pseudospectrum Visualization');
    grid(gui,'on');
   
end