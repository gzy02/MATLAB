% tic
% A = zeros(2000,200);
% 
% for i = 1:size(A,1)
%     for j = 1:size(A,2)
%         A(i,j)=i*2000+j;
%     end
% end
% toc
% 
% tic
% 
% 
% for i = 1:size(A,1)
%     for j = 1:size(A,2)
%         A(i,j)=i*2000+j;
%     end
% end
% toc

function pre(x)
if x<2
    disp(x);
elseif x>2
    disp(x+1);
else
    disp(x-1);
end
end
