H_in_cd:=function(H)
       cd_H := Max([#K`subgroup*#Centralizer(H,K`subgroup): K in NormalSubgroups(H) | IsAbelian(K`subgroup)]);
       return #H*#Center(H) eq cd_H;
end function;

not_in_cd:=function(H)
      cd_H := Max([#K`subgroup*#Centralizer(H,K`subgroup): K in NormalSubgroups(H) | IsAbelian(K`subgroup)]);
      CD_H := [];
       for K in Subgroups(H) do
           if #sub<H|K`subgroup, Center(H)> eq #sub<H|K`subgroup> and #K`subgroup * #Centralizer(H,K`subgroup) ne cd_H then
                Append(~CD_H,K`length);
            end if;
        end for;
      if #CD_H eq 0 then return 0; end if;
      return &+CD_H;
end function;

condition_1:=function(order)
       p := Factorization(order)[1][1];
       ret_set := {};
       for i in [1..NumberOfSmallGroups(order)] do
            K := SmallGroup(order,i);
            if #{x: x in K | Order(x) eq p} le 4*(p-1) then
                 Include(~ret_set,i);
            end if;
        end for;
       return ret_set;
end function;

condition_2:=function(order)
        p := Factorization(order)[1][1];
        ret_set := {};
        for i in [1..NumberOfSmallGroups(order)] do
            K:=SmallGroup(order,i);
            Z:=Center(K);
            for H in Subgroups(Z:OrderEqual:=p) do
                if #{*1: J in Subgroups(K)|J`order ge 4 
                   and (#sub<K|J`subgroup,H`subgroup> ne #sub<K|J`subgroup>)*} gt (3-p) 
                then continue; end if;
                    Include(~ret_set,i);
            end for;
        end for;
        return ret_set;
end function;

condition_3 := function(order)
        p := Factorization(order)[1][1];
        ret_set := {};
        for i in [1..NumberOfSmallGroups(order)] do
            K := SmallGroup(order,i);
            if H_in_cd(K) and not_in_cd(K) lt 1 then         
                Include(~ret_set,i);
            end if;
        end for;
        return ret_set;
end function;

condition_1(32) meet condition_2(32) meet condition_3(32);
condition_1(243) meet condition_2(243) meet condition_3(243);

