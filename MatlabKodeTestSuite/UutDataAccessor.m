classdef UutDataAccessor < matlab.unittest.TestCase
    %UUTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    
     methods (Static)
       
       function [DataAccessObj paths] = Setup() %Arrange
           addpath ../
           
           DicomFilesPath = {
               '../TestData/Z5795_Bold'
               '../TestData/Black.dcm'
               '../TestData/White.dcm'
               };
           
            for i = 1:length(DicomFilesPath)
                paths{i} = dir(fullfile(DicomFilesPath{i+1}));
            end
                     
            DataAccessObj = DataAccessor; 
     
       end       
    end
    
    
    
    
    
    
    methods (Test)
        
        function SortDicomFiles1_1(testCase)
            [uut dto] = UutReader.StaticSetup();
            
            %Filtrere unødvendige DICOM filer for testcasen
            dtoTest = dto(:,[1 2]);
              
            [Dicom_Sorted Dicom_Localizer] = uut.SortDicomFiles(dtoTest); %Act
            
            
            actSolution = length(Dicom_Localizer);
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
    end
end

