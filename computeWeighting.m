function [result] = computeWeighting(d, h, sigma, patchSize)
    %Implement weighting function from the slides
    %Be careful to normalise/scale correctly!
    result=exp(-(max(d-(2*sigma^2),0)/(h*sigma)^2));
    %REPLACE THIS
    %power = max((d-(2*(sigma)^2)),0);
    %power = power/((h*sigma)^2);
    %result = exp(-power);
    %Here I am not applying normalization as I have already normalised the
    %distances in template matching and am using the formula from slides directly
end