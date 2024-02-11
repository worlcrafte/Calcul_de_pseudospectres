import numpy as np
import matplotlib.pyplot as plt
from scipy.linalg import lu

def generate_matrix(N):
    mu = 1
    sigma = 5
    np.random.seed(0)  # similar to rng('Default') in MATLAB
    res = np.random.normal(mu, sigma, (N, N))
    return res

def grid2(A, m):
    # 
    N = A.shape[0]
    x = np.linspace(-1.5, 1.5, m)
    y = np.linspace(-1.5, 1.5, m)
    maxit = m
    sigmin = np.zeros((m, m))

    for k in range(m):
        for j in range(m):
            B = (x[k] + y[j]*1j) * np.eye(N) - A
            u = np.random.randn(N) + 1j * np.random.randn(N)
            L, U = lu(B, permute_l=True)
            Ls = L.conj().T
            Us = U.conj().T
            sigold = 1

            for p in range(maxit):
                u = np.linalg.solve(Ls, np.linalg.solve(Us, np.linalg.solve(U, np.linalg.solve(L, u)))) # u = Ls\(Us\(U\(L)))
                sig = 1 / np.linalg.norm(u)
                
                if np.abs(sigold/sig - 1) < 1e-2:
                    break

                u = sig * u
                sigold = sig

            sigmin[j, k] = np.sqrt(sig)

    plt.contour(x, y, np.log10(sigmin))
    # plt.xlabel('Real Part')
    # plt.ylabel('Imaginary Part')
    plt.title('Contour Plot of the ε-Pseudospectrum of Matrix A')
    plt.grid(True)
    plt.show()

A = generate_matrix(50)
grid2(A, 100)