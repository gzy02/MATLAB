function thd = getthd(img,n)
[count,x]=imhist(img);
mysum=PrefixSum(count);
thd = mysum.OtsuSolve(n);
