classdef UutBOLDAnalyzer < matlab.unittest.TestCase
    %UUTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    
     methods (Static)
       
       function [BoldAnalyzerObj DicomFiles pos1 pos2 pos3 pos4] = Setup() %Arrange
           addpath ../
           
           DicomFilesPath = {
               '../TestData/ZZZBlackWhite1'
               '../TestData/ZZZBlackWhite2'
               };
           
            for i = 1: length(DicomFilesPath)
                d = DICOM_File_DTO;
                d.pixelData = dicomread(DicomFilesPath{i});
                d.dicomInfo = dicominfo(DicomFilesPath{i});
                DicomFiles{i} = d;
            end
             

            
%             Opretter polygon objekt med forskellige punkter
%             positions1{1} = {[0 0;1 0;1 1;0 1]};
            pos1{1} = [0 0;1 0;1 1;0 1]; %Mindst mulige ROI
            pos2{1} = [0 0;128 0;128 128;0 128]; %Størst mulige ROI
            pos3{1} = [0 0;64 0;64 128;0 128]; %ROI af hele venstre halvdel lodret
            pos4{1} = [65 0;128 0;128 128;65 128]; %ROI af hele højre halvdel lodret
%             pos4{1} = [0 0;128 0;128 128;0 128];
%             poly = images.roi.Polygon;
%             poly.Position = positions1;
            
            BoldAnalyzerObj = BOLDAnalyzer; 
            
       
       end       
    end
    
    
    methods (Test)
        
        
        function SetMask7_1(testCase)
            [uut, dicomFiles, positions1, ~] = UutBOLDAnalyzer.Setup();
            
            dicomFile = dicomFiles{1};
              
            pixelData = dicomFile.pixelData; %Act
            dim1 = size(pixelData,1);
            dim2 = size(pixelData,2);
            
            mask = uut.SetMask(positions1, dim1, dim2);
            
            actSolution = mask;
            expSolution = zeros(128,128);
            expSolution(1,1) = 1;
            
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        
        function SetMask7_2(testCase)
            [uut, dicomFiles, ~, positions2] = UutBOLDAnalyzer.Setup();
            
            dicomFile = dicomFiles{1};
              
            pixelData = dicomFile.pixelData; %Act
            dim1 = size(pixelData,1);
            dim2 = size(pixelData,2);
            
            mask = uut.SetMask(positions2, dim1, dim2);
            
            actSolution = mask;
            expSolution = ones(128,128);
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        function GetAbsoluteValue7_3(testCase)
            [uut, dicomFiles, ~, ~, positions3] = UutBOLDAnalyzer.Setup();
            
            dicomFile = dicomFiles{1};
              
            pixelData = dicomFile.pixelData; %Act
            dim1 = size(pixelData,1);
            dim2 = size(pixelData,2);
            
            mask = uut.SetMask(positions3, dim1, dim2);
            meanValue = uut.GetAbsoluteValue(mask, pixelData);
            
            
            actSolution = meanValue;
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        function GetAbsoluteValue7_4(testCase)
            [uut, dicomFiles, ~, ~, ~, positions4] = UutBOLDAnalyzer.Setup();
            
            dicomFile = dicomFiles{1};
              
            pixelData = dicomFile.pixelData; %Act
            dim1 = size(pixelData,1);
            dim2 = size(pixelData,2);
            
            mask = uut.SetMask(positions4, dim1, dim2);
            meanValue = uut.GetAbsoluteValue(mask, pixelData);
            
            
            actSolution = meanValue;
            expSolution = 65535;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        
        
         
        
    end
end

