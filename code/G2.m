% Calibration
%% load image
clear;
close all;
addpath('utils');
img = imread('villa.png');
img = im2double(img);
IMG_MAX_SIZE = max(size(img));
H_scaling = diag([1/IMG_MAX_SIZE, 1/IMG_MAX_SIZE, 1]);

%figure; imshow(img);


%Hrect is the result of the stratified metric rectification done in "G1.m"
Hrect = [1.4608    0.1926         0;
    0.1926    0.9813         0;
         0         0    1.0000];



%% Finding vertical vanishing points

% 3 families of parallel lines (parallel to "X", parallel to "Z" and parallel to "Y", 4 lines
% per family)
f = 5;
col = 'rgbm';
parallelLines =cell(f,1);

%family parallel to "Z" direction
parallelLines{1}(1, :) =segToLine([155 910 ; 230 994]);
parallelLines{1}(2, :) =segToLine([734 555 ; 812 391]);
parallelLines{1}(3, :) =segToLine([215 524 ; 254 658]);
parallelLines{1}(4, :) =segToLine([770 987 ; 886 916]);
%family parallel to "X" direction
parallelLines{2}(1, :) =segToLine([451 731 ; 585 733]);
parallelLines{2}(2, :) =segToLine([23 559 ; 162 562]);
parallelLines{2}(3, :) =segToLine([227 1001 ; 464 1003]);
parallelLines{2}(4, :) =segToLine([911 1344 ; 173 1370]);

% we already have X and Z directions vanishing points, now we need to find
% the Y direction one

%family parallel to "Y" direction
parallelLines{3}(1, :) =segToLine([466 960 ;467 851]);
parallelLines{3}(2, :) =segToLine([266 1011 ;279 840]);
parallelLines{3}(3, :) =segToLine([649 853 ;661 1050]);
parallelLines{3}(4, :) =segToLine([758 824 ;776 998]);

%family parallel to "L" direction
parallelLines{4}(1, :) =segToLine([501 1151 ; 425 1073]);
parallelLines{4}(2, :) =segToLine([698 1145 ; 647 1095]);

%family parallel to "M" direction
parallelLines{5}(1, :) =segToLine([518 1150; 586 1079]);
parallelLines{5}(2, :) =segToLine([717 1145; 799 1048]);




%% compute the vanishing points

V = nan(2,f);
for i =1:f
    A = parallelLines{i}(:,1:2);
    B = -parallelLines{i}(:,3);
    V(:,i) = A\B;
end

vz = [V(1,1) V(2,1) 1];
vx = [V(1,2) V(2,2) 1];
vy = [V(1,3) V(2,3) 1];
vl = [V(1,4) V(2,4) 1];
vm = [V(1,5) V(2,5) 1];

imLinfty = cross(vz, vx);
imLinfty = imLinfty./(imLinfty(3));

%% second method

l_inf_s = H_scaling.' \ imLinfty';
vy_s = H_scaling * vy';
vx_s = H_scaling *  vx';
vz_s = H_scaling * vz';
vl_s= H_scaling * vl';
vm_s= H_scaling * vm';
v1 = [vx_s,vy_s,vz_s,vl_s];
v2 = [vy_s,vz_s,vx_s,vm_s];

IAC = compute_IAC(v1, v2);


% get the scaled intrinsic parameters
 alfa = sqrt(IAC(1,1));
 u0 = -IAC(1,3)/(alfa^2);
 v0 = -IAC(2,3);
 fy = sqrt(IAC(3,3) - (alfa^2)*(u0^2) - (v0^2));
 fx = fy /alfa;

K = [fx 0 u0; 0 fy v0; 0 0 1];
disp(K);

% % de-scale K and IAC
K = H_scaling \ K;

% IAC = inv(K*K');
% IAC = IAC./IAC(2,2);

% get intrinsic after descaling
fx = K(1,1);
fy = K(2,2);
u0 = K(1,3);
v0 = K(2,3);
alfa = fx/fy;


%K obtained
% K =
% 
% 1.0e+03 *
% 
%     1.2716         0    0.5384
%          0    1.1844    0.6399
%          0         0    0.0010

