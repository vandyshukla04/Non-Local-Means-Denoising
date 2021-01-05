function [offsetsRows, offsetsCols, distances] = templateMatchingNaive(row, col,...
    patchSize, searchWindowSize)
% This function should for each possible offset in the search window
% centred at the current row and col, save a value for the offsets and
% patch distances, e.g. for the offset (-1,-1)
% offsetsRows(1) = -1;
% offsetsCols(1) = -1;
% distances(1) = 0.125;

% The distance is simply the SSD over patches of size patchSize between the
% 'template' patch centred at row and col and a patch shifted by the
% current offset


alley=rgb2gray(imread('alleyNoisy_sigma20.png'));
imshow(alley);
[imgRowNo imgColNo]=size(alley);

%we need to check if research window goes beyond the image since it is
%centered at the current pixel
%For that- we will calculate the maximum offset 

max_offset=floor(searchWindowSize/2);

%for iterating through every pixel in the research window, we set the starting and
%end row and column pixels for the window

sr=row-max_offset;%starting row
er=row+max_offset;%ending row
sc=col-max_offset;%start column
ec=col+max_offset;%end column

%there is however one situation we need to test for in case of research
%windows, the research window might extend beyond the image edges and we
%need to test for that

if (row <= max_offset)
    sr=1+floor(patchSize/2);%shift the starting index by half of the patch size
elseif(row >= (imgRowNo-max_offset+1))
    er=imgRowNo-floor(patchSize/2);%shift the ending index by half the patch size
end

if(col <= max_offset)
    sc=1+floor(patchSize/2);%shift the starting index by half of the patch size
elseif(col >= (imgColNo-max_offset+1))
    ec=imgColNo-floor(patchSize/2);%shift the ending index by half the patch size
end

%the patch against which we calculate distances of all the other patches in
%the research window
calc_patch=floor(patchSize/2);
og_patch=alley(row-calc_patch:row+calc_patch,col-calc_patch:col+calc_patch);
%imshow(og_patch);

%suppose we choose a research window of 30*30
res_window=searchWindowSize*searchWindowSize;
offsetsRows=zeros(1,res_window);
offsetsCols=zeros(1,res_window);
%we might not fill up the offsetRows and offsetCols if the research window
%is clipped but that's the max size

%calc_patch=floor(patchSize/2);%for calculating testing patches in research window

distances=zeros(1,res_window);%same as offset
counter=1;
for i=sr:er
    for j=sc:ec
        
        comp_patch = alley(i-calc_patch:i+calc_patch,j-calc_patch:j+calc_patch);
        
        diff = (double(comp_patch)-double(og_patch)).^2;
        ssd = sum(sum(diff));
        
        distances(counter)=ssd;%/(patchSize*patchSize);
        offsetsRows(counter)=-(row-i);
        offsetsCols(counter)=-(col-j);
        
        counter=counter+1;
    end
end


end