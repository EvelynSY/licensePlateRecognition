% 利用hough变换实现车牌图像的倾斜校正
function d = tiltCorrection_Hough(I)
figure;
subplot(131), imshow(I); 
I1 = wiener2(I, [5, 5]);  % 对灰度图像进行维纳滤波
I2 = edge(I1, 'canny');  % 边缘检测
subplot(132), imshow(I2); 
[m, n] = size(I2);  % compute the size of the image
rho = round(sqrt(m^2 + n^2)); % 获取ρ的最大值，此处rho=282
theta = 180; % 获取θ的最大值
r = zeros(rho, theta);  % 产生初值为0的计数矩阵
for i = 1 : m
   for j = 1 : n
      if I2(i,j) == 1  % I3是边缘检测得到的图像
          for k = 1 : theta
             ru = round(abs(i*cosd(k) + j*sind(k)));
             r(ru+1, k) = r(ru+1, k) + 1; % 对矩阵计数 
          end
      end
   end
end
r_max = r(1,1); 
for i = 1 : rho
   for j = 1 : theta
       if r(i,j) > r_max
          r_max = r(i,j); 
          c = j; % 把矩阵元素最大值所对应的列坐标送给c
       end
   end
end
if c <= 90
   rot_theta = -c;  % 确定旋转角度
else
    rot_theta = 180 - c; 
end
d = imrotate(I2, rot_theta, 'crop');  % 对图像进行旋转，校正图像
subplot(133), imshow(d);
%set(0, 'defaultFigurePosition', [100, 100, 1200, 450]); % 修改图像位置的默认设置
%set(0, 'defaultFigureColor', [1, 1, 1]); % 修改图像背景颜色的设置