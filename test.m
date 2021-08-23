function test()
%{
Demonstrates a full cycle of cart -> pol -> modified pol -> modified cart by
adding a constant-theta line to the polar image, which turns into a circle in
the cartesian image.
%}

%% SETUP
SZ = 150;
RANGE_STEP = 2;

lo = floor(1 * SZ / 4);
hi = ceil(3 * SZ / 4);
lo_range = lo - RANGE_STEP : lo + RANGE_STEP;
hi_range = hi - RANGE_STEP : hi + RANGE_STEP;

fh = figure();
fh.Position(4) = 700;
colormap(fh, gray);

%% CREATE CARTESIAN IMAGE
im_c = false(SZ, SZ);
im_c(lo_range, :) = true;
im_c(:, lo_range) = true;
im_c(hi_range, :) = true;
im_c(:, hi_range) = true;
plot_imagesc(fh, 1, im_c);

%% CONVERT TO POLAR
im_p = im_cart2pol(im_c);
plot_imagesc(fh, 2, im_p);

% cart -> pol
anh = annotation("arrow");
anh.X = [0.213 0.28];
anh.Y = [0.65 0.65];
anh = annotation("textbox");
anh.Position = [0.213 0.64 0.067 0.0];
anh.HorizontalAlignment = "center";
anh.Interpreter = "none";
anh.String = "im_cart2pol()";
anh.EdgeColor = "none";

%% ADD CONSTANT THETA LINE TO POLAR
im_p_mod = im_p;
im_p_mod(lo_range, :) = true;
plot_imagesc(fh, 4, im_p_mod);

% pol -> pol
anh = annotation("arrow");
anh.X = [0.85 0.85];
anh.Y = [0.55 0.3];
anh = annotation("textbox");
anh.Position = [0.85 0.55 0.2 0.0];
anh.HorizontalAlignment = "left";
anh.Interpreter = "none";
anh.String = "add constant theta line";
anh.EdgeColor = "none";

%% CONVERT TO CARTESIAN
im_c_mod = im_pol2cart(im_p_mod, size(im_c));
plot_imagesc(fh, 3, im_c_mod);

% pol -> cart
anh = annotation("arrow");
anh.X = [0.28 0.213];
anh.Y = [0.25 0.25];
anh = annotation("textbox");
anh.Position = [0.213 0.24 0.067 0.0];
anh.HorizontalAlignment = "center";
anh.Interpreter = "none";
anh.String = "im_pol2cart()";
anh.EdgeColor = "none";

% ADJUST FIGURE
fh.Position = [50 50 1100 700];

end


function plot_imagesc(fh, p, im)

axh = subplot(2, 2, p, "parent", fh);
imagesc(axh, im);
axh.XLim(2) = size(im, 2);
axh.YLim(2) = size(im, 1);
axh.DataAspectRatio = [1 1 1];
axh.PlotBoxAspectRatio = [1 1 1];
axh.Units = "pixels";
axh.Position([4, 3]) = size(im);
axh.Visible = "off";

end
