%==========================================================================
% Generate the horizontal interpolation weights
% Method : 
%   Inverse distance interpolation
%   1) Find out the several nearest points (default is 6)
%   2) Calculate the weights
%                    1 / d(i)^power
%       w(i) = ---------------------------------
%                 sum( 1 / d(i)^power )
%          (i=1,2...np)
%
% Input  : x1 (node1)
%          y1 (node1)
%          x2 (node2)
%          y2 (node2)
%          'np' (option) selected nearest point number (default is 6)
%          'power' (option) power in inverse distance interpolation 
%                (default is 2)
% Output : weight_h (cell)
%           -id (node2,np)
%           -weight (node2,np)
%
% Siqi Li, SMAST
% 2020-02-07
%
% Updates:
% 2020-03-18  Siqi Li, Merge the output into one cell
% 2020-03-17  Siqi Li, Fixed the bug when two points are exactly the same.
% 2020-03-16  Siqi Li, The interpolation method is changed to inverse
%                      distance interpolation.
%==========================================================================
function weight_h = interp_horizontal_calc_weight(x1, y1, x2, y2, varargin)

x1=x1(:);
y1=y1(:);

% dimensions
node1=length(x1);
node2=length(x2);

% inverse distance interpolation
np=6;         % selected nearest points number
power=2;          % power over distance 

k=1;
% Input 
while k<=length(varargin)
    switch lower(varargin{k})
        case 'np'
            np=varargin{k+1};
        case 'power'
            power=varargin{k+1};            
    end
    k=k+2;
end


% assign the output
d=nan(node2,np);
id=nan(node2,np);


[id, d] = knnsearch([x1, y1], [x2, y2], 'K', np);
% for i=1:node2
%     if (mod(i,100)==0)
%         fprintf('-----%d / %d------\n',i,node2)
%     end
%     disttemp=sqrt( (x1-x2(i)).^2 + (y1-y2(i)).^2 );
%     [~,idtmp]=sort(disttemp);
%     id(i,:)=idtmp(1:np)';
%     d(i,:)=disttemp(id(i,:));
% end



% Matrix run
% step=100;
% i2=0;
% while i2<node2
%     if (mod(i2,step)==0)
%         fprintf('-----%d / %d------\n',i2,node2)
%     end
%     i1=i2+1;
%     i2=min(i2+step,node2);
%     x_dst=repmat(x2(i1:i2),1,node1);
%     y_dst=repmat(y2(i1:i2),1,node1);
%     x_src=repmat(x1',i2-i1+1,1);
%     y_src=repmat(y1',i2-i1+1,1);
%     distemp=sqrt( (x_dst-x_src).^2 + (y_dst-y_src).^2 );
%     [~,idtemp]=sort(distemp,2);
%     id(i1:i2,:)=idtemp(:,1:np);
% end

% The location is exactly the same
% id_exact=find(d(:,1)<1e-8);
% d(id_exact,1)=1e-8;
d=max(1e-8,d);

% Calculate the weight
weight=1./d.^power ./ repmat(sum(1./d.^power,2),1,np);

% Merge the weight and id into one cell
weight_h.id=id;
weight_h.w=weight;

%   1) find out the three nearest points 
%   2) if the destination point is in the triangle of these three points
%        --- in, interpolate
%        --- otherwise, nearest value
% % assign the output
% id=nan(node2,3);
% weight=nan(node2,3);
% for i=1:node2
%     
%     disttemp=sqrt( (x1-x2(i)).^2 + (y1-y2(i)).^2 );
%     [~,idtmp]=sort(disttemp);
%     idtmp=idtmp(1:3);
%     
%     IN=inpolygon(x2(i),y2(i),x1(idtmp([1 2 3 1])),y1(idtmp([1 2 3 1])));
% 
%     if (IN)
%         x0=x2(i);
%         y0=y2(i);
%         x=x1(idtmp);
%         y=y1(idtmp);
%         
%         tmp=(y(2)-y(3))*(x(1)-x(3))+(x(3)-x(2))*(y(1)-y(3));
%         weight(i,1)=((y(2)-y(3))*(x0-x(3))+(x(3)-x(2))*(y0-y(3)))/tmp;
%         weight(i,2)=((y(3)-y(1))*(x0-x(3))+(x(1)-x(3))*(y0-y(3)))/tmp;
%         weight(i,3)=1-weight(i,2)-weight(i,1);
%         id(i,:)=idtmp;
%     else
%         id(i,:)=[idtmp(1) idtmp(1) idtmp(1)];
%         weight(i,:)=[1 0 0];
%     end
%            
% end
