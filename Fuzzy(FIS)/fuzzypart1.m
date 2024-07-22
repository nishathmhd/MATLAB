% Define the FIS
fis = mamfis('Name', 'FanSpeedControl');

% Add input variables
fis = addInput(fis, [0 40], 'Name', 'Temperature');
fis = addInput(fis, [0 100], 'Name', 'Humidity');

% Add output variable
fis = addOutput(fis, [0 100], 'Name', 'FanSpeed');

% Add membership functions for Temperature
fis = addMF(fis, 'Temperature', 'trimf', [-10 0 20], 'Name', 'Low');
fis = addMF(fis, 'Temperature', 'trimf', [10 20 30], 'Name', 'Medium');
fis = addMF(fis, 'Temperature', 'trimf', [20 40 50], 'Name', 'High');

% Add membership functions for Humidity
fis = addMF(fis, 'Humidity', 'trimf', [0 20 40], 'Name', 'Low');
fis = addMF(fis, 'Humidity', 'trimf', [30 50 70], 'Name', 'Medium');
fis = addMF(fis, 'Humidity', 'trimf', [60 80 100], 'Name', 'High');

% Add membership functions for FanSpeed
fis = addMF(fis, 'FanSpeed', 'trimf', [0 25 50], 'Name', 'Low');
fis = addMF(fis, 'FanSpeed', 'trimf', [25 50 75], 'Name', 'Medium');
fis = addMF(fis, 'FanSpeed', 'trimf', [50 75 100], 'Name', 'High');

% Add rules
rules = [1 1 1 1 1;
         1 2 2 1 1;
         1 3 3 1 1;
         2 1 1 1 1;
         2 2 2 1 1;
         2 3 3 1 1;
         3 1 2 1 1;
         3 2 3 1 1;
         3 3 3 1 1];

fis = addRule(fis, rules);

% Save the FIS for future use
writeFIS(fis, 'FanSpeedControl');

% Generate the FIS Structure plot (if needed)
figure;
subplot(2,2,1);
plotmf(fis, 'input', 1);
title('Membership Functions for Temperature');

subplot(2,2,2);
plotmf(fis, 'input', 2);
title('Membership Functions for Humidity');

subplot(2,2,3);
plotmf(fis, 'output', 1);
title('Membership Functions for FanSpeed');

% Generate the Control Surface plot
figure;
gensurf(fis);
title('Control Surface Plot');
xlabel('Temperature');
ylabel('Humidity');
zlabel('Fan Speed');

% Open the Rule Viewer
figure;
ruleview(fis);
title('Rule Viewer');
