function temp_monitor(a)

%TEMP_MONITOR Real-time temperature monitoring and visual alert system
%TEMP_MONITOR(arduino) reads temperature from a thermistor on analog pin
%A0 and displays live data in a scrolling plot (60-second window).
%It provides visual feedback using three LEDs: GREEN (stable 18-24°C),
%YELLOW (blinking for <18°C), RED (rapid flashing for >24°C).
%The plot auto-scales and updates every second with temperature data.
%Connections: GREEN=D9, YELLOW=D10, RED=D11, Thermistor=A0.
%Input: a - Arduino connection object.

green = 'D9'; % Green LED connected to Digital Pin 9
yellow = 'D10'; % Yellow LED connected to Digital Pin 10
red = 'D11'; % Red LED connected to Digital Pin 11

writeDigitalPin(a, green, 0);  % Turn off green LED
writeDigitalPin(a, yellow, 0); % Turn off yellow LED
writeDigitalPin(a, red, 0); % Turn off red LED

time_data = []; % Array to store elapsed time points (seconds)
temp_data = []; % Array to store raw temperature values (°C)
t = 0; % Elapsed time counter (seconds)

figure('Name','Live Temperature Monitoring'); % Create a figure for live temperature plot
grid on; % Display grid for better plot readability
h_plot = plot(NaN, NaN, 'b-o', 'LineWidth', 1); % Create empty plot for dynamic data update
hold on;  % Keep plot active for continuous updates
xlabel('Time (s)'); % Label x-axis as time in seconds
ylabel('Temperature (°C)'); % Label y-axis as temperature in Celsius
title('Live Temperature Monitoring'); % Add title to the plot
xlim([0 60]); % Set initial x-axis to show 60-second sliding window
ylim([24 27]); % Set initial y-axis for typical temperature range
while true % Infinite loop for real-time monitoring
    V = readVoltage(a, 'A0'); % Read raw voltage from temperature sensor on Analog Pin A0
    temp = (V - 0.5)* 1000  / 10; % Convert voltage reading to temperature in Celsius
    
    t = t+1; % Increment time counter by 1 second
    time_data = [time_data, t]; % Append new time to time history array
    temp_data = [temp_data, temp]; % Append new temperature to temperature history array

    % Maintain 60-second sliding window by removing old data
    if t > 60
            idx = time_data >= (t - 60); % Keep only data within the last 60 seconds
            time_data = time_data(idx); % Update time array with recent data
            temp_data = temp_data(idx); % Update temperature array with recent data
            xlim([t-60, t]); % Update x-axis to follow latest 60-second window
        end
    set(h_plot, 'XData', time_data, 'YData', temp_data); % Update plot with new data
    drawnow; % Force MATLAB to refresh plot immediately

    % LED Control Logic based on current temperature
    if temp >= 18 && temp <= 24
        % Condition 1: Temperature in comfortable range
        writeDigitalPin(a, green, 1); % Turn on green LED
        writeDigitalPin(a, yellow, 0); % Turn off yellow LED
        writeDigitalPin(a, red, 0); % Turn off red LED
        pause(1); % Maintain steady state for 1 second

    elseif temp < 18
        % Condition 2: Temperature below comfort range, slow yellow blink
        writeDigitalPin(a, yellow, 1); % Turn on yellow LED
        pause(0.5); % Keep on for 0.5 second
        writeDigitalPin(a, yellow, 0); % Turn off yellow LED
        pause(0.5); % Keep off for 0.5 second

    else
        % Condition 3: Temperature above comfort range, rapid red flash
        writeDigitalPin(a, red, 1); % Turn on red LED
        pause(0.25); % Keep on for 0.25 second
        writeDigitalPin(a, red, 0); % Turn off red LED
        pause(0.25); % Keep off for 0.25 second
        writeDigitalPin(a, red, 1);
        pause(0.25);
        writeDigitalPin(a, red, 0);
        pause(0.25);
    end
end