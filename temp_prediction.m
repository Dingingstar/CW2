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
while true
    V = readVoltage(a, 'A0');
     current_temp= (V - 0.5)* 1000  / 10;
    
    t=t+1
    time_data = [time_data, t];
    temp_data = [temp_data,  current_temp];
    if length(temp_data) >= 2
        prev_temp = temp_data(end-1);
        delta_temp = current_temp - prev_temp;
        rate_c_per_sec = delta_temp / 1;
        rate_c_per_min = rate_c_per_sec * 60;
    else
        rate_c_per_min = 0;  
    end
     predicted_temp = current_temp + rate_c_per_min * 5;
     fprintf('Current Temp: %.2f °C\n', current_temp);
    fprintf('Change Rate : %.2f °C/min\n', rate_c_per_min);
    fprintf('Predicted Temp in 5 min: %.2f °C\n', predicted_temp);
    pause(1);  % 1-second sample interval
end