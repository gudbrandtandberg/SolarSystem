function a = gravity(r, v, t)
%gravity.m
%Gudbrand Tandberg - gudbrandduff@gmail.com
%version 1.0
%
%This funtion returns the acceleration due to gravity on n planets in three
%dimensional euclidian space. Distance is scaled by the AU, and time is
%scaled by the length of a day. The paramaters v and t are strictly
%unnecessary, but since in general a acceleration depends upon position,
%velocity and time, they are here included.
%
%  r = [x1 y1 z1 x2 y2 z2 ... xn yn zn] are the positions of the plantes.
%
%  a = [ax1 ay1 az1 ax2 ay2 az2 ... axn ayn azn] are the components of the
%acceleration of each of the planets.
%As it is the funtion calculates the gravitational acceleration on the sun
%and the n first planets (n = 1, 2, .., 8), but it can easily be modified
%to work with any number of defferent bodies in any nymber of dimensions.

dim = 3;                    %no. of spacial dimensions
planets = size(r);
planets = planets(2)/dim;   %no. of bodies (planets)

G = 6.67E-11;               %gravitational constant
AU = 1.495978707E11;        %astronomical unit
d = 60*60*24;               %length of a day
G_s = G*d^2/AU^3;           %scaled gravitational constant

m = [1.9891E30 3.302E23 4.8685E24 5.97219E24 6.4185E23 1.8986E27 5.6846E26...
    8.681E25 1.0243E26];    %masses of the sun and our 8 planets
a = zeros(1, planets*3);    %preallocation

%This loop iterates over all the planets adding the acceleration of planet
%i due to planet j to the overall acceleration on planet i.
for i = 1:planets
    for j = 1:planets
        if j ~= i
            r_ij = r((j-1)*3+1:j*3) - r((i-1)*3+1:i*3);
            a((i-1)*3+1:i*3) = a((i-1)*3+1:i*3) + (G_s*m(j)/(norm(r_ij)^3))*r_ij;
        end
    end
end
end
