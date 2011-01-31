function c = chebgui(varargin)
% CHEBGUI Constructor for chebgui objects. For documentation of the GUI,
% press Help button in the GUI.
%
% See also chebguiwindow.

% If chebgui is called without any arguments, we load a random example and
% display it in the GUI window
if isempty(varargin)
    % Need to create a temporary chebgui object to be able to call the
    % loadexample method
    cgTemp = chebgui('type','bvp');
    % Calling loadexample with second argument -1 gives a random example
    cg = loadexample(cgTemp,-1,'bvp');
    show(cg);
elseif nargin == 1 && isa(varargin{1},'chebgui')
    chebguiwindow(varargin{1});
else
    c.type = '';
    c.DomLeft = ''; c.DomRight = '';
    c.DE = ''; c.DErhs = ''; c.LBC = ''; c.LBCrhs = ''; c.RBC = '';
    c.RBCrhs = ''; c.timedomain = '';
    c.guess = []; c.tol = [];
    c.options = struct('damping','1','plotting','0.5','grid',1,'pdeholdplot',0);
    
    
    k = 1;
    while k < nargin
        type = varargin{k};
        value = varargin{k+1};
        if isnumeric(value), value = num2str(value); end
        switch lower(type)
            case 'type'
                if ~strcmpi(value,'bvp') && ~strcmpi(value,'pde') && ~strcmpi(value,'ivp')
                    error('CHEBGUI:chebgui:type',[value,' is not a valid type of problem.'])
                elseif strcmpi(value,'ivp')
                    warning('CHEBGUI:chebgui:type Type of problem changed from IVP to BVP');
                    c.type = 'bvp';
                else
                    c.type = value;
                end
            case 'domleft'
                c.DomLeft = value;
            case 'domright'
                c.DomRight = value;
            case 'domain'
                c.DomLeft =   num2str(varargin{k+1}(1));
                c.DomRight =  num2str(varargin{k+1}(2));
            case 'timedomain'
                c.timedomain = value;
            case 'de'
                c.DE = value;
            case 'derhs'
                c.DErhs = value;
            case 'lbc'
                c.LBC = value;
            case 'lbcrhs'
                c.LBCrhs = value;
            case 'rbc'
                c.RBC = value;
            case 'rbcrhs'
                c.RBCrhs = value;
            case 'guess'
                c.guess = value;
            case 'tol'
                c.tol = value;
            case 'options'
                % Set the fields which correspond to elements specified.
                % Use fieldnames to obtain a list of the fields in the
                % struct, then a dynamic field name to obtain the
                % corresponding value.
                fNames = fieldnames(value);
                for optCounter = 1:length(fNames)
                    optionName = char(fNames(optCounter,:));
                    c.options.(optionName)  = value.(optionName);
                end
            otherwise
                error('CHEBGUI:propname',[propName,' is not a valid chebgui property.'])
        end
        k = k + 2;
    end
    
    if isempty(c.tol)
        c.tol = '1e-10'; % Default tolerance
    end
    
    c = class(c,'chebgui');
end

