function [Mat]=CreateCurvatureMap(I)
%{
Create a curvature factor map for cylindrical (axisymmetric) vessels based on their outline in the image

Use the contour line (I) of the vessel in the image to find the curvature factor of each point in the vessel surface in the image.
 Return map of the curvature factor as matrix of type double and size of I. 
Could be used for adjusting for reflections from  the vessel surface in recognition of materials in transparent vessels

 Input:
I: a Boundary curve of axisymmetric vessel in the image. Hence contour line of the vessel in the image as binary edge image.
I most be a close curve in the thickness of one pixel and symmetric with respect to the Y axis
 
Output:
Mat: output curvature map (Curvature factor F) in each point inside the vessel region of the image.  A double matrix of size Y.


%}
close all;
imtool close  all;
if nargin<1 
    I=imread('Ibor.tif');
end;
%I=imread('C:\Users\mithycow\Documents\TEST IMAGES For curvature 1\LIQUID\IMG_3904_BORDERS.TIF');
%---------------------------------------------------------------------------------------------------------
[Hight,Width]=size(I);
  [Ay,Ax]=find(I);
  [n,tt]=size(Ax);
  MaxX=max(Ax);
  MaxY=max(Ay);
  MinY=min(Ay);
  MinX=min(Ax);
AvX=mean(Ax);
%------------------smooth boundaries using openning closing morphological operations (not effective)-------------------------------------------------------------------------------------
mat=double(imfill(I,'holes'));
%{
ll=max(round((MaxY-MinY)/100*3),2);



mat = imerode(mat,ones(ll,ll));
mat = imdilate(mat,ones(ll,ll));
mat = imdilate(mat,ones(ll,ll));
mat = imerode(mat,ones(ll,ll));
I = bwmorph(mat,'remove');% remove blobe interior and leave edges;
%}
%------------------------------------------retrace points-------------------------------------
[Ay,Ax]=find(I);
  [n,tt]=size(Ax);
  MaxX=max(Ax);
  MaxY=max(Ay);
  MinY=min(Ay);
  MinX=min(Ax);
AvX=mean(Ax);
%------------------------------------------------------------------------------------------------
%----------------------------------------Find left edges along the vessel (maxx X for each row)---------------------------------------------------------------------
LeftEdge=ones(Hight,1)*MinX;

for f=1:n
    if LeftEdge(Ay(f))<Ax(f)
       LeftEdge(Ay(f))=Ax(f);
    end;
end;
%================================================Find the curvature of each  row of the vessel=================================================================================
%{
tm=mat*0;
for f=1:size(LeftEdge)
tm(f,LeftEdge(f))=255;
end;
imshow(tm);
pause();
%}
%================================================Find the curvature of each  row of the vessel=================================================================================


Dmin=max(round((MaxY-MinY)/50),3);
Dmax=max(round((MaxY-MinY)/14),4);
LineScore=zeros(Hight,1);
   v1=[0;0];   v2=[0 0];
for f=MinY:MaxY % Scan every line in the image and find the angle of the vessel curvature
    for d=Dmin:Dmax % Find the angle over multitude of scale            
        v1(2)=LeftEdge(f)-LeftEdge(max((f-d),1));
        v2(2)=LeftEdge(min((f+d),Hight))-LeftEdge(f);
        v1(1)=d;
        v2(1)=d;        
        LineScore(f)=LineScore(f)+acos((v2*v1/norm(v1)/norm(v2)));%/sqrt(d);
         % LineScore(f)=LineScore(f)+abs(v2*v1/norm(v1)/norm(v2));%/d;
   end;
end;
%============================================adjust and smooth line score===================================================================================
LineScore=LineScore(MinY:1:MaxY);
LineScore=LineScore./3.14.*180; 
mask=ones(min(round((MaxY-MinY)/100),1),1);
LineScore= conv(LineScore,mask,'same');
%LineScore=sqrt(LineScore);
LineScore=LineScore/(Dmax-Dmin+1)/30+ones(size(LineScore));%./(max([LineScore]))*;%30 best so far
%==================================================Create and draw curvature map===================================================================================
for y=MinY:MaxY;
    mat(y,:)=mat(y,:)*LineScore(y-MinY+1);
end;
close all;
%==========================Curvature map  display(optional)============================================
rgb = label2rgb(gray2ind(uint8(mat/max(max(mat))*255),255),jet(255));

figure,imshow(rgb);
figure,imshow(uint8(mat/max(max(mat))*255));
imtool(mat);

%plot(LineScore);
end
