
function C = chebspec(N)

  C = gallery('chebspec',N);
  C = C(1:end-1,1:end-1);
end