# PFC-punishment

## About
This is the code to replicate the fitting, prediction, and simulation analysis of the reinforcement model in Nishio et al.
[Link to the paper]

## How to run
First, clone this repository.  

To reproduce Figure 4,   
* `codes/Fig4_parameter_plotting.m` plots fitted parameters.  

To reproduce Figure 6,   
* `codes/Fig6_optimization_plotting_airpuff` plots optimization results for the airpuff task.

To reproduce Supplementary Figure 1,   
* `codes/SupFig1_fitting.m` repeats fitting 100 times and plots the fitted parameters.
* `codes/SupFig1_fitting_result_aggregation.m` aggregates 100 fitting results and chooses the parameters of the smallest likelihood.
* `codes/SupFig1_prediction.m` plots prediction results.
  
To reproduce Supplementary Figure 2,  
* `codes/SupFig2_simulation.m` repeats simulation 1000 times and output plotted figures of simulation results and RMSE averaged across 1000 simulation results.

To reproduce Supplementary Figure 3,  
* `codes/SupFig3_optimization.m` conducts optimization of each parameter and outputs the optimized parameters.  
* `codes/SupFig3_trialsimulation.m` plots simulation results using the original parameters.  
* `codes/SupFig3_trialsimulation_optimized.m` plots simulation results using optimized parameters.  

To reproduce Supplementary Figure 5,   
* `codes/SupFig5_optimization_plotting_omission` plots optimization results for the omission task.
