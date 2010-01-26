function fitness = eval_fitness(pop, params)
global bfcells;
fitness = ones(1, numel(pop));

 for i = 1:numel(pop)
	e = bfexec(pop{i,1});
	if(e > 0)
		fitness(i) = 0;
		continue;
	end
% 	nf = numfiboprop(params.NUMCELLSREQ);
% 	%si = strictincrease(NUMCELLSREQ); + 0.3 * (si/(NUMCELLSREQ - 1))
% 	fitness(i) = 0.65 * nf/(params.NUMCELLSREQ - 2)  + 0.2*all(bfcells(1:params.NUMCELLSREQ) >= 0); 
% 	fitness(i) = fitness(i) + 0.15*goldenration(params.NUMCELLSREQ);
    fitness(i) = nnz(bfcells(1:12) == 'hello, world')/12;
end

%disp('SUM: ');
%disp(sum(fitness));
end
