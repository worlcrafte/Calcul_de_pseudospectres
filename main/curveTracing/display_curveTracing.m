function pred = display_curveTracing(eigen_values,points,gui)
    hold(gui,"on");
    plot(gui,real(eigen_values), imag(eigen_values),'X', 'MarkerEdgeColor','red');
    [siz,~] = size(eigen_values);
    c = lines(siz);
    pred=cell(1,siz);
    for lambda0=1:siz
        color = c(lambda0,:);  
        pred{lambda0} = scatter(gui,real(points{lambda0}), imag(points{lambda0}),'MarkerEdgeColor',color);
        
    end
    drawnow;
    hold(gui,"off");
    axis(gui,"equal");
    xlabel(gui,'Real part (\lambda)');
    ylabel(gui,'Imaginary part (\lambda)');
    title(gui,'Combined Pseudospectrum Visualization');
    grid(gui,'on');
end