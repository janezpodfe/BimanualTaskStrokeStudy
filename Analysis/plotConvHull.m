function [Area, xC, yC] = plotConvHull(interp_x, interp_y, p, subject)

[hist2,Xedges,Yedges] = histcounts2(interp_x(:),interp_y(:),20,'Normalization','probability','BinMethod','fd');
[s,I] = sort(hist2(:), 'descend');
D = find(cumsum(s)>p);
L = hist2(I(D(1)));

[X,Y] = meshgrid(mean([Xedges(1:end-1);Xedges(2:end)],1),...
    mean([Yedges(1:end-1);Yedges(2:end,1)],1));

if (subject == 'H') 
    [M, c] = contourf(X,Y,hist2',[L L],"ShowText","off");
    [Area, xC, yC]=Contour2Area(M);
    c.FaceColor = 'b';
    c.FaceAlpha = 0.0;
    c.LineStyle = "-"; %"none";
    c.LineWidth = 2;
    c.EdgeColor = 'b';
else
    [M, c] = contourf(X,Y,hist2',[L L],"ShowText","off");
    [Area, xC, yC]=Contour2Area(M);
    c.FaceColor = 'r';
    c.FaceAlpha = 0.3;
    c.LineStyle = "none";
end
Area = sum(Area);
