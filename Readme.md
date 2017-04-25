#  CER Electricity Subsidy Prediction

> Data used for this project is Smart Meter Electricity Trial data.It consists of 6 zipped files of 2.5GB size.

## Description of above files :

- main.R 
	* The main function of the entire code. Calls the different function and displays the final output.

- preprocessing.R
	* Function to read 6 text files and extract features such as average consumption, working hours consumption, monthly consumption or 	      yearly consumption.

- feature_extraction.R
	* Function to extract features from “Residential Pre Trial Survey” such as income category, number of heave devices and their 		  usage, etc.

- collection.R
	* A function to merge the above extracted features based on MeterID.

- makePlots.R
	* A function for data visualization and exploratory data analysis. It saves the plots in PNG format in the working directory.

- elbow.R
	* Implementation of elbow-method to find the optimal value of ‘K’ for K-means algorithm.
	  Also, saves the final plot in current working directory.

- algorithms.R
	* A generalized function to predict income using Support Vector Machines(SVM) and  Random Forest. It also classifies the users into 	      4 groups based on their consumption patterns, number of devices, income categories, etc. using K-means algorithm.

- package.R
	* This script is used to install all packages required for this project. 

- newdf.csv 
	* This is an intermediate dataframe produced by feature_extraction.R for further data processing.
	
	
## Description of mentioned folders :

- Exploratory Data Analysis :
	* Contains figures which helped us to capture the trends and distribution of the dataset.

- Cluster1 Analysis: 
	* Contains figures produced by applying kmeans algorithm on the dataset,which was predicted by the 					  Support Vector Machine(svm). 

- Cluster2 Analysis: 
	* Contains figures produced by applying kmeans algorithm on the dataset,which was predicted by the 					  Random Forest.

- Elbow Method: 
	* This figure concludes the appropriate k value for kmeans algorithm.

