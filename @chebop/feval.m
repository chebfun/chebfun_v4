function Narg = feval(Nin,varargin)
% FEVAL Evaluate the operator of the chebop.
%
% Evaluate the operator with the given argument.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

if nargin < 2, 
    error('CHEBFUN:chebop:feval:nargin1',...
        'Incorrect number of input arguments.');
end

if isnumeric(varargin{1})
    [L linBC isLin] = linearise(Nin);
    if ~isLin
        error('CHEBOP:feval:expansion',...
            'Matrix expansion is only allowed for linear chebops.')
    end
    L = L & linBC;
    Narg = feval(L,varargin{:});
    return
end

% Need to do a trick if the operator is a cell
if ~isa(Nin.op,'cell')
    if strcmp(class(Nin.op),'linop')
        Narg = feval(Nin.op,varargin{:});
        return
    end
    
    numberOfInputVariables = nargin(Nin.op);
    xDom = {chebfun('x',Nin.domain.endsandbreaks)};
    
    if numberOfInputVariables == 1
        xDom = {};
        if numel(varargin) > 1
            error
%         elseif numel(varargin{1}) ~= numberOfInputVariables
%             error
        else
            vars = varargin(1);
        end
    elseif numberOfInputVariables > 2
        if numel(varargin) == 1
            if numel(varargin{1}) == numberOfInputVariables
                xDom = {};
            elseif numel(varargin{1}) ~= numberOfInputVariables - 1
                error
            end
            quasi = varargin{1};
            vars = cell(1,numel(quasi));
            for quasiCounter = 1:numel(quasi)
                vars{quasiCounter} = quasi(:,quasiCounter);
            end
        elseif numel(varargin) == numberOfInputVariables
            xDom = varargin(1); vars = varargin(2:end);   
        elseif numel(varargin) == 2 && numel(varargin{2}) == numberOfInputVariables - 1
            xDom = varargin(1); quasi = varargin{2};
            vars = cell(1,numel(quasi));
            for quasiCounter = 1:numel(quasi)
                vars{quasiCounter} = quasi(:,quasiCounter);
            end
        else 
            error
        end
    else
        if numel(varargin) > 2
            error
        elseif numel(varargin) == 2
            xDom = {};
        end
        vars = varargin;
    end
    Narg = feval(Nin.op,xDom{:},vars{:});
else
    [m,n] = size(Nin.op);
    Narg = [];
    argument = varargin{1};
    for i = 1:length(Nin.op)
        if m > n % Cell with many rows, one column. Do a vertcat
            Narg = [Narg; Nin.op{i}(argument)];
        else
            Narg = [Narg, Nin.op{i}(argument)];
        end
    end
end
