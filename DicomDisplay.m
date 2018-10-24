classdef DicomDisplay
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dicom_files;
        reader;
    end
    
    methods
        function obj = Constructor(obj)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.reader = Reader;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
        
        function ReadDicomFiles(obj, path)
            
            
        end
    end
end

