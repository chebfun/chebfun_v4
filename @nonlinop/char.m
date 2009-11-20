function s = char(A)
% CHAR  Convert nonlinop to pretty-printed string.


if isempty(A)
    s = '   (empty nonlinop)';
else
    s = '   operating on chebfuns defined on:';
    s = char(s,' ');
    s = char(s,['  ' char(A.dom)],' ');
    
    %   if all(A.blocksize==[1 1])
    %     if ~isempty(A.varmat)
    %       s = char(s,char(A.varmat),' ');
    %     end
    if ~isempty(A.op)
        opchar = char(A.op);
        %         s = char(s, '   representing the operator:',' ',...
        %             ['     ' char(A.op)]);
        %         opchar = char(A.op);
        s = char(s, '   representing the operator:',' ',...
            ['     ' opchar(3) ' |-> ' opchar(5:end), ' ']);
    end
    
    if ~isempty(A.lbc)
        s = char(s, '   left boundary condition:',' ',...
                    ['     ' char(A.lbc) ' = 0']);
    end
    
    if ~isempty(A.rbc)
        s = char(s, '   right boundary condition:',' ',...
                    ['     ' char(A.rbc) ' = 0']);
    end
    %   else
    %     s = char(s,sprintf('   with %ix%i block definitions',A.blocksize),' ');
    %   end
    %
    %   if A.difforder~=0
    %     s = char(s, ['   and differential order ' num2str(A.difforder)],' ');
    %   end
    %
    %   if A.numbc > 0
    %     if A.numbc==1
    %       s = char(s,['   and ' int2str(A.numbc) ' boundary condition'],' ' );
    %     else
    %       s = char(s,['   and ' int2str(A.numbc) ' boundary conditions'],' ' );
    %     end
    %   end
end
