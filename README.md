# Create-a-curvature-factor-map-for-axisymmetric-vessels-based-on-their-outline-in-the-image
Use contour of axissymmetric vessel to create curvature factor map
Create a curvature factor map for cylindrical (axisymmetric) vessels based on their outline in the image 
Use the contour line (I) of the vessel in the image to find the curvature factor of each point in the vessel surface in the image. Return map of the curvature factor as matrix of type double and size of I. Could be used for adjusting for reflections from the vessel surface in recognition of materials in transparent vessels 
 Input: 
I: a Boundary curve of axisymmetric vessel in the image. Hence contour line of the vessel in the image as binary edge image. 
I most be a close curve in the thickness of one pixel and symmetric with respect to the Y axis 
  
Output: 
Mat: output curvature map (Curvature factor F) in each point inside the vessel region of the image. A double matrix of size Y.
