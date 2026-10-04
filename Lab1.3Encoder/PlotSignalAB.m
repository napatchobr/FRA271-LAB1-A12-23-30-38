% 1. กำหนดรายชื่อไฟล์ .mat ทั้ง 4 ไฟล์
file_names = {'A_Slow_Signal1.mat', 'A_Fast_Signal1.mat', 'B_SLOW_Signal1.mat', 'B_Fast_Signal1.mat'};
subplot_titles = {'AMT103-V Slow', 'AMT103-V Fast', 'BOURNS PEC11R-4220F-N0024 Slow', 'BOURNS PEC11R-4220F-N0024 Fast'};

% 2. สร้างหน้าต่างกราฟ
figure('Name', 'Encoder Signals Comparison', 'Color', 'w', 'Position', [100, 100, 1200, 800]);

for j = 1:length(file_names)
    
    mat_data = load(file_names{j});
    ds = mat_data.data; 
    
    % ใช้ Subplot 2x2
    ax = subplot(2, 2, j);
    hold on;
    
    num_sigs = ds.numElements;
    
    % 3. วนลูปพล็อตทีละเส้น
    for i = 1:num_sigs
        sig = ds{i}; 
        
        if isa(sig, 'Simulink.SimulationData.Signal')
            t = sig.Values.Time;
            v = sig.Values.Data;
        elseif isa(sig, 'timeseries')
            t = sig.Time;
            v = sig.Data;
        end
        
        % กำหนดชื่อสายสัญญาณใหม่ตรงนี้เลย (เพื่อทับชื่อ A0, A1 เดิมจากบอร์ด)
        if i == 1
            disp_name = 'Signal A';
            line_color = '#0072BD'; % สีน้ำเงินเข้ม
        else
            disp_name = 'Signal B';
            line_color = '#D95319'; % สีส้มเข้ม
        end
        
        % พล็อตและบังคับใช้ชื่อ DisplayName เพื่อให้ไปโผล่ใน Legend ทันที
        stairs(t, v, 'LineWidth', 2, 'Color', line_color, 'DisplayName', disp_name);
    end
    hold off;
    
    % 4. ตกแต่งกราฟย่อย (ใช้ Theme ขาว และเส้น Grid สีดำ)
    title(subplot_titles{j}, 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k');
    xlabel('Time (seconds)', 'FontSize', 12, 'Color', 'k');
    ylabel('Logic Level (V)', 'FontSize', 12, 'Color', 'k');
    
    set(ax, 'Color', 'w', 'XColor', 'k', 'YColor', 'k', ...
        'GridColor', 'k', 'GridAlpha', 0.5, ...
        'MinorGridColor', 'k', 'MinorGridAlpha', 0.15, ...
        'FontSize', 11, 'LineWidth', 1.2);
    grid on; grid minor;
    ylim([-0.5 5.5]); 
    
    % เรียก legend ขึ้นมาเฉยๆ ไม่ต้องส่ง array ชื่อเข้าไปแล้ว (มันจะดึง DisplayName มาใช้เอง)
    if num_sigs > 0
        legend('Location', 'best');
    end
end