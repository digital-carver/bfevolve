function newpop = strongmutate(pop, fitness, params)
[sf indices] = sort(fitness, 'descend');
PRESERVE_COUNT = round(numel(pop)/4);
newpop = pop;
newpop(1:PRESERVE_COUNT, 1) = pop(indices(1:PRESERVE_COUNT), 1);

i = PRESERVE_COUNT + 1;
while (i <= numel(pop))
	randlen = round(params.LENLOWBND + rand() * params.LENUPBND);

	prog = params.symbols(round(rand(1, randlen) * (params.NUMSYMBS - 1) + 1));
	prog = boundcorrect(optimize(prog));
	
	if(length(prog) > params.LENLOWBND && issaneprog(prog))
		newpop{i, 1} = prog;
		i = i + 1;
	end
end
end
