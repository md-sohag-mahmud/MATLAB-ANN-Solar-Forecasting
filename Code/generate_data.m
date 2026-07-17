% 1. Advanced Non-Linear Dataset Generation for Solar Power Forecasting
clear; clc;

% Define the number of historical data samples (1000 days)
n = 1000; 

% Set random seed for reproducibility
rng(42);

% Generate Meteorological Features
Solar_Irradiance = 200 + (1000-200).*rand(n,1); % Range: 200 to 1000 W/m^2
Temperature = 15 + (40-15).*rand(n,1);          % Range: 15°C to 40°C
Cloud_Cover = rand(n,1);                         % Range: 0 (Clear) to 1 (Thick Clouds)

% Simulate Real-World Non-Linear PV Power Output Equation
% Incorporating exponential decay for cloud cover and temperature interaction
Thermal_Loss = 0.002 * (Temperature - 25).^2; 
Cloud_Attenuation = exp(-2.5 * Cloud_Cover);
Base_Power = Solar_Irradiance .* Cloud_Attenuation .* (1 - Thermal_Loss);

% Add Gaussian environmental noise (Volatility constraint)
Noise = 25 * randn(n,1); 
PV_Power = max(0, Base_Power + Noise); % Power cannot be negative

% Consolidate into a MATLAB Table and Save
Advanced_Solar_Data = table(Solar_Irradiance, Temperature, Cloud_Cover, PV_Power);
save('advanced_solar_data.mat', 'Advanced_Solar_Data');

disp('Advanced non-linear solar dataset successfully generated!');
