function g = inv(f,varargin)
% INV Invert a chebfun
%  G = INV(F) will attempt to invert the monotonic chebfun F.
%  If F has zero derivatives at its endpoints, then it is advisable
%  to turn Splitting ON.
%
%  G = INV(F,'SPLITTING','ON') will turn Splitting ON for the inv command.
%
%  Note, this function is experimental and slow!
%
%  Example: 
%   x = chebfun('x');
%   f = sign(x) + x;
%   g = inv(f,'splitting',true);
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

% no quasimatrix support
if numel(f) > 1
    error('chebfun:inv:noquasi','no support for quasimatrices');
end

split_yn = [];
tol = chebfunpref('eps');

% parse input  
while numel(varargin) > 1
    if strcmpi(varargin{1},'splitting') && istrcmpi(varargin{2},'on')
        split_yn = true; 
    elseif strcmpi(varargin{1},'eps')
        tol = varargin{2};
    end
    varargin(1:2) = [];       
end

% local splitting on
if isempty(split_yn)
    split_yn = chebfunpref('splitting');
end

domainf = domain(f);

% turn splitting on if F is piecewise.
if length(f.ends) > 2 && ~(chebfunpref('splitting') || split_yn)
    split_yn = true;
end

% monotonic check
tpoints = roots(diff(f));
if ~isempty(tpoints) 
    endtest = zeros(length(tpoints),1);
    for k = 1:length(tpoints)
        endtest(k) = min(abs(tpoints(k)-domainf.ends));
    end
    if any(endtest > 100*abs(feval(f,tpoints))*tol)
        error('chebfun:inv:notmonotonic','chebfun F must be monotonic its domain.');
    elseif ~(chebfunpref('splitting') || split_yn)
         warning('chebfun:inv:singularendpoints', ['F is monotonic, but ', ...
         'INV(F) has singular endpoints. Suggest you try ''splitting on''.']);
    end
end

% compute the inverse
[domaing x] = domain(minandmax(f));
g = chebfun(@(x) op(f,x), domaing, 'resampling', 0,'splitting',split_yn,'eps',tol);

% scale so that the range of g is the domain of f
[rangeg gx] = minandmax(g);
g = g + (gx(2)-x)*(domainf(1)-rangeg(1))/diff(gx) ...
      + (x-gx(1))*(domainf(2)-rangeg(2))/diff(gx);
  
function r = op(f,x)
tol = chebfunpref('eps');
r = zeros(length(x),1);
% Vectorise
for j = 1:length(x)
    temp = roots(f-x(j));
    if length(temp) ~= 1
        fvals = feval(f,f.ends);
        err = abs(fvals-x(j));
        [temp k] = min(err);
        if err(k) > 100*tol*abs(fvals(k));
            error('chebfun:inv:notmonotonic2','chebfun must be monotonic');
        end
    end
    r(j,1) = temp;
end


