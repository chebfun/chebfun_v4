function A = vertcat(varargin)  
% VERTCAT   Vertically concatenate oparrays.

% Copyright 2008 by Toby Driscoll. See www.comlab.ox.ac.uk/chebfun.

% Take out empties.
empty = cellfun( @(A) isempty(A), varargin );
varargin(empty) = [];

op = {};
for k = 1:length(varargin)
  opk = varargin{k}.op;
  op = vertcat(op,opk);
end

A = oparray(op);

end