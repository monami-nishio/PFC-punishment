# PFC-punishment
## How to run
First, clone this repository.  

To reproduce Supplementary Figure1,   
* `codes/SupFig1_fitting.mat` repeats fitting 100 times and plots the fitted parameters.
* `codes/SupFig1_fitting_result_aggregation.mat` aggregates 100 fitting results and extracts the median value for each parameter.
* `codes/SupFig1_parameter_plotting.mat` plots fitted parameters.  
* `codes/SupFig1_prediction.mat` plots prediction results.
  
To reproduce Supplementary Figure2,  
* `codes/SupFig2_simulation.mat` repeats simulation 1000 times and output plotted figures of simulation results and RMSE averaged across 1000 simulation results.

To reproduce Supplementary Figure3,  
* `codes/SupFig3_optimization.mat` conducts optimization of each parameter and outputs the optimized parameters.  
* `codes/SupFig3_trialsimulation.mat` plots simulation results using the original parameters.  
* `codes/SupFig3_trialsimulation_optimized.mat` plots simulation results using optimized parameters.  
