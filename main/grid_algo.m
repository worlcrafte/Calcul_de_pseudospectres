function sigmin = grid_algo(A, m)
    %g = 1/norm(((x+y)))
    %z(0) = newtons_method()
    
    %[S, U, V] = svd(z(1) - A);

    %for k = 2:N
     %   z(k) = z(k - 1) + tho * i(v * u) / norm(v * u);
      %  [S, U, V] = svd(z(k) - A);
       % z(k) = z(k) - (S - e) / (u * v);
        %plot(z);
    %end
    %sigmin = z;
    [N,~] = size(A);
    x = logspace(-1, 1, m);
    y = logspace(-1, 1, m);
    for k=1:m , for j = 1:m
        sigmin(j,k) = min(svd((x(k)+y(j)*1i*eye(N)-A)));
    end,end
    contour(x,y,log10(sigmin));
end
