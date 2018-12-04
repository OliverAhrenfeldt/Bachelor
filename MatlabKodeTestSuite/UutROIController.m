classdef UutROIController < matlab.unittest.TestCase
    %UUTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    
     methods (Static)
       
       function [ROIControllerObj MockROICollectionObj poly poly2 poly3] = Setup() %Arrange
            addpath ../
           
            ROIControllerObj = ROIController; 
            MockROICollectionObj = MockROICollection;
            
%               Opretter polygon objekt med forskellige punkter
            points = [500 500;400 600;400 700;500 800;600 800;700 700; 700 600];
            poly = images.roi.Polygon;
            poly.Position = points;
            
%               Opretter polygon objekt med identiske punkter i to punkter
            points = [500 500;400 600;400 700;500 800;700 700;700 700; 700 600];
            poly2 = images.roi.Polygon;
            poly2.Position = points;
            
%               Opretter polygon objekt med identiske punkter i tre punkter
            points = [500 500;400 700;400 700;500 800;700 700;700 700; 700 700];
            poly3 = images.roi.Polygon;
            poly3.Position = points;
            
       end  
       
    end
    
    
    methods (Test)
        
        function AddNewCollection6_1(testCase)
            [uut mockCollection poly]= UutROIController.Setup();   
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, mockCollection); %Act
            
            actSolution = length(uut.ROICollections);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        function AddNewCollection6_2(testCase)
            [uut mockCollection poly poly2]= UutROIController.Setup();   
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly2, mockCollection); %Act
            
            actSolution = length(uut.ROICollections);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        function AddNewCollection6_3(testCase)
            [uut mockCollection poly poly2 poly3]= UutROIController.Setup();   
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly3, mockCollection); %Act
            
            actSolution = length(uut.ROICollections);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        function AddROI6_4(testCase)
            [uut mockCollection poly]= UutROIController.Setup();   
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, mockCollection); %Act
            uut.AddROI(1, 1, 1, poly)
           
            actSolution = length(uut.ROICollections{1}.ROIs{1}.Frames{1}.ROI);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        function AddROI6_5(testCase)
            [uut mockCollection poly poly2]= UutROIController.Setup();   
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, mockCollection); %Act
            uut.AddROI(1, 1, 1, poly2)
           
            actSolution = length(uut.ROICollections{1}.ROIs{1}.Frames{1}.ROI);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        function AddROI6_6(testCase)
            [uut mockCollection poly poly2 poly3]= UutROIController.Setup();   
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, mockCollection); %Act
            uut.AddROI(1, 1, 1, poly3)
           
            actSolution = length(uut.ROICollections{1}.ROIs{1}.Frames{1}.ROI);
            expSolution = 2;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        function GetNames6_7(testCase)
            [uut mockCollection poly]= UutROIController.Setup();   
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, mockCollection); %Act
            ROICollectionName = uut.getNames();
               
            actSolution = char(ROICollectionName);
            expSolution = 'Test';
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
        function GetAnalysisStatus6_8(testCase)
            [uut mockCollection poly]= UutROIController.Setup();   
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, mockCollection); %Act
            ROICollectionStatus = uut.getAnalysisStatus();
               
            actSolution = cell2mat(ROICollectionStatus);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
      
         function SetAnalysisStatus6_9(testCase)
            [uut mockCollection poly]= UutROIController.Setup();   
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, mockCollection); %Act
            uut.setAnalysisStatus(1,0);
               
            actSolution = uut.ROICollections{1}.AnalysisStatus;
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
          
        end 
        
        
        function GetROITable6_10(testCase)
            [uut mockCollection poly]= UutROIController.Setup();   
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, mockCollection); %Act
            [colaName colbStatus] = uut.getROITable();
               
            actSolution = char(colaName);
            expSolution = 'Test';
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = cell2mat(colbStatus);
            expSolution = true;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
         function GetROITable6_11(testCase)
            [uut mockCollection poly]= UutROIController.Setup();   
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, mockCollection); %Act
            uut.setAnalysisStatus(1,0);
            [colaName colbStatus] = uut.getROITable();
               
            actSolution = char(colaName);
            expSolution = 'Test';
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = cell2mat(colbStatus);
            expSolution = false;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end 
        
         function GetROITable6_12(testCase)
            uut= UutROIController.Setup();   
            
            [colaName colbStatus] = uut.getROITable();
               
            actSolution = isempty(colaName);
            expSolution = true;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = isempty(colbStatus);
            expSolution = true;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end 
         
         function DeleteROI6_13(testCase)
            [uut mockCollection poly] = UutROIController.Setup();   
            
            
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, mockCollection); %Act
            uut.AddROI(1, 2, 1, poly);
            uut.DeleteROI(1, 2, 1);
            

            actSolution = isempty(uut.ROICollections{1}.ROIs{1}.Frames{1,2}.ROI{1,2});
            expSolution = true;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
         end 
         
          function DeleteROICollection6_14(testCase)
            [uut mockCollection poly] = UutROIController.Setup();   
              
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, mockCollection); %Act
            uut.DeleteROICollection(1);

            actSolution = length(uut.ROICollections);
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
         end 
         
         function DeleteROICollection6_15(testCase)
            [uut mockCollection poly] = UutROIController.Setup();   
              
            uut.AddNewCollection('Test',2,1,'Test',1,1, poly, mockCollection); %Act
            uut.AddNewCollection('Test2',2,1,'Test2',1,1, poly, mockCollection); %Act
            uut.DeleteROICollection(1);
         

            actSolution = length(uut.ROICollections);
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
         end 
         
         
         
         
    end
end

