function failfun = probe(dirname)
% PROBE Probe system against standard test files.
% PROBE DIRNAME runs each M-file in the directory DIRNAME. Each M-file
% should be a function that takes no inputs and returns a logical scalar 
% value. If this value is true, the function is deemed to have 'passed'. 
% If its result is false, the function 'failed'. If the function
% threw an error, it is considered to have 'crashed'. A report is
% generated in the command window.
%
% PROBE by itself tries to find a directory named 'probetests' in the
% directory in which probe.m resides.
%
% FAILED = PROBE('DIRNAME') returns a cell array of all functions that
% either failed or crashed.

% Toby Driscoll, 13 May 2008.

if nargin < 1
  % Attempt to find "probetests" directory.
  w = which('probe.m');
  dirname = fileparts(w);
  dirname = fullfile(dirname,'probetests');
end
  
if exist(dirname)~=7
  msg = ['The name "' dirname '" does not appear to be a directory on the path.'];
  error('chebfun:probe:nodir',msg)
end

dirlist = dir( fullfile(dirname,'*.m') );
mfile = {dirlist.name};

fprintf('\nTesting %i functions:\n\n',length(mfile))
failed = zeros(length(mfile),1);

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
    failed(j) = ~feval( fun );
    if failed(j)
      fprintf('FAILED\n')
    else
      fprintf('passed\n')
      pause(0.1)
      %fprintf( repmat('\b',1,numchar) )
    end
  catch me
    failed(j) = -1;
    fprintf('CRASHED: ')
    fprintf(me.message)
    fprintf('\n')
  end
  
end
rmpath(dirname)

if all(~failed)
  fprintf('\nAll tests passed!\n\n')
else
  fprintf('\n%i failed and %i crashed\n\n',sum(failed>0),sum(failed<0))
end

if nargout>0
  failfun = mfile(failed~=0);
end
