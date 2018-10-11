classdef ContrastAdjuster
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = untitled(inputArg1,inputArg2)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputFrame = GammaCorrect(obj,gamma,frame)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputFrame = frame.^gamma;
        end
        
        function outputFrame = HistogramEqualize(obj,frame)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputFrame = histeq(frame); 
        end
        
    end
end

