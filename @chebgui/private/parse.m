function [stackout PDESIGN] = parse(guifiles,lexOutArg)
% PARSE - This function parses the output from the lexer.
%
% As it is now, it only checks the validity of the syntax. My plan is to
% modify the code so it returns a syntax tree.

% Initialize all global variables
global NEXT; global NEXTCOUNTER; global LEXOUT; global pStack; global PDESIGN;
pStack = [];
NEXTCOUNTER = 1;
LEXOUT = lexOutArg;
NEXT = char(LEXOUT(NEXTCOUNTER,2));
PDESIGN = 1;
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
if ~isempty(strmatch(NEXT,char('NUM','VAR','INDVAR','PDEVAR',...
        'FUNC1','FUNC2','UN-','UN+','LPAR')))
    parseExp1();
    success = match('$');
    
    if ~success
        reportError('Parse:end','Input expression ended in unexpected manner');
    end
else
    success = 0;
    reportError('Parse:start','Input field started with unaccepted symbol.');
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
parseExp5();
parseExp4pr();
end

function parseExp5()
global NEXT; global NEXTCOUNTER; global LEXOUT; global PDESIGN;
% We begin by checking whether we have hit a terminal case. In that case,
% we push that into the stack. We need to treat variables with _ in the
% names separately, as we only allow certain operators around the time
% derivative.
if strcmp(NEXT,'NUM') || strcmp(NEXT,'VAR') || strcmp(NEXT,'INDVAR')
    newLeaf = struct('center',{{char(LEXOUT(NEXTCOUNTER)), char(NEXT)}},'pdeflag',0);
    push(newLeaf);
    advance();
elseif strcmp(NEXT,'PDEVAR')
    newLeaf = struct('center',{{char(LEXOUT(NEXTCOUNTER)), char(NEXT)}},'pdeflag',1);
    push(newLeaf);
    advance();
elseif strcmp(NEXT,'FUNC1') % Functions which take one argument
    functionName = char(LEXOUT(NEXTCOUNTER));
    advance();
    parseFunction1();
    rightArg =  pop();
    if rightArg.pdeflag
        error('Chebgui:Parse:PDE','Cannot use time derivative as function arguments.')
    end
    newTree = struct('center',{{functionName, 'FUNC1'}},...
        'right',rightArg,'pdeflag',0); % Can assume no pde if we reach here
    push(newTree);
elseif strcmp(NEXT,'FUNC2') % Functions which take two arguments
    functionName = char(LEXOUT(NEXTCOUNTER));
    advance();
    parseFunction2();
    secondArg =  pop();
    % Diff can either take one or two argument. Need a fix if user just
    % passed one argument to diff (e.g. diff(u) instead of diff(u,1)). If
    % that's the case, the stack will be empty at this point, so we create
    % a pseudo argument for diff. Similar for Airy.
    if (strcmp(functionName,'diff') || strcmp(functionName,'cumsum')) && ~stackRows
        firstArg = secondArg;
        secondArg = struct('center',{{'1','NUM'}},'pdeflag',0);
    elseif strcmp(functionName,'airy') && ~stackRows
        firstArg = struct('center',{{'0','NUM'}},'pdeflag',0);
    else
        firstArg =  pop();
    end
    if firstArg.pdeflag || secondArg.pdeflag
        error('Chebgui:Parse:PDE','Cannot use time derivative as function arguments.')
    end    
    newTree = struct('left',firstArg,'center', {{functionName, 'FUNC2'}},...
        'right', secondArg,'pdeflag',0); % Can assume no pde if we reach here
    push(newTree);
elseif strcmp(NEXT,'LPAR')
    advance();
    parseExp1();
    % Check if NEXT symbol is ')' as it should be. If not, there is a
    % parenthesis imbalance in the expression and we return an error.
    m = match('RPAR');  
    if ~m
        reportError('Parse:parenths', 'Parenthesis imbalance in input fields.')
    end
elseif  strcmp(NEXT,'UN-') || strcmp(NEXT,'UN+') || strcmp(NEXT,'OP-') || strcmp(NEXT,'OP+') 
    % If + or - reaches this far, we have an unary operator.
    % ['UN', char(NEXT(3))] determines whether we have UN+ or UN-.
    newCenterNode = {{char(LEXOUT(NEXTCOUNTER)), ['UN', char(NEXT(3))]}};
    if strcmp(NEXT,'UN-')
        swapSign = 1;
    else
        swapSign = 0;
    end
    advance();
    parseExp4();
    
    rightArg =  pop();
    
    pdeflag = rightArg.pdeflag;
    % Swap the leading sign of the PDE part
    if pdeflag && swapSign;
        PDESIGN = -1*PDESIGN;
    end
    newTree = struct('center',newCenterNode,'right', rightArg,...
        'pdeflag',pdeflag);
    push(newTree);
else
    reportError('Parse:terminal','Unrecognized character in input field')
end
end

function parseFunction1()
global NEXT;
if strcmp(NEXT,'LPAR')
    advance();
    parseExp1();
    
    m = match('RPAR');
    if ~m
        reportError('Parse:parenths', 'Parenthesis imbalance in input fields.')
    end
else
    reportError('Parse:parenths', 'Need parenthesis when using functions in input fields.')
end
end

function parseFunction2()
global NEXT;
if strcmp(NEXT,'LPAR')
    advance();
    parseExp1();
    
    m = match('RPAR');
    if ~m
        reportError('Parse:parenths', 'Parenthesis imbalance in input fields.')
    end
else
    reportError('Parse:parenths', 'Need parenthesis when using functions in input fields.')
end
end

function parseExp1pr()
global NEXT; global  pStack; global PDESIGN;
if strcmp(NEXT,'OP+')

    advance();
    leftArg  = pop();
    parseExp2();
    rightArg = pop();
    
    pdeflag = leftArg.pdeflag || rightArg.pdeflag;
    
    newTree = struct('left',leftArg,'center',{{'+', 'OP+'}},...
        'right',rightArg,'pdeflag',pdeflag);
    push(newTree);
    parseExp1pr();
elseif(strcmp(NEXT,'OP-'))
    advance();
    leftArg  = pop();
    parseExp2();
    rightArg = pop();

    pdeflag = leftArg.pdeflag || rightArg.pdeflag;
    % Swap the leading sign of the PDE part
    if rightArg.pdeflag
        PDESIGN = -1*PDESIGN;
    end
    newTree = struct('left',leftArg,'center',{{'-', 'OP-'}},...
        'right',rightArg,'pdeflag',pdeflag);
    push(newTree);
    parseExp1pr();
elseif strcmp(NEXT,'COMMA')
    advance();
    parseExp1();
	% Do nothing
elseif strcmp(NEXT,'RPAR') || strcmp(NEXT,'$')
	% Do nothing
else % If we don't have ) or the end symbol now something has gone wrong.
    reportError('Parse:end','Syntax error in input fields.')
end
end


function parseExp2pr()
global NEXT; global pStack;
if strcmp(NEXT,'OP*')
    leftArg  = pop();   % Pop from the stack the left argument
    advance();          % Advance in the input
    parseExp3();
    rightArg = pop();  % Pop from the stack the right argument
    % Check whether we have _ variables
    if leftArg.pdeflag || rightArg.pdeflag
        error('Chebgui:Parse:PDE','Cannot multiply time derivative')
    end
    newTree = struct('left',leftArg,'center',{{'.*', 'OP*'}},...
        'right',rightArg,'pdeflag',0); % Can assume no pde if we reach here
    push(newTree);
    parseExp2pr();
elseif(strcmp(NEXT,'OP/'))
    leftArg  = pop();   % Pop from the stack the left argument
    advance();          % Advance in the input
    parseExp3();
    rightArg = pop();  % Pop from the stack the right argument
    % Check whether we have _ variables
    if leftArg.pdeflag || rightArg.pdeflag
        error('Chebgui:Parse:PDE','Cannot divide with time derivatives')
    end
    newTree = struct('left',leftArg,'center',{{'./', 'OP/'}},...
        'right',rightArg,'pdeflag',0); % Can assume no pde if we reach here
    push(newTree);
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
    % Check whether we have _ variables
    if leftArg.pdeflag || rightArg.pdeflag
        error('Chebgui:Parse:PDE','Cannot take powers with time derivative')
    end
    newTree = struct('left',leftArg,'center',{{'.^', 'OP^'}},...
        'right',rightArg,'pdeflag',0); % Can assume no pde if we reach here
    push(newTree);
    parseExp3pr();
elseif ~isempty(strfind(NEXT,'DER'))
    leftArg  = pop();
    % Check whether we have _ variables
    if leftArg.pdeflag
        error('Chebgui:Parse:PDE','Cannot differentiate time derivative')
    end
    newTree = struct('center',{{'D',NEXT}},'right',leftArg,'pdeflag',0);
    push(newTree);
    advance();
    parseExp3pr();
else
    % Do nothing
end
end

function parseExp4pr()
global NEXT;
if ~isempty(strfind(NEXT,'DER'))
    leftArg  = pop();
    % Check whether we have _ variables
    if leftArg.pdeflag
        error('Chebgui:Parse:PDE','Cannot differentiate time derivative')
    end
    newTree = struct('center',{{'D',NEXT}},'right',leftArg,'pdeflag',0);
    push(newTree);
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