%%
img = 'image/701.png';
img = imread(img);
thnum=input("请输入阈值个数:");
my = GA(img,thnum);
tic
thd = my.bestfit_thd(my.iter_max,:);
toc
var = my.otsu_var(thd);
disp(thd);
disp(var);
subplot(2,2,3);
imshow(img);
subplot(2,2,4);
res = segment(img,thd);
imshow(res);
%%
img_source = [301,601,701,750,801,990];
thnum=input("请输入:");
comp = zeros(4,6);
for i=1:1
    path = strcat('image/',num2str(img_source(i)),'.png');
    img = imread(path);
    my = GA(img,thnum);
    thd = my.bestfit_thd(my.iter_max,:);
    var = my.otsu_var(thd);
    comp(1,i)=var;
    
    [count,x]=imhist(img);
    mysum=PrefixSum(count);
    myth=mysum.OtsuSolve(thnum);
    variance=mysum.fitness(myth);
    comp(2,i) = variance;
    comp(3,i) = variance-var;
    comp(4,i) = comp(3,i)/comp(2,i);
    disp(comp(4,i));
end
%%
a = [1,2,3];
disp(a(1));