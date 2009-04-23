function names = fieldnames(g,varargin)
% Returns the list of public member variable names
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if nargin == 1
    names = {'vals' 'n' 'scl'}';
else
    switch varargin{1}
        case '-full'
            names = {'vals % double array' ...
                'n % double array' 'scl % struct array' }';
        case '-possible'
            names = {'vals' {{'double array (nx1)'}} ...
                'n' {{'double array (1x1)'}}...
                'scl' {{'struct array (1x1)'}}};
        otherwise
            error('Unsupported call to fieldnames');
    end
end