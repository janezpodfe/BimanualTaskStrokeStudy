% Non-parametric analysis for Table 1: Between-group comparisons (H vs. P) at damping levels (B0, B20, B40)
close all;
clear Table1;

% Initialize Table1 for 9 parameters and 3 damping levels
Table1 = NaN(9, 3);
rowNames = {'V_T', 'V_v', 'v_par', 'v_perp', 'v_Nperp', 'V_FM', 'V_FI', 'F_Mpar', 'F_Mperp'};
varNames = {'B0', 'B20', 'B40'};

% Sample sizes
nH = 16; % Healthy participants (confirmed)
nP = 16; % Stroke participants (confirmed)
nTotal = nH + nP; % Total participants (n=32)
alpha = 0.05; % Significance level
alpha_adj = alpha / 3; % Bonferroni-corrected alpha (0.05/3 ≈ 0.0167)

% Define parameters and their data sources
params = struct(...
    'V_T', struct('source', 'Trajektorije', 'fieldH', 'areaH', 'fieldP', 'areaP'), ...
    'V_v', struct('source', 'Velocity', 'fieldH', 'areaH', 'fieldP', 'areaP'), ...
    'v_par', struct('source', 'Velocity', 'fieldH', 'directH', 'fieldP', 'directP'), ...
    'v_perp', struct('source', 'Velocity', 'fieldH', 'perpH', 'fieldP', 'perpP'), ...
    'v_Nperp', struct('source', 'Velocity', 'fieldH', 'dirRatioH', 'fieldP', 'dirRatioP'), ...
    'V_FM', struct('source', 'sum_FD_FL', 'fieldH', 'areaH', 'fieldP', 'areaP'), ...
    'V_FI', struct('source', 'diff_FD_FL', 'fieldH', 'areaH', 'fieldP', 'areaP'), ...
    'F_Mpar', struct('source', 'sum_FD_FL', 'fieldH', 'directH', 'fieldP', 'directP'), ...
    'F_Mperp', struct('source', 'sum_FD_FL', 'fieldH', 'perpH', 'fieldP', 'perpP'));

% Loop over parameters
param_names = fieldnames(params);
for pp = 1:length(param_names)
    param = param_names{pp};
    fprintf('Kruskal-Wallis Test for parameter %s: Damping (B0, B20, B40) and Group (H, P)\n', param);
    
    % Get data source and fields
    source = params.(param).source;
    fieldH = params.(param).fieldH;
    fieldP = params.(param).fieldP;
    
    % Prepare data for all damping levels
    try
        % Select data structure
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
        
        % Check if fields exist
        for d = 1:3
            if ~isfield(data_struct.damping(d).target, fieldH) || ~isfield(data_struct.damping(d).target, fieldP)
                error('Field %s or %s missing in %s.damping(%d).target', fieldH, fieldP, source, d);
            end
        end
        
        % Create data table
        data = table(...
            (1:nTotal)', ... % Participant ID
            [repmat({'H'}, nH, 1); repmat({'P'}, nP, 1)], ... % Group (H or P)
            [[data_struct.damping(1).target.(fieldH)]'; [data_struct.damping(1).target.(fieldP)]'], ... % B0
            [[data_struct.damping(2).target.(fieldH)]'; [data_struct.damping(2).target.(fieldP)]'], ... % B20
            [[data_struct.damping(3).target.(fieldH)]'; [data_struct.damping(3).target.(fieldP)]'], ... % B40
            'VariableNames', {'ID', 'Group', 'B0', 'B20', 'B40'});

        % Verify data dimensions
        if height(data) ~= nTotal
            fprintf('Error: Data dimension mismatch for %s, expected %d rows, got %d\n', ...
                param, nTotal, height(data));
            continue;
        end
        
        % Perform Kruskal-Wallis test for each damping level
        damping_levels = {'B0', 'B20', 'B40'};
        p_values = zeros(1, 3);
        for d = 1:length(damping_levels)
            damping = damping_levels{d};
            h_data = data.(damping)(strcmp(data.Group, 'H')); % Healthy group data
            p_data = data.(damping)(strcmp(data.Group, 'P')); % Stroke group data
            
            % Debug data sizes
            fprintf('Debug: %s at %s - H data size: %s, P data size: %s\n', ...
                param, damping, mat2str(size(h_data)), mat2str(size(p_data)));
            
            % Aggregate if multiple targets
            if size(h_data, 2) > 1
                h_data = mean(h_data, 2); % Mean across targets
            end
            if size(p_data, 2) > 1
                p_data = mean(p_data, 2);
            end
            
            % Verify aggregated data dimensions
            fprintf('Debug: %s at %s - Aggregated H data size: %s, P data size: %s\n', ...
                param, damping, mat2str(size(h_data)), mat2str(size(p_data)));
            
            % Kruskal-Wallis test
            try
                data_vec = [h_data; p_data];
                group_vec = [repmat({'H'}, length(h_data), 1); repmat({'P'}, length(p_data), 1)];
                [p, tbl, stats] = kruskalwallis(data_vec, group_vec, 'off');
                chi2_kw = tbl{2, 5}; % Chi-square statistic
                fprintf('Kruskal-Wallis Test for %s at %s: Chi2 = %.2f, p = %.4f\n', ...
                    param, damping, chi2_kw, p);
                p_values(d) = p;
            catch err
                fprintf('Error in Kruskal-Wallis test for %s at %s: %s\n', ...
                    param, damping, err.message);
                p_values(d) = NaN;
            end
        end
        
        % Bonferroni correction
        p_values_adj = min(p_values * 3, 1); % Adjust for 3 comparisons
        fprintf('Bonferroni-corrected p-values for %s: B0=%.4f, B20=%.4f, B40=%.4f\n', ...
            param, p_values_adj(1), p_values_adj(2), p_values_adj(3));
        
        % Store in Table1
        Table1(pp, :) = p_values_adj;
        
    catch err
        fprintf('Error processing parameter %s: %s\n', param, err.message);
        Table1(pp, :) = NaN;
    end
end

% Display Table 1
fprintf('\nTable 1\n');
tbl1 = array2table(Table1, 'RowNames', rowNames, 'VariableNames', varNames);
colorizeTable(tbl1);