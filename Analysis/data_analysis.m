load('haptic_data.mat')

%%
Table1 = NaN(9,3);
Table2 = NaN(24,3);

Sub_H = [1:25];
Sub_P = [26:38];

sample_size_P = (length(Sub_P))*3;

Sub_All = [Sub_H, Sub_P];


target_pose = [0 -0.16;0.17 -0.16;0.17 0.16;0 -0.16;-0.17 -0.16;0.17 -0.16;0 -0.16;-0.17 0.16;-0.17 -0.16;
    0 -0.16;0 0.16;0 -0.16;0.17 0.16;0.17 -0.16;-0.17 -0.16;-0.17 0.16;0 -0.16];

for xi = Sub_All
    disp(['Person ', int2str(xi)])
    for xj = 1:3
        Fl_local = [haptic_data(xi).damping(xj).data_all(20,:); haptic_data(xi).damping(xj).data_all(21,:)]';
        grip_force_data(xi).damping(xj).Fl_local = Fl_local;

        Fd_local = [haptic_data(xi).damping(xj).data_all(23,:); haptic_data(xi).damping(xj).data_all(24,:)]';
        grip_force_data(xi).damping(xj).Fd_local = Fd_local;

        grip_force_data(xi).damping(xj).F_sum = [haptic_data(xi).damping(xj).data_all(26,:); haptic_data(xi).damping(xj).data_all(27,:)]';

        position = [haptic_data(xi).damping(xj).data_all(3,:); haptic_data(xi).damping(xj).data_all(4,:)]';
        pose_data(xi).damping(xj).position = position;

    end
end

%% Izriše poligone na 3 slikah po 16 tarč

num_points = 200;
range = 90;

ji = 0;

main_title = 'Trajectory';

for damping_no = 1:3

    %figure

    for target_no = 1:16

        clear trajectories
        clear trajectoriesH
        %subplot(4,4,target_no)
        figure
        title(target_no)
        hold on
        axis equal
        axis([-0.22 0.22 -0.22 0.22])
        xlabel('y')
        ylabel('z')        

        interp_x = zeros(num_points, length(Sub_H)*3);
        interp_y = zeros(num_points, length(Sub_H)*3);

        interp_x_a = zeros(num_points, 5*3);
        interp_y_a = zeros(num_points, 5*3);

        Distances = zeros(num_points, length(Sub_H)*3);
        idx = 1;

        for subject_no = Sub_H;
            for repetition_no = 1:length(haptic_data(subject_no).damping(damping_no).min_index_table)

                position = pose_data(subject_no).damping(damping_no).position(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,1):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,2),:);

                %plot(position(:,1), position(:,2),'b')
                trajectoriesH{idx}(:,1) = position(:,1);
                trajectoriesH{idx}(:,2) = position(:,2);                  

                interp_x(:,idx) = interp1(1:length(position(:,1)), position(:,1), linspace(1, length(position(:,1)), num_points));
                interp_y(:,idx) = interp1(1:length(position(:,2)), position(:,2), linspace(1, length(position(:,2)), num_points));

                idx = idx + 1;


            end
        end

        [xH, yH] = analyzeTrajectories(trajectoriesH, range);

        poly1 = polyshape(xH, yH);
   

        interp_x = zeros(num_points, sample_size_P);
        interp_y = zeros(num_points, sample_size_P);
        Distances = zeros(num_points, sample_size_P);
        idx = 1;

        for subject_no = Sub_P;
            for repetition_no = 1:length(haptic_data(subject_no).damping(damping_no).min_index_table)
                position = pose_data(subject_no).damping(damping_no).position(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,1):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,2),:);

                %plot(position(:,1), position(:,2), 'r')
                trajectories{idx}(:,1) = position(:,1);
                trajectories{idx}(:,2) = position(:,2);                

                interp_x(:,idx) = interp1(1:length(position(:,1)), position(:,1), linspace(1, length(position(:,1)), num_points));
                interp_y(:,idx) = interp1(1:length(position(:,2)), position(:,2), linspace(1, length(position(:,2)), num_points));
                idx = idx + 1;
            end
        end        
    
        [xP, yP] = analyzeTrajectories(trajectories, range);

        poly2 = polyshape(xP, yP);

        patch(xP, yP, 'r', 'FaceAlpha', 0.3, 'EdgeColor', 'r');
        patch(xH, yH, 'b', 'FaceAlpha', 0.0, 'LineWidth', 2, 'EdgeColor', 'b');

    
        title(num2str(target_no))

        plot(target_pose(target_no,1), target_pose(target_no,2),'kx','MarkerSize',8,'LineWidth',2)
        plot(target_pose(target_no+1,1), target_pose(target_no+1,2),'ko','MarkerSize',8,'LineWidth',2)

        xticks([-0.2 -0.1 0 0.1 0.2])
        yticks([-0.2 -0.1 0 0.1 0.2])
        set(gcf,'units','centimeters','position',[0,0,10,10]); 
        set(gca,'FontSize',10,'FontName','Times');
        %print(['D', num2str(damping_no), '_', num2str(target_no)],'-depsc2', '-vector');        
      
        Trajektorije.damping(damping_no).target(target_no).areaH = poly1.area;
        Trajektorije.damping(damping_no).target(target_no).areaP = poly2.area;

    end

    close all

end

%% Parameter for V_T

% Display purpose
disp('Two-way mixed ANOVA for parameter V_T: Damping (B0, B20, B40) and Group (H, P)')

% Prepare data in long format for repeated-measures ANOVA
% Assume diff_FD_FL.damping(i).target.areaH/P are arrays of participant scores
nH = length([Trajektorije.damping(1).target.areaH]);
nP = length([Trajektorije.damping(1).target.areaP]);
nTotal = nH + nP; % Total participants (n=38)

% Create table: participant ID, group, V_FI scores for each damping level
data = table(...
    (1:nTotal)', ... % Participant ID
    [repmat({'H'}, nH, 1); repmat({'P'}, nP, 1)], ... % Group (H or P)
    [[Trajektorije.damping(1).target.areaH]'; [Trajektorije.damping(1).target.areaP]'], ... % B0
    [[Trajektorije.damping(2).target.areaH]'; [Trajektorije.damping(2).target.areaP]'], ... % B20
    [[Trajektorije.damping(3).target.areaH]'; [Trajektorije.damping(3).target.areaP]'], ... % B40
    'VariableNames', {'ID', 'Group', 'B0', 'B20', 'B40'});

% Define within-subjects factor (Damping)
withinDesign = table([1; 2; 3], 'VariableNames', {'Damping'});
withinDesign.Damping = categorical(withinDesign.Damping);

% Fit repeated-measures model
rm = fitrm(data, 'B0-B40 ~ Group', 'WithinDesign', withinDesign);

% Run ANOVA for within-subjects effects and interaction
anovaTable = ranova(rm, 'WithinModel', 'Damping');

% Run ANOVA for between-subjects effect (Group)
betweenTable = anova(rm);

% Extract F-statistics and p-values
F_damping = anovaTable.F(1); % Damping main effect
p_damping = anovaTable.pValue(1);
F_interaction = anovaTable.F(2); % Damping*Group interaction
p_interaction = anovaTable.pValue(2);
F_group = betweenTable.F(1); % Group main effect
p_group = betweenTable.pValue(1);

% Display ANOVA results
disp('Two-way mixed ANOVA results:')
disp(['Damping main effect: F = ', num2str(F_damping), ', p = ', num2str(p_damping)])
disp(['Group main effect: F = ', num2str(F_group), ', p = ', num2str(p_group)])
disp(['Damping*Group interaction: F = ', num2str(F_interaction), ', p = ', num2str(p_interaction)])

% Post-hoc tests for significant effects (Bonferroni-corrected)
posthoc_p = [];
if p_damping < 0.05 || p_interaction < 0.05 || p_group < 0.05
    % Compare groups at each damping level
    mc = multcompare(rm, 'Group', 'By', 'Damping', 'ComparisonType', 'bonferroni');
    posthoc_p = mc.pValue; % P-values for H vs. P at B0, B20, B40
    disp('Post-hoc comparisons (Bonferroni-corrected):')
    disp(mc)
end

% Update Table1 for V_FI (row 7)
% Store post-hoc p-values for H vs. P at each damping level
Table1(1, :) = posthoc_p([1 3 5])' % Transpose to 1x3 for B0, B20, B40

%% 
disp('p-values for H between dampings for Parameter V_T')
pDamp = zeros(1,3);

groupOneScores = [Trajektorije.damping(1).target.areaH]';
groupTwoScores = [Trajektorije.damping(2).target.areaH]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Trajektorije.damping(1).target.areaH]';
groupTwoScores = [Trajektorije.damping(3).target.areaH]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Trajektorije.damping(2).target.areaH]';
groupTwoScores = [Trajektorije.damping(3).target.areaH]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(1,:) = pDamp(:)';

disp('p-values for P between dampings for Parameter V_T')
pDamp = zeros(1,3);

groupOneScores = [Trajektorije.damping(1).target.areaP]';
groupTwoScores = [Trajektorije.damping(2).target.areaP]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Trajektorije.damping(1).target.areaP]';
groupTwoScores = [Trajektorije.damping(3).target.areaP]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Trajektorije.damping(2).target.areaP]';
groupTwoScores = [Trajektorije.damping(3).target.areaP]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(2,:) = pDamp(:)';

%%

% Figure 6a
figure
boxplot([[Trajektorije.damping(1).target.areaH]', [Trajektorije.damping(1).target.areaP]', [Trajektorije.damping(2).target.areaH]', [Trajektorije.damping(2).target.areaP]', [Trajektorije.damping(3).target.areaH]', [Trajektorije.damping(3).target.areaP]'])
A = axis;
y_text = (A(4)-A(3))*0.1+A(4);
A(4) = (A(4)-A(3))*0.2+A(4);
text(1.5, y_text, 'D0', 'HorizontalAlignment', 'center')
text(3.5, y_text, 'D20', 'HorizontalAlignment', 'center')
text(5.5, y_text, 'D40', 'HorizontalAlignment', 'center')
axis(A)
hold on
plot([2.5 2.5], [A(3), A(4)],'k--')
plot([4.5 4.5], [A(3), A(4)],'k--')
xticks([1 2 3 4 5 6])
xticklabels({'H','P','H','P','H','P'})
title('area')

%%
dT = 0.005;
num_points = 200;

ji = 0;

main_title = 'Velocity';

for damping_no = 1:3

    figure

    for target_no = 1:16

        subplot(4,4,target_no)
        title(target_no)
        hold on
        axis equal
        axis([-0.35 0.35 -0.35 0.35])
        xlabel('y')
        ylabel('z')        

        dir_vec = target_pose(target_no+1,:)-target_pose(target_no,:);
        dir_vec = dir_vec/vecnorm(dir_vec);

        interp_x = zeros(num_points, length(Sub_H)*3);
        interp_y = zeros(num_points, length(Sub_H)*3);
        DirectH = zeros(1, length(Sub_H)*3);
        PerpH = zeros(1, length(Sub_H)*3);
        dirRatioH = zeros(1, length(Sub_H)*3);         
        idx = 1;

        for subject_no = Sub_H;
            for repetition_no = 1:length(haptic_data(subject_no).damping(damping_no).min_index_table)

                position = pose_data(subject_no).damping(damping_no).position(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,1):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,2),:);
                position = diff(position)/dT;

                %plot(position(:,1), position(:,2), 'b')

                interp_x(:,idx) = interp1(1:length(position(:,1)), position(:,1), linspace(1, length(position(:,1)), num_points));
                interp_y(:,idx) = interp1(1:length(position(:,2)), position(:,2), linspace(1, length(position(:,2)), num_points));
                
                interrp_xy = [interp_x(:,idx), interp_y(:,idx)];
                [directH, perpH, neg_dirH] = projectionOnTargetDirection(interrp_xy, repmat(dir_vec,size(interrp_xy,1),1));
                DirectH(idx) = directH;
                PerpH(idx) = perpH;
                dirRatioH(idx) = perpH/directH;                    
                idx = idx + 1;


            end
        end

        [Area1, xC, yC] = plotConvHull(interp_x, interp_y, range/100, 'H');
        
        poly1 = polyshape(xC, yC);

        interp_x = zeros(num_points, length(Sub_P)*3);
        interp_y = zeros(num_points, length(Sub_P)*3);
        DirectP = zeros(1, length(Sub_P)*3);
        PerpP = zeros(1, length(Sub_P)*3);
        dirRatioP = zeros(1, length(Sub_P)*3);          
        idx = 1;

        for subject_no = Sub_P;
            for repetition_no = 1:length(haptic_data(subject_no).damping(damping_no).min_index_table)
                position = pose_data(subject_no).damping(damping_no).position(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,1):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,2),:);
                position = diff(position)/dT;

                %plot(position(:,1), position(:,2), 'r')

                interp_x(:,idx) = interp1(1:length(position(:,1)), position(:,1), linspace(1, length(position(:,1)), num_points));
                interp_y(:,idx) = interp1(1:length(position(:,2)), position(:,2), linspace(1, length(position(:,2)), num_points));

                interrp_xy = [interp_x(:,idx), interp_y(:,idx)];
                [directP, perpP, neg_dirP] = projectionOnTargetDirection(interrp_xy, repmat(dir_vec,size(interrp_xy,1),1));
                DirectP(idx) = directP;
                PerpP(idx) = perpP;
                dirRatioP(idx) = perpP/directP;                 
                idx = idx + 1;
            end
        end

        [Area2, xC, yC] = plotConvHull(interp_x, interp_y, range/100, 'PR');

        poly2 = polyshape(xC, yC);

        title(num2str(target_no))

        %plot(target_pose(target_no,1), target_pose(target_no,2),'kx','MarkerSize',8,'LineWidth',2)
        %plot(target_pose(target_no+1,1), target_pose(target_no+1,2),'ko','MarkerSize',8,'LineWidth',2)

        Velocity.damping(damping_no).target(target_no).areaH = poly1.area;
        Velocity.damping(damping_no).target(target_no).areaP = poly2.area;
        Velocity.damping(damping_no).target(target_no).directH = median(DirectH);
        Velocity.damping(damping_no).target(target_no).perpH = median(PerpH);
        Velocity.damping(damping_no).target(target_no).dirRatioH = median(dirRatioH);
        Velocity.damping(damping_no).target(target_no).directP = median(DirectP);
        Velocity.damping(damping_no).target(target_no).perpP = median(PerpP);
        Velocity.damping(damping_no).target(target_no).dirRatioP = median(dirRatioP);
    end

    %print(gcf,[main_title,'_d',num2str(damping_no)],'-dpdf','-fillpage')

end

%%

% Figure 6b
figure
boxplot([[Velocity.damping(1).target.areaH]', [Velocity.damping(1).target.areaP]', [Velocity.damping(2).target.areaH]', [Velocity.damping(2).target.areaP]', [Velocity.damping(3).target.areaH]', [Velocity.damping(3).target.areaP]'])
A = axis;
y_text = (A(4)-A(3))*0.1+A(4);
A(4) = (A(4)-A(3))*0.2+A(4);
text(1.5, y_text, 'D0', 'HorizontalAlignment', 'center')
text(3.5, y_text, 'D20', 'HorizontalAlignment', 'center')
text(5.5, y_text, 'D40', 'HorizontalAlignment', 'center')
axis(A)
hold on
plot([2.5 2.5], [A(3), A(4)],'k--')
plot([4.5 4.5], [A(3), A(4)],'k--')
xticks([1 2 3 4 5 6])
xticklabels({'H','P','H','P','H','P'})
title('area vel')

%% Figure 7

% Figure 7a
figure
boxplot([[Velocity.damping(1).target.directH]', [Velocity.damping(1).target.directP]', [Velocity.damping(2).target.directH]', [Velocity.damping(2).target.directP]', [Velocity.damping(3).target.directH]', [Velocity.damping(3).target.directP]'])
A = axis;
y_text = (A(4)-A(3))*0.00+A(4);
A(4) = (A(4)-A(3))*0.05+A(4);
text(1.5, y_text, 'D0', 'HorizontalAlignment', 'center')
text(3.5, y_text, 'D20', 'HorizontalAlignment', 'center')
text(5.5, y_text, 'D40', 'HorizontalAlignment', 'center')
axis(A)
hold on
plot([2.5 2.5], [A(3), A(4)],'k--')
plot([4.5 4.5], [A(3), A(4)],'k--')
xticks([1 2 3 4 5 6])
xticklabels({'H','P','H','P','H','P'})
title('dir vel')

% Figure 7b
figure
boxplot([[Velocity.damping(1).target.perpH]', [Velocity.damping(1).target.perpP]', [Velocity.damping(2).target.perpH]', [Velocity.damping(2).target.perpP]', [Velocity.damping(3).target.perpH]', [Velocity.damping(3).target.perpP]'])
A = axis;
y_text = (A(4)-A(3))*0.00+A(4);
A(4) = (A(4)-A(3))*0.05+A(4);
text(1.5, y_text, 'D0', 'HorizontalAlignment', 'center')
text(3.5, y_text, 'D20', 'HorizontalAlignment', 'center')
text(5.5, y_text, 'D40', 'HorizontalAlignment', 'center')
axis(A)
hold on
plot([2.5 2.5], [A(3), A(4)],'k--')
plot([4.5 4.5], [A(3), A(4)],'k--')
xticks([1 2 3 4 5 6])
xticklabels({'H','P','H','P','H','P'})
title('perp vel')

% Figure 7c
figure
boxplot([[Velocity.damping(1).target.dirRatioH]', [Velocity.damping(1).target.dirRatioP]', [Velocity.damping(2).target.dirRatioH]', [Velocity.damping(2).target.dirRatioP]', [Velocity.damping(3).target.dirRatioH]', [Velocity.damping(3).target.dirRatioP]'])
A = axis;
y_text = (A(4)-A(3))*0.00+A(4);
A(4) = (A(4)-A(3))*0.05+A(4);
text(1.5, y_text, 'D0', 'HorizontalAlignment', 'center')
text(3.5, y_text, 'D20', 'HorizontalAlignment', 'center')
text(5.5, y_text, 'D40', 'HorizontalAlignment', 'center')
axis(A)
hold on
plot([2.5 2.5], [A(3), A(4)],'k--')
plot([4.5 4.5], [A(3), A(4)],'k--')
xticks([1 2 3 4 5 6])
xticklabels({'H','P','H','P','H','P'})
title('dir ratio vel')

%%

% Table 1, p_HP, Parameter V_v

% Display purpose
disp('Two-way mixed ANOVA for parameter V_v: Damping (B0, B20, B40) and Group (H, P)')

% Prepare data in long format for repeated-measures ANOVA
% Assume diff_FD_FL.damping(i).target.areaH/P are arrays of participant scores
nH = length([Velocity.damping(1).target.areaH]);
nP = length([Velocity.damping(1).target.areaP]);
nTotal = nH + nP; % Total participants (n=38)

% Create table: participant ID, group, V_FI scores for each damping level
data = table(...
    (1:nTotal)', ... % Participant ID
    [repmat({'H'}, nH, 1); repmat({'P'}, nP, 1)], ... % Group (H or P)
    [[Velocity.damping(1).target.areaH]'; [Velocity.damping(1).target.areaP]'], ... % B0
    [[Velocity.damping(2).target.areaH]'; [Velocity.damping(2).target.areaP]'], ... % B20
    [[Velocity.damping(3).target.areaH]'; [Velocity.damping(3).target.areaP]'], ... % B40
    'VariableNames', {'ID', 'Group', 'B0', 'B20', 'B40'});

% Define within-subjects factor (Damping)
withinDesign = table([1; 2; 3], 'VariableNames', {'Damping'});
withinDesign.Damping = categorical(withinDesign.Damping);

% Fit repeated-measures model
rm = fitrm(data, 'B0-B40 ~ Group', 'WithinDesign', withinDesign);

% Run ANOVA for within-subjects effects and interaction
anovaTable = ranova(rm, 'WithinModel', 'Damping');

% Run ANOVA for between-subjects effect (Group)
betweenTable = anova(rm);

% Extract F-statistics and p-values
F_damping = anovaTable.F(1); % Damping main effect
p_damping = anovaTable.pValue(1);
F_interaction = anovaTable.F(2); % Damping*Group interaction
p_interaction = anovaTable.pValue(2);
F_group = betweenTable.F(1); % Group main effect
p_group = betweenTable.pValue(1);

% Display ANOVA results
disp('Two-way mixed ANOVA results:')
disp(['Damping main effect: F = ', num2str(F_damping), ', p = ', num2str(p_damping)])
disp(['Group main effect: F = ', num2str(F_group), ', p = ', num2str(p_group)])
disp(['Damping*Group interaction: F = ', num2str(F_interaction), ', p = ', num2str(p_interaction)])

% Post-hoc tests for significant effects (Bonferroni-corrected)
posthoc_p = [];
if p_damping < 0.05 || p_interaction < 0.05 || p_group < 0.05
    % Compare groups at each damping level
    mc = multcompare(rm, 'Group', 'By', 'Damping', 'ComparisonType', 'bonferroni');
    posthoc_p = mc.pValue; % P-values for H vs. P at B0, B20, B40
    disp('Post-hoc comparisons (Bonferroni-corrected):')
    disp(mc)
end

% Update Table1 for V_FI (row 7)
% Store post-hoc p-values for H vs. P at each damping level
Table1(2, :) = posthoc_p([1 3 5])' % Transpose to 1x3 for B0, B20, B40

%%

% Table 1, p_HP, Parameter v_par

% Display purpose
disp('Two-way mixed ANOVA for parameter V_v: Damping (B0, B20, B40) and Group (H, P)')

% Prepare data in long format for repeated-measures ANOVA
% Assume diff_FD_FL.damping(i).target.areaH/P are arrays of participant scores
nH = length([Velocity.damping(1).target.directH]);
nP = length([Velocity.damping(1).target.directP]);
nTotal = nH + nP; % Total participants (n=38)

% Create table: participant ID, group, V_FI scores for each damping level
data = table(...
    (1:nTotal)', ... % Participant ID
    [repmat({'H'}, nH, 1); repmat({'P'}, nP, 1)], ... % Group (H or P)
    [[Velocity.damping(1).target.directH]'; [Velocity.damping(1).target.directP]'], ... % B0
    [[Velocity.damping(2).target.directH]'; [Velocity.damping(2).target.directP]'], ... % B20
    [[Velocity.damping(3).target.directH]'; [Velocity.damping(3).target.directP]'], ... % B40
    'VariableNames', {'ID', 'Group', 'B0', 'B20', 'B40'});

% Define within-subjects factor (Damping)
withinDesign = table([1; 2; 3], 'VariableNames', {'Damping'});
withinDesign.Damping = categorical(withinDesign.Damping);

% Fit repeated-measures model
rm = fitrm(data, 'B0-B40 ~ Group', 'WithinDesign', withinDesign);

% Run ANOVA for within-subjects effects and interaction
anovaTable = ranova(rm, 'WithinModel', 'Damping');

% Run ANOVA for between-subjects effect (Group)
betweenTable = anova(rm);

% Extract F-statistics and p-values
F_damping = anovaTable.F(1); % Damping main effect
p_damping = anovaTable.pValue(1);
F_interaction = anovaTable.F(2); % Damping*Group interaction
p_interaction = anovaTable.pValue(2);
F_group = betweenTable.F(1); % Group main effect
p_group = betweenTable.pValue(1);

% Display ANOVA results
disp('Two-way mixed ANOVA results:')
disp(['Damping main effect: F = ', num2str(F_damping), ', p = ', num2str(p_damping)])
disp(['Group main effect: F = ', num2str(F_group), ', p = ', num2str(p_group)])
disp(['Damping*Group interaction: F = ', num2str(F_interaction), ', p = ', num2str(p_interaction)])

% Post-hoc tests for significant effects (Bonferroni-corrected)
posthoc_p = [];
if p_damping < 0.05 || p_interaction < 0.05 || p_group < 0.05
    % Compare groups at each damping level
    mc = multcompare(rm, 'Group', 'By', 'Damping', 'ComparisonType', 'bonferroni');
    posthoc_p = mc.pValue; % P-values for H vs. P at B0, B20, B40
    disp('Post-hoc comparisons (Bonferroni-corrected):')
    disp(mc)
end

% Update Table1 for V_FI (row 7)
% Store post-hoc p-values for H vs. P at each damping level
Table1(3, :) = posthoc_p([1 3 5])' % Transpose to 1x3 for B0, B20, B40

%%

% Display purpose
disp('Two-way mixed ANOVA for parameter v_perp: Damping (B0, B20, B40) and Group (H, P)')

% Prepare data in long format for repeated-measures ANOVA
% Assume diff_FD_FL.damping(i).target.areaH/P are arrays of participant scores
nH = length([Velocity.damping(1).target.perpH]);
nP = length([Velocity.damping(1).target.perpP]);
nTotal = nH + nP; % Total participants (n=38)

% Create table: participant ID, group, V_FI scores for each damping level
data = table(...
    (1:nTotal)', ... % Participant ID
    [repmat({'H'}, nH, 1); repmat({'P'}, nP, 1)], ... % Group (H or P)
    [[Velocity.damping(1).target.perpH]'; [Velocity.damping(1).target.perpP]'], ... % B0
    [[Velocity.damping(2).target.perpH]'; [Velocity.damping(2).target.perpP]'], ... % B20
    [[Velocity.damping(3).target.perpH]'; [Velocity.damping(3).target.perpP]'], ... % B40
    'VariableNames', {'ID', 'Group', 'B0', 'B20', 'B40'});

% Define within-subjects factor (Damping)
withinDesign = table([1; 2; 3], 'VariableNames', {'Damping'});
withinDesign.Damping = categorical(withinDesign.Damping);

% Fit repeated-measures model
rm = fitrm(data, 'B0-B40 ~ Group', 'WithinDesign', withinDesign);

% Run ANOVA for within-subjects effects and interaction
anovaTable = ranova(rm, 'WithinModel', 'Damping');

% Run ANOVA for between-subjects effect (Group)
betweenTable = anova(rm);

% Extract F-statistics and p-values
F_damping = anovaTable.F(1); % Damping main effect
p_damping = anovaTable.pValue(1);
F_interaction = anovaTable.F(2); % Damping*Group interaction
p_interaction = anovaTable.pValue(2);
F_group = betweenTable.F(1); % Group main effect
p_group = betweenTable.pValue(1);

% Display ANOVA results
disp('Two-way mixed ANOVA results:')
disp(['Damping main effect: F = ', num2str(F_damping), ', p = ', num2str(p_damping)])
disp(['Group main effect: F = ', num2str(F_group), ', p = ', num2str(p_group)])
disp(['Damping*Group interaction: F = ', num2str(F_interaction), ', p = ', num2str(p_interaction)])

% Post-hoc tests for significant effects (Bonferroni-corrected)
posthoc_p = [];
if p_damping < 0.05 || p_interaction < 0.05 || p_group < 0.05
    % Compare groups at each damping level
    mc = multcompare(rm, 'Group', 'By', 'Damping', 'ComparisonType', 'bonferroni');
    posthoc_p = mc.pValue; % P-values for H vs. P at B0, B20, B40
    disp('Post-hoc comparisons (Bonferroni-corrected):')
    disp(mc)
end

% Update Table1 for V_FI (row 7)
% Store post-hoc p-values for H vs. P at each damping level
Table1(4, :) = posthoc_p([1 3 5])' % Transpose to 1x3 for B0, B20, B40

%%

% Display purpose
disp('Two-way mixed ANOVA for parameter v_N_perp: Damping (B0, B20, B40) and Group (H, P)')

% Prepare data in long format for repeated-measures ANOVA
% Assume diff_FD_FL.damping(i).target.areaH/P are arrays of participant scores
nH = length([Velocity.damping(1).target.dirRatioH]);
nP = length([Velocity.damping(1).target.dirRatioP]);
nTotal = nH + nP;

% Create table: participant ID, group, V_FI scores for each damping level
data = table(...
    (1:nTotal)', ... % Participant ID
    [repmat({'H'}, nH, 1); repmat({'P'}, nP, 1)], ... % Group (H or P)
    [[Velocity.damping(1).target.dirRatioH]'; [Velocity.damping(1).target.dirRatioP]'], ... % B0
    [[Velocity.damping(2).target.dirRatioH]'; [Velocity.damping(2).target.dirRatioP]'], ... % B20
    [[Velocity.damping(3).target.dirRatioH]'; [Velocity.damping(3).target.dirRatioP]'], ... % B40
    'VariableNames', {'ID', 'Group', 'B0', 'B20', 'B40'});

% Define within-subjects factor (Damping)
withinDesign = table([1; 2; 3], 'VariableNames', {'Damping'});
withinDesign.Damping = categorical(withinDesign.Damping);

% Fit repeated-measures model
rm = fitrm(data, 'B0-B40 ~ Group', 'WithinDesign', withinDesign);

% Run ANOVA for within-subjects effects and interaction
anovaTable = ranova(rm, 'WithinModel', 'Damping');

% Run ANOVA for between-subjects effect (Group)
betweenTable = anova(rm);

% Extract F-statistics and p-values
F_damping = anovaTable.F(1); % Damping main effect
p_damping = anovaTable.pValue(1);
F_interaction = anovaTable.F(2); % Damping*Group interaction
p_interaction = anovaTable.pValue(2);
F_group = betweenTable.F(1); % Group main effect
p_group = betweenTable.pValue(1);

% Display ANOVA results
disp('Two-way mixed ANOVA results:')
disp(['Damping main effect: F = ', num2str(F_damping), ', p = ', num2str(p_damping)])
disp(['Group main effect: F = ', num2str(F_group), ', p = ', num2str(p_group)])
disp(['Damping*Group interaction: F = ', num2str(F_interaction), ', p = ', num2str(p_interaction)])

% Post-hoc tests for significant effects (Bonferroni-corrected)
posthoc_p = [];
if p_damping < 0.05 || p_interaction < 0.05 || p_group < 0.05
    % Compare groups at each damping level
    mc = multcompare(rm, 'Group', 'By', 'Damping', 'ComparisonType', 'bonferroni');
    posthoc_p = mc.pValue; % P-values for H vs. P at B0, B20, B40
    disp('Post-hoc comparisons (Bonferroni-corrected):')
    disp(mc)
end

% Update Table1 for V_FI (row 7)
% Store post-hoc p-values for H vs. P at each damping level
Table1(5, :) = posthoc_p([1 3 5])' % Transpose to 1x3 for B0, B20, B40


%% Table 2

disp('p-values for P between dampings for Parameter v_par')
pDamp = zeros(1,3);

groupOneScores = [Velocity.damping(1).target.directP]';
groupTwoScores = [Velocity.damping(2).target.directP]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(1).target.directP]';
groupTwoScores = [Velocity.damping(3).target.directP]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(2).target.directP]';
groupTwoScores = [Velocity.damping(3).target.directP]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(6,:) = pDamp(:)';

disp('p-values for H between dampings for Parameter v_par')
pDamp = zeros(1,3);

groupOneScores = [Velocity.damping(1).target.directH]';
groupTwoScores = [Velocity.damping(2).target.directH]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(1).target.directH]';
groupTwoScores = [Velocity.damping(3).target.directH]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(2).target.directH]';
groupTwoScores = [Velocity.damping(3).target.directH]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(5,:) = pDamp(:)';

disp('p-values for P between dampings for Parameter v_perp')
pDamp = zeros(1,3);

groupOneScores = [Velocity.damping(1).target.perpP]';
groupTwoScores = [Velocity.damping(2).target.perpP]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(1).target.perpP]';
groupTwoScores = [Velocity.damping(3).target.perpP]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(2).target.perpP]';
groupTwoScores = [Velocity.damping(3).target.perpP]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(8,:) = pDamp(:)';

disp('p-values for H between dampings for Parameter v_perp')
pDamp = zeros(1,3);

groupOneScores = [Velocity.damping(1).target.perpH]';
groupTwoScores = [Velocity.damping(2).target.perpH]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(1).target.perpH]';
groupTwoScores = [Velocity.damping(3).target.perpH]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(2).target.perpH]';
groupTwoScores = [Velocity.damping(3).target.perpH]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(7,:) = pDamp(:)';

disp('p-values for H between dampings for Parameter v_N_perp')
pDamp = zeros(1,3);

groupOneScores = [Velocity.damping(1).target.dirRatioH]';
groupTwoScores = [Velocity.damping(2).target.dirRatioH]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(1).target.dirRatioH]';
groupTwoScores = [Velocity.damping(3).target.dirRatioH]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(2).target.dirRatioH]';
groupTwoScores = [Velocity.damping(3).target.dirRatioH]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(9,:) = pDamp(:)';

disp('p-values for P between dampings for Parameter v_N_perp')
pDamp = zeros(1,3);

groupOneScores = [Velocity.damping(1).target.dirRatioP]';
groupTwoScores = [Velocity.damping(2).target.dirRatioP]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(1).target.dirRatioP]';
groupTwoScores = [Velocity.damping(3).target.dirRatioP]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(2).target.dirRatioP]';
groupTwoScores = [Velocity.damping(3).target.dirRatioP]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(10,:) = pDamp(:)';

disp('p-values for P between dampings for Parameter V_v')
pDamp = zeros(1,3);

groupOneScores = [Velocity.damping(1).target.areaP]';
groupTwoScores = [Velocity.damping(2).target.areaP]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(1).target.areaP]';
groupTwoScores = [Velocity.damping(3).target.areaP]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(2).target.areaP]';
groupTwoScores = [Velocity.damping(3).target.areaP]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(4,:) = pDamp(:)';

disp('p-values for H between dampings for Parameter V_v')
pDamp = zeros(1,3);

groupOneScores = [Velocity.damping(1).target.areaH]';
groupTwoScores = [Velocity.damping(2).target.areaH]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(1).target.areaH]';
groupTwoScores = [Velocity.damping(3).target.areaH]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [Velocity.damping(2).target.areaH]';
groupTwoScores = [Velocity.damping(3).target.areaH]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(3,:) = pDamp(:)';

%%

num_points = 200;
half_points = round(num_points/2);
qs = round(num_points/5);
qe = round(4*num_points/5);

pp = [];

main_title = 'Fl+Fd';

for damping_no = 1:3

    %figure

    for target_no = 1:16

        %subplot(4,4,target_no)
        figure
        title(target_no)
        hold on
        axis equal
        %axis([-25 25 -25 25])
        %axis([-50 50 -50 50])
        axis([-30 30 -30 30])
        xlabel('y')
        ylabel('z')        

        dir_vec = target_pose(target_no+1,:)-target_pose(target_no,:);
        dir_vec = dir_vec/vecnorm(dir_vec);

        interp_xH = zeros(num_points, length(Sub_H)*3);
        interp_yH = zeros(num_points, length(Sub_H)*3);
        DirectH = zeros(1, length(Sub_H)*3);
        PerpH = zeros(1, length(Sub_H)*3);
        dirRatioH = zeros(1, length(Sub_H)*3);
        idx = 1;

        for subject_no = Sub_H;
            for repetition_no = 1:length(haptic_data(subject_no).damping(damping_no).min_index_table)

                force = 2*grip_force_data(subject_no).damping(damping_no).F_sum(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,1):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,2),:);

                %plot(force(:,1), force(:,2), 'b')

                interp_xH(:,idx) = interp1(1:length(force(:,1)), force(:,1), linspace(1, length(force(:,1)), num_points));
                interp_yH(:,idx) = interp1(1:length(force(:,2)), force(:,2), linspace(1, length(force(:,2)), num_points));

                interrp_xy = [interp_xH(:,idx), interp_yH(:,idx)];
                [directH, perpH, neg_dirH] = projectionOnTargetDirection(interrp_xy, repmat(dir_vec,size(interrp_xy,1),1));
                DirectH(idx) = directH;
                PerpH(idx) = perpH;
                dirRatioH(idx) = perpH/directH;
                
                idx = idx + 1;
            end
        end

        interp_xP = zeros(num_points, length(Sub_P)*3);
        interp_yP = zeros(num_points, length(Sub_P)*3);
        DirectP = zeros(1, length(Sub_P)*3);
        PerpP = zeros(1, length(Sub_P)*3);
        dirRatioP = zeros(1, length(Sub_P)*3);        
        idx = 1;

        for subject_no = Sub_P;
            for repetition_no = 1:length(haptic_data(subject_no).damping(damping_no).min_index_table)

                force = 2*grip_force_data(subject_no).damping(damping_no).F_sum(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,1):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,2),:);

                %plot(force(:,1), force(:,2), 'r')

                interp_xP(:,idx) = interp1(1:length(force(:,1)), force(:,1), linspace(1, length(force(:,1)), num_points));
                interp_yP(:,idx) = interp1(1:length(force(:,2)), force(:,2), linspace(1, length(force(:,2)), num_points));

                interrp_xy = [interp_xP(:,idx), interp_yP(:,idx)];
                [directP, perpP, neg_dirP] = projectionOnTargetDirection(interrp_xy, repmat(dir_vec,size(interrp_xy,1),1));
                DirectP(idx) = directP;
                PerpP(idx) = perpP;
                dirRatioP(idx) = perpP/directP;                

                idx = idx + 1;
            end
        end

        [Area2, xP, yP] = plotConvHull(interp_xP, interp_yP, range/100, 'PR');
        [Area1, xH, yH] = plotConvHull(interp_xH, interp_yH, range/100, 'H');

        poly1 = polyshape(xH, yH);
        poly2 = polyshape(xP, yP);

        title(num2str(target_no))
        xticks([-50 -25 0 25 50])
        yticks([-50 -25 0 25 50])
        set(gcf,'units','centimeters','position',[0,0,10,10]); 
        set(gca,'FontSize',10,'FontName','Times');
        %print(['D', num2str(damping_no), '_', num2str(target_no)],'-depsc2', '-vector');        

        sum_FD_FL.damping(damping_no).target(target_no).areaH = poly1.area;
        sum_FD_FL.damping(damping_no).target(target_no).areaP = poly2.area;
        sum_FD_FL.damping(damping_no).target(target_no).directH = median(DirectH);
        sum_FD_FL.damping(damping_no).target(target_no).perpH = median(PerpH);
        sum_FD_FL.damping(damping_no).target(target_no).dirRatioH = median(dirRatioH);
        sum_FD_FL.damping(damping_no).target(target_no).directP = median(DirectP);
        sum_FD_FL.damping(damping_no).target(target_no).perpP = median(PerpP);
        sum_FD_FL.damping(damping_no).target(target_no).dirRatioP = median(dirRatioP);

    end

    close all


end

%%
% Display purpose
disp('Two-way mixed ANOVA for parameter V_FM: Damping (B0, B20, B40) and Group (H, P)')

% Prepare data in long format for repeated-measures ANOVA
% Assume diff_FD_FL.damping(i).target.areaH/P are arrays of participant scores
nH = length([sum_FD_FL.damping(1).target.areaH]);
nP = length([sum_FD_FL.damping(1).target.areaP]);
nTotal = nH + nP; % Total participants (n=38)

% Create table: participant ID, group, V_FI scores for each damping level
data = table(...
    (1:nTotal)', ... % Participant ID
    [repmat({'H'}, nH, 1); repmat({'P'}, nP, 1)], ... % Group (H or P)
    [[sum_FD_FL.damping(1).target.areaH]'; [sum_FD_FL.damping(1).target.areaP]'], ... % B0
    [[sum_FD_FL.damping(2).target.areaH]'; [sum_FD_FL.damping(2).target.areaP]'], ... % B20
    [[sum_FD_FL.damping(3).target.areaH]'; [sum_FD_FL.damping(3).target.areaP]'], ... % B40
    'VariableNames', {'ID', 'Group', 'B0', 'B20', 'B40'});

% Define within-subjects factor (Damping)
withinDesign = table([1; 2; 3], 'VariableNames', {'Damping'});
withinDesign.Damping = categorical(withinDesign.Damping);

% Fit repeated-measures model
rm = fitrm(data, 'B0-B40 ~ Group', 'WithinDesign', withinDesign);

% Run ANOVA for within-subjects effects and interaction
anovaTable = ranova(rm, 'WithinModel', 'Damping');

% Run ANOVA for between-subjects effect (Group)
betweenTable = anova(rm);

% Extract F-statistics and p-values
F_damping = anovaTable.F(1); % Damping main effect
p_damping = anovaTable.pValue(1);
F_interaction = anovaTable.F(2); % Damping*Group interaction
p_interaction = anovaTable.pValue(2);
F_group = betweenTable.F(1); % Group main effect
p_group = betweenTable.pValue(1);

% Display ANOVA results
disp('Two-way mixed ANOVA results:')
disp(['Damping main effect: F = ', num2str(F_damping), ', p = ', num2str(p_damping)])
disp(['Group main effect: F = ', num2str(F_group), ', p = ', num2str(p_group)])
disp(['Damping*Group interaction: F = ', num2str(F_interaction), ', p = ', num2str(p_interaction)])

% Post-hoc tests for significant effects (Bonferroni-corrected)
posthoc_p = [];
if p_damping < 0.05 || p_interaction < 0.05 || p_group < 0.05
    % Compare groups at each damping level
    mc = multcompare(rm, 'Group', 'By', 'Damping', 'ComparisonType', 'bonferroni');
    posthoc_p = mc.pValue; % P-values for H vs. P at B0, B20, B40
    disp('Post-hoc comparisons (Bonferroni-corrected):')
    disp(mc)
end

% Update Table1 for V_FI (row 7)
% Store post-hoc p-values for H vs. P at each damping level
Table1(6, :) = posthoc_p([1 3 5])' % Transpose to 1x3 for B0, B20, B40
%%

% Display purpose
disp('Two-way mixed ANOVA for parameter F_Mpar: Damping (B0, B20, B40) and Group (H, P)')

% Prepare data in long format for repeated-measures ANOVA
% Assume diff_FD_FL.damping(i).target.areaH/P are arrays of participant scores
nH = length([sum_FD_FL.damping(1).target.directH]);
nP = length([sum_FD_FL.damping(1).target.directP]);
nTotal = nH + nP; % Total participants (n=38)

% Create table: participant ID, group, V_FI scores for each damping level
data = table(...
    (1:nTotal)', ... % Participant ID
    [repmat({'H'}, nH, 1); repmat({'P'}, nP, 1)], ... % Group (H or P)
    [[sum_FD_FL.damping(1).target.directH]'; [sum_FD_FL.damping(1).target.directP]'], ... % B0
    [[sum_FD_FL.damping(2).target.directH]'; [sum_FD_FL.damping(2).target.directP]'], ... % B20
    [[sum_FD_FL.damping(3).target.directH]'; [sum_FD_FL.damping(3).target.directP]'], ... % B40
    'VariableNames', {'ID', 'Group', 'B0', 'B20', 'B40'});

% Define within-subjects factor (Damping)
withinDesign = table([1; 2; 3], 'VariableNames', {'Damping'});
withinDesign.Damping = categorical(withinDesign.Damping);

% Fit repeated-measures model
rm = fitrm(data, 'B0-B40 ~ Group', 'WithinDesign', withinDesign);

% Run ANOVA for within-subjects effects and interaction
anovaTable = ranova(rm, 'WithinModel', 'Damping');

% Run ANOVA for between-subjects effect (Group)
betweenTable = anova(rm);

% Extract F-statistics and p-values
F_damping = anovaTable.F(1); % Damping main effect
p_damping = anovaTable.pValue(1);
F_interaction = anovaTable.F(2); % Damping*Group interaction
p_interaction = anovaTable.pValue(2);
F_group = betweenTable.F(1); % Group main effect
p_group = betweenTable.pValue(1);

% Display ANOVA results
disp('Two-way mixed ANOVA results:')
disp(['Damping main effect: F = ', num2str(F_damping), ', p = ', num2str(p_damping)])
disp(['Group main effect: F = ', num2str(F_group), ', p = ', num2str(p_group)])
disp(['Damping*Group interaction: F = ', num2str(F_interaction), ', p = ', num2str(p_interaction)])

% Post-hoc tests for significant effects (Bonferroni-corrected)
posthoc_p = [];
if p_damping < 0.05 || p_interaction < 0.05 || p_group < 0.05
    % Compare groups at each damping level
    mc = multcompare(rm, 'Group', 'By', 'Damping', 'ComparisonType', 'bonferroni');
    posthoc_p = mc.pValue; % P-values for H vs. P at B0, B20, B40
    disp('Post-hoc comparisons (Bonferroni-corrected):')
    disp(mc)
end

% Update Table1 for V_FI (row 7)
% Store post-hoc p-values for H vs. P at each damping level
Table1(8, :) = posthoc_p([1 3 5])' % Transpose to 1x3 for B0, B20, B40

%%


% Display purpose
disp('Two-way mixed ANOVA for parameter F_Mperp: Damping (B0, B20, B40) and Group (H, P)')

% Prepare data in long format for repeated-measures ANOVA
% Assume diff_FD_FL.damping(i).target.areaH/P are arrays of participant scores
nH = length([sum_FD_FL.damping(1).target.perpH]);
nP = length([sum_FD_FL.damping(1).target.perpP]);
nTotal = nH + nP; % Total participants (n=38)

% Create table: participant ID, group, V_FI scores for each damping level
data = table(...
    (1:nTotal)', ... % Participant ID
    [repmat({'H'}, nH, 1); repmat({'P'}, nP, 1)], ... % Group (H or P)
    [[sum_FD_FL.damping(1).target.perpH]'; [sum_FD_FL.damping(1).target.perpP]'], ... % B0
    [[sum_FD_FL.damping(2).target.perpH]'; [sum_FD_FL.damping(2).target.perpP]'], ... % B20
    [[sum_FD_FL.damping(3).target.perpH]'; [sum_FD_FL.damping(3).target.perpP]'], ... % B40
    'VariableNames', {'ID', 'Group', 'B0', 'B20', 'B40'});

% Define within-subjects factor (Damping)
withinDesign = table([1; 2; 3], 'VariableNames', {'Damping'});
withinDesign.Damping = categorical(withinDesign.Damping);

% Fit repeated-measures model
rm = fitrm(data, 'B0-B40 ~ Group', 'WithinDesign', withinDesign);

% Run ANOVA for within-subjects effects and interaction
anovaTable = ranova(rm, 'WithinModel', 'Damping');

% Run ANOVA for between-subjects effect (Group)
betweenTable = anova(rm);

% Extract F-statistics and p-values
F_damping = anovaTable.F(1); % Damping main effect
p_damping = anovaTable.pValue(1);
F_interaction = anovaTable.F(2); % Damping*Group interaction
p_interaction = anovaTable.pValue(2);
F_group = betweenTable.F(1); % Group main effect
p_group = betweenTable.pValue(1);

% Display ANOVA results
disp('Two-way mixed ANOVA results:')
disp(['Damping main effect: F = ', num2str(F_damping), ', p = ', num2str(p_damping)])
disp(['Group main effect: F = ', num2str(F_group), ', p = ', num2str(p_group)])
disp(['Damping*Group interaction: F = ', num2str(F_interaction), ', p = ', num2str(p_interaction)])

% Post-hoc tests for significant effects (Bonferroni-corrected)
posthoc_p = [];
if p_damping < 0.05 || p_interaction < 0.05 || p_group < 0.05
    % Compare groups at each damping level
    mc = multcompare(rm, 'Group', 'By', 'Damping', 'ComparisonType', 'bonferroni');
    posthoc_p = mc.pValue; % P-values for H vs. P at B0, B20, B40
    disp('Post-hoc comparisons (Bonferroni-corrected):')
    disp(mc)
end

% Update Table1 for V_FI (row 7)
% Store post-hoc p-values for H vs. P at each damping level
Table1(9, :) = posthoc_p([1 3 5])' % Transpose to 1x3 for B0, B20, B40

%%

% Figure 6c
figure
boxplot([[sum_FD_FL.damping(1).target.areaH]', [sum_FD_FL.damping(1).target.areaP]', [sum_FD_FL.damping(2).target.areaH]', [sum_FD_FL.damping(2).target.areaP]', [sum_FD_FL.damping(3).target.areaH]', [sum_FD_FL.damping(3).target.areaP]'])
A = axis;
y_text = (A(4)-A(3))*0.1+A(4);
A(4) = (A(4)-A(3))*0.2+A(4);
text(1.5, y_text, 'D0', 'HorizontalAlignment', 'center')
text(3.5, y_text, 'D20', 'HorizontalAlignment', 'center')
text(5.5, y_text, 'D40', 'HorizontalAlignment', 'center')
axis(A)
hold on
plot([2.5 2.5], [A(3), A(4)],'k--')
plot([4.5 4.5], [A(3), A(4)],'k--')
xticks([1 2 3 4 5 6])
xticklabels({'H','P','H','P','H','P'})
title('area sum')

% Figure 8a
figure
boxplot([[sum_FD_FL.damping(1).target.directH]', [sum_FD_FL.damping(1).target.directP]', [sum_FD_FL.damping(2).target.directH]', [sum_FD_FL.damping(2).target.directP]', [sum_FD_FL.damping(3).target.directH]', [sum_FD_FL.damping(3).target.directP]'])
A = axis;
y_text = (A(4)-A(3))*0.00+A(4);
A(4) = (A(4)-A(3))*0.05+A(4);
text(1.5, y_text, 'D0', 'HorizontalAlignment', 'center')
text(3.5, y_text, 'D20', 'HorizontalAlignment', 'center')
text(5.5, y_text, 'D40', 'HorizontalAlignment', 'center')
axis(A)
hold on
plot([2.5 2.5], [A(3), A(4)],'k--')
plot([4.5 4.5], [A(3), A(4)],'k--')
xticks([1 2 3 4 5 6])
xticklabels({'H','P','H','P','H','P'})
title('dir sumF')

% Figure 8b
figure
boxplot([[sum_FD_FL.damping(1).target.perpH]', [sum_FD_FL.damping(1).target.perpP]', [sum_FD_FL.damping(2).target.perpH]', [sum_FD_FL.damping(2).target.perpP]', [sum_FD_FL.damping(3).target.perpH]', [sum_FD_FL.damping(3).target.perpP]'])
A = axis;
y_text = (A(4)-A(3))*0.00+A(4);
A(4) = (A(4)-A(3))*0.05+A(4);
text(1.5, y_text, 'D0', 'HorizontalAlignment', 'center')
text(3.5, y_text, 'D20', 'HorizontalAlignment', 'center')
text(5.5, y_text, 'D40', 'HorizontalAlignment', 'center')
axis(A)
hold on
plot([2.5 2.5], [A(3), A(4)],'k--')
plot([4.5 4.5], [A(3), A(4)],'k--')
xticks([1 2 3 4 5 6])
xticklabels({'H','P','H','P','H','P'})
title('pepr sumF')

%% Table 2

disp('p-values for P between dampings for parameter V_FM')
pDamp = zeros(1,3);

groupOneScores = [sum_FD_FL.damping(1).target.areaP]';
groupTwoScores = [sum_FD_FL.damping(2).target.areaP]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [sum_FD_FL.damping(1).target.areaP]';
groupTwoScores = [sum_FD_FL.damping(3).target.areaP]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [sum_FD_FL.damping(2).target.areaP]';
groupTwoScores = [sum_FD_FL.damping(3).target.areaP]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(14,:) = pDamp(:)';

disp('p-values for H between dampings for parameter V_FM')
pDamp = zeros(1,3);

groupOneScores = [sum_FD_FL.damping(1).target.areaH]';
groupTwoScores = [sum_FD_FL.damping(2).target.areaH]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [sum_FD_FL.damping(1).target.areaH]';
groupTwoScores = [sum_FD_FL.damping(3).target.areaH]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [sum_FD_FL.damping(2).target.areaH]';
groupTwoScores = [sum_FD_FL.damping(3).target.areaH]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(13,:) = pDamp(:)';

disp('p-values for H between dampings for parameter F_Mpar')
pDamp = zeros(1,3);

groupOneScores = [sum_FD_FL.damping(1).target.directH]';
groupTwoScores = [sum_FD_FL.damping(2).target.directH]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [sum_FD_FL.damping(1).target.directH]';
groupTwoScores = [sum_FD_FL.damping(3).target.directH]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [sum_FD_FL.damping(2).target.directH]';
groupTwoScores = [sum_FD_FL.damping(3).target.directH]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(17,:) = pDamp(:)';

disp('p-values for P between dampings for parameter F_Mpar')
pDamp = zeros(1,3);

groupOneScores = [sum_FD_FL.damping(1).target.directP]';
groupTwoScores = [sum_FD_FL.damping(2).target.directP]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [sum_FD_FL.damping(1).target.directP]';
groupTwoScores = [sum_FD_FL.damping(3).target.directP]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [sum_FD_FL.damping(2).target.directP]';
groupTwoScores = [sum_FD_FL.damping(3).target.directP]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(18,:) = pDamp(:)';

disp('p-values for H between dampings for F_Mperp')
pDamp = zeros(1,3);

groupOneScores = [sum_FD_FL.damping(1).target.perpH]';
groupTwoScores = [sum_FD_FL.damping(2).target.perpH]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [sum_FD_FL.damping(1).target.perpH]';
groupTwoScores = [sum_FD_FL.damping(3).target.perpH]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [sum_FD_FL.damping(2).target.perpH]';
groupTwoScores = [sum_FD_FL.damping(3).target.perpH]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])


Table2(19,:) = pDamp(:)';

disp('p-values for P between dampings for F_Mperp')
pDamp = zeros(1,3);

groupOneScores = [sum_FD_FL.damping(1).target.perpP]';
groupTwoScores = [sum_FD_FL.damping(2).target.perpP]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [sum_FD_FL.damping(1).target.perpP]';
groupTwoScores = [sum_FD_FL.damping(3).target.perpP]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [sum_FD_FL.damping(2).target.perpP]';
groupTwoScores = [sum_FD_FL.damping(3).target.perpP]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])


Table2(20,:) = pDamp(:)';

%%

num_points = 200;
half_points = round(num_points/2);
qs = round(num_points/5);
qe = round(4*num_points/5);

pp = [];

main_title = 'Fl-Fd';

for damping_no = 1:3

    %figure

    for target_no = 1:16

        %subplot(4,4,target_no)
        figure
        title(target_no)
        hold on
        axis equal
        %axis([-25 25 -25 25])
        %axis([-50 50 -50 50])
        axis([-30 30 -30 30])
        xlabel('y')
        ylabel('z')  

        dir_vec = [1 0];

        interp_xH = zeros(num_points, length(Sub_H)*3);
        interp_yH = zeros(num_points, length(Sub_H)*3);
        DirectH = zeros(1, length(Sub_H)*3);
        PerpH = zeros(1, length(Sub_H)*3);
        dirRatioH = zeros(1, length(Sub_H)*3);        
        idx = 1;

        for subject_no = Sub_H;
            for repetition_no = 1:length(haptic_data(subject_no).damping(damping_no).min_index_table)

                Fd = grip_force_data(subject_no).damping(damping_no).Fd_local(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,1):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,2),:);
                Fl = grip_force_data(subject_no).damping(damping_no).Fl_local(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,1):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,2),:);

                force = (Fl-Fd)/2;

                %plot(force(:,1), force(:,2), 'b')

                interp_xH(:,idx) = interp1(1:length(force(:,1)), force(:,1), linspace(1, length(force(:,1)), num_points));
                interp_yH(:,idx) = interp1(1:length(force(:,2)), force(:,2), linspace(1, length(force(:,2)), num_points));
                
                interrp_xy = [interp_xH(:,idx), interp_yH(:,idx)];
                [directH, perpH, neg_dirH] = projectionOnTargetDirection(interrp_xy, repmat(dir_vec,size(interrp_xy,1),1));
                DirectH(idx) = directH;
                PerpH(idx) = perpH;
                dirRatioH(idx) = perpH/directH;                
                
                idx = idx + 1;
            end
        end

        interp_xP = zeros(num_points, length(Sub_P)*3);
        interp_yP = zeros(num_points, length(Sub_P)*3);
        DirectP = zeros(1, length(Sub_P)*3);
        PerpP = zeros(1, length(Sub_P)*3);
        dirRatioP = zeros(1, length(Sub_P)*3);            
        idx = 1;

        for subject_no = Sub_P;
            for repetition_no = 1:length(haptic_data(subject_no).damping(damping_no).min_index_table)
                Fd = grip_force_data(subject_no).damping(damping_no).Fd_local(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,1):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,2),:);
                Fl = grip_force_data(subject_no).damping(damping_no).Fl_local(haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,1):haptic_data(subject_no).damping(damping_no).min_index_table(repetition_no).StartEnd_idx(target_no,2),:);

                force = (Fl-Fd)/2;

                %plot(force(:,1), force(:,2), 'r')

                interp_xP(:,idx) = interp1(1:length(force(:,1)), force(:,1), linspace(1, length(force(:,1)), num_points));
                interp_yP(:,idx) = interp1(1:length(force(:,2)), force(:,2), linspace(1, length(force(:,2)), num_points));
                interrp_xy = [interp_xP(:,idx), interp_yP(:,idx)];
                [directP, perpP, neg_dirP] = projectionOnTargetDirection(interrp_xy, repmat(dir_vec,size(interrp_xy,1),1));
                DirectP(idx) = directP;
                PerpP(idx) = perpP;
                dirRatioP(idx) = perpP/directP;                 

                idx = idx + 1;
            end
        end

        [Area2, xP, yP] = plotConvHull(interp_xP, interp_yP, range/100, 'PR');
        [Area1, xH, yH] = plotConvHull(interp_xH, interp_yH, range/100, 'H');
        
        poly1 = polyshape(xH, yH);
        poly2 = polyshape(xP, yP);
        [directP, perpP, neg_dirP] = projectionOnTargetDirection(force, repmat(dir_vec,size(force,1),1));

        title(num2str(target_no))
        xticks([-50 -25 0 25 50])
        yticks([-50 -25 0 25 50])
        set(gcf,'units','centimeters','position',[0,0,10,10]); 
        set(gca,'FontSize',10,'FontName','Times');
        %print(['D', num2str(damping_no), '_', num2str(target_no)],'-depsc2', '-vector'); 

        diff_FD_FL.damping(damping_no).target(target_no).areaH = poly1.area;
        diff_FD_FL.damping(damping_no).target(target_no).areaP = poly2.area;
        diff_FD_FL.damping(damping_no).target(target_no).directH = median(DirectH);
        diff_FD_FL.damping(damping_no).target(target_no).perpH = median(PerpH);
        diff_FD_FL.damping(damping_no).target(target_no).directP = median(DirectP);
        diff_FD_FL.damping(damping_no).target(target_no).perpP = median(PerpP);

    end

    close all

    %print(gcf,[main_title, '_d',num2str(damping_no)],'-dpdf','-fillpage')

end


%%

% Figure 8c
figure
boxplot([[diff_FD_FL.damping(1).target.directH]', [diff_FD_FL.damping(1).target.directP]', [diff_FD_FL.damping(2).target.directH]', [diff_FD_FL.damping(2).target.directP]', [diff_FD_FL.damping(3).target.directH]', [diff_FD_FL.damping(3).target.directP]'])
A = axis;
A(4) = 9;
y_text = (A(4)-A(3))*0.00+A(4);
A(4) = (A(4)-A(3))*0.05+A(4);
text(1.5, y_text, 'D0', 'HorizontalAlignment', 'center')
text(3.5, y_text, 'D20', 'HorizontalAlignment', 'center')
text(5.5, y_text, 'D40', 'HorizontalAlignment', 'center')
axis(A)
hold on
plot([2.5 2.5], [A(3), A(4)],'k--')
plot([4.5 4.5], [A(3), A(4)],'k--')
xticks([1 2 3 4 5 6])
xticklabels({'H','P','H','P','H','P'})
title('internal compr')

%%

%Figure 8d
figure
boxplot([[diff_FD_FL.damping(1).target.perpH]', [diff_FD_FL.damping(1).target.perpP]', [diff_FD_FL.damping(2).target.perpH]', [diff_FD_FL.damping(2).target.perpP]', [diff_FD_FL.damping(3).target.perpH]', [diff_FD_FL.damping(3).target.perpP]'])
A = axis;
A(4) = 4;
y_text = (A(4)-A(3))*0.00+A(4);
A(4) = (A(4)-A(3))*0.05+A(4);
text(1.5, y_text, 'D0', 'HorizontalAlignment', 'center')
text(3.5, y_text, 'D20', 'HorizontalAlignment', 'center')
text(5.5, y_text, 'D40', 'HorizontalAlignment', 'center')
axis(A)
hold on
plot([2.5 2.5], [A(3), A(4)],'k--')
plot([4.5 4.5], [A(3), A(4)],'k--')
xticks([1 2 3 4 5 6])
xticklabels({'H','P','H','P','H','P'})
title('internal rot')


%%

% Figure 6d
figure
boxplot([[diff_FD_FL.damping(1).target.areaH]', [diff_FD_FL.damping(1).target.areaP]', [diff_FD_FL.damping(2).target.areaH]', [diff_FD_FL.damping(2).target.areaP]', [diff_FD_FL.damping(3).target.areaH]', [diff_FD_FL.damping(3).target.areaP]'])
A = axis;
y_text = (A(4)-A(3))*0.1+A(4);
A(4) = (A(4)-A(3))*0.2+A(4);
text(1.5, y_text, 'D0', 'HorizontalAlignment', 'center')
text(3.5, y_text, 'D20', 'HorizontalAlignment', 'center')
text(5.5, y_text, 'D40', 'HorizontalAlignment', 'center')
axis(A)
hold on
plot([2.5 2.5], [A(3), A(4)],'k--')
plot([4.5 4.5], [A(3), A(4)],'k--')
xticks([1 2 3 4 5 6])
xticklabels({'H','P','H','P','H','P'})
title('area diff')

%%

% Display purpose
disp('Two-way mixed ANOVA for parameter V_FI: Damping (B0, B20, B40) and Group (H, P)')

% Prepare data in long format for repeated-measures ANOVA
% Assume diff_FD_FL.damping(i).target.areaH/P are arrays of participant scores
nH = length([diff_FD_FL.damping(1).target.areaH]);
nP = length([diff_FD_FL.damping(1).target.areaP]);
nTotal = nH + nP; % Total participants (n=38)

% Create table: participant ID, group, V_FI scores for each damping level
data = table(...
    (1:nTotal)', ... % Participant ID
    [repmat({'H'}, nH, 1); repmat({'P'}, nP, 1)], ... % Group (H or P)
    [[diff_FD_FL.damping(1).target.areaH]'; [diff_FD_FL.damping(1).target.areaP]'], ... % B0
    [[diff_FD_FL.damping(2).target.areaH]'; [diff_FD_FL.damping(2).target.areaP]'], ... % B20
    [[diff_FD_FL.damping(3).target.areaH]'; [diff_FD_FL.damping(3).target.areaP]'], ... % B40
    'VariableNames', {'ID', 'Group', 'B0', 'B20', 'B40'});

% Define within-subjects factor (Damping)
withinDesign = table([1; 2; 3], 'VariableNames', {'Damping'});
withinDesign.Damping = categorical(withinDesign.Damping);

% Fit repeated-measures model
rm = fitrm(data, 'B0-B40 ~ Group', 'WithinDesign', withinDesign);

% Run ANOVA for within-subjects effects and interaction
anovaTable = ranova(rm, 'WithinModel', 'Damping');

% Run ANOVA for between-subjects effect (Group)
betweenTable = anova(rm);

% Extract F-statistics and p-values
F_damping = anovaTable.F(1); % Damping main effect
p_damping = anovaTable.pValue(1);
F_interaction = anovaTable.F(2); % Damping*Group interaction
p_interaction = anovaTable.pValue(2);
F_group = betweenTable.F(1); % Group main effect
p_group = betweenTable.pValue(1);

% Display ANOVA results
disp('Two-way mixed ANOVA results:')
disp(['Damping main effect: F = ', num2str(F_damping), ', p = ', num2str(p_damping)])
disp(['Group main effect: F = ', num2str(F_group), ', p = ', num2str(p_group)])
disp(['Damping*Group interaction: F = ', num2str(F_interaction), ', p = ', num2str(p_interaction)])

% Post-hoc tests for significant effects (Bonferroni-corrected)
posthoc_p = [];
if p_damping < 0.05 || p_interaction < 0.05 || p_group < 0.05
    % Compare groups at each damping level
    mc = multcompare(rm, 'Group', 'By', 'Damping', 'ComparisonType', 'bonferroni');
    posthoc_p = mc.pValue; % P-values for H vs. P at B0, B20, B40
    disp('Post-hoc comparisons (Bonferroni-corrected):')
    disp(mc)
end

% Update Table1 for V_FI (row 7)
% Store post-hoc p-values for H vs. P at each damping level
Table1(7, :) = posthoc_p([1 3 5])'; % Transpose to 1x3 for B0, B20, B40

%% Tabel 2

% Parameter V_FI
disp('p-values for P between dampings for Parameter V_FI')
pDamp = zeros(1,3);

groupOneScores = [diff_FD_FL.damping(1).target.areaP]';
groupTwoScores = [diff_FD_FL.damping(2).target.areaP]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [diff_FD_FL.damping(1).target.areaP]';
groupTwoScores = [diff_FD_FL.damping(3).target.areaP]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [diff_FD_FL.damping(2).target.areaP]';
groupTwoScores = [diff_FD_FL.damping(3).target.areaP]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])


Table2(16,:) = pDamp(:)';

disp('p-values for H between dampings for Parameter V_FI')
pDamp = zeros(1,3);

groupOneScores = [diff_FD_FL.damping(1).target.areaH]';
groupTwoScores = [diff_FD_FL.damping(2).target.areaH]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [diff_FD_FL.damping(1).target.areaH]';
groupTwoScores = [diff_FD_FL.damping(3).target.areaH]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [diff_FD_FL.damping(2).target.areaH]';
groupTwoScores = [diff_FD_FL.damping(3).target.areaH]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(15,:) = pDamp(:)';

disp('p-values for H between dampings for Parameter F_IC ')
pDamp = zeros(1,3);

groupOneScores = [diff_FD_FL.damping(1).target.directH]';
groupTwoScores = [diff_FD_FL.damping(2).target.directH]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [diff_FD_FL.damping(1).target.directH]';
groupTwoScores = [diff_FD_FL.damping(3).target.directH]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [diff_FD_FL.damping(2).target.directH]';
groupTwoScores = [diff_FD_FL.damping(3).target.directH]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(11,:) = pDamp(:)';

disp('p-values for P between dampings for Parameter F_IC')
pDamp = zeros(1,3);

groupOneScores = [diff_FD_FL.damping(1).target.directP]';
groupTwoScores = [diff_FD_FL.damping(2).target.directP]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [diff_FD_FL.damping(1).target.directP]';
groupTwoScores = [diff_FD_FL.damping(3).target.directP]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [diff_FD_FL.damping(2).target.directP]';
groupTwoScores = [diff_FD_FL.damping(3).target.directP]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(12,:) = pDamp(:)';

disp('p-values for H between dampings for Parameter F_IR')
pDamp = zeros(1,3);

groupOneScores = [diff_FD_FL.damping(1).target.perpH]';
groupTwoScores = [diff_FD_FL.damping(2).target.perpH]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [diff_FD_FL.damping(1).target.perpH]';
groupTwoScores = [diff_FD_FL.damping(3).target.perpH]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [diff_FD_FL.damping(2).target.perpH]';
groupTwoScores = [diff_FD_FL.damping(3).target.perpH]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(23,:) = pDamp(:)';

disp('p-values for P between dampings for Parameter F_IR')
pDamp = zeros(1,3);

groupOneScores = [diff_FD_FL.damping(1).target.perpP]';
groupTwoScores = [diff_FD_FL.damping(2).target.perpP]';
pDamp(1) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [diff_FD_FL.damping(1).target.perpP]';
groupTwoScores = [diff_FD_FL.damping(3).target.perpP]';
pDamp(2) = anova1([groupOneScores, groupTwoScores]);

groupOneScores = [diff_FD_FL.damping(2).target.perpP]';
groupTwoScores = [diff_FD_FL.damping(3).target.perpP]';
pDamp(3) = anova1([groupOneScores, groupTwoScores])

Table2(24,:) = pDamp(:)';

%%

close all

fprintf('\nTable 1\n');
rowNames = {'V_T','V_v','v_par','v_perp','V_Nperp','V_FM','V_FI','F_Mpar','F_Mperp'};
varNames = {'B0','B20','B40'};
tbl1 = array2table(Table1, 'RowNames', rowNames, 'VariableNames', varNames);
colorizeTable(tbl1)

fprintf('\nTable 2\n');
varNames = {'p_B0B20','p_B0B40','p_B20B40'};
rowNames = {'V_T:H','V_T:P','V_v:H','V_v:P','v_par H',' v_par P','v_perp H','v_perp P','V_Nperp H','V_Nperp P','FIC H','FIC P','V_FM H','V_FM P','V_FI H','V_FI P','F_Mpar H','F_Mpar P','F_Mperp H','F_Mperp P','HNAN','PNAN','FIR H','FIR P'};
tbl2 = array2table(Table2, 'RowNames', rowNames, 'VariableNames', varNames);
colorizeTable(tbl2)