%% Indentify the maximum of consecutive errors in the error input sequence

max_errors_array = [];
cnt_array_cell = {};
cnt_cell = 1;
% for pe = 0.01:0.01:0.99
% for pe = 0.7
for pe = 0.1:0.1:0.9
    error_probability = pe;

    sim('simulink_random_error', Tend);

    errors = error_input_sequence.Data;
    cnt_array = [];
    cnt = 0;
    for i = 1:length(errors)
        if errors(i) == 1
            cnt = cnt + 1;
            if i == length(errors)
                cnt_array = [cnt_array cnt];
            end;
        else
            cnt_array = [cnt_array cnt];
            cnt = 0;
        end;
    end

    cnt_array_cell{cnt_cell} = cnt_array;
    max_errors_array = [max_errors_array max(cnt_array)]; 
    
    cnt_cell = cnt_cell + 1;
end

% pe = 0.01:0.01:0.99;
% pe = 0.01:0.0001:0.99;
pe = 0.1:0.1:0.9;
%% Saving results
save('results\results_errors_and_probabilities.mat', ...
     'pe', 'cnt_array_cell', 'max_errors_array');  
