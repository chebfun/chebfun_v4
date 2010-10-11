function make_examples(dirs)
%MAKE_EXAMPLES  Publish the files in the examples directory.
% MAKE_EXAMPLES(DIR) published only the files in $Chebfunroot/examples/DIR,
% where DIR may be a string or a cell array of strings.

% The flags below can only be adjusted manually.
html = true;  % Publish to html? (This should be true when released).
pdf = false;   % By default this will be off.
shtml = false; % This should only be used by admin for creating the 
               % shtml files for the Chebfun website.
clean = false;

% Define formatting.
chebdir = fileparts(which('chebtest'));
xsl = fullfile(chebdir,'custom_mxdom2simplehtml.xsl'); 
if exist(xsl,'file'), 
    opts.stylesheet = xsl;  % Custom stylesheet if available.
else
    opts.stylesheet = [];   % Resort to default.
end                    
optsPDF.format = 'latex'; optsPDF.outputDir = 'pdf';

if nargin == 0
    % Find all the dicrectories (except 'templates' and 'old_examples').
    dirlist = struct2cell(dir(fullfile(pwd)));
    dirs = {}; k = 1;
    for j = 3:size(dirlist,2)
        if dirlist{4,j} && ~strcmp(dirlist{1,j},'templates') && ~strcmp(dirlist{1,j},'old_examples')
            dirs{k} = dirlist{1,j};
            k = k + 1;
        end
    end
elseif ischar(dirs)
    dirs = {dirs};
end

% Clean up
if clean
    for j = 1:numel(dirs)
        cd(dirs{j})
        delete *.html *.shtml
        rmdir html s
        rmdir pdf s
        %!rm *.html *.shtml
        %!rm -r html/
        %!rm -r pdf/
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
    
    fidc = fopen('contents.txt','r+');
    titletxt = fgetl(fidc);
    while ~strncmp(dirs{j},titletxt,3)
        titletxt = fgetl(fidc);
        if isequal(titletxt,-1)  % EOF
          break
        end
    end
    titletxt = titletxt(length(dirs{j})+2:end);
    fclose(fidc);
    
    % Move to the directory.
	cd(dirs{j})
    % Find all the m-files.
    dirlist = dir(fullfile(pwd,'*.m'));
    mfile = {dirlist.name};
    
    % Make dirname/dirname.html
    fid = fopen([dirs{j},'.html'],'w+');
    % Write title
    if shtml, fprintf(fid,'<div style="position:relative; left:-20px;">\n');  end
    fprintf(fid,'<h2 class="bigger">Chebfun Examples: %s</h2>\n',titletxt);
    if shtml, fprintf(fid,'</div>\n');  end
    if shtml
        % Make dirname/index.shtml
        make_shtml('index',dirs{j});
    end
    
    % Loop over the files
    for k = 1:numel(mfile)
        
        if shtml
            % Make dirname/html/filename.shtml
            make_shtml(mfile{k}(1:end-2),mfile{k}(1:end-2),'html');
        end
        
        % Grab the file description.
        fidk = fopen(mfile{k});
        txt = fgetl(fidk);
        if strcmp(txt(1:8),'function')
            txt = fgetl(fidk);
        end
        fclose(fidk);
        if strcmp(txt(1:2),'%%')
            txt = txt(4:end);
        else
            txt = mfile{k};
        end
        fprintf(fid,[txt, '     (']);

        %%% HTML %%%
        if html
            % Publish (to dirname/html/dirname.html)
            publish(mfile{k},opts);           close all
        end
        if shtml && exist(fullfile('html',[mfile{k}(1:end-2),'.shtml']),'file')
        % Link to dirname/html/filename.shtml
            fprintf(fid,'<a href="html/%s.shtml">html</a>, ',mfile{k}(1:end-2));
        elseif exist(fullfile('html',[mfile{k}(1:end-2),'.html']),'file')
            % Link to dirname/html/filename.html
            link = fullfile('html',[mfile{k}(1:end-2),'.html']);
            fprintf(fid,'<a href="%s">html</a>, ',link);
        end
        
        %%% PDF %%%
        if pdf
            % Publish (to dirname/pdf/dirname.pdf)
            publish(mfile{k},optsPDF);        close all
            try
                cd pdf
                delete *.pdf    % !rm *.pdf
                !latex *.tex
                !dvips *.dvi
                !ps2pdf *.ps file.pdf
                ! rm *.aux *.log *.dvi *.ps
%                 ! rm *.tex *.eps
                cd ../
            end
            
        end
        % Link to dirname/pdf/filename.pdf
        if exist(fullfile('pdf',[mfile{k}(1:end-2),'.pdf']),'file')
            if shtml
                link = ['pdf/',mfile{k}(1:end-2),'.pdf'];
            else
                link = fullfile('pdf',[mfile{k}(1:end-2),'.pdf']);
            end
            fprintf(fid,'<a href="%s" target="_blank">PDF</a>, ',link);
        end
        
        % Link to dirname/pdf/file.pdf
        if exist(fullfile('pdf','file.pdf'),'file')            
            if shtml
                link = 'pdf/file.pdf';
            else
                link = fullfile('pdf','file.pdf');
            end
            fprintf(fid,'<a href="%s" target="_blank">PDF</a>, ',link);
        end
        
        %%% M-FILES %%%
        fprintf(fid,'<a href="%s">M-file</a>)\n',mfile{k});
        fprintf(fid,'                <br/>\n\n');
        

    end
    fclose(fid);

    pwd
    cd ..
end

% fclose(fid0);

webdir = '/common/htdocs/www/maintainers/hale/chebfun/examples/';
if shtml
    fprintf('Copy the following to a bash terminal:\n')
    fprintf(['cp -r ',pwd,' ',webdir,'\n'])
end


function make_shtml(file1,file2,dir)

% Create the files.
if nargin == 3
    if ~exist(fullfile(dir),'dir')
        !mkdir html
    end
    fid = fopen([dir,'/', file1,'.shtml'],'w+');
else
    fid = fopen([file1,'.shtml'],'w+');
end

% Open the templates.
fid1 = fopen('../templates/template1.txt','r');
if nargin == 3
    fid2 = fopen('../templates/template2.txt','r');
else
    fid2 = fopen('../templates/template3.txt','r');
end

% Read their data.
tmp1 = fread(fid1,inf,'*char');
fclose(fid1);
tmp2 = fread(fid2,inf,'*char');
fclose(fid2);

% Write to file.
fwrite(fid, tmp1);
fprintf(fid,['            <!--#include virtual="',file2,'.html" -->\n']);
fwrite(fid, tmp2);
fclose(fid);


    
    