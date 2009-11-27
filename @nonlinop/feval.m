function Narg = feval(Nin,argument,varargin)
% Evaluate the anonymous function in Nin.op with the argument passed.

% Check whether the operator is a chebop
if strcmp(Nin.optype,'chebop')
    disp('chebop');
    Narg = Nin.op*argument;
    return
end

% Need to do a trick if the operator is a cell
if ~isa(Nin.op,'cell')
    Narg = Nin.op(argument);
else
    disp('cell');
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
