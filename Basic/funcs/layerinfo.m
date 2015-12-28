function [S,L] = layerinfo(glib)
%function [S,L] = layerinfo(glib)
%
% layerinfo :  displays information about the
%              distribution of elements on layers
%              in a gds_library object.
%
% glib :  a gds_library object
% S :     (Optional) structure array with number of element 
%         per layer.
%         S(k).(etype) contains the number of elements of 
%         type 'etype' on layer k. E.g.: S(10).boundary
%         When the output argument is omitted, the layer
%         information is printed on the screen.
% L :     (Optional) a vector with layers that contain elements
%

% initial version, Ulf Griesmann, NIST, November 16, 2012

    % check argument
    if ~isa(glib, 'gds_library')
        error('layerinfo :  argument must be a gds_library object.');
    end
    
    % initialize variables for accounting
    numl = 256; % max number of layers
    for k=1:numl
        S(k) = struct('boundary',0, 'path',0, 'box',0, 'node',0, 'text',0);
    end
    L = zeros(1,numl);
    
    % iterate over all structures
    for k=1:numst(glib)
        
        % structure
        st = glib(k);
        
        % iterate over all elements
        for m=1:numel(st)
            el = st(m);
            if ~is_ref(el)            % sref and aref have no layer information
                numl = el.layer + 1;  % gds layer numbers start with 0
                L(numl) = L(numl) + 1; 
                S(numl).(etype(el)) = S(numl).(etype(el)) + 1;
            end
        end
    end

    %display
    if ~nargout
        fprintf('\n');
        for k = find(L)
            fprintf('L %-3d ->  ', k-1); % layers start with 0
            if S(k).boundary
                fprintf('%8d Bnd ', S(k).boundary);
            end
            if S(k).path
                fprintf('%8d Pth ', S(k).path);
            end
            if S(k).box
                fprintf('%8d Box ', S(k).box);
            end
            if S(k).node
                fprintf('%8d Nde ', S(k).node);
            end
            if S(k).text
                fprintf('%8d Txt ', S(k).text);
            end 
            fprintf('\n');
        end
        fprintf('\n');
    end
    
    % return layer numbers with elements
    L = find(L) - 1;
    
end
