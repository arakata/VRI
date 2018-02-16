% Computes the Nash-Sutcliffe efficiency coefficient, excludes pairs where
% NaN values exist.
% 
%CITATION
% Nash, J.E. and J.V. Sutcliffe (1970), River flow forecasting through
% conceptual models Part I - A discussion of princiles, Journal of
% Hydrology, 10(3), 282-290.
% 
%RELEASE NOTES
% Written by Mark Raleigh (mraleig1@uw.edu)
% Version 1.0 released on January 27, 2010
% 
%INPUTS
% obs = nx1 or 1xn array, observed values
% sim = nx1 or 1xn array, simulated values
% 
%OUTPUTS
% ns = 1x1 N-S efficiency coefficient
% * Read the citation to interpret the value of this coefficient

%
function ns = nashsutcliffe(obs,sim)

% Checks
if length(obs) ~= length(sim)
    error('Vectors must be of equal length')
end

if size(obs,1) >1 && size(obs,2) > 1
    error('obs must be an aray')
end

if size(sim,1) >1 && size(sim,2) > 1
    error('obs must be an aray')
end

if size(obs,2) > 1
    obs = obs';
end

if size(sim,2) > 1
    sim = sim';
end

% Code
    
    if max(isnan(obs)==1) || max(isnan(sim)==1)
        if max(isnan(obs)==1)
            disp('Warning: NaN Values detected in observed data set.  Pairs with NaN values excluded from Nash-Sutcliffe calculation.')
        elseif max(isnan(sim)==1)
            disp('Warning: NaN Values detected in simulated data set.  Pairs with NaN values excluded from Nash-Sutcliffe calculation.')
        end
        
        no_NaN = find(isnan(obs) == 0 & isnan(sim) == 0);
        
        obs_real = obs(no_NaN);
        sim_real = sim(no_NaN);
        
    else
        obs_real = obs;
        sim_real = sim;

    end

    ns = 1 - sum((obs_real-sim_real).^2)/sum((obs_real-mean(obs_real)).^2);
end