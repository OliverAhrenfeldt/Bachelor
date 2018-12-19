classdef ROIController < handle
    %ROIController holds functionality to add, edit and delete ROIs
    %   This class is holds all an instance of the 'Autotrack'-class and 
    %   holds all ROICollections. The class is used to add a new
    %   ROI Collection and to add a new ROI to en existing ROI Collection.
    %   Furthermore, this class is used to delete a ROI Collection and to
    %   delete ROIs in a frame from a collection. This class is also 
    %   used to get a table with all the names and to set and get the 
    %   analysis status of all ROI Collections. 
    %   Finally, this class is used to initiate autotracking and to
    %   initiate cloning of a ROI to succeeding frames. 
    
    properties
        %The 'ROICollections' property holds all ROICollections and their
        %ROIs
        ROICollections;
        %The Autotracker property is an instance of the 'Autotrack'-class
        %which holds the functionality to the autotracking-algorithm.
        Autotracker;
    end
    
    methods
        function obj = Constructor(obj)
            %Constructs an instance of the ROIController class
            %   The property 'Autotracker' is initialized as an object of
            %   the Autotrack class.
            obj.Autotracker = Autotrack();
        end
        
        function AddNewCollection(obj,name,totalFrameNumber, totalSliceNumber, color, framenumber, slicenumber, polygon, roiCollection)
            %The AddNewCollection method adds a new ROICollection to the
            %structure of ROI Collections
            %   The method is used to add a new ROI collection and has no
            %   return value. The method recieves a ROI Colecction object,
            %   a name and a color of the ROI collection, a polygon to add
            %   to the ROI Collection, the current frame- and
            %   slicenumber and the total frame- and slicenumber of the MRI
            %   scan. 
            
            % Counter initialized. Used in the succeeding for-loop to keep
            % the index of the preceding loop
            counter = 1;
            
            % For-lopp compares all points in the ROI to the preceding
            % point. polyIndex holds the index of all non-repeated points.
            for i=2: size(polygon.Position,1)
                if((polygon.Position(i,1) == polygon.Position(i-1,1)) && (polygon.Position(i,2) == polygon.Position(i-1,2))) 
                    polyIndex(counter) = i;
                    counter = counter + 1;
                end
            end
            
            % polyIndex exists only if the previous loop detected identical
            % points in the polygon. The index is used to remove identical
            % points.
            if(exist('polyIndex','var'))
                for i=1: length(polyIndex)
                 polygon.Position(polyIndex(i),:)= [];
                 polyIndex = polyIndex - 1;
                end 
            end
            
            % Constructs a new object the ROI Collection class and adds the
            % collection the the next empty space in ROICollections 
            roiCollection = roiCollection.Constructor(name,totalFrameNumber, totalSliceNumber, color,framenumber,slicenumber,polygon);
            obj.ROICollections{length(obj.ROICollections)+1} = roiCollection;
        end
        
        function AddROI(obj, idx, framenumber, slicenumber, polygon) 
            %The AddROI method adds a new ROI to an existing ROI collection
            %   The method is used to add a ROI to an existing ROI
            %   collection. The method has no return value. The method
            %   recieves a polygon, the idx of the ROI collection it should be added
            %   to, and the slice- and framenumber the ROI is drawn on.
            
            % For-lopp compares all points in the ROI to the preceding
            % point. polyIndex holds the index of all non-repeated points.
            counter = 1;
            for i=2: size(polygon.Position,1)
                if((polygon.Position(i,1) == polygon.Position(i-1,1)) && (polygon.Position(i,2) == polygon.Position(i-1,2)))
                    
                    polyIndex(counter) = i;
                    counter = counter + 1;
                end
            end
            
            % polyIndex exists only if the previous loop detected identical
            % points in the polygon. The index is used to remove identical
            % points.
            if(exist('polyIndex','var'))
                for i=1: length(polyIndex)
                    polygon.Position(polyIndex(i),:)= [];
                    polyIndex = polyIndex - 1;
                end 
            end
            
            %The polygon and its positions is added to the ROI collection:
            obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI{length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI)+1} = polygon;
            obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.Position{length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.Position)+1} = polygon.Position;
        end
        
        function Names = getNames(obj)
            %the getNames method returns the names of all ROI collections.
            %   The method returns the names of all ROI collection. The
            %   Method takes no input parameters.
            
            for i =1:length(obj.ROICollections)
                Names{i} = obj.ROICollections{i}.Name; 
            end
        end
        
        function AnalysisStatus = getAnalysisStatus(obj)
            %The getAnalysisStatus method returns the analysis status of 
            %all ROI collections.
            %   Themethod returns the analysis status of all ROI
            %   collections. The method takes no input parameters.
            
            for i =1:length(obj.ROICollections)
                AnalysisStatus{i} = obj.ROICollections{i}.AnalysisStatus; 
            end
        end
        
        function [cola, colb] = getROITable(obj)
            %The getROITable method creates a column with ROI Collecion 
            %names and a column of the analysis status of the ROI 
            %collections.
            %   The method returns two columns: one with collection names
            %   and one with the analysis status. The method takes no input
            %   parameter.
            
            % Checks for collections in the ROICollections property
            if (isempty(obj.ROICollections) == 0)
                cola = obj.getNames()';
                AnalysisStatus = obj.getAnalysisStatus()';
                for i=1: length(AnalysisStatus)
                    if(AnalysisStatus{i}==0)
                        colb{i} = false;
                    else
                        colb{i} = true;
                    end
                end
                colb = colb';
                
            %Return empty columns if the ROICollections property hold no 
            % ROI collections.
            else
                cola = {};
                colb = {};
            end
        end
        
        function setAnalysisStatus(obj,collectionIndex,status)
            %The SetAnalysisStatus method sets the analysis status of a ROI
            %collection.
            %   The method takes a collection index and a status as input parameters 
            obj.ROICollections{collectionIndex}.AnalysisStatus = status;
        end
        
        function DeleteROI(obj, idx, framenumber, slicenumber)
            %The DeleteROI method deletes ROIs from a ROICollection in a
            %specific frame.
            %   The method takes a index, framenumber and a slicenumber as
            %   input parameters. The method has no return value.
            
            for i=1:length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.Position)
                %Checks wether the field contianing the ROI polygon is
                %longer than i. If the user has used autotracking, ROIs
                %have been added and they are only added as arrays (in the
                %'Position' field. 
                if(length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI)>=i)
                    delete(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI{i});
                    obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI{i} = [];
                end
                obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.Position{i} = [];
            end
        end
        
        function DeleteROICollection(obj, idx, framenumber, slicenumber)
            %The DeleteROICollection deletes a ROI collection
            %   The DeleteROICollection deletes a ROI collection. The
            %   method takes the collection index and the current frame-
            %   and slicenumber. The method has no return value.
            
            %The folowwing for-loop deletes the polygons currently visible
            %on te GUI.
            for i=1:length(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI)
                delete(obj.ROICollections{idx}.ROIs{slicenumber}.Frames{framenumber}.ROI{i});
            end
            
            %Deletes the ROI collection:
            obj.ROICollections{idx} = [];
            for i=idx+1:length(obj.ROICollections)
                if (isempty(obj.ROICollections{i}) == 0)
                    obj.ROICollections{i-1} = obj.ROICollections{i};
                end
            end
            
            obj.ROICollections(length(obj.ROICollections)) = [];
        end
        
        function StartAutotracking(obj,dicomDisplay, slicenumber, framenumber, totalFrames, collectionIdx)
            %The StartAutotracking methods starts the calls the
            %autotracking algorithm in the Autotrack class
            %   The method calls the autotracking algorithm in the
            %   Autotrack class for each ROI on succeeding frames in the 
            %   slice. The method takes a dicomDisplay, holding MRI images,
            %   the current slice- and framenumber, the total number of
            %   frames and the collection index identifying the collection
            %   whose ROIs should be automatically drawn on succeeding
            %   frames. The method has no return value.
            
            %Makes sure that the Autotracker property is instantiated: 
            obj.Autotracker = Autotrack();
            for i=framenumber+1:totalFrames
                image = dicomDisplay.dicom_files{slicenumber}.DTO{framenumber+1}.pixelData;
                for j=1: length(obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber}.Position)
                    prevROI = obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber}.Position{j};
                    if(~isempty(prevROI))
                        %Creates a mask of the ROI being basis of the
                        %succeeding ROI:
                        mask = poly2mask(prevROI(:,1),prevROI(:,2),size(dicomDisplay.dicom_files{1}.DTO{1}.pixelData,1),size(dicomDisplay.dicom_files{1}.DTO{1}.pixelData,2));
                        idx = find(mask>0);
                        prevImage = dicomDisplay.dicom_files{slicenumber}.DTO{framenumber}.pixelData;
                        %Threshold that determines wheter a difference in
                        %pixel values is detected as an edge. The threshold
                        %is based on the std in the ROI on the previous
                        %frame:
                        threshold = (std2(prevImage(idx)))*1.5;
                        newROI = obj.Autotracker.TrackImage(image,prevROI,threshold);
                        obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber+1}.Position{length(obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber+1}.Position)+1} = newROI;
                    end
                end
                framenumber = framenumber+1;
            end
        end
        
        function DrawROIsThrough(obj, slicenumber, framenumber, totalFrames, collectionIdx)
            %The DrawROIsThrough method clones a ROI to all succeeding images in the
            %same slice.
            %   The method takes the current slice- and framenumer, the
            %   totalframes and the index identifying the collection
            %   whose ROI should be automatically cloned to succeeding
            %   frames. The method has no return value.
            for i=framenumber+1:totalFrames
                for j=1: length(obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber}.Position)
                    prevROI = obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber}.Position{j};
                    if(~isempty(prevROI))
                        obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber+1}.Position{length(obj.ROICollections{collectionIdx}.ROIs{slicenumber}.Frames{framenumber+1}.Position)+1} = prevROI;
                    end
                end
                framenumber = framenumber+1;
            end
        end
    end
end

