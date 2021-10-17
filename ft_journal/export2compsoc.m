%% Export sequences to .txt
format longeng;

%% Controllers
N = dim + 1;
fd = fopen('controllers.txt', 'wt');

for modes_index = 1:control_modes
    % Ki
    fprintf(fd, ['float K' num2str(modes_index) '[1][N] = {{']);
    for N_index = 1:N
        if N_index < N
            fprintf(fd, '%Ef ', K_total(modes_index,N_index));
        else
            fprintf(fd, '%Ef ', K_total(modes_index,N_index));
            fprintf(fd, '}};\n');
        end
    end
    
    % Fi
    fprintf(fd, ['float F' num2str(modes_index) '[1][1] = {{ %Ef }};\n'], F_total(modes_index));
end


fclose(fd);             


%% Generate header files errors
length_errors = length(error_input_sequence.data);
fd = fopen('ws_errors.h', 'wt');
fprintf(fd, 'unsigned int ws_errors_len = %d;\n', length_errors);
fprintf(fd, 'int ws_errors[] = {\n' );
for index = 1:length_errors
    fprintf(fd, '%d,\n', error_input_sequence.data(index));
end
fprintf (fd, '};\n');
fclose(fd);                                  


%% Generate header files reference
length_reference = length(ws_reference.data);
fd = fopen('ws_reference.h', 'wt');
fprintf(fd, 'unsigned int ws_reference_len = %d;\n', length_reference);
fprintf(fd, 'float ws_reference[] = {\n' );
for index = 1:length_reference
    fprintf(fd, '%ff,\n', ws_reference.data(index));
end
fprintf (fd, '};\n');
fclose(fd);                   


%% Generate header files modes
% length_modes = length(ws_modes.data);
% fd = fopen('ws_modes.h', 'wt');
% fprintf(fd, 'unsigned int ws_modes_len = %d;\n', length_modes);
% fprintf(fd, 'int ws_modes[] = {\n' );
% for index = 1:length_modes
%     fprintf(fd, '%d,\n', ws_modes.data(index));
% end
% fprintf (fd, '};\n');
% fclose(fd);                                  



%% Generate header files sensing instants
% length_sensing_instant = length(ws_sensing_instant.data);
% fd = fopen('ws_sensing_instant.h', 'wt');
% fprintf(fd, 'unsigned int ws_sensing_instant_len = %d;\n', length_sensing_instant);
% fprintf(fd, 'int ws_sensing_instant[] = {\n' );
% for index = 1:length_sensing_instant
%     fprintf(fd, '%d,\n', ws_sensing_instant.data(index));
% end
% fprintf (fd, '};\n');
% fclose(fd);                                  


%% Generate header files actuation instants
% length_actuation_instant = length(ws_actuation_instant.data);
% fd = fopen('ws_actuation_instant.h', 'wt');
% fprintf(fd, 'unsigned int ws_actuation_instant_len = %d;\n', length_actuation_instant);
% fprintf(fd, 'int ws_actuation_instant[] = {\n' );
% for index = 1:length_actuation_instant
%     fprintf(fd, '%d,\n', ws_actuation_instant.data(index));
% end
% fprintf (fd, '};\n');
% fclose(fd);                       

