function pred = display_curveTracing(eigen_values,points,gui)
% Entries : 
%   eigen_values    : the eigen values of the matrix that we compute in
%                     pseudospectra
%   points          : the pseudo spectra computed with Curve tracing
%   gui             : The UIAxes of the app
% Output :
%   pred            : the scatter 

    % plot the eigen values as X with red color
    hold(gui,"on");
    plot(gui,real(eigen_values), imag(eigen_values),'X', 'MarkerEdgeColor','red');
    [siz,~] = size(eigen_values);
    % Compute siz various colors 
    c = lines(siz);
    pred=cell(1,siz);
    % for each eigen value, display the pseudo spectra computed with
    % color(i) 
    for lambda0=1:siz
        color = c(lambda0,:);  
        pred{lambda0} = scatter(gui,real(points{lambda0}), imag(points{lambda0}),'MarkerEdgeColor',color);
        
    end
    drawnow;
    % Info of the graph (label, Title, ...)
    hold(gui,"off");
    axis(gui,"equal");
    xlabel(gui,'Real part (\lambda)');
    ylabel(gui,'Imaginary part (\lambda)');
    title(gui,'Combined Pseudospectrum Visualization');
    grid(gui,'on');
end