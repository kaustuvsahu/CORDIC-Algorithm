sumWL  = 32; % CORDIC sum word length
thNorm = -1.0:(2^-8):1.0; % Normalized [-1.0, 1.0] angle values
theta  = fi(thNorm, 1, sumWL); % Fixed-point angle values (best precision)

z_NT   = numerictype(theta);             % Data type for Z
xyNT   = numerictype(1, sumWL, sumWL-2); % Data type for X-Y
x_out  = fi(zeros(size(theta)), xyNT);   % X array pre-allocation
y_out  = fi(zeros(size(theta)), xyNT);   % Y array pre-allocation
z_out  = fi(zeros(size(theta)), z_NT);   % Z array pre-allocation

niters = 32; % Number of CORDIC iterations
inpLUT = fi(atan(2 .^ (-((0:(niters-1))'))) .* (2/pi), z_NT); % Normalized
AnGain = prod(sqrt(1+2.^(-2*(0:(niters-1))))); % CORDIC gain
inv_An = 1 / AnGain; % 1/A_n inverse of CORDIC gain

for idx = 1:length(theta)
    % CORDIC rotation kernel iterations
    [x_out(idx), y_out(idx), z_out(idx)] = ...
        cordi(...
            fi(inv_An, xyNT), fi(0, xyNT), theta(idx), inpLUT, niters);
end

% Plot the CORDIC-approximated sine and cosine values
figure;
subplot(411);
plot(thNorm, x_out);
axis([-1 1 -1 1]);
title('Normalized X Values from CORDIC Rotation Kernel Iterations');
subplot(412);
thetaRadians = pi/2 .* thNorm; % real-world range [-pi/2 pi/2] angle values
plot(thNorm, cos(thetaRadians) - double(x_out));
title('Error between MATLAB COS Reference Values and X Values');
subplot(413);
plot(thNorm, y_out);
axis([-1 1 -1 1]);
title('Normalized Y Values from CORDIC Rotation Kernel Iterations');
subplot(414);
plot(thNorm, sin(thetaRadians) - double(y_out));
title('Error between MATLAB SIN Reference Values and Y Values')