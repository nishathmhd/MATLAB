% Benchmark functions
sphere = @(x) sum(x.^2);
rastrigin = @(x) 10 * numel(x) + sum(x.^2 - 10 * cos(2 * pi * x));
griewank = @(x) 1 + sum(x.^2 / 4000) - prod(cos(x ./ sqrt(1:numel(x))));

% Define the benchmark functions
benchmarkFunctions = {sphere, rastrigin, griewank};
functionNames = {'Sphere', 'Rastrigin', 'Griewank'};

% Dimensions to test
dimensions = [2, 10];

% Number of runs for averaging
numRuns = 15;

% Initialize results storage
results = struct();

for funcIdx = 1:numel(benchmarkFunctions)
    func = benchmarkFunctions{funcIdx};
    funcName = functionNames{funcIdx};
    
    for dimIdx = 1:numel(dimensions)
        D = dimensions(dimIdx);
        
        % Storage for performance data
        performances = struct('GA', [], 'PSO', [], 'SA', []);
        
        for run = 1:numRuns
            % GA optimization
            options = optimoptions('ga', 'Display', 'off');
            [~, fval] = ga(func, D, [], [], [], [], [], [], [], options);
            performances.GA = [performances.GA; fval];
            
            % PSO optimization
            options = optimoptions('particleswarm', 'Display', 'off');
            [~, fval] = particleswarm(func, D, [], [], options);
            performances.PSO = [performances.PSO; fval];
            
            % SA optimization
            options = saoptimset('Display', 'off');
            [x, fval] = simulannealbnd(func, rand(1, D), [], [], options);
            performances.SA = [performances.SA; fval];
        end
        
        % Calculate statistics
        results.(funcName).(sprintf('D%d', D)).GA = performances.GA;
        results.(funcName).(sprintf('D%d', D)).PSO = performances.PSO;
        results.(funcName).(sprintf('D%d', D)).SA = performances.SA;
        
        % Display results
        fprintf('Function: %s, Dimensions: %d\n', funcName, D);
        fprintf('GA - Mean: %.4f, Std: %.4f, Best: %.4f, Worst: %.4f\n', ...
            mean(performances.GA), std(performances.GA), min(performances.GA), max(performances.GA));
        fprintf('PSO - Mean: %.4f, Std: %.4f, Best: %.4f, Worst: %.4f\n', ...
            mean(performances.PSO), std(performances.PSO), min(performances.PSO), max(performances.PSO));
        fprintf('SA - Mean: %.4f, Std: %.4f, Best: %.4f, Worst: %.4f\n', ...
            mean(performances.SA), std(performances.SA), min(performances.SA), max(performances.SA));
        
        % Plotting
        figure;
        hold on;
        plot(performances.GA, '-o', 'DisplayName', 'GA');
        plot(performances.PSO, '-x', 'DisplayName', 'PSO');
        plot(performances.SA, '-s', 'DisplayName', 'SA');
        xlabel('Run');
        ylabel('Performance');
        title(sprintf('Performance Comparison on %s Function (D=%d)', funcName, D));
        legend show;
        hold off;
    end
end
