classdef ROICollection < handle
    %ROICollection is a data transfer object
    %   The class is used to encapsulate data in a singele object, making
    %   it easy to pass around related dated in the application. A
    %   ROICollection holds the collections ROIs, the name of the
    %   collection, the color of the ROIs in the collection af the analysis
    %   status of the collection. 
    
    properties
        ROIs;
        Name;
        Color;
        AnalysisStatus;
    end
    
    methods
        function obj = Constructor(obj,name,totalFrameNumber, totalSliceNumber, color,framenumber,slicenumber,polygon)
            %Constructs an instance of ROICollection class
            %   The constructor of this class takes the total frame- and
            %   slicenumber of the MRI data, which is used to created the
            %   structure holding the ROIs of the ROI collection. 
            %   Furthermore, the constructor takes the color and the name
            %   of the collection, the current frame- and slicenumber and a
            %   polygon which is saved in the collection.
            
            obj.createStructure(totalFrameNumber,totalSliceNumber);
            obj.ROIs{slicenumber}.Frames{framenumber}.ROI{1} = polygon;
            obj.ROIs{slicenumber}.Frames{framenumber}.Position{1} = polygon.Position;
            obj.Name = name;
            obj.Color = color;
            % New collections analysis status is set to 1 as default:
            obj.AnalysisStatus = 1;
        end
        
        function createStructure(obj,totalFrameNumber, totalSliceNumber)
            %The createStructure method creates the structure holding the
            %ROIs associated with the ROI collection.
            %   The method takes the total frame- and slice number as
            %   parameters. These parameters are used to create a
            %   structure which allows ROIs to be saved in positions
            %   corresponding to the frame they are drawn
            %   in.
            for i=1: totalSliceNumber
                for j=1: totalFrameNumber
                    obj.ROIs{i}.Frames{j}.ROI{1} = [];
                    obj.ROIs{i}.Frames{j}.Position{1} = [];
                end
            end 
        end
    end
end

