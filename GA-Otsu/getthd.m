function thd = getthd(img,n)
my = GA(img,n);
thd = my.bestfit_thd(my.iter_max,:);
thd = sort(thd);