% ����hough�任ʵ�ֳ���ͼ�����бУ��
function d = tiltCorrection_Hough(I)
figure;
subplot(131), imshow(I); 
I1 = wiener2(I, [5, 5]);  % �ԻҶ�ͼ�����ά���˲�
I2 = edge(I1, 'canny');  % ��Ե���
subplot(132), imshow(I2); 
[m, n] = size(I2);  % compute the size of the image
rho = round(sqrt(m^2 + n^2)); % ��ȡ�ѵ����ֵ���˴�rho=282
theta = 180; % ��ȡ�ȵ����ֵ
r = zeros(rho, theta);  % ������ֵΪ0�ļ�������
for i = 1 : m
   for j = 1 : n
      if I2(i,j) == 1  % I3�Ǳ�Ե���õ���ͼ��
          for k = 1 : theta
             ru = round(abs(i*cosd(k) + j*sind(k)));
             r(ru+1, k) = r(ru+1, k) + 1; % �Ծ������ 
          end
      end
   end
end
r_max = r(1,1); 
for i = 1 : rho
   for j = 1 : theta
       if r(i,j) > r_max
          r_max = r(i,j); 
          c = j; % �Ѿ���Ԫ�����ֵ����Ӧ���������͸�c
       end
   end
end
if c <= 90
   rot_theta = -c;  % ȷ����ת�Ƕ�
else
    rot_theta = 180 - c; 
end
d = imrotate(I2, rot_theta, 'crop');  % ��ͼ�������ת��У��ͼ��
subplot(133), imshow(d);
%set(0, 'defaultFigurePosition', [100, 100, 1200, 450]); % �޸�ͼ��λ�õ�Ĭ������
%set(0, 'defaultFigureColor', [1, 1, 1]); % �޸�ͼ�񱳾���ɫ������