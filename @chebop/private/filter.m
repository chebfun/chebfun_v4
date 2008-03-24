function v = filter(v,thresh)

% Attempt to filter out a "noise plateau" falling below the given relative
% threshold.

% TAD, 4 March 2008.

n = length(v);
if n < 64, return, end

c = cd2cp(v);    % ascending degree
ac = abs(c)/norm(v,inf);

% Smooth using a windowed max.
maxac = ac;
for k=1:8
  maxac = max(maxac(1:end-1),ac(k+1:end));
end

% If too little accuracy has been achieved, do nothing.
t = find(maxac<thresh,1);
if isempty(t) || n-t < 16
  return
end

% Find where improvement in the windowed max seems to stop.
dmax = diff( conv( [1 1 1 1]/4, log(maxac(t:end)) ) );
mindmax = dmax;
for k = 1:2
  mindmax = min(mindmax(1:end-1),dmax(k+1:end));
end
%cut = t+k+8 + find(mindmax < 0.02*min(mindmax), 1, 'last');
cut = find(mindmax > 0.01*min(mindmax), 3);
cut = cut(end) + t + k + 8;
c(cut:end) = 0;
v = cp2cd(c);

% % Try to identify a leading flat region. 
% T = max( 10, n/20 );  % block size
% k = (1:T)';
% p = polyfit(k,log(ac(k)),1);
% slope = p(1);
% while (slope < .005) && (k(end)+T<=n)
%   c(k) = 0;
%   k = k+T;
%   p = polyfit(k,log(ac(k)),1);
%   slope = p(1);
% end
    


% % Uses an explicit formula for the slopes of
% % the 'cumulative least squares fit'.
% T = (1:2*t)';
% logac = log(ac(T));
% slopes = ( cumsum(T.*logac) - (T+1)/2.*cumsum(logac) ) * 12 ./ (T.*(T.^2-1));
% slopes([1 end]) = 1;   % skip the first, guarantee the last
% if all(slopes(1:6) > 0.05)
%   tmax = 0;
% else
%   tmax = 5 + find( slopes(6:end) > 0.05, 1 );
% end
% c(1:tmax) = 0;


% locmax = [false; ( diff(sign(diff(logac))) < 0 ); false ];
% slope = 0;
% % tnew = find(locmax,8);
% % if length(tnew) < 8
% %   tnew = Inf;
% % else
% %   tnew = tnew(end);
% % end
% tnew = 8; t = 0;
% while (tnew*abs(slope) < -log(.05)) && (tnew < n)
%   tnew = ceil(1.5*t);
%   t = tnew;
%   k = (1:t)';
%   if sum(k) > 10
%     p = polyfit( k, logac(k), 1 );
%     slope = p(1);
%   end
% end
% c(1:t) = 0;

% v = cp2cd(flipud(c));

end