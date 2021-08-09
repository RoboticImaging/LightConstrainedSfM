File Description

| Filename | Description |  
| ---------| ----------- |
| [Readme.md](../example/Readme.md) | example Readme file|
| [Demo.m](../example/Demo.m) | Main script: The demo creates a synthetic burst of images, aligns each image in the burst to a reference image and temporally merge all images in the burst |
| [getAlign.m](../example/getAlign.m) | This script aligns each input image to the selected reference image using hierarchical tile-based alignment |
| [getChan.m](../example/getChan.m) | This script extracts an RGB image into three seperate channels |
| [getMerge.m](../example/getMerge.m) | This script temporally merges each image in the burst to a reference image using 2D DFT voting scheme. This script subsequently sptially filters the temporally merged image using wiener and bilateral filtering |
| [getMin.m](../example/getMin.m) | This script get the minimum difference between two images and used during alignment stage |
| [image.jpg](../example/image.jpg) | This is the example image used for demonstration |
