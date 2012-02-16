function funcOut = fitBCs(L)
% FUNCOUT = FITBCS(L) Returns a chebfun which will satisfy the BCs and
% other conditions of the linop L.

% Determines how big discretization we want for each component. Individual
% diffOrder for each component if we have a system
indDifforder = max(L.difforder);

numVar = L.blocksize(2);

breaks = L.domain;
breaks = breaks.endsandbreaks;

jumplocs = [];
if ~isempty(L.jumpinfo)
    jumplocs = L.jumpinfo(:,1);
end

breaks = union(breaks,jumplocs);

% Store the total number of interior breakpoints
numBreaks = length(breaks) - 2;
if numel(breaks) == 2, breaks = []; end
breaks = repmat({breaks},1,numVar);

% n = repmat({n},1,L.blocksize(2));

fevalOrder = {repmat(indDifforder(1),1,numBreaks+1)};

for varCounter = 2:numVar
    fevalOrder = [fevalOrder, repmat(indDifforder(varCounter),1,numBreaks+1)];
end

map = [];

% Boundary (and other conditions) matrix
[BC bcrhs] = bdyreplace(L,fevalOrder,map,breaks);
% Continuity matrix
[CM  cmrhs] = cont_conds(L,fevalOrder,map,breaks);



completeMat = [BC ; CM];
completeRHS = [bcrhs  ; cmrhs];

% Complete solution to everything
uu = completeMat\completeRHS;



% uu will contain all information. If we have a coupled system, we need to
% split up the vector to corresponding blocks for each function. Also, here
% we need to take breakpoints into consideration, as each block can contain
% information about multiple funs on subdomains.
f = chebfun;
startPos = 1;
for varCounter = 1:numVar
    % In a system, the functions can have different lengths depending on
    % the their maximum differential order. Take that into account by
    % working with each "chunk" from uu at a time.
    %
    % Here we could do some fancy vector footwork, but for the sake of
    % clarity, we work directly with counters
    endPos = startPos + (numBreaks + 1)*indDifforder(varCounter) - 1;
    
    % This vector holds all values for a single function.
    un = uu(startPos:endPos);
    
    % Need to split un up according to breakpoints
    funs = fun;
    ends = L.domain; ends = ends.endsandbreaks;
    funlength = length(un)/(numBreaks+1);
    imps = zeros(1,length(ends));
    for k = 1:length(ends)-1
        unk = un((k-1)*funlength+1:k*funlength);
        %         uk = un((k-1)*difford+1:k*difford);
        funs(k) = fun(unk,[ends(k) ends(k+1)]);
        imps(1,k) = funs(k).vals(1);
    end
    imps(end) = funs(k).vals(end);
    
    ftemp = chebfun(0,ends);
    ftemp.funs = funs;
    ftemp.imps = imps;
    f = [f ftemp];
    
    % Update counters
    startPos = endPos + 1;
end

funcOut = f;