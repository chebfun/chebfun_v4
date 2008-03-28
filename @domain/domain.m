function r = domain(varargin)

% domain(a,b) or domain([a,b]) or domain([a,b,c,d]).

if nargin==0
  e = [];
elseif nargin==1
  e = varargin{1};
else
  e = cat(2,varargin{:});
end

r.ends = e;

superiorto('double');
r = class(r,'domain');