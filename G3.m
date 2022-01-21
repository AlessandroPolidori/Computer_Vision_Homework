% Reconstruction of a vertical facade
%% find intersection between line at infinity of vertical plane and IAC

clear;
close all;
addpath('utils');
img = imread('villa.png');
H_scaling =[

    0.0007         0         0;
         0    0.0007         0;
         0         0    1.0000];

%figure, imshow(img);
img = im2double(img);


%% Solving system

%parameters of the IAC taken from "G2.m"
a = 0.8675 ;
b = -0.3280;
c = -0.4494;
d = 1.0177;

% imLinfty of the vertical plane scaled with H_scaling
imLinfty = [ -0.1643    0.7290    1.0000 ];

Linfty  = imLinfty;

l1 = Linfty(1,1);
l2 = Linfty(1,2);
l3 = Linfty(1,3);
syms 'x';
syms 'y';

% finding intersection between IAC and imLinfty

eq1 = a*x^2 + 2*b*x + y^2 +2*c*y + d;
eq2 = l1*x + l2*y + l3;

eqns = [eq1 ==0, eq2 ==0];
S = solve(eqns, [x,y]);
 
I = [double(S.x(1));double(S.y(1));1];
J = [double(S.x(2));double(S.y(2));1];
 
imDCCP = I*J.' + J*I.';
imDCCP = inv(H_scaling)*imDCCP;
imDCCP = imDCCP./norm(imDCCP);

%% compute the rectifying homography
[U,D,V] = svd(imDCCP);
D(3,3) = 1;
A = U*sqrt(D);

H = inv(A);% rectifying homography
disp(H);
tform = projective2d(H');
JJ = imwarp(img,tform);
JJ = imrotate(JJ, 193.2);
figure;
imshow(JJ);
axis equal;
imwrite(JJ,'verticalRectified.png');
