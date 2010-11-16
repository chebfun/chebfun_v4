function Fout = vertcat(varargin)
% Vertcat   Chebfun vertical concatenation.
%   [F1; F2] is the vertical concatenation of chebfun quasimatrices F1 and F2.
%
%   For column chebfuns, F = VERTCAT(F1,F2,...) concatenates any number
%   of chebfuns by translating their domains to, in effect, create a
%   piecewise defined chebfun F.
%
%   For row chebfuns, F = VERTCAT(F1,F2,...) returns a quasimatrix whose
%   rows are F1, F2, ....
%
%   See also CHEBFUN/HORZCAT, CHEBFUN/SUBSASGN.
%
%   See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

thereisdouble = false;
for i = 1:nargin
    Fout = varargin{i};
    if ~isempty(Fout) && isa(Fout,'chebfun') , break; end
    if isa(Fout,'double'), thereisdouble = true; end
end


if Fout(1).trans

    d = domain(Fout(1));
    
    % Check for doubles, empty and whether chebfuns are consistent.
    kk =[];
    for k = 1:nargin
        v = varargin{k};
        if ~isempty(v)
            kk =[kk k];
            if isa(v,'double') && ~isempty(v)
                f = chebfun(v,d.ends);
                f.trans = true;
                varargin{k} = f;
            elseif isa(v,'chebfun')
                if ~v(1).trans
                    error('CHEBFUN:vertcat:dims','CAT arguments dimensions are not consistent.')
                elseif  ~(domain(v(1))==d)
                    error('CHEBFUN:vertcat:doms','Domains are not consistent.');
                end
            end
        end
    end
   
   % VERTCAT!
   Fout = builtin('vertcat',varargin{kk});
      
else      
        
    if thereisdouble
         error('CHEBFUN:vertcat:inargs','Incorrect input arguments.')  % Cannot Tobycat doubles with chebfuns
    end
    
    % TOBYCAT!
    % Deal with Quasi-matrices:
    for k = i+1:nargin
        f2 = varargin{k};
        if isa(f2,'chebfun')
            if size(Fout,2) ~= size(f2,2)
                error('CHEBFUN:vertcat:argsorrows','CAT arguments dimensions are not consistent or number of rows>1. Try horzcat?')
            else
                for j = 1:numel(f2)
                    Fout(j) = vertcatcol(Fout(j),f2(j));
                end
            end
        else
            error('CHEBFUN:vertcat:numinargs','Incorrect input arguments.')  % Cannot Tobycat doubles with chebfuns
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
      newends = delta+newf.ends;
      for j = 1:newf.nfuns  % update maps in funs!
          newf.funs(j) = newdomain(newf.funs(j), newends(j:j+1));
      end
      f.ends = [f.ends newends(2:end)];    % translate domain
      f.funs = [f.funs, newf.funs];
      f.imps = [f.imps(1:end-1) newf.imps(1:end)];
    end
  end
end
f.nfuns = numel(f.funs);
