function op = optimize(program)

changed = 0;
persistent wastes;
wastes = ['<>'; '><'; '+-'; '-+'];
starts = [];

for i = 1:size(wastes, 1)
	starts = [starts strfind(program, wastes(i, :))];
end
starts = [starts starts+1];
starts = sort(starts);

if(numel(starts))
	program(starts) = [];
	changed = 1;
end

i = 1;
while i < numel(program)
	if(program(i) == '[')
		looplen = isemptyloop(program, i);
		if(looplen)
			program = [program(1:i-1) program(i+looplen:end)];
			changed = 1;
			continue;
		end
	end
	i = i + 1;
end
if(changed)
	program = optimize(program);	%wastes may have occurred after things were removed
end
op = program;
end
