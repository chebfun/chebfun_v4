function varargout = cheb2test(dirname)
%CHEB2TEST Probe Chebfun2 against standard test files.
%
%   CHEB2TEST DIRNAME runs each M-file in the directory DIRNAME. Each M-file
%   should be a function that takes no inputs and returns a logical scalar
%   value. If this value is true, the function is deemed to have 'passed'. 
%   If its result is false, the function 'failed'. If the function threw an
%   error, it is considered to have 'crashed'. A report is generated in the
%   command window, and in a file 'cheb2testreport' in the Chebfun2 directory.
%  
%   CHEB2TEST by itself tries to find a directory named 'cheb2test' in the
%   directory in which cheb2test.m resides.
%  
%   FAILED = CHEB2TEST returns a cell array of all functions that either 
%   failed or crashed. A report is also generated in the file
%     <chebfun2_directory>/cheb2tests/cheb2test_report.txt
%  
%   CHEB2TEST RESTORE restores user preferences prior to cheb2test execution.
%   CHEB2TEST modifies path, warning state, and chebfun2pref during execution.
%   If a cheb2test execution is interrupted, the RESTORE option can be used to
%   reset these values. 
%  
%   CHEB2TEST looks first for the subdirectories below, and executes the tests
%   therein in alphabetical order. The tests should be assigned to different
%   directories according to the following scheme:
%  
%     Level0: Tests for the Fun2 class, which is for developer use. 
%     Level1: Tests for the Chebfun2 class.
%     Level2: Tests for the Chebfun2v class.

% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.maths.ox.ac.uk/chebfun/ for Chebfun information. 

clear all
persistent user2pref

if nargin == 1 && ischar(dirname) && strcmpi(dirname,'restore')
    if isempty(user2pref)
%         disp('First execution of chebtests (or information has been cleared), preferences unchanged.')
        return
    end
    warning(user2pref.warnstate)
    rmpath(user2pref.dirname)
    path(path,user2pref.path)
    chebfunpref(user2pref.pref);
    cheboppref(user2pref.oppref);
    disp('Restored values of warning, path, and chebfunpref.')
    return
end

% init some local data
pref = chebfun2pref;
tol = pref.eps;
createreport = true;
avgtimes = false; % If turning off, remember to remove line from help comments.
nr_tests = 0;
tests = struct('fun','','path','','funptr',[]);

if verLessThan('matlab','7.6')
    matlabver = ver('matlab');
    disp(['MATLAB version: ',matlabver.Version, ' ', matlabver.Release])
    error('CHEBFUN:chebtest:version',['Chebfun is compatible' ...
        ' with MATLAB 7.6 (R2008a) or above.'])
end

% Chebfun directory
chbfundir = fileparts(which('cheb2test.m'));

if nargin < 1
    % Attempt to find "chebtests" directory.
    dirname = fullfile(chbfundir,'cheb2test');
end

% Deal with levelX input
if ischar(dirname)
    if ~isempty(str2num(dirname))
        dirname = str2num(dirname);
    elseif strncmpi(dirname,'level',5)
        dirname = fullfile(chbfundir,'cheb2test',lower(dirname));
    end
end
if isnumeric(dirname)
    if numel(dirname) == 1
        dirname = fullfile(chbfundir,'cheb2test',['level',num2str(dirname)]);
    else
        error('CHEB2FUN:cheb2test:numdirs','Can only cheb2test all test directories at once, or one at a time.');
    end
end

if ~exist(dirname,'dir')
  msg = ['The name "' dirname '" does not appear to be a directory on the path.'];
  error('CHEBFUN2:cheb2test:nodir',msg)
end


% Store user preferences for warning and chebfunpref
warnstate = warning;
user2pref.warnstate = warnstate;
user2pref.path = path;
user2pref.pref = pref;
user2pref.oppref = cheboppref;
user2pref.dirname = dirname;

% Add chebtests directory to the path
addpath(dirname)

% loop over the level directories (first)
subdirlist = dir( fullfile(dirname,'Level*') );
subdirnames = { subdirlist.name };
for i=1:length(subdirnames)

    % is this really a directory?
    if ~subdirlist(i).isdir, continue; end;
    
    % add it to the path
    addpath( fullfile(dirname,subdirnames{i}) );

    % Get the names of the tests for this level
    dirlist = dir(fullfile(dirname,subdirnames{i},'*.m'));
    for j=1:length(dirlist)
        nr_tests = nr_tests + 1;
        tests(nr_tests).fun = dirlist(j).name(1:end-2);
        tests(nr_tests).path = [ dirname filesep subdirnames{i} filesep dirlist(j).name ];
        tests(nr_tests).funptr = str2func( dirlist(j).name(1:end-2) );
    end;
    
    % remove the path
    rmpath( fullfile(dirname,subdirnames{i}) )
    
end;

% Get the names of any un-sorted tests
dirlist = dir( fullfile(dirname,'*.m') );
for j=1:length(dirlist)
    nr_tests = nr_tests + 1;
    tests(nr_tests).fun = dirlist(j).name(1:end-2);
    tests(nr_tests).path = [ dirname filesep dirlist(j).name ];
    tests(nr_tests).funptr = str2func( dirlist(j).name(1:end-2) );
end;

% restore the original path names
path( user2pref.path );

% check for duplicate chebtest names
um = unique( { tests(:).fun } , 'first' );
if numel(um) < nr_tests
    warning('CHEBFUN2:cheb2test:unique','Nonunique cheb2test names detected.');
end

% Find the length of the names (for pretty display later).
namelen = 0;
for k = 1:nr_tests
    namelen = max(namelen,length(tests(k).fun));
end;
    
% Initialise some storage
failed = zeros(nr_tests,1);  % Pass/fail
t = failed;                        % Vector to store times

% Clear the report file (and check we can open file)
report = fullfile(chbfundir,'cheb2test','cheb2test_report.txt');
[fid message] = fopen(report,'w+');
if fid < 0
    warning('CHEBFUN2:cheb2test:fopenfail', ...
        ['Cannot create cheb2test report: ', message]);
    createreport = false;
    avgtimes = false;
else
    fclose(fid);
end

% For looking at average time performance.
if avgtimes
    avgfile = fullfile(chbfundir,'cheb2tests','cheb2test_avgs.txt');
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

prevdir = 'bogus';

% Turn off warnings for the test
warning off

% loop through the tests
for j = 1:nr_tests
  fun = tests(j).fun;
  % Print the test directory (if new)
  whichfun = tests(j).path;
  fparts = fileparts(whichfun);
  curdir = fparts(find(fparts==filesep,1,'last')+1:end);
  if ~strcmp(curdir,prevdir)
      prevdir = curdir;
      fprintf('%s tests:\n',curdir);
  end
  % Print the test name
  if javacheck
      link = ['<a href="matlab: edit ''' whichfun '''">' fun '</a>'];
  else
      link = fun;
  end
  ws = repmat(' ',1,namelen+3-length(fun)-length(num2str(j)));
  msg = ['  Function #' num2str(j) ' (' link ')... ', ws ];
  msg = strrep(msg,'\','\\');  % escape \ for fprintf
  numchar = fprintf(msg);
  % Execute the test
  try
    close all
%     chebfunpref('factory');
%     cheboppref('factory');
    chebfun2pref('eps',tol);
    tic
    pass = feval( tests(j).funptr );
    t(j) = toc;
    failed(j) = ~ all(pass);
    if failed(j)
      fprintf('FAILED\n')
      
      % Create an error report entry for a failure
      if createreport
        fid = fopen(report,'a');
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
        fid = fopen(report,'a');
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
warning(warnstate)
chebfun2pref(pref);

% Final output
ts = sum(t); tm = ts/60;
if avgN == 0
    fprintf('Total time: %1.1f seconds = %1.1f minutes \n',ts,tm)
else
    fprintf('Total time: %1.1f seconds (Lifetime Avg: %1.1f seconds)\n',ts,avgTot)
end

if all(~failed)
  fprintf('\nAll tests passed!\n')
  failfun = [];
else
  fprintf('\n%i failed and %i crashed\n',sum(failed>0),sum(failed<0))
  failfun = tests(failed~=0);
  if createreport
      if javacheck
          link = ['<a href="matlab: edit ''' report '''">chebtest_report.txt</a>'];
      else
          link = report;
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
    if isempty(failfun)
        varargout{1} = [];
    else
        varargout{1} = { failfun(:).fun }; 
    end
else
    fprintf('    ');
    for k = 1:sum(abs(failed))
        fun = failfun(k).fun;
        whichfun = failfun(k).path;
        if javacheck         
            link = ['<a href="matlab: edit ''' whichfun '''">' fun '</a>    '];
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
    fid = fopen(report,'a');

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
elseif createreport && ~any(failed)
    delete(report);
end
