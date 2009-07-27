function waterfall(u,varargin)
%WATERFALL Waterfall plot for quasimatrices.
%
%  See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

%  Copyright 2002-2009 by The Chebfun Team. 
%  Last commit: $Author$: $Rev$:
%  $Date$:

n = size(u,2);
if isinf(n), error('chebfun:waterfall:notrow','No support for row quasimatrices'); end
t = 1:n;

if nargin > 1 && isnumeric(varargin{1}) && size(varargin{1},2) == size(u,2)
    t = varargin{1};
    varargin = {varargin{2:end}};
end

if ~isreal(u) || ~all(isreal(t))
    warning('chebfun:waterfall:imaginary',...
        'Imaginary parts of complex T and/or U arguments ignored');
    u = real(u); t = real(t);
end

% [data1 data2 data3] = plot(u,'noplot');
% xx = []; uu = [];
% for k = 1:3:length(data1);
%     xx = [xx data1{k}];
%     uu = [uu data1{k+1}];
% end
% tt = repmat(t,length(data1{1}),1);
% waterfall(xx.',tt.',uu.',varargin{:})


data1 = plotdata([],u,[],20);
xx = []; uu = [];
for k = 1:3:length(data1);
    xx = [xx data1{k}];
    uu = [uu data1{k+1}];
end
tt = repmat(t,length(data1{1}),1);
xx = repmat(xx,1,length(t));

size(uu)
size(xx)
size(tt)
waterfall(xx.',tt.',uu.',varargin{:})









% h = ishold;
% hold on
% for k = 1:n
% 
%     ends = u(:,k).ends;
%     uk = []; xk = [];
%     for j = 1:u(:,k).nfuns
%         uk = [uk u(:,k).funs(j).vals];
%         xk = [xk ; chebpts(u(:,k).funs(j).n,domain(ends(j),ends(j+1)))];
%     end
%     
%     tk = t(k) + 0*xk;
%     plot3(xk,tk,uk,varargin{:},'linestyle','none'); hold on
%     
%     xx = linspace(ends(1),ends(end),max(200,pi*length(u(:,k))));
%     uu = feval(u(:,k),xx);
%     tt = t(k) + 0*xx;
%     plot3(xx,tt,uu,varargin{:},'marker','none'); hold on
%     
% end
% if ~h, hold off, end