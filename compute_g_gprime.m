function [g, gprime] = compute_g_gprime(c,pars)

% params
n = pars(1);
c50 = pars(2);

% g and gprime
temp = c.^n + c50^n;
g = c.^n./temp;
gprime = n * g./c .* (1 - g);

end