function newfragment = makecompatfragment(oldfragment, params)
[oldop oldcl] = findbraces(oldfragment);
len = length(oldfragment);
newfragment = params.symbols(round(rand(1, len)*(params.NUMSYMBS-1) + 1));
[newop newcl] = findbraces(newfragment);
while([newop newcl] ~= [oldop oldcl])
	newfragment = params.symbols(round(rand(1, len)*(params.NUMSYMBS-1) + 1));
	[newop newcl] = findbraces(newfragment);
end
end
