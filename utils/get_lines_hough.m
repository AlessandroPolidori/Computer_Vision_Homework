function lines = get_lines_hough(edges)
[H,T,R] = hough(edges, "Theta", (-89.5:0.5:60), 'RhoResolution', 1);
P = houghpeaks(H, 300,'threshold', ceil(0.1*max(H(:))), "NHoodSize", [15,15]);
lines = houghlines(edges, T, R, P,'FillGap', 8,'MinLength', 25);
end