classdef anon < handle
    
    properties
        func = []
        variablesName = [];
        workspace = [];
        type  = 1;  % Type of anon. 1 for AD, 2 for regular @(u) anons.
        depth = [];
        parent = [];
    end
    
    methods
        function a = anon(varargin)
            maxdepth = chebfunpref('ADdepth');
            
            % Begin by checking whether we will be exceeding the maxdepth
            if nargin == 0 || ~maxdepth
                return
            elseif nargin > 4 && isnumeric(varargin{5})
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
            
            if nargin > 4 && ischar(varargin{5})
                a.parent = varargin{5};
            end

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
