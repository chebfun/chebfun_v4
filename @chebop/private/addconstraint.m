function A = addconstraint(A,idx,varargin)

% ADDCONSTRAINT(A,I)
% ADDCONSTRAINT(A,I,VAL)
% ADDCONSTRAINT(A,I,ROW)
% ADDCONSTRAINT(A,I,ROW,VAL)
% ADDCONSTRAINT(A,'first'[,VAL])
% ADDCONSTRAINT(A,'last'[,VAL])
% ADDCONSTRAINT(A,'ends'[,VAL])

if ischar(idx)
  switch(lower(idx))
    case {'first','left'}
      idx = @(n) 1;
    case {'last','right'}
      idx = @(n) n;
    case 'ends'
      idx = @(n) [1;n];
  end
elseif isnumeric(idx)
  idx = @(n) idx;
end

ncond = length(idx(1));

val = [];
row = [];

% Parse the inputs.
if nargin > 2
  if isa(varargin{1},'function_handle') || isa(varargin{1},'chebop')
    row = varargin{1};
    if nargin > 3
      val = varargin{2};
    end
  else
    val = varargin{1};
  end
end

% What are the replacement rows?
if isempty(row)
  row = @eye;   % Dirichlet replacement
elseif isa(row,'chebop')
  % Realize a size-n matrix for any n.
  row = @(n) feval(row,n);
  %row = @(n) subsref( row, struct('type','()','subs',{{n}}) );
end

% We may have been given just the rows we need, OR we may have been given a
% full matrix (e.g. eye or chebop). In the latter case, use a wrapper to
% extract the correct rows.
test = row(ncond+1);   % Does it have just ncond rows?
if size(test,1) > ncond
  % Wrap it inside a subsref. Why does MATLAB make this syntax hard?
  row = @(n) subsref( row(n), struct('type','()','subs',{{idx(n),':'}}) );
end
 
% Check out RHS replacement values. Default to zero, or vectorize if needed.
if isempty(val)
  val = zeros(ncond,1);
elseif length(val)==1
  val = repmat(val,[ncond,1]);
end

A.constraint(end+1).idx = idx;
A.constraint(end).row = row;
A.constraint(end).val = val;
