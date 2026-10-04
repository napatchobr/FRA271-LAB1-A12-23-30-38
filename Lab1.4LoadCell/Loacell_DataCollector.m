% --- ตั้งค่าระยะเวลา ---
readTime = 5;         % เวลาที่ต้องการนำข้อมูลมาเฉลี่ยจริงๆ (วินาที)
warmUpTime = 2.5;     % เวลาเผื่อช่วงเริ่มต้นให้เซ็นเซอร์นิ่ง (วินาที) - ส่วนนี้จะถูกตัดทิ้ง
totalSimTime = readTime + warmUpTime; % รวมเวลารัน Simulink ทั้งหมด (7.5 วินาที)

modelName = 'sensorExpoler'; % ชื่อไฟล์ Simulink
fileName = 'Real_VS_Loadcell_data.csv';

% ตรวจสอบและสร้างไฟล์ CSV พร้อมหัวตาราง (ถ้ายังไม่มีไฟล์)
if ~isfile(fileName)
    fid = fopen(fileName, 'w');
    fprintf(fid, 'Weight_g,Sensor_Reading_avg\n');
    fclose(fid);
end

disp('==================================================');
disp('   เริ่มระบบเก็บข้อมูลอัตโนมัติ (อ่านค่า 5 วินาทีเต็ม)');
disp('   ** หากต้องการหยุดทำงาน ให้พิมพ์ -1 แล้วกด Enter **');
disp('==================================================');

% วนลูปทำงานไปเรื่อยๆ
while true
    % 1. รับค่าน้ำหนักมาตรฐานจากผู้ใช้
    fprintf('\n');
    userInput = input('โปรดระบุน้ำหนักที่วางบนตาชั่ง (กรัม) [-1 เพื่อออก]: ');
    
    % ตรวจสอบเงื่อนไขการออกจากลูป
    if isempty(userInput) || userInput == -1
        disp('--- สิ้นสุดการเก็บข้อมูล ระบบปิดการทำงาน ---');
        break; 
    end
    
    true_weight = userInput;
    
    % บอกสถานะให้ผู้ใช้ทราบ
    fprintf('กำลังรันระบบเพื่อเก็บข้อมูล %g วินาที... (ตัดช่วงเริ่ม %g วิ, เก็บค่าจริง %g วิ)\n', ...
            totalSimTime, warmUpTime, readTime);
    
    % 2. โหลดโมเดลและรัน Simulink ตามเวลาที่รวมแล้ว
    load_system(modelName);
    out = sim(modelName, 'StopTime', num2str(totalSimTime));
    
    % 3. ดึงข้อมูลและตัดช่วง 2.5 วินาทีแรกทิ้ง
    if isprop(out, 'simout')
        % ดึงข้อมูล
        if isa(out.simout, 'timeseries')
            rawData = out.simout.Data;
        else
            rawData = out.simout;
        end
        
        % คำนวณหาว่า 2.5 วินาทีแรก คือข้อมูลกี่ตัว (Index)
        total_len = length(rawData);
        start_idx = floor((warmUpTime / totalSimTime) * total_len) + 1;
        
        % เลือกเอาเฉพาะข้อมูลตั้งแต่หลัง 2.5 วิ จนถึงสิ้นสุดการรัน (รวมเป็นเวลา 5 วิ พอดี)
        stable_data = rawData(start_idx:end); 
        
        % 4. หาค่าเฉลี่ยจากข้อมูลที่เสถียร 5 วินาทีเต็ม
        avg_reading = mean(stable_data);
        
        % บันทึกข้อมูลลงไฟล์ CSV ทันที
        fid = fopen(fileName, 'a');
        fprintf(fid, '%.4f,%.4f\n', true_weight, avg_reading);
        fclose(fid);
        
        fprintf('=> อ่านค่าเฉลี่ยได้: %.4f | บันทึกข้อมูล %.2f กรัม สำเร็จ!\n', avg_reading, true_weight);
    else
        disp('Error: ไม่พบข้อมูลจาก Simulink โปรดตรวจสอบบล็อก To Workspace ว่าชื่อ simout หรือไม่');
    end
end