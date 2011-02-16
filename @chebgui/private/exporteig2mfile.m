function exportbvp2mfile(guifile,pathname,filename,handles)

% Extract information from the GUI fields
a = guifile.DomLeft;
b = guifile.DomRight;
deInput = guifile.DE;
lbcInput = guifile.LBC;
rbcInput = guifile.RBC;
% Sigmas and num eigs
sigma = guifile.sigma;
K = guifile.options.numeigs;
if isempty(K), K = '6'; end

% Wrap all input strings in a cell (if they're not a cell already)
if isa(deInput,'char'), deInput = cellstr(deInput); end
if isa(lbcInput,'char'), lbcInput = cellstr(lbcInput); end
if isa(rbcInput,'char'), rbcInput = cellstr(rbcInput); end

deRHSInput = cellstr(repmat('0',numel(deInput),1));
lbcRHSInput = cellstr(repmat('0',numel(lbcInput),1));
rbcRHSInput = cellstr(repmat('0',numel(rbcInput),1));

[allStrings allVarString indVarName pdeVarName pdeflag allVarNames] = setupFields(guifile,deInput,deRHSInput,'DE');
% If allStrings return a cell, we have both a LHS and a RHS string. Else,
% we only have a LHS string, so we need to create the LHS linop manually.
if iscell(allStrings)
    lhsString = allStrings{1};
    rhsString = allStrings{2};
else
    lhsString = allStrings;
    rhsString = '';
end
% Assign x or t as the linear function on the domain
[d,xt] = domain(str2num(a),str2num(b));
eval([indVarName, '=xt;']);

% Convert the strings to proper anon. function using eval
LHS  = eval(lhsString);

if ~isempty(lbcInput{1})
    [lbcString indVarNameL] = setupFields(guifile,lbcInput,lbcRHSInput,'BC',allVarString);
    LBC = eval(lbcString);
else
    LBC = [];
end
if ~isempty(rbcInput{1})
    [rbcString indVarNameR] = setupFields(guifile,rbcInput,rbcRHSInput,'BC',allVarString);
    RBC = eval(rbcString);
else
    RBC = [];
end

if isempty(lbcInput) && isempty(rbcInput)
    error('chebfun:bvpgui','No boundary conditions specified');
end

DErhsNum = str2num(char(deRHSInput));
if isempty(DErhsNum)
    % RHS is a string representing a function -- convert to chebfun
    DE_RHS = chebfun(deRHSInput,d);
else
    % RHS is a number - Don't need to construct chebfun
    DE_RHS = DErhsNum;
end

% Variable which determines whether it's a generalized problem. If
% rhsString is empty, we can be sure it's not a generalized problem.
generalized = 1;

% Create the chebops, and try to linearise them.
% We will always have a string for the LHS, if the one for RHS is empty, we
% know we have a non-generalised problem.
N_LHS = chebop(d,LHS,LBC,RBC);
try
    A = linop(N_LHS);
catch
    if guiMode
        errordlg('Operator is not linear.', 'Chebgui error', 'modal');
    else
        rethrow(lasterr)
    end
    varargout{1} = handles;
    return
end
% Check for a generalised problem
if ~isempty(rhsString)
    RHS  = eval(rhsString);
    N_RHS = chebop(d,RHS);
    try
        B = linop(N_RHS);
    catch
        if guiMode
            errordlg('Operator is not linear.', 'Chebgui error', 'modal');
        else
            rethrow(lasterr)
        end
        varargout{1} = handles;
        return
    end
    
    % Check whether we are working with generalized
    % problems or not by comparing B with the identity operator on the domain.
    I = eye(B.domain);
    Iblock = blkdiag(I,B.blocksize(1));
    
    opDifference = B(10)-Iblock(10);
    opSum = B(10)+Iblock(10);
    if isempty(nonzeros(opDifference)), generalized = 0; end
    if isempty(nonzeros(opSum)), generalized = 0; A = -A; end
else
    generalized = 0;
end

% Support for periodic boundary conditions
if (~isempty(lbcInput{1}) && strcmpi(lbcInput{1},'periodic')) || ...
        (~isempty(rbcInput{1}) && strcmpi(rbcInput{1},'periodic'))
    lbcInput{1} = []; rbcInput{1} = []; periodic = true;
else
    periodic = false;
end

% Find the eigenvalue name
mask = strcmp(deInput{1},{'lambda','lam','l'});
if mask(1), lname = 'lambda'; 
elseif mask(2), lname = 'lam'; 
elseif mask(3), lname = 'l'; 
else lname = 'lambda'; end

% Print to the file
fullFileName = [pathname,filename];
fid = fopen(fullFileName,'wt');

if ispc
    userName = getenv('UserName');
else
    userName = getenv('USER');
end

fprintf(fid,'%% %s - An executable M-file file for solving an eigenvalue problem.\n',filename);
fprintf(fid,'%% Automatically created from chebfun/chebgui by user %s\n',userName);
fprintf(fid,'%% at %s on %s.\n\n',datestr(rem(now,1),13),datestr(floor(now)));

fprintf(fid,'%% Solving\n');
if numel(deInput) == 1 && ~any(deInput{1}=='=')
    fprintf(fid,'%%   %s = %s*%s\n',deInput{1},lname,allVarString);
else
    for k = 1:numel(deInput)
        fprintf(fid,'%%   %s,\n',deInput{k});
    end
end
fprintf(fid,'%% for %s in [%s,%s]',indVarName,a,b);
if ~isempty(lbcInput{1}) || ~isempty(rbcInput{1})
    fprintf(fid,', subject to\n%%');
    if  ~isempty(lbcInput{1})
        if numel(lbcInput)==1 && ~any(lbcInput{1}=='=') && ~any(strcmpi(lbcInput{1},{'dirichlet','neumann'}))
            % Sort out when just function values are passed as bcs.
            lbcInput{1} = sprintf('%s = %s',allVarString,lbcInput{1});
        end
        fprintf(fid,'   ');
        for k = 1:numel(lbcInput)
            fprintf(fid,'%s',lbcInput{k});
            if k~=numel(lbcInput) && numel(lbcInput)>1, fprintf(fid,', '); end
        end
        fprintf(fid,' at %s = % s\n',indVarName,a);
    end
    if  ~isempty(lbcInput{1}) && ~isempty(rbcInput{1})
        fprintf(fid,'%% and\n%%',indVarName,a);
    end
    if ~isempty(rbcInput{1})
        if numel(rbcInput)==1 && ~any(rbcInput{1}=='=') && ~any(strcmpi(rbcInput{1},{'dirichlet','neumann'}))
            % Sort out when just function values are passed as bcs.
            rbcInput{1} = sprintf('%s = %s',allVarString,rbcInput{1});
        end
        fprintf(fid,'   ');
        for k = 1:numel(rbcInput)
            fprintf(fid,'%s',rbcInput{k});
            if k~=numel(rbcInput) && numel(rbcInput)>1, fprintf(fid,', '); end
        end
        fprintf(fid,' at %s = % s\n',indVarName,b);
    end
    fprintf(fid,'\n');
elseif periodic
    fprintf(fid,', subject to periodic boundary conditions.\n\n');
else
    fprintf(fid,'.\n');
end

if ~generalized
    fprintf(fid,'%% Define the domain we''re working on.\n');
    fprintf(fid,'dom = [%s,%s];\n',a,b);
    fprintf(fid,['\n%% Assign the equation to a chebop N such that' ...
        ' N(u) = %s*u.\n'],lname);
    fprintf(fid,'N = chebop(%s,dom);\n',lhsString);
else
    fprintf(fid,'%% Define the domain we''re working on.\n');
    fprintf(fid,'dom = [%s,%s];\n',a,b);
    fprintf(fid,['\n%% Assign the equation to two chebops N and B such that' ...
        ' N(u) = %s*B(u).\n'],lname);
    fprintf(fid,'N = chebop(%s,dom);\n',lhsString);
    fprintf(fid,'B = chebop(%s,dom);\n',rhsString);
end

% Make assignments for left and right BCs.
fprintf(fid,'\n%% Assign boundary conditions to N.\n');
if ~isempty(lbcInput{1})
    lbcString = setupFields(guifile,lbcInput,lbcRHSInput,'BC',allVarString);
    fprintf(fid,'N.lbc = %s;\n',lbcString);
end
if ~isempty(rbcInput{1})
    rbcString = setupFields(guifile,rbcInput,rbcRHSInput,'BC',allVarString);
    fprintf(fid,'N.rbc = %s;\n',rbcString);
end
if periodic
    fprintf(fid,'N.bc = ''periodic'';\n');
end

fprintf(fid,'\n%% Number of eigenvalue and eigenmodes to compute.\n');
fprintf(fid,'k = %s;\n',K);

fprintf(fid,'\n%% Solve the eigenvalue problem.\n');
if ~generalized
    if ~isempty(sigma)
        fprintf(fid,'[V D] = eigs(N,k,%s);\n',sigma);
    else
        fprintf(fid,'[V D] = eigs(N,k);\n');
    end
else
    if ~isempty(sigma)
            fprintf(fid,'[V D] = eigs(N,B,k,%s);\n',sigma);
        else
            fprintf(fid,'[V D] = eigs(N,B,k);\n');
    end
end
fprintf(fid,'\n%% Plot the eigenvalues.\n');
fprintf(fid,'D = diag(D);\n');
fprintf(fid,'figure\n');
fprintf(fid,'plot(real(D),imag(D),''.'',''markersize'',25)\n');
fprintf(fid,'title(''Eigenvalues''); xlabel(''real''); ylabel(''imag'');\n');

if ischar(allVarNames) || numel(allVarNames) == 1
    fprintf(fid,'\n%% Plot the eigenmodes.\n');
    fprintf(fid,'figure\n');
    fprintf(fid,'plot(real(V),''linewidth'',2);\n');
    fprintf(fid,'title(''Eigenmodes''); xlabel(''%s''); ylabel(''%s'');\n',indVarName,allVarString);
end

fclose(fid);
end