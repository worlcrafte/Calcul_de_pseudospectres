N = 50;

C = gallery('chebspec',N);
C = C(1:end-1,1:end-1);

m = [N N*N/4 N*N/2 N*N];
    
t = tiledlayout(2,2);
nexttile
gridPseudospectrum_par(C,[-1 -2 -3], m(1));
nexttile
gridPseudospectrum_par(C,[-1 -2 -3], m(2));
%nexttile
%gridPseudospectrum_par(C,[-1 -2 -3], m(3));
%nexttile
%gridPseudospectrum_par(C,[-1 -2 -3], m(4));