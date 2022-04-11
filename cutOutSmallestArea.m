% Cut out the smallest area
% (left, top) indicates the position of the upper left pixel in the original image after cropping
% dd is the width of the cropped image, hh is the height of the cropped image
function [e] = cutOutSmallestArea(d) 
[m,n] = size(d);
top = 1; bottom = m; left = 1; right = n;
while sum(d(top,:)) == 0 && top <= m
      top = top+1;
end
while sum(d(bottom,:)) == 0 && bottom >= 1
      bottom = bottom-1;
end
while sum(d(:,left)) == 0 && left <= n
     left = left+1;
end
while sum(d(:,right)) == 0 && right >= 1
     right = right-1;
end
dd = right-left;
hh = bottom-top;
e = imcrop(d,[left top dd hh]);   % Crop the image