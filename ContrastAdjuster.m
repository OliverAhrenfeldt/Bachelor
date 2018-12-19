classdef ContrastAdjuster
    %ContrastAdjuster This class handles the contrast adjustments made on
    %an image
    %   It contains functions for two different types of contrast
    %   adjustment: Gamma correction and histogram equalization.
    methods
        function outputFrame = GammaCorrect(obj,gamma,frame)
            %GammeCorrect This function performs gamma correction
            %   The function outputs a gamma corrected image. It is
            %   provided with a gamma factor and an image.
            outputFrame = frame.^gamma;
        end        
        
        function outputFrame = HistogramEqualize(obj,frame)
            %HistogramEqualize This function performs histogram
            %equalization
            %   The function outputs a histogram equalized image. It is
            %   provided with an image to perform the operation on.
            outputFrame = histeq(frame); 
        end
    end
end

