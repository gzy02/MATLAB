close all;
clc;
%该代码为对纯形态学方法加入了各向异性扩散滤波
k=6;           %导热系数,控制平滑
lambda=0.2;    %控制平滑
N=15;           %迭代次数
img=double(imread('MRimage\\T1\\830.png'));
imshow(img,[]);
[m,n]=size(img);

imgn=zeros(m,n);
for i=1:N

    for p=2:m-1
        for q=2:n-1
            %当前像素的散度，对四个方向分别求偏导，局部不同方向上的变化量，
            %如果变化较多，就证明是边界，想方法保留边界
            NI=img(p-1,q)-img(p,q);
            SI=img(p+1,q)-img(p,q);
            EI=img(p,q-1)-img(p,q);
            WI=img(p,q+1)-img(p,q);
            
            %四个方向上的导热系数，该方向变化越大，求得的值越小，从而达到保留边界的目的
            cN=exp(-NI^2/(k*k));
            cS=exp(-SI^2/(k*k));
            cE=exp(-EI^2/(k*k));
            cW=exp(-WI^2/(k*k));
            
            imgn(p,q)=img(p,q)+lambda*(cN*NI+cS*SI+cE*EI+cW*WI);  %扩散后的新值      
        end
    end
    
    img=imgn;       %整个图像扩散完毕，用已扩散图像的重新扩散。
end
figure;
img2=mat2gray(imgn);%img2是滤波后的图像
imshow(img2);
%imwrite(img2,'MRimage\9900.png');

T=graythresh(img2);
img3=imbinarize(img2,T);%Otus进行分割
%se=strel('octagon',6);se2=strel('octagon',27);
se=strel('disk',6);se2=strel('disk',24);
img4=imopen(img3,se);
img5=imclose(img4,se2);
J=immultiply(img2,img5);
imshow(J);
