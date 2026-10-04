% 1. ตั้งค่าตัวแปรเบื้องต้น
model_name = 'sensorExpoler'; % เปลี่ยนเป็นชื่อไฟล์ Simulink ของคุณ (อย่าลืมเปลี่ยนชื่อ)
angles = 0:5:100; % ช่วงองศาที่ต้องการเก็บ
filename = 'Potentiometer_Calibration3.csv';

% --- เพิ่มส่วนนี้: ป้องกันปัญหา Simulink รันค้าง ---
if bdIsLoaded(model_name)
    if ~strcmp(get_param(model_name, 'SimulationStatus'), 'stopped')
        set_param(model_name, 'SimulationCommand', 'stop');
    end
end
% --------------------------------------------

% 2. สร้างไฟล์ CSV พร้อมเขียน Header บรรทัดแรก
header = {'Angle_Degree', 'Pot1_Avg', 'Pot2_Avg', 'Pot3_Avg', 'Pot4_Avg', 'Pot5_Avg'};
writecell(header, filename);

% 3. วนลูปเก็บค่าทีละองศา
for i = 1:length(angles)
    current_angle = angles(i);
    fprintf('\n--- กำลังเตรียมเก็บค่าที่ %d องศา ---\n', current_angle);
    
    % วนลูปรอจนกว่าผู้ใช้จะพิมพ์ 'a'
    ready = false;
    while ~ready
        user_input = input('>> เลื่อน Poten ตรงตำแหน่งแล้ว พิมพ์ a แล้วกด Enter เพื่ออ่านค่า (5 วิ): ', 's');
        
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
    
    % ดึงข้อมูลที่รันได้ออกมา
    data_matrix = out.pot_data;
    
    % 4. นำข้อมูลมาหาค่าเฉลี่ย
    avg_vals = mean(data_matrix, 1);
    
    % 5. รวมข้อมูลองศาปัจจุบันกับค่าเฉลี่ย
    result_row = [current_angle, avg_vals];
    
    % 6. บันทึกลงไฟล์ CSV 
    writematrix(result_row, filename, 'WriteMode', 'append');
    
    fprintf('เก็บค่าที่ %d องศาเสร็จสิ้น!\n', current_angle);
end

disp('=======================================');
disp('เก็บข้อมูลครบทุกองศาเรียบร้อยแล้ว!');