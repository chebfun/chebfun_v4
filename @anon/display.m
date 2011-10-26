function display(A,maxdepth,curdepth)
% DISPLAY Pretty-print an anon
% DISPLAY is called automatically when a statement that results in an anon
% output is not terminated with a semicolon.
% DISPLAY(A,MAXDEPTH) will descend the anon tree upto MAXDEPTH levels and
% pretty-print the correponding anons. By default MAXDEPTH is 1. Setting it
% to INF will force DISPLAY to descend to the bottom of the tree.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% Defaults
if nargin < 2, maxdepth = inf; end
if nargin < 3, curdepth = 1; end

% We don't want to go any further
if curdepth > maxdepth, return, end

% Initialise whitespace
ws = ['   ' repmat('     ',1,curdepth-1)];

% Initialise string to print
s = [];

if curdepth == 1
    % Attempt to grab variable name
    name = inputname(1);
    if isempty(name), name = 'ans'; end
    disp([name ' ='])
    
    % Deal with empty anons
    if isempty(A.variablesName)
        disp([ws, 'empty anon']);    
        return
    end
    % Anon is not empty
    disp([ws 'anon']);
    
    % Initialise s
    s = [s, sprintf('\n%sdiff(%s,u) = ',ws,name)];
end

varNamesStr = [];
vars = A.variablesName;
for k = 1:numel(vars)
%     if ~isa(A.workspace{k},'chebfun'), continue, end
    if isempty(varNamesStr)
        varNamesStr = vars{k};
    else
        varNamesStr = [varNamesStr,',',vars{k}];
    end
    if isnumeric(A.workspace{k})
        classk = num2str(A.workspace{k});
    else
        classk = class(A.workspace{k});
    end
    varNamesStr = [varNamesStr '=' classk];
end
% Update s to contain the variables string
if isempty(varNamesStr)
    s = [s, sprintf('empty anon')];
    disp(s);
    return
end
s = [s, sprintf('@(%s): ',varNamesStr)];

% Include the parent tag if present
if ~isempty(A.parent)
    parent = A.parent;
    % If java is not enabled, don't display html links.
    if usejava('jvm') && usejava('desktop') 
        whichParent = which([parent '(chebfun)']);
        parent = ['<a href="matlab: edit ''' whichParent '''">' parent '</a>'];
    end
    s = [s, '%', parent];
end

% Grab the main function string
funcStr = A.func;

% Clean out 'linop' flags and break at seicolons for prettyprint
idx = [0 strfind(funcStr,';')];
funcStrClean = {};
for k = 1:numel(idx)-1;
    funcStrClean{k} = funcStr(idx(k)+1:idx(k+1));
    while numel(funcStrClean{k})>1 && isspace(funcStrClean{k}(1)) 
        funcStrClean{k}(1) = [];
    end
    funcStrClean{k} = strrep(funcStrClean{k},',''linop''','');
end

% Print each function string on a new line
for k = 1:numel(funcStrClean)
    s = [s,sprintf('\n%s%s',ws,funcStrClean{k})];
%     s = [s,sprintf('%s',funcStrClean{k})];
end

% Print the output
disp(s)

% We don't want to go any further
if curdepth == maxdepth, return, end

% Recurse down the tree
for k = 1:numel(A.workspace)
    fk = A.workspace{k};
    % Uncomment below to prevent showing empty anons
    if isa(fk,'chebfun') %&& ~isempty(fk.jacobian.variablesName)
        fprintf('\n%s     diff(%s,u) = ',ws,vars{k});
        display(fk.jacobian,maxdepth,curdepth+1)
    end
end    

end
