To run the program, type MRI_Interface in the matlab command window. 

(1st Panel) Generate Phantom
In the first panel, choose a phantom from the drop down window. The first phantom is resizable while the others are not. Once a phantom is chosen, click 'Generate Phantom'. 

!important! To input an image, please make sure your image is in the 'data' folder, otherwise the program will not be able to find it. Choose the image to upload in the pop-up window. Once an image is chosen, it will auto-convert to gray-scale and be viewable in the GUI. Note: you do not have to click 'Generate Phantom' if you choose to input an image. 

(2nd Panel) Trajectory
Choose either Radial or Cartesian directory from the drop-down window. Then enter the number of lines and points you wish to interpolate with. Click 'Run Acquisition' to run the function. The resulting MRI image will be viewable along with the image's k-space in the third panel. 

(3rd Panel) K-space Manipulation
Choose a k-space manipulation from the drop-down window. Editable information will toggle on/off depending on the choice. 
For the first two options, enter the k-step number. 
For the last one, enter the coordinates needed with the first square in the top-left being the coordinate (1,1) (Note: X-coordinates start at 1 then increase as you go down, y-coordinates start at one and increase as you go right). 
Click 'Run Function' once all information is entered. The K-Space Function image will be viewable in the third panel.
To run the acquisition on the K-Space image, click 'Run Acquisition Again' at the bottom of the third panel. Note: Polar lines & point points numbers can be changed before running the acquisition again. The resulting image will be viewable in the second panel. 

To reset the program and start again, click 'Reset' at the bottom of the third panel. 