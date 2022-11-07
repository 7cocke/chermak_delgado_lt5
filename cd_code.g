#compute the Chermak-Delgado measure of K in H
CD_measure:=function(H,K)
return Order(K)*Order(Centralizer(H,K));
end;

#compute m^*(H)
Max_CD_measure:=function(H)
return MaximumList(List(ConjugacyClassesSubgroups(H),x->CD_measure(H,Representative(x))));
end;

#check to see if $H \in CD(H)$
H_in_CDL:=function(H)
	if CD_measure(H,H) = Max_CD_measure(H) then
		return true;
	else
		return false;
	fi;
end;

#count the number of subgroups not in the CD Lattice(H) which contain Z(H)


NumberSubgroupsContainingCenterOutsideCDL:=function(H)
  local toCount, SubgroupConjugacyClasses, max_cdm, Z_H, rep, class;

toCount:=[];
SubgroupConjugacyClasses:=ConjugacyClassesSubgroups(H);
max_cdm:=Max_CD_measure(H);
Z_H:=Center(H);

for class in SubgroupConjugacyClasses do
	rep:=Representative(class);
		if CD_measure(H,rep) <> max_cdm and IsSubset(rep,Z_H) then
			Add(toCount,class);
		fi;
od;

return Sum(List(toCount,x->Size(x)));
end;

NumberSubgroupsOrder_p:=function(H)
  local p, classes_order_p;

p:=PrimePGroup(H);
classes_order_p:=Filtered(ConjugacyClasses(H),x->Order(Representative(x))=2);
return Sum(List(classes_order_p,x->Size(x)));
end;

NumberSubgroupsNotContainingCentralSubgroup:=function(K,Z)
  local p, toCount, rep, class;

#we assume $Z <= Z(K)$
#we count the number of subgroups of $K$ of order >= p^2 which do not contain Z
#we can do this by identifying the conjugacy classes which do or do not contain
#Z as a subgroup and then count the lengths of the conjugacy classes which do not

p:=PrimePGroup(K);
toCount:=[];
for class in Filtered(ConjugacyClassesSubgroups(K), x->Order(Representative(x))>= p^2) do
	rep:=Representative(class);
		if not IsSubset(rep,Z) then
			Add(toCount,class);
		fi;
od;

return Sum(List(toCount,x->Size(x)));
end;

Test_1:=function(K)
	if NumberSubgroupsOrder_p(K) > 4 then
		return false;
	fi;
return true;
end;

Test_2:=function(K)
  local Z_K, p, bound, candidates, Z;

Z_K:=Center(K);
p:=PrimePGroup(K);

if p > 2 then bound:=0; else bound:=1; fi;

candidates:=Filtered(AllSubgroups(Z_K),x->Order(x)=p);

for Z in candidates do
	if NumberSubgroupsNotContainingCentralSubgroup(K,Z) <= bound then
		return true;
	fi;
od;

return false;

end;

Test_3:=function(K)
  local p;

p:=PrimePGroup(K);
	if Order(K) < p^3 then return false; fi;
#
	if CD_measure(K,K) <> Max_CD_measure(K) then return false; fi;

### to get here we have $|K| >= p^3$ and $K \in CD(K)$
	if NumberSubgroupsContainingCenterOutsideCDL(K) > 1 then return false; fi;

return true;

end;

ComputeDeltaCD:=function(G)

local SubgroupClasses, CD_LatticeClasses;

SubgroupClasses:=ConjugacyClassesSubgroups(G);
CD_LatticeClasses:=Filtered(
SubgroupClasses,x->CD_measure(G,Representative(x))=Max_CD_measure(G));

return Sum(List(SubgroupClasses,Size)) - Sum(List(CD_LatticeClasses,Size));
end;

TestSubgroupsOfOrderN:=function(n)
  local match;
Print(" ----------------- Test Results -----------------\n\n");
	for match in List(Filtered(AllSmallGroups(n),x-> Test_1(x) and Test_2(x) and Test_3(x)),IdSmallGroup) do
		Print(StringFormatted("SmallGroup({},{}) which is isomorphic to {} passes the tests\n\n",n,match[2],StructureDescription(SmallGroup(n,match[2]))));
		# Print(StringFormatted("{} passes the tests\n",));
	od;
end;

TestSubgroupsOfOrderN(32);

TestSubgroupsOfOrderN(243);

