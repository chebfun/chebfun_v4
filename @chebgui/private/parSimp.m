function sOut = parSimp(guifile,str)

sOut = str;

% Store length of the string
strLen = length(str);

% Find all locations of ( and )
leftParLoc = strfind(str,'(');
rightParLoc = strfind(str,')');
plusMinVec =  (str == '+') + (str == '-');
timDivVec  =  2*((str == '*') + (str == '/'));
powerVec = 3*(str == '^');
allOpVec = plusMinVec + timDivVec + powerVec;
allOpVec(allOpVec == 0) = inf;

allOpLoc = regexp(str,'[\+\-\*\/\^]');
allCharNumLoc = regexp(str,'[A-Za-z0-9]'); % Vantar ad finna tolur lika

% Error if the number of ( and ) are not equal
if length(leftParLoc) ~= length(rightParLoc)
    error('chebgui:parenth_simplify:Incorrect number of parenthesis.');
end

% Store number of parenthesis
numOfPars = length(leftParLoc);

% Pair them together
pairs = zeros(numOfPars,2);
parCounter = 1;

leftStack = [];
for strIndex = 1:length(str)
    if str(strIndex) == '(' % Push to the stack
        leftStack = [leftStack strIndex];
    elseif str(strIndex) == ')' % Pop from the stack
        % Write information to pairs
        pairs(parCounter,1) = leftStack(end);
        pairs(parCounter,2) = strIndex;
        
        % Update stack and counter
        leftStack(end) = [];
        parCounter = parCounter + 1;
    end
end

leftPars = pairs(:,1);
rightPars = pairs(:,2);
for pIndex = 1:numOfPars
    pLeft = leftPars(pIndex);
    pRight = rightPars(pIndex);
    minOpInside = min(allOpVec(pLeft:pRight));
    nextLeftOp = max(allOpLoc(allOpLoc < pLeft));
    nextRightOp = min(allOpLoc(allOpLoc > pRight));
    
    % If the character in str next to the left of the left parenthesis is a
    % letter or a number (e.g. from sin or log2), we have a function from
    % which we can not remove the () pair. If not, we perform a check to
    % see whether we can remove them.
    if any(allCharNumLoc == pLeft-1)
        % Do nothing
    elseif (isempty(nextLeftOp) || minOpInside >= allOpVec(nextLeftOp)) && ... 
        (isempty(nextRightOp) || minOpInside >= allOpVec(nextRightOp))
        
        % Remove parenthesis pair
        sOut(pLeft) = [];
        sOut(pRight-1) = [];
        
        % Need to update indices and operators
        allOpVec(pLeft) = [];
        allOpVec(pRight-1) = [];
        leftPars = leftPars - (leftPars > pLeft) - (leftPars > pRight);
        rightPars = rightPars - (rightPars > pLeft) - (rightPars > pRight);        
        allOpLoc = allOpLoc - (allOpLoc > pLeft) - (allOpLoc > pRight);
        allCharNumLoc = allCharNumLoc - (allCharNumLoc > pLeft) - (allCharNumLoc > pRight);
    end
end