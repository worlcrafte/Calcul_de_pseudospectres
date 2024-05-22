function [h,pred] = display_grid_curve(A,epsilon,m,d0,tol_Newton, tol_turn, thread,step,gui)
%input:
%       A: matrix 
%       epsilon:
%       d0
%       tol
    
    
    
    %Compute pseudospectra with grid algorithm 
    [X, Y, sigmin] = gridPseudospectrum_par(A, epsilon, thread,m);
    hold(gui,'on');
    %display
    [~,h] = contourf(gui,X, Y, log10(sigmin), log10([epsilon epsilon]));  % Use log 10 for a better display
    drawnow;
    
    %Compute with curve now 
    [eigen_values,points] = curve_tracing_par(A,epsilon,d0,tol_Newton,tol_turn,thread,step);
    
    %The eigen valu will be red and a X 
    plot(gui,real(eigen_values), imag(eigen_values),'X', 'MarkerEdgeColor','red');
    [siz,~] = size(eigen_values);
    c = lines(siz);
    pred=cell(1,siz);
    for lambda0=1:siz
        color = c(lambda0,:);  
        pred{lambda0} = scatter(gui,real(points{lambda0}), imag(points{lambda0}),'MarkerEdgeColor',color);
        
    end
    hold(gui,"off");
    axis(gui,"equal");
    xlabel(gui,'Real part (\lambda)');
    ylabel(gui,'Imaginary part (\lambda)');
    title(gui,'Combined Pseudospectrum Visualization');
    grid(gui,'on');
   
end