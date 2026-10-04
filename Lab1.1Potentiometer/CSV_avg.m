% 1. เปิดหน้าต่างให้ผู้ใช้เลือกไฟล์ CSV หลายๆ ไฟล์
[filenames, path] = uigetfile('*.csv', 'เลือกไฟล์ที่ต้องการนำมาหาค่าเฉลี่ย', 'MultiSelect', 'on');

% ตรวจสอบว่ามีการกดยกเลิกหรือไม่
if isequal(filenames, 0)
    disp('ยกเลิกการเลือกไฟล์');
    return;
end

if ischar(filenames)
    filenames = {filenames};
end
num_files = length(filenames);
fprintf('\n--- เริ่มตรวจสอบไฟล์ทั้งหมด %d ไฟล์ ---\n', num_files);

% 2. ตรวจสอบจำนวนแถวของแต่ละไฟล์ และหา min_rows
min_rows = inf;
for i = 1:num_files
    temp_data = readtable(fullfile(path, filenames{i}));
    row_count = height(temp_data);
    
    % ปริ้นท์บอกจำนวนบรรทัดของแต่ละไฟล์
    fprintf('ไฟล์ที่ %d: %s (มีข้อมูล %d แถว)\n', i, filenames{i}, row_count);
    
    if row_count < min_rows
        min_rows = row_count;
    end
end

% ป้องกันกรณีมีไฟล์ 0 บรรทัด
if min_rows == 0
    error('หยุดการทำงาน: ตรวจพบไฟล์ที่ไม่มีข้อมูล (0 แถว) กรุณาเลือกไฟล์ใหม่โดยระวังไม่เลือกไฟล์ผลลัพธ์เก่าที่ว่างเปล่าครับ');
end

fprintf('=> จะทำการเฉลี่ยข้อมูลโดยใช้ขนาด %d แถว\n\n', min_rows);

% 3. ดำเนินการหาค่าเฉลี่ย
first_file = fullfile(path, filenames{1});
data = readtable(first_file);
degrees = data.Angle_Degree(1:min_rows);
sum_pot_data = zeros(min_rows, 5);

for i = 1:num_files
    temp_data = readtable(fullfile(path, filenames{i}));
    
    sum_pot_data(:, 1) = sum_pot_data(:, 1) + temp_data.Pot1_Avg(1:min_rows);
    sum_pot_data(:, 2) = sum_pot_data(:, 2) + temp_data.Pot2_Avg(1:min_rows);
    sum_pot_data(:, 3) = sum_pot_data(:, 3) + temp_data.Pot3_Avg(1:min_rows);
    sum_pot_data(:, 4) = sum_pot_data(:, 4) + temp_data.Pot4_Avg(1:min_rows);
    sum_pot_data(:, 5) = sum_pot_data(:, 5) + temp_data.Pot5_Avg(1:min_rows);
end

avg_pot_data = sum_pot_data / num_files;

% 4. บันทึกไฟล์
final_data = table(degrees, avg_pot_data(:,1), avg_pot_data(:,2), avg_pot_data(:,3), avg_pot_data(:,4), avg_pot_data(:,5), ...
    'VariableNames', {'Angle_Degree', 'Pot1_Avg', 'Pot2_Avg', 'Pot3_Avg', 'Pot4_Avg', 'Pot5_Avg'});

output_filename = fullfile(path, 'Master_Averaged_Calibration.csv');
writetable(final_data, output_filename);
fprintf('เสร็จสิ้น! ไฟล์ใหม่ถูกบันทึกไว้ที่:\n%s\n', output_filename);