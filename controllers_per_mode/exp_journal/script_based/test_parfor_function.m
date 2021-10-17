            error_flag = 0;            

            % load Q, R matrices from SR:PSO designed for baseline sampling
            clear Q R;
            load 'output/results/SR_CT_controller/C-BEST.mat';
            clear K F;                 
            
            Qc = diag(Q);
            Rc = R;
            
            max_x1 = [1e-3 1e-2 1e-1 1];
            max_x2 = [1e-3 1e-2 1e-1 1];
            max_x3 = [1 10 100 1000];
            max_x4 = [1 10 100 1000];            

            max_u_values = linspace(0.1,5,256);
            
            Qc_values = combvec(max_x1,max_x2,max_x3,max_x4)';
            
            
            Qc = diag(1./Qc_values(loop,:))
            Rc = 1/(max_u_values(loop)^2)
            
                      
%             % half of the checks are increasing Q values, the other half
%             % decreases these values     
%             if (loop == 1)
%                 % re-use Q R matrices and crop their dimensions to Qc and Rc
%                 Qc = diag(Q);
%                 Rc = R;
%             end            
%             if (loop > 1  &&  loop < loop_check_limit)
%                 % re-use Q R matrices and crop their dimensions to Qc and Rc
%                 Qc = diag(Q);
%                 Rc = R * (10^(loop-1));
%             end
%             if (loop >= loop_check_limit  &&  loop < 2*loop_check_limit)
%                 % re-use Q R matrices and crop their dimensions to Qc and Rc
%                 Qc = diag(Q);
%                 Rc = R / (10^(loop-1));
%             end
%             if (loop >= 2*loop_check_limit  &&  loop < 3*loop_check_limit)
%                 % re-use Q R matrices and crop their dimensions to Qc and Rc
%                 Qc = diag(Q);
%                 Rc = R + (10^(loop-1));
%             end            
%             if (loop >= 3*loop_check_limit  &&  loop < 4*loop_check_limit)
%                 % re-use Q R matrices and crop their dimensions to Qc and Rc
%                 Qc = diag(Q) * (10^(loop-1));
%                 Rc = R;
%             end
%             if (loop >= 4*loop_check_limit  &&  loop < 5*loop_check_limit)
%                 % re-use Q R matrices and crop their dimensions to Qc and Rc
%                 Qc = diag(Q) / (10^(loop-1));
%                 Rc = R;
%             end
%             if (loop >= 5*loop_check_limit  &&  loop < 6*loop_check_limit)
%                 % re-use Q R matrices and crop their dimensions to Qc and Rc
%                 Qc = diag(Q) + (10^(loop-1));
%                 Rc = R;
%             end            
%             if (loop >= 6*loop_check_limit  &&  loop < 7*loop_check_limit)
%                 % re-use Q R matrices and crop their dimensions to Qc and Rc
%                 Qc = eye(4);
%                 Rc = 1 / (10^(loop-1));
%             end            
%             if (loop >= 7*loop_check_limit  &&  loop < 8*loop_check_limit)
%                 % re-use Q R matrices and crop their dimensions to Qc and Rc
%                 Qc = eye(4);
%                 Rc = 1 * (10^(loop-1));
%             end                      
%             if (loop >= 8*loop_check_limit  &&  loop < 9*loop_check_limit)
%                 % re-use Q R matrices and crop their dimensions to Qc and Rc
%                 Qc = eye(4);
%                 Rc = 1 + (10^(loop-1));
%             end                      

            % do lqr-lptv control design
            try 
                tic
                compsoc_lqr_based;
                toc
            catch ME
                error_flag = 1;
                warning('LQR-LPTV ERROR!!!');                    
            end
            
            
            % TODO: working on this section!!!!!!!!!!!!!!!!!!!!!!!!!!!!
            % when there are no errors finding the controllers
            if error_flag == 0                                
                
                % adjust feedback control matrices
                load (['output/results/exp' num2str(EXP) '/LQR_LPTV/ControlMatrices_set_1.mat']); % always load the same files
                load (['output/results/exp' num2str(EXP) '/LQR_LPTV/SysMatrices_set_1.mat']) % always load the same files
                
                clear K F;
                for i = 1:length(Ks)
                    K{i}  = -Ks{i};
                    Cs{i} = C_aug{1};
                    F{i}  = inv( Cs{i} / ( eye(dim+1) - As{i} - (Bs{i}*K{i}) ) * Bs{i}); % feedforward gain            
                end

                % Do script-based simulation for the lqr-lptv controller
                [x, u, time] = multi_rate_script_based_simulation(PLOTS_SCRIPT_SIM_ON_OFF, SIM_TIME, SIM_REFERENCE, all_h, s{1}, sp_sequence_s, A_aug, B_aug, K, F);

                t_lqr_lptv_temp                     = time;
                step_info_lqr_lptv_temp             = stepinfo( x(1,1:length(t_lqr_lptv_temp)) ); 

                % check is there is an actual settling time: system is most likely stable
                if isnan(step_info_lqr_lptv_temp.SettlingTime) == 1
                    step_info_lqr_lptv_samples(no_error_loop)   = Inf;
                    step_info_lqr_lptv(no_error_loop)           = Inf;                                
                else
                    step_info_lqr_lptv_samples(no_error_loop)   = ceil(step_info_lqr_lptv_temp.SettlingTime);
                    step_info_lqr_lptv(no_error_loop)           = t_lqr_lptv_temp(step_info_lqr_lptv_samples(no_error_loop));                            
                end
                
                step_info_lqr_lptv
                
                % just save the best experiment
                if step_info_lqr_lptv(no_error_loop) == min(step_info_lqr_lptv)
                    % SAVE DATA
                    save(['output/results/exp' num2str(EXP) '/LQR_LPTV/SIM_RESULTS.mat'],'time','x','u');                                            
                    save(['output/results/exp' num2str(EXP) '/LQR_LPTV/MATRICES_SIM_RESULTS.mat'],'Ks','Ps','As','Bs','Qs','Rs','Ss', 'PLOTS_SCRIPT_SIM_ON_OFF', 'SIM_TIME', 'SIM_REFERENCE', 'all_h', 's', 'sp_sequence_s', 'A_aug', 'B_aug', 'K', 'F');
                end                                  
                
                no_error_loop = no_error_loop + 1; % increment only when there were no errors in the solution
                                                
            end
            
%                 loop = loop + 1;