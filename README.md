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

## Dataset (/dataset)
Following files include behavioral information during training sessions.
- wholeses_airpuff.mat
- wholeses_omission.mat

The information below is included in each file.
| Column | Description |
| ---- | ---- |
| success | Lever successfully pulled (0/1) |
| Cue1 | tone A was presented (0/1) |
| Cue2 | tone B was presented (0/1) |
| reward | Reward (water) was presented (0/1) |
| punish | Punishment (airpuff) was presented (0/1) |
| RT | Response Time |
| ses_len | Number of trials for each training session |
| ses_len1 | Number of tone A trials for each training session |
| ses_len2 | Number of tone B trials for each training session |

Following files include behavioral information for acsf/muscimol sessions.
- airpuff_acsf_history.mat
- airpuff_muscimol_history.mat
- omission_acsf_history.mat
- omission_muscimol_history.mat

The information below is included in each file.
| Column | Description |
| ---- | ---- |
| trial_idx | ID of each trial |
| success | Lever successfully pulled (0/1) |
| Cue1 | tone A was presented (0/1) |
| Cue2 | tone B was presented (0/1) |
| reward | Reward (water) was presented (0/1) |
| punish | Punishment (airpuff) was presented (0/1) |
| RT | Response Time |
| consumatoryLick | Number of licks after reward presentation |
| anticipatoryLick | Number of licks before go cue |
| earlypull | Number of pulls before go cue |
| analyzed | Trials prior to obtaining 60% of the total planned reward (0/1)|
| LeverPullDuration | Duration of lever pulled above the threshold |
| LickDuration | Duration of licking |
| PullSpeed | Speed of pulling lever |

## How to run (/codes)

To reproduce Figure 2,   
* `Fig2_fitting.m` repeats fitting 5000 (50x100) times and plots the fitted parameters. Executing this code takes about 3 days; therefore, we pre-store the parameters in advance in the 'param/' directory.
* `Fig2_fitting_result_aggregation.m` aggregates 100 fitting results and chooses the parameters of the maximum log likelihood.

To reproduce Figure 4,   
* `Fig4_parameter_plotting.m` plots fitted parameters.  

To reproduce Figure 6,   
* `Fig6_optimization_plotting_airpuff` plots optimization results for the airpuff task.

To reproduce Supplementary Figure 1,   
* `SupFig1_prediction.m` plots prediction results.
  
To reproduce Supplementary Figure 2,  
* `SupFig2_simulation.m` repeats simulation 1000 times and output plotted figures of simulation results and RMSE averaged across 1000 simulation results.

To reproduce Supplementary Figure 3,  
* `SupFig3_optimization.m` conducts optimization of each parameter and outputs the optimized parameters.  
* `SupFig3_trialsimulation.m` plots simulation results using the original parameters.  
* `SupFig3_trialsimulation_optimized.m` plots simulation results using optimized parameters.  

To reproduce Supplementary Figure 5,   
* `SupFig5_optimization_plotting_omission` plots optimization results for the omission task.
