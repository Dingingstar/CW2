% Yixin Ding
% ssyyd14@Nottingham.edu.cn
clear all % Clear all variables from MATLAB workspace to ensure clean startup

% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]
 a = arduino('COM5', 'Uno'); % Establish MATLAB-Arduino communication: connect to Arduino Uno on COM5 port
for i = 1:10 % FOR loop: Repeat LED blink 10 times
    writeDigitalPin(a, 'D13', 1); % Set digital pin D13 to HIGH (turn LED ON)
    pause(0.5); % Keep LED ON for 0.5 seconds

    writeDigitalPin(a, 'D13', 0); % Set digital pin D13 to LOW (turn LED OFF)
    pause(0.5); % Keep LED OFF for 0.5 seconds
end

%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
% b)
duration = 600; % Total data acquisition time: 600 seconds (10 minutes)
sample_interval = 1;  % Sampling interval: 1 second between readings
TC = 10; % Temperature coefficient of sensor (mV/°C)
V0 = 0.5; % Sensor output voltage at 0°C (volts)
analog_pin = 'A0'; % Analog pin A0 connected to temperature sensor
time_array = 0:sample_interval:duration; % Time array from 0 to 600 seconds
voltage_array = zeros(1, duration+1); % Array to store raw voltage readings
temp_array = zeros(1, duration+1); % Array to store converted temperature values

% Acquire data in a loop for the full duration
for t = 1:duration+1
    voltage_array(t) = readVoltage(a, analog_pin); % Read analog voltage from sensor
    temp_array(t) = (voltage_array(t) - V0) * 1000 / TC; % Convert voltage to temperature (°C)
    if t <= duration
        pause(sample_interval);% Pause for sampling interval except after last sample
    end
end
min_temp = min(temp_array); % Compute minimum temperature
max_temp = max(temp_array); % Compute maximum temperature
avg_temp = mean(temp_array); % Compute average temperature

% c)
figure; % Create a new figure window
plot(time_array, temp_array, 'b-', 'LineWidth', 1.5); % Plot temperature against time
xlabel('Time (seconds)'); % Label x-axis: time in seconds
ylabel('Temperature (°C)'); % Label y-axis: temperature in °C
title('Temperature Variation Over Time'); % Add plot title
grid on; % Enable grid for better readability

% d)
clc; % Clear command window for clean output
date_str = datestr(now, 'dd/mm/yyyy'); % Get current date in dd/mm/yyyy format
location_str = 'Nottingham IAMET406'; % Set recording location string

% Print log header
fprintf('Data logging initiated - %s\n', date_str);
fprintf('Location - %s\n\n', location_str);

% Print temperature data for each minute (0 to 10 minutes)
for minute = 0:10
    index = minute * 60 + 1; % Compute array index for each minute
    current_temp = temp_array(index); % Get temperature at this minute
    fprintf('Minute\t\t%d\n', minute); % Print minute number
    fprintf('Temperature\t%.2f °C\n\n', current_temp); % Print temperature with 2 decimal places
end

fprintf('Max temp\t\t%.2f °C\n', max_temp); % Print maximum temperature recorded
fprintf('Min temp\t\t%.2f °C\n', min_temp); % Print minimum temperature recorded
fprintf('Average temp\t%.2f °C\n\n', avg_temp); % Print average temperature over the test
fprintf('Data logging terminated\n'); % Print data logging completion message

% e)
fileID = fopen('capsule_temperature.txt', 'w'); % Open/create text file for writing

% Write log header information to the text file
fprintf(fileID, 'Data logging initiated - %s\n', date_str);
fprintf(fileID, 'Location - %s\n\n', location_str);

% Loop through each minute (0 to 10) and write data to text fil
for minute = 0:10
    index = minute * 60 + 1; % Calculate array index for each minute mark
    current_temp = temp_array(index); % Retrieve temperature at current minute
    fprintf(fileID, 'Minute\t\t%d\n', minute); % Write minute number to file
    fprintf(fileID, 'Temperature\t%.2f °C\n\n', current_temp); % Write temperature value to file
end

fprintf(fileID, 'Max temp\t\t%.2f °C\n', max_temp); % Write maximum temperature to file
fprintf(fileID, 'Min temp\t\t%.2f °C\n', min_temp); % Write minimum temperature to file
fprintf(fileID, 'Average temp\t%.2f °C\n\n', avg_temp); % Write average temperature to file
fprintf(fileID, 'Data logging terminated\n'); % Write logging end message to file

fclose(fileID); % Close the text file to ensure data is saved correctly

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
temp_monitor(a);


