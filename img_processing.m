%% load image
clear, close all;
img = imread('villa.png');
% converts image's values in double notation
img = im2double(img);
figure(1), imshow(img, []), title('original image')


%% Histogram equalization

% converts the 3 channels image to one channel image
gray_image = rgb2gray(img);
%figure(3), imshow(gray_image, []), title('grayscale')
% applies the adaptive histogram equalization only on the castle (excluding the sky)
gray_image = histeq(gray_image);
%figure(4), imshow(gray_image, []), title('greyscale + histEqimage')

%second histEqimage to increase contrast
gray_image = histeq(gray_image);
figure(5), imshow(gray_image, []), title('after second histEqimage')

%% edges 0,0.15 works well
 edges = edge(gray_image,'canny', [0 , 0.09], 2.5);
 figure(6), imshow(edges, []), title('greyscale + histEqimage + edges')
 
%% hough
lines = get_lines_hough(edges);
 
%% plot
figure(7); imshow(img), hold on;
plot_lines(lines);

%% list of important lines
%list of useful segments annotated using img_processing.m final result

% lines parallel to "Z" direction (towards the camera, "inside the image plane")
% [155 910 ; 230 994]
% [734 555 ; 812 391]
% [215 524 ; 254 658]
% [770 987 ; 886 916]

% lines parallel to "X" direction ("horizontal" wrt image)
% [451 731 ; 585 733]
% [23 559 ; 162 562]
% [227 1001 ; 464 1003]
% [911 1344 ; 173 1370]


       
