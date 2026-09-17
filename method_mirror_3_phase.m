function [new_snr,count,nmse]=method_mirror_3_phase(num_x,num_z,M,lambda,antenna_coor,aperture_x,aperture_z,noise_power,channel,y_list,y_list_index)
num_all=num_x*num_z;
%% Phase I-1
x_indices=ones(M+1,1);
virutal_points=zeros(2,3);
mirror_words=zeros(2,num_all);
pilot_power_index=zeros(2,2);
for m=1:M
    for x=1:2
        x_index=2*x_indices(m,1)+x-2;
        virutal_points(x,:)=[(2*x_index-2^m-1)/2*aperture_x,-2^(m-1)*aperture_x,0];
        virtual_distance=sqrt(sum((virutal_points(x,:)-antenna_coor).^2,2));
        tem_word=exp(-1j*2*pi*virtual_distance'/lambda)/sqrt(num_x);
        mirror_words(x,((1:num_z:end)+num_z/2-1))=tem_word((1:num_z:end)+num_z/2-1);
        pure_pilot=mirror_words(x,:)*channel;
        noise=sqrt(noise_power)*(randn+1j*randn)/sqrt(2);
        pilot_power_index(x,1)=abs(pure_pilot+noise);
        pilot_power_index(x,2)=x_index;
    end
    [~,max_index]=max(pilot_power_index(:,1));
    x_indices(m+1)=pilot_power_index(max_index,2);
end
virtual_point_x=virutal_points(max_index,:);

%% Phase I-2
z_indices=ones(M+1,1);
virutal_points=zeros(2,3);
mirror_words=zeros(2,num_all);
pilot_power_index=zeros(2,2);
for m=1:M
    for z=1:2
        z_index=2*z_indices(m,1)+z-2;
        virutal_points(z,:)=[0,-2^(m-1)*aperture_z,(2*z_index-2^m-1)/2*aperture_z];
        virtual_distance=sqrt(sum((virutal_points(z,:)-antenna_coor).^2,2));
        tem_word=exp(-1j*2*pi*virtual_distance'/lambda)/sqrt(num_z);
        mirror_words(z,((1:num_z)+num_z*(num_x/2-1)))=tem_word((1:num_z)+num_z*(num_x/2-1));
        pure_pilot=mirror_words(z,:)*channel;
        noise=sqrt(noise_power)*(randn+1j*randn)/sqrt(2);
        pilot_power_index(z,1)=abs(pure_pilot+noise);
        pilot_power_index(z,2)=z_index;
    end
    [~,max_index]=max(pilot_power_index(:,1));
    z_indices(m+1)=pilot_power_index(max_index,2);
end
virtual_point_z=virutal_points(max_index,:);

%% Phase II-1: estimate angles
estimate_x_sin=virtual_point_x(1)/norm(virtual_point_x);
estimate_z_sin=virtual_point_z(3)/norm(virtual_point_z);
estimate_point=[-estimate_x_sin,sqrt(1-estimate_x_sin^2-estimate_z_sin^2),-estimate_z_sin];
estimate_x_tan=estimate_point(1)/estimate_point(2);
estimate_z_tan=estimate_point(3)/estimate_point(2);
estimate_x_index=min(2^M,max(1,round(((estimate_x_tan+1)*(2^M)+1)/2)));
estimate_z_index=min(2^M,max(1,round(((estimate_z_tan+1)*(2^M)+1)/2)));

estimate_x_sin_neg=-(virtual_point_x(1)-(-aperture_x/2))/norm(virtual_point_x-[-aperture_x/2,0,0]);
estimate_x_sin_pos=-(virtual_point_x(1)-aperture_x/2)/norm(virtual_point_x-[aperture_x/2,0,0]);
estimate_z_sin_neg=-(virtual_point_z(3)-(-aperture_z/2))/norm(virtual_point_z-[0,0,-aperture_z/2]);
estimate_z_sin_pos=-(virtual_point_z(3)-aperture_z/2)/norm(virtual_point_z-[0,0,aperture_z/2]);


%% Phase II_2: refinement
% Computational pre-screening for Phase III:
% Only a local angular window is checked before applying the geometric
% intersection condition below. pre_length is chosen sufficiently large
% to cover the entire feasible refinement region under the simulated
% system settings; it does not provide additional UE-location information.
best_pilot_power=0;
count=0;
pre_length=10;
pre_length = 10;
for k=y_list_index
    y_value=y_list(k);
    iden_matrix=zeros(min(2^M,estimate_x_index+pre_length)-max(1,estimate_x_index-pre_length)+1,min(2^M,estimate_z_index+pre_length)-max(1,estimate_z_index-pre_length)+1);
    for tem_x=1:(min(2^M,estimate_x_index+pre_length)-max(1,estimate_x_index-pre_length)+1)
        for tem_z=1:(min(2^M,estimate_z_index+pre_length)-max(1,estimate_z_index-pre_length)+1)
            x_angle=max(1,estimate_x_index-pre_length)-1+tem_x;
            z_angle=max(1,estimate_z_index-pre_length)-1+tem_z;
            focus_point=[((2*x_angle-1)/2^M-1)*y_value,y_value,((2*z_angle-1)/2^M-1)*y_value];
            x_sin_neg=(focus_point(1)-(-aperture_x/2))/norm(focus_point-[-aperture_x/2,0,0]);
            x_sin_pos=(focus_point(1)-(aperture_x/2))/norm(focus_point-[aperture_x/2,0,0]);
            z_sin_neg=(focus_point(3)-(-aperture_z/2))/norm(focus_point-[0,0,-aperture_z/2]);
            z_sin_pos=(focus_point(3)-(aperture_z/2))/norm(focus_point-[0,0,aperture_z/2]);
            if x_sin_neg>=estimate_x_sin_neg && x_sin_pos<=estimate_x_sin_pos && ...
                z_sin_neg>=estimate_z_sin_neg && z_sin_pos<=estimate_z_sin_pos
                iden_matrix(tem_x,tem_z)=1;
            end
        end
    end
    % iden_matrix_up=[iden_matrix(2:end,:);iden_matrix(1,:)];
    % iden_matrix_down=[iden_matrix(end,:);iden_matrix(1:end-1,:)];
    % iden_matrix_left=[iden_matrix(:,2:end),iden_matrix(:,1)];
    % iden_matrix_right=[iden_matrix(:,end),iden_matrix(:,1:end-1)];
    % iden_matrix=iden_matrix_up+iden_matrix_down+iden_matrix_left+iden_matrix_right;
    if sum(sum(iden_matrix))==0
        tem1=max(1,estimate_x_index-pre_length);
        tem2=estimate_x_index-tem1+1;
        tem3=max(1,estimate_z_index-pre_length);
        tem4=estimate_z_index-tem3+1;
        iden_matrix(tem2,tem4)=1;
    end
    for tem_x=1:(min(2^M,estimate_x_index+pre_length)-max(1,estimate_x_index-pre_length)+1)
        for tem_z=1:(min(2^M,estimate_z_index+pre_length)-max(1,estimate_z_index-pre_length)+1)
            if iden_matrix(tem_x,tem_z)>0
                x_angle=max(1,estimate_x_index-pre_length)-1+tem_x;
                z_angle=max(1,estimate_z_index-pre_length)-1+tem_z;
                focus_point=[((2*x_angle-1)/2^M-1)*y_value,y_value,((2*z_angle-1)/2^M-1)*y_value];
                count=count+1;
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
end
new_snr=(abs(best_pure_power)^2)/noise_power;
nmse=(norm(best_pure_power/norm(best_focus_word)^2*conj(best_focus_word)-channel.')^2)/(norm(channel)^2);
end