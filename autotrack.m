classdef autotrack
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Property1
    end
    
    methods
        function obj = untitled(inputArg1,inputArg2)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function startTracking(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            I1 = dicomread('D:\Aarhus universitet\Mads Nielsen - Bachelor\DICOM\BOLD Datasæt\198\CD-rom\A\Z834');
            I1norm = double(I1)/max(double(I1(:)));
            figure(1); imshow(I1norm); ROI= drawpolygon;
            %'Position',[50,110;70,50;100,30]
            
            for i=1:size(ROI.Position,1)      
                %% Setup
                % To find the angle bisector of every point in the ROI, the
                % point of interest and the two adjacent points are
                % identified:
                if(i==1)
                    punkt1 = [ROI.Position(size(ROI.Position,1),1),ROI.Position(size(ROI.Position,1),2)];
                    punkt2 = [ROI.Position(1,1),ROI.Position(1,2)];
                    punkt3 = [ROI.Position(2,1),ROI.Position(2,2)];
                    
                elseif(i==size(ROI.Position,1))
                    punkt1 = [ROI.Position(i-1,1),ROI.Position(i-1,2)];
                    punkt2 = [ROI.Position(i,1),ROI.Position(i,2)];
                    punkt3 = [ROI.Position(1,1),ROI.Position(1,2)];
                else
                    punkt1 = [ROI.Position(i-1,1),ROI.Position(i-1,2)];
                    punkt2 = [ROI.Position(i,1),ROI.Position(i,2)];
                    punkt3 = [ROI.Position(i+1,1),ROI.Position(i+1,2)];
                end
                
                x1 = punkt1(1);
                y1 = punkt1(2);
                
                x2 = punkt2(1);
                y2 = punkt2(2);

                x3 = punkt3(1);
                y3 = punkt3(2);

                a_1 = (y2 - y1)/(x2-x1);
                b_1 = y1 - a_1*x1;

                a_2 = (y3 - y2)/(x3-x2);
                b_2 = y2 - a_2*x2;
                
                %% Scenarios:
                % The point of interest can be either to the left, right or
                % in center of the two adjacent points.
                left = false; right = false; center = false;
                
                if (x2-x1<0 && x2-x3<0)
                    left = true;
                elseif (x2-x1>0 && x2-x3>0)
                    right = true;
                else
                    center = true;
                end
                
                % Source for method of angle calculation: https://www.studieportalen.dk/forums/Thread.aspx?id=568435&fbclid=IwAR0SbmeZVewMB-OOZwPCNLfHm6lJV52ulpYHTkH8oGZE4zvcFVukI5s0miM
                
                % All of the possible positions of the three points:
                % Scenario 1:
                if (a_1<0 && a_2<0 && left)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC1andSC2(a_1, a_2, x2, y2);
                % Scenario 2:
                elseif (a_1<0 && a_2<0 && right)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC1andSC2(a_1, a_2, x2, y2);
                % Scenario 3:
                elseif (a_1<0 && a_2<0 && center)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC3(a_1, a_2, x2, y2);
                % Scenario 4:
                elseif (a_1<0 && a_2>0 && left)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC4andSC5(a_1, a_2, x2, y2);
                % Scenario 5:
                elseif (a_1<0 && a_2>0 && right)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC4andSC5(a_1, a_2, x2, y2);
                % Scenario 6:
                elseif (a_1<0 && a_2>0 && center)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC6(a_1, a_2, x2, y2);
                % Scenario 7:
                elseif (a_1>0 && a_2>0 && left)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC7(a_1, a_2, x2, y2);
                % Scenario 8:
                elseif (a_1>0 && a_2>0 && right)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC8(a_1, a_2, x2, y2);
                % Scenario 9:
                elseif (a_1>0 && a_2>0 && center)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC9(a_1, a_2, x2, y2);
                % Scenario 10:
                elseif (a_1>0 && a_2<0 && left)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC10andSC11(a_1, a_2, x2, y2);
                % Scenario 11:
                elseif (a_1>0 && a_2<0 && right)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC10andSC11(a_1, a_2, x2, y2);
                % Scenario 12:
                elseif (a_1>0 && a_2<0 && center)
                    [vhalv, avinkelhalv, bvinkelhalv] = obj.SC12(a_1, a_2, x2, y2);
                end
                
                drawline('Position',vhalv,'Color','y');
                
                %% Creation of line segment
                % To find a line segment, a circle is drawn. The center
                % is the point of interest. The intersection between the
                % circle and the angle bisector defines the line segment.
                
%                 circle = drawcircle('Center', [x2,y2], 'Radius', 5);
                % linecirc requires Mapping Toolbox
                [xinter, yinter] = linecirc(avinkelhalv, bvinkelhalv, x2, y2, 5);
                
                
                
                
                
            end
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC1andSC2(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            a_x_inner = (180-a_x);
            C = 180-b_x-a_x_inner;
            halvC = C/2;
            vinkelHalvVinkeltilX = 180-halvC-a_x_inner;
            vinkelHalvVinkeltilX = 180-vinkelHalvVinkeltilX;
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC3(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            a_x_inner = (180-a_x);
            C = (360-2*(180-b_x-a_x_inner))/2;
            if (C > 180)
                C = 360-C;
            end
            halvC = C/2;
            vinkelHalvVinkeltilX = 180-halvC-max([a_x, b_x]);
            
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC4andSC5(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            C = 180-(180-a_x-b_x);
            halvC = C/2;
            
            vinkelHalvVinkeltilX = 180-halvC-(180-max([a_x, b_x]));
            
            if (a_x>b_x)
                vinkelHalvVinkeltilX = 180-vinkelHalvVinkeltilX;
            end
            
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
                
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC6(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            C = 180-(a_x+b_x);

            halvC = C/2;

            vinkelHalvVinkeltilX = 180-halvC-max([a_x, b_x]);
            if (a_x<b_x)
                vinkelHalvVinkeltilX = 180-vinkelHalvVinkeltilX;
            end
            
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC7(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            a_x_inner = (180-a_x);
            C = abs(180-b_x-a_x_inner);
            halvC = C/2;
            vinkelHalvVinkeltilX = 180-halvC-(180-max([a_x,b_x]));
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC8(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            a_x_inner = (180-a_x);
            C = abs(180-b_x-a_x_inner);
            halvC = C/2;
            vinkelHalvVinkeltilX = 180-halvC-(180-max([a_x,b_x]));
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC9(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            a_x_inner = (180-a_x);
            C = (360-2*(180-b_x-a_x_inner))/2;
            if (C > 180)
                C = 360-C;
            end
            halvC = C/2;
            vinkelHalvVinkeltilX = 180-(180-halvC-max([a_x, b_x]));
            
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC10andSC11(obj, a_1, a_2, x2, y2)
            b_x = abs(atand(a_1));
            a_x = abs(atand(a_2));
            C = 180-(180-a_x-b_x);
            halvC = C/2;
            
            vinkelHalvVinkeltilX = 180-halvC-(180-max([a_x, b_x]));
            
            if (a_x>b_x)
                vinkelHalvVinkeltilX = 180-vinkelHalvVinkeltilX;
            end
            
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
        
        function [vhalvlinje, avinkelhalv, bvinkelhalv] = SC12(obj, a_1, a_2, x2, y2)
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            C = 180-(a_x+b_x);

            halvC = C/2;

            vinkelHalvVinkeltilX = 180-halvC-max([a_x, b_x]);
            if (a_x>b_x)
                vinkelHalvVinkeltilX = 180-vinkelHalvVinkeltilX;
            end
            
            avinkelhalv = tand(vinkelHalvVinkeltilX);
            bvinkelhalv = y2-avinkelhalv*x2;
            
            punkt1y = 0;
            punkt1x = (punkt1y-bvinkelhalv)/avinkelhalv;
            punkt1 = [punkt1x, punkt1y];
            
            punkt2y = 128;
            punkt2x = (punkt2y-bvinkelhalv)/avinkelhalv;
            punkt2 = [punkt2x, punkt2y];
            
            vhalvlinje = [punkt1; punkt2];
        end
                
        function outputArg = getpixelsonline(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

