function initialize(obj, rgc, sensor, outersegment, varargin)
% intialize: a method of @rgcMosaicLNP that initializes the object based on a
% series of input parameters that can include the location of the
% retinal patch.
% 
% Inputs:
% 
% Outputs:
% 
% Example:
% 
% (c) isetbio
% 09/2015 JRG


% %% Add generator function
% % Need to make this into Gaussian CDF
% for cellTypeInd = 1:obj.numberCellTypes
%     obj.generatorFunction = @erf;
    obj.generatorFunction = @exp;
%     obj.generatorFunction = @(x) 10*erf(x);
    
    obj.postSpikeFilter = buildPostSpikeFilter(.01);
    
    [obj.couplingFilter, obj.couplingMatrix] = buildCouplingFilters(obj, .01);

% end

