function str = parSimp(guifile,str)
% PARSIMP  Remove unnecessary parentheses from string inputs.
%  parSimp does some basic parsing of the input STR to attempt to remove
%  unnecessary parenthesis and consecutive +/- pairs.

if length(str) < 2, return, end

oldlength = 0;
while length(str) ~= oldlength
    oldlength = length(str);
    str = parSimpMain(str);
end

end

function str = parSimpMain(str)

% Find all locations of ( and )
leftParLoc = strfind(str,'(');
rightParLoc = strfind(str,')');
% Find true-false vector of operators
minusVec = str == '-';
plusVec = str == '+';
timDivVec = 2*((str == '*') + (str == '/'));
powerVec = 3*(str == '^');
opVec = plusVec + minusVec + timDivVec + powerVec;
% operator locations
opLoc = find(opVec);
opVec(opVec == 0) = inf;
% Location of characters and numbers
charLoc = regexp(str,'[A-Za-z0-9]');


% Error if the number of ( and ) are not equal
if length(leftParLoc) ~= length(rightParLoc)
    error('chebgui:parenth_simplify:Incorrect number of parenthesis.');
end

% Store number of parenthesis
numOfPars = length(leftParLoc);
% Pair them together
pairsLoc = zeros(numOfPars,2);
pairsVec = zeros(1,length(str));
parCounter = 1;
leftStack = [];
for strIndex = 1:length(str)
    if str(strIndex) == '(' % Push to the stack
        leftStack = [leftStack strIndex];
    elseif str(strIndex) == ')' % Pop from the stack
        % Write information to pairs
        pairsLoc(parCounter,1) = leftStack(end);
        pairsLoc(parCounter,2) = strIndex;
        pairsVec([leftStack(end) strIndex]) = parCounter;
        % Update stack and counter
        leftStack(end) = [];
        parCounter = parCounter + 1;
    end
end
leftParsLoc = pairsLoc(:,1);
rightParsLoc = pairsLoc(:,2);

% Loop over the pairs
for pIndex = 1:numOfPars
    pLeft = leftParsLoc(pIndex);
    pRight = rightParsLoc(pIndex);
    nextOpLeft = max(opLoc(opLoc < pLeft));
    nextOpRight = min(opLoc(opLoc > pRight));
    if nextOpLeft == 0, nextOpLeft = []; end
    if nextOpRight == 0, nextOpRight = []; end
    
    if any(charLoc == pLeft-1)
        % If the character in str next to the left of the left parenthesis is a
        % letter or a number (e.g. from sin or log2), we have a function from
        % which we cannot remove the () pair.
        continue
    end
    
    % Just mask the interior of these parentheses
    mask = zeros(1,length(str));
    mask(pLeft+1:pRight-1) = true;
    idx = find(leftParsLoc > pLeft & rightParsLoc < pRight);
    for k = 1:numel(idx)
        mask(leftParsLoc(idx(k)):rightParsLoc(idx(k))) = false;
    end
    mask = isfinite(opVec.*mask) & opVec.*mask > 0;
    interiorOpVec = opVec.*mask; 
    interiorOpVec(interiorOpVec==0 | isnan(interiorOpVec)) = inf;
    minOpInside = min(interiorOpVec(pLeft:pRight));
    
    % If not, we perform a check to see whether we can remove them.
    if (isempty(nextOpLeft) || minOpInside >= opVec(nextOpLeft)) && ...
            (isempty(nextOpRight) || minOpInside >= opVec(nextOpRight))
        
        if minOpInside == 1 && ~isempty(nextOpLeft) && strcmp(str(pLeft-1),'-')
            % Deal with the case of minus (switch interior pluses and minuses
%             continue % uncomment if we don't want to simplify -(a+b) = -a-b
            interiorPM = interiorOpVec == 1;
            interiorPM(pLeft+1) = 0;
            m = str=='-' & interiorPM;
            p = str=='+' & interiorPM;
            str(m) = '+'; str(p) = '-';
        end
        
        % Remove parenthesis pairs
        str(pLeft) = [];
        str(pRight-1) = [];

        % Update indices and operators
        opVec(pLeft) = []; opVec(pRight-1) = [];
        leftParsLoc(pIndex) = NaN;
        rightParsLoc(pIndex) = NaN;
        leftParsLoc = updateLoc(leftParsLoc,pLeft,pRight);
        rightParsLoc = updateLoc(rightParsLoc,pLeft,pRight);
        opLoc = updateLoc(opLoc,pLeft,pRight);
        charLoc = updateLoc(charLoc,pLeft,pRight);
    end
        
    % Remove leading + signs
    if strcmp(str(1),'+')
        str(1) = []; 
        opVec(1) = [];
        leftParsLoc = leftParsLoc - 1;
        rightParsLoc = rightParsLoc - 1;
        opLoc = opLoc - 1;
        charLoc = charLoc - 1;
    end
    
    % remove consecutive +/- pairs
    dOV = diff(opVec);
    dOV(isnan(dOV)) = inf;
    pm = find(~dOV,1);
    if ~isempty(pm)
        if str(pm) == str(pm+1)
            str(pm) = '+';
        else
            str(pm) = '-';
        end
        str(pm+1) = [];
        % Need to update indices and operators
        opVec(pm+1) = [];
        leftParsLoc(leftParsLoc > pm) = leftParsLoc(leftParsLoc > pm)-1;
        rightParsLoc(rightParsLoc > pm) = rightParsLoc(rightParsLoc > pm)-1;
        opLoc(opLoc > pm) = opLoc(opLoc > pm)-1;
        charLoc(charLoc > pm) = charLoc(charLoc > pm)-1;
    end
    
    % remove +0, -0, 0+, 0-
    zs = strfind(str,'0');
    for k = 1:numel(zs)
        zsk = zs(k);
        if any(zsk-1 == leftParsLoc) && opVec(zsk+1)==1
            str(zsk) = [];
            % Need to update indices and operators
            opVec(zsk) = [];
            leftParsLoc(leftParsLoc > zsk) = leftParsLoc(leftParsLoc > zsk)-1;
            rightParsLoc(rightParsLoc > zsk) = rightParsLoc(rightParsLoc > zsk)-1;
            opLoc(opLoc > zsk) = opLoc(opLoc > zsk)-1;
        end
    end
    
end

% Remove leading + signs
if strcmp(str(1),'+')
    str(1) = []; 
end

end

function out = updateLoc(in,pLeft,pRight)
out = in - (in > pLeft) - (in > pRight);
end