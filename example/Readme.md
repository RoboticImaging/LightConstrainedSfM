| Filename | Description |  
| ---------| ----------- |
| [Demo.m](../main/Readme.md) | Main script: The demo creates a synthetic burst of images, aligns each image in the burst to a reference image and temporally merge all images in the burst to the reference image. |
| [getAlign.m](../main/example/getAlign.m) | This script aligns each input image to the selected reference image using hierarchical tile-based alignment |
| [getChan.m](../main/example/getChan.m) | This script extracts an RGB image into three seperate channels |
| [getMerge.m](../main/example/getMerge.m) | This script temporally merges each image in the burst to a reference image using 2D DFT voting scheme. This script sptially filters the temporally merged image using wiener and bilateral filtering |
| [getMin.m](../main/example/getMin.m) | This script get the minimum difference between two images and used during alignment stage |
| [image.jpg](../main/example/image.jpg) | This is the example image used for demonstration |
