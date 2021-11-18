fprintf('Compiling setim_no_delay.m into a c function ');
cfg=coder.config('mex'); % type of output file
cfg.MATLABSourceComments='on';
cfg.GenerateReport= 'on';
codegen setim_no_delay.m -config cfg -o setim_mex_no_delay
fprintf('..... done \n');