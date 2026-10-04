% 1. โหลดข้อมูลจากไฟล์ .mat
file_name = 'Home_Signal1.mat';
mat_data = load(file_name);
ds = mat_data.data; 

% 2. สร้างหน้าต่างกราฟ
figure('Name', 'Homing Sequence Plot', 'Color', 'w', 'Position', [200, 200, 800, 500]);

% กำหนดสีและชื่อ
color_left = '#0072BD';  % สีน้ำเงิน สำหรับกราฟเส้นแรก (ฝั่งซ้าย)
color_right = '#D95319'; % สีส้ม สำหรับกราฟเส้นที่สอง (ฝั่งขวา)
custom_labels = {'Relative Position', 'Homing Sequence Position'};

% 3. แกะข้อมูลและพล็อตแยกฝั่ง
% สมมติว่ามี 2 สัญญาณใน Dataset
for i = 1:ds.numElements
    sig = ds{i}; 

    if isa(sig, 'Simulink.SimulationData.Signal')
        t = sig.Values.Time;
        v = sig.Values.Data;
    elseif isa(sig, 'timeseries')
        t = sig.Time;
        v = sig.Data;
    end

    if i == 1
        % --- พล็อตเส้นที่ 1 โดยอ้างอิงแกน Y ฝั่งซ้าย ---
        yyaxis left;
        plot(t, v, 'Color', color_left, 'LineWidth', 2, 'DisplayName', custom_labels{1});
        ylabel('Relative Position (Counts)', 'Color', color_left, 'FontWeight', 'bold');

        % ปรับสเกลแกนซ้ายให้ฟิตพอดีกับข้อมูล หรือตั้งค่าตายตัวก็ได้
        % ylim([0 65000]); 

        % เปลี่ยนสีแกนให้ตรงกับสีกราฟ
        ax = gca;
        ax.YColor = color_left;

    elseif i == 2
        % --- พล็อตเส้นที่ 2 โดยอ้างอิงแกน Y ฝั่งขวา ---
        yyaxis right;
        plot(t, v, 'Color', color_right, 'LineWidth', 2, 'DisplayName', custom_labels{2});
        ylabel('Homing Position (Counts)', 'Color', color_right, 'FontWeight', 'bold');

        % ปรับสเกลแกนขวาให้ฟิตพอดี
        % ylim([0 1000]); 

        % เปลี่ยนสีแกนให้ตรงกับสีกราฟ
        ax = gca;
        ax.YColor = color_right;
    end
end

% 4. ตกแต่งกราฟส่วนกลาง (ใช้ร่วมกัน)
title('Encoder Homing Sequence', 'FontWeight', 'bold', 'FontSize', 14);
xlabel('Time (s)', 'FontWeight', 'bold');

% แสดง Legend
legend('Location', 'best');

% เปิด Grid โดยอ้างอิงเส้นกริดตามแกนซ้ายเป็นหลัก
grid on;
grid minor;
ax.GridColor = 'k';
ax.GridAlpha = 0.5;
ax.MinorGridColor = 'k';
ax.MinorGridLineStyle = ':';
ax.MinorGridAlpha = 0.3;