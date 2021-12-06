%% stratified approach starting from affinity.m result
close all;
clear;
clc;
addpath('utils');
imgAffRect = imread('affRect.png');
Ha =[ 1.0000         0         0;
    0    1.0000         0;
    -0.0000   -0.0008    1.0000 ];

%figure;
%imshow(imgAffRect);
numConstraints = 2; % 2 is the minimum number

%% drawing manually at least 2 pairs of orthogonal lines
% hold all;
% fprintf('Draw pairs of orthogonal segments\n');
% count = 1;
% A = zeros(numConstraints,3);
% % select pairs of orthogonal segments
% while (count <=numConstraints)
%     figure(gcf);
%     title('Select pairs of orthogonal segments')
%     col = 'rgbcmykwrgbcmykw';
%     segment1 = drawline('Color',col(count));
%     segment2 = drawline('Color',col(count));
% 
%     l = segToLine(segment1.Position);
%     m = segToLine(segment2.Position);
% 
%     % each pair of orthogonal lines gives rise to a constraint on s
%     % [l(1)*m(1),l(1)*m(2)+l(2)*m(1), l(2)*m(2)]*s = 0
%     % store the constraints in a matrix A
%      A(count,:) = [l(1)*m(1),l(1)*m(2)+l(2)*m(1), l(2)*m(2)];
% 
%     count = count+1;
% end

%% alternatively, get pairs of orthogonal lines (taken from starting image) to affine rectified form
%first pair of orthogonal lines (right corner -between 3rd and 4th facades-)
l1 = segToLine([218 485 ; 280 716]);
m1 = segToLine([267 663 ; 434 665]);
%second pair of orthogonal lines (exploiting shadow/sun direction)
l2 = segToLine([215 487 ; 380 690]);
m2 = segToLine([787 599 ; 204 669]);
%third pair of orthogonal lines (left corner, probabily linearly dependent)
% l3 = segToLine([]);
% m3 = segToLine([]);

%apply transformation Ha (result of "affinity.m" workflow)
%affLine = inv(Ha)'*line'
l1_aff = inv(Ha)'*l1;
m1_aff = inv(Ha)'*m1;
l2_aff = inv(Ha)'*l2;
m2_aff = inv(Ha)'*m2;
    
% each pair of orthogonal lines gives rise to a constraint on s
% [l(1)*m(1),l(1)*m(2)+l(2)*m(1), l(2)*m(2)]*s = 0
% store the constraints in a matrix A
A(1,:) = [l1_aff(1)*m1_aff(1),l1_aff(1)*m1_aff(2)+l1_aff(2)*m1_aff(1), l1_aff(2)*m1_aff(2)];
A(2,:) = [l2_aff(1)*m2_aff(1),l2_aff(1)*m2_aff(2)+l2_aff(2)*m2_aff(1), l2_aff(2)*m2_aff(2)];
disp(A);



%% solve system
%S = [x(1) x(2); x(2) 1];
[~,~,v] = svd(A);
s = v(:,end); %[s11,s12,s22];
S = [s(1),s(2); s(2),s(3)];

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

%% two pairs of orthogonal lines taken from a lower horizontal plane stored for comparison purposes
% %first pair of orthogonal lines (right corner -between 3rd and 4th facades-)
% l1 = segToLine([163 988; 251 1064]);
% m1 = segToLine([239 1044;376 1043]);
% %second pair of orthogonal lines (exploiting shadow/sun direction)
% l2 = segToLine([148 1008; 394 1076]);
% m2 = segToLine([836 1018; 229 1046]);
