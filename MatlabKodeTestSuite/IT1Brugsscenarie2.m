classdef UutROIController < matlab.unittest.TestCase
    %UUTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    
     methods (Static)
       
       function [ROIControllerObj ROICollectionObj poly] = Setup() %Arrange
            addpath ../
           
            ROIControllerObj = ROIController; 
            ROICollectionObj = ROICollection;
            
%               Opretter polygon objekt
            points = [500 500;400 600;400 700;500 800;600 800;700 700; 700 600];
            poly = images.roi.Polygon
            poly.Position = points;
            
       end  
       
    end
    
    
    methods (Test)
        
        function AddNewCollection1_1(testCase)
            [uut ROICollection poly]= UutROIController.Setup();   
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, ROICollection); %Act
            
            actSolution = length(uut.ROICollections);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        
      
         
         
         
    end
end

