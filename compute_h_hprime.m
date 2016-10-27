function [h, hprime] = compute_h_hprime(s,phi,a,b,gamma)

h = a + b.*exp(gamma.*(cos(s - phi) - 1));
hprime = -(b.*gamma).*sin(s-phi).*exp(gamma.*cos(s-phi)-gamma);

end
