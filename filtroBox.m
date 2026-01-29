%-------- FUNCIÓN FILTRO BOX --------

function imgs = filtroBox(img)

    [Filas, Columnas] = size(img);
    imgs = zeros(Filas, Columnas);
    filtro = [0,0,0,0,0; 0,1,1,1,0; 0,1,1,1,0; 0,1,1,1,0; 0,0,0,0,0]/9;
    
    for rxp = 3:Filas - 2
        for ryp = 3:Columnas - 2
            vec = double(img(rxp-2:rxp+2, ryp-2:ryp+2));
            nValor = sum(sum(vec .* filtro));
            imgs(rxp, ryp) = nValor;
        end    
    end
        
    imgs(1, :) = 0;
    imgs(Filas, :) = 0;
    imgs(:, 1) = 0;
    imgs(:, Columnas) = 0;
    imgs = uint8(imgs);
end
