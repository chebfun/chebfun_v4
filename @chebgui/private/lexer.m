function [out varNames pdeVarNames indVarName] = lexer(guifile,str)
% LEXER Lexer for string expression in the chebfun system
% [OUT VARNAMES INDVARNAME] = LEXER(STR) performs a lexical analysis on the
% string STR. OUT is a cell array with two columns, the left is a token and
% the right is a label. VARNAMES is a cell string with name of variables in
% the expression. INDVARNAME is a string which represents the independent
% variable in the problem (i.e. x or t).

out = [];
% A string array containing all functions which take one argument which 
% we are interested in differentiating
strfun1 = char('sin', 'cos', 'tan', 'cot', 'sec', 'csc', ...
    'sinh', 'cosh', 'tanh', 'coth', 'sech', 'csch', ...
    'asin', 'acos', 'atan', 'acot', 'asec', 'acsc', ...
    'asinh', 'acosh', 'atanh', 'acoth', 'asech', 'acsch', ...
    'sqrt', 'exp', 'log','log10','sum','abs','sign');
% A string array containing all functions which take two arguments which 
% we are interested in differentiating
strfun2 = char('airy','besselj','cumsum','diff','power');

% Remove all whitespace
str = strrep(str,' ','');

% Change quotes (") to two apostrophes ('')
str = strrep(str,'"','''''');
% Change two minuses to one +, etc
k = 1;
while k < numel(str)-1
    if strcmp(str(k),'-')
        if strcmp(str(k+1),'-')
            str(k) = '+';
            str(k+1) = [];
        elseif strcmp(str(k+1),'+')
            str(k+1) = [];
        else
            k = k+1;
        end
    elseif strcmp(str(k),'+')
        if strcmp(str(k+1),'-')
            str(k) = '-';
            str(k+1) = [];
        elseif strcmp(str(k+1),'+')
            str(k+1) = [];
        else
            k = k+1;
        end
    else
        k = k+1;
    end
end
% Vectorize the string
str = vectorize(str);

% Obtain the name of possible variables
varNames = symvar(str);

% Create a cell for potential pdeVarNames
pdeVarNames = {};

% x and t are reserved for independent variables
xLoc = strcmp('x',varNames); varNames(xLoc) = [];
tLoc = strcmp('t',varNames); varNames(tLoc) = [];

% Return the name of the independent variable. Use x if none is found
if sum(tLoc)
    indVarName = 't';
else
    indVarName = 'x';
end

str(end+1) = '$';   % Add $ to the end of the string to mark its end
% In order to spot unary operators we need to store the type of the
% previous token.
prevtype = 'operator';
while ~strcmp(str,'$')
    char1 = str(1);
    type = myfindtype(char1,prevtype);
    expr_end = 1;
    switch type
        case 'num'
            % Obtain the numbers continously (with match), their start and
            % end positions.
            [m s e] = regexp(str, '[\+\-]?(([0-9]+(\.[0-9]*)?|\.[0-9]+)([eE][\+\-]?[0-9]+)?)', 'match', 'start', 'end');
            
            % We can run into trouble with string such as 2*3 which will
            % become 2.*3 as we vectorize. But the . here should be a part
            % of the operator, not the number, so we have to do a little
            % check here.
            nextnum = char(m(1));
            expr_end = e(1);
            nextChar = str(e(1)+1);
            if nextnum(end) == '.' && ~isempty(regexp(nextChar,'[\+\-\*\/\^]'))
                nextnum(end) = []; % Throw away the .
                expr_end = e(1) - 1; % Lower the number of which we clear the string before
            end
            
            % If we encounter xi or xj, where x is a number (i.e. we have
            % 1i, 1.32i etc), we need to combine them into one token,
            % rather than lexing 1 as a number and i as a variable.         
            if strcmp(nextChar,'i') || strcmp(nextChar,'j')
                nextnum = [nextnum,nextChar];
                expr_end = e(1) + 1; % Increase the number of chars. we throw away
            end
            out = [out; {nextnum, 'NUM'}];
        case 'unary'
            expr_end = 1;
            switch(char1)
                case '+'
                    out = [out; {char1, 'UN+'}];
                case '-'
                    out = [out; {char1, 'UN-'}];
            end
        case 'point'
            % If we have point, we need to check next symbol to see if we 
            % have an operator (e.g. .*) or a double (e.g. .1):
            char2 = str(2);
            type2 = myfindtype(str(2),prevtype);
            switch type2
                
                case 'num'      % We have a float
                    [m s e] = regexp(str, '[0-9]+([eE][\+\-]?[0-9]+)?', 'match', 'start', 'end');
                    nextnum = ['.', char(m(1))];   % Add a . and convert from cell to string
                    expr_end = e(1);
                    out = [out; {nextnum, 'NUM'}];
                case 'operator' % We have a pointwise operator
                    expr_end = 2;
                    switch char2
                        case '+'
                            out = [out; {'.+', 'OP+'}];
                        case '-'
                            out = [out; {'.-', 'OP-'}];
                        case '*'
                            out = [out; {'.*', 'OP*'}];
                        case '/'
                            out = [out; {'./', 'OP/'}];
                        case '^'
                            out = [out; {'.^', 'OP^'}];
                    end
            end
        case 'operator'
            % We know that *,/ and ^ will never reach this far as we have
            % already vectorized the string. Thus, we don't have to treat
            % those operators here.
            expr_end = 1;
            switch char1
                case '+'
                    out = [out; {char1, 'OP+'}];
                case '-'
                    out = [out; {char1, 'OP-'}];
                case '('
                    out = [out; {char1, 'LPAR'}];
                case ')'
                    out = [out; {char1, 'RPAR'}];
            end
        case 'deriv'
            [m s e] = regexp(str, '''+', 'match', 'start', 'end');
            
            expr_end = e(1);
            
            order = e(1)-s(1)+1;
            
            out = [out; {m{1}, ['DER' num2str(order)]}];
            % Find the order of the derivative
        case 'char'
            [m s e] = regexp(str, '[a-zA-Z_][a-zA-Z_0-9]*', 'match', 'start', 'end');
            nextstring = char(m(1));   % Convert from cell to string
            expr_end = e(1);
            
            % First check if we are getting pi (which should obviously be
            % treated as a number
            if strcmp(nextstring,'pi')
                out = [out; {nextstring, 'NUM'}];       
            % Check if we are getting the variable we are interested in
            % differentiating w.r.t.
            elseif any(strcmp(nextstring,varNames))
                % Need to treat variables which have a time derivative
                % attached on them separately.
                if isempty(strfind(nextstring,'_'))
                    out = [out; {nextstring, 'VAR'}];
                else
                    out = [out; {nextstring, 'PDEVAR'}];
                    % Remove from the varNames array, store in pdeVarNames instead
                    pdeVarLoc = strcmp(nextstring,varNames); varNames(pdeVarLoc) = [];
                    pdeVarNames = [pdeVarNames;nextstring];
                end
            % Check if this string is one of the function defined in
            % strfun1 (functions with one argument)
            elseif strmatch(nextstring,strfun1,'exact')
                out = [out; {nextstring, 'FUNC1'}];
            % Check if this string is one of the function defined in
            % strfun2 (functions with two arguments)
            elseif strmatch(nextstring,strfun2,'exact')
                out = [out; {nextstring, 'FUNC2'}];
            % Treat l, lam and lambda specially for e-value problems
            elseif strcmp(guifile.type,'eig') && (strcmp(nextstring,'l') || ...
                strcmp(nextstring,'lam') || strcmp(nextstring,'lambda'))
                out = [out; {nextstring, 'LAMBDA'}];
            % If not a function nor the variable we are interested in
            % differentiating with respect to, we treat this variable just
            % as number (this enables us e.g. to be able to differentiate w.r.t.
            % x and y seperately)
            else    
                out = [out; {nextstring, 'INDVAR'}];
            end
        case 'comma'
            out = [out; {char1,'COMMA'}];
        case 'error'
            disp('Chebgui:Lexer:UnknownType','Unrecognized type of lexer input.');
            % Throw error
    end
    
    prevtype = type;
    if char1 == ')'          % Special case if we have have ) as we DON'T want unary operators then
        prevtype = 'char';
    end
    str(1:expr_end) = '';       %  Throw away from string what we have already scanned
end
out = [out; {'', '$'}];
end

function type = myfindtype(str,prevtype)

if regexp(str, '[0-9]') % Breyta i float  [+-]?(([0-9]+(.[0-9]*)?|.[0-9]+)([eE][+-]?[0-9]+)?)
    type = 'num';
% If we want to treat unary operators especially
elseif (strcmp(prevtype,'operator') || strcmp(prevtype,'unary')) && ~isempty(regexp(str, '[+-]'))
    type = 'unary';
elseif regexp(str,'[A-Za-z_]')
    type = 'char';
elseif str == '.' % We need to be able to distinguish between doubles and operators
    type = 'point';
elseif regexp(str,'\.?[\+\-\*\/\.\^\(\)]')
    type = 'operator';
elseif regexp(str,'''')
    type = 'deriv';
elseif strcmp(str,',')
    type = 'comma';
else
    type = 'error';
end

end