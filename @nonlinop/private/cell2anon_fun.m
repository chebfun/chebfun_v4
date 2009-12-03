function bcArg = cell2anon_fun(bcArg)
% CELL2ANON_FUN Converts cell that could include doubles to a cell that
% only includes anonymous functions.

% Find the position of doubles
doublesPos = find(cellfun('isclass',bcArg,'double'));

% Convert every double to an anonymous function
for dCounter = 1:length(doublesPos)
    val = bcArg{doublesPos(dCounter)};
    bcArg{doublesPos(dCounter)} = @(u) u-val;
end
end