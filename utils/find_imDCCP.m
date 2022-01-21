% Assume s to have this form [a b 0
%                             b 1 0 
%                             0 0 0]

% result of "affinity.m"
function S = find_imDCCP()
close all;
clear;
clc;

Ha =[
    1.0000         0         0;
         0    1.0000         0;
   -0.0000   -0.0008    1.0000];% found in "affine.m"
   
syms a, syms b;
C = [a b 0; b 1 0; 0 0 0]; % image of the Conic dual to the circular points

cos_theta = 0.2484; % theta is the angle between sun rays and facade 3

% considering one horizontal plane:

% l1 and m1 are orthogonal lines (left corner)
l1= segToLine([39 479; 269 488]);
l1 = inv(Ha)'*l1;
m1= segToLine([214 484; 267 673]);
m1 = inv(Ha)'*m1;

% l2 and m2 are lines with theta angle
l2 = segToLine([212 485; 373 665]);
l2 = inv(Ha)'*l2;
m2= segToLine([404 668; 721 676]);
m2 = inv(Ha)'*m2;


eq1 = l1'*C*m1;

eq2 = (l2'*C*m2)/sqrt((l2'*C*l2)*(m2'*C*m2)) - cos_theta;



eqns = [eq1 ==0, eq2 ==0];
S = solve(eqns,[a,b]);
end

