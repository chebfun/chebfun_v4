function s = char(V,dom)
% CHAR  Convert varmat to pretty-print string.

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information..

defreal = 6;

if isempty(V.defn)
  s = '   []';
else 
  if nargin == 1
      s1 = ['   with n = ',int2str(defreal),' realization:'];
      try
          s2 = num2str(feval(V,defreal),'  %8.4f');
      catch
          s2 = 'WARNING - varmat cannot be displayed. Possibly piecewise.';
      end
  else
      numints = numel(dom.endsandbreaks);
      defreal = max(2,ceil(defreal/(numints-1)));
      s1 = ['   with n = ',int2str(defreal),' realization:'];
      s2 = num2str(feval(V,{defreal,[],dom}),'  %8.4f');
  end
  space = ' ';
  s2 = [ repmat(space,size(s2,1),5) s2 ];
  s = char(s1,'',s2);
end
  