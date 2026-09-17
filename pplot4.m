load('data41.mat');
mean(count_list)
figure
hold on;
snr_bound=snr_list+10*log10(num_x*num_z);
new_snr_list=snr_bound'*ones(1,7)-new_snr_list;
new_snr_list=new_snr_list.^(1/10);
plot(snr_list,new_snr_list(:,1),'-ro','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,2),'-bs','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,3),'-k^','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,4),'-v','Color',[0.62, 0.28, 0.360],'MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,5),'-*','Color',[0.8, 0.6, 0.1],'MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,6),'-m<','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,7),'-m>','MarkerSize', 10,'LineWidth', 1.5);
legend('Proposed two-phase method','Proposed three-phase method','UPA partitioning','ULA-based hierarchical DFT','ULA-based DFT Sweeping','Grid matching with spacing as 1 m','Grid matching with spacing as 1/2 m');
xlabel('Reference SNR (dB)');
ylabel('NMSE (dB)');
set(gca, 'linewidth', 1.5, 'fontsize', 15, 'fontname', 'Times New Roman', 'GridLineStyle', '--');
grid on;
box on;
xticks(0:10:50);
yticks(nthroot([0.2, 0.3, 0.4, 1, 3, 4],10));
yticklabels({'0.2', '0.3', '0.4', '1', '3', '4'});
axis([5,45,0.2^(1/10),4^(1/10)]);

load('data42.mat');
mean(count_list)
figure
hold on;
snr_bound=snr_list+10*log10(num_x*num_z);
test_snr=new_snr_list;
new_snr_list=snr_bound'*ones(1,7)-new_snr_list;
new_snr_list=new_snr_list.^(1/10);
plot(snr_list,new_snr_list(:,1),'-ro','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,2),'-bs','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,3),'-k^','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,4),'-v','Color',[0.62, 0.28, 0.360],'MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,5),'-*','Color',[0.8, 0.6, 0.1],'MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,6),'-m<','MarkerSize', 10,'LineWidth', 1.5);
plot(snr_list,new_snr_list(:,7),'-m>','MarkerSize', 10,'LineWidth', 1.5);
legend('Proposed two-phase method','Proposed three-phase method','UPA partitioning','ULA-based hierarchical DFT','ULA-based DFT Sweeping','Grid matching with spacing as 1/2 m','Grid matching with spacing as 1/4 m');
xlabel('Reference SNR (dB)');
ylabel('NMSE (dB)');
set(gca, 'linewidth', 1.5, 'fontsize', 15, 'fontname', 'Times New Roman', 'GridLineStyle', '--');
grid on;
box on;
xticks(0:10:50);
yticks(nthroot([0.2, 0.3, 0.4, 1, 3, 4],10));
yticklabels({'0.2', '0.3', '0.4', '1', '3', '4'});
axis([5,45,0.2^(1/10),4^(1/10)]);