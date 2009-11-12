function Fout = power(F1,F2)
% .^	Chebfun power.
% F.^G returns a chebfun F to the scalar power G, a scalar F to the
% chebfun power G, or a chebfun F to the chebfun power G.
%
% See http://www.comlab.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2008 by The Chebfun Team. 

if isa(F1,'chebfun') && isa(F2,'chebfun')
    % chebfun.^chebfun
    if size(F1)~=size(F2)
        error('Chebfun quasi-matrix dimensions must agree.')
    end
    Fout = F1;
    for k = 1:numel(F1)
        Fout(k) = powercol(F1(k),F2(k));
    end
elseif isa(F1,'chebfun')
    % chebfun.^double
    Fout = F1;
    for k = 1:numel(F1)
        Fout(k) = powercol(F1(k),F2);
        Fout(k).jacobian = anon('@(u) F2*diag(F1.^(F2-1))*jacobian(F1,u)',{'F1', 'F2'},{F1(k) F2});
        Fout(k).ID = newIDnum();
    end
else
    % double.^chebfun
    Fout = F2;
    for k = 1:numel(F2)
        Fout(k) = powercol(F1,F2(k));
        Fout(k).jacobian = anon('@(u) (diag(F1.^F2)*log(F1))*jacobian(F2,u)',{'F1', 'F2'},{F1 F2(k)});
        Fout(k).ID = newIDnum();
    end
end

% -----------------------------------------------------    
function fout = powercol(f,b)

if (isa(f,'chebfun') && isa(b,'chebfun'))
    if f.ends(1)~=b.ends(1) ||  f.ends(end)~=b.ends(end)
        error('F and G must be defined in the same interval')
    end
    fout = comp(f,@power,b);
    fout.jacobian = anon('@(u) diag(diag(b)*f.^(b-1))*jacobian(f,u) + diag(diag(f.^b)*log(f))*jacobian(b,u)',{'f' 'b'},{f b});
    fout.ID = newIDnum();
else
    if isa(f,'chebfun') 
        if b == 0
            % Trivial case
            fout = chebfun(1,[f.ends(1) f.ends(end)]);
        elseif b == .5
            % Sqrt
            fout = sqrt(f);
        elseif b == 2
            % Square
            fout = f.*f;
        else
            % General case
            f = add_breaks_at_roots(f);
            fout = f;
            % Loop through funs
            for k = 1:f.nfuns
                fk = extract_roots(f.funs(k));
                exps = fk.exps;
                fk.exps = [0 0];
                foutk = compfun(fk, @(x) power(x,b));
                foutk.exps = b*exps;
                foutk = replace_roots(foutk);
                fout.funs(k) = foutk;
            end
            fout.imps = power(fout.imps,b);
            
        end
        
% %         old     
%         elseif any(any(get(f,'exps'))) && ~chebfunpref('splitting')
%             % It's better to seperate out the markfun part if possible
%             %  -- does it really make a difference?
%             
%             exps = get(f,'exps');
%             for k = 1:f.nfuns
%                 fk = f.funs(k);
%                 fk = set(fk,'exps',[0 0]); 
%                 f.funs(k) = fk;
%             end
%             
%             if b == 2
%                 fout = f.*f;
%             else
%                 fout = comp(f,@(x) power(x,b));
%             end
%             
%             if fout.nfuns ~= f.nfuns,
%                 error('I didn''t think this could happen ...'); 
%             end
%             
%             exps = b*exps;
%             
%             for k = 1:f.nfuns
%                 fk = fout.funs(k);
%                 fk = set(fk,'exps',exps(k,:)); 
%                 fout.funs(k) = fk;
%             end
%             
%         else
%             % The usual case
%             
%             if b == 2
%                 fout = f.*f;
%             elseif b == .5
%                 fout = sqrt(f);                
%             else
%                 fout = comp(f,@(x) power(x,b));
%             end
%            
%         end
        
        fout.trans = f.trans;
        
    else
        fout = comp(b, @(x) power(f,x));
        %fout = chebfun(@(x) f.^feval(b,x), b.ends);
        %fout.trans = b.trans;
    end
    
end