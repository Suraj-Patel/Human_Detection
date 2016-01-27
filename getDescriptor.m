% Name   : Suraj K. Patel
% Net ID : skp392
% N#     : N16678451

%________________________________________________________________________________________________________________________

%Function to get a decriptor of input image 
function image_desc = getDescriptor(filename)
    %Reading the input image
    image = imread(filename);
    image = imcrop(image,[17 17 63 127]);
    image = double(image);
    %image = image(17:144, 17:80);

    %Initialising the template/mask
    %The same mask will be used vertically as well as horizontally
    template = [-1, 0, 1];

    %Convert given color image to grayscale
    red = image(:, :, 1);
    green = image(:, :, 2);
    blue = image(:, :, 3);

    image = 0.21*red + 0.72*green + 0.07*blue; 
    %imshow(image);

    %Getting the size of image
    [r,c] = size(image);

    Ir = zeros(r,c);            %Vertical gradient
    Ic = zeros(r,c);            %Horizontal gradient
    angle = zeros(r,c);         %Gradient angle
    magnitude = zeros(r,c);     %Magnitude
    angle(1:r,1:c) = 0/0;

    %Applying the template and computing Ic and Ir

    for i = 2:r-1
        for j = 2:c-1
            Ir(i,j) = image(i-1,j)*template(1) + image(i,j)*template(2) + image(i+1,j)*template(3);
            Ic(i,j) = image(i,j-1)*template(1) + image(i,j)*template(2) + image(i,j+1)*template(3);
%            angle(i,j) = Ir(i,j)/Ic(i,j);

            if Ir(i,j) == 0 && Ic(i,j) == 0
                magnitude(i,j) = 0;
            else
                magnitude(i,j) = Ir(i,j)*Ir(i,j) + Ic(i,j)*Ic(i,j);
            end
        end
    end

    angle = atan2d(Ir,Ic);
    angle = -angle;
    magnitude = sqrt(magnitude)/sqrt(2);
    magnitude = round(magnitude);
    %magnitude = uint8(magnitude);
    %Displaying the original image and the normalised edge magnitude image

    cell_hist = zeros(16,8,9);

    bin = [0 0 0 0 0 0 0 0 0];

    %Quantizing the gradient angles into values (1-9).
    for m = 1:r/8
        for n = 1:c/8
            for p = 1:8
                for q = 1:8

                    i = (m-1)*8 + p;
                    j = (n-1)*8 + q;

                    if( angle(i,j) < 0)
                        angle(i,j) = 360 + angle(i,j);
                    end

                    if (angle(i,j) >= 10 && angle(i,j) < 30)
                        
                        bin(1) = 1 - (abs(angle(i,j) - 10)/20);
                        bin(1) = magnitude(i,j)*bin(1);
                        cell_hist(m,n,1) = cell_hist(m,n,1) + bin(1);

                        bin(2) = 1 - (abs(angle(i,j) - 30)/20);
                        bin(2) = magnitude(i,j)*bin(2);
                        cell_hist(m,n,2) = cell_hist(m,n,2) + bin(2);
                        
                    elseif (angle(i,j) >= 190 && angle(i,j) < 210)

                        bin(1) = 1 - (abs(angle(i,j) - 190)/20);
                        bin(1) = magnitude(i,j)*bin(1);
                        cell_hist(m,n,1) = cell_hist(m,n,1) + bin(1);

                        bin(2) = 1 - (abs(angle(i,j) - 210)/20);
                        bin(2) = magnitude(i,j)*bin(2);
                        cell_hist(m,n,2) = cell_hist(m,n,2) + bin(2);

                    elseif (angle(i,j) >= 30 && angle(i,j) < 50)
                        bin(3) = 1 - (abs(angle(i,j) - 50)/20);
                        bin(3) = magnitude(i,j)*bin(3);
                        cell_hist(m,n,3) = cell_hist(m,n,3) + bin(3);

                        bin(2) = 1 - (abs(angle(i,j) - 30)/20);
                        bin(2) = magnitude(i,j)*bin(2);
                        cell_hist(m,n,2) = cell_hist(m,n,2) + bin(2);
                        
                    elseif (angle(i,j) >= 210 && angle(i,j) < 230)
                        bin(3) = 1 - (abs(angle(i,j) - 230)/20);
                        bin(3) = magnitude(i,j)*bin(3);
                        cell_hist(m,n,3) = cell_hist(m,n,3) + bin(3);

                        bin(2) = 1 - (abs(angle(i,j) - 210)/20);
                        bin(2) = magnitude(i,j)*bin(2);
                        cell_hist(m,n,2) = cell_hist(m,n,2) + bin(2);    

                    elseif (angle(i,j) >= 50 && angle(i,j) < 70)
                        bin(3) = 1 - (abs(angle(i,j) - 50)/20);
                        bin(3) = magnitude(i,j)*bin(3);
                        cell_hist(m,n,3) = cell_hist(m,n,3) + bin(3);

                        bin(4) = 1 - (abs(angle(i,j) - 70)/20);
                        bin(4) = magnitude(i,j)*bin(4);
                        cell_hist(m,n,4) = cell_hist(m,n,4) + bin(4);

                    elseif (angle(i,j) >= 230 && angle(i,j) < 250)
                        bin(3) = 1 - (abs(angle(i,j) - 230)/20);
                        bin(3) = magnitude(i,j)*bin(3);
                        cell_hist(m,n,3) = cell_hist(m,n,3) + bin(3);

                        bin(4) = 1 - (abs(angle(i,j) - 250)/20);
                        bin(4) = magnitude(i,j)*bin(4);
                        cell_hist(m,n,4) = cell_hist(m,n,4) + bin(4);                        
                        
                    elseif (angle(i,j) >= 70 && angle(i,j) < 90)
                        bin(5) = 1 - (abs(angle(i,j) - 90)/20);
                        bin(5) = magnitude(i,j)*bin(5);
                        cell_hist(m,n,5) = cell_hist(m,n,5) + bin(5);

                        bin(4) = 1 - (abs(angle(i,j) - 70)/20);
                        bin(4) = magnitude(i,j)*bin(4);
                        cell_hist(m,n,4) = cell_hist(m,n,4) + bin(4);

                    elseif (angle(i,j) >= 250 && angle(i,j) < 270)
                        bin(5) = 1 - (abs(angle(i,j) - 270)/20);
                        bin(5) = magnitude(i,j)*bin(5);
                        cell_hist(m,n,5) = cell_hist(m,n,5) + bin(5);

                        bin(4) = 1 - (abs(angle(i,j) - 250)/20);
                        bin(4) = magnitude(i,j)*bin(4);
                        cell_hist(m,n,4) = cell_hist(m,n,4) + bin(4);
                        
                    elseif (angle(i,j) >= 90 && angle(i,j) < 110)
                        bin(5) = 1 - (abs(angle(i,j) - 90)/20);
                        bin(5) = magnitude(i,j)*bin(5);
                        cell_hist(m,n,5) = cell_hist(m,n,5) + bin(5);

                        bin(6) = 1 - (abs(angle(i,j) - 110)/20);
                        bin(6) = magnitude(i,j)*bin(6);
                        cell_hist(m,n,6) = cell_hist(m,n,6) + bin(6);

                    elseif (angle(i,j) >= 270 && angle(i,j) < 290)
                        bin(5) = 1 - (abs(angle(i,j) - 270)/20);
                        bin(5) = magnitude(i,j)*bin(5);
                        cell_hist(m,n,5) = cell_hist(m,n,5) + bin(5);

                        bin(6) = 1 - (abs(angle(i,j) - 290)/20);
                        bin(6) = magnitude(i,j)*bin(6);
                        cell_hist(m,n,6) = cell_hist(m,n,6) + bin(6);
                        
                    elseif (angle(i,j) >= 110 && angle(i,j) < 130)
                        bin(7) = 1 - (abs(angle(i,j) - 130)/20);
                        bin(7) = magnitude(i,j)*bin(7);
                        cell_hist(m,n,7) = cell_hist(m,n,7) + bin(7);

                        bin(6) = 1 - (abs(angle(i,j) - 110)/20);
                        bin(6) = magnitude(i,j)*bin(6);
                        cell_hist(m,n,6) = cell_hist(m,n,6) + bin(6);

                    elseif (angle(i,j) >= 290 && angle(i,j) < 310)
                        bin(7) = 1 - (abs(angle(i,j) - 310)/20);
                        bin(7) = magnitude(i,j)*bin(7);
                        cell_hist(m,n,7) = cell_hist(m,n,7) + bin(7);

                        bin(6) = 1 - (abs(angle(i,j) - 290)/20);
                        bin(6) = magnitude(i,j)*bin(6);
                        cell_hist(m,n,6) = cell_hist(m,n,6) + bin(6);

                    elseif (angle(i,j) >= 130 && angle(i,j) < 150)
                        bin(7) = 1 - (abs(angle(i,j) - 130)/20);
                        bin(7) = magnitude(i,j)*bin(7);
                        cell_hist(m,n,7) = cell_hist(m,n,7) + bin(7);

                        bin(8) = 1 - (abs(angle(i,j) - 150)/20);
                        bin(8) = magnitude(i,j)*bin(8);
                        cell_hist(m,n,8) = cell_hist(m,n,8) + bin(8);

                    elseif (angle(i,j) >= 310 && angle(i,j) < 330)
                        bin(7) = 1 - (abs(angle(i,j) - 310)/20);
                        bin(7) = magnitude(i,j)*bin(7);
                        cell_hist(m,n,7) = cell_hist(m,n,7) + bin(7);

                        bin(8) = 1 - (abs(angle(i,j) - 330)/20);
                        bin(8) = magnitude(i,j)*bin(8);
                        cell_hist(m,n,8) = cell_hist(m,n,8) + bin(8);


                    elseif (angle(i,j) >= 150 && angle(i,j) < 170)
                        bin(9) = 1 - (abs(angle(i,j) - 170)/20);
                        bin(9) = magnitude(i,j)*bin(9);
                        cell_hist(m,n,9) = cell_hist(m,n,9) + bin(9);

                        bin(8) = 1 - (abs(angle(i,j) - 150)/20);
                        bin(8) = magnitude(i,j)*bin(8);
                        cell_hist(m,n,8) = cell_hist(m,n,8) + bin(8);

                    elseif (angle(i,j) >= 330 && angle(i,j) < 350)
                        bin(9) = 1 - (abs(angle(i,j) - 350)/20);
                        bin(9) = magnitude(i,j)*bin(9);
                        cell_hist(m,n,9) = cell_hist(m,n,9) + bin(9);

                        bin(8) = 1 - (abs(angle(i,j) - 330)/20);
                        bin(8) = magnitude(i,j)*bin(8);
                        cell_hist(m,n,8) = cell_hist(m,n,8) + bin(8);
                        
                    elseif (angle(i,j) >= 170 && angle(i,j) < 190)
                        bin(9) = 1 - (abs(angle(i,j) - 170)/20);
                        bin(9) = magnitude(i,j)*bin(9);
                        cell_hist(m,n,9) = cell_hist(m,n,9) + bin(9);

                        bin(1) = 1 - (abs(angle(i,j) - 190)/20);
                        bin(1) = magnitude(i,j)*bin(1);
                        cell_hist(m,n,1) = cell_hist(m,n,1) + bin(1);

                    elseif (angle(i,j) >= 350 && angle(i,j)<360)
                        
                        bin(9) = 1 - (abs(angle(i,j) - 350)/20);
                        bin(9) = magnitude(i,j)*bin(9);
                        cell_hist(m,n,9) = cell_hist(m,n,9) + bin(9);

                        bin(1) = 1 - ((abs(angle(i,j) - 360)+10)/20);
                        bin(1) = magnitude(i,j)*bin(1);
                        cell_hist(m,n,1) = cell_hist(m,n,1) + bin(1);
                    
                    elseif (angle(i,j) >= 0 && angle(i,j) < 10)     
                        bin(9) = 1 - ((abs(angle(i,j) - 0)+10)/20);
                        bin(9) = magnitude(i,j)*bin(9);
                        cell_hist(m,n,9) = cell_hist(m,n,9) + bin(9);

                        bin(1) = 1 - (abs(angle(i,j) - 10)/20);
                        bin(1) = magnitude(i,j)*bin(1);
                        cell_hist(m,n,1) = cell_hist(m,n,1) + bin(1);
                    end         
                end
            end
        end
    end

    desc = zeros(105,36);
    %Compute descriptor of the image from the histograms of each cell and
    %adding the histograms of corresponding cells of all the blocks and
    %normalizing using L2-norm.
    for i= 1:15
        for j= 1:7
            desc((i-1)*7+j, 1:9) = cell_hist(i,j,1:9);
            desc((i-1)*7+j, 10:18) = cell_hist(i,j+1,1:9);
            desc((i-1)*7+j, 19:27) = cell_hist(i+1,j,1:9);
            desc((i-1)*7+j, 28:36) = cell_hist(i+1,j+1,1:9);           
        
            l2_norm = 0;
            for k=1:36
                l2_norm = l2_norm + desc((i-1)*7+j,k)*desc((i-1)*7+j,k); 
            end
            l2_norm = sqrt(l2_norm);
            if(l2_norm == 0)
                desc((i-1)*7+j,1:36) = 0;
            else
                desc((i-1)*7+j,1:36) = desc((i-1)*7+j,1:36)/l2_norm;
            end
        end
    end
    image_desc = zeros(3780,1);
    for i=1:105
        a = (i-1)*36 + 1;
        image_desc(a:a+35,1) = desc(i,1:36);
    end
end
