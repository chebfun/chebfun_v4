function varargout = domain(f)
% DOMAIN Domain of definition
%
% I = DOMAIN(F) returns the domain of definition of the chebfun F. This
% includes breakpoint information.
% 
% [A,B] = DOMAIN(F) returns the endpoints of the domain.
%
% See also domain/domain.

%  Chebfun Version 2.0

if numel(f) == 1
    if isempty(f)
        varargout = {domain};
    elseif(nargout<=1)
        varargout{1} = domain(f.ends);
    else
        varargout{1} = f.ends(1);
        varargout{2} = f.ends(end);
    end
elseif nargout == 1
    error('For quasimatrices, use [a,b] = domain(F) instead.')
elseif nargout == 2
    varargout{1} = f(1).ends(1);
    varargout{2} = f(1).ends(end);
else
    varargout = {[f(1).ends(1),f(1).ends(end)]};
end
