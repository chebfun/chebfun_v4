function varargout = chebtest(dirname)
%CHEBTEST Probe Chebfun against standard test files.
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
% FAILED = CHEBTEST returns a cell array of all functions that either 
% failed or crashed. 
%
% CHEBTEST RESTORE restores user preferences prior to CHEBTEST
% execution. CHEBTEST modifies path, warning state, and chebfunpref during
% execution. If a CHEBTEST execution is interrupted, the RESTORE option can
% be used to reset these values. CHEBTEST RESTORE also resets the 'avg'
% times also returned by chebtest.
%
% Chebtest looks first for subdirectories labeled 'level*' and executes
% the tests therein in alphabetical order. The tests should be assigned
% to different levels according to the following scheme:
%
%   level0: Tests of the basic Chebfun routines such as arithmetic
%           operators, constructors, preferences, etc...
%   level1: Tests for more complex operations of a single chebfun, e.g.
%           norm, max, roots, diff, sum, etc...
%   level2: Tests involving systems of chebfuns (quasimatrices).
%   level3: Tests involving linear chebops.
%   level4: Tests involving non-linear chebops.
%
% In an ideal world, each test would only use functions and operations
% that are tested in the same or lower levels.
%
% Tests residing directly in the chebtests directory will be executed
% only after the 'level*' tests.
%
% See http://www.maths.ox.ac.uk/chebfun for Chebfun information.

% Copyright 2002-2011 by The Chebfun Team. 

persistent userpref

if nargin == 1 && ischar(dirname) && strcmpi(dirname,'restore')
    if isempty(userpref)
%         disp('First execution of chebtests (or information has been cleared), preferences unchanged.')
        return
    end
    warning(userpref.warnstate)
    rmpath(userpref.dirname)
    path(path,userpref.path)
    chebfunpref(userpref.pref);
    cheboppref(userpref.oppref);
    disp('Restored values of warning, path, and chebfunpref.')
    return
end

pref = chebfunpref;
tol = pref.eps;
createreport = true;
avgtimes = false; % If turning off, remember to remove line from help comments.

if verLessThan('matlab','7.4')
    matlabver = ver('matlab');
    disp(['MATLAB version: ',matlabver.Version, ' ', matlabver.Release])
    error('CHEBFUN:chebtest:version',['Chebfun is compatible' ...
        ' with MATLAB 7.4 (R2007a) or a more recent version.'])
end

% Chebfun directory
chbfundir = fileparts(which('chebtest.m'));

if nargin < 1
    % Attempt to find "chebtests" directory.
    dirname = fullfile(chbfundir,'chebtests');
end

% Deal with levelX input
if ischar(dirname)
    if ~isempty(str2num(dirname))
        dirname = str2num(dirname);
    elseif strncmpi(dirname,'level',5)
        dirname = fullfile(chbfundir,'chebtests',lower(dirname));
    end
end
if isnumeric(dirname)
    if numel(dirname) == 1
        dirname = fullfile(chbfundir,'chebtests',['level',num2str(dirname)]);
    else
        error('CHEBFUN:chebtest:numdirs','Can only chebtest all test directories at once, or one at a time.');
    end
end

if ~exist(dirname,'dir')
  msg = ['The name "' dirname '" does not appear to be a directory on the path.'];
  error('CHEBFUN:chebtest:nodir',msg)
end

% Turn off warnings for the test
warnstate = warning;
warning off

% Store user preferences for warning and chebfunpref
userpref.warnstate = warnstate;
userpref.path = path;
userpref.pref = pref;
userpref.oppref = cheboppref;
userpref.dirname = dirname;

% Add chebtests directory to the path
addpath(dirname)

% loop over the level directories (first)
subdirlist = dir( fullfile(dirname,'level*') );
subdirnames = { subdirlist.name };
mfiles = {};
for i=1:length(subdirnames)

    % is this really a directory?
    if ~subdirlist(i).isdir, continue; end;
    
    % add it to the path
    addpath( [ dirname filesep subdirnames{i} ] );

    % Get the names of the tests for this level
    dirlist = dir( fullfile([ dirname filesep subdirnames{i} ],'*.m') );
    mfiles = { mfiles{:} , dirlist.name };
    
end;

% Get the names of any un-sorted tests
dirlist = dir( fullfile(dirname,'*.m') );
mfiles = { mfiles{:} , dirlist.name };

% Find the length of the names (for pretty display later).
namelen = 0;
for k = 1:numel(mfiles)
    namelen = max(namelen,length(mfiles{k}));
end;
    
% Initialise some storage
failed = zeros(length(mfiles),1);  % Pass/fail
t = failed;                        % Vector to store times

% Clear the report file (and check we can open file)
[fid message] = fopen(fullfile(chbfundir,'chebtests','chebtest_report.txt'),'w+');
if fid < 0
    warning('CHEBFUB:chebtest:fopenfail', ...
        ['Cannot create chebtest report: ', message]);
    createreport = false;
    avgtimes = false;
else
    fclose(fid);
end

% For looking at average time performance.
if avgtimes
    avgfile = fullfile(chbfundir,'chebtests','chebtest_avgs.txt');
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

% If java is not enabled, don't display html links.
javacheck = true;
if ~usejava('jvm') || ~usejava('desktop')
    javacheck = false;
end

% loop through the tests
for j = 1:length(mfiles)
  % Print the test name
  fun = mfiles{j}(1:end-2);
  if javacheck
      link = ['<a href="matlab: edit ' which(fun) '">' fun '</a>'];
  else
      link = fun;
  end
  ws = repmat(' ',1,namelen+1-length(fun)-length(num2str(j)));
  msg = ['  Function #' num2str(j) ' (' link ')... ', ws ];
  msg = strrep(msg,'\','\\');  % escape \ for fprintf
  numchar = fprintf(msg);
  % Execute the test
  try
    close all
    chebfunpref('factory');
    cheboppref('factory');
    chebfunpref('eps',tol);
    tic
    pass = feval( fun );
    t(j) = toc;
    failed(j) = ~ all(pass);
    if failed(j)
      fprintf('FAILED\n')
      
      % Create an error report entry for a failure
      if createreport
        fid = fopen([dirname filesep ,'chebtest_report.txt'],'a');
        fprintf(fid,[fun '  (failed) \n']);
        fprintf(fid,['pass: ''' int2str(pass) '''\n\n']);
        fclose(fid);
      end

    else
        avgt(j) = (avgN*avgt(j)+t(j))/(avgN+1);
        if avgN == 0
          fprintf('passed in %2.3fs \n',t(j))
        else
          fprintf('passed in %2.3fs (avg %2.3fs)\n',t(j),avgt(j))
        end
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
   
    % Create an error report entry for a crash
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
chebfunpref(pref);
cheboppref(userpref.oppref);

% Final output
ts = sum(t); tm = ts/60;
if avgN == 0
    fprintf('Total time: %1.1f seconds = %1.1f minutes \n',ts,tm)
else
    fprintf('Total time: %1.1f seconds (Lifetime Avg: %1.1f seconds)\n',ts,avgTot)
end

if all(~failed)
  fprintf('\nAll tests passed!')
  failfun = {};
else
  fprintf('\n%i failed and %i crashed\n',sum(failed>0),sum(failed<0))
  failfun = mfiles(failed~=0);
  if createreport
      fun = 'chebtest_report.txt';
      if javacheck
          link = ['<a href="matlab: edit ' dirname filesep fun '">' fun '</a>'];
      else
          link = fullfile(dirname,filesep,fun);
      end
      msg = [' Error report available here: ' link '. ' ];
      msg = strrep(msg,'\','\\');  % escape \ for fprintf
      numchar = fprintf(msg); fprintf('\n')
  end
end

% Update average times (if enabled and no failures)
if avgtimes && all(~failed)
    avgfid = fopen(avgfile,'w+');    
    for k = 1:size(t,1)
        fprintf(avgfid,'%f\n',avgt(k));
    end
    fprintf(avgfid,'%d \n',avgN+1);
    fclose(avgfid);
end

% Output args
if nargout > 0
    varargout{1} = failfun; 
else
    fprintf('    ');
    for k = 1:sum(abs(failed))
        fun = failfun{k};
        if javacheck         
            link = ['<a href="matlab: edit ' fullfile(dirname,fun) '">' fun '</a>    '];
            link = strrep(link,'\','\\');  % maintain fprintf compatability in MSwin
        else
            link = fun;
        end
        fprintf([ link '    ' ])
    end
    fprintf('\n');
end
if nargout > 0, varargout{2} = t; end

if createreport && any(failed)
    fid = fopen(fullfile(dirname,'chebtest_report.txt'),'a');

    % GET SYSTEM INFORMATION
    % find platform OS
    if ispc
        platform = [system_dependent('getos'),' ',system_dependent('getwinsys')];
    elseif ismac
        [fail, input] = unix('sw_vers');
        if ~fail
            platform = strrep(input, 'ProductName:', '');
            platform = strrep(platform, sprintf('\t'), '');
            platform = strrep(platform, sprintf('\n'), ' ');
            platform = strrep(platform, 'ProductVersion:', ' Version: ');
            platform = strrep(platform, 'BuildVersion:', 'Build: ');
        else
            platform = system_dependent('getos');
        end
    else    
        platform = system_dependent('getos');
    end
    % display platform type
    fprintf(fid,['MATLAB Version ',version,'\n']);
    % display operating system
    fprintf(fid,['Operating System: ',  platform,'\n']);
    % display first line of Java VM version info
    fprintf(fid,['Java VM Version: ',...
    char(strread(version('-java'),'%s',1,'delimiter','\n'))]);

    fclose(fid);
end
