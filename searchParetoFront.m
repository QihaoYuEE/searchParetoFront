
%%
function ParetoFront = searchParetoFront(Data)
%% Initialize the dataset
PopSize = zeros(1,length(Data.Var));
for iVar = 1:length(Data.Var)
    PopSize(iVar) = length(Data.Var(iVar).Value);
end
nFun = length(Data.Fun);
nValue = prod(PopSize);
Fun1D = zeros(nValue,nFun);
for iFun = 1:nFun
    Fun1D(:,iFun) = Data.Fun(iFun).Value(:);
end
% Find the goal of the optimization, Max=1, Min=0
GoalsLogic = strcmpi([Data.Fun(:).Goal], "Max");

%% Select the initial datasets which contains Pareto front
% Start from the first, helping reduce the size of the initial datasets
% Here the time complexity is O(N)
if GoalsLogic(1) == 0
    [~,iTemp] = min(Fun1D(:,1));
elseif GoalsLogic(1) == 1
    [~,iTemp] = max(Fun1D(:,1));
end

iInitFront = 1;
InitFront = struct();         % This initialize the struct but not preallocation
for iValue = 1:nValue
    % The selected Value substract the temporary best value.
    % ~GoalsLogic gives
    if ~isDominated(Fun1D(iTemp,:),Fun1D(iValue,:),GoalsLogic)
        InitFront(iInitFront).Value = Fun1D(iValue,:);
        InitFront(iInitFront).Index = iValue;
        InitFront(iInitFront).Valid = 1;
        iInitFront = iInitFront + 1;
    else
    end
end

%% Refine the initial datasets which contain fake data
% First compare each data to every others and set the fake data invalid
% Here the time complexity is O(N^2)
for iInitFront = 1:length(InitFront)
    iTemp = iInitFront;
    for jInitFront = 1:length(InitFront)
        if isDominated(InitFront(iTemp).Value,InitFront(jInitFront).Value,GoalsLogic)
%         if isequal( (InitFront(jInitFront).Value - InitFront(iTemp).Value > 0), ~GoalsLogic )...
%                 && jInitFront ~= iTemp
            InitFront(jInitFront).Valid = 0;
        else
        end
    end
end

% Grab the valid data and make the final front
% Here the time complexity is O(N)
iFinalFront = 1;
FinalFront = struct();
for iInitFront = 1:length(InitFront)
    if InitFront(iInitFront).Valid == 1
        FinalFront(iFinalFront).Value = InitFront(iInitFront).Value;
        FinalFront(iFinalFront).Index = InitFront(iInitFront).Index;
        iFinalFront = iFinalFront + 1;
    else
    end
end

%% Sort the Pareto front by the function order
OutTemp = struct();
IndexArray = cat(1,FinalFront(:).Index);
ValueMatrix = cat(1,FinalFront(:).Value);
[MatrixSort,IndexSortTemp] = sortrows(ValueMatrix);
IndexSort   = IndexArray(IndexSortTemp);
for iFun = 1:nFun
    OutTemp.Fun(iFun).Value = MatrixSort(:,iFun);
    OutTemp.Fun(iFun).Name = Data.Fun(iFun).Name;
    OutTemp.Fun(iFun).Goal = Data.Fun(iFun).Goal;
end
OutTemp.IndexArray = IndexSort;

% Convert 1D indeces to subscripts
nVar = length(Data.Var);
CellTemp = cell(1,nVar);
[CellTemp{:}] = ind2sub(PopSize,IndexSort);
OutTemp.Subscript = cell2mat(CellTemp);

% Assign the variable Value to the output
for iVar = 1:nVar
    VarTemp = Data.Var(iVar).Value;
    OutTemp.Var(iVar).Value = VarTemp(OutTemp.Subscript(:,iVar));
    OutTemp.Var(iVar).Name = Data.Var(iVar).Name;
end

%% Return the result
ParetoFront = OutTemp;
end


%% Check the ArrayA is dominated than ArrayB or not
% A = [100,100];
% B = cat(1,[90,90],[90,100],[90,110],[100,90],[100,100],[100,110],[110,90],[110,100],[110,110]);
% Logic = [1,1];
% 
% Size = size(B);
% for Index = 1:Size(1)
%     Result(Index) = isDominated(A,B(Index,:),Logic);
% end
% 
% Result

function Result = isDominated(ArrayA,ArrayB,Logic)
% If ArrayA is completely the same with ArrayB, it is not dominated
if isequal(ArrayA,ArrayB)
    Result  = 0;
    return
end

Diff        = ArrayA - ArrayB;
for Index   = 1:length(ArrayA)
    if Diff(Index)>0 && Logic(Index) == 0
        Result = 0;
        return
    elseif Diff(Index)<0 && Logic(Index) == 1
        Result = 0;
        return
    end
end

Result = 1;

end
