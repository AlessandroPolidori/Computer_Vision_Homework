# Computer_Vision_Homework

#ASSIGNMENT
Write and test a Matlab program that analyzes the given image in order to extract the informatin items
listed below.
#Image Processing.
F1. Feature extraction. Combining the learned techniques, find edges, corner features and
straight lines in the image. Then manually select those features and those lines, that are useful
for the subsequent steps.
#Geometry
G1. 2D reconstruction of an horizontal section. Rectify (2D reconstruct) the horizontal section of the
building from the useful selected image lines and features, including vertical shadows. In particular,
determine the ratio between the width of facade 2 (or 4) and the width of facade 3.
Hint: use normalized coordinates to reduce numerical errors (e.g. set image size = 1) and exploit the
symmetry of facede 3 to improve accuracy.
G2. Calibration. First extract a vertical vanishing point and then use it together with useful information
extracted during the rectificatino step, in order to estimate the calibration matrix K containing the intrinsic
parameters of the camera, namely. focal distance, aspect ratio and position of principal point.
G3. Reconstruction of a vertical facade. Use the knowledge of K to rectify also a vertical facade, as, e.g.,
facade 3.
G4. Localization. Determine the relative pose (i.e. position and orientation) between facade 3 and the
camera reference. Use information about the camera height to solve for scale.
Design suitable techniques to solve the indicated steps and implement the designed solutions in Matlab.
For each intermediate steps include experimental results obtained by applying the chosen techniques to
the given image. Write a well written report including the explan
