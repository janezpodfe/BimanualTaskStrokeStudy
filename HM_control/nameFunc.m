
[m,n]=size(data);
LastName = {'Time';'wPosX';'wPosZ';'wPosY';'qsmall';'qbig';'FrawL';'TrawL';'FrawR';'TrawR';'Fbal';'F';'Time';'wPosX';'wPosZ';'wPosY';'qsmall';'qbig';'FrawL';'TrawL';'FrawR';'TrawR';'Fbal';'F';'TrawR';'Fbal';'F',n};
x = [LastName,data];

%C = {zeros(3); [1 0 1; 0 0 0; 1 0 1]};
%X = [1 1 0; 0 1 0]; %current matrix
%X = cell2mat(C(X+1)) %new matrix
% C1 = {1; 2; 3};
% C2 = {'A'; 'B'; 'C'};
% C3 = {10; 20; 30};
% C4 = [C1, C2, C3]