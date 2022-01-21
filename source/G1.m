% 2D reconstruction of a horizontal section
%% stratified approach starting from affinity.m result
close all;
clear;
clc;
addpath('utils');
imgAffRect = imread('affRect.png');

Ha =[ 1.0000         0         0;
    0    1.0000         0;
    -0.0000   -0.0008    1.0000 ];% found in "affinity.m"


numConstraints = 2; % 2 is the minimum number


%% as the orthogonal pairs are all equivalent, use only one pair and add another constraint
% taking into account the angle between the sun direction and the facade 3
a = find_imDCCP().a;
b = find_imDCCP().b;
S = [a,b;b,1];

%% computing rectifying homography
imDCCP = [S,zeros(2,1); zeros(1,3)]; % the image of the circular points
[U,D,V] = svd(S);
A = U*sqrt(D)*V';
H = eye(3);
H(1,1) = A(1,1);
H(1,2) = A(1,2);
H(2,1) = A(2,1);
H(2,2) = A(2,2);

Hrect = inv(H);
Cinfty = [eye(2),zeros(2,1);zeros(1,3)];

tform = projective2d(Hrect');
J = imwarp(imgAffRect,tform);

figure;
imshow(J);
imwrite(J,'metric.png');

%Rateo between facades 3 and 4 is 1.43

%% Hrect
% Hrect =
% 
%     0.7028   -0.1379         0
%    -0.1379    1.0461         0
%          0         0    1.0000