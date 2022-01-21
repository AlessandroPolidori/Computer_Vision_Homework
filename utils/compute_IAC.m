function IAC = compute_IAC(vp1_s, vp2_s)
% vp1_s and vp2_s columns contain couples of orthogonal vanishing points
%
% Assume w to have this form [a 0 b
%                             0 1 c 
%                             b c d]

syms a b c d;
w = [a 0 b; 0 1 c; b c d];

X = []; 
Y = [];
% constraints on l_inf_s and v_orthogonal_s
% 2 constraints for each couple
% [l_inf_s]x *W*v_orthogonal_s = 0
% where [l_inf_s]x is the vector product matrix of the image of the line at the infinity
constraints = [];

[A,y] = equationsToMatrix(constraints,[a,b,c,d]);

% concatenation
X = [X;double(A)];
Y = [Y;double(y)];

% constraints contains all the equations
constraints = [];
% add constraints on vanishing points
for ii = 1:size(vp1_s,2)
    % first compute the element of x
    vi = vp1_s(:,ii);
    ui = vp2_s(:,ii);
    
    % vp1' W vp2 = 0
    constraints = [constraints, vi.' * w * ui == 0];

end

if size(constraints,2)>0
    % cast equations into matrix form
    [A,y] = equationsToMatrix(constraints,[a,b,c,d]);
    % concatenate matrices
    X = [X;double(A)];
    Y = [Y;double(y)];
end


% fit a linear model without intercept
lm = fitlm(X,Y, 'y ~ x1 + x2 + x3 + x4 - 1');
% get the coefficients
W = lm.Coefficients.Estimate;


% image of absolute conic
IAC = double([W(1,1) 0 W(2,1); 0 1 W(3,1); W(2,1) W(3,1) W(4,1)]);


end