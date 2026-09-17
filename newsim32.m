clear;
disp(datetime('now'));
tic;
%% Hyperparameters
test_point_num=1e4;

%% Basic setting
num_x=16;
num_z=32;
M=8;
y_min=1.25;
y_max=7.5;
refine_length=5;
grid_spacing=1/2;

%% System setting
c=3e8;
frequency=28e9;
lambda=c/frequency;
spacing=lambda/2;
aperture_x=spacing*(num_x-1);
aperture_z=spacing*(num_z-1);
aperture=sqrt(aperture_x^2+aperture_z^2);
y_low=0.62*sqrt(aperture^3/lambda);
y_high=2*aperture^2/lambda;
y_list=2^(M-1)./(2*(1:10)-1)*min(aperture_x,aperture_z);
y_list_index=1:2:3;

%% SNR setting
noise_power=1e-10;
rician_factor=19.95; % 13 dB
nlos_num=6;

%% Antenna elements
antenna_coor=zeros(num_x*num_z,3);
for x=1:num_x
    for z=1:num_z
        count=num_z*(x-1)+z;
        antenna_coor(count,1)=spacing*(x-(num_x+1)/2);
        antenna_coor(count,3)=spacing*(z-(num_z+1)/2);
    end
end

%% Point boundary
% grid_count=method_grid_basic(aperture_x,aperture_z,grid_spacing,y_min,y_max);

%% Simulation
snr_list=linspace(5,45,15);
new_snr_list=zeros(length(snr_list),7);
count_list=zeros(length(snr_list),7);
nmse_list=zeros(length(snr_list),7);
parfor index=1:length(snr_list)
    snr_list_tem=zeros(1,7);
    count_list_tem=zeros(1,7);
    nmse_list_tem=zeros(1,7);
    snr=snr_list(index);
    signal_sum_power=noise_power*10^(snr/10);% 13 dB
    los_power=signal_sum_power*(rician_factor/(1+rician_factor));
    nlos_power=signal_sum_power*(1/(1+rician_factor))/nlos_num;
    for i=1:test_point_num
        while 1
            y_coor=(y_max-y_min)*rand+y_min;
            x_coor=(2*rand-1)*y_max;
            z_coor=(2*rand-1)*y_max;
            if x_coor>=-y_coor && x_coor<=y_coor && z_coor>=-y_coor && z_coor<=y_coor
                break;
            end
        end
        test_point_coor=[x_coor,y_coor,z_coor];
    
        real_distance=sqrt(sum((test_point_coor-antenna_coor).^2,2));
        channel_phase=exp(-1j*2*pi*real_distance/lambda);
        los_channel=sqrt(los_power)*channel_phase;
        channel=los_channel;
        for nlos_index=1:nlos_num
            nlos_y_coor=y_min+(y_max-y_min)*rand;
            nlos_x_coor=(2*rand-1)*y_max;
            nlos_z_coor=(2*rand-1)*y_max;
            nlos_point_coor=[nlos_x_coor,nlos_y_coor,nlos_z_coor];
            nlos_distance=sqrt(sum((nlos_point_coor-antenna_coor).^2,2));
            nlos_channel=sqrt(nlos_power)*exp(-1j*2*pi*nlos_distance/lambda);
            channel=channel+nlos_channel;
        end

        [new_snr,count,nmse]=method_mirror_2_phase(num_x,num_z,M,lambda,antenna_coor,aperture_x,aperture_z,noise_power,channel,y_list,y_list_index);
        snr_list_tem(1)=snr_list_tem(1)+new_snr;
        count_list_tem(1)=count_list_tem(1)+count;
        nmse_list_tem(1)=nmse_list_tem(1)+nmse;
        
        [new_snr,count,nmse]=method_mirror_3_phase(num_x,num_z,M,lambda,antenna_coor,aperture_x,aperture_z,noise_power,channel,y_list,y_list_index);
        snr_list_tem(2)=snr_list_tem(2)+new_snr;
        count_list_tem(2)=count_list_tem(2)+count;
        nmse_list_tem(2)=nmse_list_tem(2)+nmse;

        [new_snr,count,nmse]=method_partition(num_x,num_z,M,lambda,antenna_coor,noise_power,channel,y_list,y_list_index,refine_length);
        snr_list_tem(3)=snr_list_tem(3)+new_snr;
        count_list_tem(3)=count_list_tem(3)+count;
        nmse_list_tem(3)=nmse_list_tem(3)+nmse;

        [new_snr,count,nmse]=method_sparse(num_x,num_z,M,lambda,antenna_coor,noise_power,channel,y_list,y_list_index,refine_length);
        snr_list_tem(4)=snr_list_tem(4)+new_snr;
        count_list_tem(4)=count_list_tem(4)+count;
        nmse_list_tem(4)=nmse_list_tem(4)+nmse;

        [new_snr,count,nmse]=method_dft(num_x,num_z,M,lambda,antenna_coor,noise_power,channel,y_list,y_list_index,refine_length);
        snr_list_tem(5)=snr_list_tem(5)+new_snr;
        count_list_tem(5)=count_list_tem(5)+count;
        nmse_list_tem(5)=nmse_list_tem(5)+nmse;

        [new_snr,nmse]=method_grid(num_x,num_z,lambda,antenna_coor,aperture_x,aperture_z,noise_power,channel,grid_spacing,y_min,y_max+5,test_point_coor);
        snr_list_tem(6)=snr_list_tem(6)+new_snr;
        nmse_list_tem(6)=nmse_list_tem(6)+nmse;

        [new_snr,nmse]=method_grid(num_x,num_z,lambda,antenna_coor,aperture_x,aperture_z,noise_power,channel,grid_spacing/2,y_min,y_max+5,test_point_coor);
        snr_list_tem(7)=snr_list_tem(7)+new_snr;
        nmse_list_tem(7)=nmse_list_tem(7)+nmse;
    end
    new_snr_list(index,:)=snr_list_tem;
    count_list(index,:)=count_list_tem;
    nmse_list(index,:)=nmse_list_tem;
end
new_snr_list=10*log10(new_snr_list/test_point_num);
count_list=count_list/test_point_num;
nmse_list=10*log10(nmse_list/test_point_num);
save('data32.mat','snr_list','new_snr_list','count_list','nmse_list','test_point_num','num_x','num_z','M','y_min','y_max','grid_spacing');
toc;

