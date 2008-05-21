function x = linspace(d,varargin)
% LINSPACE Linearly spaced points in a domain. 
% LINSPACE(D,M) returns a vector of M points linearly spaced in the domain
% D. If omitted, M defaults to 100.

if isempty(d)
  x = [];
else
  x = linspace(d.ends(1),d.ends(end),varargin{:});
end

end