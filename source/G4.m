% Localization
%% real world facade 3 rectangle (lacking real scale, we only have ratio after G3)
close all;
clear;
clc;


K = 1.0e+03 *[
    1.2716         0    0.5384
         0    1.1844    0.6399
         0         0    0.0010]; % found in "G2.m"

SIDE_LENGTH = 307;
BASE_WIDTH = 200;
d_left = [0 0];
d_right = [BASE_WIDTH 0];
u_left = [0 SIDE_LENGTH];
u_right = [BASE_WIDTH SIDE_LENGTH];

original_d_left = [202 1312.7];
original_d_right = [804 1295];
original_u_left = [282.4 486.7];
original_u_right = [727.1 508];

% fitting homography from real scene to image
H = fitgeotrans([u_left; d_left; u_right; d_right], [original_u_left;original_d_left ;original_u_right ;original_d_right ], 'projective');
H = H.T.';

h1 = H(:,1);
h2 = H(:,2);
h3 = H(:,3);

% normalization factor.
l = 1 / norm(K \ h1);

% r1 = K^-1 * h1 normalized
r1 = (K \ h1) * l;
r2 = (K \ h2) * l;
r3 = cross(r1,r2);

% rotation of the plane wrt camera
R = [r1, r2, r3];

% svd to approximate and obtain surely an orthogonal matrix
[U, ~, V] = svd(R);
R = U * V';

% Compute translation vector. This vector is the position of the plane wrt
% the reference frame of the camera
p = (K \ (l * h3));
cameraR = R.';
% since p is expressed in the camera ref frame we want it in the plane
% reference frame, R.' is the rotation of the camera wrt the plane
cameraPos = -R.'*p;
cameraPos = cameraPos*0.055; % 0.055 scales the height from the ground to 1.5

%% display

figure
plotCamera('Location', cameraPos, 'Orientation', cameraR.', 'Size', 5);
hold on
pcshow([[u_left; d_left; u_right; d_right], zeros(size([u_left; d_left; u_right; d_right],1), 1)], ...
    'red','VerticalAxisDir', 'up', 'MarkerSize', 120);
xlabel('X')
ylabel('Y')
zlabel('Z')


