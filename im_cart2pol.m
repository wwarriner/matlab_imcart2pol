function im_pol = im_cart2pol(im_cart, origin, interp_method)
%{
Converts an image from cartesian coordinates to polar coordinates.

The output image will expand to fit the entirety of the Cartesian coordinates. It does this
by computing the largest distance from origin to any pixel and setting that
value as the radial axis size. The theta axis size is, naturally, 2pi times
the radial axis size.

Rectifying a circular grid always induces distortion. Using interp2 with
'makima' does a reasonably good job, even with logical images. Be aware that a
full cycle from cart -> pol -> cart may introduce artifacts, especially in
logical images with thin (single pixel) lines.

Inputs:
1. im_cart (2D image-like array) - Image in cartesian coordinate system.
2. origin (optional 2-vector double, default im_cart center) - Origin
coordinates of transformation, in [1, size(im_cart)]. Empty array is replaced
with default.
3. interp_method (optional string, default "makima") - Method passed to
interp2.

Outputs:
1. im_pol (2D image-like array) - Image in polar coordinate system. Tries to
fit the entire input image into the output by computing largest radius from the
center. There may significant extraneous nan data depending on the position of
the center.

Inspired by ImToPolar by Prakash Manandhar pmanandhar@umassd.edu
Original: https://www.mathworks.com/matlabcentral/fileexchange/17933-polar-to-from-rectangular-transform-of-images

Adapted from polartrans.m by Peter Kovesi at
https://www.peterkovesi.com/matlabfns/#syntheticimages

Dev notes:
Hungarian notation
1. *_c is spatial coordinates
2. *_i is pixel indices
%}

if nargin < 2
    origin = [];
end

if nargin < 3
    interp_method = "makima";
end

sz_cart = size(im_cart);
if isempty(origin)
    origin = sz_cart ./ 2;
end

assert(isnumeric(im_cart) | islogical(im_cart));

assert(numel(origin) == 2);
assert(isnumeric(origin))
assert(isreal(origin));
assert(all(isfinite(origin)));
assert(all(0 < origin));

interp_method = string(interp_method);
assert(isscalar(interp_method));
assert(isstring(interp_method));

origin_c = origin;

x_basis_c = 1 : sz_cart(2);
y_basis_c = 1 : sz_cart(1);
[x_c, y_c] = meshgrid(x_basis_c, y_basis_c);

[r_max_c, t_max_c] = compute_max_c(origin_c, sz_cart);
sz_pol = ceil([r_max_c, t_max_c]);
[r_i_to_c, t_i_to_c] = compute_i_to_c(r_max_c, t_max_c);
t_basis_i = 1 : sz_pol(2);
t_basis_c = t_basis_i .* t_i_to_c;
r_basis_i = 1 : sz_pol(1);
r_basis_c = r_basis_i .* r_i_to_c;
[t_c, r_c] = meshgrid(t_basis_c, r_basis_c);

x_query_c = r_c .* cos(t_c) .* r_max_c + origin_c(2);
y_query_c = r_c .* sin(t_c) .* r_max_c + origin_c(1);
im_pol = interp2(x_c, y_c, double(im_cart), x_query_c, y_query_c, interp_method);

im_pol = fix_output_type(im_cart, im_pol, 0.5);

assert(strcmp(class(im_pol), class(im_cart)));

end
