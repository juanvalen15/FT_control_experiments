function variable = CompSoc(A,D)
% CompSoc(A,Decimals) outputs the A matrix in an appropiate format for a CompSoc
% application, showing D decimal positions. 
% by default D=7.
% The result is automatically copied to the workspace. 

% Robinson Medina 
% September 2017

if (nargin==1)
    formato='%.7e'; % shows 7 decimal positions
else
    formato=['%.' num2str(D) 'e'];
end


[a,b]     = size(A);
variable  = blanks(a*b*3+4);

variable  = ['{' char(10)];

for row = 1:a
    variable = [variable '{'];
    for columns=1:b
        if columns == b
            variable=[variable num2str(A(row,columns),formato) 'f '];
        else
            variable=[variable num2str(A(row,columns),formato) 'f, '];
        end
    end
    
    if row == a
        variable=[variable '} ' char(10)];
    else
        variable=[variable '}, ' char(10)];
    end
end

variable=[variable '};' char(10)];

% fprintf(variable)
% clipboard('copy',variable)
% fprintf('\n The result was copied to the workspace \n')