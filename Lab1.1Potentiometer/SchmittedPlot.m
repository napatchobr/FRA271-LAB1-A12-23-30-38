% 1. โหลดข้อมูลจากไฟล์ .mat
file_name = 'Schmitted1.mat';
mat_data = load(file_name);
% ดึงตัวแปร 'data' ออกมา (มันคือ Simulink.SimulationData.Dataset)
ds = mat_data.data; 

% 2. สร้างหน้าต่างกราฟ
figure('Name', 'Schmitt Trigger Data Plot', 'Color', 'w', 'Position', [200, 200, 800, 500]);
hold on;

% ตรวจสอบจำนวนสัญญาณ (Signals) ที่อยู่ใน Dataset นี้
num_sigs = ds.numElements;
legend_names = cell(1, num_sigs);

% ---------------------------------------------------------
% 🌟 ส่วนที่เพิ่มมา: ตั้งค่าสีเส้นกราฟและชื่อ Legend
% ---------------------------------------------------------
line_colors = {'k', 'b', 'r', 'g', '#D95319'}; % สีดำ(Raw Data) และสีน้ำเงิน(Schmitt)
custom_labels = {'Raw Data', 'Schmitt Trigger Output'}; % บังคับชื่อ Legend ตามนี้

% 3. วนลูปแกะข้อมูลจาก Dataset ออกมาทีละเส้นเพื่อพล็อต
for i = 1:num_sigs
    sig = ds{i}; % ดึงข้อมูลสัญญาณเส้นที่ i
    
    % เช็คประเภทของออบเจกต์เพื่อดึงค่าแกน X (Time) และแกน Y (Data)
    if isa(sig, 'Simulink.SimulationData.Signal')
        t = sig.Values.Time;
        v = sig.Values.Data;
    elseif isa(sig, 'timeseries')
        t = sig.Time;
        v = sig.Data;
    end
    
    % กำหนดชื่อ Legend ตามที่ระบุไว้ใน custom_labels
    if i <= length(custom_labels)
        legend_names{i} = custom_labels{i};
    else
        % ถ้ามีข้อมูลเส้นที่ 3 ขึ้นไป จะตั้งชื่ออัตโนมัติเป็น Signal 3, Signal 4...
        legend_names{i} = sprintf('Signal %d', i);
    end
    
    % เลือกสีให้เส้นปัจจุบัน
    c_idx = mod(i-1, length(line_colors)) + 1;
    current_color = line_colors{c_idx};
    
    % พล็อตกราฟ
    plot(t, v, 'Color', current_color, 'LineWidth', 2);
end
hold off;

% 4. ตกแต่งกราฟให้เหมือนในรูปอ้างอิงเป๊ะๆ
title('Potentiometer 1', 'FontWeight', 'bold');
ylabel('Voltage (V)');
xlabel('Time (s)'); % ปรับชื่อแกน X ตามต้องการ (สมมติว่าเป็นเวลา)

% ตั้งค่าสเกลแกน Y ให้เป็น 0 ถึง 3.5 (สเตปทีละ 0.5) แบบในรูป
ylim([-0.5 3.5]); % ยืดแกนลงมานิดหน่อยให้เห็นกราฟเส้น 0 ชัดๆ
yticks(0:0.5:3.5);

% หมายเหตุ: หากต้องการกำหนดลิมิตแกน X (เวลา) ให้เปิดคอมเมนต์บรรทัดล่าง
% xlim([0 5]); % สมมติว่าเก็บค่า 5 วินาที

% เปิดการใช้งาน Grid หลักและ Grid รอง (Minor Grid)
grid on;
grid minor;

% ปรับแต่งหน้าตาของกรอบและเส้น Grid
ax = gca;
ax.Box = 'on'; % ขอบกรอบกราฟแบบปิด
ax.LineWidth = 1.0; % ความหนาของกรอบ
    
% ปรับแต่ง Grid หลัก (เส้นทึบสีดำ/เทา)
ax.GridColor = 'k';
ax.GridAlpha = 0.5;
    
% ปรับแต่ง Grid รอง (เส้นประจุดไข่ปลาสีเทาอ่อนๆ เหมือนในรูป)
ax.MinorGridColor = 'k';
ax.MinorGridLineStyle = ':';
ax.MinorGridAlpha = 0.3;

% 🌟 แสดงแถบ Legend พร้อมชื่อที่กำหนด (สามารถเปลี่ยน Location เป็น 'northwest', 'best', 'southeast' ได้)
if num_sigs > 0
    legend(legend_names, 'Location', 'best');
end