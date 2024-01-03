# PFC-punishment

## About
This is the codes to replicate the fitting, prediction, and simulation analysis of the reinforcement model in Nishio et al.  
[Link to the paper]

## Setup
The code is initially executed in MATLAB 2023a on a Mac.
Install following MATLAB packages 
* Optimization Toolbox [https://www.mathworks.com/products/optimization.html]
* Statistics and Machine Learning Toolbox [https://www.mathworks.com/products/statistics.html]
Clone this repository.  

## How to run

To reproduce Figure 2,   
* `codes/Fig2_fitting.m` repeats fitting 5000 (50x100) times and plots the fitted parameters. Executing this code takes about 3 days; therefore, we pre-store the parameters in advance in the 'param/' directory.
* `codes/Fig2_fitting_result_aggregation.m` aggregates 100 fitting results and chooses the parameters of the maximum log likelihood.

To reproduce Figure 4,   
* `codes/Fig4_parameter_plotting.m` plots fitted parameters.  

To reproduce Figure 6,   
* `codes/Fig6_optimization_plotting_airpuff` plots optimization results for the airpuff task.

To reproduce Supplementary Figure 1,   
* `codes/SupFig1_prediction.m` plots prediction results.
  
To reproduce Supplementary Figure 2,  
* `codes/SupFig2_simulation.m` repeats simulation 1000 times and output plotted figures of simulation results and RMSE averaged across 1000 simulation results.

To reproduce Supplementary Figure 3,  
* `codes/SupFig3_optimization.m` conducts optimization of each parameter and outputs the optimized parameters.  
* `codes/SupFig3_trialsimulation.m` plots simulation results using the original parameters.  
* `codes/SupFig3_trialsimulation_optimized.m` plots simulation results using optimized parameters.  

To reproduce Supplementary Figure 5,   
* `codes/SupFig5_optimization_plotting_omission` plots optimization results for the omission task.
