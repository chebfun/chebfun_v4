function varargout = subsasgn(f,index,varargin)
%     F(I) = G assigns the chebfun G into the interval of the chebfun F specifed 
%     by the domain I. A(I,C) = F assigns the chebfun F to the column C of a 
%     quasi-matrix A.  A colon used as a subscript in the first argument, as in 
%     A(:,C) = F, indicates the entire chebfun column.
%  
%     F(PTS) = VALS assigns the values of vector VALS at locations
%     specified in vector PTS in the chebfun F. length(PTS) should be equal
%     to length(VALS)). Subsasgn introduces new break-points in F at points
%     in PTS that were not before in F.ENDS. Similarly, A(PTS,C) = VALS
%     assigns values for specific points PTS of the column C of a
%     quasimatrix A.
%  
%     F{A,B} = G is a wrapper for the command DEFINE(F,[A,B],G).
%  
%     F.FIELD = B is a wrapper for the command SET(F,FIELD,B), where FIELD
%     is any of the chebfun fields.
%
% Chebfun Version 2.0
n = size(f,2);
fini = f;
switch index(1).type
    case '.'
        varargout = {set(f,index(1).subs,varargin{:})};
    case '()'
        if length(index(1).subs) == 1            
            if n == 1
                s = index(1).subs{1};
            else
                error('chebfun:subsasgn:dimensions',...
                    'Index missing for quasi-matrix assignment.')
            end                
        elseif length(index(1).subs) == 2
            if n > 1                
                f = f(index(1).subs{2});
                s = index(1).subs{1};
            else
                error('chebfun:subsasgn:dimensions',...
                'Index exceeds chebfun dimensions.')
            end
        else
            error('chebfun:subsasgn:dimensions',...
                'Index exceeds chebfun dimensions.')
        end
        if isnumeric(s)
            if length(s) == length(varargin{:})
                if min(s)<f.ends(1) || max(s)>f.ends(end)
                    error('chebfun:subsref:outbounds',...
                        'Cannot introduce endpoints outside domain.')
                end
                [a,b] = domain(f);
                stemp = s;
                s(find(s==f.ends(end))) = [];
                for i = s
                    f = [restrict(f,[a,i]); restrict(f,[i,b])];                    
                end 
                [mem,loc] = ismember(stemp,f.ends);
                v = varargin{:};
                f.imps(1,loc(find(loc))) = v(find(mem));
                if n > 1
                    fini(index(1).subs{2}) = f;
                    varargout = { fini };
                else
                    varargout = {f};
                end
            else
                error('chebfun:subsref:dimensions',...
                    ['In an assignment  A(I) = B, the number of '...
                    'elements  in B and I must be the same.'])
            end
        elseif isa(s,'domain')
            fini(index(1).subs{2}) = define(f,s,varargin{:});
            varargout = { fini };
        elseif strcmp(s,':')
            fini(index(1).subs{2}) = define(f,domain(f),varargin{:});
            varargout = { fini };
        else
            error('chebfun:subsref:nonnumeric',...
              'Cannot evaluate chebfun for non-numeric type.')
        end
    case '{}'        
        s = [];
        if length(index.subs)==1
          if isequal(index.subs{1},':')
            s = domain(f); 
          else
              error('chebfun:subsref:baddomain',...
            'Invalid domain syntax.')
          end
        elseif length(index.subs)==2
          s = cat(2,index.subs{:});
        end
        if ~( isa(s,'domain') || (isnumeric(s) && length(s)==2) )
          error('chebfun:subsref:baddomain',...
            'Invalid domain syntax.')
        end
        varargout = { define(f,s,varargin{:}) };
    otherwise
        error(['??? Unexpected index.type of ' index(1).type]);
end