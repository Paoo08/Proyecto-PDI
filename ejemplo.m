% ==============================
% Contador y Clasificador de Monedas
% ==============================

% 1) Leer imagen
I = imread('img.jpeg');  % Cambia el nombre según tu imagen
figure, imshow(I), title('Imagen Original');

% 2) Escala de grises
Igray = rgb2gray(I);
figure, imshow(Igray), title('Escala de grises');

% 3) Ajustar contraste
Icontrast = imadjust(Igray);
figure, imshow(Icontrast), title('Contraste ajustado');

% 4) Mostrar histogramas
figure;
subplot(1,2,1), imhist(Igray), title('Histograma Original');
subplot(1,2,2), imhist(Icontrast), title('Histograma Ajustado');

% 5) Filtrado: Box o Gaussiano
h = fspecial('gaussian', [5 5], 2); % filtro Gaussiano
Ifilt = imfilter(Icontrast, h, 'replicate');

% Filtrado mediana para eliminar ruido
Ifilt = medfilt2(Ifilt);
figure, imshow(Ifilt), title('Filtrado');

% 6) Binarización
BW = imbinarize(Ifilt);
BW = imcomplement(BW); % Invertir: monedas blancas, fondo negro
figure, imshow(BW), title('Imagen Binaria');

% 7) Morfología para limpiar
BW = imopen(BW, strel('disk',3)); % Elimina objetos pequeños
BW = imclose(BW, strel('disk',5)); % Rellena huecos

figure, imshow(BW), title('Después de Morfología');

% 8) Etiquetar objetos
[L, num] = bwlabel(BW);
stats = regionprops(L, 'Area', 'Centroid');

% 9) Clasificar según área
areas = [stats.Area];
% Umbrales de ejemplo: ajusta según tu imagen!
T1 = 1000; % límite para pequeña
T2 = 3000; % límite para mediana

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

% 10) Mostrar resultado
figure, imshow(I), title('Monedas clasificadas');
hold on;
for k = 1:num
    c = stats(k).Centroid;
    text(c(1), c(2), sprintf('%d: %s', k, clases{k}), ...
        'Color', 'red', 'FontSize', 12, 'FontWeight', 'bold');
end
hold off;

% Mostrar tabla resumen
fprintf('=== Resumen ===\n');
fprintf('Total: %d monedas\n', num);
fprintf('Pequeñas: %d\n', sum(strcmp(clases,'Pequeña')));
fprintf('Medianas: %d\n', sum(strcmp(clases,'Mediana')));
fprintf('Grandes: %d\n', sum(strcmp(clases,'Grande')));
