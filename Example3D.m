%%
clear variables
close all
clc
%% Init Data
Data.Var(1).Name = "x1";
Data.Var(1).Value = 1:0.1:2;
Data.Var(2).Name = "x2";
Data.Var(2).Value = 0:0.5:2;
Data.Var(3).Name = "x3";
Data.Var(3).Value = 1:1:6;
PopSize = [];
for iVar = 1:length(Data.Var)
    PopSize(end+1) = length(Data.Var(iVar).Value);
end
Data.Fun(1).Name = "y1";
Data.Fun(1).Value = rand(PopSize);
Data.Fun(1).Goal = "Max";
Data.Fun(2).Name = "y2";
Data.Fun(2).Value = rand(PopSize);
Data.Fun(2).Goal = "Min";
Data.Fun(3).Name = "y3";
Data.Fun(3).Value = rand(PopSize);
Data.Fun(3).Goal = "Min";
% Data.Fun(4).Name = "y4";
% Data.Fun(4).Value = rand(PopSize);
% Data.Fun(4).Goal = "Min";

%%
ParetoFront = searchParetoFront(Data);
ParetoFrontIndex    = searchParetoFrontIndex(Data);
%%
x1 = Data.Var(1).Value(:);
x2 = Data.Var(2).Value(:);
x3 = Data.Var(3).Value(:);
[X1,X2,X3] = meshgrid(x1,x2,x3);
figure
plot3(X1(:),X2(:),X3(:),'b+')
hold on
scatter3(ParetoFront.Var(1).Value(:),ParetoFront.Var(2).Value(:),ParetoFront.Var(3).Value(:),'ro')
xlabel("x1")
ylabel("x2")
zlabel("x3")

%%
figure
scatter3(Data.Fun(1).Value(:),Data.Fun(2).Value(:),Data.Fun(3).Value(:),'b+')
hold on
scatter3(ParetoFront.Fun(1).Value(:),ParetoFront.Fun(2).Value(:),ParetoFront.Fun(3).Value(:),'ro')
xlabel("y1")
ylabel("y2")
zlabel("y3")

%%
figure
hold on
scatter3(Data.Fun(1).Value(:),Data.Fun(2).Value(:),Data.Fun(3).Value(:),'b+')
scatter3(ParetoFront.Fun(1).Value,ParetoFront.Fun(2).Value,ParetoFront.Fun(3).Value,'ro')
y1  = ParetoFront.Fun(1).Value;
y2  = ParetoFront.Fun(2).Value;
y3  = ParetoFront.Fun(3).Value;
% [y1q,y2q] = meshgrid(0:1e-2:1);
[y1q,y2q] = meshgrid(y1,y2);
y3q = griddata(y1,y2,y3,y1q,y2q);
surf(y1q,y2q,y3q)
xlabel("y1")
ylabel("y2")
zlabel("y3")

