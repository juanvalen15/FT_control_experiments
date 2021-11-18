%% Export sequences to .txt
format longeng;

%% Controllers
N = dim + 1;
fd = fopen('controllers.txt', 'wt');

% C1
fprintf(fd, 'float K1[1][N] = {{' );
for index = 1:N
    if index == N
        fprintf(fd, '%Ef ', K1(index));
    else
        fprintf(fd, '%Ef, ', K1(index));
    end
end
fprintf (fd, '}};\n');
fprintf(fd, 'float F1[1][1] = {{ %Ef }};\n', F1);

% C2
fprintf(fd, 'float K2[1][N] = {{' );
for index = 1:N
    if index == N
        fprintf(fd, '%Ef ', K2(index));
    else
        fprintf(fd, '%Ef, ', K2(index));
    end
end
fprintf (fd, '}};\n');
fprintf(fd, 'float F2[1][1] = {{ %Ef }};\n', F2);

% C3
fprintf(fd, 'float K3[1][N] = {{' );
for index = 1:N
    if index == N
        fprintf(fd, '%Ef ', K3(index));
    else
        fprintf(fd, '%Ef, ', K3(index));
    end
end
fprintf (fd, '}};\n');
fprintf(fd, 'float F3[1][1] = {{ %Ef }};\n', F3);


fclose(fd);             


%% Generate header files errors
length_errors = length(ws_errors.data);
fd = fopen('ws_errors.h', 'wt');
fprintf(fd, 'unsigned int ws_errors_len = %d;\n', length_errors);
fprintf(fd, 'int ws_errors[] = {\n' );
for index = 1:length_errors
    fprintf(fd, '%d,\n', ws_errors.data(index));
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
length_modes = length(ws_modes.data);
fd = fopen('ws_modes.h', 'wt');
fprintf(fd, 'unsigned int ws_modes_len = %d;\n', length_modes);
fprintf(fd, 'int ws_modes[] = {\n' );
for index = 1:length_modes
    fprintf(fd, '%d,\n', ws_modes.data(index));
end
fprintf (fd, '};\n');
fclose(fd);                                  



%% Generate header files sensing instants
length_sensing_instant = length(ws_sensing_instant.data);
fd = fopen('ws_sensing_instant.h', 'wt');
fprintf(fd, 'unsigned int ws_sensing_instant_len = %d;\n', length_sensing_instant);
fprintf(fd, 'int ws_sensing_instant[] = {\n' );
for index = 1:length_sensing_instant
    fprintf(fd, '%d,\n', ws_sensing_instant.data(index));
end
fprintf (fd, '};\n');
fclose(fd);                                  


%% Generate header files actuation instants
length_actuation_instant = length(ws_actuation_instant.data);
fd = fopen('ws_actuation_instant.h', 'wt');
fprintf(fd, 'unsigned int ws_actuation_instant_len = %d;\n', length_actuation_instant);
fprintf(fd, 'int ws_actuation_instant[] = {\n' );
for index = 1:length_actuation_instant
    fprintf(fd, '%d,\n', ws_actuation_instant.data(index));
end
fprintf (fd, '};\n');
fclose(fd);                       


%% Generate plant discretised values
length_actuation_instant = length(ws_actuation_instant.data);
fd = fopen('discrete_plant.txt', 'wt');
fprintf(fd, 'float A[N-1][N-1] = {\n' );
for index = 1:length_actuation_instant
    fprintf(fd, '%d,\n', ws_actuation_instant.data(index));
end
fprintf (fd, '};\n');
fclose(fd);                       

