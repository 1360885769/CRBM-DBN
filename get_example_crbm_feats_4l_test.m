clear

% Load the mocap data in exponential maps - each sequence inside a cell
% matrix
load('sean_rc40fps.mat')
%load('mered_rc.mat')
M{1} = Motion{1};
Motion = M;

% Load the model parameters of the first layer
load('crbmconfig_sean_100h_3p.mat')

% for now, just using another CRBM as a template, and to fill in the mean, std, and other variables that we didn't read from python
load('av_feat_crbm_4layer_exp17_sean_lay1_100hid_6ord_10cd_gaussian_crbm_ep100.mat')

CRBMConfig_p = CRBMConfig;
CRBMConfig_p.model.w = W';
CRBMConfig_p.model.A = reshape(A', 52,52,3);
CRBMConfig_p.model.B = reshape(B', 150,52,3);
CRBMConfig_p.model.bj = hbias';
CRBMConfig_p.model.bi = vbias';
CRBMConfig_p.order = 3;
CRBMConfig_p.numdims = 52;
CRBMConfig_p.numhid = 150;


inputdata = [];
% Run the pre-processing routines to convert the raw mocap to CRBM input
for m=1:length(Motion)
    inputdata = [inputdata; Prep_CRBMData(Motion{m}, skel, CRBMConfig_p)];
end 


% Run a bottom-up tranform to get the features of the layers
feat1 = exp2crbmfeat(inputdata, skel, CRBMConfig_p);


hidstates1 = double(feat1' > rand(size(feat1,2),size(feat1,1)));
figure(10);imagesc(hidstates1(:,:)');colormap gray;
figure(1);imagesc(feat1(:,1:end));colormap gray;

% GenLog = gen_crbm(CRBMConfig_p,MotionData,200,10);
% 
% imagesc(GenLog.hidden{1}'); colormap gray;
% GenLog = Post_AddEmpty(GenLog, MotionData,0);
% GenLog.ppostvis = GenLog.postvis;
% GenLog = postprocess2(GenLog, MotionData);
% 
% figure(2); expPlayData(skel, GenLog.postvis, 1/30);

