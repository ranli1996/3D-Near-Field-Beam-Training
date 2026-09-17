function grid_count=method_grid_basic(aperture_x,aperture_z,grid_spacing,y_min,y_max)
% This function counts the number of beams over the FULL 3D grid and is
% used to evaluate the training overhead of the grid-matching benchmark.
% The local pruning in method_grid.m is only used to accelerate simulation.
x_low=@(y)-y-aperture_x/2;
x_high=@(y)y+aperture_x/2;
z_low=@(y)-y-aperture_z/2;
z_high=@(y)y+aperture_z/2;

grid_count=0;
for y=y_min:grid_spacing:y_max
    for x=x_low(y):grid_spacing:x_high(y)
        for z=z_low(y):grid_spacing:z_high(y)
            grid_count=grid_count+1;
        end
    end
end
end