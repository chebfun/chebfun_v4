function [failfun t] = chebtest(dirname)
% CHEBTEST Probe chebfun system against standard test files.
% CHEBTEST DIRNAME runs each M-file in the directory DIRNAME. Each M-file
% should be a function that takes no inputs and returns a logical scalar 
% value. If this value is true, the function is deemed to have 'passed'. 
% If its result is false, the function 'failed'. If the function
% threw an error, it is considered to have 'crashed'. A report is
% generated in the command window.
%
% CHEBTEST by itself tries to find a directory named 'chebtests' in the
% directory in which chebtest.m resides.
%
% FAILED = CHEBTEST('DIRNAME') returns a cell array of all functions that
% either failed or crashed. 
%
% CHEBTEST RESTORE restores user preferences prior to CHEBTEST
% execution. CHEBTEST modifies path, warning state, and chebfunpref during
% execution. If a CHEBTEST execution is interrupted, the RESTORE option can
% be used to reset these values. 
%
% See http://www.maths.ox.ac.uk/chebfun for chebfun information.

% Copyright 2002-2009 by The Chebfun Team. 

persistent userpref

if nargin ==1 && strcmpi(dirname,'restore')
    if isempty(userpref)
        disp('First excution of chebtests (or information has been cleared), preferences unchanged')
        return
    end
    warning(userpref.warnstate)
    rmpath(userpref.dirname)
    path(path,userpref.path)
    chebfunpref(userpref.pref);
    cheboppref(userpref.oppref);
    disp('Restored values of warning, path, and chebfunpref')
    return
end

pref = chebfunpref;
tol = pref.eps;

matlabver = ver('matlab');
if str2double(matlabver.Version) < 7.39
    disp(['Matlab version: ',matlabver.Version])
    error('CHEBFUN:chebtest:version',['Chebfun is compatible' ...
        ' with MATLAB 7.4 or a more recent version.'])
end

if nargin < 1
  % Attempt to find "chebtests" directory.
  w = which('chebtest.m');
  dirname = fileparts(w);
  dirname = fullfile(dirname,'chebtests');
end
  
if exist(dirname)~=7
  msg = ['The name "' dirname '" does not appear to be a directory on the path.'];
  error('CHEBFUN:probe:nodir',msg)
end

dirlist = dir( fullfile(dirname,'*.m') );
mfile = {dirlist.name};

fprintf('\nTesting %i functions:\n\n',length(mfile))
failed = zeros(length(mfile),1);
t = failed;    % vector to store times

warnstate = warning;
warning off

% Store user preferences for warning and chebfunpref
userpref.warnstate = warnstate;
userpref.path = path;
userpref.pref = pref;
userpref.oppref = cheboppref;
userpref.dirname = dirname;
addpath(dirname)

for j = 1:length(mfile)
  
  fun = mfile{j}(1:end-2);
  link = ['<a href="matlab: edit ' dirname filesep fun '">' fun '</a>'];
  msg = ['  Function #' num2str(j) ' (' link ')... ' ];
  msg = strrep(msg,'\','\\');  % escape \ for fprintf
  numchar = fprintf(msg);
  
  try
    close all
    chebfunpref('factory');
    cheboppref('factory');
    chebfunpref('eps',tol);
    tic
    failed(j) = ~ all(feval( fun ));
    t(j) = toc;
    if failed(j)
      fprintf('FAILED\n')
    else
      fprintf('passed in %2.3fs \n',t(j))
      %pause(0.1)
      %fprintf( repmat('\b',1,numchar) )
    end
  catch
    failed(j) = -1;
    fprintf('CRASHED: ')
    msg = lasterror;  
    lf = findstr(sprintf('\n'),msg.message); 
    if ~isempty(lf), msg.message(1:lf(end))=[]; end
    fprintf([msg.message '\n'])
  end
  
end
rmpath(dirname)
path(path,userpref.path); % If dirname was already in path, put it back.
warning(warnstate)
chebfunpref('factory');
chebfunpref(pref);
cheboppref(userpref.oppref);

if all(~failed)
  fprintf('\nAll tests passed!\n\n')
  if nargout>0, failfun = {}; end
else
  fprintf('\n%i failed and %i crashed\n\n',sum(failed>0),sum(failed<0))
  failfun = mfile(failed~=0);
end

ts = sum(t); tm = ts/60;
fprintf('Total time:%6.1f seconds =%5.2f minutes \n',ts,tm)

end
