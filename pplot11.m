load('data11.mat');
mean(count_list)
figure
hold on;
y_list=y_min+(y_max-y_min)*y_sample_list;
snr_bound=snr+10*log10(num_x*num_z);
delta_snr=snr_bound-new_snr_list;%
delta_snr=delta_snr.^(1/10);
plot(y_list,delta_snr(:,1),'-ro','MarkerSize', 10,'LineWidth', 1.5);
plot(y_list,delta_snr(:,2),'-bs','MarkerSize', 10,'LineWidth', 1.5);
plot(y_list,delta_snr(:,3),'-k^','MarkerSize', 10,'LineWidth', 1.5);
plot(y_list,delta_snr(:,4),'-v','Color',[0.62, 0.28, 0.360],'MarkerSize', 10,'LineWidth', 1.5);
plot(y_list,delta_snr(:,5),'-*','Color',[0.8, 0.6, 0.1],'MarkerSize', 10,'LineWidth', 1.5);
plot(y_list,delta_snr(:,6),'-m<','MarkerSize', 10,'LineWidth', 1.5);
plot(y_list,delta_snr(:,7),'-m>','MarkerSize', 10,'LineWidth', 1.5);
legend('Proposed two-phase method','Proposed three-phase method','UPA partitioning','ULA-based hierarchical DFT','ULA-based DFT Sweeping','Grid matching with spacing as 1 m','Grid matching with spacing as 0.5 m');
xlabel('Distance (m)');
ylabel('SNR Loss (dB)');
set(gca, 'linewidth', 1.5, 'fontsize', 15, 'fontname', 'Times New Roman', 'GridLineStyle', '--');
grid on;
box on;
xticks(0:10:50);
yticks(nthroot([0.2, 0.3, 0.4, 1, 3, 4],10));
yticklabels({'0.2', '0.3', '0.4','1', '3','4'});
axis([7.5,45,0.2^(1/10),4^(1/10)]);


load('data12.mat');
mean(count_list)
figure
hold on;
y_list=y_min+(y_max-y_min)*y_sample_list;
snr_bound=snr+10*log10(num_x*num_z);
delta_snr=snr_bound-new_snr_list;
delta_snr=delta_snr.^(1/10);
plot(y_list,delta_snr(:,1),'-ro','MarkerSize', 10,'LineWidth', 1.5);
plot(y_list,delta_snr(:,2),'-bs','MarkerSize', 10,'LineWidth', 1.5);
plot(y_list,delta_snr(:,3),'-k^','MarkerSize', 10,'LineWidth', 1.5);
plot(y_list,delta_snr(:,4),'-v','Color',[0.62, 0.28, 0.360],'MarkerSize', 10,'LineWidth', 1.5);
plot(y_list,delta_snr(:,5),'-*','Color',[0.8, 0.6, 0.1],'MarkerSize', 10,'LineWidth', 1.5);
plot(y_list,delta_snr(:,6),'-m<','MarkerSize', 10,'LineWidth', 1.5);
plot(y_list,delta_snr(:,7),'-m>','MarkerSize', 10,'LineWidth', 1.5);
legend('Proposed two-phase method','Proposed three-phase method','UPA partitioning','ULA-based hierarchical DFT','ULA-based DFT Sweeping','Grid matching with spacing as 1 m','Grid matching with spacing as 0.5 m');
xlabel('Distance (m)');
ylabel('SNR Loss (dB)');
set(gca, 'linewidth', 1.5, 'fontsize', 15, 'fontname', 'Times New Roman', 'GridLineStyle', '--');
grid on;
box on;
xticks(0:10:50);
yticks(nthroot([0.2, 0.3, 0.4, 1, 3, 4],10));
yticklabels({'0.2', '0.3', '0.4','1', '3','4'});
axis([7.5,45,0.2^(1/10),4^(1/10)]);
