%==========================================================================
%
%
% input  :
% 
% output :
%
% Siqi Li, SMAST
% yyyy-mm-dd
%
% Updates:
%
%==========================================================================
function rvo = calc_rvo(u, v, dx, dy)

[nx, ny] = size(u);

% xc=zeros(nx-1,ny-1);
% yc=zeros(nx-1,ny-1);
rvo1=zeros(nx-1,ny-1);

for i=1:nx-1
    for j=1:ny-1

%         xc(i,j)=(x(i,j)+x(i+1,j)+x(i,j+1)+x(i+1,j+1))/4;
%         yc(i,j)=(y(i,j)+y(i+1,j)+y(i,j+1)+y(i+1,j+1))/4;

%        u_right=(u(i+1,j)+u(i+1,j+1))/2;
%        u_left=(u(i,j+1)+u(i,j))/2;
%        v_top=(v(i+1,j+1)+v(i,j+1))/2;
%        v_bottom=(v(i,j)+v(i+1,j))/2;

%         rvo(i,j)=(u_right-v_top-u_left+v_bottom)/dd;

        u_bottom=(u(i,j)+u(i+1,j))/2;
        u_top=(u(i+1,j+1)+u(i,j+1))/2;
        v_right=(v(i+1,j)+v(i+1,j+1))/2;
        v_left=(v(i,j+1)+v(i,j))/2;
%         rvo1(i,j)=(u_bottom+v_right-u_top-v_left)/d;
        rvo1(i,j)=(u_bottom-u_top)/dx+(v_right-v_left)/dy;

    end
end

% Interpolate rvo back to the orginal grid points.
rvo = nan(nx, ny);
rvo(2:end-1, 2:end-1) = rvo1(1:end-1, 1:end-1) + ...
                         rvo1(2:end, 1:end-1)   + ...
                         rvo1(1:end-1, 2:end)   + ...
                         rvo1(2:end, 2:end);
rvo = rvo / 4;