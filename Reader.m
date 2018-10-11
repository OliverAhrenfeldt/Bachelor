classdef Reader
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dataAccessor;
    end
    
    methods
        function obj = Constructor(obj)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.dataAccessor = DataAccessor;
        end
        
        function DICOM_files = ReadDicomFiles(paths)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            DICOM_files = zeros(lenght(paths));
            for i = 1: length(paths)
                d = DICOM_File_DTO;
                d.pixelData = dicomread(paths(i));
                d.dicomInfo = dicominfo(paths(i));
                DICOM_files(i) = d;
            end
        end
        
    end
end

