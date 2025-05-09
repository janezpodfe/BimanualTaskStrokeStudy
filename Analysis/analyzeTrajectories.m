function [x_polygon, y_polygon] = analyzeTrajectories(trajectories, range)
    warning('off');
    % Find the maximum length among all trajectories
    lengths = cellfun(@(x) size(x,1), trajectories);
    max_length = max(lengths);
    
    % Interpolate all trajectories to the maximum length
    x_data = zeros(max_length, length(trajectories));
    y_data = zeros(max_length, length(trajectories));
    
    for i = 1:length(trajectories)
        current_length = lengths(i);
        t_original = linspace(0, 1, current_length);
        t_interp = linspace(0, 1, max_length);
        x_data(:,i) = interp1(t_original, trajectories{i}(:,1), t_interp, 'pchip');
        y_data(:,i) = interp1(t_original, trajectories{i}(:,2), t_interp, 'pchip');
    end
    
    % Calculate median trajectory
    x_median = median(x_data, 2);
    y_median = median(y_data, 2);
    
    % Calculate single normal vector based on start and end points of median trajectory
    dx = x_median(end) - x_median(1);
    dy = y_median(end) - y_median(1);
    
    % Calculate normal vector (rotate tangent by 90 degrees)
    normal_x = -dy;
    normal_y = dx;
    
    % Normalize normal vector
    norm_length = sqrt(normal_x^2 + normal_y^2);
    normal_x = normal_x / norm_length;
    normal_y = normal_y / norm_length;
    
    % Calculate signed distances for each trajectory point using the fixed normal
    signed_distances = zeros(max_length, length(trajectories));
    for i = 1:length(trajectories)
        for j = 1:max_length
            % Vector from median to trajectory point
            vec_x = x_data(j,i) - x_median(j);
            vec_y = y_data(j,i) - y_median(j);
            
            % Signed distance is the dot product with normal vector
            signed_distances(j,i) = vec_x * normal_x + vec_y * normal_y;
        end
    end
    
    % Calculate percentiles of signed distances
    dist_25 = prctile(signed_distances, (50-range/2), 2);
    dist_75 = prctile(signed_distances, (50+range/2), 2);
    
    % Create polygon vertices using median trajectory and fixed normal vector
    x_polygon = [x_median + normal_x * dist_25; 
                 flipud(x_median + normal_x * dist_75)];
    y_polygon = [y_median + normal_y * dist_25;
                 flipud(y_median + normal_y * dist_75)];
    
end