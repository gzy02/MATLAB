%使用了区域生长与形态学结合的方法
origin=imread('MRimage\\T1\\050.png');
T2=graythresh(origin);
I=imbinarize(origin,T2);%Otus进行分割
figure 
imshow(I);
[M,N]=size(I);
[y,x]=getpts; %单击取点后，按enter结束
x1=round(x);
y1=round(y);
seed=I(x1,y1); %获取中心像素灰度值

J=zeros(M,N);
J(x1,y1)=1;

count=1; %待处理点个数
threshold=0.15;
while count>0
    count=0;
    for i=1:M %遍历整幅图像
    for j=1:N
        if J(i,j)==1 %点在“栈”内
        if (i-1)>1&&(i+1)<M&&(j-1)>1&&(j+1)<N %3*3邻域在图像范围内
            for u=-1:1 %8-邻域生长
            for v=-1:1
                if J(i+u,j+v)==0&&abs(I(i+u,j+v)-seed)<=threshold
                    J(i+u,j+v)=1;
                    count=count+1;  %记录此次新生长的点个数
                end
            end
            end
        end
        end
    end
    end
end
subplot(2,2,1),imshow(I);
title("二值化")

subplot(2,2,2),imshow(J);
title("区域生长")

se2=strel('disk',24);%闭操作
J=imclose(J,se2);%闭操作

subplot(2,2,3),imshow(J);
title("闭操作")

origin=double(origin)/255;

result=immultiply(origin,J);%与原图像相乘
subplot(2,2,4),imshow(result);
title("结果")