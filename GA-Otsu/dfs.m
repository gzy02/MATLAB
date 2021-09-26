function [ret,max] = dfs(cnt,output,maxth,inputdep,obj,maxoutput)
    if inputdep==length(output)+1
        fit=obj.fitness(output);
        if fit>maxth
            maxth=fit;
            maxoutput=output;
        end
        ret=maxoutput;
        max=maxth;
        %return
    
    else
        for i=cnt:255
            output(inputdep)=i;
            [ret,max]=dfs(cnt+1,output,maxth,inputdep+1,obj,maxoutput);
            maxth=max;
            maxoutput=ret;
        end
    end
end
