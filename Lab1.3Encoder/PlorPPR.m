% 1. อ่านข้อมูลจากไฟล์ CSV
% (อ้างอิงชื่อไฟล์ตามที่ระบุ)
data = readtable('Encoder_PPR_Experiment_Results.csv');

% แยกข้อมูลตามชนิดของ Encoder เพื่อพล็อตแยกกราฟกัน
bourns_data = data(strcmp(data.Encoder_Type, 'BOURNS PEC11R'), :);
amt_data = data(strcmp(data.Encoder_Type, 'AMT103-V'), :);

% 2. สร้างหน้าต่างกราฟ (ธีมสว่าง ตามตัวอย่าง)
figure('Name', 'Encoder PPR & CPR Analysis', 'Color', 'w', 'Position', [150, 150, 1000, 500]);

% กำหนดสี: สีเทาสำหรับค่าทฤษฎี, สีดำสำหรับค่าจากการทดลองจริง
color_theoretical = [0.7 0.7 0.7]; 
color_actual = [0 0 0];

%% ส่วนที่ 1: พล็อต BOURNS PEC11R (กราฟฝั่งซ้าย)
ax1 = subplot(1, 2, 1);
% ดึงข้อมูลมาสร้าง Matrix สำหรับกราฟแท่งคู่
y1 = [bourns_data.Theoretical_CPR, bourns_data.Average_Counts];
b1 = bar(y1, 'grouped');
b1(1).FaceColor = color_theoretical; 
b1(2).FaceColor = color_actual;

% ตั้งค่าแกน X ให้เป็นชื่อโหมด 1x, 2x, 4x
set(gca, 'XTickLabel', bourns_data.Decoding_Mode);

% นำค่า PPR ตั้งต้นมาโชว์ที่หัวกราฟเพื่อให้สื่อความหมายได้ชัดเจน
ppr_bourns = bourns_data.Declared_PPR(1);
title(sprintf('BOURNS PEC11R\n(Base PPR = %d)', ppr_bourns), ...
    'FontSize', 16, 'FontWeight', 'bold', 'Color', 'k', 'Interpreter', 'none');
xlabel('Decoding Mode', 'FontSize', 14, 'Color', 'k');
ylabel('Counts Per Revolution (CPR)', 'FontSize', 14, 'Color', 'k');

% ตั้งค่า Theme ขาว และ Grid ตามโค้ดต้นฉบับของคุณ
set(ax1, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', ...
    'GridColor', 'k', 'GridAlpha', 0.5, ...
    'MinorGridColor', 'k', 'MinorGridAlpha', 0.15, ...
    'FontSize', 12, 'LineWidth', 1.2);
grid on; grid minor;
legend({'Theoretical CPR', 'Measured Average'}, 'Location', 'northwest', 'FontSize', 11);

%% ส่วนที่ 2: พล็อต AMT103-V (กราฟฝั่งขวา)
ax2 = subplot(1, 2, 2);
% ดึงข้อมูลมาสร้าง Matrix สำหรับกราฟแท่งคู่
y2 = [amt_data.Theoretical_CPR, amt_data.Average_Counts];
b2 = bar(y2, 'grouped');
b2(1).FaceColor = color_theoretical; 
b2(2).FaceColor = color_actual;

% ตั้งค่าแกน X
set(gca, 'XTickLabel', amt_data.Decoding_Mode);

% นำค่า PPR ตั้งต้นมาโชว์ที่หัวกราฟ
ppr_amt = amt_data.Declared_PPR(1);
title(sprintf('AMT103-V\n(Base PPR = %d)', ppr_amt), ...
    'FontSize', 16, 'FontWeight', 'bold', 'Color', 'k', 'Interpreter', 'none');
xlabel('Decoding Mode', 'FontSize', 14, 'Color', 'k');
ylabel('Counts Per Revolution (CPR)', 'FontSize', 14, 'Color', 'k');

% ตั้งค่า Theme ขาว และ Grid 
set(ax2, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', ...
    'GridColor', 'k', 'GridAlpha', 0.5, ...
    'MinorGridColor', 'k', 'MinorGridAlpha', 0.15, ...
    'FontSize', 12, 'LineWidth', 1.2);
grid on; grid minor;
legend({'Theoretical CPR', 'Measured Average'}, 'Location', 'northwest', 'FontSize', 11);