classdef DICOM_File_DTO
    %DICOM_File_DTO This class is a data transfer object
    %   It is used to combine the pixeldata and metadata of a loaded
    %   dicom-file. It enables easy access to both, in a single object 
    %   accross the application.
    
    properties
        pixelData;
        dicomInfo;
    end
end

