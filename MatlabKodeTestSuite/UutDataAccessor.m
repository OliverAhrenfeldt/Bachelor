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
                paths{i} = dir(fullfile(DicomFilesPath{i}));
            end
                     
            DataAccessObj = DataAccessor; 
            
            
       end       
    end
    
    
    methods (Test)
        
        function Dicomread2_1(testCase)
            [uut paths] = UutDataAccessor.Setup();
            
            %Filtrere unødvendige paths for testcasen
            path = paths(:,1);
              
            pixelData = uut.Dicomread(path); %Act
            
            actSolution = size(pixelData);
            expSolution = [128 128];
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
         function Dicomread2_2(testCase)
            [uut paths] = UutDataAccessor.Setup();
            
            %Filtrere unødvendige paths for testcasen
            path = paths(:,2);
              
            pixelData = uut.Dicomread(path); %Act
            
            actSolution = max(pixelData(:));
            expSolution = uint16(0);
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = min(pixelData(:));
            expSolution = uint16(0);
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end 
        
         function Dicomread2_3(testCase)
            [uut paths] = UutDataAccessor.Setup();
            
            %Filtrere unødvendige paths for testcasen
            path = paths(:,3);
              
            pixelData = uut.Dicomread(path); %Act
            
            actSolution = max(pixelData(:));
            expSolution = uint16(65535);
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = min(pixelData(:));
            expSolution = uint16(65535);
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end 
        
         function Dicominfo2_4(testCase)
            [uut paths] = UutDataAccessor.Setup();
            
            %Filtrere unødvendige paths for testcasen
            path = paths(:,1);
              
            metaData = uut.Dicominfo(path); %Act
            
            actSolution = metaData.SeriesDescription;
            expSolution = '2D GE EPI SS 1';
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end     
        
         
    end
end

