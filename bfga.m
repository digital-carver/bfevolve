function program = fiboganew(init)
global NUMSYMBS;
NUMSYMBS = 6;

global symbols;
symbols = ['+' '-' '<' '>' '[' ']']; %Input and output are orthogonal to our requirements

global POP_COUNT;
POP_COUNT = 100;		%The approximate number of individuals we desire in each generation

global pop; 
global curbest;

global LENUPBND;
LENUPBND = 140;		%Upper bound for the length of the program

global LENLOWBND;
LENLOWBND = 10;		%Lower bound

params = struct('POP_COUNT', 100, 'LENUPBND', 140, 'LENLOWBND', 10, 'symbols', ['+' '-' '<' '>' '[' ']'], 'NUMSYMBS', 6, ...
	'NUMCELLSREQ', 50);

i = 1;
if(nargin == 0)
	while(i <= POP_COUNT)
		randlen = round(LENLOWBND + rand() * LENUPBND);
		
		prog = symbols(round(rand(1, randlen) * (NUMSYMBS - 1) + 1));
		prog = boundcorrect(optimize(prog));
		
		if(length(prog) > LENLOWBND && issaneprog(prog))
			init{i, 1} = prog;
			i = i + 1;
		end
	end
	init %#ok<NOPRT>
%	pause
end
pop = init;

figure;
hold on;

fitness = eval_fitness(pop, params); %#ok<NOPRT>
if(any(fitness == 1))
	program = pop{find(fitness == max(fitness)), 1} %#ok<NOPRT>
	return;
end
%pop = select(pop, fitness) %#ok<NOPRT>
maximumfitness = max(fitness)
stem(0, maximumfitness)

warning('off','all');
stagnancy = 0;
numgen = 0;
while(numgen <= 50000)
	disp(sprintf('Working on generation %d...\n', numgen));
	numparents = numel(pop);
	pop = crossovers(pop, params);
	pop = mutate(pop, numparents, params);	%numparents sent so that it mutates only children.
	fitness = eval_fitness(pop, params); %#ok<NOPRT>
	
	if(any(fitness > .99))
		disp('Wow! We did it!!');
		break;
	end
	diffmax = abs(max(fitness) - maximumfitness);
	if(diffmax == 0)
		stagnancy = stagnancy + 1;
		if(stagnancy > 50)
			disp('Performing strong mutation.');
			pop = strongmutate(pop, fitness, params);
			stagnancy = 0;
		end
	elseif(diffmax > 0)
		stagnancy = 0;
	else
		error('Something is terribly wrong! Fitness decreased...');
	end
	
	pop = select(pop, fitness, params) %#ok<NOPRT>
	curbest = pop{1,1};
	pop = unique(pop); %Inbuilt unique for selecting unique strings
	numpop = numel(pop)

	maximumfitness = max(fitness) %#ok<NOPRT>
	numgen = numgen + 1;
	stem(numgen, maximumfitness);	
	%    pause
end
if(numgen >= 50000)
	warning('The fitness objective was not achieved. Stopping because of reaching maximum number of generations.')
	fitness = eval_fitness(pop); %#ok<NOPRT>
end
clear mutate;	%To re initialize mutation rate
program = pop{find(fitness == max(fitness)), 1} %#ok<NOPRT>
%disp(sprintf('Achieved %g%% accuracy, found %g%% of the target.', numprimes(pop)/numel(pop)*100, numprimes(pop)/numel(primes(maxval))*100))
end
