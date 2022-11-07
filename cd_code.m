H_in_cd:=function(H)
       cd_H := Max([#K`subgroup*#Centralizer(H,K`subgroup): K in Subgroups(H)]);
       return #H*#Center(H) eq cd_H;
end function;

not_in_cd:=function(H)
      cd_H := Max([#K`subgroup*#Centralizer(H,K`subgroup): K in Subgroups(H)]);
      if #CD_H eq 0 then return 0; end if;
      return &+CD_H;
end function;

order := 32;
Y := {};
X := {};
ZZ := {x: x in [1..NumberOfSmallGroups(order)]|
H_in_cd(SmallGroup(order,x)) and not_in_cd(SmallGroup(order,x)) lt 1};
for i in [1..NumberOfSmallGroups(order)] do
    K:=SmallGroup(order,i);
    Z:=Center(K);
    for H in Subgroups(Z:OrderEqual:=2) do
        if #{*1: J in Subgroups(K)|J`order ge 4 
        and (#sub<K|J`subgroup,H`subgroup> ne #sub<K|J`subgroup>)*} gt 1 
        then continue; end if;
        Include(~X,i);
    end for;
    if #{x: x in K | Order(x) eq 2} le 3 then Include(~Y,i); end if;
end for;
X;
Y;
ZZ;
X meet Y meet ZZ;

order := 243;
Y := {};
X := {};
ZZ := {x: x in [1..NumberOfSmallGroups(order)]|
H_in_cd(SmallGroup(order,x)) and not_in_cd(SmallGroup(order,x)) lt 1};
for i in [1..NumberOfSmallGroups(order)] do
    K:=SmallGroup(order,i);
    Z:=Center(K);
    for H in Subgroups(Z:OrderEqual:=2) do
        if #{*1: J in Subgroups(K)|J`order ge 4 
        and (#sub<K|J`subgroup,H`subgroup> ne #sub<K|J`subgroup>)*} gt 1 
        then continue; end if;
        Include(~X,i);
    end for;
    if #{x: x in K | Order(x) eq 2} le 3 then Include(~Y,i); end if;
end for;
X;
Y;
ZZ;
X meet Y meet ZZ;
