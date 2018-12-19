classdef StubDicomDisplay < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
 
    properties
        
        dicom_files
        
    end
    
    
    methods

         function obj = Constructor(obj)
            
            addpath ../
                  
            DicomFilesPath = {
               '../TestData/ZZZBlackWhite1.dcm'
               '../TestData/ZZZBlackWhite2.dcm'
               };
           
           dicom_files = {}; 
           
                      
           for i = 1: length(DicomFilesPath)
                d = DICOM_File_DTO;
                d.pixelData = dicomread(DicomFilesPath{i});
                d.dicomInfo = dicominfo(DicomFilesPath{i});
                dicom_files{1}.DTO{i} = d;
           end 
           
            dicom_files{2} = dicom_files{1};
            
           
           obj.dicom_files = dicom_files;
           
             %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            
        end
        
    end
end

