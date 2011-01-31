function out = movie(F,varargin)
% MOVIE  Animate columns of a quasimatrix.
% MOVIE(F) displays an animation of frames produced by plotting the columns 
% of the quasimatrix F in sequence.
%
% MOVIE(F,T) interprets T as a vector of times corresponding to the columns
% of F, and adds a title to each frame showing the time. 
%
% MOVIE(F,'PROP1',VAL1,...) or MOVIE(F,T,'PROP1',VAL1,...) uses
% property/value pairs to modify the appearance of the movie. The
% properties understood by MOVIE are:
%
%    'xlim': x-axis limits (defaults to DOMAIN(F))
%    'ylim': y-axis limits (defaults to 'auto' for each frame)
%    'xlabel','ylabel': labels for the axes (defaults to '')
%    'timefmt': format string for the running title (defaults to '' if T is
%                       not given, 'Time = %#5.3g' otherwise)
%    'pause': time in seconds to pause between frames (defaults to 0)
%    'figure': handle of the movie figure (defaults to gcf)
%
% Any unrecognized property/value pair is passed along to PLOT for each
% frame, so you can set line colors, widths, etc. 
%
% M = MOVIE(F,...) returns a movie object suitable for the built-in MOVIE
% or MOVIE2AVI. Each frame captures the figure, not the axes, so use
% MOVIE(GCF,M) to show the movie object properly in the current figure.
%
% Examples:
%   for n = 1:40, f(:,n) = chebfun(@(x) sin(n*pi*x)); end
%   movie(f,'ylim',[-1.1 1.1],'linewidth',2,'timefmt','Frequency = %2i')
%
%   for n = 1:100, f(:,n) = chebfun(@(x) sin(exp(n/20*x))); end
%   movie(f,(1:100)/20,'ylim',[-1.1 1.1],'timefmt','sin( exp(%.2f*x) )')
%
%   t = -4:0.05:4;  c = 2;
%   soliton = @(x,t) c/2*sech(sqrt(c)/2*(x-c*t)).^2;   
%   for n = 1:length(t),s(:,n)=chebfun(@(x)soliton(x,t(n)),[-3 3]); end
%   movie(s,t,'ylim',[0 c/2])
%
% See also CHEBFUN/PLOT, MOVIE, MOVIE2AVI.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

if isinf(size(F,2)), F=F.'; end  % force column quasimatrix

% Look for a time vector.
t = [];
if nargin > 1 && isnumeric(varargin{1})
  t = varargin{1};
  varargin(1) = [];
end

% Catch a potential error.
if ~isempty(t) && length(t)~=size(F,2)
  error('chebfun:movie:timesize',...
    'Length of the time vector must equal the finite size of the quasimatrix.')
end

% Default options.
d = domain(F);
opt = struct('xlim',[d(1) d(2)],'ylim','auto',...
  'pause',0,...
  'timefmt','',...
  'figure',gcf,...
  'xlabel','','ylabel','');
if ~isempty(t)
  opt.timefmt = 'Time = %#5.3g';
end

% Parse options (must come as prop/value pairs).
k = 1;
plotargs = {};
while k < length(varargin)
  switch lower(varargin{k})  % locally recognized, or send to PLOT?
    case {'xlim','ylim','pause','timefmt','figure','xlabel','ylabel'}  
      opt.(varargin{k}) = varargin{k+1};
    otherwise                                        
      plotargs(end+1:end+2) = varargin(k:k+1);
  end
  k = k+2;
end

% Plotting loop.
figure(opt.figure)
M = make_frame(1,[]);
for j = 1:size(F,2)
  pause(opt.pause)
  clf reset  % chebfun-rendered objects can be very sticky...
  M = make_frame(j,M);
end

if nargout > 0, out=M; end
  

  % Actual plotting work is done here.
  function M = make_frame(n,M)
    plot(F(:,n),plotargs{:})
    xlim(opt.xlim), ylim(opt.ylim)
    xlabel(opt.xlabel), ylabel(opt.ylabel)
    if ~isempty(opt.timefmt)  % will there be a title? 
      if isempty(t)
        tstr = sprintf(opt.timefmt,n);
      else
        tstr = sprintf(opt.timefmt,t(n));
      end
      title(tstr)
    end
    drawnow
    if nargout > 0, M(n) = getframe(gcf); end
  end

end