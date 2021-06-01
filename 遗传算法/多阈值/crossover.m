function crossover()
global temp popsize cross_rate lchrom
j=1;
for i=1:popsize
    p=rand;
    if p<=cross_rate        
        parent(j,:)=temp(i,:);
        a(1,j)=i;%a(1,j)表示和第j个个体发生交叉操作的子代个体
        j=j+1;
    end
end
j=j-1; %j表示有多少个个体发生了交叉操作
if rem(j,2)~=0
    j=j-1;
end
if j>=2 %判断是否有个体发生了交叉操作
    for k=1:2:j    %前cutpoint个位点，父辈中的第f和f+1个个体分别与其对应的子辈中的个体交叉，后面的位点，则交换式交叉
        cutpoint=round(rand*(lchrom-1));
        f=k;
        for i=1:cutpoint
            temp(a(1,f),i)=parent(f,i);
            temp(a(1,f+1),i)=parent(f+1,i);
        end
        for i=(cutpoint+1):lchrom
            temp(a(1,f),i)=parent(f+1,i);
            temp(a(1,f+1),i)=parent(f,i);
        end
    end
end