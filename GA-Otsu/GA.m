classdef GA < handle

    properties
        pop_size = 20 %种群大小
        p_cross = 0.8 %交叉概率
        p_muta = 0.07 %变异概率
        iter_max = 100 %最大迭代次数
        thd_len = 8 %每个阈值的位数
        bestfit % 每代最好适应度 每代平均适应度
        bestfit_thd % 每代最好适应度对应个体
        hist % 结合最大类间方差
        thd_n % 阈值个数
        pop % 种群
    end

    methods

        function obj = GA(image, thlsd)
            obj.thd_n = thlsd;
            init_image = image;
            [count, ~] = imhist(init_image);
            obj.hist = PrefixSum(count);
            obj.bestfit = zeros(obj.iter_max, 2);
            obj.bestfit_thd = zeros(obj.iter_max, obj.thd_n);
            obj.pop = obj.init_pop();

            %最大迭代代数内迭代
            flag = ceil(obj.iter_max * (1 - 0.4));

            for iter = 1:obj.iter_max
                ini_pop = obj.pop;
                %交叉
                obj.cross();
                %变异
                obj.mutation();
                %选择
                [obj.pop, best_fit_aver_fit, cur_best_pop] = obj.selection(ini_pop);
                obj.bestfit(iter, :) = best_fit_aver_fit;
                obj.bestfit_thd(iter, :) = cur_best_pop;
                %调整选择和编译概率
                if iter == flag
                    obj.p_cross = obj.p_cross * 0.4;
                    obj.p_muta = obj.p_muta * 0.4;
                end

            end
            
            x = 1:1:obj.iter_max;
            y1 = obj.bestfit(:,1);
            y2 = obj.bestfit(:,2);
            subplot(2,2,1);
            plot(x,y1,'r');
            subplot(2,2,2);
            plot(x,y2,'b');
            
        end

        function pop = init_pop(obj)
            %随机生成[0 255]之间的十进制阈值
            pop = zeros(obj.pop_size, obj.thd_n);

            for i = 1:obj.pop_size
                pop(i, :) = randperm(255, obj.thd_n); % 从1~255中返回n个不相同值
            end

        end

        % 交叉
        function cross(obj)
            [row, list] = size(obj.pop);
            %多个交叉点的单点交叉
            cross_mount = fix(row * obj.p_cross); %向下取整，交叉个体数量
            if rem(cross_mount, 2) ~= 0 %凑偶数 方便两两交叉
                cross_mount = cross_mount + 1;
            end
            
            cross_num = randperm(row, cross_mount); %从1~row中，随机选择cross_mount做不重复随机排列
            %进行两两交叉
            for i = 1:2:cross_mount
                %每个阈值都单点交叉
                while 1
                    %每个阈值分量都进行不同程度单点交叉
                    cross_pos = randi(obj.thd_len, 1, list);
                    %将十进制编码成二进制
                    x = dec2base(obj.pop(cross_num(i), :), 2, obj.thd_len); %8位2进制表示的字符串数组
                    y = dec2base(obj.pop(cross_num(i + 1), :), 2, obj.thd_len);

                    for j = 1:list
                        for k = cross_pos(j):obj.thd_len
                            temp = x(j, k);
                            x(j, k) = y(j, k);
                            y(j, k) = temp;
                        end
                    end

                    %将二进制转换成十进制
                    obj.pop(cross_num(i), :) = base2dec(x, 2)';
                    obj.pop(cross_num(i + 1), :) = base2dec(y, 2)';
                    %检查一个子代中有没有产生相同的阈值
                    ux = length(obj.pop(cross_num(i), :)) - length(unique(obj.pop(cross_num(i), :)));
                    uy = length(obj.pop(cross_num(i + 1), :)) - length(unique(obj.pop(cross_num(i + 1), :)));

                    if ux == 0 && uy == 0 && sum(obj.pop(cross_num(i), :) > 255) == 0 && sum(obj.pop(cross_num(i + 1), :) > 255) == 0
                        break;
                    end

                end

            end

        end

        % 变异
        function mutation(obj)
            [row, list] = size(obj.pop);
            muta_mount = ceil(row * list * obj.thd_len * obj.p_muta); %上取整，计算总共要变异的二进制位数
            muta_num = randperm(row * list * obj.thd_len, muta_mount); %待变异位置

            for i = 1:muta_mount
                muta_row = ceil(muta_num(i) / (list * obj.thd_len));

                if rem(muta_num(i), list * obj.thd_len) == 0
                    muta_list = list;
                    muta_bit = obj.thd_len;
                else
                    muta_list = ceil(rem(muta_num(i), list * obj.thd_len) / obj.thd_len);
                    muta_bit = rem(muta_num(i), list * obj.thd_len) - (muta_list - 1) * obj.thd_len;
                end

                %
                %将十进制编码成二进制
                z = dec2base(obj.pop(muta_row, muta_list), 2, obj.thd_len); %8位2进制表示的字符串数组

                while 1

                    if z(muta_bit) == '0'
                        z(muta_bit) = '1';
                    else
                        z(muta_bit) = '0';
                    end

                    obj.pop(muta_row, muta_list) = base2dec(z, 2);
                    %检查变异后一个个体中有没有相同的阈值
                    uz = length(obj.pop(muta_row, :)) - length(unique(obj.pop(muta_row, :)));
                    if uz == 0 && sum(obj.pop(muta_row, :) > 256) == 0
                        break;
                    else
                        muta_bit = randi(obj.thd_len, 1);
                    end
                end
            end
        end

        % 选择
        function [select_pop, best_fit_aver_fit, cur_best_pop] = selection(obj, ini_pop)
            [row, list] = size(ini_pop);
            obj.pop(obj.pop == 0) = 1; %阈值不为0
            elite_pro = 0.1; %精英中保持的父代比例

            %保留父代优秀个体
            f_num = ceil(elite_pro * row); %父代数量
            f_fitness = obj.compute_fit(ini_pop);
            [~, b] = sort(f_fitness, 'descend');
            temp_pop = ini_pop(b(1:f_num), :);
            select_fit = f_fitness(b(1:f_num));

            %保留子代个体
            s_fitness = obj.compute_fit(obj.pop);
            %根据适应度值计算累积概率
            c_fit = zeros(row, 1); %累积适应度
            c_sum = 0;
            for i = 1:row
                c_sum = c_sum + s_fitness(i);
                c_fit(i) = c_sum;
            end
            por = c_fit / c_sum; %累积概率

            %轮盘赌选择row - f_num个个体
            s_num = row - f_num;

            for i = 1:s_num
                r = rand;

                for j = 1:row

                    if por(j) >= r
                        temp_pop(f_num + i, :) = obj.pop(j, :);
                        select_fit(f_num + i) = s_fitness(j);
                        break;
                    end
                end
            end
            %选择后的每一代的最好适应度和平均适应度
            best_fit = max(select_fit);
            aver_fit = mean(select_fit);
            best_fit_aver_fit = [best_fit, aver_fit];
            %选择后最好适应度的解空间
            [~, b] = sort(select_fit, 'descend');
            cur_best_pop = temp_pop(b(1), :);
            select_pop = temp_pop;
        end
        
        function [select_pop, best_fit_aver_fit, cur_best_pop] = tnt_selection(obj) %锦标赛选择
            tnt_size = 2;
            s_fitness = obj.compute_fit(obj.pop);
            [row, list] = size(obj.pop);
            select_pop = zeros(row,list);
            for i = 1:obj.pop_size
                temp = randperm(obj.pop_size,tnt_size);
                bf = 1;
                for j = 1:tnt_size
                    if s_fitness(temp(j))>s_fitness(bf)
                        bf = j;
                    end
                end
                select_pop(i) = obj.pop(j);
            end
            select_fit = obj.compute_fit(select_pop);
            best_fit = max(select_fit);
            aver_fit = mean(select_fit);
            best_fit_aver_fit = [best_fit, aver_fit];
            [~, b] = sort(select_fit, 'descend');
            cur_best_pop = select_pop(b(1), :);
        end

        function var = compute_fit(obj, pop)
            var = zeros(obj.pop_size, 1);
            for i = 1:obj.pop_size
                var(i) = obj.hist.fitness(pop(i, :));
            end

        end
        
        function varience = otsu_var(obj,thsld)
            varience = obj.hist.fitness(thsld);
        end
    end

end
