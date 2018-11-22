classdef IT2Brugsscenarie1 < matlab.unittest.TestCase
    %UUTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
     methods (Static)
       
        function [DicomDisplayObj path2_1] = Setup() %Arrange
           addpath ../
           
            structPath = dir;
            charPath = structPath(1,1).folder;
            newCharPath = charPath(:,[1:69]);
            path2_1 = strcat(newCharPath,'TestData_IT2Brugsscenarie1');
            
   
            DicomDisplayObj = DicomDisplay;
            DicomDisplayObj = DicomDisplayObj.Constructor();
       end       
       
    end
      
    methods (Test)
        
       
        
        function ReadDicomFiles2_1(testCase)
            [DicomDisplayObj path] = IT2Brugsscenarie1.Setup();
            
            DicomDisplayObj.ReadDicomFiles(path); %Act
                  
            actSolution = length(DicomDisplayObj.dicom_files);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end  
        
        
        function ReadDicomFiles2_2(testCase)
            [DicomDisplayObj path] = IT2Brugsscenarie1.Setup();
            
            DicomDisplayObj.ReadDicomFiles(path); %Act
                  
            actSolution = length(DicomDisplayObj.dicom_files{1}.DTO);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        

    end
end

