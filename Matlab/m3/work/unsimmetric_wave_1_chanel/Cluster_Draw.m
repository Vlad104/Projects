function Wp = Cluster_Draw(S, W)

Wp(1:64, 1:50) = 0;
    len = length(S);
    for i = 1:len
        if S(i,2) > 0
%             v = round(S(i,7));
%             r = round(S(i,8));
            v = round(S(i,4)/0.78125) + 32;
            r = round(S(i,3)/3);
            Wp(v,r) = S(i,2);
        end;
    end;
end