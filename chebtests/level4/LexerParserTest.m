function pass = LexerParserTest
% This test ensures that the chebgui string parser is doing the correct
% thing in a few different situations. It is a little unique in that it
% tests a privates chebgui method, and so has to temporarily add this to
% the path.

str = { 'u(0) = 1'
        'u(-1) = 1'
        'u(0)=1, u(2) = 3'
%         'u = 1,v = 0,w = 3'
        'u(end),u(1,left)'
        'diff(sin(u))'
        'diff(sin(u),2)'
        'feval(u,sqrt(2))'
        'feval(u,0,left)'
        'sum(u) = 0'
        'sum(u,0,.5) = 0'
        'volt(sin(x-y),u) = 0'
        'fred(sin(x-y),u) = fred(cos(x-z),v)'
        'u + fred(sin(2*pi*(y-x)),u) = feval(u,0,left)'};
n = numel(str);
    
curdir = pwd;
cd(fullfile(fileparts(which('chebgui')),'private'))
c = chebgui('type','bvp');
an = cell(n,1);
for k = 1:n
    try
        an{k} = convertToAnon(c,str{k});
    end
end
cd(curdir);

true = {'@(u) feval(u,0)-1'
        '@(u) feval(u,-1)-1'
        '@(u) feval(u,0)-1,feval(u,2)-3'
%         '@(u,v,w) [u-1,v-0,w-3]'
        '@(u) feval(u,''end''),feval(u,1,''left'')'
        '@(u) diff(sin(u))'
        '@(u) diff(sin(u),2)'
        '@(u) feval(u,sqrt(2))'
        '@(u) feval(u,0,''left'')'
        '@(u) sum(u)'
        '@(u) sum(u,0,.5)'
        '@(u) volt(@(x,y)sin(x-y),u)'
        '@(u,v) fred(@(x,y)sin(x-y),u)-fred(@(x,z)cos(x-z),v)'
        '@(u) u+fred(@(x,y)sin(2.*pi.*(y-x)),u)-feval(u,0,''left'')'};
      
pass = zeros(n,1);
for k = 1:n
    pass(k) = strcmp(an{k},true{k});
end
