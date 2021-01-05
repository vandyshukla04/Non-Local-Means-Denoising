%similar to nonLocalMeans.m in all capacity except runs on grayscale images
function [result] = nonLocalMeans(image, sigma, h, patchSize, windowSize)

result = image;
[size_r size_c]=size(result);

patch_f=floor(patchSize/2);
window_f=floor(windowSize/2);
patch=patchSize*patchSize;

for row=patch_f+1:size_r-patch_f
    
    sr=row-window_f;%starting row
    er=row+window_f;%ending row
    
    if (row <= window_f+patch_f)%here an additional check is added so that the code runs smoothly for all patch sizes
        sr=1+patch_f;%shift the starting index by half of the patch size
    elseif(row >= (size_r-window_f-patch_f+1))
        er=size_r-patch_f;%shift the ending index by half the patch size
    end
    
    for col=patch_f+1:size_c-patch_f
        
        sc=col-window_f;%start column
        ec=col+window_f;%end column
        
        if(col <= window_f+patch_f)
            sc=1+patch_f;%shift the starting index by half of the patch size
        elseif(col >= (size_c-window_f-patch_f+1))
            ec=size_c-patch_f;%shift the ending index by half the patch size
        end
        
        %main patch against which we will implement non-local means
        og_patch=double(result(row-patch_f:row+patch_f,col-patch_f:col+patch_f));
        
        Summation_W=0;
        %Summation_W is used here for "stacking" the patches with their
        %weights attached (multiplied)
        Normalising_Factor=0;
        %we use this in the end to normalise. It is basically the sum of
        %individual weights.
        
        for i=sr:er
            for j=sc:ec
                
                comp_patch = double(result(i-patch_f:i+patch_f,j-patch_f:j+patch_f));
        
                diff = ((double(og_patch)-double(comp_patch)).^2);
                ssd = sum(sum(diff))/patch;
                
                weight = computeWeighting(ssd, h, sigma, patchSize);
                
                Summation_W = Summation_W+(weight*(comp_patch(patch_f+1,patch_f+1)));
                
                Normalising_Factor = Normalising_Factor + weight;
            end
        end
                

    result(row,col) = uint8(Summation_W/Normalising_Factor);%new value of center pixel

    end
end

end