function [new_snr,count,nmse]=method_mirror_2_phase(num_x,num_z,M,lambda,antenna_coor,aperture_x,aperture_z,noise_power,channel,y_list,y_list_index)
aperture_min=min(aperture_x,aperture_z);
num_all=num_x*num_z;
%% Phase I
xz_indices=ones(M+1,2);
virutal_points=zeros(4,3);
mirror_words=zeros(4,num_all);
pilot_power_index=zeros(4,3);
for m=1:M
    for x=1:2
        for z=1:2
            x_index=2*xz_indices(m,1)+x-2;
            z_index=2*xz_indices(m,2)+z-2;
            point_index=2*(x-1)+z;
            virutal_points(point_index,:)=[(2*x_index-2^m-1)/2*aperture_x,-2^(m-1)*aperture_min,(2*z_index-2^m-1)/2*aperture_z];
            virtual_distance=sqrt(sum((virutal_points(point_index,:)-antenna_coor).^2,2));
            mirror_words(point_index,:)=exp(-1j*2*pi*virtual_distance'/lambda)/sqrt(num_all);
            pure_pilot=mirror_words(point_index,:)*channel;
            noise=sqrt(noise_power)*(randn+1j*randn)/sqrt(2);
            pilot_power_index(point_index,1)=abs(pure_pilot+noise);
            pilot_power_index(point_index,2)=x_index;
            pilot_power_index(point_index,3)=z_index;
        end
    end
    [~,max_index]=max(pilot_power_index(:,1));
    xz_indices(m+1,1)=pilot_power_index(max_index,2);
    xz_indices(m+1,2)=pilot_power_index(max_index,3);
end

%% Identification codes
% estimate_point=virutal_points(max_index,:);
% x_proj_low=(-aperture_xz/2-estimate_point(1))*test_point_coor(2)/(-estimate_point(2))-aperture_xz/2;
% x_proj_high=(aperture_xz/2-estimate_point(1))*test_point_coor(2)/(-estimate_point(2))+aperture_xz/2;
% z_proj_low=(-aperture_xz/2-estimate_point(3))*test_point_coor(2)/(-estimate_point(2))-aperture_xz/2;
% z_proj_high=(aperture_xz/2-estimate_point(3))*test_point_coor(2)/(-estimate_point(2))+aperture_xz/2;
% if test_point_coor(1)>=x_proj_low && test_point_coor(1)<=x_proj_high && test_point_coor(3)>=z_proj_low && test_point_coor(3)<=z_proj_high
%     NMSE=1;
% else
%     NMSE=0;
% end

%% Phase II
x_index=xz_indices(M+1,1);
z_index=xz_indices(M+1,2);
f_x=(aperture_min+aperture_x)*(2^M+1)/2/aperture_min-aperture_x/aperture_min*x_index;
f_z=(aperture_min+aperture_z)*(2^M+1)/2/aperture_min-aperture_z/aperture_min*z_index;
x_real_index=min(2^M,max(1,f_x));
z_real_index=min(2^M,max(1,f_z));

best_pilot_power=0;
count=0;
for k=y_list_index
    thinner_k=k-1;
    y_value=y_list(k);
    for x_angle=max(1,x_real_index-thinner_k*(aperture_x/aperture_min)):min(2^M,x_real_index+thinner_k*(aperture_x/aperture_min))
        for z_angle=max(1,z_real_index-thinner_k*(aperture_z/aperture_min)):min(2^M,z_real_index+thinner_k*(aperture_z/aperture_min))
            count=count+1;
            focus_point=[((2*x_angle-1)/2^M-1)*y_value,y_value,((2*z_angle-1)/2^M-1)*y_value];
            focus_distance=sqrt(sum((focus_point-antenna_coor).^2,2));
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
    end
end
new_snr=(abs(best_pure_power)^2)/noise_power;
nmse=(norm(best_pure_power/norm(best_focus_word)^2*conj(best_focus_word)-channel.')^2)/(norm(channel)^2);
end