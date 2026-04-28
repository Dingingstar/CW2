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
