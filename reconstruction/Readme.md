File Description
- Implementation is on raw Bayer images.
- For further details regarding scripts that handles raw images, please refer to [LFToolbox Documentation](https://github.com/doda42/LFToolbox/blob/master/LFToolbox.pdf)

| Filename | Description |  
| ---------| ----------- |
| [Readme.m](../reconstruction/Readme.md) | reconstruction: Readme file |
| [Main.m](../reconstruction//Main.m) | This script aligns each image in a given burst from a scene to a reference image from the same burst of the same scene and temporally merge all images within the burst, and repeat it over different bursts over different scenes |
| [Alignment.m](../reconstruction//Alignment.m) | This script prepares raw image for alignment |
| [getAlign.m](../reconstruction//getAlign.m) | This script aligns each input image to the selected reference image using hierarchical tile-based alignment |
| [getChan.m](../reconstruction//getChan.m) | This script extracts a raw image into four seperate channels |
| [getMerge.m](../reconstruction//getMerge.m) | This script temporally merges each image in the burst to a reference image using 2D DFT voting scheme. This script subsequently sptially filters the temporally merged image using wiener and bilateral filtering |
| [getMin.m](../reconstruction//getMin.m) | This script get the minimum difference between two images and used during alignment stage |
| [setChan.m](../reconstruction//setChan.m) | This script creates a final combined image from each four seperate channel |
| [colmapscript.sh](../reconstruction//colmapscript.sh) | This script describes the settings used in COLMAP for reconstruction |
