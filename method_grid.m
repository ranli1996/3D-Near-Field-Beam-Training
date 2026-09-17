function [new_snr,nmse]=method_grid(num_x,num_z,lambda,antenna_coor,aperture_x,aperture_z,noise_power,channel,grid_spacing,y_min,y_max,test_point_coor)
%% NOTE ON SIMULATION ACCELERATION:
% The grid-matching benchmark is theoretically defined over the full 3D
% spatial grid. To reduce simulation time, this implementation evaluates
% only grid points within a sufficiently large neighborhood of the true UE
% position. The true UE position is used only for computational pruning and
% is NOT treated as side information available to the grid-matching method.
%
% The training overhead reported for grid matching is calculated based on
% the full 3D grid (see method_grid_basic.m), rather than the pruned grid
% evaluated here.

% The pruning range was chosen sufficiently large such that enlarging it
% further produces no observable change in the simulated performance.
num_all=num_x*num_z;
%% start
x_low=@(y)-y-aperture_x/2;
x_high=@(y)y+aperture_x/2;
z_low=@(y)-y-aperture_z/2;
z_high=@(y)y+aperture_z/2;

focus_points=zeros(1331,3);
count=0;
scale=5;
y_list=y_min:grid_spacing:y_max;
y_list=y_list(y_list>test_point_coor(2)-grid_spacing*scale);
y_list=y_list(y_list<test_point_coor(2)+grid_spacing*scale);
for y=y_list
    x_list=x_low(y):grid_spacing:x_high(y);
    x_list=x_list(x_list>test_point_coor(1)-grid_spacing*scale);
    x_list=x_list(x_list<test_point_coor(1)+grid_spacing*scale);
    for x=x_list
        z_list=z_low(y):grid_spacing:z_high(y);
        z_list=z_list(z_list>test_point_coor(3)-grid_spacing*scale);
        z_list=z_list(z_list<test_point_coor(3)+grid_spacing*scale);
        for z=z_list
            count=count+1;
            focus_points(count,:)=[x,y,z];
        end
    end
end

best_pilot_power=0;
for k=1:count
    focus_distance=sqrt(sum((focus_points(k,:)-antenna_coor).^2,2));
    focus_word=exp(1j*2*pi*focus_distance'/lambda)/sqrt(num_all);
    pure_pilot=focus_word*channel;
    noise=sqrt(noise_power)*(randn+1j*randn)/sqrt(2);
    pilot_power=pure_pilot+noise;
    if abs(pilot_power)>abs(best_pilot_power)
        best_pilot_power=pilot_power;
        best_pure_power=pure_pilot;
        best_focus_word=focus_word;
    end
end
new_snr=(abs(best_pure_power)^2)/noise_power;
nmse=(norm(best_pure_power/norm(best_focus_word)^2*conj(best_focus_word)-channel.')^2)/(norm(channel)^2);
end