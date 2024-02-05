import numpy as np
import matplotlib.pyplot as plt

n = 50
A = np.random.randint(1, 10, size=(n, n))  # random integers between 1 and 10

# adjust the region in the complex plane and epsilon
x_min, x_max, y_min, y_max = -10, 10, -10, 10  # Adjusting the range
resolution = 100  # higher resolution
epsilon = 0.01  # adjusting epsilon for better visualization

# recreate the grid of complex numbers
x = np.linspace(x_min, x_max, resolution)
y = np.linspace(y_min, y_max, resolution)
X, Y = np.meshgrid(x, y)
Z = X + 1j * Y

# recompute the pseudospectrum
pseudospectrum = np.zeros(Z.shape, dtype=bool)
I = np.identity(A.shape[0])
for i in range(Z.shape[0]):
    for j in range(Z.shape[1]):
        lambda_ij = Z[i, j]
        try:
            norm = np.linalg.norm(np.linalg.inv(A - lambda_ij * I))
            pseudospectrum[i, j] = norm > (1 / epsilon)
        except np.linalg.LinAlgError:
            pseudospectrum[i, j] = True

# plotting
plt.figure(figsize=(8, 8))
plt.imshow(pseudospectrum, extent=(x_min, x_max, y_min, y_max), origin='lower')
plt.colorbar(label='Part of ε-pseudospectrum')
plt.xlabel('Real Part')
plt.ylabel('Imaginary Part')
plt.title(f'ε-Pseudospectrum of Matrix A (ε = {epsilon})')
plt.grid(True)
plt.show()
