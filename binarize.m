%-------- FUNCIÓN DE BINARIZACIÓN --------

function im_bin = binarize(imgG)
    [r, c] = size(imgG);

    im_bin = zeros(r, c);

    for i = 1 : r
        for j = 1 : c

            %imags(i,j) = imgG(i,j,1) * 0.2989 + imgG(i,j,2) * 0.5870 + imgG(i,j,3) * 0.1141;
            if imgG(i,j) < 128
                im_bin(i, j) = 0;
            else
                im_bin(i, j) = 1;
            end;
        end;
    end;
    
end