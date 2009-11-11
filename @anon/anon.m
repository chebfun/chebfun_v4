function ADH = anon(varargin)
ADH = struct([]);

ADH(1).function = varargin{1};
ADH(1).variablesName = varargin{2};
ADH(1).workspace = varargin{3};

ADH = class(ADH,'anon');
end