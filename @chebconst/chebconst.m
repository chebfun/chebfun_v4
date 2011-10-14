classdef chebconst < chebfun
    properties
    end
    
    methods 
        function obj = chebconst(varargin)
            obj = obj@chebfun(varargin{:});
        end
        
        function [L nonConst] = diff(varargin)
            if nargin > 1 && isa(varargin{2},'chebfun')
                [L nonConst] = diff@chebfun(varargin{:});
                if ~isfinite(length(L)) % L is inf x inf
                    L = full(diag(feval(L,1)));
                end
            else
                f = varargin{1}; 
                N = 1; dim = 1;
                if nargin > 1 && ~isempty(varargin{2}), N = varargin{2}; end
                if nargin > 2 && dim == varargin{2}; end
                if numel(f) == 1, L = constfun([],domain(f)); return, end
                L = f;
                for j = 1:N 
                   for k = 1:numel(L)-j
                       L(k) = L(k+1)-L(k);
                   end
                end
                L = L(1:numel(L)-j);
            end          
 
        end
        
        function g = double(f)
            n = numel(f);
            g = zeros(1,n);
            for k = 1:n
                v = get(f(k),'vals');
                g(k) = v(1);
            end
            if f(1).trans, g = transpose(g); end
        end
        
        function g = sum(f)
            g = constfun(0,domain(f));
            for k = 1:numel(f)
                g = plus(g,f(:,k));
            end
        end
        
        function g = feval(f,varargin)
            g = zeros(1,numel(f));
            if ~isempty(f) && get(f(1),'trans'), g = g.'; end
            for k = 1:numel(f)
                vals = get(f(k),'vals');
                g(k) = vals(1);
            end
        end
    end
end

    