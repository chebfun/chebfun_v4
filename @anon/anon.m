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


ADH = struct([]);

% Begin by checking whether any input function has a maxsize memory flag.
% If so, all derived functions will also be flagged, so no need to do all
% the work involved in creating an anon.
maxFlag = 0;
for argCounter = 1:length(varargin{3})
    arg = varargin{3}{argCounter};
    if isa(arg,'chebfun')
        funJacobian = get(varargin{3}{argCounter},'jacobian');
        if strmatch(funJacobian.function,'max_memsize')
            maxFlag = 1;
        end
    end
end

if maxFlag
   ADH(1).function = 'max_memsize';
   ADH(1).variablesName = [];
   ADH(1).workspace = [];
   ADH = class(ADH,'anon');
   return;
end

ADH(1).function = varargin{1};
ADH(1).variablesName = varargin{2};
ADH(1).workspace = varargin{3};

whosADH = whos('ADH');
sizeADH = whosADH.bytes/(1024^2); % Size in MB

if sizeADH < 100
    ADH = class(ADH,'anon');
else
    % Clear the fields and return a dummy anon
    ADH(1).function = 'max_memsize';
    ADH(1).variablesName = [];
    ADH(1).workspace = [];
    ADH = class(ADH,'anon');
end
