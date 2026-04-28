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
writeDigitalPin(a, green, 0);
writeDigitalPin(a, yellow, 0);
writeDigitalPin(a, red, 0);
time_data = [];
temp_data = [];
t = 0;
filter_window = 5;  
temp_buffer = [];
while true
    V = readVoltage(a, 'A0');
     current_temp= (V - 0.5)* 1000  / 10;

    temp_buffer = [temp_buffer, current_temp];  
    if length(temp_buffer) > filter_window
        temp_buffer(1) = [];  
    end
    smoothed_temp = mean(temp_buffer); 

    t = t + 1;
    time_data = [time_data, t];
    temp_data = [temp_data, smoothed_temp];
    if length(temp_data) >= 2
        prev_temp = temp_data(end-1);
        delta_temp = smoothed_temp - prev_temp;
        rate_c_per_sec = delta_temp / 1;
        rate_c_per_min = rate_c_per_sec * 60;
    else
        rate_c_per_sec = 0;
        rate_c_per_min = 0;  
    end
     predicted_temp = smoothed_temp + rate_c_per_min * 5;

    fprintf('Current Temp: %.2f °C\n', current_temp);
    fprintf('Change Rate : %.2f °C/s\n', rate_c_per_sec);
    fprintf('Predicted Temp in 5 min: %.2f °C\n', predicted_temp);
    
 if rate_c_per_min >= -4 && rate_c_per_min <= 4
        writeDigitalPin(a, green, 1);
        writeDigitalPin(a, yellow, 0);
        writeDigitalPin(a, red, 0);
    elseif rate_c_per_min < -4
        writeDigitalPin(a, green, 0);
        writeDigitalPin(a, yellow, 1);
        writeDigitalPin(a, red, 0);
    else
        writeDigitalPin(a, green, 0);
        writeDigitalPin(a, yellow, 0);
        writeDigitalPin(a, red, 1);
    end
    pause(1);  % 1-second sample interval
end