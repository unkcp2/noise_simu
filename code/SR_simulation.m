clc;
clear;
close all;
warning off;
addpath 'GA_toolbox\'

% load ReciveData.mat
% %全局参数
% global fs Tsyn  T_proctective f_syn_start B_syn Tdata f_data_start B_data
% 
% public_fun();
% fc = 20000;
% f_data_start = f_data_start + fc;
% h      = 1;
% t = -Tdata/2:1/fs:Tdata/2 - 1/fs;
% N = fs*Tdata;
% f = (-N/2:N/2-1)/N*fs;


%基于遗传算法的随机共振参数选择
[a_GA,b_GA] = GA;
SNR_GA = huaresult(a_GA,b_GA);
title('Result of GASR');

% %基于蚁群算法的随机共振参数选择
% [a_AA,b_AA,maxvalue]=AA;
% SNR_AA = huaresult(a_AA,b_AA);
% title('Result of AASR');
% 
% %基于粒子群算法的随机共振参数选择
% Areas  = [0,2
%           0,2];
% [Result,OnLine,OffLine,MinMaxMeanAdapt]=PA(100,2,Areas,0,0,50,0);
% a_PA = Result(1);
% b_PA = Result(2);
% SNR_PA = huaresult(a_PA,b_PA);
% title('Result of PASR');
% 
% %基于模拟退火算法的随机共振参数选择
% x = [1,1];
% [x,res] = SA(x,@fun_object,@Arrise);
% a_SA = x(1);
% b_SA = x(2);
% SNR_SA = huaresult(a_SA,b_SA);
% title('Result of SASR');

