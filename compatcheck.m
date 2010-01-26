function compat = compatcheck(chrom1, chrom2)
bracs1 = chrom1; b1 = 1;
bracs2 = chrom2; b2 = 1;
for i = 1:numel(chrom1)
	if(chrom1(i) == ']')
		if(b1 > 1 && bracs1(b1-1) == '[')
			b1 = b1 - 1;
		else
			bracs1(b1) = ']'; 
			b1 = b1 + 1;
		end
	elseif(chrom1(i) == '[')
		bracs1(b1) = '['; 
		b1 = b1 + 1;
	end
	if(chrom2(i) == ']')
		if(b2 > 1 && bracs2(b2-1) == '[')
			b2 = b2 - 1;
		else
			bracs2(b2) = ']'; 
			b2 = b2 + 1;
		end
	elseif(chrom2(i) == '[')
		bracs2(b2) = '['; 
		b2 = b2 + 1;
	end
	
end
compat = (b1 == b2);
if(compat)
	compat = all(bracs1(1:b1-1) == bracs2(1:b2-1));
end
end
