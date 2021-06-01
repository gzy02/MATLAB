function multifitness_order()
global lchrom oldpop fitness popsize chrom fit gen C m n  fitness1 yuzhisum x
global popsum u yuzhi gen oldpop1 popsize1 b1 b yuzhi1 cross_rate mutation_rate
if popsize>=5
    popsize=ceil(popsize-0.03*gen);
end
if gen==750     %当进化到末期的时候调整种群规模和交叉、变异概率
    cross_rate=0.3;        %交叉概率
    mutation_rate=0.3;     %变异概率
end
%如果不是第一代则将上一代操作后的种群根据此代的种群规模装入此代种群中
if gen>1  
    t=oldpop;
    j=popsize1;
    for i=1:popsize
        if j>=1
            oldpop(i,:)=t(j,:);
        end
        j=j-1;
    end
end
%计算适度值并排序
for i=1:popsize
    popsum=zeros(x+1,1);
    popnum=zeros(x+1,1);
    chrom=oldpop(i,:);
    c=zeros(1,x);
    for j=1:x
        for k=1:8
            c(j)=c(j)+chrom(1,(j-1)*8+k)*(2^(8-k));
        end
    end
    b(i,:)=c*255/(2^8-1);
    for y=1:m
        for z=1:n
            if C(y,z)<=b(i,1)
                popsum(1)=popsum(1)+double(C(y,z));%统计低于第一个阈值的灰度值的总和
                popnum(1)=popnum(1)+1; %统计低于第一个阈值的灰度值的像素的总个数
            elseif C(y,z)>b(i,x)
                popsum(x+1)=popsum(x+1)+double(C(y,z));%统计高于最后一个阈值的灰度值的总和
                popnum(x+1)=popnum(x+1)+1; %统计高于最后一个阈值的灰度值的像素的总个数
            else
                for h=2:x
                    if (C(y,z)>b(i,h-1)) && (C(y,z)<=b(i,h))
                        popsum(h)=popsum(h)+double(C(y,z));%统计低于第h个阈值且高于第h-1个阈值的灰度值的总和
                        popnum(h)=popnum(h)+1; %统计低于第h个阈值且高于第h-1个阈值的灰度值的像素的总个数
                    end
                end 
            end
        end
    end
    for j=1:x+1
        if popnum(j)~=0
            u(j)=popsum(j)/popnum(j);%求每一类的平均灰度值
        else 
            u(j)=0;
        end
    end
    ul=sum(popsum)/sum(popnum); %求所有类的平均灰度值
    fitness(1,i)=0;
    for j=1:x+1
        fitness(1,i)=fitness(1,i)+((u(j)-ul)^2*popnum(j))/sum(popnum);
    end
end
if gen==1 %如果为第一代，从小往大排序
    for i=1:popsize
        j=i+1;
        while j<=popsize
            if fitness(1,i)>fitness(1,j)
                tempf=fitness(1,i);
                tempc=oldpop(i,:);
                tempb=b(i,:);
                b(i,:)=b(j,:);
                b(j,:)=tempb;
                fitness(1,i)=fitness(1,j);
                oldpop(i,:)=oldpop(j,:);
                fitness(1,j)=tempf;
                oldpop(j,:)=tempc;
            end
            j=j+1;
        end
    end
    for i=1:popsize
        fitness1(1,i)=fitness(1,i);
        b1(i,:)=b(i,:);
        oldpop1(i,:)=oldpop(i,:);
    end
    popsize1=popsize;
else %大于一代时进行如下从小到大排序
    for i=1:popsize
        j=i+1;
        while j<=popsize
            if fitness(1,i)>fitness(1,j)
                tempf=fitness(1,i);
                tempc=oldpop(i,:);
                tempb=b(i,:);
                b(i,:)=b(j,:);
                b(j,:)=tempb;
                fitness(1,i)=fitness(1,j);
                oldpop(i,:)=oldpop(j,:);
                fitness(1,j)=tempf;
                oldpop(j,:)=tempc;
            end
            j=j+1;
        end
    end
end
%下边对上一代群体进行排序
for i=1:popsize1
    j=i+1;
    while j<=popsize1
        if fitness1(1,i)>fitness1(1,j)
            tempf=fitness1(1,i);
            tempc=oldpop1(i,:);
            tempb=b1(i,:);
            b1(i,:)=b1(j,:);
            b1(j,:)=tempb;
            fitness1(1,i)=fitness1(1,j);
            oldpop1(i,:)=oldpop1(j,:);
            fitness1(1,j)=tempf;
            oldpop1(j,:)=tempc;
        end
        j=j+1;
    end
end
%下边统计每一代中的最佳阈值和最佳适应度值
if gen==1
    fit(1,gen)=fitness(1,popsize);
    yuzhi(gen,:)=b(popsize,:);
    yuzhisum=0;
else
    if fitness(1,popsize)>fitness1(1,popsize1)
        yuzhi(gen,:)=b(popsize,:); %每一代中的最佳阈值
        fit(1,gen)=fitness(1,popsize);%每一代中的最佳适应度
    else
        yuzhi(gen,:)=b1(popsize1,:);
        fit(1,gen)=fitness1(1,popsize1);
    end
end