function [new_snr,count,nmse]=method_partition(num_x,num_z,M,lambda,antenna_coor,noise_power,channel,y_list,y_list_index,refine_length)
num_all=num_x*num_z;
%% Phase I-1
x_indices=ones(M+1,1);
partition_words=zeros(2,num_all);
for m=1:(log2(num_x)-1)
    partition_words(:)=0;
    x_index_1=2^(log2(num_x)-m)*(2*x_indices(m)-2)+1;
    x_index_2=2^(log2(num_x)-m)*(2*x_indices(m)-1);
    x_index_3=2^(log2(num_x)-m)*(2*x_indices(m)-1)+1;
    x_index_4=2^(log2(num_x)-m)*(2*x_indices(m));
    for part_1_index=x_index_1:x_index_2
        sin_theta=(2*part_1_index-1)/num_x-1;
        partition_words(1,(1:num_z)+num_z*(part_1_index-1))=exp(-1j*pi*sin_theta*(1:num_z))/sqrt(num_all/2^m);
    end
    for part_2_index=x_index_3:x_index_4
        sin_theta=(2*part_2_index-1)/num_x-1;
        partition_words(2,(1:num_z)+num_z*(part_2_index-1))=exp(-1j*pi*sin_theta*(1:num_z))/sqrt(num_all/2^m);
    end
    pure_pilot=partition_words*channel;
    noise=sqrt(noise_power)*(randn(2,1)+1j*randn(2,1))/sqrt(2);
    pilot_power_index=abs(pure_pilot+noise);
    [~,max_index]=max(pilot_power_index);
    x_indices(m+1)=2*(x_indices(m)-1)+max_index;
end
for m=log2(num_x):M
    partition_words(:)=0;
    part_1_index=2*x_indices(m)-1;
    part_2_index=2*x_indices(m);
    sin_theta=(2*part_1_index-1)/(2^m)-1;
    partition_words(1,(1:num_z)+num_all/2)=exp(-1j*pi*sin_theta*(1:num_z))/sqrt(num_z);
    sin_theta=(2*part_2_index-1)/(2^m)-1;
    partition_words(2,(1:num_z)+num_all/2)=exp(-1j*pi*sin_theta*(1:num_z))/sqrt(num_z);
    pure_pilot=partition_words*channel;
    noise=sqrt(noise_power)*(randn(2,1)+1j*randn(2,1))/sqrt(2);
    pilot_power_index=abs(pure_pilot+noise);
    [~,max_index]=max(pilot_power_index);
    x_indices(m+1)=2*(x_indices(m)-1)+max_index;
end
%% Phase I-2
z_indices=ones(M+1,1);
partition_words=zeros(2,num_all);
for m=1:(log2(num_z)-1)
    partition_words(:)=0;
    z_index_1=2^(log2(num_z)-m)*(2*z_indices(m)-2)+1;
    z_index_2=2^(log2(num_z)-m)*(2*z_indices(m)-1);
    z_index_3=2^(log2(num_z)-m)*(2*z_indices(m)-1)+1;
    z_index_4=2^(log2(num_z)-m)*(2*z_indices(m));
    for part_1_index=z_index_1:z_index_2
        sin_theta=(2*part_1_index-1)/num_z-1;
        partition_words(1,(1:num_z:num_all)+part_1_index-1)=exp(-1j*pi*sin_theta*(1:num_x))/sqrt(num_all/2^m);
    end
    for part_2_index=z_index_3:z_index_4
        sin_theta=(2*part_2_index-1)/num_z-1;
        partition_words(2,(1:num_z:num_all)+part_2_index-1)=exp(-1j*pi*sin_theta*(1:num_x))/sqrt(num_all/2^m);
    end
    pure_pilot=partition_words*channel;
    noise=sqrt(noise_power)*(randn(2,1)+1j*randn(2,1))/sqrt(2);
    pilot_power_index=abs(pure_pilot+noise);
    [~,max_index]=max(pilot_power_index);
    z_indices(m+1)=2*(z_indices(m)-1)+max_index;
end
for m=log2(num_z):M
    partition_words(:)=0;
    part_1_index=2*z_indices(m)-1;
    part_2_index=2*z_indices(m);
    sin_theta=(2*part_1_index-1)/(2^m)-1;
    partition_words(1,(1:num_z:num_all)+num_z/2)=exp(-1j*pi*sin_theta*(1:num_x))/sqrt(num_x);
    sin_theta=(2*part_2_index-1)/(2^m)-1;
    partition_words(2,(1:num_z:num_all)+num_z/2)=exp(-1j*pi*sin_theta*(1:num_x))/sqrt(num_x);
    pure_pilot=partition_words*channel;
    noise=sqrt(noise_power)*(randn(2,1)+1j*randn(2,1))/sqrt(2);
    pilot_power_index=abs(pure_pilot+noise);
    [~,max_index]=max(pilot_power_index);
    z_indices(m+1)=2*(z_indices(m)-1)+max_index;
end
%% Identification codes
% real_x=test_point_coor(1)/norm(test_point_coor);
% real_z=test_point_coor(3)/norm(test_point_coor);
% est_x=(2*x_indices(M+1)-1)/2^M-1;
% est_z=(2*z_indices(M+1)-1)/2^M-1;
% NMSE=abs(real_x-est_x)+abs(real_z-est_z);

%% Phase II

estimate_sin_z=min(sqrt(2)/2,max(-sqrt(2)/2,(2*x_indices(M+1)-1)/2^M-1));%% direction should be replaced
estimate_sin_x=min(sqrt(2)/2,max(-sqrt(2)/2,(2*z_indices(M+1)-1)/2^M-1));
estimate_x=estimate_sin_x;
estimate_z=estimate_sin_z;
estimate_y=sqrt(1-estimate_x^2-estimate_z^2);
estimate_point=[estimate_x,estimate_y,estimate_z];

estimate_x_tan=estimate_point(1)/estimate_point(2);
estimate_z_tan=estimate_point(3)/estimate_point(2);
estimate_x_index=round(((estimate_x_tan+1)*(2^M)+1)/2);
estimate_z_index=round(((estimate_z_tan+1)*(2^M)+1)/2);

x_index=min(2^M,max(1,estimate_x_index));
z_index=min(2^M,max(1,estimate_z_index));
best_pilot_power=0;
count=0;
for k=y_list_index
    y_value=y_list(k);
    for x_angle=max(1,x_index-refine_length):min(2^M,x_index+refine_length)
        for z_angle=max(1,z_index-refine_length):min(2^M,z_index+refine_length)
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