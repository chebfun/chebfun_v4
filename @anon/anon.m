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
% differentiation in the chebfun system and is therefore lightly
% documented. It is intented to be used in the overloaded functions in the
% @chebfun directory.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team.
maxdepth = chebfunpref('addepth');

% Store a persistent dummy anon
persistent dummyAnon

if isempty(dummyAnon)
    dummyAnon(1).function = [];
    dummyAnon(1).variablesName = [];
    dummyAnon(1).workspace = [];
    dummyAnon(1).depth = maxdepth;
    dummyAnon = class(dummyAnon,'anon');
end
if maxdepth % If maxdepth == 0, AD is turned off
    % Begin by checking whether we will be exceeding the maxdepth
    if nargin > 3
        newdepth = varargin{4};
    else
        currdepth = 0;
        for vararginCounter = 1:length(varargin{3})
            currVar = varargin{3}{vararginCounter};
            if isa(currVar,'chebfun')
                varDepth = currVar.jacobian.depth;
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
    ADH = struct([]);
    
    ADH(1).function = varargin{1};
    ADH(1).variablesName = varargin{2};
    ADH(1).workspace = varargin{3};
    ADH(1).depth = newdepth;
    
    % Convert struct to anon object
    ADH = class(ADH,'anon');
else % If AD is turned off, return a dummy anon
    ADH = dummyAnon;
end
end