# LightConstrainedSfM

### Description
This is the code for the paper   
**A. Ravendran, M. Bryson, and D. G. Dansereau, “Burst imaging for light-constrained structure-from-motion,” IEEE Robotics and Automation Letters (RA-L, ICRA), vol. 7, no. 2, pp. 1040–1047, Apr. 2022** Available [here](https://roboticimaging.org/Papers/ravendran2022burst.pdf).

For further information please see the [Project Website](https://roboticimaging.org/Projects/BurstSfM).

### Dependencies
These are required for running the folders:
- example: .JPG images
  - [MATLAB Image Processing Toolbox](https://au.mathworks.com/products/image.html)  
- reconstruction: raw images
  - [MATLAB Image Processing Toolbox](https://au.mathworks.com/products/image.html)  
  - [LFToolbox](https://github.com/doda42/LFToolbox)  

| Filename | Description |  
| ---------| ----------- |
| [Readme.md](../main/Readme.md) | Main Readme file. |
| [example](../main/example) | Demonstration of the imaging pipeline used during the reconstruction on a burst with synthetic noise. For further details, please read [Readme](../main/example/Readme.md) within example folder. Implementation is on deBayered images e.g. JPG or PNG images |
| [reconstruction](../main/reconstruction) | The implementation of Light-Constrained SfM on raw Bayer images over different bursts of different scenes. For further details, please read [Readme](../main/reconstruction/Readme.md) within reconstruction folder. Implementation is on raw Bayer images. |

