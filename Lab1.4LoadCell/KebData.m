% 1. ตั้งค่าตัวแปรเบื้องต้น
model_name = 'sensorExpoler'; % เปลี่ยนเป็นชื่อไฟล์ Simulink ของคุณ
filename = 'Weight_Voltage_Calibration3.csv';

% --- ป้องกันปัญหา Simulink รันค้าง ---
if bdIsLoaded(model_name)
    if ~strcmp(get_param(model_name, 'SimulationStatus'), 'stopped')
        set_param(model_name, 'SimulationCommand', 'stop');
    end
end
% --------------------------------------------

% 2. สร้างไฟล์ CSV พร้อมเขียน Header บรรทัดแรก
header = {'Weight_g', 'Voltage_mV'};
writecell(header, filename);

disp('=== เริ่มโปรแกรมเก็บข้อมูลน้ำหนักและแรงดันไฟฟ้า ===');
disp('คำแนะนำ: วางน้ำหนักลงบนเซนเซอร์ให้เรียบร้อย พิมพ์ตัวเลข (เช่น 1015) แล้วกด Enter');
disp('พิมพ์ตัว q หรือ exit แล้วกด Enter เพื่อออกจากโปรแกรม');
disp('===============================================');

% 3. ใช้ลูปเพื่อรับค่าน้ำหนักไปเรื่อยๆ จนกว่าจะสั่งหยุด
while true
    % รอรับคำสั่งหรือตัวเลขจากผู้ใช้
    user_input = input('\n>> กรุณาใส่น้ำหนัก (g) [พิมพ์ q เพื่อออก]: ', 's');
    user_input = strtrim(user_input); % ตัดช่องว่างหน้าหลังทิ้ง

    % เช็คคำสั่งออกจากลูป
    if strcmpi(user_input, 'q') || strcmpi(user_input, 'exit')
        break;
    end

    % แปลงข้อความที่พิมพ์มาให้เป็นตัวเลข
    current_weight = str2double(user_input);

    % เช็คว่าผู้ใช้กรอกตัวเลขมาถูกต้องหรือไม่
    if isnan(current_weight)
        disp('! รับคำสั่งผิดพลาด กรุณากรอกเฉพาะตัวเลข (เช่น 1015) หรือพิมพ์ q เพื่อออก');
        continue; % ข้ามไปเริ่มรับค่าใหม่
    end

    fprintf('กำลังรันเพื่ออ่านค่าสำหรับน้ำหนัก %g g เป็นเวลา 5 วินาที...\n', current_weight);

    % สั่งรัน Simulink
    if bdIsLoaded(model_name)
        if ~strcmp(get_param(model_name, 'SimulationStatus'), 'stopped')
            set_param(model_name, 'SimulationCommand', 'stop');
            while ~strcmp(get_param(model_name, 'SimulationStatus'), 'stopped')
                pause(0.1);
            end
        end
    end

    out = sim(model_name, 'StopTime', '5');

    % 4. ดึงข้อมูลที่รันได้ออกมา (ดึงจากตัวแปร simout ตามบล็อกในรูป)
    raw_data = out.simout; 

    % ตรวจสอบโครงสร้างข้อมูลและดึงตัวเลขออกมาหาค่าเฉลี่ย
    if isa(raw_data, 'timeseries')
        data_matrix = squeeze(raw_data.Data);
    else
        data_matrix = raw_data;
    end

    % หาค่าเฉลี่ยของแรงดันไฟฟ้าทั้งหมดที่เก็บมาใน 5 วินาที
    avg_voltage = mean(data_matrix, 'all');

    % 5. รวมข้อมูลน้ำหนักปัจจุบันกับค่าเฉลี่ย
    result_row = [current_weight, avg_voltage];

    % 6. บันทึกลงไฟล์ CSV 
    writematrix(result_row, filename, 'WriteMode', 'append');

    fprintf('เก็บค่าสำเร็จ! น้ำหนัก: %g g -> แรงดันเฉลี่ย: %.4f mV\n', current_weight, avg_voltage);
end

disp('=======================================');
disp('ออกจากโปรแกรมและปิดการบันทึกข้อมูลเรียบร้อยแล้ว!');