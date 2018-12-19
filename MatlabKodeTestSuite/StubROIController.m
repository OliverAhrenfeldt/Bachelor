classdef StubROIController < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
 
    properties
        
        ROICollections
        
    end
    
    
    methods

         function obj = Constructor(obj, pos)
            
            addpath ../
            
           totalSliceNumber = 2;
           totalFrameNumber = 2;
            
           for i=1: totalSliceNumber
                for j=1: totalFrameNumber
                    ROIs{i}.Frames{j}.ROI{1} = [];
                    ROIs{i}.Frames{j}.Position{1} = [];
                    obj.ROICollections{1} = ROIs{i};
%                     obj.ROICollections{1} = pos;
                end
           end   
 
           
           obj.ROICollections{1}.ROIs{1}.Frames{1}.Position{1} = cell2mat(pos);
           obj.ROICollections{1}.ROIs{1}.Frames{2}.Position{1} = cell2mat(pos);
           obj.ROICollections{1}.ROIs{2}.Frames{1}.Position{1} = cell2mat(pos);
           obj.ROICollections{1}.ROIs{2}.Frames{2}.Position{1} = cell2mat(pos);          
%            pos{1} = [0 0;1 0;1 1;0 1]; %Mindst mulige ROI

        end
        
    end
end

