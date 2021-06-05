clc
clear
close all

thnum=input("请输入阈值个数:");
A=zeros(thnum,1);%列向量 thnum*1
Img=imread("../4.jpg");
Pic=rgb2gray(Img);
[count,x]=imhist(Pic);
mysum=PrefixSum(count);
tic
myth=mysum.OtsuSolve(thnum);
disp(myth)
toc
variance=mysum.fitness([88;165]);
disp(variance)

%fmesh(@(x,y) mysum.fitness([x;y]),[0 255 0 255]);
% figure;
% stem(x,count);
% title("像素分布直方图");
% figure;
% imshow(Img);
% title("原始图像");
