function temp_monitor(a)
green = 'D9';
yellow = 'D10';
red = 'D11';

% 初始化所有LED关闭
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
    pause(1)
end