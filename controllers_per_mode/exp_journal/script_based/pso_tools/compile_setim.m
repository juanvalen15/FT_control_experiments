fprintf('Compiling setim.m into a c function ');
cfg=coder.config('mex'); % type of output file
cfg.MATLABSourceComments='on';
cfg.GenerateReport= 'on';
codegen setim.m -config cfg -o setim_mex
fprintf('..... done \n');