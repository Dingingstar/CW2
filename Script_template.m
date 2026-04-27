% Yixin Ding
% ssyyd14@Nottingham.edu.cn
clear all

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]
a = arduino('COM5', 'Uno');
for i = 1:10
    writeDigitalPin(a, 'D13', 1); 
    pause(0.5);
    
    writeDigitalPin(a, 'D13', 0); 
    pause(0.5); 
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
% b)
duration = 600;
sample_interval = 1; 
TC = 10; 
V0 = 0.5; 
analog_pin = 'A0'; 
time_array = 0:1:duration; 
voltage_array = zeros(1, duration+1);
temp_array = zeros(1, duration+1);
for t = 1:duration+1
    voltage_array(t) = readVoltage(a, analog_pin);
    temp_array(t) = (voltage_array(t) - V0) * 1000 / TC;
    if t <= duration
        pause(sample_interval);
    end
end
min_temp = min(temp_array);
max_temp = max(temp_array);
avg_temp = mean(temp_array);



%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here