function varargout = subsref(f,index)
% SUBSREF   Evaluate a chebfun.
% F(X) returns the values of the chebfun F evaluated on the array X. The 
% function at the right of a breakpoint x is used for the evaluation of F
% on x.

% Copyright 2002-2008 by The Chebfun Team. See www.comlab.ox.ac.uk/chebfun.
idx = index(1).subs;
switch index(1).type
    case '.'
        varargout = { get(f,idx) };
    case '()'
        % --- transpose row chebfuns/quasimatrices -------
        trans = 0;
        if get(f,'trans')   
            n = size(f,1);
            s = idx{2}; % where to evaluate
        else
            n = size(f,2);
            s = idx{1}; % where to evaluate
        end     
        % ---- read input arguments -----------------------------
        if length(idx) == 1
            % f(s), where s can be vector, domain or ':'
            % syntaxis not allowed when f is a quasimatrix
            if n ~= 1
                error('chebfun:subsasgn:dimensions',...
                    'Index missing for quasi-matrix assignment.')
            end
        elseif length(idx) == 2
            if get(f,'trans')
                f = f(cat(2,idx{1}),:);
            else
                f = f(:,cat(2,idx{2}));
            end
        else
            error('chebfun:subsref:dimensions',...
                'Index exceeds chebfun dimensions.')
        end
        % ---- assign values/chebfuns at given points/domains ---        
        if isnumeric(s)
            varargout = { feval(f,s) };
        elseif isa(s,'domain')
            f = restrict(f,s);            
            varargout = { f };
        elseif isequal(s,':')
            varargout = { f }; 
        else
            error('chebfun:subsref:nonnumeric',...
              'Cannot evaluate chebfun for non-numeric type.')
        end       
    case '{}'
        if length(idx) == 1
            if isequal(idx{1},':')
                s = domain(f); 
            else
                error('chebfun:subsref:baddomain',...
                    'Invalid domain syntax.')
            end
        elseif length(idx) == 2
            s = domain(cat(2,idx{:}));
        else
            error('chebfun:subsasgn:dimensions',...
                'Index exceeds chebfun dimensions.')
        end
        varargout = { restrict(f,s) };        
    otherwise
        error(['??? Unexpected index.type of ' index(1).type]);
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
