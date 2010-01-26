function corrected = boundcorrect(program)
i = 1;
symbs = '>+-';
while( i <= numel(program) && program(i) ~= '[' && program(i) ~= '>')
	if(program(i) == '<')
		program(i) = symbs(mod(round(rand()*100), 3) + 1);
		i = 0;
	end
	i = i + 1;
end
corrected = program;
end
