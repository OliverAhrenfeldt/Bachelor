classdef StubReader
    %STUBREADER Summary of this class goes here
    %   Detailed explanation goes here
    
    
    methods        
        function [DICOM_files_Collection dicomLocalizers]= ReadDicomFiles(obj,path)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
%             addpath ../
            
            for i = 1: length(path)
                d = DICOM_File_DTO;
                d.pixelData = dicomread(fullfile(path{i}.folder, path{i}.name));
                d.dicomInfo = dicominfo(fullfile(path{i}.folder, path{i}.name));
                DICOM_files{i} = d;  
            end
            
            DICOM_files{7} = DICOM_files{6};
            DICOM_files{7}.dicomInfo.TemporalPositionIdentifier = 2;
            DICOM_files{8} = DICOM_files{4};
            DICOM_files{8}.dicomInfo.TemporalPositionIdentifier = 2;
            
%             Opsætter struktur som skal returneres til DICOM display. Det
%             er samme strukturopbygning, som klassen Reader returnere
            DICOM_files_Collection = cell(1,2);
            DICOM_files_Collection{1} = struct;
            DICOM_files_Collection{2} = struct;
            
            DICOM_files_Collection{1}.DTO = DICOM_files(6);
            DICOM_files_Collection{1}.DTO(2) = DICOM_files(7);
            DICOM_files_Collection{2}.DTO(1) = DICOM_files(4);
            DICOM_files_Collection{2}.DTO(2) = DICOM_files(8);
            
   
            dicomLocalizers = [];
   
        end
    end
end

