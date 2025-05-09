
function [Area, xC, yC]=Contour2Area(C)
% % Syntax: [Area,Centroid,IN]=Contour2Area(C)
% % Takes the contour argument C from matlabs function contourc
% % as produced by C=contour(x,y,z,...) and convert the contours
% % to closed polygons from where the areas are calculated. 
% % In addition the centroids (centre of mass) Cxy are calculated
% % and a matrix IN determining the parent/child relationship
% % between the contours (if polygon i is inside j then IN_ij=1, else=0).
% % For obscure contours NaN would be retrived, but are excluded in output.
% %
% % Created By: Per Sundqvist 2010-01-26, ABB/CRC, V�ster�s/Sweden.
%
% %--- Example ---
% [X,Y,Z] = PEAKS(50);
% figure(1), clf;
% %C=contourf(X,Y,Z,0.37+[0 0]);
% C=contourf(X,Y,Z,5);
% [Area,Centroid,IN]=Contour2Area(C);
% xc=Centroid(1,:);yc=Centroid(2,:);
% hold on;plot(xc,yc,'k*');
% Area
% IN
%--- find number of contours ---
nC=length(C);
cc=1;j=1;
while cc<nC
    ix(j)=C(2,cc);
    cvec_start(j)=cc+1;
    cc=cc+ix(j)+1;
    j=j+1;
end
%--- find areas Ac and centroid Cxy (special if contour goes outside) ---
for j=1:length(ix)
    xC=C(1,cvec_start(j):cvec_start(j)+ix(j)-1);
    yC=C(2,cvec_start(j):cvec_start(j)+ix(j)-1);
    if ~isempty(find(isnan(xC)))
        if length(xC)>1
            xC(find(isnan(xC)))=(xC(find(isnan(xC))-1)+xC(find(isnan(xC))+1))/2;
            yC(find(isnan(yC)))=(yC(find(isnan(yC))-1)+yC(find(isnan(yC))+1))/2;
        end
    end
    if length(xC)>1
        Ac(j)=polyarea(xC,yC);  % area
        nan0(j)=0;
    else
        Ac(j)=NaN;
        nan0(j)=1;
    end
end
%--- Remove NaN contours ---
nanix=find(nan0~=1);
[m,j] = max(Ac);
xC=C(1,cvec_start(j):cvec_start(j)+ix(j)-1);
yC=C(2,cvec_start(j):cvec_start(j)+ix(j)-1);
Area=Ac(nanix);

