function Narg = feval(Nin,argument,varargin)
% FEVAL Evaluate the operator of the chebop.
%
% Evaluate the operator with the given argument.

% Need to do a trick if the operator is a cell
if ~isa(Nin.op,'cell')
    if strcmp(class(Nin.op),'linop')
        Narg = feval(Nin.op,argument,varargin);
        return
    end
    numberOfInputVariables = nargin(Nin.op);
    
    % Need to load a cell if the number of input arguments is greater than
    % 1:
    if numberOfInputVariables == numel(argument)
        Narg = feval(Nin.op,argument);
    elseif numel(argument) == numberOfInputVariables - 1
        % Create the linear function on the domain of Nin to use as the
        % first argument
        xDom = chebfun('x',Nin.dom);
        Narg = feval(Nin.op,xDom,argument);
    else
        error('CHEBOP:feval:nargin','Incorrect number of input arguments.')
    end
else
    [m,n] = size(Nin.op);
    Narg = [];
    for i = 1:length(Nin.op)
        if m > n % Cell with many rows, one column. Do a vertcat
            Narg = [Narg; Nin.op{i}(argument)];
        else
            Narg = [Narg, Nin.op{i}(argument)];
        end
    end
end
