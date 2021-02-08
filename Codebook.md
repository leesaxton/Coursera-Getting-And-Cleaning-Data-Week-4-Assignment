**Codebook for getting and cleaning data week 4 assignment**  
**Author: Lee Saxton**  
**Date: 08 Feb 2021**  

2 datasets are ouput from run_analysis.R  
merge_all_keep - contains mean and standard deviation measurments from stury outline in ReadMe.txt  
final_mean - contains mean of measurements grouped by activity and subject  
For this study there were 30 subjects performing 6 activities:  
Laying  
Sitting  
Standing  
Walking  
Walking downstairs  
Walking Upstairs  
The following measurments are provided  
TimeGravity Accelerometer - in 3 components (X,Y,Z) measured in units of g  
TimeBody Accelerometer - As above but after subtracting the gravity from total acceleration  
Angular velocity measurements obtained from gyroscope, units are radians / s  
Frequency domain measurements are obtained by applying a FFT to the time sampled data  