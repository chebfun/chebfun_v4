% A simple check list to semi-automatically generate a .zip chebfun
% release.

clc
clear classes
clear all
close all

disp('generating .zip chebfun release')
disp(' ')
R = input('Are you in the right directory ? [1 or 0]');
if ~R
    tmp = input('Use ~/tmp? [1 or 0]');
    if tmp
        cd ~/tmp
    else
        return
    end
end
disp(' ')
!svn export --force svn://edison.comlab.ox.ac.uk/chebfun/svnrepo/trunk chebfun_tmp
cd chebfun_tmp
R = input('Please enter revision number for file name: ');
rev = int2str(R);

chebtest

disp('removing etc folder')
!rm -rf etc

disp('generating guide files')
disp('this takes time, feel free to get coffee or ...')
cd guide
guidedefaults
numguides = input('Number of guide chapters? (8)?');
for i = 1:numguides
    disp(['generating guide',int2str(i),' ...'])
    for k =1:2
        publish(['guide',int2str(i)]);
    end
end

cd ..
disp('Manual information in Contents.m and helptoc.xml')
edit Contents.m
edit guide/html/helptoc.xml
disp('have you edited and saved both files?')
disp('close the files as well?')
disp('type enter to continue..')
pause

disp(' ')
disp('Note: If new guide files, modify helptoc and index.html')
disp('type enter to continue.')
pause
disp(' ')
disp('Generating zip file')
cd ..
unix(['zip -r chebfun_v2_0',rev,' chebfun_tmp']);
R = input('Remove direcotry? [1 or 0]');
if R
    !rm -rf chebfun_tmp
end
disp(' ')
disp('all done!')



