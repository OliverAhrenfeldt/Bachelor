classdef UutROICollection < matlab.unittest.TestCase
    %UUTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    
     methods (Static)
       
       function [ROICollectionObj poly] = Setup() %Arrange
            addpath ../
           
            ROICollectionObj = ROICollection; 
             
            points = [500 500;400 600;400 700;500 800;600 800;700 700; 700 600];
            poly = images.roi.Polygon
            poly.Position = points;
            
       end  
       
    end
    
    
    methods (Test)
        
        function createStructure5_1(testCase)
            uut = UutROICollection.Setup();
             
            uut.createStructure(2,1); %Act
            
            actSolution = length(uut.ROIs{1});
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = length(uut.ROIs{1}.Frames);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        
        function Constructor5_2(testCase)
            [uut polygon] = UutROICollection.Setup();
             
            ROICollection = uut.Constructor('Test',2,1,'Test',1,1,polygon); %Act
                     
            actSolution = ROICollection.Name;
            expSolution = 'Test';
            testCase.verifyEqual(actSolution,expSolution); %Assert
 
        end 
        
        function Constructor5_3(testCase)
            [uut polygon] = UutROICollection.Setup();
             
            ROICollection = uut.Constructor('Test',2,1,'Test',1,1,polygon); %Act
            
            actSolution = ROICollection.Color;
            expSolution = 'Test';
            testCase.verifyEqual(actSolution,expSolution); %Assert
 
        end 
        
%         function Constructor5_4(testCase)
%             [uut polygon] = UutROICollection.Setup();
%              
%             ROICollection = uut.Constructor('Test',2,1,'Test',1,1,polygon); %Act
%             
%             actSolution = ROICollection.Autotracking;
%             expSolution = 0;
%             testCase.verifyEqual(actSolution,expSolution); %Assert
%  
%         end 
  
        
%         function Constructor5_5(testCase)
%             [uut polygon] = UutROICollection.Setup();
%              
%             ROICollection = uut.Constructor('Test',2,1,'Test',1,1,polygon); %Act
%             
%             actSolution = ROICollection.D3ROI;
%             expSolution = 0;
%             testCase.verifyEqual(actSolution,expSolution); %Assert
%  
%         end
        
        
        function Constructor5_6(testCase)
            [uut polygon] = UutROICollection.Setup();
             
            ROICollection = uut.Constructor('Test',2,1,'Test',1,1,polygon); %Act
              
            actSolution = ROICollection.AnalysisStatus;
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
        end
      
    end
end

