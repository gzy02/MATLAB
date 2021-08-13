clc
clear
close all
addpath("./gatbx");
thnum=input("请输入阈值个数:");
A=zeros(thnum,1);%列向量 thnum*1
Img=imread("./4.jpg");
Pic=rgb2gray(Img);
[count,x]=imhist(Pic);
mysum=PrefixSum(count);

tic
myth=mysum.OtsuSolve(thnum);
disp("标准阈值分别为:");
disp(myth);
variance=mysum.fitness([88;165]);
disp("最大方差为:");
disp(variance);
toc


%% 定义遗传算法参数
tic
NIND=100;          %个体数目
MAXGEN=400;        %最大遗传代数
PRECI=8;         %变量的二进制位数
GGAP=1;        %代沟
px=0.15;            %交叉概率
pm=0.001;          %变异概率

lb=0;
ub=255;
mytrace=zeros(thnum+1,MAXGEN);          %寻优结果的初始值
%MAXGEN表示最大遗传代数，意为建立一个3行maxgen列的零矩阵，用来记录每代的最优值。
FieldD=zeros(7,thnum);%区域描述器
for i=1:thnum
    FieldD(1,i)=PRECI;
    FieldD(2,i)=lb;
    FieldD(3,i)=ub;
    FieldD(4,i)=1;
    FieldD(5,i)=0;
    FieldD(6,i)=1;
    FieldD(7,i)=1;
end
%disp(FieldD)
Chrom=crtbp(NIND,PRECI*thnum);      %初始种群 一个NIND行 (8*thnum)列的矩阵
%% 优化
gen=1;                                             %代计数器
%disp(Chrom)
Group=bs2rv(Chrom,FieldD);                      %计算初始种群的十进制转换
%disp(Group);
ObjVSel=zeros(NIND,1);
ObjV=zeros(NIND,1);

while gen<MAXGEN
    for i=1:size(Group,1)
        ObjV(i,1)=mysum.fitness((Group(i,:)'));
    end
    %获取每代的最优解及其序号，Y为最优解,I为个体的序号
    [Y,I]=max(ObjV);
    mytrace(1:thnum,gen)=Group(I,:);  %记下每代的最优值
    mytrace(thnum+1,gen)=Y; %记下每代的最优值
    %disp(mytrace(:,gen));
    
    FitnV=ranking(-ObjV); %分配适应度值
    SelCh=select('rws',Chrom,FitnV,GGAP);%选择
    SelCh=recombin('recint',SelCh,px);%重组
    SelCh=mut(SelCh,pm);  %变异
    Group=floor(bs2rv(SelCh,FieldD));  %子代个体的十进制转换,截断
    for i=1:size(Group,1)
        for j=1:thnum
            if(Group(i,j)>ub)
                Group(i,j)=ub;
            elseif(Group(i,j)<lb)
                Group(i,j)=lb;
            end
        end
    end
    gen=gen+1;    %代计数器增加

end
%% 画进化图
figure(2);
plot(1:MAXGEN,mytrace(thnum+1,:));
grid on
xlabel('遗传代数')
ylabel('解的变化')
title('进化过程')
[Y,I]=max(mytrace(thnum+1,:));
disp("遗传算法求得方差大小为:");
disp(Y);
disp("遗传算法求得对应阈值为:");
disp(mytrace(1:thnum,I));
toc