classdef IT1Brugsscenarie1 < matlab.unittest.TestCase
    %UUTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
     methods (Static)
       
       function [ReaderObj paths] = Setup() %Arrange
           addpath ../
           
           DicomFilesPath = {
               '../TestData/Z5795_Bold'
               '../TestData/Z5792_Bold'
               '../TestData/Z01_Loc'
               };
                             
            ReaderObj = Reader; 
            ReaderObj.dataAccessor = DataAccessor;
           
            %Indlæser Dicomfilerne indeks 2,3 og 4 i DicomFilesPath
            for i = 1: length(DicomFilesPath)
                paths{i} = dir(fullfile(DicomFilesPath{i}));
            end
            
       end
     end
     
     
    methods (Test)
        
        function ReadDicomFiles1_1(testCase)
            [ReaderObj paths] = IT1Brugsscenarie1.Setup();
            
            [Dicom_Sorted Dicom_Localizer] = ReaderObj.ReadDicomFiles(paths); %Act
                  
            actSolution = length(Dicom_Sorted);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(Dicom_Localizer);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end   
        
        function ReadDicomFiles1_2(testCase)
            [ReaderObj paths] = IT1Brugsscenarie1.Setup();
            
            paths = paths(:,[1 2]);
            
            [Dicom_Sorted Dicom_Localizer] = ReaderObj.ReadDicomFiles(paths); %Act
                  
            actSolution = length(Dicom_Sorted);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(Dicom_Localizer);
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end
        
        
        function ReadDicomFiles1_3(testCase)
            [ReaderObj paths] = IT1Brugsscenarie1.Setup();
            
            paths = paths(:,3);
            
            [Dicom_Sorted Dicom_Localizer] = ReaderObj.ReadDicomFiles(paths); %Act
                  
            actSolution = length(Dicom_Sorted);
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(Dicom_Localizer);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end  
    end
end

