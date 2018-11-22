classdef UutContrastAdjuster < matlab.unittest.TestCase
    %UUTDATA Summary of this class goes here
    %   Detailed explanation goes here
    
    
     methods (Static)
       
       function [ContrastAdjusterObj Pixel_1 Pixel_0 Pixel_05 Pixel_bold] = Setup() %Arrange
             addpath ../
           
            Pixel_1 = ones(128,128);
            Pixel_0 = zeros(128,128);
            Pixel_05 = ones(128,128).*0.5;
            Pixel_bold = dicomread('../TestData/Z5795_Bold');
              
            %Normaliserer billede
            Pixel_bold= double(Pixel_bold);
            Pixel_bold = Pixel_bold/max(Pixel_bold(:));
            
            ContrastAdjusterObj = ContrastAdjuster; 
 
       end       
    end
    
    
    methods (Test)
        
        function GammaCorrect4_1(testCase)
            [uut Pixel_1] = UutContrastAdjuster.Setup();
             
            pixelData = uut.GammaCorrect(2,Pixel_1); %Act
            
            actSolution = max(pixelData(:));
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = min(pixelData(:));
            expSolution = 1;
            testCase.verifyEqual(actSolution,expSolution); %Assert
        end 
        
         function GammaCorrect4_2(testCase)
            [uut Pixel_1 Pixel_0] = UutContrastAdjuster.Setup();
             
            pixelData = uut.GammaCorrect(2,Pixel_0); %Act
            
            actSolution = max(pixelData(:));
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = min(pixelData(:));
            expSolution = 0;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end 
        
         function GammaCorrect4_3(testCase)
            [uut Pixel_1 Pixel_0 Pixel_05] = UutContrastAdjuster.Setup();
             
            pixelData = uut.GammaCorrect(5,Pixel_05); %Act
            
            actSolution = round(max(pixelData(:)),4);
            expSolution = 0.0313;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = round(min(pixelData(:)),4);
            expSolution = 0.0313;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end 
        
         function GammaCorrect4_4(testCase)
            [uut Pixel_1 Pixel_0 Pixel_05] = UutContrastAdjuster.Setup();
             
            pixelData = uut.GammaCorrect(0.5,Pixel_05); %Act
            
            actSolution = round(max(pixelData(:)),4);
            expSolution = 0.7071;
            testCase.verifyEqual(actSolution,expSolution); %Assert
            
            actSolution = round(min(pixelData(:)),4);
            expSolution = 0.7071;
            testCase.verifyEqual(actSolution,expSolution); %Assert
         end     
        
         function HistogramEqualize4_5(testCase)
            [uut Pixel_1 Pixel_0 Pixel_05 Pixel_bold] = UutContrastAdjuster.Setup();
              
            pixelData = uut.HistogramEqualize(Pixel_bold); %Act
            std_2 = std2(pixelData);
            
            actSolution = 0.1423;
            expSolution = round(std_2,4);
            testCase.verifyEqual(actSolution,expSolution); %Assert       
         end  
         
         
    end
end

