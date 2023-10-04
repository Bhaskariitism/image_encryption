function image = n_dnaDecode(dna, rule)
bit = 8;
[row, col] = size(rule);
col = col*2/bit;
image = uint16(zeros(row, col));
for x = 1:row
    count = 1;
    for y = 1:col
        for z = 1:bit/2
            ch = dna(x,count);
            image(x,y) = image(x,y)*4+bp2quad(ch, rule(x,count));
            count = count+1;
        end
    end
end
if bit==8
    image = uint8(image);
end