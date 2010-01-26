function sanity = issaneprog(program)
openers = strfind(program, '[');
closers = strfind(program, ']');
sanity = 1;
if(numel(openers) ~= numel(closers))
	sanity = 0;
	return;
end
wantedbrackets = 0;
for i = 1:numel(program)
	if(program(i) == '[')
		wantedbrackets = wantedbrackets + 1;
	elseif(program(i) == ']')
		if(wantedbrackets > 0)
			wantedbrackets = wantedbrackets - 1;
		else
			sanity = 0;
			return;
		end
	end
end
if(wantedbrackets > 0)
	sanity = 0;
	return;
end

end
