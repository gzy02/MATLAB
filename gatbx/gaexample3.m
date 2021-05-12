clc
clear all
close all
%% ��������ͼ
figure(1);
lbx=0;ubx=2; %�����Ա���x��Χ
lby=0;uby=2; %�����Ա���y��Χ
ezmesh('100*(Y-X*X)*(Y-X*X)+(1-X)*(1-X)',[lbx,ubx,lby,uby],50);   %������������
hold on;
%% �����Ŵ��㷨����
NIND=100;        %������Ŀ
MAXGEN=2000;      %����Ŵ�����
PRECI=15;       %�����Ķ�����λ��
GGAP=0.1;      %����
px=0.7;         %�������
pm=0.001;        %�������
trace=zeros(3,MAXGEN);        %Ѱ�Ž���ĳ�ʼֵ 
%MAXGEN��ʾ����Ŵ���������Ϊ����һ��3��maxgen�е������������¼ÿ��������ֵ��
FieldD=[PRECI PRECI;lbx lby;ubx uby;1 1;0 0;1 1;1 1]; %����������
Chrom=crtbp(NIND,PRECI*2);     %��ʼ��Ⱥ
%% �Ż�
gen=0;                                  %��������
XY=bs2rv(Chrom,FieldD);                 %�����ʼ��Ⱥ��ʮ����ת��
X=XY(:,1);Y=XY(:,2);    %ȡXY����ĵ�һ�У��ڶ���
ObjV=100*(Y-X.*X).*(Y-X.*X)+(1-X).*(1-X);        %����Ŀ�꺯��ֵ
while gen<MAXGEN
   FitnV=ranking(ObjV); %������Ӧ��ֵ
   SelCh=select('rws',Chrom,FitnV,GGAP);%ѡ��
   SelCh=recombin('recint',SelCh,px);%����
   SelCh=mut(SelCh,pm);  %����
   XY=bs2rv(SelCh,FieldD);  %�Ӵ������ʮ����ת��
   X=XY(:,1);Y=XY(:,2);
   ObjVSel=100*(Y-X.*X).*(Y-X.*X)+(1-X).*(1-X);   %�����Ӵ���Ŀ�꺯��ֵ
   [Chrom,ObjV]=reins(Chrom,SelCh,1,1,ObjV,ObjVSel); %�ز����Ӵ����������õ�����Ⱥ
   XY=bs2rv(Chrom,FieldD);
   gen=gen+1;   %������������
   %��ȡÿ�������Ž⼰����ţ�YΪ���Ž�,IΪ��������
   [Y,I]=max(ObjV);
   trace(1:2,gen)=XY(I,:);  %����ÿ��������ֵ
   trace(3,gen)=Y; %����ÿ��������ֵ
end
plot3(trace(1,:),trace(2,:),trace(3,:),'bo');   %����ÿ�������ŵ�
grid on;
plot3(XY(:,1),XY(:,2),ObjV,'bo');  %�������һ������Ⱥ
hold off
%% ������ͼ
figure(2);
plot(1:MAXGEN,trace(3,:));
grid on
xlabel('�Ŵ�����')
ylabel('��ı仯')
title('��������')
bestZ=trace(3,end);
bestX=trace(1,end);
bestY=trace(2,end);
fprintf(['���Ž�:\nX=',num2str(bestX),'\nY=',num2str(bestY),'\nZ=',num2str(bestZ),'\n'])
