# BimanualTaskStrokeStudy

This repository contains the code and models supporting the study published in:

**Movement and Force Dynamics in Bimanual Cooperative Tasks in Chronic Stroke and Healthy Individuals**

The repository includes the xPC Target Simulink model for controlling the HapticMaster robot, a Unity project for visualization, and MATLAB code for data analysis. Raw data (1.38 GB) from study participants is hosted separately on a faculty OneDrive due to its size.

## Repository Contents
- **Analysis/**: MATLAB scripts for data analysis, generating figures and tables from the paper.
- **Unity/**: Unity project for visualizing the bimanual task environment.
- **HM_control/**: xPC Target Simulink model and scripts for controlling the HapticMaster robot.
- **README.md**: This file, providing instructions for use.

## Raw Data Access
Raw data (1.38 GB) is hosted on the University of Ljubljana faculty OneDrive:  
[https://unilj-my.sharepoint.com/:u:/g/personal/janezpodobnik_fe1_uni-lj_si/Eek8FN40rmlNoFPPmhEi7LkBNtXFFf438DKxdTT3gkxIOA?e=uR2LNR](https://unilj-my.sharepoint.com/:u:/g/personal/janezpodobnik_fe1_uni-lj_si/Eek8FN40rmlNoFPPmhEi7LkBNtXFFf438DKxdTT3gkxIOA?e=uR2LNR)

1. Download the raw data file to your local machine.
2. Place the file in the `Analysis/` folder of this repository.

## Statistical Analysis
To reproduce the statistical analyses, figures, and tables (Table 1 and Table 2) from the paper:

1. Clone or download this repository to your local machine.
2. Place the raw data file (downloaded from OneDrive) in the `Analysis/` folder.
3. Open MATLAB.
4. Navigate to the `Analysis/` folder.
5. Run the script `data_analysis.m`.
   - The script processes the raw data, generates figures from the paper, and outputs data for Table 1 and Table 2.
   - Results are printed to the MATLAB console.

## Unity visualization

Unpack Unity.zip file which contains Unity project for visualization.

## HapticMaster Control

Hapticmaster control model and logics for task performed by participants is in folder `/HM_control`. xPC simulink model is `HM_to_Unity_2013a.slx`. Model is started by runing `initall.m` matlab script, which starts the GUI and loads the model on xPC target computer.

The model is tailored for the study’s task (16 targets, 3 damping levels: B0, B20, B40). Refer to the paper for task details.

## File Structure

```plaintext
BimanualTaskStrokeStudy/
├── Analysis/
│   ├── data_analysis.m
│   └── [place raw data file here]
├── Unity/
│   └── [Unity project files]
├── HM_control/
│   ├── initall.m
│   ├── HM_to_Unity_2013a.slx
│   └── [other files]
└── README.md
```

## Citation
If you use this code or data, please cite:  
[Insert final citation. Movement and Force Dynamics in Bimanual Cooperative Tasks in Chronic Stroke and Healthy Individuals.]

## Contact
For questions or issues, contact [Janez Podobnik, janez.podobnik@fe.uni-lj.si].

## License
This repository is licensed under the MIT License. Raw data is shared under a CC-BY-4.0 license, requiring attribution when reused.
