% 1. อ่านข้อมูลจากไฟล์ CSV
data = readtable('Master_Averaged_Calibration.csv');
degrees = data.Angle_Degree;
num_points = length(degrees);
distance_mm = (0:(num_points-1))' * 3; % สร้างแกน X แนวแกนตั้ง

% ปรับขนาดหน้าต่างกราฟให้กว้างขึ้น เพื่อให้เหมาะกับการจัดแบบ 2 แถว
figure('Name', 'Linearity Analysis', 'Color', 'w', 'Position', [100, 100, 1200, 700]);

fprintf('=== สรุปคุณสมบัติความเป็นเชิงเส้น (Linearity) ===\n\n');

for i = 1:5
    % ----------------------------------------------------
    % จัด Layout แบบตาราง 2 แถว 6 คอลัมน์ (รวม 12 ช่อง)
    % แถวบน (Pot 1-3) ให้กินพื้นที่ตัวละ 2 ช่อง
    % แถวล่าง (Pot 4-5) ให้กินพื้นที่ตัวละ 3 ช่อง (จะได้กึ่งกลางและสมดุล)
    % ----------------------------------------------------
    if i == 1
        subplot(2, 6, [1, 2]);
    elseif i == 2
        subplot(2, 6, [3, 4]);
    elseif i == 3
        subplot(2, 6, [5, 6]);
    elseif i == 4
        subplot(2, 6, [7, 8, 9]);
    elseif i == 5
        subplot(2, 6, [10, 11, 12]);
    end

    col_name = sprintf('Pot%d_Avg', i);
    pot_data = data.(col_name);
    
    % หมายเหตุ: หากข้อมูลในไฟล์ยังเป็นค่าดิบ 0-4095 ให้เอาเครื่องหมาย % บรรทัดล่างออกเพื่อแปลงเป็น V
    % pot_data = (pot_data / 4095) * 3.3; 

    % เลือกแกน X และชื่อแกนให้ตรงตามรูปอ้างอิง
    if i <= 3
        x_data = degrees;
        x_label = 'Rotational Travel (Degree)';
        pot_type = 'Rotary';
    else
        x_data = distance_mm;
        x_label = 'Distance (mm)';
        pot_type = 'Linear Slide';
    end

    % 2. สร้างเส้นตรงอุดมคติ (Best-fit line) ด้วยสมการ Linear-Regression (ดีกรี 1)
    p = polyfit(x_data, pot_data, 1);
    pot_ideal = polyval(p, x_data);

    % 3. คำนวณค่า R-squared
    SS_tot = sum((pot_data - mean(pot_data)).^2);
    SS_res = sum((pot_data - pot_ideal).^2);
    R_sq = 1 - (SS_res / SS_tot);

    % 4. คำนวณหา Maximum Error เปรียบเทียบกับไฟ 3.3V (หรือปรับตาม Full Scale ที่ใช้)
    max_error_v = max(abs(pot_data - pot_ideal));
    max_error_percent = (max_error_v / max(pot_data)) * 100;

    % พล็อตกราฟเปรียบเทียบ
    % ข้อมูลจริง: เส้นสีดำหนา (k-) เหมือนในรูป
    % ข้อมูลอุดมคติ (Linearity): เส้นประสีแดง (r--) เพื่อให้เห็นชัดเจนเวลาซ้อนกัน
    plot(x_data, pot_data, 'k-', 'LineWidth', 2); hold on;
    plot(x_data, pot_ideal, 'r--', 'LineWidth', 1.5); hold off;

    % ตกแต่งชื่อกราฟและแกน
    title(sprintf('Potentiometer %d', i), 'FontWeight', 'bold');
    ylabel('Voltage (V)');
    xlabel(x_label);
    
    % ล็อกสเกลแกน X ให้พอดี
    xlim([0 max(x_data)]);
    
    % เปิด Grid ทั้งเส้นหลักและเส้นรอง (Minor Grid) ให้เหมือนในรูป
    grid on;
    grid minor;
    ax = gca;
    ax.GridColor = 'k'; % สีเส้น Grid หลัก
    ax.MinorGridColor = 'k'; % สีเส้น Grid รอง
    ax.MinorGridLineStyle = ':'; % เส้น Grid รองเป็นจุดไข่ปลา
    ax.GridAlpha = 0.4;
    
    legend('Actual Data', 'Ideal Linear Fit', 'Location', 'northwest');

    % แสดงผลลัพธ์การวิเคราะห์ใน Command Window
    fprintf('Potentiometer %d (%s):\n', i, pot_type);
    fprintf('  - สมการเชิงเส้น: V = %.5f(X) + %.5f\n', p(1), p(2));
    fprintf('  - ค่า R-squared: %.4f\n', R_sq);
    fprintf('  - ความคลาดเคลื่อนสูงสุด (Max Error): %.2f %%FS (หรือ %.4f V)\n\n', max_error_percent, max_error_v);
end