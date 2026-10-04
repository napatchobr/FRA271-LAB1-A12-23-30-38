% 1. โหลดข้อมูลจากไฟล์ CSV 
data = readtable('Real_VS_Loadcell_data.csv');

% 2. ดึงตัวแปรจากชื่อคอลัมน์ในไฟล์
real_weight = data.Weight_g; 
meas_weight = data.Sensor_Reading_avg;

% 3. คำนวณความต่างและคลาดเคลื่อน
error_abs = meas_weight - real_weight;
error_pct = (abs(error_abs) ./ real_weight) * 100;

% 4. แสดงผลลัพธ์เป็นตารางใน Command Window
disp('==================================================================');
disp('                ตารางเปรียบเทียบน้ำหนักและความคลาดเคลื่อน');
disp('==================================================================');
results = table(real_weight, meas_weight, error_abs, error_pct, ...
    'VariableNames', {'Real_Weight_g', 'Loadcell_Weight_g', 'Error_g', 'Percent_Error'});
disp(results);

fprintf('\n>> ค่าความคลาดเคลื่อนเฉลี่ย (Mean Absolute Error) : %.2f กรัม\n', mean(abs(error_abs)));
fprintf('>> เปอร์เซ็นต์ความคลาดเคลื่อนเฉลี่ย (Mean %% Error)  : %.2f %%\n\n', mean(error_pct));

% 5. สร้างกราฟเปรียบเทียบค่าที่วัดได้กับค่าจริง (1:1 Plot)
figure('Name', 'Load Cell Performance Analysis');
plot(real_weight, real_weight, 'k--', 'LineWidth', 1.5); % เส้นอุดมคติ (Ideal Line)
hold on;
plot(real_weight, meas_weight, 'bo-', 'MarkerFaceColor', 'b', 'LineWidth', 1.5); % ค่าที่วัดได้
hold off;

% ตกแต่งกราฟ
title('Real vs Measured Weight');
xlabel('Real Weight (g)');
ylabel('Load cell Reading (g)');
legend('Ideal (y = x)', 'Measured Data', 'Location', 'northwest');
grid on;