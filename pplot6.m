load('data61.mat');
figure
hold on;
snr_bound=snr_list+10*log10(num_x*num_z);
new_snr_list=snr_bound'*ones(1,8)-new_snr_list;
new_snr_list=new_snr_list.^(1/10);
plot(snr_list,new_snr_list(:,1),'-ro','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,2),'-rs','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,3),'-r*','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,4),'-r<','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,5),'-bo','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,6),'-bs','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,7),'-b*','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,8),'-b<','MarkerSize', 10,'LineWidth', 1.5);
legend('Two-phase method with \epsilon=0','Two-phase method with \epsilon=0.25','Two-phase method with \epsilon=0.50','Two-phase method with \epsilon=0.75',...
    'Three-phase method with \epsilon=0','Three-phase method with \epsilon=0.25','Three-phase method with \epsilon=0.50','Three-phase method with \epsilon=0.75');
xlabel('Reference SNR (dB)');
ylabel('SNR Loss (dB)');
set(gca, 'linewidth', 1.5, 'fontsize', 15, 'fontname', 'Times New Roman', 'GridLineStyle', '--');
grid on;
box on;
xticks(0:10:50);
yticks(nthroot([0.2, 0.3, 0.4, 1, 2],10));
yticklabels({'0.2', '0.3', '0.4', '1', '2'});
axis([5,45,0.2^(1/10),2^(1/10)]);