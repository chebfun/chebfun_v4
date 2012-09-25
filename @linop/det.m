function d = det(L,tol)
%DET    Determinant of a linop
% Compute the determinant of a linear operator.
%
% Example: 
%   dom = domain(-1,1);
%   F = fred(@(x,y) sin(x-y),dom)+eye(dom);
%   d = det(F);

% Copyright 2011 by The University of Oxford and The Chebfun Developers. 
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.

% For differential operators the determinant will be +/- infinity.
if any(L.difforder > 1), d = inf; return, end

if nargin < 2, tol = 100*chebfunpref('eps'); end  % Aim for this tolerance

% Choose a sensible number of points to discretise at (same as growfun)
maxn = cheboppref('maxdegree');
l2n = log2(maxn-1);
maxn = 2.^ceil(l2n)+1;
maxpower = max(4,floor(log2(maxn-1)));
npn = max(min(maxpower,6),3);
nn = 1 + round(2.^[ (3:npn) (2*npn+1:2*maxpower)/2 ]);
nn = nn + 1 - mod(nn,2);

% Initialise the stored value
d = 0; 
dold = inf;

for n = nn
    
    % Evaluate the operator on a Chebyshev grid
    d = det(feval(L,n));

    % Check for convergence
    err = abs(d-dold);
    ish = err <= tol;
    dold = d;

    % If happy, we're done!
    if ish, return, end

end

warning('LINOP:det:NoConverge',...
    ['Failed to converge with ',int2str(n),' points.\n' ...
     'Estimated error is ', num2str(err) '.'])
 
 

%%%%%%% ALTERNATIVE %%%%%%%%%%%
% % Some settings (sampletest, resampling, and maxdegree)
% pref = chebfunpref; 
% pref.sampletest = false;    % Sampletest won't work here
% pref.resampling = true;     % We don't want to reample either
% pref.splitting = false;     % No need for splitting..
% maxdegree = cheboppref('maxdegree');    % Set a sensible maxdegree
% pref.maxdegree = maxdegree;
% if nargin < 2, tol = 100*pref.eps; end  % Aim for this tolerance
% 
% % Initialise the stored value (will be set inside nested function)
% d = 0; dold = inf;

% Use the fun constructor to increase the sample size in a sensible way
% fun(@(x) detfun(x),[-1 1],pref);
% 
%     function y = detfun(x)
%         % Evaluate the operator on a Chebyshev grid
%         n = length(x);
%         d = det(feval(L,n));
%         
%         % Check for convergence
%         err = abs(d-dold);
%         ish = err <= tol;
%         dold = d;
%         
%         % Force unhappiness in vector returned to constructor
%         y = x;
%         if ~ish, 
%             y(2:2:end) = -y(2:2:end); % Sawtooth
%         end 
% 
%         if ~ish && n >= maxdegree
%             warning('LINOP:det:NoConverge',...
%                 ['Failed to converge with ',int2str(maxdegree+1),' points.\n' ...
%                  'Estimated error is ', num2str(err) '.'])
%         end
%        
%     end
            
            
        



