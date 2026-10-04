% 1. ดึงข้อมูล Data 1 
dist1_no = data1_noShield_avg.Distance_mm; 
mag1_no  = data1_noShield_avg.Mag_Sensor_Avg * 1000;
dist1_with = data1_withShield_avg.Distance_mm;
mag1_with  = data1_withShield_avg.Mag_Sensor_Avg * 1000;

% 2. ดึงข้อมูล Data 2 (ตรวจสอบชื่อคอลัมน์ของคุณอีกครั้งว่าตรงกันไหม)
dist2_no = data2_noShield_avg.Distance_mm;
mag2_no  = data2_noShield_avg.Mag_Sensor_Avg * 1000;
dist2_with = data2_withShield_avg.Distance_mm;
mag2_with  = data2_withShield_avg.Mag_Sensor_Avg * 1000;

% สร้างหน้าต่าง Figure และปรับให้กว้างขึ้นเพื่อวาง 2 กราฟสบายๆ
figure('Name', 'Magnetic Sensor Comparison', 'Position', [100, 100, 1200, 450]);

% ==========================================
% กราฟที่ 1 (แบ่งครึ่ง ซ้ายมือ)
% ==========================================
subplot(1, 2, 1); % หมายถึง: แบ่ง 1 แถว, 2 คอลัมน์, และนี่คือตำแหน่งที่ 1
plot(dist1_no, mag1_no, 'ro-', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
hold on;
plot(dist1_with, mag1_with, 'bs-', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
hold off;

% ตกแต่งกราฟซ้าย
title('Data 1 (1st Polar): No Shield vs With Shield');
xlabel('Distance (mm)');
ylabel('Mag Sensor Avg (mV)');
legend('No Shield', 'With Shield', 'Location', 'best');
grid minor;
grid on;

% ==========================================
% กราฟที่ 2 (แบ่งครึ่ง ขวามือ)
% ==========================================
subplot(1, 2, 2); % หมายถึง: แบ่ง 1 แถว, 2 คอลัมน์, และนี่คือตำแหน่งที่ 2
plot(dist2_no, mag2_no, 'ro-', 'LineWidth', 1.5, 'MarkerFaceColor', 'r');
hold on;
plot(dist2_with, mag2_with, 'bs-', 'LineWidth', 1.5, 'MarkerFaceColor', 'b');
hold off;

% ตกแต่งกราฟขวา
title('Data 2(2nd Polar): No Shield vs With Shield');
xlabel('Distance (mm)');
ylabel('Mag Sensor Avg (mV)');
legend('No Shield', 'With Shield', 'Location', 'best');
grid on;
grid minor;