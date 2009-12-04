function Narg = feval(Nin,argument,varargin)
% FEVAL Evaluate the operator of the chebop.
%
% Evaluate the operator with the given argument. 

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
