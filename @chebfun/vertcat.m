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

thereisdouble = false;
for i = 1:nargin
    Fout = varargin{i};
    if ~isempty(Fout) && isa(Fout,'chebfun') , break; end
    if isa(Fout,'double'), thereisdouble = true; end
end


if Fout(1).trans

    d = domain(Fout(1));
    
    % Check for doubles and whether chebfuns are consistent.
    for k = 1:nargin
        v = varargin{k};
        if isa(v,'double') && ~isempty(v)
           f = chebfun(v,d(:)); 
           f.trans = true;
           varargin{k} = f;
        elseif isa(v,'chebfun') 
            if ~v(1).trans
               error('CAT arguments dimensions are not consistent.')     
            elseif ~(domain(v(1))==d)
               error('Domains are not consistent');
            end
        end
    end
   
   % VERTCAT!
   Fout = builtin('vertcat',varargin{:});
      
else      
        
    if thereisdouble
         error('Incorrect input arguments')  % Cannot Tobycat doubles with chebfuns
    end
    
    % TOBYCAT!
    % Deal with Quasi-matrices:
    for k = i+1:nargin
        f2 = varargin{k};
        if isa(f2,'chebfun')
            if size(Fout,2) ~= size(f2,2)
                error('CAT arguments dimensions are not consistent or number of rows>1. Try horzcat?')
            else
                for j = 1:numel(f2)
                    Fout(j) = vertcatcol(Fout(j),f2(j));
                end
            end
        else
            error('Incorrect input arguments')  % Cannot Tobycat doubles with chebfuns
        end
    end
    
end


% ----------------------------------------------
% Tobycat (vertcat in version 2007a)
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
      f.imps = [f.imps(1:end-1) newf.imps(1:end) ];
    end
  end
end
f.nfuns = numel(f.funs);
