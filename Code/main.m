% 2. Machine Learning Architecture (ANN) for PV Power Forecasting
clear; clc;

% Load the advanced non-linear dataset
if ~exist('advanced_solar_data.mat', 'file')
    error('Please run generate_data_advanced.m first.');
end
load('advanced_solar_data.mat');

% Extract Input Features (Inputs) and Target Vector (Outputs)
Inputs = [Advanced_Solar_Data.Solar_Irradiance, ...
          Advanced_Solar_Data.Temperature, ...
          Advanced_Solar_Data.Cloud_Cover]';
Targets = Advanced_Solar_Data.PV_Power';

% Define and Configure the Feedforward Artificial Neural Network (ANN)
% Architecture: Input Layer (3) -> Hidden Layer (10 Neurons) -> Output Layer (1)
hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize, 'trainlm'); % Levenberg-Marquardt backpropagation

% Configure Data Splitting for Training, Validation, and Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio   = 15/100;
net.divideParam.testRatio  = 15/100;

% Turn off training window GUI pop-up for clean execution
net.trainParam.showWindow = false;

% Train the Neural Network Architecture
[net, tr] = train(net, Inputs, Targets);

% Test the Trained Network on Holdout Data
All_Predictions = net(Inputs);

% Extract Testing Performance metrics
testIndices = tr.testInd;
Y_Actual_Test = Targets(testIndices);
Y_Pred_Test = All_Predictions(testIndices);

% Evaluate Model Precision using Mean Absolute Error (MAE)
MAE = mean(abs(Y_Actual_Test - Y_Pred_Test));

% Compute R-squared (Coefficient of Determination) to check tracking fit
R_Matrix = corrcoef(Y_Actual_Test, Y_Pred_Test);
R_Squared = R_Matrix(1,2)^2;

% Display Performance and Optimization Metrics
fprintf('\n==================================================\n');
fprintf('   Advanced ANN Solar Forecasting Model Results\n');
fprintf('==================================================\n');
fprintf('Optimized Mean Absolute Error (MAE) : %.4f Watts\n', MAE);
fprintf('Coefficient of Determination (R^2)  : %.4f\n', R_Squared);
fprintf('==================================================\n');

% Visualization: Performance Evaluation (Actual vs Neural Network Forecast)
figure('Name', 'ANN Solar Power Forecasting Analysis', 'NumberTitle', 'off');
plot(Y_Actual_Test(1:50), '-o', 'LineWidth', 1.5); hold on;
plot(Y_Pred_Test(1:50), '-x', 'LineWidth', 1.5);
xlabel('Sample Data Points (Test Sub-set)');
ylabel('PV Power Output (Watts)');
title('Advanced Solar Power Forecasting: Actual vs. Neural Network Prediction');
legend('Actual Power Output', 'ANN Predicted Power');
grid on;
% View the Graphical Architecture of the Trained Network
view(net);
