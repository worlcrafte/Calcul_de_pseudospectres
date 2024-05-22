function SpeedUp(mesure,size,num_threads,gui)

    speed_up = bsxfun(@rdivide, mesure(1,:), mesure);

    % Tracer les courbes
    hold(gui,"on");
    colors = lines(length(speed_up)); % Obtenir des couleurs différentes pour chaque courbe
    
    for i = 2:length(num_threads)
        plot(gui,size, speed_up(i,:), 'DisplayName', sprintf('%d threads', num_threads(i)), 'Color', colors(i,:));
    end
    
    xlabel(gui,'Taille de la matrice');
    ylabel(gui,'Speed-up');
    title(gui,'Speed-up en fonction de la taille de la matrice et du nombre de threads');
    legend(gui,'show');
    grid(gui,'on');
    hold(gui ,"off");

end