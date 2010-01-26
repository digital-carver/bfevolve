function result = isemptyloop(program, loopstart)
wantedbrackets = 1;
result = 1;
if(program(loopstart + 1) == ']')
	result = 2;
	return;
end
plen = numel(program);
for j = loopstart+1:plen
	if(program(j) ~= '[' && program(j) ~= ']')
		result = 0;
		return;
	elseif(program(j) == '[')
		wantedbrackets = wantedbrackets + 1;
	elseif(program(j) == ']')
		wantedbrackets = wantedbrackets - 1;
		if(wantedbrackets == 0)
			result = j - loopstart + 1;
			break;
		end
	end
end
end
