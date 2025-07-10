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
