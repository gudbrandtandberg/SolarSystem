%Solarsystem.m
%Gudbrand Tandberg - gudbrandduff@gmail.com
%version 1.0
%
%This program shows the motion of the planets in our solar system. By
%adjusting the parameter 'no_planets', trajectories for the sun and the
%first no_planets-1 planets. The initial conditions were retrieved from
%NASA's Solar System Dynamics group on the 2nd of Febuary 2014, and are
%all scaled by the AU and the length of a day. The program generates a 
%.avi file with the trajectories of the planets. 

%Preallocation, physical parameters and initial conditions:
no_planets = 6;         %how many planets to plot?
days = [0 88.0 224.7 365.2 687.0 4331 10747 30589 59800 90588]; %Length of a year on planet i
planets = {'Sun', 'Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', ...
    'Saturn', 'Uranus', 'Neptune'};
colors = {'k', 'g', 'y', 'b', 'r', 'm', 'c', 'g', 'w'};

d = 60*60*24;           %length of a day
dt = 5;                 %time step
AU = 1.495978707E11;    %astronomical unit
T = days(no_planets);   %final time
n = round(T/dt);        %no. of evaluation points

m = [1.9891E30 3.302E23 4.8685E24 5.97219E24 6.4185E23 1.8986E27 5.6846E26...
    8.681E25 1.0243E26];    %masses of the sun and the planets

r_0 = 1000/AU*[0 0 0 ...
    2.417458149944681E+07  3.961908823472586E+07  1.019152972912366E+06...
   -8.713874815025689E+07  6.267133929263873E+07  5.887624863078220E+06...
    -9.832893329273786E+07  1.098127067722844E+08 -3.257632516971247E+03...
    -2.437981627448902E+08  4.819784790635903E+07  6.994082893304829E+06...
    -2.331512428061480E+08  7.427122742511928E+08  2.132579853305100E+06...
    -1.012749850225338E+09 -1.076436562107142E+09  5.903530065123624E+07...
    2.935069311018662E+09  6.038275159130698E+08 -3.577124383069587E+07...
    4.054749746608424E+09 -1.915367119297712E+09 -5.398515950879561E+07
    ];                      %inital positions of all the planets

v_0 = 1000*d/AU*[0 0 0 ...
    -5.129420747164487E+01  2.732245601122905E+01  6.938641077916809E+00...
    -2.058556491270471E+01 -2.860628332870155E+01  7.959826095832389E-01...
    -2.267685408359372E+01 -1.998317369161212E+01  6.841972831700973E-04...
    -3.793312925984044E+00 -2.169904870654408E+01 -3.615448792248455E-01...
    -1.263517979410647E+01 -3.297975401056563E+00  2.964314434433838E-01...
    6.500277929864231E+00 -6.647002225408530E+00 -1.433612204947691E-01...
    -1.431512921791133E+00  6.348399029861570E+00  4.225470418730855E-02...
    2.275369579533704E+00  4.942024008970557E+00 -1.543036821871557E-01
    ];
                            %inital velocities of all the planets
                            
%Calculate the trajectories using Runge-Kuttas solution method: 
[r, ~, t] = RK4(@gravity, r_0, v_0, T, dt);

%Create an 'animation' of the planets:
images = cell(1, no_planets);
for i = 1:no_planets        %retrieve an image for each planet
    images{i} = imread(strcat(planets{i},'.jpg'));
end

im_sizes = [1/5 1/7 1/6 1/5 1/5 2 2 1.5 1.5]; %approriately scale the images 

ax_size = [1 1 1 1 2 9 11 25 31];       %appropriate axis size for i planets
AX = ax_size(no_planets);

film = avifile(strcat('Solarsystem_', num2str(no_planets-1),'_planets.avi'));
film.fps = 20.0;

fig = figure('visible', 'off');

%Finally, plot the trajectories:
for i = 1:n
    
    plot(r(1:i, 1), r(1:i,2), 'k');
    hold on;
    for j = 2:no_planets    
        plot(r(1:i,j*3-2), r(1:i,j*3-1), colors{j});
    end
    set(gca, 'Color', 'k');
    
    for j = 1:no_planets
        h = im_sizes(j);
        image([r(i,j*3-2)-h r(i,j*3-2)+h], [r(i,j*3-1)+h r(i,j*3-1)-h], images{j});
        %text(r(i,j*3-2) + h, r(i,j*3-1), planets{j}, 'Color', colors{j});
    end
    
    hold off;
    title(sprintf('The solar system %.1f days after 2.2.2014', i*dt));
    xlabel('Distance [AU]');
    ylabel('Distance [AU]');
    axis([-AX, AX, -AX, AX]);
    legend(planets(1:no_planets), 'TextColor', 'white');
    pause(0.01);
  
    film = addframe(film, getframe(fig));
    
    hold off;
end

film = close(film);