function children = mutate(childchromos, numparents, params)
children = childchromos;
i = numparents + 1;

persistent MUT_RATE;
if(isempty(MUT_RATE))
	disp('Initializing mutation rate');
	MUT_RATE = 0.5;
end

while i <= numel(childchromos)
	if(rand() > MUT_RATE)
		continue;
	end
	pos = round(rand()*(length(childchromos{i, 1}) - 2) + 1);
	allowedlength = length(childchromos{i,1}) - pos;
	probs = rand(1,allowedlength);
	len = find(probs == max(probs), 1);	%find first occurrence only
	thischild = childchromos{i,1};
	assert((numel(thischild) >= pos+len-1 && pos > 0 && len > 0), 'ThisChild %s length pathala: pos is %d, len is %d', thischild, pos, len);
	oldfragment = thischild(pos:pos+len-1);
	newfragment = makecompatfragment(oldfragment, params);
	thischild(pos:pos+len-1) = newfragment;
	thischild = optimize(thischild);
	
	while(length(thischild) < params.LENLOWBND)
		l = length(thischild);
		randlen = round(params.LENLOWBND + rand() * params.LENUPBND) - l;

		addendum = params.symbols(round(rand(1, randlen)*(params.NUMSYMBS-1) + 1));
		while(~issaneprog(addendum))
			randlen = round(params.LENLOWBND + rand() * params.LENUPBND) - l;
			addendum = params.symbols(round(rand(1, randlen)*(params.NUMSYMBS-1) + 1));
		end
		thischild = [thischild addendum]; %#ok<AGROW> 
		thischild = optimize(thischild);
	end
	
	if(issaneprog(thischild))
		children{i,1} = thischild;
		i = i + 1;
	end
end

MUT_RATE = MUT_RATE - 0.4/10000;	%less than initial rate / 10000 so that some mutation occurs in last gens too
end

