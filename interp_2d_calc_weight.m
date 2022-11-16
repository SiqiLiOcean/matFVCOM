%==========================================================================
% Do the 2d interpolation with different kind of data in three different
% ways:
%   1> For triangle-grid (such as FVCOM node), use the Triangulation with Linear
%      Interpolation Method. (TRI)
%   2> For rectangule-grid (such as WRF), use the Bilinear / Quadrilateral
%      Interpolation Method.(BI) 
%   3> For random scattered points, use the Inversed Distance Method. (ID)
%
% This function will calculate the weight only.
%
% input  : METHOD_2D, varargin
%    METHOD_2D    interpolation methode, 'TRI', 'BI', 'QU', or 'ID'
%    varargin contains:
%    1> x           source x
%       y           source y
%       nv          source nv
%       xo          destination x
%       yo          destination y
%       'Extrap'    the flag to do extrapolation (optional)
%       'K'         the points to be searched, if there are NaN points in 
%                     the domain, try to increase this value (optional, 
%                     default 7)
%
%    2> x           source x
%       y           source y
%       xo          destination x
%       yo          destination y
%       'Global'    the flag to solve the global grid problem (optional)
%
%    3> x           source x
%       y           source y
%       xo          destination x
%       yo          destination y
%       'Extrap'    the flag to do extrapolation (optional)
%
%    4> x           source x
%       y           source y
%       xo          destination x
%       yo          destination y
%       'np'        the flag to do extrapolation (optional)
%       'Power'     the order of distance in the ID equation (optional, 
%                     default 2)
%
% 
% output :
%    weight_h       cell of interpolation weight
%
% Siqi Li, SMAST
% 2021-06-22
%
% Updates:
% 2022-03-02  Siqi Li  Added the global option in BI method
% 2022-03-03  Siqi Li  Added the Quadrilateral method for WRF regional grid
%==========================================================================
function weight_h = interp_2d_calc_weight(METHOD_2D, varargin)

% Part 1: read input data
varargin = read_varargin2(varargin, {'Global'});
weight_h.index = [];

switch upper(METHOD_2D)
    
    case 'TRI'
        x = varargin{1}(:);
        y = varargin{2}(:);
        nv= varargin{3};
        xo = varargin{4}(:);
        yo = varargin{5}(:);
        dims = size(varargin{1});
        dimso = size(varargin{4});
        varargin(1:5) = [];
        varargin = read_varargin2(varargin, {'Extrap'});
        varargin = read_varargin(varargin, {'K'}, {7});
        
    case 'BI'
        x = varargin{1};
        y = varargin{2};
        xo = varargin{3}(:);
        yo = varargin{4}(:);
        dims = size(varargin{1});
        dimso = size(varargin{4});
        varargin(1:4) = [];
        
        if length(dims) ~= 2
            error('The size of input x is wrong')
        else
            if dims(1) ==1 || dims(2) == 1
                [y, x] = meshgrid(y, x);
            end
        end
        
        if Global
            [nx0, ny0] = size(x);
            index = reshape(1:nx0*ny0, nx0, ny0);
            
            if abs(x(1,1)-x(end,1))>300
                index = [index(end,:); index; index(1,:)];
                x = x(index);
                x(1,:) = x(1,:) - 360;
                x(end,:) = x(end,:) + 360;
                y = y(index);
            else
                index = [index(:,end) index index(:,1)];
                x = x(index);
                x(:,1) = x(:,1) - 360;
                x(:,end) = x(:,end) + 360;
                y = y(index);
            end
            weight_h.index = index;
        end
        
    case 'QU'
        x = varargin{1};
        y = varargin{2};
        xo = varargin{3}(:);
        yo = varargin{4}(:);
        dims = size(varargin{1});
        dimso = size(varargin{4});
        varargin(1:4) = [];
        
        if length(dims) ~= 2
            error('The size of input x is wrong')
        else
            if dims(1) ==1 || dims(2) == 1
                [y, x] = meshgrid(y, x);
            end
        end
        varargin = read_varargin2(varargin, {'Extrap'});
        
    case 'ID'
        x = varargin{1}(:);
        y = varargin{2}(:);
        xo = varargin{3}(:);
        yo = varargin{4}(:);
        dims = size(varargin{1});
        dimso = size(varargin{4});
        varargin(1:4) = [];
        varargin = read_varargin(varargin, {'np', 'Power'}, {6, 2});
        
    otherwise
        error('UNKOWN mehtod. Select TRI, BI or ID.')
end

% Part 2: calculate weight
switch upper(METHOD_2D)
    
    %----------------------------------------------------------------
    % Triangulation with Linear Interpolation Method
    case 'TRI'
        

%         varargin = read_varargin(varargin, {'K'}, {1});
        
        
%         if ~isempty(varargin)
%             error('Something was un-used.')
%         end
        
        n2 = length(xo);

        % Use (xc, yc) to find the posible cell (default K = 7)
        xc = mean(x(nv), 2);
        yc = mean(y(nv), 2);
        k = knnsearch([xc yc], [xo yo], 'K', K);
        
%         % Use (x, y) to find the posible cell (default K = 1)
%         k_list = knnsearch([x, y], [xo, yo], 'K', K);
        
        jo = nan(n2, 1);
        id = nan(n2, 3);
        weight = nan(n2, 3);
        for i = 1 : n2
            
            % Find out which cell (xo, yo) is in
            for j = k(i,:)
%             k = find(any(ismember(nv, k_list(i)),2));
%             for j = k(:)'
                if inpolygon(xo(i), yo(i), x(nv(j,:)), y(nv(j,:)))
                    jo(i) = j;
                    break
                end
            end
            
            % Calculate weight
            if ~isnan(jo(i))
%                 if Extrap
%                     id(i, :) = knnsearch([x y], [xo(i) yo(i)], 'K', 1);
%                     weight(i, :) = [1 0 0];
%                 end
%             else
                id(i, :) = nv(jo(i),:);
                A = [x(id(i, :))'; y(id(i, :))'; 1 1 1];
                b = [xo(i); yo(i); 1];
                weight(i, :) = A \ b;
            end
            
                
        end
        
        if Extrap
            out = find(isnan(jo));
            if ~isempty(out)
                id(out, 1) = knnsearch([x y], [xo(out) yo(out)], 'K', 1);
                id(out, 2:3) = 1;  % Fake
                weight(out, 1) = 1;
                weight(out, 2:3) = 0;
            end
        end
            
        % Merge the weight and id into one cell
        weight_h.id = id;
        weight_h.w = weight;
        weight_h.method = METHOD_2D;
        weight_h.dims1 = dims;
        weight_h.dims2 = dimso;
                
    %----------------------------------------------------------------    
    % Bilinear Interpolation Method
    case 'BI' 
        
%         varargin = read_varargin2(varargin, {'Extrap'});
        
%         if ~isempty(varargin)
%             error('Something was un-used.')
%         end
        

        
        [nx, ny] = size(x);
        
        x_in1 = x(1:nx-1, 1:ny-1);
        x_in2 = x(2:nx,   1:ny-1);
        x_in3 = x(2:nx,   2:ny);
        x_in4 = x(1:nx-1, 2:ny);
        
        y_in1 = y(1:nx-1, 1:ny-1);
        y_in2 = y(2:nx,   1:ny-1);
        y_in3 = y(2:nx,   2:ny);
        y_in4 = y(1:nx-1, 2:ny);

        x_center = (x_in1 + x_in2 + x_in3 + x_in4) / 4;
        y_center = (y_in1 + y_in2 + y_in3 + y_in4) / 4;

        k = knnsearch([x_center(:) y_center(:)], [xo yo]);
        
        [ix, iy] = ind2sub([nx-1, ny-1], k);
        
        id1 = sub2ind([nx,ny], ix, iy);
        id2 = sub2ind([nx,ny], ix+1, iy);
        id3 = sub2ind([nx,ny], ix+1, iy+1);
        id4 = sub2ind([nx,ny], ix, iy+1);

        px = x([id1 id2 id3 id4]);
        py = y([id1 id2 id3 id4]);
        
        id = [id1(:) id2(:) id3(:) id4(:)];
        weight = interp_rectangle_calc_weight(px, py, xo, yo);
%         weight = interp_quadrilateral_calc_weight(px, py, xo, yo);
        
        
%         if Extrap
%             % Calculate bdy_id
%             sub1 = [repmat(1,ny,1); (2:nx)'          ; repmat(nx,ny-1,1); (nx-1:-1:1)'  ];
%             sub2 = [(1:ny)'       ; repmat(ny,nx-1,1); (ny-1:-1:1)'     ; repmat(1,nx-1,1)];
%             bdy_id = sub2ind([nx,ny], sub1, sub2);
%             
%             % Caluclate bdy_x and bdy_y
%             bdy_x = x(bdy_id);
%             bdy_y = y(bdy_id);
%             
%             in = inpolygon(xo, yo, bdy_x, bdy_y);
%             out = find(~in);
% %             id(out, :) = nan;
% %             weight(out, :) = nan;
%             id(out, 1) = knnsearch([x(:) y(:)], [xo(out) yo(out)], 'K', 1);
%             id(out, 2:4) = 1;  % Fake
%             weight(out, 1) = 1;
%             weight(out, 2:4) = 0;
%             
%         else
%             % Calculate bdy_id
%             sub1 = [repmat(1,ny,1); (2:nx)'          ; repmat(nx,ny-1,1); (nx-1:-1:1)'  ];
%             sub2 = [(1:ny)'       ; repmat(ny,nx-1,1); (ny-1:-1:1)'     ; repmat(1,nx-1,1)];
%             bdy_id = sub2ind([nx,ny], sub1, sub2);
%             
%             % Caluclate bdy_x and bdy_y
%             bdy_x = x(bdy_id);
%             bdy_y = y(bdy_id);
%             
%             in = inpolygon(xo, yo, bdy_x, bdy_y);
%             out = find(~in);
%             id(out, :) = nan;
%             weight(out, :) = nan;
%         end

        % Merge the weight and id into one cell
        weight_h.id = id;
        weight_h.w = weight;
        weight_h.method = METHOD_2D;
        weight_h.dims1 = dims;
        weight_h.dims2 = dimso;
        
    %----------------------------------------------------------------    
    % Quadrilateral Interpolation Method
    case 'QU' 
        
%         varargin = read_varargin2(varargin, {'Extrap'});
        
%         if ~isempty(varargin)
%             error('Something was un-used.')
%         end
        

        
        [nx, ny] = size(x);
        
        x_in1 = x(1:nx-1, 1:ny-1);
        x_in2 = x(2:nx,   1:ny-1);
        x_in3 = x(2:nx,   2:ny);
        x_in4 = x(1:nx-1, 2:ny);
        
        y_in1 = y(1:nx-1, 1:ny-1);
        y_in2 = y(2:nx,   1:ny-1);
        y_in3 = y(2:nx,   2:ny);
        y_in4 = y(1:nx-1, 2:ny);
        
        
        rec_x(:,:,1) = x_in1;
        rec_x(:,:,2) = x_in2;
        rec_x(:,:,3) = x_in3;
        rec_x(:,:,4) = x_in4;
        
        rec_y(:,:,1) = y_in1;
        rec_y(:,:,2) = y_in2;
        rec_y(:,:,3) = y_in3;
        rec_y(:,:,4) = y_in4;
        
        rec_x_min = min(rec_x, [], 3);
        rec_x_max = max(rec_x, [], 3);
        rec_y_min = min(rec_y, [], 3);
        rec_y_max = max(rec_y, [], 3);
        
        
        k = nan(length(xo(:)), 1);
        for i = 1 : length(xo(:))
            in = find(xo(i)>=rec_x_min & yo(i)>=rec_y_min & xo(i)<=rec_x_max & yo(i)<=rec_y_max);
            if length(in)==1
                k(i) = in;
            elseif length(in) > 1
                for j = 1 : length(in)
                    t=in(j);
                    [ix, iy] = ind2sub([nx-1, ny-1], t);
                    if inpolygon(xo(i), yo(i), squeeze(rec_x(ix, iy, :)), squeeze(rec_y(ix, iy, :)))
                        k(i) = in(j);
                        continue
                    end
                end
            end
            
        end

        x_center = mean(rec_x, 3);
        y_center = mean(rec_y, 3);
        
        k(isnan(k)) = knnsearch([x_center(:) y_center(:)], [xo(isnan(k)) yo(isnan(k))]);

        % This mehtod does not work with WRF regional grid.
        %         x_center = (x_in1 + x_in2 + x_in3 + x_in4) / 4;
        %         y_center = (y_in1 + y_in2 + y_in3 + y_in4) / 4;
        %
        %         k = knnsearch([x_center(:) y_center(:)], [xo yo]);
        
        [ix, iy] = ind2sub([nx-1, ny-1], k);

        id1 = sub2ind([nx,ny], ix, iy);
        id2 = sub2ind([nx,ny], ix+1, iy);
        id3 = sub2ind([nx,ny], ix+1, iy+1);
        id4 = sub2ind([nx,ny], ix, iy+1);
        
        
        px = x([id1 id2 id3 id4]);
        py = y([id1 id2 id3 id4]);
        
        id = [id1(:) id2(:) id3(:) id4(:)];
%         weight = interp_rectangle_calc_weight(px, py, xo, yo);
        weight = interp_quadrilateral_calc_weight(px, py, xo, yo);
        
        
        if Extrap
            % Calculate bdy_id
            sub1 = [repmat(1,ny,1); (2:nx)'          ; repmat(nx,ny-1,1); (nx-1:-1:1)'  ];
            sub2 = [(1:ny)'       ; repmat(ny,nx-1,1); (ny-1:-1:1)'     ; repmat(1,nx-1,1)];
            bdy_id = sub2ind([nx,ny], sub1, sub2);
            
            % Caluclate bdy_x and bdy_y
            bdy_x = x(bdy_id);
            bdy_y = y(bdy_id);
            
            in = inpolygon(xo, yo, bdy_x, bdy_y);
            out = find(~in);
%             id(out, :) = nan;
%             weight(out, :) = nan;
            id(out, 1) = knnsearch([x(:) y(:)], [xo(out) yo(out)], 'K', 1);
            id(out, 2:4) = 1;  % Fake
            weight(out, 1) = 1;
            weight(out, 2:4) = 0;
            
        else
            % Calculate bdy_id
            sub1 = [repmat(1,ny,1); (2:nx)'          ; repmat(nx,ny-1,1); (nx-1:-1:1)'  ];
            sub2 = [(1:ny)'       ; repmat(ny,nx-1,1); (ny-1:-1:1)'     ; repmat(1,nx-1,1)];
            bdy_id = sub2ind([nx,ny], sub1, sub2);
            
            % Caluclate bdy_x and bdy_y
            bdy_x = x(bdy_id);
            bdy_y = y(bdy_id);
            
            in = inpolygon(xo, yo, bdy_x, bdy_y);
            out = find(~in);
            id(out, :) = nan;
            weight(out, :) = nan;
        end

        % Merge the weight and id into one cell
        weight_h.id = id;
        weight_h.w = weight;
        weight_h.method = METHOD_2D;
        weight_h.dims1 = dims;
        weight_h.dims2 = dimso;
        
    %----------------------------------------------------------------    
    % Inversed Distance Method
    case 'ID'

        

        
%         if ~isempty(varargin)
%             error('Something was un-used.')
%         end
        
        % Find the nearest np points around each (x2, y2)
        [id, d] = knnsearch([x, y], [xo, yo], 'K', np);
        d = max(1e-8, d);
        
        % Calculate the weight
        inverse_d = 1./d.^Power;
        weight = inverse_d ./ repmat(sum(inverse_d,2),1,np);
        
        % Merge the weight and id into one cell
        weight_h.id = id;
        weight_h.w = weight;
        weight_h.method = METHOD_2D;
        weight_h.dims1 = dims;
        weight_h.dims2 = dimso; 

    otherwise
        error('Unkown METHOD_2D.')
end

weight_h.Global = Global;


end

%==========================================================================
% 
%         Physical Coordinate          Logical Coordinate
%            4----------3                4----------3 
%           /            \               |          |
%          /              \              |          |
%         /                \             |          |
%        1------------------2            1----------2
%
%                  y                         m
%                 |                         |
%                 |___ x                    |___ l
%
%  P1 :          (x1, y1)                   (0, 0)
%  P2 :          (x2, y2)                   (1, 0)
%  P3 :          (x3, y3)                   (1, 1)
%  P4 :          (x4, y4)                   (0, 1)
%
% ---> 1. Mapping from (x, y) to (l, m)
%         x = a1 + a2*l + a3*m + a4*l*m 
%         y = b1 + b2*l + b3*m + b4*l*m
%
% ---> 2. Geting the mapping from (l, m) to (x, y)
%         l = (x-a1-a3*m) / (a2+a4*m)
%                               (a4*b3-a3*b4) * m^2 +
%         (a4*b1-a3*b2+a2*b3-a1*b4+x*b4-y*a4) * m   +
%                     (a2*b1-a1*b2+x*b2-y*a2)          = 0
%         m = [-bb + sqrt(bb^2-4*aa*cc)] / (2*aa)
%
% ---> 3. Do the interpolation in Logical Coordinate
%
%==========================================================================
function w = interp_quadrilateral_calc_weight(px, py, x0, y0)

% px = [-1, 8, 13, -4];
% py = [-1, 3, 11, 8];
% T = px + 2*py;
% x0 = [2 6 8];
% y0 = [2 6 7];
% TT0 = x0 + 2*y0;


x0 = x0(:);
y0 = y0(:);

[n1, n2] = size(px);
n3 = length(x0);

if n1~=n3
    disp([n1 n3])
    error('The size of inputs are wrong.')
end

if n2==1
    px = px(:)';
    py = py(:)';
end

% ---> 1. Mapping from (x, y) to (l, m)
A=[1 0 0 0;
   1 1 0 0;
   1 1 1 1;
   1 0 1 0];
% AI = inv(A);
% a = AI*px;
% b = AI*py;
% a = (A \ px')';
% b = (A \ py')';
AI =[ 1  0  0  0;
     -1  1  0  0;
     -1  0  0  1;
      1 -1  1 -1];
AI = AI';
a = px * AI;
b = py * AI;


% ---> 2. Geting the mapping from (l, m) to (x, y)
aa = a(:,4).*b(:,3) - a(:,3).*b(:,4);
bb = a(:,4).*b(:,1) - a(:,3).*b(:,2) + a(:,2).*b(:,3) - a(:,1).*b(:,4) + x0.*b(:,4) - y0.*a(:,4);
cc = a(:,2).*b(:,1) - a(:,1).*b(:,2) + x0.*b(:,2) - y0.*a(:,2);
m0 = (-bb + sqrt(bb.^2-4*aa.*cc)) ./ (2*aa);
l0 = (x0-a(:,1)-a(:,3).*m0)  ./ (a(:,2)+a(:,4).*m0);
% aa = a(4)*b(3) - a(3)*b(4);
% bb = a(4)*b(1) - a(3)*b(2) + a(2)*b(3) - a(1)*b(4) + x0*b(4) - y0*a(4);
% cc = a(2)*b(1) - a(1)*b(2) + x0*b(2) - y0*a(2);
% m0 = (-bb + sqrt(bb.^2-4*aa*cc)) / (2*aa);
% l0 = (x0-a(1)-a(3)*m0)  ./ (a(2)+a(4)*m0);

% For rectangle grid (aa=0)
k = find(aa==0);
dx = max(abs(px(k,2)-px(k,1)), abs(px(k,3)-px(k,2)));
dy = max(abs(py(k,2)-px(k,1)), abs(py(k,3)-px(k,2)));
l0(k) = (x0(k)-px(k,1)) ./ dx;
m0(k) = (y0(k)-py(k,1)) ./ dy;
% l0(k) = (x0(k)-px(k,1)) ./ (px(k,2)-px(k,1));
% m0(k) = (y0(k)-py(k,1)) ./ (py(k,3)-py(k,2));

% ---> 3. Do the interpolation in Logical Coordinate
%         Calculate the weightd
w(:,1) = (1-l0) .* (1-m0);
w(:,2) =    l0  .* (1-m0);
w(:,3) =    l0  .*    m0 ;
w(:,4) = (1-l0) .*    m0 ;

% figure
% subplot(1,2,1)
% hold on
% plot([px;  px(1)], [py;  py(1)], 'ko-', 'linewidth', 1.3, 'MarkerFaceColor', 'k')
% plot(x0, y0, 'bo', 'MarkerFaceColor', 'b')
% 
% subplot(1,2,2)
% hold on
% plot([0 1 1 0 0], [0 0 1 1 0], 'ko-', 'linewidth', 1.3, 'MarkerFaceColor', 'k')
% plot(l0, m0, 'bo', 'MarkerFaceColor', 'b')
end

function w = interp_rectangle_calc_weight(px, py, x0, y0)

% px = [-1, 8, 13, -4];
% py = [-1, 3, 11, 8];
% T = px + 2*py;
% x0 = [2 6 8];
% y0 = [2 6 7];
% TT0 = x0 + 2*y0;


x0 = x0(:);
y0 = y0(:);

[n1, n2] = size(px);
n3 = length(x0);

if n1~=n3
    error('The size of inputs are wrong.')
end

if n2==1
    px = px(:)';
    py = py(:)';
end

% grid resolution
% dx = max(px(1,:)) - min(px(1,:));
% dy = max(py(1,:)) - min(py(1,:));
dx = max(px, [], 2) - min(px, [], 2);
dy = max(py, [], 2) - min(py, [], 2);



% 
w(:,1) = (px(:,3)-x0).*(py(:,3)-y0) ./ dx ./ dy;
w(:,2) = (px(:,4)-x0).*(py(:,4)-y0) ./ dx ./ dy;
w(:,3) = (px(:,1)-x0).*(py(:,1)-y0) ./ dx ./ dy;
w(:,4) = (px(:,2)-x0).*(py(:,2)-y0) ./ dx ./ dy;

w = abs(w);

end