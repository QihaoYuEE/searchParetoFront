function Result = isDominated(ArrayA,ArrayB,Logic)
% If ArrayA is completely the same with ArrayB, it is not dominated
if isequal(ArrayA,ArrayB)
    Result  = 0;
    return
end

for iFun = 1:length(ArrayA)
    Diff        = ArrayA(iFun) - ArrayB(iFun);
    LogicDiff   = Diff >= 0;
    ResultTemp  = LogicDiff == Logic(iFun);
    if ResultTemp == 0
        Result  = 0;
        return
    end
end

Result = 1;

end