function children = crossovers(pop, params)
children = pop;
count = numel(children) + 1;
used = zeros(1, numel(pop));

for i = 1:(numel(pop) - 1)
	if(used(i))
		continue;
	end
	unusedind = find(~used);
	if(isempty(unusedind))
		break;
	end
	chrom1 = pop{i,1};
	used(i) = 1;
	if(numel(chrom1) <= 1)
		disp('Chrom1 toooo short...');
		continue;
	end
	sanechildren = 0; sanitycount = 1;
	j = 0;
	while(~sanechildren)
		if(sanitycount > 1)
			used(j) = 0;
		end
		j = unusedind(round(rand()*(numel(unusedind) - 1) + 1));
		used(j) = 1;
		chrom2 = pop{j,1};
		foundcompatfragments = 0; frcount = 0;
		while(~foundcompatfragments)
			frcount = frcount + 1;
			if(frcount > 10000)
				disp('Fragments matchae aaga maatengudhu baa! Innaanu paaru...');
				chrom1, chrom2, fragment1, fragment2
			end
			pos1 = round(rand()*(numel(chrom1) - 2) + 1); maxlen = length(chrom1) - pos1;
			pos2 = round(rand()*(numel(chrom2) - 2) + 1); maxlen = min(maxlen, length(chrom2) - pos2);
			len = round(rand()*(maxlen - 1) + 1);

			if(numel(chrom2) < pos2+1)
				pos2, len, chrom1, chrom2
				disp('Length 2 Gujaltified!');
			end

			if(numel(chrom1) < pos1+1)
				pos1, len, chrom1, chrom2
				disp('Length 1 Gujaltified!');
			end
			fragment1 = chrom1(pos1+1:pos1+len);
			fragment2 = chrom2(pos2+1:pos2+len);
			foundcompatfragments = compatcheck(fragment1, fragment2);
		end

		childchrom1 = [chrom1(1:pos1) chrom2(pos2+1:pos2+len)];
		if(length(chrom1) > pos1 + len)
			childchrom1 = [childchrom1 chrom1(pos1+len+1:end)]; %#ok<AGROW>
		end


		childchrom2 = [chrom2(1:pos2) chrom1(pos1+1:pos1+len)];
		if(length(chrom2) > pos2 + len)
			childchrom2 = [childchrom2 chrom2(pos2+len+1:end)]; %#ok<AGROW>
		end

		childchrom1 = boundcorrect(childchrom1);
		childchrom2 = boundcorrect(childchrom2);

		sanechildren = issaneprog(childchrom1) && issaneprog(childchrom2);
		sanitycount = sanitycount + 1;
		if(sanitycount > 10000 && ~sanechildren)
			disp('Every damn soul is insane! Investigate: ');
			issaneprog(childchrom1), issaneprog(childchrom2), sanechildren, pos1, pos2
			len, chrom1, chrom2, childchrom1, childchrom2
		end
	end

	children{count, 1} = optimize(childchrom1);
	children{count+1, 1} = optimize(childchrom2);
	count = count + 2;
end
end


