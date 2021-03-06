function [M] = MovieOf_SphericalHarmonics_As_Chargewaves2(l,m)


N=100; % Number of frames in one Period
NumberOfPeriod = 5;
AngleDivision = 50;
InitialRadius = 1;
OscillationRadius = 0.01;

[theta,phi] = meshgrid(linspace(0,2*pi,AngleDivision),linspace(-pi/2,pi/2,AngleDivision));
[Ylm] = compute_Ylm(l, m, phi, theta);
Ylm2 = zeros(AngleDivision,AngleDivision)
Ylm = Ylm
Ylm2((AngleDivision/2)+1:AngleDivision,:) = Ylm(1:AngleDivision/2,:);
Ylm2(1:AngleDivision/2,:) = Ylm(AngleDivision/2+1:AngleDivision,:);
Ylm2(1:AngleDivision/2,:) = ((-1)^(l+m))*Ylm(AngleDivision/2+1:AngleDivision,:);

%Ylm2((AngleDivision/2)+1:AngleDivision,(AngleDivision/2)+1:AngleDivision) = Ylm(1:AngleDivision/2,1:AngleDivision/2)
%Ylm2(1:AngleDivision/2,1:AngleDivision/2) = ((-1)^l)*Ylm(AngleDivision/2+1:AngleDivision,AngleDivision/2+1:AngleDivision)

Ylm = Ylm2
w = 2*pi/N;
RecordVideo =0;
max_Ylm = max(max(Ylm));


for t = 1:N*NumberOfPeriod

  %  if mod(t-25,100)== 0
   % OscillationRadius = OscillationRadius + 0.2;
   % if OscillationRadius >=1/max_Ylm
   %     OscillationRadius = 1/max_Ylm;
   % end
   % end
    
r2 = OscillationRadius*diag(diag(Ylm))*ones(AngleDivision,AngleDivision)*(diag(diag(cos(m*theta-w*t)))) + InitialRadius*ones(AngleDivision,AngleDivision);

x2 = r2.*cos(theta).*cos(phi);
y2 = r2.*sin(theta).*cos(phi);
z2 = r2.*sin(phi);

C = InitialRadius-r2;
surf(x2,y2,z2,C);

% Imaginary Part
r3 = OscillationRadius*diag(diag(Ylm))*sin(w*t)*ones(AngleDivision,AngleDivision)*(diag(diag(cos(m*theta)))) + InitialRadius*ones(AngleDivision,AngleDivision);
x3 = r3.*cos(theta).*cos(phi);
y3 = r3.*sin(theta).*cos(phi);
z3 = r3.*sin(phi);
C2 = InitialRadius-r3;
hold on
%surf(x3,y3,z3,C2);
hold off 

%r1 =  InitialRadius*ones(AngleDivision,AngleDivision);
%x1 = r1.*cos(theta).*cos(phi);
%y1 = r1.*sin(theta).*cos(phi);
%z1 = r1.*sin(phi);


set(gca,'XTick',[])
set(gca,'YTick',[])
%set(gca,'ZTick',[])

zlim([-2.6 2.6])
ylim([-2.6 2.6])
xlim([-2.6 2.6])

set(gca, 'CLim', [-0.004, 0.004]);

az = 322.5 + t/10;
el = 30 - t/10;
if t>=500
    el = -30 + (t-500)/8;
    if t>=1000
        el = 32.5 - (t-1000)/8;
    end
end
view(az, el);
colormap(jet);

hold on
%mesh(x1,y1,z1);
shading interp
hold off
colorbar
title(sprintf('Charge density waves on a sphere  \n\n Positive charge in red, and Negative charge in blue, Neutral in green')) 
M(t)=getframe(gcf);% leaving gcf out crops the frame in the movie.
%M(t)=getframe(gcf);% leaving gcf out crops the frame in the movie.

end


%movie2avi(M,'WaveMovie.avi');
if RecordVideo ==1
v = VideoWriter('Spherical Harmonics4.avi','Uncompressed AVI');
open(v)
writeVideo(v,M)
close(v)
end