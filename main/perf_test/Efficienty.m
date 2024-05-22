function Efficienty(mesure,size,num_threads,gui)   
    speed_up = bsxfun(@rdivide, mesure(1,:), mesure);
    % Draw the plot
    hold(gui,"on");
    colors = lines(length(speed_up)); % Get various color for each plot
    for i = 2:length(num_threads)
        efficiency = speed_up(i,:)./num_threads(i);
        plot(gui,size, efficiency, 'DisplayName', sprintf('%d threads', num_threads(i)), 'Color', colors(i,:));
    end
    
    xlabel(gui,'Taille de la matrice');
    ylabel(gui,'Efficiency');
    title(gui,'Efficiency en fonction de la taille de la matrice et du nombre de threads');
    legend(gui,'show');
    grid(gui,"on");
    hold(gui,"off");

end