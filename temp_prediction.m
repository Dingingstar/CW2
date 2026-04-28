function temp_prediction(a)

% TEMP_PREDICTION Real-time temperature monitoring and prediction system
% TEMP_PREDICTION(arduino) reads temperature from a thermistor connected
% to analog pin A0, applies a 5-point moving average filter to reduce
% noise, and calculates the real-time temperature change rate in °C/s.
% It predicts the temperature 5 minutes ahead assuming constant rate.
% LED indicators: GREEN (stable), YELLOW (fast cooling < -4°C/min),
% RED (fast heating > +4°C/min). Outputs current temp, rate, and
% prediction to the command window every second.
% Connections: GREEN=D9, YELLOW=D10, RED=D11, Thermistor=A0.
% Input: a - Arduino connection object.

green = 'D9'; % Green LED connected to Digital Pin 9
yellow = 'D10'; % Yellow LED connected to Digital Pin 10
red = 'D11'; % Red LED connected to Digital Pin 11
comfort_min = 18; % Minimum temperature for comfortable range (°C)
comfort_max = 24; % Maximum temperature for comfortable range (°C)
rise_threshold = 4; % Temperature rise rate alert threshold (°C per minute)
fall_threshold = -4; % Temperature fall rate alert threshold (°C per minute)

writeDigitalPin(a, green, 0); % Turn off green LED
writeDigitalPin(a, yellow, 0); % Turn off yellow LED
writeDigitalPin(a, red, 0); % Turn off red LED

time_data = []; % Array to store elapsed time points (seconds)
temp_data = []; % Array to store smoothed temperature values (°C)
t = 0;  % Elapsed time counter (seconds)
sample_interval = 1; % Sampling interval: read data every 1 second
filter_window = 5; % Window size for median filtering (noise reduction)  
rate_window = 5; % Window size for temperature rate calculation
temp_buffer = []; % Buffer to store raw temperature values for filtering

while true
    V = readVoltage(a, 'A0'); % Read raw voltage from temperature sensor (Analog Pin A0)
     current_temp= (V - 0.5)* 1000  / 10; % Use formula to convert voltage to actual temperature

    temp_buffer = [temp_buffer, current_temp]; % Add new reading to buffer 

    % Maintain fixed buffer size by removing oldest value when full
    if length(temp_buffer) > filter_window
        temp_buffer(1) = [];  
    end
    smoothed_temp = median(temp_buffer);  % Calculate smoothed temperature using median value

    % Update time and temperature history arrays
    t = t + sample_interval;
    time_data = [time_data, t];
    temp_data = [temp_data, smoothed_temp];

     % Calculate temperature change rate (°C per second & per minute)
    if length(temp_data) >= rate_window
        prev_temp = temp_data(end - rate_window + 1); % Get temperature from 'rate_window' samples ago
        prev_time = time_data(end - rate_window + 1); % Get time from 'rate_window' samples ago
        delta_temp = smoothed_temp - prev_temp; % Compute change in temperature
        delta_time = t - prev_time; % Compute change in time
        rate_c_per_sec = delta_temp / delta_time;  % Calculate temperature change rate
        rate_c_per_min = rate_c_per_sec * 60; % Convert to °C per minute
    else
        % Not enough data yet: set rates to 0
        rate_c_per_sec = 0;
        rate_c_per_min = 0;  
    end
     predicted_temp = smoothed_temp + rate_c_per_min * 5; % Predict temperature 5 minutes into the future

     % Print real-time data to for monitoring
    fprintf('Current Temp: %.2f °C\n', current_temp);
    fprintf('Smoothed Temp: %.2f °C\n', smoothed_temp);
    fprintf('Change Rate : %.2f °C/s\n', rate_c_per_sec);
    fprintf('Predicted Temp in 5 min: %.2f °C\n', predicted_temp);

    % LED Status Control Logic
    if rate_c_per_min > rise_threshold
        % Condition 1: Rapid temperature rise (>4°C/min) 
        writeDigitalPin(a, green, 0); % Turn off green LED
        writeDigitalPin(a, yellow, 0); % Turn off yellow LED
        writeDigitalPin(a, red, 1); % Turn on red LED
    elseif rate_c_per_min < fall_threshold
        % Condition 2: Rapid temperature drop (<-4°C/min)
        writeDigitalPin(a, green, 0); % Turn off green LED
        writeDigitalPin(a, yellow, 1); % Turn on yellow LED
        writeDigitalPin(a, red, 0); % Turn off red LED
    elseif smoothed_temp >= comfort_min && smoothed_temp <= comfort_max
        % Condition 3: Temperature in comfortable range 
        writeDigitalPin(a, green, 1); % Turn on green LED
        writeDigitalPin(a, yellow, 0); % Turn off yellow LED
        writeDigitalPin(a, red, 0); % Turn off red LED
    else
        % Condition 4: outside comfort range & stable
        writeDigitalPin(a, green, 0); % Turn off green LED
        writeDigitalPin(a, yellow, 0); % Turn off yellow LED
        writeDigitalPin(a, red, 0); % Turn off red LED
    end
    pause(sample_interval); % Wait for next sampling cycle
end
end