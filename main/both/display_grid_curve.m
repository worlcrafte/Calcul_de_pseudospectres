function [h,pred] = display_grid_curve(A,epsilon,d0,tol_Newton, tol_turn, thread,gui)
%input:
%       A: matrix 
%       epsilon:
%       d0
%       tol
    m = 2000;
    %[~, s_min, ~] = svd(A);
    [X, Y, sigmin] = gridPseudospectrum_par(A, epsilon, thread,m);

    %s = diag(s_min);
    s = eig(A);
    %figure();
    hold(gui,'on');
    [~,h] = contourf(gui,X, Y, log10(sigmin), log10([epsilon epsilon]));  % Utilisation de log10 pour un meilleur affichage
    drawnow;

    [eigen_values,points] = curve_tracing_par(A,epsilon,d0,tol_Newton,tol_turn,thread);
    plot(gui,real(eigen_values), imag(eigen_values),'X', 'MarkerEdgeColor','red');
    pred = scatter(gui,real(points), imag(points));
    hold(gui,"off");
    axis(gui,"equal");
    xlabel(gui,'Real part (\lambda)');
    ylabel(gui,'Imaginary part (\lambda)');
    title(gui,'Combined Pseudospectrum Visualization');
    grid(gui,'on');

end