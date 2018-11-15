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
            I1 = dicomread('C:\Users\Mads_\OneDrive - Aarhus universitet\Bachelor\DICOM\BOLD Datasæt\198\CD-rom\A\Z834');
            I1norm = double(I1)/max(double(I1(:)));

            figure(); imshow(I1norm); ROI= drawpolygon;
            for i=1:size(ROI.Position,1)
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
                
                if(a_1>0 && a_2>0)
                    vhalvlinje = obj.pospos(a_1,a_2,x2,y2);
                    drawline('Position',vhalvlinje);
                elseif (a_1<0 && a_2<0)
                    vhalvlinje = obj.negneg(a_1,a_2,x2,y2);
                    drawline('Position',vhalvlinje);
                else
                    vhalvlinje = obj.negpos(a_1,a_2,x1,x2,y2,x3);
                    drawline('Position',vhalvlinje);
                end                   
            end
        end
        
        function vhalvlinje = pospos(obj, a_1, a_2,x2,y2)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            C = 180-abs((abs(atand(a_1))-abs(atand(a_2))));
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
        
        function vhalvlinje = negneg(obj,a_1,a_2,x2,y2)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            C = 180-abs((abs(atand(a_1))-abs(atand(a_2))));
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
        
        function vhalvlinje = negpos(obj,a_1,a_2,x1,x2,y2,x3)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            a_x = abs(atand(a_1));
            b_x = abs(atand(a_2));
            if((x1<x2 && x2<x3 )|| (x3<x2 && x2<x1 ))
                C = 180-(abs(atand(a_1))+abs(atand(a_2)));
                halvC = C/2;
                if(C>90)
                    vinkelHalvVinkeltilX = (180-halvC-max([a_x, b_x]));
                else
                    vinkelHalvVinkeltilX = 180-(180-halvC-max([a_x, b_x]));
                end
            else
                C = (360-2*(180-(abs(atand(a_1))+abs(atand(a_2)))))/2;
                halvC = C/2;
                vinkelHalvVinkeltilX = (180-halvC-(180-max([a_x, b_x])));
            end
            

% if ((x2-x1>0 && x2-x3>0) || ((x2-x1<0 && x2-x3<0)))
%     C = 180-(abs(atand(a_1))+abs(atand(a_2)));
%                 halvC = C/2;
%     
%             if(C>90)
%                 vinkelHalvVinkeltilX = (180-halvC-max([a_x, b_x]))+90;
%             else
%                 vinkelHalvVinkeltilX = 180-(180-halvC-max([a_x, b_x]))+90;
%             end
%     
% else
%     C = 180-(abs(atand(a_1))+abs(atand(a_2)));
%                 halvC = C/2;
%                 
%             if(C>90)
%                 vinkelHalvVinkeltilX = (180-halvC-max([a_x, b_x]));
%             else
%                 vinkelHalvVinkeltilX = 180-(180-halvC-max([a_x, b_x]));
%             end
%     
% end


         
%             if(C>90)
%                 vinkelHalvVinkeltilX = (180-halvC-max([a_x, b_x]));
%             else
%                 vinkelHalvVinkeltilX = 180-(180-halvC-max([a_x, b_x]));
%             end
            
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

