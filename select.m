function selected = select(pop, fitness, params)
[sf indices] = sort(fitness, 'descend');

ELITE_COUNT = 5;
selected = pop(indices(1:ELITE_COUNT), 1);
%sfit = eval_fitness(selected)

j = ELITE_COUNT + 1;
nonelite = pop(indices(ELITE_COUNT+1:end), 1);

numloops = cellfun(@numel, strfind(nonelite, '[')).';	%find the number of loops in each program
maxnumloops = max(numloops);
loopratio = (numloops./maxnumloops).^(1/8);	%power 1/n to reduce it's influence

count = 0;
numlessfit = round(rand()*(4*ELITE_COUNT)) + params.POP_COUNT - 2*ELITE_COUNT;

i = 1;
while(count <= numlessfit)
	randval = rand()*sf(ELITE_COUNT + 1)/loopratio(i);
	if(sf(i + ELITE_COUNT) >= randval)
		selected{j,:} = nonelite{i,1};
		j = j + 1;
		count = count + 1;
	end
	i = i + 1;
	if(i > numel(nonelite))
		i = 1;
	end
end

end

