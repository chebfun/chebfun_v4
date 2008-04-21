function varargout = subsref(f,index)
% SUBSREF   subscripted reference
% F(X) returns the values of the chebfun F evaluated on the array X. The 
% function at the right of a breakpoint x is used for the evaluation of F
% on x.

% Ricardo Pachon and Lloyd N. Trefethen, 2007, Chebfun Version 2.0

switch index(1).type
    case '.'
        if isempty(f)
            varargout = {};
        else
            if numel(f) > 1
                error('Argument cannot be a quasi-matrix.')
            end
            switch index(1).subs
                case 'funs'
                    varargout = {f.funs};
                case 'ends'
                    varargout = {f.ends};
                case 'nfuns'
                    varargout = {f.nfuns};
            end
        end           
    case '()'
        if length(index.subs) == 1
            s = index.subs{1};
        elseif length(index.subs)== 2
            f = f(index.subs{2});
            s = index.subs{1};
        else
            error('chebfun:subsref:dimensions',...
                'Index exceeds chebfun dimensions.')
        end
        if isnumeric(s)
            varargout = {feval(f,s)};
        elseif isa(s,'domain')
            varargout = { restrict(f,s) };
        elseif strcmp(s,':')
            varargout = {f};
        else
            error('chebfun:subsref:nonnumeric',...
              'Cannot evaluate chebfun for non-numeric type.')
        end
    case '{}'
        s = [];
        if length(index.subs)==1
          if isequal(index.subs{1},':')
            s = domain(f); 
          elseif isa(index.subs{1},'domain')
            s = index.subs{1};
          end
        elseif length(index.subs)==2
          s = cat(2,index.subs{:});
        end
        if ~( isa(s,'domain') || (isnumeric(s) && length(s)==2) )
          error('chebfun:subsref:baddomain',...
            'Invalid domain syntax.')
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
