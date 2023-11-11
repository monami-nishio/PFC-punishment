# PFC-punishment
## How to run
First, clone this repository.  

To reproduce Supplementary Figure1,   
* `codes/SupFig1_fitting.mat` will output the fitted parameters.
* `codes/SupFig1_parameter_plotting.mat` will output plotted figures of fitted parameters.  
* `codes/SupFig1_prediction.mat` will output plotted figures of prediction results.
  
To reproduce Supplementary Figure2,  
* `codes/SupFig2_simulation.mat` will output plotted figures of simulation results.

To reproduce Supplementary Figure3,  
* `codes/SupFig3_optimization.mat` will output the optimized parameters.  
* `codes/SupFig3_trialsimulation.mat` will output plotted figures of simulation results using the original parameters.  
* `codes/SupFig3_trialsimulation_optimized.mat` will output plotted figures of simulation results using optimized parameters.  

## Detailed Description of each file
### SupFig1_fitting
* Train Q-learning model with training sessions.  
* output: fitted parameters, plotted figures of fitted parameters
  
### SupFig1_prediction
* Predict mice behavior with fitted parameters.  
* output: plotted figures
  
### SupFig2_simulation
* Simulate training sessions with fitted parameters.  
* output: plotted figures

### SupFig3_optimization
* Optimize parameters to acsf/muscimol sessions.  
* output: optimized parameters  
  
### SupFig3_trialsimulation
* Simulate acsf/musicmol sessions with original/optimized parameters.  
* output: plotted figures 