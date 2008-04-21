function Fout = vertcat(varargin)
% Vertcat   Chebfun horizontal concatenation.
%   [F1; F2] is the horizontal concatenation of chebfun quasi-matrices F1 and F2.
%
%   For column chebfuns, F = VERTCAT(F1,F2,...) concatenates any number
%   of chebfuns by translating their domains to, in effect, create a
%   piecewise defined chebfun F.
%
%   For row chebfuns, F = VERTCAT(F1,F2,...) returns a quasi-matrix whose
%   rows are F1, F2, ....
%
%   See also CHEBFUN/HORZCAT, CHEBFUN/SUBSASGN.
%

% Chebfun Version 2.0

for i=1:nargin
    Fout = varargin{i};
    if ~isempty(Fout), break; end
end
%Fout = varargin{1};
if Fout(1).trans
   Fout = builtin('horzcat',varargin{:});
else
    
    % Deal with Quasi-matrices:

    for k = i+1:nargin
        f2 = varargin{2};
        if size(Fout,2) ~= size(f2,2) || size(f2,1) > 2
            error('CAT arguments dimensions are not consistent or number of rows>1. Try horzcat?')
        else
            for j = 1:numel(f2)
                Fout(j) = vertcatcol(Fout(j),f2(j));
            end
        end
    end
    
end


% ----------------------------------------------
function f = vertcatcol(varargin)

if nargin == 0
  f = chebfun;
  return
end

f = chebfun;
for k = 1:nargin
  newf = varargin{k};
  if ~isempty(newf)
    if isempty(f)           % found the first nonempty case
      f = newf;
    else                    % append to current f
      delta = f.ends(end) - newf.ends(1);    
      f.ends = [ f.ends delta+newf.ends(2:end) ];    % translate domain
      f.funs = [f.funs, newf.funs];
      f.imps = [ f.imps newf.imps(2:end) ];
    end
  end
end
f.nfuns = numel(f.funs);