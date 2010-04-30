function Fx = feval(Fin,anonArgument,varargin)
% FEVAL Evaluates an anon with an input argument, similar to f(u) where f
% is an anonymous function and u is some argument.

if strmatch(Fin.function,'max_memsize')
    error('Error while evaluating AD derivative. Variables have grown to big in memory. Please contact the chebfun team at chebfun@maths.ox.ac.uk.');
end
% Extract variable names and values
Fvar = Fin.variablesName;
Fwork = Fin.workspace;

% Load these variables into workspace
loadVariables(Fvar,Fwork)

% Create a normal anonymous function handle that we can then evaluate
Ffun = eval(Fin.function);
Fx = feval(Ffun,anonArgument);
end

function loadVariables(Fvar,Fwork)
for i=1:length(Fvar), assignin('caller',Fvar{i},Fwork{i}), end
end