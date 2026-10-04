% 1. กำหนดตัวแปร x และ y
x = Weight_Voltage_Calibration_avg.Weight_avg_g_;
y = Weight_Voltage_Calibration_avg.Voltage_avg_mV_;

% 2. สร้างโมเดล Linear Regression ด้วยคำสั่งพื้นฐาน (polyfit)
% เลข 1 หมายถึงสมการโพลิโนเมียลดีกรี 1 (สมการเส้นตรง)
p = polyfit(x, y, 1); 
m = p(1); % ความชัน (Slope)
c = p(2); % จุดตัดแกน Y (Intercept)

% 3. คำนวณค่า R-squared แบบ Manual
y_fit = polyval(p, x); % คำนวณค่า y จากสมการที่ได้
SS_resid = sum((y - y_fit).^2); % Sum of squares of residuals
SS_total = sum((y - mean(y)).^2); % Total sum of squares
rsquared = 1 - (SS_resid / SS_total);

% 4. พลอตกราฟ
figure;
plot(x, y, 'o', 'MarkerFaceColor', 'b'); % พลอตจุดข้อมูลจริง
hold on;
plot(x, y_fit, 'r-', 'LineWidth', 1.5); % พลอตเส้นตรงแนวโน้ม
hold off;

% ตกแต่งกราฟ
title(sprintf('Calibration Curve\ny = %.4fx + %.4f (R^2 = %.4f)', m, c, rsquared));
xlabel('Weight avg (g)');
ylabel('Voltage avg (mV)');
grid on;
legend('Data', 'Linear Fit', 'Location', 'northwest');

% 5. แสดงผลลัพธ์ใน Command Window
fprintf('สมการเส้นตรง: y = %.4fx + %.4f\n', m, c);
fprintf('ค่า R-squared: %.4f\n', rsquared);