%runs the patchWise implementation of NLM for grayscale images
function [result] = nonLocalMeans(image, sigma, h, patchSize, windowSize)

result = image;
[size_r size_c]=size(result);
patch=patchSize*patchSize;

patch_f=floor(patchSize/2);
window_f=floor(windowSize/2);

for row=patch_f+1:size_r-patch_f
    
    sr=row-window_f;%starting row
    er=row+window_f;%ending row
    
    if (row <= window_f+patch_f)
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
        
        og_patch=double(result(row-patch_f:row+patch_f,col-patch_f:col+patch_f));
        
        Summation_W=zeros(patchSize,patchSize);
        Normalising_Factor=0;
        
        for i=sr:er
            for j=sc:ec
                
                comp_patch = double(result(i-patch_f:i+patch_f,j-patch_f:j+patch_f));
        
                diff = ((double(og_patch)-double(comp_patch)).^2);
                ssd = sum(sum(diff))/patch;
                
                %weight between the patches is calculated in the same way
                %for both pixelwise and patchwise
                weight = computeWeighting(ssd, h, sigma, patchSize);
                
                %the main difference between NLM pixelwise and NLM
                %patchwise comes in this step. We attach the weight to the
                %whole patch with which we are comparing instead of the
                %center pixel of the template
                Summation_W = Summation_W+ weight*(comp_patch);
                
                Normalising_Factor = Normalising_Factor + weight;
            end
        end
                
    %Here we sum over the entire weighted patch and normalize it with the summation of 
    %weights. This estimate is averaged for the center pixel of the main patch with the
    %help of patch size (N^2 in the article)
    result(row,col) = uint8(sum(sum(Summation_W./Normalising_Factor))/patch);

    end
end

end