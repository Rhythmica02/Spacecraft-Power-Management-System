% Main system
mdl = 'SpacecraftPowerManagement';
new_system(mdl);
open_system(mdl);

% Solar Panel subsystem
add_block('simulink/Ports & Subsystems/Subsystem', [mdl '/SolarPanel']);
add_block('simulink/Sources/In1', [mdl '/SolarPanel/SolarRadiation']);
add_block('simulink/Sources/In1', [mdl '/SolarPanel/EclipseFactor']);
add_block('simulink/Math Operations/Product', [mdl '/SolarPanel/SolarOutput']);
add_block('simulink/Math Operations/Gain', [mdl '/SolarPanel/Efficiency']);
add_block('simulink/Sinks/Out1', [mdl '/SolarPanel/Output']);
add_line([mdl '/SolarPanel'], 'SolarRadiation/1', 'SolarOutput/1');
add_line([mdl '/SolarPanel'], 'EclipseFactor/1', 'SolarOutput/2');
add_line([mdl '/SolarPanel'], 'SolarOutput/1', 'Efficiency/1');
add_line([mdl '/SolarPanel'], 'Efficiency/1', 'Output/1');
set_param([mdl '/SolarPanel/Efficiency'], 'Gain', '0.3'); % 30% efficiency

% Battery subsystem
add_block('simulink/Ports & Subsystems/Subsystem', [mdl '/Battery']);
add_block('simulink/Sources/In1', [mdl '/Battery/Input']);
add_block('simulink/Continuous/Integrator', [mdl '/Battery/Charge']);
add_block('simulink/Discontinuities/Saturation', [mdl '/Battery/Limits']);
add_block('simulink/Sinks/Out1', [mdl '/Battery/Output']);
add_line([mdl '/Battery'], 'Input/1', 'Charge/1');
add_line([mdl '/Battery'], 'Charge/1', 'Limits/1');
add_line([mdl '/Battery'], 'Limits/1', 'Output/1');
set_param([mdl '/Battery/Charge'], 'InitialCondition', '1000'); % Initial charge in Wh
set_param([mdl '/Battery/Limits'], 'UpperLimit', '2000', 'LowerLimit', '0'); % Battery capacity limits

% Load subsystem
add_block('simulink/Ports & Subsystems/Subsystem', [mdl '/Load']);
add_block('simulink/Sources/Constant', [mdl '/Load/BaseLoad']);
add_block('simulink/Sources/Pulse Generator', [mdl '/Load/PeakLoad']);
add_block('simulink/Math Operations/Add', [mdl '/Load/TotalLoad']);
add_block('simulink/Sinks/Out1', [mdl '/Load/Output']);
add_line([mdl '/Load'], 'BaseLoad/1', 'TotalLoad/1');
add_line([mdl '/Load'], 'PeakLoad/1', 'TotalLoad/2');
add_line([mdl '/Load'], 'TotalLoad/1', 'Output/1');
set_param([mdl '/Load/BaseLoad'], 'Value', '500'); % Base load in W
set_param([mdl '/Load/PeakLoad'], 'Amplitude', '1000', 'Period', '3600', 'PulseWidth', '10'); % Peak load

% Main system blocks
add_block('simulink/Sources/Constant', [mdl '/SolarRadiation']);
add_block('simulink/Sources/Sine Wave', [mdl '/EclipseFactor']);
add_block('simulink/Math Operations/Sum', [mdl '/PowerBalance']);
add_block('simulink/Sinks/Scope', [mdl '/PowerScope']);

% Set block parameters
set_param([mdl '/SolarRadiation'], 'Value', '1366'); % W/m^2
set_param([mdl '/EclipseFactor'], 'Amplitude', '0.5', 'Bias', '0.5', 'Frequency', '1/5400'); % Assuming 90-minute orbit
set_param([mdl '/PowerBalance'], 'Inputs', '+++'); % All positive inputs
add_block('simulink/Math Operations/Gain', [mdl '/NegateLoad']);
set_param([mdl '/NegateLoad'], 'Gain', '-1');

% Connect blocks in main system
add_line(mdl, 'SolarRadiation/1', 'SolarPanel/1');
add_line(mdl, 'EclipseFactor/1', 'SolarPanel/2');
add_line(mdl, 'SolarPanel/1', 'PowerBalance/1');
add_line(mdl, 'Battery/1', 'PowerBalance/2');
add_line(mdl, 'Load/1', 'NegateLoad/1');
add_line(mdl, 'NegateLoad/1', 'PowerBalance/3');

% Add Delay to break the algebraic loop
add_block('simulink/Discrete/Unit Delay', [mdl '/Delay']);
set_param([mdl '/Delay'], 'SampleTime', '0.01');
add_line(mdl, 'PowerBalance/1', 'Delay/1');
add_line(mdl, 'Delay/1', 'Battery/1'); % Feedback with delay

% Connect output to scope
add_line(mdl, 'PowerBalance/1', 'PowerScope/1');

% Set simulation parameters
set_param(mdl, 'StopTime', '10800'); % Simulate for 3 hours
set_param(mdl, 'RelTol', '1e-6');    % Smaller tolerance for better convergence
set_param(mdl, 'Solver', 'ode45');   % Solver for non-stiff problems

% Save and close the system
save_system(mdl);
close_system(mdl);
