function stackout = parse(lexOutArg)
% PARSE - This function parses the output from the lexer.
%
% As it is now, it only checks the validity of the syntax. My plan is to
% modify the code so it returns a syntax tree.

% Initialize all global variables
global NEXT; global NEXTCOUNTER; global LEXOUT; global pStack; pStack = [];
NEXTCOUNTER = 1;
LEXOUT = lexOutArg;
NEXT = char(LEXOUT(NEXTCOUNTER,2));
success = parseSst;

% Return the one tree that is left on the stack
stackout = pStack;

% Clear all global variables
NEXT = []; NEXTCOUNTER = []; LEXOUT = []; pStack = [];
end

function success = parseSst
global NEXT;
% Our expression can only start with certain labels, make sure we are
% starting with one of them.
if ~isempty(strmatch(NEXT,char('NUM','VAR','INDVAR','FUNC1','FUNC2','UN-','UN+','LPAR')))
    parseExp1();
    success = match('$');
    
    if ~success
        reportError('parse:end','Input expression ended in unexpected manner');
    end
else
    success = 0;
    reportError('parse:start','Input field started with unaccepted symbol.');
end
end

function parseExp1()
parseExp2();
parseExp1pr();
end

function parseExp2()
parseExp3();
parseExp2pr();
end

function parseExp3()
parseExp4();
parseExp3pr();
end

function parseExp4()
global NEXT; global NEXTCOUNTER; global LEXOUT; 
% Setja upp strmatch
if strcmp(NEXT,'NUM') || strcmp(NEXT,'VAR') || strcmp(NEXT,'INDVAR')
    % This means we have hit a terminal type. We therefore push that into
    % the stack.
    newLeaf = tree({char(LEXOUT(NEXTCOUNTER)), char(NEXT)});
    push(newLeaf);
    advance();
elseif strcmp(NEXT,'FUNC1')
    functionName = char(LEXOUT(NEXTCOUNTER));
    advance();
    parseFunction1();
    rightArg =  pop();
    newTree = tree({functionName, 'FUNC1'}, rightArg);
    push(newTree);
elseif strcmp(NEXT,'FUNC2')
    functionName = char(LEXOUT(NEXTCOUNTER));
    advance();
    parseFunction2();
    secondArg =  pop();
    % Diff can either take one or two argument. Need a fix if user just
    % passed one argument to diff (e.g. diff(u) instead of diff(u,1)). If
    % that's the case, the stack will be empty at this point, so we create
    % a pseudo argument for diff
    if (strcmp(functionName,'diff') || strcmp(functionName,'cumsum')) & ~stackRows
        firstArg = secondArg;
        secondArg = tree({'1','NUM'});
    else
        firstArg =  pop();
    end
    newTree = tree(firstArg, {functionName, 'FUNC2'}, secondArg);
    push(newTree);
elseif strcmp(NEXT,'LPAR')
    advance();
    parseExp1();
    % Check if NEXT symbol is ')' as it should be. If not, there is a
    % parenthesis imbalance in the expression and we return an error.
    m = match('RPAR');  
    if ~m
        reportError('parse:parenths', 'Parenthesis imbalance in input fields.')
    end
elseif  strcmp(NEXT,'UN-') || strcmp(NEXT,'UN+') || strcmp(NEXT,'OP-') || strcmp(NEXT,'OP+') 
    % If + or - reaches this far, we have an unary operator.
    % ['UN', char(NEXT(3))] determines whether we have UN+ or UN-.
    newCenterNode = {char(LEXOUT(NEXTCOUNTER)), ['UN', char(NEXT(3))]};
    advance();
    parseExp4();
    
    rightArg =  pop();
    newTree = tree(newCenterNode, rightArg);
    push(newTree);
else
    reportError('parse:terminal','Unrecognized character in input field')
end
end

function parseFunction1()
global NEXT;
if strcmp(NEXT,'LPAR')
    advance();
    parseExp1();
    
    m = match('RPAR');
    if ~m
        reportError('parse:parenths', 'Parenthesis imbalance in input fields.')
    end
else
    reportError('parse:parenths', 'Need parenthesis when using functions in input fields.')
end
end

function parseFunction2()
global NEXT;
if strcmp(NEXT,'LPAR')
    advance();
    parseExp1();
    
    m = match('RPAR');
    if ~m
        reportError('parse:parenths', 'Parenthesis imbalance in input fields.')
    end
else
    reportError('parse:parenths', 'Need parenthesis when using functions in input fields.')
end
end

function parseExp1pr()
global NEXT; global  pStack;
if strcmp(NEXT,'OP+')

    advance();
    leftArg  = pop();
    parseExp2();
    rightArg = pop();

    push(tree(leftArg, {'+', 'OP+'} ,rightArg));
    parseExp1pr();
elseif(strcmp(NEXT,'OP-'))
    advance();
    leftArg  = pop();
    parseExp2();
    rightArg = pop();

    push(tree(leftArg, {'-', 'OP-'} ,rightArg));
    parseExp1pr();
elseif strcmp(NEXT,'COMMA')
    advance();
    parseExp1();
	% Do nothing
elseif strcmp(NEXT,'RPAR') || strcmp(NEXT,'$')
	% Do nothing
else % If we don't have ) or the end symbol now something has gone wrong.
    reportError('parse:end','Syntax error in input fields.')
end
end


function parseExp2pr()
global NEXT; global pStack;
if strcmp(NEXT,'OP*')
    leftArg  = pop();   % Pop from the stack the left argument
    advance();          % Advance in the input
    parseExp3();
    rightArg = pop();  % Pop from the stack the right argument 
    push(tree(leftArg,{'.*', 'OP*'},rightArg));   % Push the (partial) syntax tree
    parseExp2pr();
elseif(strcmp(NEXT,'OP/'))
    leftArg  = pop();   % Pop from the stack the left argument
    advance();          % Advance in the input
    parseExp3();
    rightArg = pop();  % Pop from the stack the right argument 
    push(tree(leftArg,{'./','OP/'},rightArg));   % Push the (partial) syntax tree
    parseExp2pr();
else
    % Do nothing
end
end

function parseExp3pr()
global NEXT;
if strcmp(NEXT,'OP^')
    leftArg  = pop();
    advance();    
    parseExp4();
    rightArg = pop();
    push(tree(leftArg,{'.^','OP^'},rightArg));
    parseExp3pr();
elseif ~isempty(strfind(NEXT,'DER'))
    leftArg  = pop();
    push(tree({'D',NEXT},leftArg));
    advance();
    parseExp3pr();
else
    % Do nothing
end
end


function advance()
global NEXT; global NEXTCOUNTER; global LEXOUT;
NEXTCOUNTER = NEXTCOUNTER +1;
NEXT = char(LEXOUT(NEXTCOUNTER,2));
end



function m = match(label)
global NEXT;
m = strcmp(label,NEXT);
% If we found a match and are not at the end of output, we want to advance
% to the NEXT symbol
if m && ~strcmp(label,'$')
    advance();
end
end


function push(new)
global pStack;
if ~stackRows()
    pStack = new;
else
    pStack = [pStack ;new];
end
end


function p = pop()
global pStack;
p = pStack(end,:);
pStack(end,:) = [];
end

function m = stackRows()
global pStack;
[m n] = size(pStack);
end

function reportError(id,msg)
error(['CHEBFUN:', id],msg);
% ME = MException(id,msg);
% throw(ME);
end