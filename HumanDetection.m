% Name   : Suraj K. Patel
% Net ID : skp392
% N#     : N16678451

%________________________________________________________________________________________________________________________

%Call the getDescriptor function for getting descriptors of different input images
%First we take poitive images from training set
positive_desc_mean = zeros(3780,1);
positive_image_desc = zeros(3780,10);

positive_images = dir('./training/positive');
filePos1 = fopen('crop001030c.txt', 'w');
filePos2 = fopen('crop001034b.txt', 'w');
filePosMean = fopen('PositiveMean.txt','w');
for i = 3:12
    file = strcat('./training/positive/', positive_images(i).name);
    positive_image_desc(:,i-2) = getDescriptor(file);
    if strcmp(positive_images(i).name, 'crop001030c.bmp') == 1
        for j = 1:36:3780            
            fprintf(filePos1, '%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n', positive_image_desc(j:j+35,i-2)); 
        end
    end
    
    if strcmp(positive_images(i).name, 'crop001034b.bmp') == 1
        for j = 1:36:3780            
            fprintf(filePos2, '%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n', positive_image_desc(j:j+35,i-2)); 
        end
    end
    positive_desc_mean = positive_desc_mean + positive_image_desc(:,i-2)/10;
    
    for j=1:36:3780
       fprintf(filePosMean, '%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n', positive_desc_mean(j:j+35, 1)); 
    end
end

fclose(filePos1);
fclose(filePos2);
fclose(filePosMean);

%Take negative images from training set
negative_desc_mean = zeros(3780,1);
negative_image_desc = zeros(3780,10);
negative_images = dir('./training/negative');
fileNeg1 = fopen('00000003a_cut.txt', 'w');
fileNeg2 = fopen('00000057a_cut.txt', 'w');
fileNegMean = fopen('Negative Mean.txt','w');
for i = 3:12
    file = strcat('./training/negative/', negative_images(i).name);
    negative_image_desc(:,i-2) = getDescriptor(file);
    if strcmp(negative_images(i).name, '00000003a_cut.bmp') == 1
        for j = 1:36:3780
            fprintf(fileNeg1, '%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n', negative_image_desc(j:j+35,i-2)); 
        end
    end
    
    if strcmp(negative_images(i).name, '00000057a_cut.bmp') == 1
        for j = 1:36:3780            
            fprintf(fileNeg2, '%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n', negative_image_desc(j:j+35,i-2)); 
        end
    end
    negative_desc_mean = negative_desc_mean + negative_image_desc(:,i-2)/10;
    for j=1:36:3780
       fprintf(fileNegMean, '%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n', negative_desc_mean(j:j+35, 1)); 
    end
end 
fclose(fileNeg1);
fclose(fileNeg2);
fclose(fileNegMean);
positive_distances = zeros(10,1);

%Calculate distance of each positive image from the positive image mean
%and negative image from negative image mean.
for i = 1:10
    distance =0;
	for j = 1:3780       
        distance = distance + ((positive_image_desc(j,i) - positive_desc_mean(j,1))*(positive_image_desc(j,i) - positive_desc_mean(j,1)));
    end
    positive_distances(i,1) = sqrt(distance);
    fprintf('Distance of %s from positive mean is %f \n', positive_images(i+2).name, positive_distances(i,1));
end

negative_distances = zeros(10,1);
for i = 1:10
    distance =0;
	for j = 1:3780       
        distance = distance + ((negative_image_desc(j,i) - negative_desc_mean(j,1))*(negative_image_desc(j,i) - negative_desc_mean(j,1)));
    end
    negative_distances(i,1) = sqrt(distance);
    fprintf('Distance of %s from negative mean is %f \n', negative_images(i+2).name, negative_distances(i,1));
end

W = ones(3780,1)
alpha = 0.7
chk_positive = zeros(10,1);
chk_negative = zeros(10,1);
no_of_iterations = 0;

%Adjust value of W according to the two sets(positive and negative) until
%we get no error. Use fixed increment rule. Here we take value of 
% alpha as 0.5 which is fixed.

while 1
    no_of_iterations = no_of_iterations + 1;
    for i = 1:10
        x = positive_image_desc(:,i).'*W;
        if x>0
            chk_positive(i,1) = 1;
        else
            chk_positive(i,1) = 0;
            W = W + alpha*positive_image_desc(:,i);
        end
    end
    for i = 1:10
        y = negative_image_desc(:,i).'*W;
        if y<0
            chk_negative(i,1) = 1;
        else
            chk_negative(i,1) = 0;
            W = W - alpha*negative_image_desc(:,i);
        end
    end
    
    if all(chk_positive == 1) && all(chk_negative == 1)
        break;
    end
end

disp('Order of training samples: ');
for i=3:12
    disp(positive_images(i).name);
end
for i=3:12
    disp(negative_images(i).name);
end
fprintf('No of iterations = %d',no_of_iterations);
positive_images = dir('./testing/positive');

testing_pos = zeros(5,1);
testing_neg = zeros(5,1);
testing_image = zeros(3780,1);
filePos1 = fopen('crop001008b.txt', 'w');

%Take images from testing set and using the value of W classify the images
%whether they are positive or negative.

for i = 3:7
    file = strcat('./testing/positive/', positive_images(i).name);
    testing_image = getDescriptor(file);
    x = testing_image.'*W;
    if(x>0)
        testing_pos(i-2,1) = 1;
    end
    
    if strcmp(positive_images(i).name, 'crop001008b.bmp') == 1
        for j = 1:36:3780            
            fprintf(filePos1, '%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n', testing_image(j:j+35,1)); 
        end
    end
end
fclose(filePos1);

negative_images = dir('./testing/negative');
fileNeg1 = fopen(' 00000053a_cut.txt', 'w');
for i = 3:7
    file = strcat('./testing/negative/', negative_images(i).name);
    testing_image = getDescriptor(file);
    x = testing_image.'*W;
    if(x<0)
        testing_neg(i-2,1) = 1;
    end
    if strcmp(negative_images(i).name, '00000053a_cut.bmp') == 1
        for j = 1:36:3780            
            fprintf(fileNeg1, '%.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f\n', testing_image(j:j+35,1)); 
        end
    end
end
fclose(fileNeg1);