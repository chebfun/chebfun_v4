classdef (InferiorClasses = {?double}) domain
% DOMAIN  Domain object constructor. D = DOMAIN(A,B) or DOMAIN([A,B])
% creates a domain object for the real interval [A,B].
%
% D = DOMAIN(V) for vector V of length at least 2 creates a domain for
% the interval [V(1),V(end)] with breakpoints at V(2:end-1).

% Copyright 2011 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

    properties
        ends = [];
    end

    methods
        function d = domain(varargin)

            if nargin == 0
                return
            elseif isa(varargin{1},'domain')
                d = varargin{1};
                return
            end
            
            v = cat(2,varargin{:});     % Concatenate muli-inputs
            if (length(v) > 1) && (v(end) < v(1))
                v = [];                 % Empty interval
            end

            d.ends = v;
        end

    end

end