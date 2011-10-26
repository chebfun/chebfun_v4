function new_examples(examples)
% Generates html for the 'new examples' on the Chebfun homepage.

% examples = {'geom','Ellipses'};

fid = fopen('newexamples.html','w+');

% color = {'#d9e3e5'
%          '#e4ecef'
%          '#eaefef'
%          '#eff2f2'};
     
color = {'#d9e3e5'
     '#e4ecef'
     '#eff2f2'};
     
newline = '\n'     ;
str1 = '        <h3>New Examples:</h3>';
str2 = '        <div style="background:#fff; color:#000; height:170px;">';
str3 = '            <div style="float:left; background:#fff; width:410px; padding:1px 0px; height:160px">';
str = [str1,newline,str2,newline,str3];
fprintf(fid,str);

examplesdir = '/chebfun/examples/';
webdir = '/common/htdocs/www/maintainers/hale/chebfun/';
dir1 = examples{1}; file1 = examples{2};

k = 0;
while ~isempty(examples)
    k = k+1;
    dir = examples{1};
    file = examples{2};
    examples(1:2) = [];
    filedir = [examplesdir, dir, '/html/'];
    STYLE = ['style="background:',color{k},';"'];
    
    fidk = fopen([dir,'/',file,'.m']);
    title = fgetl(fidk);
    title = title(4:end);
    nameanddate = fgetl(fidk);
    nameanddate = nameanddate(3:end);
    fclose(fidk);
    
    ws = '                ';
    str1 = '<b class="rtop2" style="margin-top:3px"><b class="r1" STYLE></b><b class="r2" STYLE></b><b class="r3" STYLE></b><b class="r4" STYLE></b></b>';
    str1 = strrep(str1,'STYLE',STYLE);
    fprintf(fid,[newline, ws, str1]);
    
    str2 = '<div style="margin:0px; padding:4px; padding-left:20px; background:';
    fprintf(fid,[newline,ws,str2,color{k},';">']);
    
    str3 = ['<a href="',filedir,file,'.shtml" onmouseover="document.images[''exampleImage''].src=''',filedir,file,'_01.png''">',title,'</a>'];
    str3b = ['<p style="font-size:11px; margin:0px; padding:0px;">',nameanddate,'</p>'];
    fprintf(fid,[newline, ws,'   ',str3,newline, ws,'   ',str3b,newline,ws,'</div>']);
    
    str4 = '<b class="rbottom2"><b class="r4" STYLE></b><b class="r3" STYLE></b><b class="r2" STYLE></b><b class="r1" STYLE></b></b>';
    str4 = strrep(str4,'STYLE',STYLE);
    fprintf(fid,[newline, ws, str4]);
end

str = {};
str{1} = '            </div>';
str{2} = '            <div style="float:right; width:220px; padding-left:10px; padding-right:16px;">';
str{3} = '                <b class="rtop2"><b class="r1"></b><b class="r2"></b><b class="r3"></b><b class="r4"></b></b>';
str{4} = ['                <div style="float:right; background:',color{1},'; width:190; height:160px; padding-left:10px; padding-right:10px; align:center;">'];
str{5} = ['                    <img src="',examplesdir,dir1,'/html/',file1,'_01.png" height="150px" name="exampleImage" style="margin-top:5px;">'];
str{6} = '                </div>';
str{7} = '                <b class="rbottom2"><b class="r4"></b><b class="r3"></b><b class="r2"></b><b class="r1"></b></b>';
str{8} = '            </div>';
str{9} = '      </div>';

for k = 1:numel(str)
    fprintf(fid,[newline,str{k}]);
end

fclose(fid);

cmd = ['!mv newexamples.html ',webdir,'includes/'];
eval(cmd)

