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
            switch index(1).subs
                case 'funs'
                    varargout = {f.funs};
                case 'ends'
                    varargout = {f.ends};
                case 'vals'
                    vals = [];
                    for i = 1:f.nfuns
                      vals = [vals;f.funs{i}.val];
                    end
                    varargout = {vals};
                case 'grid'
                    grid = [];
                    for i = 1:f.nfuns
                      grid = [grid; flipud(cheb(f.funs{i}.n, ...
                          f.ends(i),f.ends(i+1)))];
                    end
                    varargout = {grid};
                case 'nfuns'
                    varargout = {f.nfuns};
                case 'npts'
                    npts = 0;
                    for i = 1:f.nfuns
                      npts = npts + f.funs{i}.n;
                    end
                    varargout = {npts};
                case 'ptsfun'
                    ptsfun = [];
                    for i = 1:f.nfuns
                      ptsfun = [ptsfun; f.funs{i}.n];
                    end
                    varargout = {ptsfun};
            end
        end
        
        if length(index) > 1
            if length(f(:)) == 1
                varargout = {subsref([varargout{:}], index(2:end))};
            else
                [err_id, err_msg] = array_reference_error(index(2).type);
                error(err_id, err_msg);
            end
        end
           
    case '()'
        s = index.subs{1};
        if isnumeric(s)
            F = feval(f,s);
            varargout = {F};
        else
            error('chebfun:subsref:nonnumeric',...
              'Cannot evaluate chebfun for non-numeric type.')
        end
    case '{}'
        s = [];
        if length(index.subs)==1
          if isequal(index.subs{1},':')
            s = domain(f);
          %elseif isnumeric(index.subs{1})
          %  s = index.subs{1};
          end
        elseif length(index.subs)==2
          s = cat(2,index.subs{:});
        end
        if ~isnumeric(s) || length(s)~=2
          error('chebfun:subsref:badinterval',...
            'Invalid interval syntax.')
        end
        varargout = { restrict(f,s) };
    otherwise
        error(['??? Unexpected index.type of ' index(1).type]);
end

if length(varargout) > 1 && nargout <= 1
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
