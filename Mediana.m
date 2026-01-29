%-------- FUNCIÓN FILTRO MEDIANA --------

function OutMediana = Mediana(img)

    [Filas, Columnas] = size(img);
    OutMediana = zeros(Filas, Columnas, 'uint8');

    for rxp = 3:Filas - 2
        for ryp = 3:Columnas - 2
            vec = img(rxp-2:rxp+2, ryp-2:ryp+2);
            vector = vec(:);
            vectorOrd = sort(vector);
            valMediana = vectorOrd(5);
            OutMediana(rxp, ryp) = valMediana;
        end
    end
end