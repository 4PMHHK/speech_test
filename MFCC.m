clc;clear;close all;
MFCC_size=12;%mfcc��ά��
GMM_component=16;%GMM component ����
mu_model=zeros(MFCC_size,GMM_component);%��˹ģ�� ���� ��ֵ
sigma_model=zeros(MFCC_size,GMM_component);%��˹ģ�� ���� ����
weight_model=zeros(GMM_component);%��˹ģ�� ���� Ȩ��
train_file_path='1/1-';%ѵ���ļ�·����
num_train=6;%ѵ������
test_file_path='./';%�����ļ�·�� 2~15��
num_test=15;%�ʶ�����,��15��
num_uttenance=6;%���Ծ��� ʵ������6*3

all_train_feature =[];
all_scores = [];

for i=1:num_train
    train_file=[train_file_path num2str(i) 'normal' '.wav']; %�����ļ���
    [wav_data ,fs]=readwav(train_file); %��ȡ��Ƶ�ļ�
    train_feature=melcepst(wav_data ,fs); %��ȡ����
    all_train_feature=[all_train_feature;train_feature]; %������������������
end

[mu_model,sigma_model,weight_model]=gmm_estimate(all_train_feature',GMM_component); %�����������ģ�;�
%����
for i=1:num_test %��Ӧ�ڼ���;��15�ܣ����а����˵�һ���е�ѵ���õ����
    for j=1:num_uttenance %��Ӧ�ڼ���
        for k=1:3   %��Ӧnormal, fast, slow
            test_file=[num2str(i) '/' num2str(i) '-' num2str(j)]; %�����ļ���
            if(k==1) str = 'normal.wav'; end
            if(k==2) str = 'fast.wav'; end
            if(k==3) str = 'slow.wav'; end   
            test_file = strcat(test_file,str);
            [wav_data ,fs]=readwav(test_file); %��ȡ��Ƶ�ļ�
            test_feature=melcepst(wav_data ,fs); %��ȡ����
            [lYM, lY] = lmultigauss(test_feature', mu_model,sigma_model, weight_model); %��ģ�ͽ��бȽ�
            score(i) = mean(lY); %�������
            all_scores(i,j,k) = score(i); %�洢���з���
            fprintf('Test:%d-%d%s score:%f\n',i,j,str,score(i)); %����
        end
    end
end

max1 = max(max(all_scores(:,:,1)));
max2 = max(max(all_scores(:,:,2)));
max3 = max(max(all_scores(:,:,3)));

min1 = min(min(min(all_scores)));