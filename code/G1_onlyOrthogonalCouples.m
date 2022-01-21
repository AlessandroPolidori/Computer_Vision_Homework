%% stratified approach starting from affinity.m result
% in this file is presented the solution with only constraints derived from
% orthogonal pairs of lines
% (the result, though, seems slightly worse).
close all;
clear;
clc;
addpath('utils');
imgAffRect = imread('affRect.png');
Ha =[ 1.0000         0         0;
    0    1.0000         0;
    -0.0000   -0.0008    1.0000 ];

FNT_SZ = 14;

%figure;
%imshow(imgAffRect);

%% finding second pair of orthogonal lines
% we need to build a square on the horizontal plane and use its diagonals
% as second orthogonal pair. We need to use the vertical shadow, knowing
% that in the affinely rectified image we can multiply its length by 3.9 
% (ratio of parallel lengths is preserved) and
% obtain the second square's side(ab). side "da" is the facade2, while the
% others are obtained using cross products and "Z" vanishing point.
originalImg = imread('villa.png');
figure;
imshow(originalImg);
%[x, y] = getpts();
a = [225.5 1044.5 1];
b = [693.5 1044.5 1];
% z- vanishing point
v_z = [413.57 1206 1];
%text(v_z(1,1), v_z(1,2), 'vz', 'FontSize', FNT_SZ, 'Color', 'b')

% % line through point b with direction z
lb = cross(b, v_z);
lb = lb./lb(1,3);
lb = lb';
%disp(b * lb );% this should be zero when b \in lb
% % line through c and d 
lcd = segToLine([7.5 978.5;149.5 976.5]);
lcd = lcd ./lcd(3,1);
% %prendi dalla foto
% %point c is intersection between lcd and lb
c = cross(lcd, lb);
c = c./c(3,1);
d = [145.5 978.5 1];
d = d';
a = a';
b = b';
% Showing the square 
text(c(1,1), c(2,1), 'c', 'FontSize', FNT_SZ, 'Color', 'b');
text(d(1,1), d(2,1), 'd', 'FontSize', FNT_SZ, 'Color', 'b');
text(a(1,1), a(2,1), 'a', 'FontSize', FNT_SZ, 'Color', 'b');
text(b(1,1), b(2,1), 'b', 'FontSize', FNT_SZ, 'Color', 'b');


%% alternatively, get pairs of orthogonal lines (taken from starting image) to affine rectified form
%first pair of orthogonal lines (right corner -between 3rd and 4th facades-)
l1 = segToLine([153 984.5 ; 355.5 1140.5]);
m1 = segToLine([273.5 1050.5 ; 665.5 1050.5]);
l3 = segToLine([785.5 1046.5 ; 1019.5 942.5]);
m3 = segToLine([273.5 1050.5 ; 665.5 1050.5]);
%second pair of orthogonal lines (exploiting shadow/sun direction)
l2 = cross(c,a);
l2 = l2./norm(l2);
m2 = cross (b,d);
m2 = m2./norm(m2);
%apply transformation Ha (result of "affinity.m" workflow)
%affLine = inv(Ha)'*line'
l1_aff = inv(Ha)'*l1;
m1_aff = inv(Ha)'*m1;
l2_aff = inv(Ha)'*l2;
m2_aff = inv(Ha)'*m2;
l3_aff = inv(Ha)'*l3;
m3_aff = inv(Ha)'*m3;
    
% each pair of orthogonal lines gives rise to a constraint on s
% [l(1)*m(1),l(1)*m(2)+l(2)*m(1), l(2)*m(2)]*s = 0
% store the constraints in a matrix A
A(1,:) = [l1_aff(1)*m1_aff(1),l1_aff(1)*m1_aff(2)+l1_aff(2)*m1_aff(1), l1_aff(2)*m1_aff(2)];
A(2,:) = [l2_aff(1)*m2_aff(1),l2_aff(1)*m2_aff(2)+l2_aff(2)*m2_aff(1), l2_aff(2)*m2_aff(2)];
A(3,:) = [l3_aff(1)*m3_aff(1),l3_aff(1)*m3_aff(2)+l3_aff(2)*m3_aff(1), l3_aff(2)*m3_aff(2)];


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

