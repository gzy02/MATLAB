function res = segment(img,thd)
% 传入图像和阈值，返回分割后图像
thd = sort(thd);
res = img;
[m,n] = size(img);
thd_n = length(thd);
for i=1:1:m
    for j=1:1:n
        if res(i,j)<thd(1)
            res(i,j)=0;
        elseif res(i,j)>=thd(thd_n)
            res(i,j)=255;
        else
            for k=1:1:thd_n-1
                if res(i,j)>=thd(k) && res(i,j)<thd(k+1)
                    % res(i,j)=int8(k*255/thd_n);
                    res(i,j)=int8((thd(k)+thd(k+1))/2);
                end
            end
        end
    end
end
% figure;
% imshow(res);