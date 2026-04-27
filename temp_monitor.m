%TEMP_MONITOR Real-time temperature monitoring and visual alert system
%TEMP_MONITOR(arduino) reads temperature from a thermistor on analog pin
%A0 and displays live data in a scrolling plot (60-second window).
%It provides visual feedback using three LEDs: GREEN (stable 18-24°C),
%YELLOW (blinking for <18°C), RED (rapid flashing for >24°C).
%The plot auto-scales and updates every second with temperature data.
%Connections: GREEN=D9, YELLOW=D10, RED=D11, Thermistor=A0.
%Input: a - Arduino connection object.
function temp_monitor(a)
green = 'D9';
yellow = 'D10';
red = 'D11';

writeDigitalPin(a, green, 0);
writeDigitalPin(a, yellow, 0);
writeDigitalPin(a, red, 0);

time_data = [];
temp_data = [];
t = 0;

figure('Name','Live Temperature Monitoring');
grid on; 
h_plot = plot(NaN, NaN, 'b-o', 'LineWidth', 1);
hold on; 
xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Live Temperature Monitoring');
xlim([0 60]);
ylim([24 27]);
while true
    V = readVoltage(a, 'A0');
    temp = (V - 0.5)* 1000  / 10;
    
    t=t+1
    time_data = [time_data, t];
    temp_data = [temp_data, temp];
    if t > 60
            idx = time_data >= (t - 60);
            time_data = time_data(idx);
            temp_data = temp_data(idx);
            xlim([t-60, t]); 
        end
    set(h_plot, 'XData', time_data, 'YData', temp_data);
    drawnow;

    if temp >= 18 && temp <= 24
        writeDigitalPin(a, green, 1);
        writeDigitalPin(a, yellow, 0);
        writeDigitalPin(a, red, 0);
        pause(1); 

    elseif temp < 18
        writeDigitalPin(a, yellow, 1);
        pause(0.5);
        writeDigitalPin(a, yellow, 0);
        pause(0.5);

    else
        writeDigitalPin(a, red, 1);
        pause(0.25);
        writeDigitalPin(a, red, 0);
        pause(0.25);
        writeDigitalPin(a, red, 1);
        pause(0.25);
        writeDigitalPin(a, red, 0);
        pause(0.25);
    end
end