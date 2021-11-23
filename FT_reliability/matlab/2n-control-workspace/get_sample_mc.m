function sample = get_sample_mc(P_markov, state)

if mod(state,1) ~= 0
    msg = 'State not an integer!';
    error(msg)
elseif state >= length(P_markov) || state <= 0
    msg = 'Invalid state';
    error(msg)
else
    cum_dist= cumsum(P_markov(state,:));
    cum_dist_a = [0 cum_dist];
    r = rand;
    temp = find(cum_dist_a>r);
    sample = temp(1)-1;
end