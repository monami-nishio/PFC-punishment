# PFC-punishment
## How to run
First, clone the repository and set the path.  
> [!WARNING]
> 今となってはパスを通す必要はないはず？
> 
To reproduce Supplementary Figure1,   
* `codes/SupFig1_fitting/fitting.mat` will output the fitted parameters in `param/original/` folder.   
* `codes/SupFig1_prediction/prediction.mat` will output the eps file in `result/` folder.
> [!WARNING]
> この順番でないとだめ，という記載がない．predictionではfittingで推定したparamを読んでいる．現時点でresultにデータが入っているの動きはするが・・・

To reproduce Supplementary Figure2,  
* `codes/SupFig2_simulation/simulation.mat` will output the eps file in `result/` folder.

To reproduce Supplementary Figure3,  
* `codes/SupFig3_optimization/optimization.mat` will output the optimization results in `param/optimized/` folder.  
* `codes/SupFig3_trialsimulation/trialsimulation.mat` will output the eps file of simulation results using original parameters in `result/` folder.  
* `codes/SupFig3_trialsimulation/trialsimulation_optimized.mat` will output the eps file of simulation results using optimized parameters in `result/` folder.  
> [!WARNING]
> これも上から順次実行しないとだめ？

**あと提案ですが，結局ファイル名を固有にしたならmainから呼び出す関数はすべて`scripts`フォルダに入れてしまい，直接実行するコードだけを`S1_xxxx.mat`，`S2_yyyy.mat`とかにしてひとまとめにしてしまえばいちいちディレクトリ移動しなくて楽です．**

## Detailed Description of each file
### SupFig1_fitting
* Train Q-learning model with training sessions  
* output: fitted parameters in "../param/original"  
  
### SupFig1_prediction
* Predict mice behavior with fitted parameters  
* output: plotted figures in "result/"  
  
### SupFig2_simulation
* Simulate training sessions with fitted parameters  
* output: plotted figures in "result/"  

### SupFig3_optimization
* Optimize parameters to acsf/muscimol sessions  
* output: optimized datas in "../param/optimized"  
  
### SupFig3_trialsimulation
* Simulate acsf/musicmol sessions with original/optimized parameters  
* output: plotted figures in "result/"  
