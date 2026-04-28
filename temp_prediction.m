%TEMP_PREDICTION Real-time temperature monitoring and prediction system
%TEMP_PREDICTION(arduino) reads temperature from a thermistor connected
%to analog pin A0, applies a 5-point moving average filter to reduce
%noise, and calculates the real-time temperature change rate in °C/s.
%It predicts the temperature 5 minutes ahead assuming constant rate.
%LED indicators: GREEN (stable), YELLOW (fast cooling < -4°C/min),
%RED (fast heating > +4°C/min). Outputs current temp, rate, and
%prediction to the command window every second.
%Connections: GREEN=D9, YELLOW=D10, RED=D11, Thermistor=A0.
%Input: a - Arduino connection object.
function temp_prediction(a)
green = 'D9';
yellow = 'D10';
red = 'D11';
comfort_min = 18;
comfort_max = 24;
rise_threshold = 4;
fall_threshold = -4;
writeDigitalPin(a, green, 0);
writeDigitalPin(a, yellow, 0);
writeDigitalPin(a, red, 0);
time_data = [];
temp_data = [];
t = 0;
sample_interval = 1;
filter_window = 5;  
rate_window = 5;
temp_buffer = [];
while true
    V = readVoltage(a, 'A0');
     current_temp= (V - 0.5)* 1000  / 10;

    temp_buffer = [temp_buffer, current_temp];  
    if length(temp_buffer) > filter_window
        temp_buffer(1) = [];  
    end
    smoothed_temp = median(temp_buffer); 

    t = t + sample_interval;
    time_data = [time_data, t];
    temp_data = [temp_data, smoothed_temp];
    if length(temp_data) >= rate_window
        prev_temp = temp_data(end - rate_window + 1);
        prev_time = time_data(end - rate_window + 1);
        delta_temp = smoothed_temp - prev_temp;
        delta_time = t - prev_time;
        rate_c_per_sec = delta_temp / delta_time;
        rate_c_per_min = rate_c_per_sec * 60;
    else
        rate_c_per_sec = 0;
        rate_c_per_min = 0;  
    end
     predicted_temp = smoothed_temp + rate_c_per_min * 5;

    fprintf('Current Temp: %.2f °C\n', current_temp);
    fprintf('Smoothed Temp: %.2f °C\n', smoothed_temp);
    fprintf('Change Rate : %.2f °C/s\n', rate_c_per_sec);
    fprintf('Predicted Temp in 5 min: %.2f °C\n', predicted_temp);
    if rate_c_per_min > rise_threshold
        writeDigitalPin(a, green, 0);
        writeDigitalPin(a, yellow, 0);
        writeDigitalPin(a, red, 1);
    elseif rate_c_per_min < fall_threshold
        writeDigitalPin(a, green, 0);
        writeDigitalPin(a, yellow, 1);
        writeDigitalPin(a, red, 0);
    elseif smoothed_temp >= comfort_min && smoothed_temp <= comfort_max
        writeDigitalPin(a, green, 1);
        writeDigitalPin(a, yellow, 0);
        writeDigitalPin(a, red, 0);
    else
        writeDigitalPin(a, green, 0);
        writeDigitalPin(a, yellow, 0);
        writeDigitalPin(a, red, 0);
    end
    pause(sample_interval);
end
end