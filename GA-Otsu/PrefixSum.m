classdef PrefixSum <handle
    %UNTITLED 此处显示有关此类的摘要

    properties
        SumpixPro
        SumWpixPro
    end

    methods
        function obj = PrefixSum(pixCount)
            %PrefixSum 构造此类的实例
            %传入列向量，表示256个像素的统计数值
            pixPro=zeros(256,1);
            WpixPro=zeros(256,1);
            obj.SumpixPro=zeros(256,1);
            obj.SumWpixPro=zeros(256,1);
            CountSum=sum(pixCount);

            obj.SumpixPro(1)=pixCount(1)/CountSum;
            pixPro(1)=obj.SumpixPro(1);
            for i=2:256
                pixPro(i)=pixCount(i)/CountSum;
                WpixPro(i)=(i-1)*pixPro(i);
                obj.SumpixPro(i)=pixPro(i)+obj.SumpixPro(i-1);
                obj.SumWpixPro(i)=WpixPro(i)+obj.SumWpixPro(i-1);
            end
        end

        function variance = fitness(obj,inputTh)
            %fitness 此处显示有关此方法的摘要
            %   此处显示详细说明
            sort(inputTh);
            cnt=1;
            tep=1;
            w=zeros(256,1);
            u=zeros(256,1);

            for i=1:length(inputTh)
                w(cnt)=obj.SumpixPro(inputTh(i)+1)-obj.SumpixPro(tep);

                if cnt==1
                    w(cnt)=w(cnt)+obj.SumpixPro(tep);
                end
                if w(cnt)==0
                    variance=-1;
                    return;
                end
                u(cnt)=(obj.SumWpixPro(inputTh(i)+1)-obj.SumWpixPro(tep))/w(cnt);

                tep=inputTh(i)+1;
                cnt=cnt+1;
            end
            w(cnt)=1-obj.SumpixPro(tep);
            if w(cnt)==0
                variance=-1;
                return;
            end
            u(cnt)=(obj.SumWpixPro(256)-obj.SumWpixPro(tep))/w(cnt);
            deltatep=0;

            for i=1:cnt
                deltatep=deltatep+w(i)*(u(i)-obj.SumWpixPro(256))*(u(i)-obj.SumWpixPro(256));
            end
            variance=deltatep;
        end

        function output = OtsuSolve(obj,inputdep)
            %输入阈值个数，返回具体阈值（列向量）
            out=zeros(inputdep,1);
            maxoutput=zeros(inputdep,1);
            output=dfs(0,out,0,1,obj,maxoutput);
            
        end
    end
end

