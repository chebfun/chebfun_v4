function make_examples(dirs,filename)
%MAKE_EXAMPLES  Publish the files in the examples directory.
% MAKE_EXAMPLES(DIR) published only the files in $Chebfunroot/examples/DIR,
% where DIR may be a string or a cell array of strings.
%
% MAKE_EXAMPLES(DIR,FILE) will only publish the file FILENAME.M in directory 
% $Chebfunroot/examples/DIR/ where FILENAME and DIR must be strings.

% The flags below can only be adjusted manually.
html = false;  % Publish to html? (This should be true when released).
pdf = false;   % By default this will be off.
shtml = true; % This should only be used by admin for creating the 
              % shtml files for the Chebfun website.
clean = true;

% Define formatting.
chebdir = fileparts(which('chebtest'));
% HTML formatting
opts = [];
opts.stylesheet = fullfile(chebdir,'notes/custom_mxdom2simplehtml.xsl'); 
if ~shtml || ~exist(opts.stylesheet,'file'), 
    opts.stylesheet = [];   % Resort to default stylesheet.
end       
opts.catchError = false;
% PDF formatting
optsPDF = [];
optsPDF.stylesheet = fullfile(chebdir,'notes/custom_mxdom2latex.xsl'); 
if ~shtml || ~exist(optsPDF.stylesheet,'file'), 
else
    optsPDF.stylesheet = [];   % Resort to default stylesheet.
end 
optsPDF.format = 'latex'; 
optsPDF.outputDir = 'pdf'; 
optsPDF.catchError = false;

if nargin == 0
    % Find all the directories (except some exclusions).
    dirlist = struct2cell(dir(fullfile(pwd)));
    dirs = {}; k = 1;
    for j = 3:size(dirlist,2)
        if dirlist{4,j} && ...
                ~strncmp(dirlist{1,j},'.',1) && ...
                ~strcmp(dirlist{1,j},'templates') && ...
                ~strcmp(dirlist{1,j},'old_examples') && ...
                ~strcmp(dirlist{1,j},'old')
            dirs{k} = dirlist{1,j};
            k = k + 1;
        end
    end
elseif nargin == 1 && ischar(dirs)
    % Directory has been passed
    dirs = {dirs};
elseif nargin == 2
    % Compile a single file (given)
    html = true; pdf = true;
    if iscell(dirs), dirs = dirs{:}; end
    if strcmp(filename(end-1:end),'.m'), 
        filename = filename(1:end-2); 
    end
    cd(dirs);
    %%% HTML %%%
    if html
        % Publish (to dirname/html/dirname.html)
        publish([filename,'.m'],opts);           close all
    end
    %%% PDF %%%
    if pdf
        % Publish (to dirname/pdf/dirname.pdf)
        publish([filename,'.m'],optsPDF);        close all
        try
            cd pdf
            if exist([filename,'.pdf'],'file') 
                eval(['!latex ',filename]) 
            end
            eval(['!latex ',filename])
            eval(['!dvipdfm ',filename])
            ! rm *.aux *.log *.tex  *.dvi *.eps
            cd ../
        catch
            warning('CHEBFUN:examples:PDFfail','PDF PUBLISH FAILED.');
        end            
    end
    cd ..
    return
end
    
% Clean up
if clean
    for j = 1:numel(dirs)
        cd(dirs{j})
        delete *.html *.shtml
        rmdir html s
        rmdir pdf s
        cd ..
    end
    return
end

% % Make examples.html
% fid0 = fopen('examples.html','w+');

% Loop over the directories.
for j = 1:numel(dirs)
%     % Add entry to examples/examples.html
%     if shtml
%         fprintf(fid0,['<a href="',dirs{j},'/">',dirs{j},'</a>\n<br/>\n']);
%     else
%         fprintf(fid0,['<a href="',dirs{j},'/',dirs{j},'.html">',dirs{j},'</a>\n<br/>\n\n']);
%     end  
    
    % Find the title of this directory
    fidc = fopen('contents.txt','r+');
    prevdir = [];
    titletxt = fgetl(fidc);
    while ~strncmp(dirs{j},titletxt,3)
        prevdir = titletxt;
        titletxt = fgetl(fidc);
        if titletxt < 0, 
            error('CHEBFUN:examples:dirname', ...
                ['Unknown directory name "',dirs{j},'. Update contents.txt.']);
        end        
    end
    titletxt = titletxt(length(dirs{j})+2:end);
    
    % Find the next and previous directories for breadcrumbs
    nextdir = fgetl(fidc);
    if isnumeric(nextdir)
        nextdir = [];
    else
        idx = strfind(nextdir,' ');
        nextdir = nextdir(1:idx-1);
    end
    if ~isempty(prevdir)
        idx = strfind(prevdir,' ');
        prevdir = prevdir(1:idx-1);
    end    
    fclose(fidc);
    
    % Move to the directory.
	cd(dirs{j})
    % Find all the m-files.
    dirlist = dir(fullfile(pwd,'*.m'));
    mfile = {dirlist.name};      
    
    % Make dirname/dirname.html
    fid = fopen([dirs{j},'.html'],'w+');
    % Write title
%     if shtml, fprintf(fid,['<div style="position:relative; left:-20px;">\n']);  end
    fprintf(fid,['                <h2>Chebfun Examples: ',titletxt,'</h2>\n']);
%     if shtml, fprintf(fid,'            </div>\n');  end
    if shtml
        % Make dirname/index.shtml
        make_shtml('index',dirs{j},[],titletxt,[],nextdir,prevdir);
    end
    
    % Get the ordering (we need to ignore A and THE)
    desc = cell(numel(mfile),1); 
    for k = 1:numel(mfile)
        filename = mfile{k}(1:end-2);
               
        % Grab the file description.
        fidk = fopen([filename,'.m']);
        txt = fgetl(fidk);
        fclose(fidk);
        if txt < 1, continue, end % This mfile will be ignored
        if numel(txt) >1 && strcmp(txt(1:2),'%%')
            txt = txt(4:end);
        else
            txt = '     ';  % This mfile will be ignored
        end
        if strcmpi(txt(1:2),'A ')
            txt = txt(3:end);
        elseif strcmpi(txt(1:4),'THE ')
            txt = txt(5:end);
        end
        desc{k} = txt;
    end
    [desc indx] = sort(desc);
    mfile = mfile(indx);
    
    % Loop over the files
    for k = 1:numel(mfile)
        close all
        filename = mfile{k}(1:end-2);
               
        % Grab the file description (again).
        fidk = fopen([filename,'.m']);
        txt = fgetl(fidk); fclose(fidk);
        if txt < 1, continue, end % Ignore this file.
        if numel(txt) >1 && strcmp(txt(1:2),'%%')
            txt = txt(4:end);
        else
            continue % This mfile will be ignored
%             txt = [filename,'.m'];
        end
        fprintf(fid,[txt, '     (']);
        
        % Make dirname/html/filename.shtml
        if shtml
            if k < numel(mfile), next = mfile{k+1}(1:end-2); else next = []; end
            if k > 1, prev = mfile{k-1}(1:end-2); else prev = []; end
            make_shtml(filename,filename,'html',upper(txt),titletxt,next,prev);
        end

        %%% HTML %%%
        if html
            % Publish (to dirname/html/dirname.html)
            publish([filename,'.m'],opts);           close all
        end
        if shtml && exist(fullfile('html',[filename,'.shtml']),'file')
        % Link to dirname/html/filename.shtml
            fprintf(fid,'<a href="html/%s.shtml">html</a>, ',filename);
        elseif exist(fullfile('html',[filename,'.html']),'file')
        % Link to dirname/html/filename.html
            link = fullfile('html','%s.html',filename);
            fprintf(fid,'<a href="%s">html</a>, ',link);
        end
        
        %%% PDF %%%
        if pdf
            % Publish (to dirname/pdf/dirname.pdf)
            publish([filename,'.m'],optsPDF);        close all
            try
                cd pdf
                if exist([filename,'.pdf'],'file') 
                    eval(['!latex ',filename]) % Remove existing pdf.
                end
                eval(['!latex ',filename])
%                 eval(['!dvips ',filename])
%                 eval(['!ps2pdf ',filename,'.ps ',filename,'.pdf'])
                eval(['!dvipdfm ',filename])
                ! rm *.aux *.log *.tex  *.dvi *.eps
%                 ! rm *.ps 
                cd ../
            catch
                warning('CHEBFUN:examples:PDFfail','PDF PUBLISH FAILED.#');
            end            
        end
        % Link to dirname/pdf/<filename>.pdf
        if exist(fullfile('pdf',[filename,'.pdf']),'file')
            if shtml
                link = ['pdf/',filename,'.pdf'];
            else
                link = fullfile('pdf',[filename,'.pdf']);
            end
%             fprintf(fid,['<a href="',link,'" target="_blank">PDF</a>, ']);
            fprintf(fid,'<a href="%s">PDF</a>, ',link);
        end
        
        %%% M-FILES %%%
        fprintf(fid,'<a href="%s.m">M-file</a>)\n',filename);
        fprintf(fid,'                <br/>\n\n');
        

    end
    fclose(fid);

    fprintf([dirs{j},' published\n'])
    cd ..
end

% fclose(fid0);

% Upload to web server.
webdir = '/common/htdocs/www/maintainers/hale/chebfun/';
if shtml
%     fprintf('Copy the following to a bash terminal:\n')
%     fprintf(['cp -r ',pwd,' ',webdir,'\n'])

    curdir = pwd;
    webdir = '/common/htdocs/www/maintainers/hale/chebfun/';
%     eval(['!cp -r ',pwd,' ',webdir])
    cd(webdir)
    !chmod -R 775 examples
    cd examples
%     !rm -rf .svn
%     !chgrp chebfun *
%     !chmod 664 *
    for j = 1:numel(dirs)
        fprintf(['Uploading ',dirs{j},'. Please wait ... '])
        eval(['!cp -r ',curdir,'/',dirs{j},' ',webdir,'examples'])
        fprintf('Complete.\n')
        eval(['!chmod -R 775 ',dirs{j}])
        cd(dirs{j})
        !rm -rf .svn
        !chgrp chebfun *
        if exist('html','dir')
            eval(['!chmod -R 775 ','html'])
            cd html
            !rm -rf .svn
            !chgrp chebfun *
            cd ..
        end
        if exist('pdf','dir')
            eval(['!chmod -R 775 ','pdf'])
            cd pdf
            !rm -rf .svn
            !chgrp chebfun *
            cd ..
        end
        cd ..
    end
%     !rm make_examples.m
%     !rm examples.html
%     !rm contents.txt
    cd(curdir)
    return
end



function make_shtml(file1,file2,dir,title,dirtitle,next,prev)
if nargin < 3, dir = []; end
% Create the files.
if ~isempty(dir)
    if ~exist(fullfile(dir),'dir')
        !mkdir html
    end
    fid = fopen([dir,'/', file1,'.shtml'],'w+');
else
    fid = fopen([file1,'.shtml'],'w+');
end

% Open the templates.
fid1 = fopen('../templates/template1.txt','r');
if ~isempty(dir)
    fid2 = fopen('../templates/template2.txt','r');
else
    fid2 = fopen('../templates/template3.txt','r');
end

% Read their data.
tmp1 = fread(fid1,inf,'*char');
tmp2 = fread(fid2,inf,'*char');
fclose(fid1);
fclose(fid2);

% Write to file.
if ~isempty(dir)
    fprintf(fid,'<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">');
else
    fprintf(fid,'<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">');
    fprintf(fid,'\n<html xmlns="http://www.w3.org/1999/xhtml">\n');
end

% HEAD
fprintf(fid,'\n<head>\n');
% TITLE
fprintf(fid,'<title>%s</title>\n',lower(title));

% META DATA
if ~isempty(dir)
    v = version; indx = strfind(v,'.'); v = v(1:indx(2)-1);
    fprintf(fid,'<meta name="generator" content="MATLAB %s">\n',v);
    fprintf(fid,'<link rel="schema.DC" href="http://purl.org/dc/elements/1.1/">\n');
    fprintf(fid,'<meta name="DC.date" content="%s">\n',datestr(now, 'yyyy-mm-dd'));
    fprintf(fid,'<meta name="DC.source" content="%s.m">\n',file1);
end

% TEMPLATE1
fwrite(fid, tmp1);

% BREADCRUMBS
if ~isempty(dir)
    % 2nd level
    fprintf(fid,'            <div id="breadcrumb"> > <a href="../../">examples</a> > <a href="../" class="lc">%s</a>',dirtitle);
    if ~isempty(prev)
        fprintf(fid, ' | <a href="%s.shtml">previous</a>',prev);
    else
        fprintf(fid, ' | previous');
    end
    if ~isempty(next)
        fprintf(fid, ' | <a href="%s.shtml">next</a>',next);
    else
        fprintf(fid, ' | next');
    end
    fprintf(fid,'</div>\n');
else
    % 1st level
    fprintf(fid,'            <div id="breadcrumb"> > <a href="../">examples</a>');
    if ~isempty(prev)
        fprintf(fid, ' | <a href="../%s">previous</a>',prev);
    else
        fprintf(fid, ' | previous');
    end
    if ~isempty(next)
        fprintf(fid, ' | <a href="../">next</a>',next);
    else
        fprintf(fid, ' | next');
    end
    fprintf(fid,'</div>\n');
end
% HTML INCLUDE
fprintf(fid,'            <!--#include virtual="%s.html" -->\n',file2);
% TEMPLATE 2
fwrite(fid, tmp2);
fclose(fid);
