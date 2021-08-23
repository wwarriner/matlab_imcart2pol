function im_cart = im_pol2cart(im_pol, sz_cart, origin, interp_method)
%{
Converts an image from polar coordinates to cartesian coordinates. Intended for
use with the output of a call to im_cart2pol(). Not designed for other uses and
results not guaranteed.

Performs inverse transformation of im_cart2pol(). Some distortion and artifacts
are possible, especially starting with a thin (single pixel) line.

Inputs:
1. im_pol (2D image-like array) - Image in cartesian coordinate system.
2. sz_cart (2-vector integer-like) - Size of desired cartesian image, intended
to be identical to the size of the im_cart passed to im_cart2pol().
3. origin (optional 2-vector double, default sz_cart center) - Origin coordinates of transformation, in [1, size(im_cart)],
intended to be identical to that passed to im_cart2pol(). Empty array is replaced
with default.
3. interp_method (optional string, default "makima") - Method passed to
interp2.

Outputs:
1. im_cart (2D image-like array) - Image in polar coordinate system. Intended to
be used from im_cart2pol(), results not guaranteed and interface not designed
for other uses.

Inspired by PolarToIm by Prakash Manandhar pmanandhar@umassd.edu
Original: https://www.mathworks.com/matlabcentral/fileexchange/17933-polar-to-from-rectangular-transform-of-images

Adapted from work by user swjm at https://stackoverflow.com/a/41788184

Dev notes:
Hungarian notation
1. *_c is spatial coordinates
2. *_i is pixel indices
%}

if nargin < 3
    origin = [];
end

if nargin < 4
    interp_method = "makima";
end

sz_polar = size(im_pol);
if isempty(origin)
    origin = sz_cart ./ 2;
end

assert(isnumeric(im_pol) | islogical(im_pol));

assert(numel(sz_cart) == 2);
assert(isnumeric(sz_cart));
assert(all(fix(sz_cart) == sz_cart));
assert(all(0 < sz_cart));

assert(numel(origin) == 2);
assert(isnumeric(origin))
assert(isreal(origin));
assert(all(isfinite(origin)));
assert(all(0 < origin));

interp_method = string(interp_method);
assert(isscalar(interp_method));
assert(isstring(interp_method));

origin_c = origin;

[r_max_c, t_max_c] = compute_max_c(origin_c, sz_cart);
x_basis_i = 1 : sz_cart(2);
x_basis_c = (x_basis_i - origin_c(2)) ./ r_max_c;
y_basis_i = 1 : sz_cart(1);
y_basis_c = (y_basis_i - origin_c(1)) ./ r_max_c;
[x_c, y_c] = meshgrid(x_basis_c, y_basis_c);

t_basis_c = 1 : sz_polar(2);
r_basis_c = 1 : sz_polar(1);
[r_c, t_c] = meshgrid(r_basis_c, t_basis_c);

[r_i_to_c, t_i_to_c] = compute_i_to_c(r_max_c, t_max_c);
r_query_i = sqrt(x_c.^2 + y_c.^2);
r_query_c = r_query_i ./ r_i_to_c;
t_query_i = atan2(y_c, x_c) + pi;
t_query_c = t_query_i ./ t_i_to_c;
im_cart = interp2(r_c, t_c, double(im_pol).', r_query_c, t_query_c, interp_method);

im_cart = fix_output_type(im_pol, im_cart, 0.5);

assert(strcmp(class(im_cart), class(im_pol)));

end
