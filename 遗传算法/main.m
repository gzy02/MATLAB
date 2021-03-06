function main()
clear all
close all
clc
global chrom oldpop fitness lchrom  popsize cross_rate mutation_rate yuzhisum
global maxgen  m n fit gen yuzhi A B C oldpop1 popsize1 b b1 fitness1 yuzhi1 
A=imread('4.jpg');     %读入医学图像
%A=imresize(A,0.4);
B=rgb2gray(A);         %灰度化
C=B;
%C=imresize(B,0.1);     %将读入的图像缩小
lchrom=8;              %染色体长度
popsize=10;            %种群大小
cross_rate=0.7;        %交叉概率
mutation_rate=0.4;     %变异概率
maxgen=150;            %最大代数
[m,n]=size(C);  
'计算中,请稍等...'
initpop;    %初始种群
for gen=1:maxgen
    generation;  %遗传操作
end
findresult; %图象分割结果
%%%输出进化各曲线
figure;
gen=1:maxgen;
plot(gen,fit(1,gen));
title('最佳适应度值进化曲线');
figure;
plot(gen,yuzhi(1,gen));
title('每一代的最佳阈值进化曲线');