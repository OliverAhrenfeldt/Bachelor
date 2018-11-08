classdef StubDataAccess
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
 
    methods

         function outputFrame = Dicomread(obj,path)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputFrame = dicomread(fullfile(path{1}.folder, path{1}.name));
        end
        
        function outputDicomInfo = Dicominfo(obj,path)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputDicomInfo = dicominfo(fullfile(path{1}.folder, path{1}.name));
        end
    end
end

