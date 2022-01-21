%% load image
clear;
close all;
addpath('utils');
img = imread('villa.png');
img = im2double(img);
figure; imshow(img);

%% interactively select f families of segments that are images of 3D parallel lines (DEBUG PURPOSES)
 
% f = 1; % number of families of parallel lines
% numSegmentsPerFamily = 1;
% parallelLines =cell(f,1); % store parallel lines
% fprintf(['Draw ', num2str(f) , ' families of parallel segments\n']);
% col = 'rgbm';
% for i = 1:f
%     count = 1;
%     parallelLines{i} = nan(numSegmentsPerFamily,3);
%     while(count <=numSegmentsPerFamily)
%         figure(gcf);
%         title(['Draw ', num2str(numSegmentsPerFamily),' segments: step ',num2str(count) ]);
%         segment1 = drawline('Color',col(i));
%         parallelLines{i}(count, :) = segToLine(segment1.Position);
%         disp(segment1.Position);
%         count = count +1;
%     end
%     fprintf('Press enter to continue\n');
%     pause
% end

%% store lines gathered during image processing

% 2 families of parallel lines (parallel to "X" and parallel to "Z" and 4 lines
% per family)
f = 2;
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


%% compute the vanishing points

V = nan(2,f);
for i =1:f
    A = parallelLines{i}(:,1:2);
    B = -parallelLines{i}(:,3);
    V(:,i) = A\B;
end
%% compute the image of the line at infinity
imLinfty = cross([V(1,1) V(2,1) 1], [V(1,2) V(2,2) 1]);

imLinfty = imLinfty./(imLinfty(3));
disp(imLinfty);
figure;
hold all;
col(1) = "g";
col(2) = "r";
for i = 1:f
    plot(V(1,i),V(2,i),'o','Color',col(i),'MarkerSize',20,'MarkerFaceColor',col(i));
end
hold all;
imshow(img);

%% build the rectification matrix
H = [eye(2),zeros(2,1); imLinfty(:)'];
% we can check that H^-T* imLinfty is the line at infinity in its canonical
% form:
fprintf('The vanishing line is mapped to:\n');
disp(inv(H)'*imLinfty');

%% rectify the image and show the result
tform = projective2d(H');
J = imwarp(img,tform,'OutputView',imref2d(size(img)*4));

figure;
imshow(J);
imwrite(J,'affRect.png');

%% Hardcode Ha (affine rectification matrix) result
%   Ha =[
% 
%     1.0000         0         0,
%          0    1.0000         0,
%    -0.0000   -0.0008    1.0000 ]
