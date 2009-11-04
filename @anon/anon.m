function ADH = anon(varargin)

ADH.function = varargin{1};
ADH.variablesName = varargin{2};
ADH.workspace = varargin{3};
ADH = class(ADH,'anon');
end