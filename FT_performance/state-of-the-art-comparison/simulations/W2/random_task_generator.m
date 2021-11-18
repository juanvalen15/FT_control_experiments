% random task generation
function set = random_task_generator(Phi, Rhi, C_lo_max, T_max)

% Phi = 0.7;
% Rhi = 4;
% C_lo_max = 10;
% T_max = 50;

set = [];
for j = 1:4

    for i = 1:2
        random_number = rand;
        if random_number < Phi
            tao.L(i) = 1; % HI
        else
            tao.L(i) = 0; % LO
        end

        cLO = randi([1,C_lo_max]);
        cHI = randi([cLO, Rhi*cLO]);
        if tao.L(i) == 0
            tao.C(i) = cLO;
        elseif tao.L(i) == 1
            tao.C(i) = cHI;
        end

        tao.T(i) = randi([cHI, T_max]);
    end

    tao;
    U = sum(tao.C ./ tao.T);
    tao.U = U;

    if U <= 1
        set = [set tao];
    end

end

end