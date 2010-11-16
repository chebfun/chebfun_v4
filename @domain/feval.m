function E = feval(d,s)
% FEVAL  Evaluation functional.
% E = FEVAL(D,S) returns a linop representing the functional of evaluation
% of a chebfun at the points in vector S. If f is a chebfun also defined on
% the domain D, then E*f will return a length(S)-by-1 vector equal to 
% f(S(:)).
%
% Example:
%
% E = feval(domain(-1,2),[-1;0;2]);  % evaluate at endpoints and one other
% E(5)   % note first and last rows are like the identity
%   ans =
%      1.0000e+000  1.6653e-016 -5.5511e-017 -1.1102e-016            0
%     -1.7284e-001  6.1656e-001  6.9136e-001 -2.2150e-001  8.6420e-002
%                0 -1.9429e-016  8.3267e-017 -1.1102e-016  1.0000e+000
%
% f = chebfun(@(x) cos(x)./(1+x.^2),[-1 2]); 
% format long, [f([-1;0;2]), E*f]
%   ans =
%      0.270151152934070   0.270151152934070
%      1.000000000000000   1.000000000000000
%     -0.083229367309428  -0.083229367309428
%
% See also linop, chebfun/feval.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2010 by Toby Driscoll.

%  Last commit: $Author$ $Rev$
%  $Id$

a = d.ends(1);  b = d.ends(end);
x = 2*(s(:)-a)/(b-a) - 1;
E = linop(@mat2,@(u) feval(u,s(:)),d);

    function P = mat2(n)
        breaks = []; map = [];
        if iscell(n)
            if numel(n) > 1, map = n{2}; end
            if numel(n) > 2, breaks = n{3}; end
            n = n{1};
        end
        
        % Force a default map for unbounded domains.
        if any(isinf(d)) && isempty(map), map = maps(d); end
        % Inherit the breakpoints from the domain.
        breaks = union(breaks, d.ends);
        if isa(breaks,'domain'), breaks = breaks.ends; end
        if numel(breaks) == 2 && all(breaks==d.ends([1 end]))
            % Breaks are the same as the domain ends. Set to [] to simplify.
            breaks = [];
        elseif numel(breaks) > 2
            numints = numel(breaks)-1;
            if numel(n) == 1, n = repmat(n,1,numints); end
            if numel(n) ~= numints
                error('DOMAIN:feval:numints','Vector N does not match domain D.');
            end
        end
        
        if isempty(map) && isempty(breaks)
            % Standard case
            P = barymat(x,chebpts(n));
        elseif isempty(breaks)
            % Map / no breaks
            if isstruct(map), map = map.for; end
            P = barymat(x,map(chebpts(n)));
        elseif isempty(map)
            % Breaks / no map
            P = barymatp(x,chebpts(n,breaks));
        else
            % Breaks and maps
            csn = [0 cumsum(n)];
            P = zeros(csn(end));
            if iscell(map) && numel(map) == 1
                map = map{1};
            end
            mp = map;
            for k = 1:numints
                if numel(map) > 1
                    if iscell(map), mp = map{k}; end
                    if isstruct(map), mp = map(k); end
                end
                if isstruct(mp), mp = mp.for; end
                ii = csn(k)+(1:n(k));
                P(ii,ii) = barymat(x,mp(chebpts(n(k))));
            end
        end   
    end

%   function A = mat(N)
%       if iscell(N), N = N{1}; end
%     C = cd2cpm(N);   % Cheb point values to polynomial coeffs
%     T = cos( acos(x)*(0:N-1) );    % poly coeffs to values at points
%     A = T*C;
%   end

end

function C = cd2cpm(N)
% Matrix to convert values at Cheb points to Cheb poly coefficients.

% Three steps: Double the data around the circle, apply the DFT matrix,
% and then take half the result with 0.5 factor at the ends.
N1 = N-1;
theta = (pi/N1)*(0:2*N1-1)';
F = exp( -1i*theta*(0:2*N1-1) );  % DFT matrix
rows = 1:N;  % output upper half only
% Impose symmetries on data and coeffs.
C = real( [ F(rows,N) F(rows,N1:-1:2)+F(rows,N1+2:2*N1) F(rows,1) ] );
C = C/N1;  C([1 N],:) = 0.5*C([1 N],:);
end