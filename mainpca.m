% ����AT&T�������ݿ⣨40���ˣ�ÿ��10����Ƭ����400����Ƭ��
close all;
clear;
clc;
faces = imageSet('E:\matlab_archive\Matlab_DPP\pca\ORL_Faces', 'recursive');

% ��ȡͼ�����ݲ���ͼ�����ת��Ϊһά����
numImages = numel(faces);
imageSize = [112, 92]; % ͼ��ߴ�
X = zeros(prod(imageSize), numImages);

for i = 1:numImages
    img = read(faces(i), 4);
    X(:, i) = img(:);
end

% ʹ��PCA���н�ά
numComponents = 100; % ѡ��ǰ50�����ɷ�
[coeff, score, ~, ~, explained] = pca(X', 'NumComponents', numComponents);

% ѡ��һ������ͼ�񣨵�1���˵ĵ�1����Ƭ��
testImage = read(faces(2), 1);
testImageVector = testImage(:);

% ������ͼ��ͶӰ��PCA�ռ���
testImageProjected = coeff' * double(testImageVector);

% ��������ѵ��ͼ�񵽲���ͼ���ͶӰ����
for i=1:numImages
    distance = sqrt(sum((score(i)' - testImageProjected').^2, 2));
    list(i)=distance;
end

% �ҵ�������С��ѵ��ͼ��ʶ��Ϊ���˵����
[~, recognizedPerson] = min(list);

% ��ʾԭʼ����ͼ���ʶ����
subplot(1, 2, 1);
imshow(testImage);
title('����ͼ��');

subplot(1, 2, 2);
imshow(read(faces(recognizedPerson), 1));
title(['ʶ��Ϊ��', num2str(recognizedPerson), '����']);
