clc,clear
p=input("选择disk结构元素[输入0]还是octagon结构元素[输入1]");

I=imread('MRimage\\T1\\101.png');


figure(1);
subplot(3,2,1);
imshow(I);
subplot(3,2,2);
imhist(I);title('灰度图');
%自动选择阈值
T2=graythresh(I);
BW2=imbinarize(I,T2);%Otus进行分割
subplot(3,2,3);imshow(BW2),title('Otus阈值进行分割');
%BW2为大津法所得图像

if p==0
   se=strel('disk',5);se2=strel('disk',24);
else
   se=strel('octagon',6);se2=strel('octagon',27);
end

BW3=imopen(BW2,se);%开操作
subplot(3,2,4);imshow(BW3);title('开操作');
BW4=imclose(BW3,se2);%闭操作
subplot(3,2,5);imshow(BW4);title("闭操作");
J=immultiply(I,BW4);%与原图像相乘
%imwrite(J, 'D:\MRimage\990.png');
subplot(3,2,6);imshow(J);title('与原图像相乘');





