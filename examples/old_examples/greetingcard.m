% greetingcard.m - makes a Chebfun Greeting card
% Just type greetingcard to run, or greetingcard(0)
% to run fast.  Chebfun Version 3 must be in your path.
% Nick Trefethen, Oxford University, November 2009

function greetingcard(dt0)
if nargin==0, dt0 = 3; end;       % pause between statements

w('We''re going to make a 10-digit greeting card.',.5)

w('(Actually the accuracy is more like 15 digits.)')

w('You''ll type a message as a string in quotes, like')
w('message = ''Happy Birthday Mom!''.',0)

w('Chebfun will call ''scribble'' to make it into')
w('a piecewise linear complex function s of the real',0)
w('variable x in [-1,1].  The values s(x) lie in a',0)
w('rectangle in the complex plane just above [-1,1].',0)

w('Then you can distort the function in artistic ways by')
w('applying a function f(s) to it like s.^2 or exp(s).',0)

w('OK, what''s your message string? ');
message = input('message = ');

disp(' ')
w('Here is your message as a chebfun.',0)
w('(see figure window -- the colors here are random):',0)

s = scribble(message);
fs = 's';
ht = mean(imag(eval(fs)));
semi = chebfun(@(x) exp(1i*x),[-pi/2 pi/2]);
seg = chebfun('x');
border0 = [seg-.4i*ht;1+ht*1i+1.4*ht*semi;2.4*ht*1i-seg;-1+ht*1i-1.4*ht*semi];
border = chebfun;
border{-1,1} = border0;

ps(fs,0)

prompt = 'Type <Enter> to see the result of f(s) = ';

fs = 'exp(1.5*s)';                     disp(' '), w([prompt fs],0); ps(fs,99)
fs = 'sin(2.5*s)';                     disp(' '), w([prompt fs],0); ps(fs,99)
fs = '(s+.5i).^2';                     disp(' '), w([prompt fs],0); ps(fs,99)
fs = '(s+.5+.5i).^3';                  disp(' '), w([prompt fs],0); ps(fs,99)
fs = 'exp(2.5i*s)';                    disp(' '), w([prompt fs],0); ps(fs,99)
fs = 'exp(-1.4i)*exp((3.5i+.6)*s)/1i'; disp(' '), w([prompt fs],0); ps(fs,99)
fs = 'real(s) + exp((1+1i)*(s-.5))';   disp(' '), w([prompt fs],0); ps(fs,99)

w('Well now you''ve got the hang of it.',0)
disp(' ')
w('It''s time to pick your own function f,',0)
w('which you should input as a string in quotes.',0)
w('You can keep trying things till you''re satisfied.',0)
w('Then type in the string ''done''.',0)

while ~strcmp(fs,'done')
  fs = input('function = ');
  if strcmp(fs,'done'), 
      break,
  elseif isempty(fs)
      disp(' ')
  else
      disp(' '), ps(fs,0)
  end
end

disp(' ')
w('Use Matlab'' control buttons to change the color if you,',0)
w('wish, and when you''re happy, print your greeting card.',0)
disp(' ')
w('To get rid of the axes, type axis off.',0)
w('To get rid of the title, type title '' ''.',0)
disp(' ')
w('Incidentally, you can run this program more quickly',0)
w('by typing, say, greetingcard(1) or greetingcard(0).',0)

function w(str,dt)  % writes string s on the screen after delay dt,
                    % which defaults to dt0 seconds.
if nargin==1, dt=dt0+1e-6; end
if dt>0, disp(' '), pause(dt), end
disp(str)
end

function ps(fs,dt)  % plots chebfun defined by string fs in a figure
                    % after delay dt, which defaults to dt0 seconds.
                    % The color is random.
                    % If dt=99, wait for user to hit <Enter>.
red = [1 0 0]; green = [0 1 0]; blue = [0 0 1]; cyan = [0 1 1];
magenta = [1 0 1]; black = [0 0 0]; orange = [1 .5 0]; red2 = [1 0 .5];
purple = [.5 0 1];
cc = [red; green; blue; cyan; magenta; black; orange; red2; purple];
if nargin==1, dt=dt0+1e-6; end
if dt>0
  if dt==99, pause, else pause(dt), end
end
c = cc(randi(size(cc,1)),:);
depvar = symvar(fs); 
if numel(depvar) ~= 1, 
    error('CHEBFUN:examples:greetingcard','Incorrect number of dependent variables in string input'); 
end
op = eval(['@(' depvar{:} ')' fs]);
ffs = op(s);
hold off
plot(ffs,'linewidth',2,'color',c), axis equal, grid on
c = cc(randi(size(cc,1)),:);
ssave = s;
s = border;
hold on
plot(op(s),'linewidth',2,'color',c)
s = ssave;
a = axis;
xm = mean(a(1:2)); xd = a(1:2)-xm;
ym = mean(a(3:4)); yd = a(3:4)-ym;
axis([xm+1.1*xd ym+1.1*yd])
title(fs,'fontsize',16), shg
end

end

