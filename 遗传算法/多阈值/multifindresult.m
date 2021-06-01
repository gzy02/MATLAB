function multifindresult()
global maxgen yuzhi m n C B A x
result=yuzhi(maxgen,:);%到最大进化代数时的最佳阈值
disp(result)
C=B;
%C=imresize(B,0.3);
imshow(A);
title('原始图像')
figure;
subplot(1,2,1)
imshow(C);
title('原始灰度图')
[m,n]=size(C);
%用所找到的阈值分割图象
for i=1:m
    for j=1:n
        if C(i,j)<=result(1)
            C(i,j)=0;
        elseif C(i,j)>result(x)
            C(i,j)=255;
        else
            for k=2:x
                if (C(i,j)>result(k-1)) && (C(i,j)<=result(k))
                    C(i,j)=floor(255/x)*(k-1);
                end
            end
        end
    end
end
subplot(1,2,2)
imshow(C);
title('阈值分割后的图');