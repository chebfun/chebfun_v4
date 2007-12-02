function [funs,ends] = auto(op,ends)

if getpref('chebfun_defaults','splitting')==0
   funs{1} = fixedgrow(op,ends);
   return
end

% Debugging controls: ---------------------------------------------------
deb1 = 1; % <-  show the iteration level
deb2 = 1; % <-  plot advance of the construction (blue=happy, red=unhappy)
% ---------------------------------------------------------------------
% Minimum allowed interval length
minlength = 1e-14;
values.vs = 0; values.hs = max(abs(ends)); values.table = [];
% ---------------------------------------------------------------------
[funs{1},hpy,values] = grow(op,ends,values);
v = get(funs{1},'val');
values.vs = max(values.vs,max(abs(v)));
count = 0;
% -------------------------------------------------------------------------
if deb2
   color = [0 0 1];
   for i = 1:length(hpy)
      if ~hpy(i)
         loglog(cheb(get(funs{i},'n'),ends(i),ends(i+1)),get(funs{i},'val'),'.r');
      else
         loglog(cheb(get(funs{i},'n'),ends(i),ends(i+1)),...
             get(funs{i},'val'),'.','color',color); color(2:3)=1-color(2:3);
      end
      hold on;
   end
   set(gca,'xgrid','on','xtick',ends,'fontsize',8)
   drawnow, %pause
end
% -------------------------------------------------------------------------
while any(~hpy)
   count = count + 1;
   % ---------------------------------------------------------------------    
   if deb1
      disp(['level -> ',num2str(count)]);
      tic
   end
   % ---------------------------------------------------------------------
   i = find(~hpy);
   for i = i(end:-1:1)
      mdpt = mean(ends(i:i+1)); 
      mdptcopy = mdpt;
      if diff(ends(i:i+1)) < minlength
         ends(i) = mdpt; ends(i+1) = [];
         mdpt = [];
         child1 = {}; hpy1 = [];
         child2 = {}; hpy2 = [];
      else
         [child1,hpy1,values] = grow(op,[ends(i) mdpt],values);            
         [child2,hpy2,values] = grow(op,[mdpt, ends(i+1)],values);
         child1 = {child1};
         child2 = {child2};

         if hpy1 && (i > 1) && hpy(i-1)
            [f,merged,values] = grow(op,[ends(i-1),mdpt],values);
            if merged
               funs{i-1} = f; child1 = {};
               ends(i) = mdpt; mdpt = [];
               hpy1 = [];
            end
         end
         if hpy2 && (i<length(hpy)) && hpy(i+1)
            [f,merged,values] = grow(op,[mdptcopy,ends(i+2)],values);
            if merged
               funs{i+1} = f; child2 = {};
               if isempty(mdpt)
                  ends(i+1) = [];
               else
                  ends(i+1) = mdpt; mdpt = [];
               end
               hpy2 = [];
            end
         end
      end
      funs = [funs(1:i-1);child1;child2;funs(i+1:end)];
      ends = [ends(1:i) mdpt ends(i+1:end)];
      hpy  = [hpy(1:i-1) hpy1 hpy2 hpy(i+1:end)];
      for ii = 1:length(funs)
         v = get(funs{ii},'val');
         values.vs = max(values.vs,max(abs(v)));
      end
      % -----------------------------------------------------------------        
      if deb2
         hold off;
         for i = 1:length(hpy)
            if ~hpy(i)
               loglog(cheb(get(funs{i},'n'),ends(i),ends(i+1)),get(funs{i},'val'),'.r');
             else
               loglog(cheb(get(funs{i},'n'),ends(i),ends(i+1)),...
                      get(funs{i},'val'),'.','color',color); color(2:3)=1-color(2:3);
             end
             hold on;
         end
         set(gca,'xgrid','on','xtick',ends,'fontsize',8)
         drawnow, %pause
         hold off
      end
      % -----------------------------------------------------------------
   end
   % ---------------------------------------------------------------------
   % if deb1, toc, end
   % ---------------------------------------------------------------------
end
if deb1
   % display(length(table));
end
