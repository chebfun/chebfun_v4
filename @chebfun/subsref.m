function varargout = subsref(f,index)
% SUBSREF   Evaluate a chebfun.
% F(X) returns the values of the chebfun F evaluated on the array X. The 
% function at the right of a breakpoint x is used for the evaluation of F
% on x.
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

idx = index(1).subs;
switch index(1).type
    case '.'
        if numel(f) > 1
            error('CHEBFUN:SUBSREF:QUASIMATRIX', ...
                'Subsref does not support ''.'' notation for chebfun quasimatrices.');
        end
        varargout = { get(f,idx) };
    case '()'
        % --- transpose row chebfuns/quasimatrices -------
        if get(f,'trans')   
            n = size(f,1);
            if length(idx) > 1,   s = idx{2}; % where to evaluate 
            else                  s = idx{1};            end
        else
            n = size(f,2);
            s = idx{1}; % where to evaluate
        end     
        % ---- read input arguments -----------------------------
        varin = {};
        if length(idx) == 1 
            % f(s), where s can be vector, domain, or ':'
            % syntax is not allowed when f is a quasimatrix
            if n ~= 1 && isnumeric(s)
               error('CHEBFUN:subsasgn:dimensions',...
                   'Index missing for quasi-matrix assignment.')
            end
        elseif length(idx) == 2
            % f(s,:), f(:,s), or, 
            if any(strcmpi(idx{2},{'left','right'}))
                varin = {idx(2)};
            elseif get(f,'trans')
                f = f(cat(2,idx{1}),:);
            else
                f = f(:,cat(2,idx{2}));
            end 
        elseif length(idx) == 3
            if any(strcmpi(idx{3},{'left','right'}))
                varin = {idx(3)};
            else
                error('CHEBFUN:subsref:dimensions',...
                'Index exceeds chebfun dimensions.')
            end
            if get(f,'trans')
                f = f(cat(2,idx{1}),:);
            else
                f = f(:,cat(2,idx{2}));
            end             
        else
            error('CHEBFUN:subsref:dimensions',...
                'Index exceeds chebfun dimensions.')
        end
        % ---- assign values/chebfuns at given points/domains ---        
        if isnumeric(s)
            varargout = { feval(f,s,varin{:}) };
        elseif isa(s,'domain')
            f = restrict(f,s);            
            varargout = { f };
        % RodP added this here for composition of chebfuns (May 2009) -----    
        elseif isa(s,'chebfun') || isa(s,'function_handle')
            varargout = { compose(f,s) };
        % -----------------------------------------------------------------
        elseif isequal(s,':')
            varargout = { f }; 
        else
            error('CHEBFUN:subsref:nonnumeric',...
              'Cannot evaluate chebfun for non-numeric type.')
        end       
    case '{}'
        if length(idx) == 1
            if isequal(idx{1},':')
                s = domain(f); 
            else
                error('CHEBFUN:subsref:baddomain',...
                    'Invalid domain syntax.')
            end
        elseif length(idx) == 2
            s = domain(cat(2,idx{:}));
        else
            error('CHEBFUN:subsasgn:dimensions',...
                'Index exceeds chebfun dimensions.')
        end
        varargout = { restrict(f,s) };        
    otherwise
        error('CHEBFUN:UnexpectedType',['??? Unexpected index.type of ' index(1).type]);
end



if length(index) > 1
    varargout = {subsref([varargout{:}], index(2:end))};
end  

if numel(varargout) > 1 && nargout <= 1
   if iscellstr(varargout) || any(cellfun('isempty',varargout))
       varargout = {varargout};
   else
       try
           varargout = {[varargout{:}]};
       catch
           varargout = {varargout};
       end
   end
end
