% Non-parametric analysis for Table 2: Within-group comparisons (H and P) across damping levels (B0 vs. B20, B0 vs. B40, B20 vs. B40)
close all;
clear Table2;

% Initialize Table2 for 11 parameters x 2 groups (H, P) and 3 comparisons
Table2 = NaN(22, 3);
varNames = {'p_B0B20', 'p_B0B40', 'p_B20B40'};
rowNames = {'V_T_H', 'V_T_P', 'V_v_H', 'V_v_P', 'v_par_H', 'v_par_P', 'v_perp_H', 'v_perp_P', ...
            'v_Nperp_H', 'v_Nperp_P', 'F_IC_H', 'F_IC_P', 'V_FM_H', 'V_FM_P', 'V_FI_H', 'V_FI_P', ...
            'F_Mpar_H', 'F_Mpar_P', 'F_Mperp_H', 'F_Mperp_P', 'F_IR_H', 'F_IR_P'};

% Sample sizes
nH = 16; % Healthy participants
nP = 16; % Stroke participants
alpha = 0.05; % Significance level
alpha_adj = alpha / 3; % Bonferroni-corrected alpha (0.05/3 ≈ 0.0167)

% Define parameters and their data sources
params = struct(...
    'V_T', struct('source', 'Trajektorije', 'fieldH', 'areaH', 'fieldP', 'areaP', 'rowH', 1, 'rowP', 2), ...
    'V_v', struct('source', 'Velocity', 'fieldH', 'areaH', 'fieldP', 'areaP', 'rowH', 3, 'rowP', 4), ...
    'v_par', struct('source', 'Velocity', 'fieldH', 'directH', 'fieldP', 'directP', 'rowH', 5, 'rowP', 6), ...
    'v_perp', struct('source', 'Velocity', 'fieldH', 'perpH', 'fieldP', 'perpP', 'rowH', 7, 'rowP', 8), ...
    'v_Nperp', struct('source', 'Velocity', 'fieldH', 'dirRatioH', 'fieldP', 'dirRatioP', 'rowH', 9, 'rowP', 10), ...
    'V_FM', struct('source', 'sum_FD_FL', 'fieldH', 'areaH', 'fieldP', 'areaP', 'rowH', 13, 'rowP', 14), ...
    'V_FI', struct('source', 'diff_FD_FL', 'fieldH', 'areaH', 'fieldP', 'areaP', 'rowH', 15, 'rowP', 16), ...
    'F_Mpar', struct('source', 'sum_FD_FL', 'fieldH', 'directH', 'fieldP', 'directP', 'rowH', 17, 'rowP', 18), ...
    'F_Mperp', struct('source', 'sum_FD_FL', 'fieldH', 'perpH', 'fieldP', 'perpP', 'rowH', 19, 'rowP', 20), ...
    'F_IC', struct('source', 'diff_FD_FL', 'fieldH', 'directH', 'fieldP', 'directP', 'rowH', 11, 'rowP', 12), ...
    'F_IR', struct('source', 'diff_FD_FL', 'fieldH', 'perpH', 'fieldP', 'perpP', 'rowH', 21, 'rowP', 22));

% Loop over parameters
param_names = fieldnames(params);
for pp = 1:length(param_names)
    param = param_names{pp};
    source = params.(param).source;
    fieldH = params.(param).fieldH;
    fieldP = params.(param).fieldP;
    rowH = params.(param).rowH;
    rowP = params.(param).rowP;
    
    % Select data structure
    try
        switch source
            case 'Trajektorije'
                data_struct = Trajektorije;
            case 'Velocity'
                data_struct = Velocity;
            case 'sum_FD_FL'
                data_struct = sum_FD_FL;
            case 'diff_FD_FL'
                data_struct = diff_FD_FL;
            otherwise
                error('Unknown data source: %s', source);
        end
        
        % Debug: List field names for sum_FD_FL and diff_FD_FL
        if strcmp(source, 'sum_FD_FL') || strcmp(source, 'diff_FD_FL')
            for d = 1:3
                if isfield(data_struct, 'damping') && length(data_struct.damping) >= d && isfield(data_struct.damping(d), 'target')
                    fprintf('Debug: Fields in %s.damping(%d).target: %s\n', source, d, ...
                        strjoin(fieldnames(data_struct.damping(d).target), ', '));
                else
                    fprintf('Debug: No target fields available in %s.damping(%d)\n', source, d);
                end
            end
        end
        
        % Process Healthy group (H)
        fprintf('Kruskal-Wallis Test for %s (H) between dampings (B0 vs. B20, B0 vs. B40, B20 vs. B40)\n', param);
        pDamp = zeros(1, 3);
        try
            % Check field existence
            for d = 1:3
                if ~isfield(data_struct.damping(d).target, fieldH)
                    error('Field %s missing in %s.damping(%d).target', fieldH, source, d);
                end
            end
            
            % Pairwise comparisons
            % B0 vs. B20
            data_b0 = [data_struct.damping(1).target.(fieldH)]';
            data_b20 = [data_struct.damping(2).target.(fieldH)]';
            if size(data_b0, 2) > 1
                data_b0 = mean(data_b0, 2);
            end
            if size(data_b20, 2) > 1
                data_b20 = mean(data_b20, 2);
            end
            fprintf('Debug: %s (H) B0 size: %s, B20 size: %s\n', param, mat2str(size(data_b0)), mat2str(size(data_b20)));
            data_vec = [data_b0; data_b20];
            group_vec = [repmat({'B0'}, nH, 1); repmat({'B20'}, nH, 1)];
            [p, tbl, stats] = kruskalwallis(data_vec, group_vec, 'off');
            pDamp(1) = p;
            fprintf('Kruskal-Wallis Test for %s (H) B0 vs. B20: Chi2 = %.2f, p = %.4f\n', param, tbl{2, 5}, p);
            
            % B0 vs. B40
            data_b40 = [data_struct.damping(3).target.(fieldH)]';
            if size(data_b40, 2) > 1
                data_b40 = mean(data_b40, 2);
            end
            fprintf('Debug: %s (H) B0 size: %s, B40 size: %s\n', param, mat2str(size(data_b0)), mat2str(size(data_b40)));
            data_vec = [data_b0; data_b40];
            group_vec = [repmat({'B0'}, nH, 1); repmat({'B40'}, nH, 1)];
            [p, tbl, stats] = kruskalwallis(data_vec, group_vec, 'off');
            pDamp(2) = p;
            fprintf('Kruskal-Wallis Test for %s (H) B0 vs. B40: Chi2 = %.2f, p = %.4f\n', param, tbl{2, 5}, p);
            
            % B20 vs. B40
            fprintf('Debug: %s (H) B20 size: %s, B40 size: %s\n', param, mat2str(size(data_b20)), mat2str(size(data_b40)));
            data_vec = [data_b20; data_b40];
            group_vec = [repmat({'B20'}, nH, 1); repmat({'B40'}, nH, 1)];
            [p, tbl, stats] = kruskalwallis(data_vec, group_vec, 'off');
            pDamp(3) = p;
            fprintf('Kruskal-Wallis Test for %s (H) B20 vs. B40: Chi2 = %.2f, p = %.4f\n', param, tbl{2, 5}, p);
            
            % Bonferroni correction
            pDamp_adj = min(pDamp * 3, 1);
            fprintf('Bonferroni-corrected p-values for %s (H): B0B20=%.4f, B0B40=%.4f, B20B40=%.4f\n', ...
                param, pDamp_adj(1), pDamp_adj(2), pDamp_adj(3));
            Table2(rowH, :) = pDamp_adj;
            
        catch err
            fprintf('Error processing %s (H): %s\n', param, err.message);
            Table2(rowH, :) = NaN;
        end
        
        % Process Stroke group (P)
        fprintf('Kruskal-Wallis Test for %s (P) between dampings (B0 vs. B20, B0 vs. B40, B20 vs. B40)\n', param);
        pDamp = zeros(1, 3);
        try
            % Check field existence
            for d = 1:3
                if ~isfield(data_struct.damping(d).target, fieldP)
                    error('Field %s missing in %s.damping(%d).target', fieldP, source, d);
                end
            end
            
            % Pairwise comparisons
            % B0 vs. B20
            data_b0 = [data_struct.damping(1).target.(fieldP)]';
            data_b20 = [data_struct.damping(2).target.(fieldP)]';
            if size(data_b0, 2) > 1
                data_b0 = mean(data_b0, 2);
            end
            if size(data_b20, 2) > 1
                data_b20 = mean(data_b20, 2);
            end
            fprintf('Debug: %s (P) B0 size: %s, B20 size: %s\n', param, mat2str(size(data_b0)), mat2str(size(data_b20)));
            data_vec = [data_b0; data_b20];
            group_vec = [repmat({'B0'}, nP, 1); repmat({'B20'}, nP, 1)];
            [p, tbl, stats] = kruskalwallis(data_vec, group_vec, 'off');
            pDamp(1) = p;
            fprintf('Kruskal-Wallis Test for %s (P) B0 vs. B20: Chi2 = %.2f, p = %.4f\n', param, tbl{2, 5}, p);
            
            % B0 vs. B40
            data_b40 = [data_struct.damping(3).target.(fieldP)]';
            if size(data_b40, 2) > 1
                data_b40 = mean(data_b40, 2);
            end
            fprintf('Debug: %s (P) B0 size: %s, B40 size: %s\n', param, mat2str(size(data_b0)), mat2str(size(data_b40)));
            data_vec = [data_b0; data_b40];
            group_vec = [repmat({'B0'}, nP, 1); repmat({'B40'}, nP, 1)];
            [p, tbl, stats] = kruskalwallis(data_vec, group_vec, 'off');
            pDamp(2) = p;
            fprintf('Kruskal-Wallis Test for %s (P) B0 vs. B40: Chi2 = %.2f, p = %.4f\n', param, tbl{2, 5}, p);
            
            % B20 vs. B40
            fprintf('Debug: %s (P) B20 size: %s, B40 size: %s\n', param, mat2str(size(data_b20)), mat2str(size(data_b40)));
            data_vec = [data_b20; data_b40];
            group_vec = [repmat({'B20'}, nP, 1); repmat({'B40'}, nP, 1)];
            [p, tbl, stats] = kruskalwallis(data_vec, group_vec, 'off');
            pDamp(3) = p;
            fprintf('Kruskal-Wallis Test for %s (P) B20 vs. B40: Chi2 = %.2f, p = %.4f\n', param, tbl{2, 5}, p);
            
            % Bonferroni correction
            pDamp_adj = min(pDamp * 3, 1);
            fprintf('Bonferroni-corrected p-values for %s (P): B0B20=%.4f, B0B40=%.4f, B20B40=%.4f\n', ...
                param, pDamp_adj(1), pDamp_adj(2), pDamp_adj(3));
            Table2(rowP, :) = pDamp_adj;
            
        catch err
            fprintf('Error processing %s (P): %s\n', param, err.message);
            Table2(rowP, :) = NaN;
        end
        
    catch err
        fprintf('Error selecting data source for %s: %s\n', param, err.message);
        Table2([rowH, rowP], :) = NaN;
    end
end

% Display Table 2
fprintf('\nTable 2\n');
tbl2 = array2table(Table2, 'RowNames', rowNames, 'VariableNames', varNames);
colorizeTable(tbl2);