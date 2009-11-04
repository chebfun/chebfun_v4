function Fx = feval(Fin,x,varargin)
% Extract variable names and values
Fvar = Fin.variablesName;
Fwork = Fin.workspace;

% Load these variables into workspace
loadVariables(Fvar,Fwork)

% Create a normal anonymous function handle that we can then evaluate
Ffun = eval(Fin.function);
Fx = Ffun(x);
end

function loadVariables(Fvar,Fwork)
for i=1:length(Fvar), r = rand; assignin('caller',Fvar{i},Fwork{i}), end
end