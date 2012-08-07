function make_tags

% Website directory
webdir = '/common/htdocs/www/maintainers/hale/chebfun/';
% Get tag info locally
examplesdir = pwd;

% The outputs
tagsfile = fullfile(examplesdir,'tags.php');
listfile = fullfile(examplesdir,'tags.list');

% Initialise the lists
tagslist = {}; filelist = {}; dirlist = {};
namelist = {}; tidynamelist = {};

% Find the relevent directories
alldirs = struct2cell(dir(fullfile(examplesdir)));
dirs = {}; k = 1;
for j = 3:size(alldirs,2)
    if alldirs{4,j} && ...
            ~strncmp(alldirs{1,j},'.',1) && ...
            ~strcmp(alldirs{1,j},'templates') && ...
            ~strcmp(alldirs{1,j},'old_examples') && ...
            ~strcmp(alldirs{1,j},'old') && ...
            ~strcmp(alldirs{1,j},'temp')
        dirs{k} = alldirs{1,j};
        k = k + 1;
    end
end

% Get all the files
for j = 1:size(dirs,2)
    tmp = struct2cell(dir(fullfile(examplesdir,dirs{j},'*.m')));
    tmp = tmp(1,:);
    filelist = [filelist tmp];
    tmp = repmat(dirs(j),1,numel(tmp));
    dirlist = [dirlist tmp];
end

for j = 1:numel(filelist);
    % Open the file
    fid = fopen(fullfile(examplesdir,dirlist{j},filelist{j}));
    
    % Get the titles
    txt = fgetl(fid);
    origtxt = txt;
    txt = upper(txt);
    if txt < 1, continue, end % This mfile will be ignored
    if numel(txt) >1 && strcmp(txt(1:2),'%%')
        txt = txt(4:end);
    else
        txt = '     ';  % This mfile will be ignored
    end
    if strcmpi(txt(1:2),'A ')
        txt = txt(3:end);
    elseif strcmpi(txt(1:3),'AN ')
        txt = txt(4:end);             
    elseif strcmpi(txt(1:4),'THE ')
        txt = txt(5:end);
    end
    tidynamelist{j} = txt;
    origtxt = origtxt(4:end);
    if numel(origtxt) > 50
        idx = strfind(origtxt,':');
        if ~isempty(idx), origtxt = origtxt(1:idx(1)-1); end
    end
    namelist{j} = origtxt;
        
    % Ignore these lines    
    for k = 2:5
        tmp = fgetl(fid);
    end
    tagline{j} = fgetl(fid);
    fclose(fid);
    
    % Seach for hashtags
    idx = strfind(tagline{j},'#');
    if isempty(idx)
        tagline{j} = '';
        continue
    end   
    idx2 = strfind(tagline{j},',');
    tags = {};
    for k = 1:numel(idx2)
        tags{k} = tagline{j}(idx(k)+1:idx2(k)-1);
    end
    tags{numel(idx)} = tagline{j}(idx(end)+1:end-1);
    tagline{j} = tagline{j}(idx(1):end-1);
    
    % Determine if new tag or existing
    for k = 1:numel(tags)
        if isempty(tagslist)
            idx = 0;
        else
            idx = strcmp(tags{k},tagslist(:,1));
        end
        if any(idx)
            idx = find(idx);
            tagslist{idx,2} = [tagslist{idx,2} j];
        else
            if isempty(tags{k})
                error('Error in tagging %s/%s',dirlist{j},filelist{j}), end
            tagslist{end+1,1} = tags{k};
            tagslist{end,2} = j;
        end
    end
end

% Sorting...
% Sort by number of times tagged
% [numtags idx] = sort(cellfun(@numel,tagslist(:,2)),'descend');
% Sort alphabetically
[ignored idx] = sort(tagslist(:,1));
% Do the sort
tagslist = tagslist(idx,:);

numtags = cellfun(@numel,tagslist(:,2));

[ignored idx2] = sort(tidynamelist);
% Write to the tags.list file
fid_list = fopen(listfile','w');
for k = 1:numel(tagline);
    j = idx2(k);
    % Get and clean the tags
    string = tagline{j};
    if isempty(string), continue, end
    string = [dirlist{j} '/' filelist{j}(1:end-2) ' ' strrep(string,',','') '\n'];
    fprintf(fid_list,string);
end
fclose(fid_list);


%% junk

% for j = 1:size(tagslist,1)
%     fprintf(fid,['<h2 id="' tagslist{j} '">#' tagslist{j} '</h2>\n']);
%     fprintf(fid,'<ul>\n');
%     kk = tagslist{j,2};
%     [ignored idx] = sort(tidynamelist(kk));
%     for k = kk(idx);
%         url = ['/chebfun/examples/' dirlist{k} '/html/' filelist{k}(1:end-2),'.shtml'];
%         fprintf(fid,['<li><a href="' url '">' namelist{k} '</a></li>\n']);
%     end
%     fprintf(fid,'</ul>\n\n');
% end

%%

% make some PHP/HTML magic
fid = fopen(tagsfile,'w+');

fidtmp = fopen([examplesdir '/templates/php_template1.txt'],'r');
while 1
    tline = fgetl(fidtmp);
    if ~ischar(tline), break, end
    fprintf(fid,tline);
    fprintf(fid,'\n');
end
fclose(fidtmp);

fprintf(fid,'<head>\n<title>Tag search</title>\n');
tmpdir = '/common/htdocs/www/maintainers/hale/chebfun/includes/';
fidtmp = fopen([tmpdir 'head.html'],'r');
while 1
    tline = fgetl(fidtmp);
    if ~ischar(tline), break, end
    if strfind(tline,'x-mathjax-config'), break, end
    fprintf(fid,tline);
    fprintf(fid,'\n');
end
fclose(fidtmp);
fprintf(fid,'</head>\n\n<body>\n<div id="headimg"></div>\n<div id="wrapper"> <!--WRAPPER-->');
fidtmp = fopen([tmpdir 'header.html'],'r');
while 1
    tline = fgetl(fidtmp);
    if ~ischar(tline), break, end
    fprintf(fid,tline);
    fprintf(fid,'\n');
end
fclose(fidtmp);
fidtmp = fopen([tmpdir 'mainmenu.html'],'r');
while 1
    tline = fgetl(fidtmp);
    if ~ischar(tline), break, end
    fprintf(fid,tline);
    fprintf(fid,'\n');
end
fclose(fidtmp);
fprintf(fid,'<h2 class="bigger">Tag search</h2>\n<div id="mycontent"> <!--CONTENT-->\n');

fprintf(fid,'<form action="tags.php" method="get">\n');
fprintf(fid,'search: <input type="text" name="query" />\n');
fprintf(fid,'<input type="submit" />\n</form>');

fidtmp = fopen([examplesdir '/templates/php_template2.txt'],'r');
while 1
    tline = fgetl(fidtmp);
    if ~ischar(tline), break, end
    fprintf(fid,tline);
    fprintf(fid,'\n');
end
fclose(fidtmp);


%%

fprintf(fid,['<h2 class="bigger" style="margin-left:-15pt; margin-top:10pt; margin-bottom:-10pt;">Tag cloud</h2>']);

% Create the cloud
maxfont = 500;
scl = ceil(maxfont/power(max(numtags),.666));
fsize = floor(max(scl*power(numtags,.66),50));
cloud = [];
for j = randperm(size(tagslist,1))
    if strcmp(tagslist{j},upper(tagslist{j})) && ...
       ~any(strcmpi(tagslist{j},{'FFT','2D','IVP'})) && ...
        isempty(str2num(tagslist{j}))
        continue
    end
    cloud = [cloud '<b style="font-size:' num2str(fsize(j)) '%%">',...
        '<a href="/chebfun/examples/tags.php?query=' tagslist{j} '">' tagslist{j} '</a></b>', ...
        '<b style="font-size:100%%"> </b>'];
%     '<a href="/chebfun/examples/tags.shtml#' tagslist{j} '">' tagslist{j} '</a></b>', ...
end
fprintf(fid,['<br/>\n\n<span style="width:400px">' cloud '</span>\n']);

fprintf(fid,['<h2 class="bigger" style="margin-left:-15pt; margin-top:10pt; margin-bottom:-10pt;">Function cloud</h2>']);
% Create the cloud
maxfont = 500;
scl = ceil(maxfont/power(max(numtags),.666));
fsize = floor(max(scl*power(numtags,.66),50));
cloud = [];
for j = randperm(size(tagslist,1))
    if ~strcmp(tagslist{j},upper(tagslist{j})) || ...
            any(strcmpi(tagslist{j},{'FFT','2D','IVP'})) || ...
            ~isempty(str2num(tagslist{j}))
            continue
    end
    cloud = [cloud '<b style="font-size:' num2str(fsize(j)) '%%">',...
        '<a href="/chebfun/examples/tags.php?query=' tagslist{j} '">' tagslist{j} '</a></b>', ...
        '<b style="font-size:100%%"> </b>'];
%     '<a href="/chebfun/examples/tags.shtml#' tagslist{j} '">' tagslist{j} '</a></b>', ...
end
fprintf(fid,['<br/>\n\n<span style="width:400px">' cloud '</span>\n']);

%%

fprintf(fid,'</div> <!--END CONTENT-->\n<div class="hr1"> <hr /> </div>\n');
fidtmp = fopen([tmpdir 'footer.html'],'r');
while 1
    tline = fgetl(fidtmp);
    if ~ischar(tline), break, end
    fprintf(fid,tline);
    fprintf(fid,'\n');
end
fclose(fidtmp);
fprintf(fid,'</div> <!--END WRAPPER-->\n<div id="footimg"></div>\n</body>\n</html>');
fclose(fid);

%%

% Upload
fprintf('Uploading tags...')
try
    eval(['!mv ' tagsfile ' ' webdir 'examples/'])
    eval(['!mv ' listfile ' ' webdir 'examples/'])
    fprintf('DONE!\n')
catch
    fprintf('FAILED!\n')
end

