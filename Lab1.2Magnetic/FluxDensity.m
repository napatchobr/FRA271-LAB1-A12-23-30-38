% =========================================================================
% สคริปต์อ่านข้อมูล CSV 4 ไฟล์, คำนวณ Magnetic Flux Density
% และพลอตเปรียบเทียบค่าที่อ่านได้ (Sensor Avg) กับค่าที่คำนวณได้ (Flux Density)
% =========================================================================

clear; clc; close all;

%% 1. กำหนดค่าพารามิเตอร์ของเซนเซอร์ DRV5055
% หมายเหตุ: ต้องปรับค่า Vcc และ Sensitivity ให้ตรงกับรุ่นที่ใช้ในการทดลอง
% ตัวอย่างสมมติใช้รุ่น DRV5055A3 ที่ Vcc = 3.3V
Vcc = 3.3;                  % แรงดันไฟเลี้ยง (V)
Vq = Vcc / 2;               % แรงดัน Quiescent (V) เมื่อไม่มีสนามแม่เหล็ก
Sensitivity_mV = 30;        % ความไวของเซนเซอร์ (mV/mT) -> A3=15, A2=30, A1=60 [อ้างอิงจาก Datasheet]
Sensitivity_V = Sensitivity_mV / 1000; % แปลงหน่วยเป็น V/mT

%% 2. อ่านข้อมูลจากไฟล์ CSV ทั้ง 4 ไฟล์
% แก้ไขชื่อไฟล์ให้ตรงกับ Directory ของคุณ (อ้างอิงจากรูปภาพที่แนบมา)
file1 = 'data1_noShield_avg.csv';
file2 = 'data1_withShield_avg.csv';
file3 = 'data2_noShield_avg.csv';
file4 = 'data2_withShield_avg.csv';

% นำเข้าข้อมูลเป็น Table
T1_no = readtable(file1);
T1_with = readtable(file2);
T2_no = readtable(file3);
T2_with = readtable(file4);

%% 3. คำนวณค่า Magnetic Flux Density (B) ในหน่วย mT
% ฟังก์ชันคำนวณ B = (Vout - Vq) / Sensitivity
% (สมมติว่าค่า Mag_Sensor_Avg ในตารางมีหน่วยเป็น Volt แล้ว)
% *หากค่าเป็น ADC ดิบ (0-4095) ให้แปลงก่อน: Vout = (ADC_val / 4095) * Vcc
calc_B = @(vout) (vout - Vq) ./ Sensitivity_V;

B1_no   = calc_B(T1_no.Mag_Sensor_Avg);
B1_with = calc_B(T1_with.Mag_Sensor_Avg);
B2_no   = calc_B(T2_no.Mag_Sensor_Avg);
B2_with = calc_B(T2_with.Mag_Sensor_Avg);

%% 4. พลอตกราฟเปรียบเทียบ
figure('Name', 'DRV5055 Magnetic Sensor Analysis', 'Position', [100, 100, 1200, 500]);
% --- กราฟที่ 2: ค่า Magnetic Flux Density (mT) ที่คำนวณได้ vs ระยะทาง ---
plot(T1_no.Distance_mm, B1_no, '-o', 'LineWidth', 1.5); hold on;
plot(T1_with.Distance_mm, B1_with, '-s', 'LineWidth', 1.5);
plot(T2_no.Distance_mm, B2_no, '-^', 'LineWidth', 1.5);
plot(T2_with.Distance_mm, B2_with, '-d', 'LineWidth', 1.5);
grid minor;
grid on;
title('Calculated Magnetic Flux Density vs Distance');
xlabel('Distance (mm)');
ylabel('Magnetic Flux Density (mT)');
legend('Data 1: No Shield', 'Data 1: With Shield', 'Data 2: No Shield', 'Data 2: With Shield', 'Location', 'best');

%% 5. แสดงผลค่า Magnetic Flux Density ทาง Command Window
fprintf('\n======================================================\n');
fprintf('   Calculated Magnetic Flux Density (mT) Results\n');
fprintf('======================================================\n\n');

% สร้างตารางแสดงผลสำหรับ Data 1 (สมมติว่าระยะทางของ No Shield และ With Shield ตรงกัน)
disp('--- Data 1: Magnetic Flux Density ---');
Result_Data1 = table(T1_no.Distance_mm, B1_no, B1_with, ...
    'VariableNames', {'Distance_mm', 'No_Shield_mT', 'With_Shield_mT'});
disp(Result_Data1);

% สร้างตารางแสดงผลสำหรับ Data 2
disp('--- Data 2: Magnetic Flux Density ---');
Result_Data2 = table(T2_no.Distance_mm, B2_no, B2_with, ...
    'VariableNames', {'Distance_mm', 'No_Shield_mT', 'With_Shield_mT'});
disp(Result_Data2);