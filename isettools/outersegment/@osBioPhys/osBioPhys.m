classdef osBioPhys < outerSegment 
% BioPhys subclass of the outersegment object
% 
%       os = osBioPhys();
% 
% Converts isomerizations (R*) to outer segment current (pA). The
% difference equation model by Rieke implements a biophysical
% simulation of the phototransduction cascade. If the noiseFlag
% property of the osLinear object is set to 1, this method will add noise
% to the current output signal.
%
% Reference:
%   http://isetbio.org/cones/adaptation%20model%20-%20rieke.pdf
%   https://github.com/isetbio/isetbio/wiki/Cone-Adaptation
% 
% JRG/HJ/BW, ISETBIO Team, 2016

    properties(Access = public)
        state;   % biophysics parameter state

        sigma;       % rhodopsin activity decay rate (1/sec) - default 22
        phi;       % phosphodiesterase activity decay rate (1/sec) - default 22
        eta;      % phosphodiesterase activation rate constant (1/sec) - default 2000
        gdark;     % concentration of cGMP in darkness - default 20.5
        k;     % constant relating cGMP to current - default 0.02
        h;        % cooperativity for cGMP->current - default 3
        cdark;        % dark calcium concentration - default 1
        beta;        % rate constant for calcium removal in 1/sec - default 9
        betaSlow;   % rate constant for slow calcium modulation of channels - default 0.4
        n;        % cooperativity for cyclase, hill coef - default 4
        kGc;      % hill affinity for cyclase - default 0.5
        OpsinGain;   % so stimulus can be in R*/sec (this is rate of increase in opsin activity per R*/sec) - default 10
        
        q;
        smax;
        
        bgCur;
        
        opsin
        PDE     
        Ca     
        Ca_slow 
        st      
        cGMP   
    end
    

    
    methods
        
        function obj = osBioPhys(varargin)
            
            %         % Peripheral parameters
                        obj.sigma = 22;  % rhodopsin activity decay rate (1/sec) - default 22
                        obj.phi = 22;     % phosphodiesterase activity decay rate (1/sec) - default 22
                        obj.eta = 2000;	  % phosphodiesterase activation rate constant (1/sec) - default 2000
                        obj.gdark = 20.5; % concentration of cGMP in darkness - default 20.5
                        obj.k = 0.02;     % constant relating cGMP to current - default 0.02
                        obj.h = 3;       % cooperativity for cGMP->current - default 3
                        obj.cdark = 1;  % dark calcium concentration - default 1
                        obj.beta = 9;	  % rate constant for calcium removal in 1/sec - default 9
                        obj.betaSlow = 0.4; % rate constant for slow calcium modulation of channels - default 0.4
                        obj.n = 4;  	  % cooperativity for cyclase, hill coef - default 4
                        obj.kGc = 0.5;   % hill affinity for cyclase - default 0.5
                        obj.OpsinGain = 10; % so stimulus can be in R*/sec (this is rate of increase in opsin activity per R*/sec) - default 10            
                        obj.q    = 2 * obj.beta * obj.cdark / (obj.k * obj.gdark^obj.h);
                        obj.smax = obj.eta/obj.phi * obj.gdark * (1 + (obj.cdark / obj.kGc)^obj.n);
            
            % Foveal parameters
%             obj.sigma = 10;       % rhodopsin activity decay rate (1/sec) - default 22
%             obj.phi   = 22;       % phosphodiesterase activity decay rate (1/sec) - default 22
%             obj.eta   = 700;      % phosphodiesterase activation rate constant (1/sec) - default 2000
%             obj.gdark = 20.5;     % concentration of cGMP in darkness - default 20.5
%             obj.k     = 0.02;     % constant relating cGMP to current - default 0.02
%             obj.h     = 3;        % cooperativity for cGMP->current - default 3
%             obj.cdark = 1;        % dark calcium concentration - default 1
%             obj.beta  = 5;        % rate constant for calcium removal in 1/sec - default 9
%             obj.betaSlow = 0.4;   % rate constant for slow calcium modulation of channels - default 0.4
%             obj.n     = 4;        % cooperativity for cyclase, hill coef - default 4
%             obj.kGc   = 0.5;      % hill affinity for cyclase - default 0.5
%             obj.OpsinGain = 12;   % so stimulus can be in R*/sec (this is rate of increase in opsin activity per R*/sec) - default 10
            
            obj.q    = 2 * obj.beta * obj.cdark / (obj.k * obj.gdark^obj.h);
            obj.smax = obj.eta/obj.phi * obj.gdark * (1 + (obj.cdark / obj.kGc)^obj.n);
            
            
            % % Compute additional initial values
            % p.opsin   = bgR / p.sigma;
            % p.PDE     = (p.opsin + p.eta) / p.phi;
            % p.Ca      = bgCur * p.q / p.beta;
            % p.Ca_slow = p.Ca;
            % p.st      = p.smax ./ (1 + (p.Ca / p.kGc).^p.n);
            % p.cGMP    = p.st * p.phi ./ (p.opsin + p.eta);

        end
        
        function obj = set(obj, varargin)
            % set function, see osBioPhysSet for details
            osSet(obj, varargin{:});
        end
        
        
        function val = get(obj, varargin)
            % get function, see osBioPhysGet for details
            val = osGet(obj, varargin{:});
        end
    end
    
    methods (Access=public)        
        function obj = compute(obj, sensor, varargin)
            % see osCompute for details
            obj = osCompute(obj, sensor, varargin{:});
        end
        
        % Derive some parameters - steady state constraints among parameters
%         function q = get.q
%             q    = 2 * beta * cdark / (k * gdark^h);
%         end
%         
%         function smax = get.smax
%             smax = eta/phi * gdark * (1 + (cdark / kGc)^n);
%         end
    
        function plot(obj, sensor, varargin)
            % see osPlot for details
            osPlot(obj, sensor, varargin{:});
        end
    end
end
