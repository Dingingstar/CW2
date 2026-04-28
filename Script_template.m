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
% % b)
% duration = 600;
% sample_interval = 1; 
% TC = 10; 
% V0 = 0.5; 
% analog_pin = 'A0'; 
% time_array = 0:sample_interval:duration; 
% voltage_array = zeros(1, duration+1);
% temp_array = zeros(1, duration+1);
% for t = 1:duration+1
%     voltage_array(t) = readVoltage(a, analog_pin);
%     temp_array(t) = (voltage_array(t) - V0) * 1000 / TC;
%     if t <= duration
%         pause(sample_interval);
%     end
% end
% min_temp = min(temp_array);
% max_temp = max(temp_array);
% avg_temp = mean(temp_array);
% 
% % c)
% figure;
% plot(time_array, temp_array, 'k-', 'LineWidth', 1.5);
% xlabel('Time (seconds)');
% ylabel('Temperature (°C)');
% title('Temperature Variation Over Time');
% grid on;
% 
% % d)
% clc;
% date_str = datestr(now, '27/4/2026'); 
% location_str = 'Nottingham IAMET406';
% fprintf('Data logging initiated - %s\n', date_str);
% fprintf('Location - %s\n\n', location_str);
% for minute = 0:10
%     index = minute * 60 + 1;
%     current_temp = temp_array(index);
%     fprintf('Minute\t%d\n', minute);
%     fprintf('Temperature\t%.2f °C\n\n', current_temp);
% end
% fprintf('Max temp\t%.2f °C\n', max_temp);
% fprintf('Min temp\t%.2f °C\n', min_temp);
% fprintf('Average temp\t%.2f °C\n\n', avg_temp);
% fprintf('Data logging terminated\n');
% 
% % e)
% fileID = fopen('capsule_temperature.txt', 'w'); 
% fprintf(fileID, 'Data logging initiated - %s\n', date_str);
% fprintf(fileID, 'Location - %s\n\n', location_str);
% for minute = 0:10
%     index = minute * 60 + 1;
%     current_temp = temp_array(index);
%     fprintf(fileID, 'Minute\t%d\n', minute);
%     fprintf(fileID, 'Temperature\t%.2f °C\n\n', current_temp);
% end
% fprintf(fileID, 'Max temp\t%.2f °C\n', max_temp);
% fprintf(fileID, 'Min temp\t%.2f °C\n', min_temp);
% fprintf(fileID, 'Average temp\t%.2f °C\n\n', avg_temp);
% fprintf(fileID, 'Data logging terminated\n');
% fclose(fileID); 

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
% temp_monitor(a);


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]
% temp_prediction(a);


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]
% In Word.