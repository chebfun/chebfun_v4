function [failfun t] = chebtest(dirname)
%CHEBTEST Probe chebfun system against standard test files.
% CHEBTEST DIRNAME runs each M-file in the directory DIRNAME. Each M-file
% should be a function that takes no inputs and returns a logical scalar 
% value. If this value is true, the function is deemed to have 'passed'. 
% If its result is false, the function 'failed'. If the function
% threw an error, it is considered to have 'crashed'. A report is
% generated in the command window, and in a file 'chebtestreport' in the
% chebfun directory.
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
createreport = true;
avgtimes = true;

matlabver = ver('matlab');
if str2double(matlabver.Version(1)) < 7 || ...
    (str2double(matlabver.Version(3)) < 4 && length(matlabver.Version) < 4)
    disp(['Matlab version: ',matlabver.Version])
    error('CHEBFUN:chebtest:version',['Chebfun is compatible' ...
        ' with MATLAB 7.4 or a more recent version.'])
end

% Chebfun directory
chbfundir = fileparts(which('chebtest.m'));

if nargin < 1
    % Attempt to find "chebtests" directory.
    dirname = fullfile(chbfundir,'chebtests');
end
if ~exist(dirname,'dir')
  msg = ['The name "' dirname '" does not appear to be a directory on the path.'];
  error('CHEBFUN:chebtest:nodir',msg)
end

dirlist = dir( fullfile(dirname,'*.m') );
mfile = {dirlist.name};
namelen = 0;
for k = 1:numel(mfile)
    namelen = max(namelen,length(mfile{k}));
end

fclose(fopen(fullfile(dirname, filesep,'chebtest_report.txt'),'w+'));

fprintf('\nTesting %i functions:\n\n',length(mfile))
failed = zeros(length(mfile),1);
t = failed;    % vector to store times

% For looking at average time performance.
if avgtimes
    avgfile = fullfile(dirname, filesep ,'chebtest_avgs.txt');
    if ~exist(avgfile,'file')
        fclose(fopen(avgfile,'w+'));
    end
    avgfid = fopen(avgfile,'r');    
    avgt = fscanf(avgfid,'%f',inf);
    fclose(avgfid);
    if length(t) ~= length(avgt)-1
        % Number of chebtests has changed, so scrap averages.
        fclose(fopen(avgfile,'w+'));
        avgt = 0*t;
    end
    avgN = avgt(end);
    avgTot = sum(avgt(1:end-1));
else
    avgN = 0; avgt = 0*t;
end

warnstate = warning;
warning off

% Store user preferences for warning and chebfunpref
userpref.warnstate = warnstate;
userpref.path = path;
userpref.pref = pref;
userpref.oppref = cheboppref;
userpref.dirname = dirname;
addpath(dirname)

javacheck = true;
if strcmp(version('-java'),'Java is not enabled')
    javacheck = false;
end

for j = 1:length(mfile)
  
  fun = mfile{j}(1:end-2);
  if javacheck
      link = ['<a href="matlab: edit ' dirname filesep fun '">' fun '</a>'];
  else
      link = fun;
  end
  ws = repmat(' ',1,namelen+1-length(fun)-length(num2str(j)));
  msg = ['  Function #' num2str(j) ' (' link ')... ', ws ];
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
        if avgN == 0
          fprintf('passed in %2.3fs \n',t(j))
        else
          fprintf('passed in %2.3fs (avg %2.3fs)\n',t(j),avgt(j))
        end
        avgt(j) = (avgN*avgt(j)+t(j))/(avgN+1);
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
    
    % Create an error report
    if createreport
        fid = fopen([dirname filesep ,'chebtest_report.txt'],'a');
        fprintf(fid,[fun '  (crashed) \n']);
        fprintf(fid,['identifier: ''' msg.identifier '''\n']);
        fprintf(fid,['message: ''' msg.message '''\n']);
        for k = 1:size(msg.stack,1)
            fprintf(fid,[msg.stack(k).file ' \tline ' int2str(msg.stack(k).line) '\n']);
        end
    fprintf(fid,'\n');
    fclose(fid);
    end

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
  fprintf('\n%i failed and %i crashed\n',sum(failed>0),sum(failed<0))
  failfun = mfile(failed~=0);
  
  if createreport
      fun = 'chebtest_report.txt';
      link = ['<a href="matlab: edit ' dirname filesep fun '">' fun '</a>'];
      msg = [' Error report available here: ' link '. ' ];
      msg = strrep(msg,'\','\\');  % escape \ for fprintf
      numchar = fprintf(msg); fprintf('\n')
  end
  fprintf('\n')
end

ts = sum(t); tm = ts/60;
if avgN == 0
    fprintf('Total time: %1.1f seconds = %1.1f minutes \n',ts,tm)
else
    fprintf('Average time: %1.1f seconds (Lifetime Avg: %1.1f seconds)\n',ts,avgTot)
end

if avgtimes && all(~failed)
    avgfid = fopen(avgfile,'w+');    
    for k = 1:size(t,1)
        fprintf(avgfid,'%f\n',avgt(k));
    end
    fprintf(avgfid,'%d \n',avgN+1);
    fclose(avgfid);
end

end
