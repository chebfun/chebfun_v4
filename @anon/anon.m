classdef anon < handle
    
    properties
        func = []
        variablesName = [];
        workspace = [];
        type  = 1;  % Type of anon. 1 for AD, 2 for regular @(u) anons.
        depth = [];
    end
    
    methods
        function a = anon(varargin)
            maxdepth = chebfunpref('ADdepth');
            
            % Begin by checking whether we will be exceeding the maxdepth
            if nargin == 0 || ~maxdepth
                return
            elseif nargin > 4
                newdepth = varargin{5};
            else
                currdepth = 0;
                for vararginCounter = 1:length(varargin{3})
                    currVar = varargin{3}{vararginCounter};
                    if isa(currVar,'chebfun')
                        varDepth = getdepth(currVar);
                        if varDepth > currdepth
                            currdepth = varDepth;
                        end
                    end
                end
                newdepth = currdepth+1;
            end
            
            % If maxdepth is exceeded, return an empty anon
            if newdepth > maxdepth
                a.depth = maxdepth;
                return
            end
            
            % If not, continue and create the anon properly
            a.func = varargin{1};
            a.variablesName = varargin{2};
            a.workspace = varargin{3};
            a.type  = varargin{4};
            a.depth = newdepth;

        end

%         function d = getdepth(an)
%         % GETDEPTH Obtain the AD depth of an anon
%         % D = GETDEPTH(AN) returns the depth of the anon AN.
% 
%         % Copyright 2011 by The University of Oxford and The Chebfun Developers. 
%         % See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.
% 
%         d = an.depth;
%         end

end
    
end


%
%
% function a = anon(varargin)
% % ANON Anon object constructor.
% %
% % A = anon('function','variables name', variables) creates an anon object
% % which behaves in a similar way to anonymous functions.
% %
% % Example:
% %   [d,x] = domain(0,1)
% %   A  = anon('@(u) u*sin(x)','x',x)
% % creates the anon A which behaves in a similar way to the anonymous
% % function F created by
% %   F  = @(u) u*sin(x)
% %
% % The anon class is a support class for working with automatic
% % differentiation in Chebfun and is therefore lightly
% % documented. It is intented to be used in the overloaded functions in the
% % @chebfun directory.
%
% % Copyright 2011 by The University of Oxford and The Chebfun Developers.
% % See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information.
%
% maxdepth = chebfunpref('ADdepth');
%
% % Store a persistent dummy anon
% persistent dummyAnon
%
% if isempty(dummyAnon)
%     dummyAnon.function = [];
%     dummyAnon.variablesName = [];
%     dummyAnon.workspace = [];
%     dummyAnon.type  = 1;
%     dummyAnon.depth = maxdepth;
%     dummyAnon = class(dummyAnon,'anon');
% end
% if maxdepth % If maxdepth == 0, AD is turned off
%     % Begin by checking whether we will be exceeding the maxdepth
%     if nargin > 4
%         newdepth = varargin{5};
%     else
%         currdepth = 0;
%         for vararginCounter = 1:length(varargin{3})
%             currVar = varargin{3}{vararginCounter};
%             if isa(currVar,'chebfun')
%                 varDepth = getdepth(currVar);
%                 if varDepth > currdepth
%                     currdepth = varDepth;
%                 end
%             end
%         end
%         newdepth = currdepth+1;
%     end
%
%     % If maxdepth is exceeded, return a dummy anon
%     if newdepth > maxdepth
%         a = dummyAnon;
%         return
%     end
%
%     % If not, continue and create the anon properly
%     a.function = varargin{1};
%     a.variablesName = varargin{2};
%     a.workspace = varargin{3};
%     a.type  = varargin{4};  % Type of anon. 1 for AD, 2 for regular @(u) anons.
%     a.depth = newdepth;
%
%
%     % Convert struct to anon object
%     a = class(a,'anon');
% else % If AD is turned off, return a dummy anon
%     a = dummyAnon;
% end
% end
