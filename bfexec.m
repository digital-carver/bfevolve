function errstatus = bfexec(program, recurscall)
global bfcells
persistent curpos
NUMCELLS = 32768;

persistent errors
if(isempty(errors))
	errors = struct('BRAC_MATCH_ERR', 128, 'NEG_CELL_INDEX_ERR', 1, 'CELL_INDEX_OVERFLOW_ERR', 256, 'INF_LOOP_ERR', 255); 
end

openers = strfind(program, '[');
closers = strfind(program, ']');
if(numel(openers) ~= numel(closers))
    warning('Number of opening and closing brackets do not match');
    errstatus = errors.BRAC_MATCH_ERR;
    return;
end

if(nargin == 1)
    curpos = 1;
    bfcells = zeros(1, NUMCELLS);    
end

errstatus = 0;
i = 1;
while(i <= numel(program))
    if(program(i) == '+')
        bfcells(curpos) = bfcells(curpos) + 1;
    elseif(program(i) == '-')
        bfcells(curpos) = bfcells(curpos) - 1;
    elseif(program(i) == '.')
        disp(bfcells(curpos));
    elseif(program(i) == ',')
       bfcells(curpos) = input('') + 48;
    elseif(program(i) == '<')
        if(curpos == 1)
            warning('Tried move before 0th cell at byte %d of (sub)program %s (character %c).', i, program, program(i));
            errstatus = errors.NEG_CELL_INDEX_ERR;
            return;
        end
        curpos = curpos - 1;
    elseif(program(i) == '>')
        if(curpos == NUMCELLS)
            warning('Tried to move beyond end of cells');
            errstatus = errors.CELL_INDEX_OVERFLOW_ERR; 
            return;
        end
        curpos = curpos + 1;
    elseif(program(i) == '[')
        wantedbrackets = 1;
        for j = i+1:numel(program)
            if(program(j) == '[')
                wantedbrackets = wantedbrackets + 1;
            elseif(program(j) == ']')
                wantedbrackets = wantedbrackets - 1;
                if(wantedbrackets == 0)
                    break;
                end
            end
        end
        loopend = j;
        if(wantedbrackets ~= 0)
            warning('Loop brackets mismatch. Detected at byte %d.', i);
            errstatus = errors.BRAC_MATCH_ERR;
            return;
        end        
        while(bfcells(curpos) ~= 0)
            loopcode = program(i+1:loopend - 1);
            oldval = bfcells(curpos);
            e = bfexec(loopcode, 'recurscall');
            newval = bfcells(curpos);
            if(abs(newval) >= abs(oldval))
                warning('Infinite loop detected at byte %d', i); 
                errstatus = errors.INF_LOOP_ERR;
                return;
            end
            if(e)
                errstatus = e;
                return;
            end
        end
        i = loopend;
    end
    i = i + 1;
end

end
