function display(F)
% DISPLAY       Display chebun
% DISPLAY(F) is called when the semicolon is not used at the end of a statement.
% DISPLAY(F) shows for each piece of a chebfun the number of points used to
% represent that part of the function, together with two columns: the first
% one with the subinterval for each sooth piece and the second with the 
% number of Chebyshev points used.

% Chebfun Version 2.0

disp([inputname(1) ' = '])

if numel(F)>1
    for k=1:numel(F)
   
        f=F(k);
        
        if f.trans==0
            columnstr=['   chebfun column ', int2str(k)];
        else
            columnstr=['   chebfun row ', int2str(k)];
        end
    
        displaychebfun(F(k),columnstr)
        
    end
        
else
    
    if F.trans==0
        columnstr='   chebfun column';
    else
        columnstr='   chebfun row';
    end
    
    displaychebfun(F,columnstr)
    
end


% -----------------------------------------------------

function displaychebfun(f, columnstr)
    
    % compact version
    if isempty(f)
         disp('empty chebfun'), disp(' ')
        return
    end

    ends = f.ends;    
    funs = f.funs;
    if f.nfuns > 1
        disp([columnstr ' (' int2str(f.nfuns) ' smooth pieces)'])
    else
        disp([columnstr ' (1 smooth piece)'])
    end    
    len = zeros(f.nfuns,1);
    disp('          interval          length   values at Chebyshev points')
    for j = 1:f.nfuns
        len(j)=length(funs(j));
        if ~isreal(funs(j).vals)
            fprintf('(%9.2g,%9.2g)   %7i       Complex values \n', ends(j), ends(j+1), len(j));
        else
            switch len(j)
                case 1
                    fprintf('(%9.2g,%9.2g)   %7i   %10.2g \n', ends(j), ends(j+1), len(j), funs(j).vals)
                case 2
                    fprintf('(%9.2g,%9.2g)   %7i   %10.2g %10.2g\n', ends(j), ends(j+1), len(j), funs(j).vals)
                case 3
                    fprintf('(%9.2g,%9.2g)   %7i   %10.2g %10.2g %10.2g \n', ends(j), ends(j+1), len(j), funs(j).vals)
                case 4
                    fprintf('(%9.2g,%9.2g)   %7i   %10.2g %10.2g %10.2g %10.2g \n', ends(j), ends(j+1), len(j), funs(j).vals)
                otherwise
                    v = funs(j).vals;
                    fprintf('(%9.2g,%9.2g)   %7i   %10.2g %10.2g %10.2g ... %10.2g\n', ends(j), ends(j+1), len(j), v(1:3), v(end))
            end
        end        
    end
    if f.nfuns > 1
        fprintf('Total length = %i \n', sum(len))
    end
    disp(' ')