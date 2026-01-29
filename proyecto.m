clear all;
clc;

img =imread('img.jpg');
figure(1);
imshow(img);
title('IMAGEN ORIGINAL');

imgGray = escGrises(img);
figure(2);
imshow(imgGray);
title('IMAGEN ESCALA DE GRISES');

% DIMENSIONES
[filas, columnas] = size(imgGray);
pixeles = 256;

% HISTOGRAMA NORMAL  
tamano = zeros(1, pixeles);
for i = 1 : filas
    for j = 1 : columnas
        intensidad = imgGray(i, j);
        tamano(intensidad + 1) = tamano(intensidad + 1) + 1;
    end
end

% HISTOGRAMA ACUMULADO
histograma = zeros(1, pixeles);
acumulador = 0;
for k = 1 : pixeles
    acumulador = acumulador + tamano(k);
    histograma(k) = acumulador;
end

% TRANSFORMACIÓN DE INTENSIDADES NORMALIZADA
nueva_int = histograma / (filas * columnas) * (pixeles - 1);

% CONTRASTE AJUSTADO 
Icontrast = zeros(filas, columnas, 'uint8');
for i = 1 : filas
    for j = 1 : columnas
        intensidad = imgGray(i, j) + 1;
        Icontrast(i, j) = uint8(nueva_int(intensidad));
    end
end

% HISTOGRAMA DE LA IMAGEN ECUALIZADA 
tamanoQ = zeros(1, pixeles);
for i = 1:filas
    for j = 1:columnas
        intensidad = Icontrast(i, j);
        tamanoQ(intensidad + 1) = tamanoQ(intensidad + 1) + 1;
    end
end

% RESULTADOS
figure(3);
stem(tamano, 'Marker', 'none');
title('HISTOGRAMA NORMAL');
xlabel('Intensidad');
ylabel('Frecuencia');

figure(4);
stem(histograma, 'Marker', 'none');
title('HISTOGRAMA ACUMULADO');
xlabel('Intensidad');
ylabel('Frecuencia Acumulada');

figure(5);
imshow(Icontrast);
title('IMAGEN CON CONTRASTE AJUSTADO (ECUALIZADA)');

figure(6);
stem(tamanoQ, 'Marker', 'none');
title('HISTOGRAMA ECUALIZADO');
xlabel('Intensidad'), ylabel('Frecuencia');

%-------- APLICAR FILTRO BOX --------
imgFiltrada = filtroBox(Icontrast);
figure(7);
imshow(imgFiltrada);
title('IMAGEN FILTRADA - BOX');

imgMediana = Mediana(imgFiltrada);
figure(8);
imshow(imgMediana);
title('IMAGEN FILTRADA - MEDIANA');

BW = logical(binarize(imgMediana));
BW = imcomplement(BW); % MONEDAS BLANCAS Y FONDO NEGRO 

figure(9);
imshow(BW);
title('IMAGEN BINARIA');

BW = imopen(BW, strel('disk',3)); % ELIMINAR OBJETOD PEQUEÑOS 
BW = imclose(BW, strel('disk',5)); % RELLENAR HUECOS 

figure(10);
imshow(BW);
title('IMAGEN DESPUÉS DE MORFOLOGÍA');

% WATERSHED
D = -bwdist(~BW);
mask = imextendedmin(D, 2);
D2 = imimposemin(D, mask);
Lw = watershed(D2);
BW(Lw == 0) = 0;

figure(11);
imshow(BW);
title('IMAGEN CON WATERSHED APLICADO');

% ELIMINAR RUIDO (FRAGMENTOS DEMASIADO PEQUEÑOS)
BW = bwareaopen(BW, 5000);

% ETIQUETAR DE NUEVO SOLO LOS OBJETOS VALIDOS
[L, num] = bwlabel(BW);
stats = regionprops(L, 'Area', 'Centroid');

% CLASIFICAR SEGÚN EL ÁREA 
areas = [stats.Area];
disp('Áreas detectadas después de filtrar:');
disp(areas'); 

T1 = 8000;   % PEQUEÑA
T2 = 20000;  % MEDIANA

clases = cell(num,1);
for k = 1:num
    if areas(k) < T1
        clases{k} = 'Pequeña';
    elseif areas(k) < T2
        clases{k} = 'Mediana';
    else
        clases{k} = 'Grande';
    end
end

% RESULTADO FINAL
figure(12);
imshow(img);
title('MONEDAS CLASIFICADAS');

hold on;
for k = 1:num
    c = stats(k).Centroid;
    text(c(1), c(2), sprintf('%d: %s', k, clases{k}), ...
        'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold');
end
hold off;

% TABLA DE RESUMEN
fprintf('=== Resumen ===\n');
fprintf('Total: %d monedas\n', num);
fprintf('Pequeñas: %d\n', sum(strcmp(clases,'Pequeña')));
fprintf('Medianas: %d\n', sum(strcmp(clases,'Mediana')));
fprintf('Grandes: %d\n', sum(strcmp(clases,'Grande')));
