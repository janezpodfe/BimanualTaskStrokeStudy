function colorizeTable(tbl)
    % COLORIZETABLE Displays table values with color coding based on value ranges
    %   colorizeTable(tbl) prints the table with:
    %     - values > 0.05 in black
    %     - 0.01 <= values <= 0.05 in blue
    %     - values < 0.01 in green
    
    % Check if cprintf is available (from File Exchange)
    hasCprintf = true;% exist('cprintf', 'file') == 2;
    
    % Convert table to array for processing
    data = table2array(tbl);
    
    % Get table row and column names
    rowNames = tbl.Properties.RowNames;
    if isempty(rowNames)
        rowNames = strcat('Row', cellstr(num2str((1:size(tbl,1))')));
    end
    varNames = tbl.Properties.VariableNames;
    
    % Determine the maximum length of row names for formatting
    maxRowNameLength = max(cellfun(@length, rowNames));
    
    % Create a formatted string for the entire table
    outputStr = '';
    
    % Add column headers
    header = sprintf('%*s', maxRowNameLength + 2, '');
    for i = 1:length(varNames)
        header = [header sprintf('%-12s', varNames{i})];
    end
    outputStr = [outputStr header newline];
    
    % Process each row
    for row = 1:size(data, 1)
        % Add row name
        rowStr = sprintf('%*s: ', maxRowNameLength, rowNames{row});
        
        % Process each value
        for col = 1:size(data, 2)
            value = data(row, col);
            
            if hasCprintf
                % If cprintf is available, we'll use it later
                formattedValue = sprintf('%-12.4g', value);
            else
                % Without cprintf, we'll use HTML for the display
                if value > 0.05
                    formattedValue = sprintf('%-12.4g', value); % Black
                elseif value >= 0.01
                    formattedValue = sprintf('<font color="blue">%-12.4g</font>', value);
                else
                    formattedValue = sprintf('<font color="green">%-12.4g</font>', value);
                end
            end
            
            rowStr = [rowStr formattedValue];
        end
        
        outputStr = [outputStr rowStr newline];
    end
    
    % Display the result
    if hasCprintf
        % Display with cprintf
        %clc; % Clear command window for better display
        fprintf('%s', header);
        fprintf('\n');
        
        for row = 1:size(data, 1)
            fprintf('%*s: ', maxRowNameLength, rowNames{row});
            
            for col = 1:size(data, 2)
                value = data(row, col);
                
                if value > 0.05
                    cprintf('text', '%-12.4g', value); % Black
                elseif value >= 0.01
                    cprintf('blue', '%-12.4g', value); % Blue
                else
                    cprintf('green', '%-12.4g', value); % Green
                end
            end
            fprintf('\n');
        end
    else
        % Display with HTML (works in Command Window)
        disp(['<html>' strrep(outputStr, newline, '<br/>') '</html>']);
    end
end