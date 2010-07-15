function Narg = feval(Nin,argument,varargin)
% FEVAL Evaluate the operator of the chebop.
%
% Evaluate the operator with the given argument.

% Need to do a trick if the operator is a cell
if ~isa(Nin.op,'cell')
    numberOfInputVariables = nargin(Nin.op);
    
    % Need to load a cell if the number of input arguments is greater than
    % 1:
    if numberOfInputVariables == 1
        Narg = Nin.op(argument);
    else
        % Load the cell variable from the quasimatrix
        argumentCell = cell(1,numel(argument));
        for quasiCounter = 1:numel(argument)
            argumentCell{quasiCounter} = argument(:,quasiCounter);
        end
        
        Narg = Nin.op(argumentCell{:});
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
