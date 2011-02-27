function ADH = anon(varargin)
% ANON Anon object constructor.
%
% A = anon('function','variables name', variables) creates an anon object
% which behaves in a similar way to anonymous functions.
%
% Example:
%   [d,x] = domain(0,1)
%   A  = anon('@(u) u*sin(x)','x',x)
% creates the anon A which behaves in a similar way to the anonymous
% function F created by
%   F  = @(u) u*sin(x)
%
% The anon class is a support class for working with automatic
% differentiation in Chebfun and is therefore lightly
% documented. It is intented to be used in the overloaded functions in the
% @chebfun directory.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

maxdepth = chebfunpref('addepth');

% Store a persistent dummy anon
persistent dummyAnon

if isempty(dummyAnon)
    dummyAnon.function = [];
    dummyAnon.variablesName = [];
    dummyAnon.workspace = [];
    dummyAnon.type  = 1;
    dummyAnon.depth = maxdepth;

    dummyAnon = class(dummyAnon,'anon');
end
if maxdepth % If maxdepth == 0, AD is turned off
    % Begin by checking whether we will be exceeding the maxdepth
    if nargin > 4
        newdepth = varargin{5};
    else
        currdepth = 0;
        for vararginCounter = 1:length(varargin{3})
            currVar = varargin{3}{vararginCounter};
            if isa(currVar,'chebfun')
                varDepth = getdepth(currVar);
                if varDepth > currdepth
                    currdepth = varDepth;
                end
            end
        end
        newdepth = currdepth+1;
    end
    
    % If maxdepth is exceeded, return a dummy anon
    if newdepth > maxdepth
        ADH = dummyAnon;
        return
    end
    
    % If not, continue and create the anon properly  
    ADH.function = varargin{1};
    ADH.variablesName = varargin{2};
    ADH.workspace = varargin{3};
    ADH.type  = varargin{4};  % Type of anon. 1 for AD, 2 for regular @(u) anons.
    ADH.depth = newdepth;

    
    % Convert struct to anon object
    ADH = class(ADH,'anon');
else % If AD is turned off, return a dummy anon
    ADH = dummyAnon;
end
end
