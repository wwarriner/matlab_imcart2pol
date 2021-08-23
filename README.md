# imcart2pol
Converts 2D Cartesian images to polar coordinate images, i.e. "unwraps" them about an origin. The result is a rectangular image whose vertical axis is radial, and horizontal axis is circumferential. The index `1` of the radial axis is the origin of the Cartesian coordinates image.

The intent of the code is to be used to make polar coordinate modifications to a Cartesian coordinate image more simply. The intended workflow goes as follows
```
im_c = <from source>
im_p = im_cart2pol(im_c, ...)
<modify im_p>
im_c = im_pol2cart(im_p, size(im_c), ...)
<use im_c>
```

The top-level functions are `im_cart2pol.m` and `im_pol2cart.m`. The file `test.m` contains an example of usage. Other files are helper functions. Note that `im_pol2cart.m` is not intended to be used in isolation, and no guarantees are made about output.

Overall the workflow works well, even on logical images, but has artifacts with thin features. The user may select which `interp2` method is used for coordinates conversion as a string argument to the top-level functions.

# Usage
Please see `test.m` for an example of how to use the functions. The output should look like the following image.

![Output of `test.m` showing workflow of modification of Cartesian image by adding a constant theta line in polar coordinates.](test.png)

# Acknowledgements
The code was inspired by
1. [ImToPolar](https://www.mathworks.com/matlabcentral/fileexchange/17933-polar-to-from-rectangular-transform-of-images) by Prakash Manandhar
2. [polartrans.m](https://www.peterkovesi.com/matlabfns/#syntheticimages) by Peter Kovesi
3. [This answer]((https://stackoverflow.com/a/41788184)) by User swjm at Stackoverflow