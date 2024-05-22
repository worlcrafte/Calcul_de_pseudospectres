function main
    cores = [1, 2, 8, 16];
    sizes = 50 + 20 * (0:5);  % X, les tailles des matrices
    disp(sizes);

    % Load the MATLAB files
    matlab_file1 = load('time_mesurment_par_pas_de_10_de_50_a_150_pour_1_2_8_16_threads.mat');
    data_grid = matlab_file1.result;

    grid_speedup = arrayfun(@(i) compute_speedup(data_grid(1, :), data_grid(i + 1, :)), 1:(size(data_grid, 1) - 1), 'UniformOutput', false);
    grid_efficiency = arrayfun(@(i) compute_efficiency(cores(i + 1), grid_speedup{i}), 1:(length(grid_speedup)), 'UniformOutput', false);

    matlab_file2 = load('time_mesurment_pas_pas_de_10_de_50_a_150_pour_1_2_8_16_thread_pour_curvetracing.mat');
    data_curve = matlab_file2.r;

    curve_speedup = arrayfun(@(i) compute_speedup(data_curve(1, :), data_curve(i + 1, :)), 1:(size(data_curve, 1) - 1), 'UniformOutput', false);
    curve_efficiency = arrayfun(@(i) compute_efficiency(cores(i + 1), curve_speedup{i}), 1:(length(curve_speedup)), 'UniformOutput', false);

    ratios_two_algo = data_grid(1, :) ./ data_curve(1, :);

    % Plot the data
    % Uncomment the section you want to plot

    %======================== ALGO GRID ===============================%
    figure;
    plot(sizes, grid_speedup{1}, 'DisplayName', '2 cores', 'Marker', 'o'); hold on;
    plot(sizes, grid_speedup{2}, 'DisplayName', '8 cores', 'Marker', 's');
    plot(sizes, grid_speedup{3}, 'DisplayName', '16 cores', 'Marker', '^');

    title('Speedup as a function of N');
    xlabel('Matrix size (N)');
    ylabel('Speedup (T_P / T_1)');

    legend('Location', 'upper right');
    hold off;
    %=====================================================================%

    %{
    figure;
    plot(sizes, grid_efficiency{1}, 'DisplayName', '2 cores', 'Marker', 'o'); hold on;
    plot(sizes, grid_efficiency{2}, 'DisplayName', '8 cores', 'Marker', 's');
    plot(sizes, grid_efficiency{3}, 'DisplayName', '16 cores', 'Marker', '^');

    title('Efficiency as a function of N');
    xlabel('Matrix size (N)');
    ylabel('Efficiency (T_P / P)');

    legend('Location', 'upper right');
    hold off;
    %}

    %======================== ALGO CURVE TRACING =============================%
    %{
    figure;
    plot(sizes, curve_speedup{1}, 'DisplayName', '2 cores', 'Marker', 'o'); hold on;
    plot(sizes, curve_speedup{2}, 'DisplayName', '8 cores', 'Marker', 's');
    plot(sizes, curve_speedup{3}, 'DisplayName', '16 cores', 'Marker', '^');

    title('Speedup as a function of N');
    xlabel('Matrix size (N)');
    ylabel('Speedup (T_P / T_1)');

    legend('Location', 'upper right');
    hold off;
    %}

    %{
    figure;
    plot(sizes, curve_efficiency{1}, 'DisplayName', '2 cores', 'Marker', 'o'); hold on;
    plot(sizes, curve_efficiency{2}, 'DisplayName', '8 cores', 'Marker', 's');
    plot(sizes, curve_efficiency{3}, 'DisplayName', '16 cores', 'Marker', '^');

    title('Efficiency as a function of N');
    xlabel('Matrix size (N)');
    ylabel('Efficiency (T_P / P)');

    legend('Location', 'upper right');
    hold off;
    %}

    %==========================COMPARE TWO ALGOS ===============================%
    %{
    figure;
    plot(sizes, data_grid(1, :), 'DisplayName', 'Algo Grid', 'Marker', 'o'); hold on;
    plot(sizes, data_curve(1, :), 'DisplayName', 'Curve Tracing', 'Marker', 's');

    title('Grid vs Curve Tracing as a function of N');
    xlabel('Matrix size (N)');
    ylabel('Execution time (sec)');

    legend('Location', 'upper right');
    hold off;
    %}

    %{
    figure;
    plot(sizes, ratios_two_algo, 'DisplayName', 'T_Grid / T_Curve', 'Marker', 'o');

    title('Grid vs Curve Tracing as a function of N');
    xlabel('Matrix size (N)');
    ylabel('Ratio');

    legend('Location', 'upper right');
    %}
end

function speedup = compute_speedup(tab_T1, tab_TP)
    if length(tab_T1) ~= length(tab_TP)
        error('tab_T1 and tab_TP must have same length');
    end
    speedup = tab_T1 ./ tab_TP;
end

function efficiency = compute_efficiency(nb_cores, tab_speedup)
    efficiency = tab_speedup / nb_cores;
end
