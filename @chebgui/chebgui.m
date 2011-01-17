function c = chebgui(varargin)
%CHEBGUI Summary of this function goes here
%   Detailed explanation goes here

% If chebgui is called without any arguments, we load a random example and
% display it in the GUI window
if isempty(varargin)
    % Need to create a temporary chebgui object to be able to call the
    % loadexample method
    cgTemp = chebgui('type','bvp');
    % Calling loadexample with second argument -1 gives a random example
    cg = loadexample(cgTemp,-1,'bvp');
    show(cg);
else
    c.type = '';
    c.DomLeft = ''; c.DomRight = '';
    c.DE = ''; c.DErhs = ''; c.LBC = ''; c.LBCrhs = ''; c.RBC = '';
    c.RBCrhs = ''; c.timedomain = '';
    c.guess = []; c.tol = [];
    
    
    k = 1;
    while k < nargin
        type = varargin{k};
        value = varargin{k+1};
        if isnumeric(value), value = num2str(value); end
        switch lower(type)
            case 'type'
                c.type = value;
            case 'domleft'
                c.DomLeft = value;
            case 'domright'
                c.DomRight = value;
            case 'domain'
                c.DomLeft =   num2str(varargin{k+1}(1));
                c.DomRight =  num2str(varargin{k+1}(2));
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
                
        end
        k = k + 2;
    end
    
    if isempty(c.tol)
        c.tol = '1e-10'; % Default tolerance
    end
    
    c = class(c,'chebgui');
end

