%-------- FUNCIÓN DE ESCALA DE GRISES --------

function imags = escGrises(img)

% ESCALA DE GRISES
[r, c, z] = size(img);

img = double(img);
    for i = 1 : r
        for j = 1 : c
            imags(i,j) = img(i,j,1) * 0.2989 + img(i,j,2) * 0.5870 + img(i,j,3) * 0.1141;
        end;
     end;

    imags = uint8(imags);
end