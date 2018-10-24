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
        
        function DICOM_files = ReadDicomFiles(obj,paths)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            %Præallokering for effektivitet
            DICOM_files = repmat(DICOM_File_DTO(),1,length(paths));
            wbar = waitbar(0, 'Reading images');
            for i = 1: length(paths)
                d = DICOM_File_DTO;
                d.pixelData = obj.dataAccessor.Dicomread(paths{i});
                d.dicomInfo = obj.dataAccessor.Dicominfo(paths{i});
                DICOM_files(i) = d;
                
                waitbar(i/length(paths),wbar);
            end
        end
        
        function SortedDicomFiles = SortDicomFiles(obj,DICOMFiles)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
            
        end
    end
end

