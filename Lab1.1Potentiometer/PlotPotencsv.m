% 1. อ่านข้อมูลจากไฟล์ CSV
data = readtable('Master_Averaged_Calibration.csv');
degrees = data.Angle_Degree;
num_points = length(degrees);

% สร้างแกน X สำหรับ Pot 4 และ 5 (ระยะทางเพิ่มทีละ 3 mm โดยเริ่มจาก 0)
distance_mm = (0:(num_points-1)) * 3;

% 2. สร้างหน้าต่างกราฟ (ธีมสว่าง)
% กำหนดขนาดให้กว้างและสูงพอสำหรับ 2 แถว
figure('Name', 'Potentiometer 1-5 Calibration', 'Color', 'w', 'Position', [100, 50, 1200, 800]);

%% ส่วนที่ 1: พล็อต Pot 1 ถึง 3 ไว้ด้านบน (แถวที่ 1 มี 3 กอลัมน์)
pot_titles_1to3 = {'Potentiometer 1', 'Potentiometer 2', 'Potentiometer 3'};

for i = 1:3
    % ใช้ subplot(2, 6, ...) เพื่อจัด Layout 
    % แถวบนแบ่งเป็น 3 ส่วน (ใช้พื้นที่คอลัมน์ละ 2 ช่องจาก 6 ช่อง)
    if i == 1
        ax = subplot(2, 6, [1, 2]);
    elseif i == 2
        ax = subplot(2, 6, [3, 4]);
    else
        ax = subplot(2, 6, [5, 6]);
    end
    
    col_name = sprintf('Pot%d_Avg', i);
    pot_data = data.(col_name);
    
    % พล็อตเส้นกราฟ ใช้เส้นสีดำ (-k)
    plot(degrees, pot_data, '-k', 'LineWidth', 2);
    xlim([0 max(degrees)]);
    ylim([0 3.5]); % ปรับให้อยู่ในช่วง 0 ถึง 3.3-3.5V ให้ดูสวยงาม
    
    title(pot_titles_1to3{i}, 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'k');
    xlabel('Rotational Travel (Degree)', 'FontSize', 14, 'Color', 'k');
    
    if i == 1
        ylabel('Voltage (V)', 'FontSize', 14, 'Color', 'k');
    end
    
    % ตั้งค่า Theme ขาว และ Grid
    set(ax, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', ...
        'GridColor', 'k', 'GridAlpha', 0.5, ...
        'MinorGridColor', 'k', 'MinorGridAlpha', 0.15, ...
        'FontSize', 12, 'LineWidth', 1.2);
    grid on;
    grid minor;
end

%% ส่วนที่ 2: พล็อต Pot 4 ถึง 5 ไว้ด้านล่าง (แถวที่ 2 มี 2 กอลัมน์)
pot_titles_4to5 = {'Potentiometer 4', 'Potentiometer 5'};

for i = 1:2
    % แถวล่างแบ่งเป็น 2 ส่วน (ใช้พื้นที่คอลัมน์ละ 3 ช่องจาก 6 ช่อง)
    if i == 1
        ax = subplot(2, 6, [7, 8, 9]);
    else
        ax = subplot(2, 6, [10, 11, 12]);
    end
    
    col_name = sprintf('Pot%d_Avg', i+3);
    pot_data = data.(col_name);
    
    % พล็อตเส้นกราฟ ใช้เส้นสีดำ (-k)
    plot(distance_mm, pot_data, '-k', 'LineWidth', 2);
    xlim([0 max(distance_mm)]);
    ylim([0 3.5]);
    
    title(pot_titles_4to5{i}, 'FontSize', 16, 'FontWeight', 'bold', 'Color', 'k');
    xlabel('Distance (mm)', 'FontSize', 14, 'Color', 'k');
    
    if i == 1
        ylabel('Voltage (V)', 'FontSize', 14, 'Color', 'k');
    end
    
    % ตั้งค่า Theme ขาว และ Grid
    set(ax, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', ...
        'GridColor', 'k', 'GridAlpha', 0.5, ...
        'MinorGridColor', 'k', 'MinorGridAlpha', 0.15, ...
        'FontSize', 12, 'LineWidth', 1.2);
    grid on;
    grid minor;
end