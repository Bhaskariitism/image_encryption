function dna = n_dnaEncode(image, rule)
bits = 8;
[row,col] = size(image);
for x = 1:row
    count =1;
    for y = 1:col
        b = de2bi(image(x,y),bits);
        for z = bits/2:-1:1
            val = b(1,2*z)*2+b(1,2*z-1);
            dna(x,count)= quad2bp(val, rule(x,count));
            count = count+1;
        end
    end
end