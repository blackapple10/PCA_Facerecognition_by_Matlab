% 加载AT&T人脸数据库（40个人，每人10张照片，共400张照片）
close all;
clear;
clc;
faces = imageSet('your_file_dictionary', 'recursive');

% 读取图像数据并将图像矩阵转换为一维向量
numImages = numel(faces);
imageSize = [112, 92]; % 图像尺寸
X = zeros(prod(imageSize), numImages);

for i = 1:numImages
    img = read(faces(i), 4);
    X(:, i) = img(:);
end

% 使用PCA进行降维
numComponents = 100; % 选择前50个主成分
[coeff, score, ~, ~, explained] = pca(X', 'NumComponents', numComponents);
%应用matlab自带计算函数pca（），coeff代表原始图像的线性组合关系，score代表投影
%后的数据，explained代表每个主成分解释的原始数据的方差比
%X要求转置，因为pca函数要求每列代表一个特征。

% 选择一个测试图像（第1个人的第1张照片）
testImage = read(faces(2), 1);
testImageVector = testImage(:);

% 将测试图像投影到PCA空间中
testImageProjected = coeff' * double(testImageVector);

% 计算所有训练图像到测试图像的投影距离
for i=1:numImages
    distance = sqrt(sum((score(i)' - testImageProjected').^2, 2));
    list(i)=distance;
end

% 找到距离最小的训练图像，识别为该人的身份
[~, recognizedPerson] = min(list);

% 显示原始测试图像和识别结果
subplot(1, 2, 1);
imshow(testImage);
title('测试图像');

subplot(1, 2, 2);
imshow(read(faces(recognizedPerson), 1));
title(['识别为第', num2str(recognizedPerson), '个人']);
