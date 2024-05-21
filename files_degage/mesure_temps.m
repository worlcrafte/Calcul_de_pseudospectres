N = 20;
nb_mesure = 5; 

ymin = 0;

x = N:10:N*nb_mesure;
mesure = zeros(nb_mesure,1);
if isempty(gcp('nocreate'))
        parpool;
end

parfor i=1:nb_mesure
    C = gallery('chebspec',x(i));
    C = C(1:end-1,1:end-1);
    tic
    gridPseudospectrum(C,[-1;-2;-3],x(i)*x(i));
    mesure(i)= toc;
end
ymax = max(mesure);

y = linspace(ymin, ymax, nb_mesure);
plot(x,log10(mesure));
title('Log10 of the measured time of the grid agorithm on 16 threads');
xlabel('the size of the matrix (x = n*n)');
ylabel('the log10 of the mesured time in seconds');
grid on;