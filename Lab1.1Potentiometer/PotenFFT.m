% 1. อ่านข้อมูลจากไฟล์ที่ผ่านการหาค่าเฉลี่ยมาแล้ว
data = readtable('Master_Averaged_Calibration.csv');
x_data = data.Angle_Degree;
L = length(x_data); % จำนวนจุดข้อมูลทั้งหมด

% คำนวณความถี่เชิงพื้นที่ (Spatial Sampling Frequency)
% เนื่องจากเก็บค่าทีละ 5 องศา (dx = 5)
dx = x_data(2) - x_data(1); 
Fs = 1 / dx; % หน่วยเป็น cycles/degree

% สร้างแกนความถี่สำหรับกราฟฝั่งบวก (One-sided spectrum)
f = Fs * (0:floor(L/2)) / L; 

% 2. สร้างหน้าต่างกราฟ
figure('Name', 'FFT Spectrum of Master Calibration', 'Color', 'w', 'Position', [150, 50, 700, 950]);

% 3. วนลูปคำนวณและพล็อต FFT สำหรับ Pot ทั้ง 5 ตัว
for i = 1:5
    col_name = sprintf('Pot%d_Avg', i);
    pot_data = data.(col_name);
    
    % --- กระบวนการทำ Fast Fourier Transform ---
    Y = fft(pot_data);
    
    % คำนวณขนาด (Magnitude)
    P2 = abs(Y / L); % Two-sided spectrum
    P1 = P2(1:floor(L/2)+1); % เลือกเฉพาะครึ่งหน้า (One-sided)
    
    % ชดเชยแอมพลิจูดจากฝั่งลบที่ถูกตัดทิ้ง (ยกเว้นค่า DC ที่ index 1)
    P1(2:end-1) = 2 * P1(2:end-1); 
    
    % 4. พล็อตกราฟ
    subplot(5, 1, i);
    
    % ใช้กราฟแท่ง (Stem) จะเหมาะสมกับการดู FFT ที่มีจุดข้อมูลจำกัด
    stem(f, P1, 'b', 'filled', 'LineWidth', 1.5, 'MarkerSize', 4);
    
    title(sprintf('Potentiometer %d', i));
    ylabel('|P1(f)| Magnitude');
    grid on;
    
    % จำกัดแกน Y ไม่ให้ค่า DC โด่งเกินไปจนมองไม่เห็นความถี่อื่น 
    % (ถอดคอมเมนต์บรรทัดล่างออกเพื่อซูมดูกราฟให้ชัดขึ้น)
    % ylim([0, max(P1(2:end)) * 1.2]); 
    
    if i == 5
        xlabel('Spatial Frequency (cycles/degree)');
    end
end