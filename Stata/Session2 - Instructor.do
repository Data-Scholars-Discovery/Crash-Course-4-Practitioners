*----------------------------------*
* PP297: Stata for Policy Analysts *
* Session 2: Intro Data Processing *
* Created by: Aaron Scherf         *
* Instructor Edition               *
*----------------------------------*

*-------------------*
* Today's Commands: *
*-------------------*

* drop
* keep
* logical operators (if)
* count
* label variable
* label define
* label values
* codebook
* recode

*----------------------*
* Review of Session 1: *
*----------------------*

* First let's quickly review some commands from Session 1, to bring in our data.

* Step 1: Clear your working environment to ensure there's no other data.

clear

* Step 2: Set your command directory to the overall working folder.
cd "C:\Users\theaa\Desktop\Crash-Course-4-Practitioners"

* Step 3: Now load in the previous "housing.dta" dataset, including the "Data"
* sub-folder in the `use` command to point to the right directory.

use "Data\housing.dta", clear

* Optional: Remember you can also create another directory path with a global.

global Data_Path = "C:\Users\theaa\Desktop\Crash-Course-4-Practitioners\Data"

cd "$Data_Path"

use "housing.dta", clear

* Step 4: Confirm you have the right dataset using `browse` and `describe`.

browse

describe

* Step 5: Quick summary stat check on a variable or two.

summarize population

tabstat total_rooms, s(mean, p50, var, sd)

*-----------------------------*
* 0. Intro to Data Processing *
*-----------------------------*

/*There is a common adage among data scientists that at least 70% of your 
time in the program will be spent cleaning and processing data.

Thus it is important to learn the functions and workflow of processing data 
early so you can become experienced (and therefore faster) at it.

The typical steps in data processing can be summarized as follows, 
as explained in this article from Towards Data Science:
https://towardsdatascience.com/the-ultimate-guide-to-data-cleaning-3969843991d4

- Inspect Data Quality
- Clean Data to Fix Anomalies
- Verify Data Quality
- Report on Changes to Dataset

You already learned the main commands necessary for inspecting data quality:
`describe`, `summarize`, `tabulate`, and `tabstat`.

The trick is knowing what kind of anomalies to look for, namely:
- Missing Data
- Improperly Formatted Data
- Errors in Data Importing
- Improper Variable or Value Labels

The whole endeavor of data processing is more art than science, meaning there
are no "right" answers that hold for every situation. Sometimes you want to 
leave missing values in, sometimes you want to replace (impute) them with other
values. Sometimes you want to label all the data you can, sometimes you don't.
It depends entirely on the usage needs and user groups for the data. You will
learn from experience what is best for your particular data situation.

For now we will just learn the technical tools to perform common data cleaning.
*/

*-------------------------*
* Inspecting Data Quality *
*-------------------------*

/* It is, unfortunately, quite common to receive "dirty data", either because
the underlying data source is messy (like in surveying humans) or the
collection or organization processes didn't follow strict formatting rules.
It's also possible for data to become messy through format conversions, such
as between different file-types, or mistakes in editing. One common mistake
is to use a non-reproducible program (like Excel) to edit data without leaving
any record of what was done. A single typo can make a whole dataset unusable.
Hence why we prefer to do things in scripts, keeping original versions of data
instead of overwriting files, and leaving a well-commented trail of any changes.

What do we mean by "dirty" or "messy" data? The biggest culprits are usually
missing values (some observations lack values for some variables) or irregular
formatting (numeric variables are read in as text-strings, dates are stored as
numeric values or text-strings, etc). The goal, therefore, is to understand where
the irregularities are and, when possible, correct them so the final dataset is 
standardized. We care about this not only to avoid losing data (most commands
will drop observations with missing values) but also to avoid errors in later
analysis. Many analytic techniques have strict requirements that data be
standardized, or at the least that all variables have a similar format.

For example, a regression model (a common statistical analysis technique) only
works if all variables can be read in as numbers. Text-strings must be converted
into categorical variables ("red", "blue", and "yellow" must be understood as 
numeric categories rather than characters). Stata can do a lot of this for you,
but it will not automatically know that "red" and "RED" should be the same.
You have to check the values to know that some text was input differently. 

How to check the data for these irregularities?

- `browse` is comprehensive but time intensive, particularly for bigger datasets
- `tab` works well for variables with only a few unique values

*/


************************
* Variable Management: *
************************

* Load in the American Community Survey dataset
use "data\ACS_17_Basics.dta", clear

* Create a new variable, "minor" with all values of 0
gen minor = 0

tab minor

* Replace the values for "minor" based on the "age" variable
replace minor = 1 if age <= 18 

tab minor

* What does the year variable tell us? What should we do with it?
tab year // Notice there is only one survey year.

drop year // Therefore the variable is not helpful for us.

* What about the other variables? Which are useful for us?
keep sex age marst educ educd inctot ftotinc poverty poverty_bin edu_simple // Likewise, many other variables aren't important right now

* What does the poverty variable look like?
tab poverty // Not what we usually expect from a poverty variable!

* How would we rather have "poverty" look?
replace poverty = poverty_bin // You can completely overwrite variables with other variables, but remember the original "poverty" variable is gone forever!

tab poverty

drop poverty_bin

***************************************
* Mathematical and Logical Operators: *
***************************************

* Mathematical Operators:

* Add 2+2
display 2+2 // Stata is really just the world's most unnecessarily complex calculator

* Calculate 2^2
display 2^2 // Exponentials

* Calculate the absolute value of -2
display abs(-2) // Absolute value

* Calculate the square root of 16
display sqrt(16) // Square root

* Calculate the max value of the set (1,2,3)
display max(1,2,3) // Max value

*Calculate the natural log of 1
display ln(1) // Natural log

* What is the closest integer below 4.5?
display floor(4.5) // Rounded down to nearest integer

* What is the closest integer to 4.5?
display round(4.6) // Rounded to nearest integer

* What is the closest integer above 4.5?
display ceil(4.5) // Rounded up to nearest integer

* How do we check for other mathematical operators?
help math_functions


* Logical Operators:

* Is 1 equal to 1?
display 1 == 1

* Is 1 equal to 0?
display 1 == 0

* Is 2 greater than 3?
display 2 > 3

* Is 1 not equal to 5,424,526?
display 1 != 5424526


* Using logical operators in summary statistics:

* Count the number of minors in the sample.
count if age < 18 // Return number of minors

* How can we check that we're right?
tabstat minor, s(n) // Should have the same number of minors!

* How much education do those living below the poverty line have?
tab edu_simple if poverty == 1

* What if we wanted to compare the poor and non-poor by education level?
tabstat edu_simple, by(poverty) s(n, mean, median) // Categorical variables don't work well with summary stats

tab edu_simple poverty, column // Two-way tables can be more helpful!

* What about poverty breakdown for males? For females?
summarize poverty if sex == 1, det

tabstat poverty, by(sex) s(n, mean, median, sd, var)

*****************************
* Variable and Value Labels *
*****************************

* How do we change the label for a variable?
label variable edu_simple "Simplified Education"

label variable minor "Age <= 18"

* What if we wanted to change the labels of the values inside the variable (all the 1's and 2's, etc.)?
label define MinorLab 0 "Adult" 1 "Minor"

label values minor MinorLab

* What if we forget how to label stuff?
help label

* What if for some reason we want to know all the labels associated with a dataset?
label dir

**********************************
* Variable Codebook and Recoding *
**********************************

* What if we wanted to know how labels and values correspond for a particular variable? 
codebook sex // Plus summary statistics and other fun stuff!

* What about changing categorical values, or even making new variables with different values?
recode sex (1 = 0) (2 = 1), gen(female) // Recoding the sex variable into a "female" dummy variable

* Alternatively, gen female = (sex > 1) would also work to create female dummy variable.

label variable female "Dummy for Female"

label define FemaleLab 0 "Male" 1 "Female"

label values female FemaleLab

save "data\ACS_17_Basics_Update.dta", replace

*****************************
* Missing Data and Outliers *
*****************************

* Missing Values:

use "data\PP297_Survey.dta", clear

* Does our data contain any missing values? For example for country1 or hoursperweek?
tab country1
tab country1, m //Notice that 9 observations are missing, giving blank values

tab hoursperweek
tab hoursperweek, m //Notice that 1 observation is missing, giving an "." or NA

* Note: Many datasets don't use "." by default, they have their own special value for missing responses, like "-2"
	* Always check your data for missing values through tab!
	
	* To read more on Missing Values: https://www.reed.edu/data-at-reed/resources/Stata/missing-values.html
	* More advanced guide with Stata commands: https://stats.idre.ucla.edu/stata/modules/missing-values/
	* Even more advanced guide with Python commands: https://towardsdatascience.com/how-to-handle-missing-data-8646b18db0d4
	
	
* Outliers:

* Notice the response of 20 hours of work expected per week (real response!)
* Is this an outlier? Should we leave it in the data?

* From Wolfram Alpha: "A convenient definition of an outlier is a point which falls more than 1.5 
	* times the interquartile range above the third quartile or below the first quartile."
	
tabstat hoursperweek, s(p25, p75, iqr)
display 1.5*1.5 //Interquartile range times 1.5
display 3+1.5 //Third quartile plus interquartile range times 1.5 (outlier limit)

display 20 >= 4.5
	*Yes, it is an outlier! But do we want it in our data?
	* Depends whether it is an outlier due to an error; assuming it isn't, we should keep it!

* Or, another way to calculate the same thing, looking ahead to next week's egen command:

egen hour_iqr = iqr(hoursperweek)
gen hour_outlier_test = hour_iqr*1.5

egen hour_max = max(hoursperweek)
display hour_max >= hour_outlier_test

* If we did want to eliminate it, should we remove the single data point or the entire observation? How would we going about doing either?

replace hoursperweek = . if hoursperweek >= 4.5 // To change the single data points to missing values

tab hoursperweek, m

drop if hoursperweek >= 4.5 // To eliminate all observations with "outlier" hours (entire row of data)

tab hoursperweek, m

* Again, the answer is no, don't remove anything unless you think there is an error.

* If you do have to remove it, consider if it was an honest mistake (incorrect bubble on survey) or a biased respondent
	* If it was an isolated mistake, remove the single data point.
	* If it was biased reporting, you may need to remove the entire observation. But you lose sample size quickly!

	* To read more on outliers: https://www.theanalysisfactor.com/outliers-to-drop-or-not-to-drop/

	
********************************************
* Fun Stata Fact for the Quant Problem Set *
********************************************

* There are ways in Stata to create output tables for summary statistics across multiple variables.
* We'll get into them later in the Stata course, 
	* but in the Quant Problem Set 1 you have to run a hypothesis test for almost 20 variables...
	
* Without getting "fancy" with Stata and running for loops or using saved output (both things we'll do later),
	* you can also use Stata with Excel by copying table output in an Excel friendly format.
		
* In the Stata Output window, highlight the entire table you want to copy, right click to open the menu,
	* and hit "Copy table". Then paste this into Excel as is.
	
* It's not the fastest way to do it but without more advanced Stata skills this should help with the problem set.	
