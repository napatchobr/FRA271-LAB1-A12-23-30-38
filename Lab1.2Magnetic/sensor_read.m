% 1. ตั้งค่าตัวแปรเบื้องต้น
model_name = 'sensorExpoler'; % เปลี่ยนเป็นชื่อไฟล์ Simulink ของคุณ (อย่าลืมลบ .slx ออกตอนใส่ชื่อ)
distances = 0:5:35; % ช่วงระยะทางที่ต้องการเก็บ (0 ถึง 35 มม. เพิ่มทีละ 5 มม.)
filename = 'with-shield_1-2.csv';

% --- ป้องกันปัญหา Simulink รันค้าง ---
if bdIsLoaded(model_name)
    if ~strcmp(get_param(model_name, 'SimulationStatus'), 'stopped')
        set_param(model_name, 'SimulationCommand', 'stop');
    end
end
% --------------------------------------------

% 2. สร้างไฟล์ CSV พร้อมเขียน Header บรรทัดแรก
% ปรับชื่อ Header ให้สอดคล้องกับ Lab 1.2 (สมมติว่าใช้สัญญาณจาก A0 ช่องเดียว)
header = {'Distance_mm', 'Mag_Sensor_Avg'}; 
writecell(header, filename);

% 3. วนลูปเก็บค่าทีละระยะ
for i = 1:length(distances)
    current_distance = distances(i);
    fprintf('\n--- กำลังเตรียมเก็บค่าที่ระยะ %d มม. ---\n', current_distance);
    
    % วนลูปรอจนกว่าผู้ใช้จะพิมพ์ 'a'
    ready = false;
    while ~ready
        user_input = input('>> เลื่อนแม่เหล็กตรงตำแหน่งแล้ว พิมพ์ a แล้วกด Enter เพื่ออ่านค่า (5 วิ): ', 's');
        
        % เช็คว่าค่าที่พิมพ์มาคือ a หรือ A หรือไม่
        if strcmpi(strtrim(user_input), 'a')
            ready = true; 
        else
            disp('! รับคำสั่งผิดพลาด กรุณาพิมพ์ตัว a เท่านั้น');
        end
    end
    
    disp('กำลังอ่านค่า...');
    
    % สั่งรัน Simulink เป็นเวลา 5 วินาที
    if bdIsLoaded(model_name)
        if ~strcmp(get_param(model_name, 'SimulationStatus'), 'stopped')
            set_param(model_name, 'SimulationCommand', 'stop');
            while ~strcmp(get_param(model_name, 'SimulationStatus'), 'stopped')
                pause(0.1);
            end
        end
    end
    
    out = sim(model_name, 'StopTime', '5');
    
    % ดึงข้อมูลที่รันได้ออกมา (แก้จาก out.pot_data เป็น out.simout ตามรูปวงจร)
    % หมายเหตุ: หาก out.simout เป็น timeseries object ให้ใช้ .Data ต่อท้าย
    if isobject(out.simout) || isstruct(out.simout)
        data_matrix = out.simout.Data; 
    else
        data_matrix = out.simout;
    end
    
    % 4. นำข้อมูลมาหาค่าเฉลี่ย
    avg_vals = mean(data_matrix, 1);
    
    % 5. รวมข้อมูลระยะปัจจุบันกับค่าเฉลี่ย
    result_row = [current_distance, avg_vals];
    
    % 6. บันทึกลงไฟล์ CSV 
    writematrix(result_row, filename, 'WriteMode', 'append');
    
    fprintf('เก็บค่าที่ระยะ %d มม. เสร็จสิ้น!\n', current_distance);
end

disp('=======================================');
disp('เก็บข้อมูลครบทุกระยะเรียบร้อยแล้ว!');