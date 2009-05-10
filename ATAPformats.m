% ATAPformats.m  Set formats for Trefethen's book "Approximation
%                Theory and Approximation Practice"

% Nick Trefethen, May 2009
% This code sets certain default properties and is called at
% the beginning of each section of the book so that the output
% from "publish" has a pleasing appearance.  It is included in
% this directory as part of the chebfun distribution so that
% readers of the book need only download chebfun to be able
% to execute each section.

% These formats are a work in progress -- they will go through
% various changes in the months ahead.

set(0,'defaultfigureposition',[380 320 540 200],...
'defaultaxeslinewidth',0.9,'defaultaxesfontsize',8,...
'defaultlinelinewidth',1.1,'defaultpatchlinewidth',1.1,...
'defaultlinemarkersize',15), format compact, format long
chebfunpref('factory'); clear all, x = chebfun('x',[-1 1]);
