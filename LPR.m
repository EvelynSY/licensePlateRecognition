imgFolder = 'E:\ËïÔÌ¼ÓÓÍ\±ÏÒµÉè¼Æ\picture';   % The path of the picture
imgName = 'LP4.jpg';   % The name of the picture
c = imread(fullfile(imgFolder,imgName));  % Read the image that need to be processed
figure;
imshow(c);   % Display images that need to be processed
title('original image');
Im = c;
Im_1 = rgb2gray(Im);   % Get the grayscale image of the original image
imwrite(Im_1,'grayscale image of the original image.jpg');
figure; imshow(Im_1); title('grayscale image of the original image');
Im_2 = edge(Im_1,'roberts',0.18,'both');   % Perform edge detection processing on the obtained grayscale image
imwrite(Im_2,'after Edge detecting.jpg');
figure; imshow(Im_2); title('after Edge detecting');
se = [1;1;1];   % Set the parameter used for image erosion
Im_3 = imerode(Im_2,se);   % erodes the grayscale image
imwrite(Im_3,'after eroding.jpg');
figure; imshow(Im_3); title('after eroding');
se = strel('rectangle',[25,25]);   %Set the parameter used to do closing method
Im_4 = imclose(Im_3,se);   %  Performs morphological closing on the grayscale or binary image
imwrite(Im_4,'after morphological closing.jpg');
figure; imshow(Im_4); title('after morphological closing');
[n, m] = size(Im_4);
Im_4(1:round(n/3), 1:m) = 0;
 
% Remove small objects in binary image
r = floor(n/10);
c = floor(m/10);
Im_4(1:r,:) = 0;
Im_4((9*r):n,:) = 0;
Im_4(:,1:c) = 0;
Im_4(:,(c*9):m) = 0;
Im_5 = bwareaopen(Im_4,200);  % removes all connected components (objects) that have fewer than 2000 pixels from the binary image Im_4, producing another binary image, Im_5.
imwrite(Im_5,'after removing all small connected components (objects).jpg');
figure; imshow(Im_5); title('after removing all small connected components (objects)');
 
[m n]=size(Im_5);
% Find the projection of a binary image in the vertical direction
for y=1:n
     S_Vertical(y)=sum(Im_5(1:m,y));
end
y=1:n;
figure;
aaa=axes;
stem(y,S_Vertical(y),'w');title('Vertical projection of binary image');
set(aaa,'color','k')
% Find the projection of a binary image in the horizontal direction
for x=1:m
     S_Horizontal(x)=sum(Im_5(x,:));
end
x=1:m;
figure;
aaa=axes;
stem(x,S_Horizontal(x),'w');title('Horizontal projection of binary image');
set(aaa,'color','k')
 
% Start to extract the license plate in the image
[y,x,z] = size(Im_5);
myIm = double(Im_5);
tic
Blue_y = zeros(y,1);
for i = 1:y
    for j = 1:x
        if(myIm(i,j,1) == 1)
            Blue_y(i,1) = Blue_y(i,1)+1;
        end
    end
end
[temp MaxY] = max(Blue_y);
    
PY1 = MaxY;
while((Blue_y(PY1,1) >= 5) && (PY1 > 1))
    PY1 = PY1-1;
end
PY2 = MaxY;
while ((Blue_y(PY2,1) >= 5) && (PY2 < y))   % For ease of processing, we set the critical value of the pixel value to 5 pixels.
    PY2 = PY2+1;
end
ImY = Im(PY1:PY2,:,:);
% figure,imshow(IY);
    
Blue_x = zeros(1,x);
for j = 1:x
    for i = PY1:PY2
        if(myIm(i,j,1) == 1)
            Blue_x(1,j) = Blue_x(1,j)+1;
        end
    end
end
% [tempx MaxX] = max(Blue_x);
PX1 = 1;
[Im_row,Im_col,PixelValues] = size(Im);
while((Blue_x(1,PX1) < 3) && (PX1 < x))
    PX1 = PX1+1;
end
PX2 = x;
while ((Blue_x(1,PX2) < 3) && (PX2 > PX1))
    PX2 = PX2-1;
end
PX1 = PX1-1;
% PX2=PX2;
% RGBLPm = Im(PY1:(PY2-8),PX1:PX2,:);
RGBLPIm = Im((PY1):(PY2),PX1:PX2,:);
t = toc;
    
if ((PX2-PX1)/(PY2-PY1)) > 3.14
    PX1 = 1;
    [Im_row,Im_col,PixelValues] = size(Im);
    while((Blue_x(1,PX1) < 11) && (PX1 < x))
        PX1 = PX1+1;
    end
    PX2 = x;
    while ((Blue_x(1,PX2)<11)&&(PX2>PX1))
        PX2 = PX2-1;
    end
    PX1 = PX1-1;
    % PX2 = PX2;
    RGBLPIm = Im((PY1):(PY2),PX1:PX2,:);
end 
% Complete license plate extraction, get the image of license
 
% Store and display
imwrite(RGBLPIm,'RGB license plate.jpg');
a = imread('RGB license plate.jpg');
b = rgb2gray(a);
imwrite(b,'gray license plate.jpg');
figure;
subplot(2,1,1);imshow(a);
title('RGB license plate.jpg');
hold on;
subplot(2,1,2);imshow(b);
title('gray license plate.jpg');
 
% The image needs to be tilt-corrected or not
b = tiltCorrection(b);
 
% Preprocess the license image before cutting out a single character
g_max = double(max(max(b)));
g_min = double(min(min(b)));
T = round(g_max-(g_max-g_min)/3);   % Calculate global threshold
[m,n] = size(b);
d = (double(b) >= T);   % Get the binary license plate image
imwrite(d,'binary license plate.jpg');
figure; imshow(d); title('binary license plate.jpg');
h = fspecial('average',3);   % Define the mean filter operator with a default value of 3
d = im2bw(round(filter2(h,d)));   % Filter the binary image to get a new binary image
imwrite(d,'after average license plate.jpg');
figure; imshow(d); title('after average license plate.jpg');
% Eroding or dilating the binary license plate image
% If the ratio of character area to license plate area is greater than 0.365, then the image is eroded,
% otherwise the image is dilated
se = eye(2);   % Set the parameter used for image eroding or image dilating
[m,n] = size(d);
if bwarea(d)/m/n >= 0.365
    d = imerode(d,se);
elseif bwarea(d)/m/n <= 0.235
    d = imdilate(d,se);
end
imwrite(d,'erode or dilate the license plate.jpg');
figure; imshow(d); title('erode or dilate the license plate.jpg');
[md nd] = size(d);
% Find the projection of LP binary image in the vertical direction
for y=1:nd
     s_Vertical(y)=sum(d(1:md,y));
end
y=1:nd;
figure;
aaa=axes;
stem(y,s_Vertical(y),'w');title('Vertical projection of LP binary image');
set(aaa,'color','k')
 
% Start cutting out a single character   
[dw1,dw2,dw3] = size(RGBLPIm);
rangeOfChar = round(0.0026*dw1*dw2);
d = bwareaopen(d,rangeOfChar);
d = cutOutSmallestArea(d);
[m,n] = size(d);
if (n/m) < 4
    row = m-(n/(4.1));
    d = d(round(row):m,1:n);
end
 
k1 = 1;
k2 = 1;
s = sum(d);
j = 1;
while j ~= n
    while s(j) == 0
        j = j+1;
    end
    k1 = j;
    while s(j) ~= 0 && j <= n-1
        j = j+1;
    end
    k2 = j-1;
    if k2-k1 >= round(n/6.5)
        [val,num] = min(sum(d(:,[k1+5:k2-5])));
        d(:,k1+num+5) = 0;
    end
end
 
% cut again 
d = cutOutSmallestArea(d);
y1 = 10; y2 = 0.25; flag = 0; char1 = [];
while flag == 0
    [m,n] = size(d);
    left = 1; wide = 0;
    while sum(d(:,wide+1)) ~= 0
        wide = wide+1;
    end
 
    if (wide<5) && (sum(d(:,wide+1))<(10/m))
        d(:,[1:wide]) = 0;
        d = cutOutSmallestArea(d);
    else
        temp = cutOutSmallestArea(imcrop(d,[1 1 wide m]));
        [m,n] = size(temp);
        all = sum(sum(temp));
        two_thirds = sum(sum(temp([round(m/3):2*round(m/3)],:)));
        if two_thirds/all > y2
            flag = 1; char1 = temp;   % char 1
        end
        d(:,[1:wide]) = 0; d = cutOutSmallestArea(d);
end
end
[char2,d] = getChar(d);
[char2row,char2col] = size(char2);
whiteSizeOfChar2 = round(char2row*char2col/12)+1;
char2 = bwareaopen(char2,whiteSizeOfChar2);
char2 = cutOutSmallestArea(char2);
% Cut out the 3rd character
[char3,d] = getChar(d);
% Cut out the 4th character
[char4,d] = getChar(d);
% Cut out the 5th character
[char5,d] = getChar(d);
% Cut out the 6th character
[char6,d] = getChar(d);
[char6row,char6col] = size(char6);
whiteSizeOfChar6 = round(char6row*char6col/12)+1;
char6 = bwareaopen(char6,whiteSizeOfChar6);
char6 = cutOutSmallestArea(char6);
% Cut out the 7th character
[char7,d] = getChar(d);
 
[m,n] = size(char1);
% figure;
% subplot(1,7,1); imshow(char1); title('1.jpg');
% subplot(1,7,2); imshow(char2); title('2.jpg');
% subplot(1,7,3); imshow(char3); title('3.jpg');
% subplot(1,7,4); imshow(char4); title('4.jpg');
% subplot(1,7,5); imshow(char5); title('5.jpg');
% subplot(1,7,6); imshow(char6); title('6.jpg');
% subplot(1,7,7); imshow(char7); title('7.jpg');
 
char1 = imresize(char1,[32 16]);
    
char2 = charNormalized(char2);
char3 = charNormalized(char3);
char4 = charNormalized(char4);
char5 = charNormalized(char5);
char6 = charNormalized(char6);
char7 = charNormalized(char7);
 
imwrite(char1,'1.jpg');
imwrite(char2,'2.jpg');
imwrite(char3,'3.jpg');
imwrite(char4,'4.jpg');
imwrite(char5,'5.jpg');
imwrite(char6,'6.jpg');
imwrite(char7,'7.jpg');
figure;
subplot(1,7,1); imshow(char1); title('1.jpg');
subplot(1,7,2); imshow(char2); title('2.jpg');
subplot(1,7,3); imshow(char3); title('3.jpg');
subplot(1,7,4); imshow(char4); title('4.jpg');
subplot(1,7,5); imshow(char5); title('5.jpg');
subplot(1,7,6); imshow(char6); title('6.jpg');
subplot(1,7,7); imshow(char7); title('7.jpg');
 
 
% Identify individual characters by comparison with the character template library
% Finally recognized the license plate number in the original picture
char = [];
store = strcat('A','B','C','D','E','F','G','H','J','K','L','M','M','N','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9','¾©','½ò','»¦','Óå','¼½','½ú','ÁÉ','¼ª','ºÚ','ËÕ','Õã' ,'Íî','Ãö','¸Ó','Â³','Ô¥','¶õ','Ïæ','ÔÁ','Çí','´¨','¹ó','ÔÆ','ÉÂ','¸Ê','Çà','²Ø','¹ð','ÃÉ','ÐÂ','Äþ','¸Û');
for i = 1:7
    for j = 1:67
        Im = eval(strcat('char',num2str(i)));
        Template = imread(strcat('E:\ËïÔÌ¼ÓÓÍ\±ÏÒµÉè¼Æ\picture\template\',num2str(j),'.bmp'));
        Template = im2bw(Template);
        Differ = Im-Template;   % Generate difference images
        Compare(j) = sum(sum(abs(Differ)));
    end
    % The template corresponding to the difference image with the smallest pixel value of 1 is the recognition result
    index = find(Compare == (min(Compare)));
    char = [char store(index)];
end
figure;imshow(b);title(strcat('This license plate number is: ', char));
display(strcat('This license plate number is: ', char));