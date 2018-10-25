classdef DataAccessor
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = untitled2(inputArg1,inputArg2)
            %UNTITLED2 Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputFrame = Dicomread(obj,path)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputFrame = dicomread(fullfile(path.folder, path.name));
        end
        
        function outputDicomInfo = Dicominfo(obj,path)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputDicomInfo = dicominfo(fullfile(path.folder, path.name));
        end
        
    end
end

