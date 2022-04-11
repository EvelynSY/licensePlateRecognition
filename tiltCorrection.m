% Correct the tilt of the license plate image
% By using Radon method
function d = tiltCorrection(I)
figure;
subplot(131), imshow(I);
I2 = wiener2(I, [5, 5]); 
I3 = edge(I2, 'canny'); 
subplot(132), imshow(I3); 
theta = 0 : 179;
r = radon(I3, theta); 
[m, n] = size(r); 
c = 1; 
for i = 1 : m
   for j = 1 : n
      if r(1,1) < r(i,j)
         r(1,1) = r(i,j);
         c = j;
      end
   end
end
rot_theta = 90 - c; 
d = imrotate(I, rot_theta, 'crop');
subplot(133), imshow(d);