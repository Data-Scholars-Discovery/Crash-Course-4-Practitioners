*-------------------------------------------------------*
* Data Science Crash Course 4 Practitioners				*
* Session 1: Introduction to Stata						*
* Created by: Aaron Scherf (aaron_scherf@berkeley.edu)	*
* Instructor Edition									*
*-------------------------------------------------------*

* Today's Commands:

* display
* generate
* set observations (set obs)
* browse
* replace
* clear
* help
* cls
* pwd
* cd
* dir
* global
* import
* describe
* export
* save
* use
* tabulate (tab)
* sysuse
* summarize (sum)
* tabstat (mean, p50, variance, sd)

*----------------------*
* 0. Welcome to Stata! *
*----------------------*

/* Stata is a simple but powerful statistical programming application that has
long been the standard for social scientists conducting empirical research. 
The program is proprietary, meaning it is privately owned by Stata Corp but 
many organizations (such as universities, government agencies, think tanks, etc.) 
offer licenses for their employees, so it's a very useful program to know, 
particularly as a legacy application since many previous research
has been conducted primarily if not exclusively in Stata.

Stata is a bit different from other data science programming languages 
(like R or Python) in the way it organizes data objects, but otherwise it 
follows similar command-based structures. The syntax of Stata is quite intuitive
and doesn't involve as much "programming" as other languages. There is also an 
extensive set of point-and-click menu options for things like data management,
analysis, and visualization. For these reasons, Stata is a great program for 
beginners in data science to learn the fundamentals. It also offers some of 
the most robust applications for survey-based data.

Stata commands are often stored in a script, called a do-file (like this one). 
Code is executed either from the do-file or directly in the main console. 
Stata is a bit unusual in separating the do-file and console into separate 
windows but otherwise the system functions like other programs. The do-file 
editor works like traditional text-editing software, with familiar "File" and 
"Edit" tabs at the top. The console window is split into three main sections: 
the command line (bottom), output (center), and variables list (right). There 
is also the command history on the left and similar drop-down menus at the top.
We will operate primarily within the do-file but view our output in the main 
console, so it's best to have both open on a split-screen. */

* Note: In do-files, green text are comments, which are not executed as code 
* if the entire do-file is executed. Black text is run as code. 
* Comments always either begin with an asterisk (*)
* or are surrounded by a "begin-comment" (/*) and "end-comment" symbol (*/)
* I tend to use the single asterisk for single-line comments 
/* and the comment-bracket for longer text. */

* The fancy section headings are purely decorative to make it easier to read.


*-----------------------------------------------------------*
* Objects and the Global Environment (Variables and Memory) *
*-----------------------------------------------------------*

/* Other programming languages, like R and Python, operate around the concept of
objects. Objects can be individual numbers, lines of text, data files, etc.
Stata is a bit different. In Stata you typically operate in a single dataframe, 
organized into rows of observations and columns of variables. This is due to 
Stata's history as a fancy survey-data calculator. Over time, programmers have
developed ways to create temporary objects outside of the "spreadsheet style"
dataframe, but most of your work will still be associated with the main data table. */

/* Data in Stata (yes it rhymes) is stored in the program's temporary memory.
Other languages refer to this as the "Global Environment" so we will do so for
consistency. You can save data to the environment using commands or import data
from other sources (like CSV files or Stata specific .dta files). First let's
see how commands in Stata work and data is stored. We will begin with the basics
of Stata, returning to what I call the "glorified calculator" mode. */

* Click on the command line at the bottom of Stata and try typing the following:

display 2+2
display 3*4
display 18/6
display 3^3

/* Notice that, yes, you need to start with the `display` command every time.
Otherwise Stata will give you an error message. `display` does exactly what it 
sounds like, displays results, similar to "print" functions in other languages.
Notice that the **Variables** window is still blank. No calculations were saved. */

/* To save a variable, we will use the `generate` command. This is, again, an
intuitive command that generates a new variable of data. Most Stata commands 
have a full name, which sound like what they do, and a shorthand version.
`generate` can also be written as `gen`. */

generate four = 2+2

* Now take a look at your variable:

display four

* What?! Nothing? But we just assigned a variable `four` with a value "2+2" right?
* Wrong. Stata only saves values to observations. It doesn't save arbitrary
* values floating in space (unlike R or Python) unless you use special commands.

* First we need to tell Stata that we want to have observations (rows) in our data.
* To do so, we use the `set observations` command. Shortned to `set obs`

set obs 10

* Now try creating a new variable, `six`:

gen six = 12/2
display six

* Looks more like what we want. But the crazy thing with Stata is that `generate`
* operates across all of your observations. So you didn't just assign `six` to 
* a single row. You assigned it to all of the rows.

* Don't believe me? Check out the dataset yourself using the data browser.
* Either click on the little table with a magnifying glass at the top of your
* main console window or use the following command:

browse

* You should see two columns, `four` and `six`, with data for all 10 rows.
* `four` is likely still empty, since we made it before creating our observations.
* We can go back and replace those empty values with numeric values using
* the aptly named `replace` command.

replace four = 8/2

* Notice that it doesn't matter how you arrive at a value if it evaluates to the
* same thing. 4 == 8/2 == 2+2 == 2^2 (we use double == to indicate equivalence).
* A single = is used to assign variables, like we did with `gen` and then `replace`.
* You can even test out the logical equivalence of values with display:

display four == 4

* The output of this command should be a 1, indicating that the statement is TRUE.
* Data in Stata can be numeric (with several formats of numbers) or text.
* Binary (logical) operators in Stata are stored as "0's" and "1's".
* Let's try making a character string variable:

gen text = "Hello_World"
display text
browse

* Notice in the data browser that numbers have black font and strings are red.


* Commands in Stata must always begin with a function like `display` or `gen`.
* Unlike other languages, Stata won't recognize variables or values without a
* function out front. Most functions have other inputs or arguments, like how
* `gen` requires a variable name, assignment operator (=), and equation.
* Others, like `browse`, can stand alone with their default inputs.

* If you are ever stuck in Stata, there is an amazing `help` function that will
* search through Stata's extensive directory of help files. Most functions are
* named intuitively, so you can use `help` as a kind of keyword search.
* Help files follow a particular layout, with a Title, Syntax, Description, 
* Option, Remarks, and often Examples.
 
* Otherwise you can Google more advanced topics to find example code among the
* global Stata community or in official Stata Corp manuals.


* Once you have assigned variables in Stata, you can perform column-wise
* calculations using those variables:

gen ten = six + four
display ten

* The above line only makes sense to Stata because we previously defined `six`
* and `four` as variables. If we tried it with a name we haven't assigned it will
* give us an error message:

gen eleven = six + five

* You can name variables nearly anything you want as long as it doesn't 
* begin with a number or a symbol.

gen 3 = 4
gen ! = 8

* For ease of reading and reproducibility, however, we try to standardize
* variables in a way that makes logical sense to others reading our code.



*------------------------------------*
* 2. Clearing the Global Environment *
*------------------------------------*

/* Stata, unlike some programs, refuses to overwrite variables once they're defined.
This helps prevent mistakes in calling two variables the same thing.
But still, we don't want to accidentally start using the wrong data,
so it's quite common to start off every do-file script with a command that
clears the global environment and deletes the temporary memory from Stata. */

clear 

* Does exactly what it says, clears the global memory. Search the following:

help clear 

* Notice that any variables you had made or data from before is gone.

browse


* A totally unrelated command which some people confuse with this is:

cls

* Which clears the results window, mostly for aesthetic effect.
* Note: the `cls` command does nothing to your temporary memory or environment.


*-------------------------------------*
* 3. Working Directory and File Paths *
*-------------------------------------*

/* You can do almost everything in Stata using the drop-down menus in the main
window, but this is quite terrible practice from a reproducibility standpoint.
One of the big mistakes beginners make is using the "File" and "Open" menus
to bring in their data, which results in do-files that don't list the actual
dataset which is being used in them.

Instead, we prefer to open, import, save, and export our data using scripts.
In order to do that, we need to define the "Working Directory", or folder
on our computer where Stata is (by default) saving and looking for our data.
Stata, unlike some languages, refers to this as the "Command Directory".

We can easily check the current command directory using the `pwd` command. 
Confusingly, this stands for "print working directory". */

pwd

* In Windows, we can also use the "change directory" command, `cd`.

cd

* Without further arguments, this is equivalent to pwd ONLY FOR WINDOWS.
* For Mac users, `cd` with no arguments changes the current direct to the default.
* Why is there a difference? No idea, but it may be fixed in a later update.

/* You can change the directory to another folder in your computer by adding
a text string of the file-path after `cd`. The file-path system also differs
between Windows and Macs so be careful. You can usually get the exact file-path
by opening the folder in the File Explorer and copying the text from the
directory (set of folders) at the top by right-clicking. */


* Set Command Directory
cd "C:\Users\theaa\Desktop\Crash-Course-4-Practitioners"

*Note: Mac directories use "/" instead of "\". Blame Steve Wozniak I guess.

/* To navigate through your folders directly from Stata, you can examine the
folders and files inside your current directory using the `dir` command. */

dir


/* To speed up the process of changing directories, you can save the name of 
your main folder as a "global macro". This is similar to saving scalar objects
in other languages and there is a lot you can use it for, but for now we will
use it simply to save the file-path of our main (sometimes called master) folder. */

global Path = "C:\Users\theaa\Desktop\Crash-Course-4-Practitioners"

* Then you can call the global macro as a scalar text string with the `$` sign.

cd $Path

* Note: You absolutely need the `$` when calling global macros!

* This is mostly useful to then create sub-directory macros, to call other folders.
* Now we can specify the "Data" sub-folder without re-typing the whole file-path.

global Data_Path = "$Path" + "\Data"

* Notice we combined two text strings using just the `+` sign.
* Other programs require functions to concatenate (combine) strings.
* Stata can do it with arithmetic operators! Cool!

/* Note: Another weird macro thing, we had to surround the `Path` macro with both
quotation marks and a `$`, to let Stata know it's a text-string and macro. */


* Now we can make our working directory the "Data" folder using macros!

cd $Data_Path
dir


/*Why would we do this, except to be lazy? Mostly it's to make it easier for other
programmers to use our file. Instead of "hard-coding" the file-path from your
computer into every line, you can set your global macros for file-paths at the 
top of your script then just call them as objects throughout your do-file.
It also speeds up our coding, which is always nice for lazy programmers. */


*------------------------------------*
* 4. Importing and Viewing CSV Files *
*------------------------------------*

* That was a lot of computer programming stuff just to import some data,
* but I promise it's worth it to learn these habits early.

* Now that we know how to set our working directory and explore file-paths,
* we can easily import data files from within Stata do-files!

* Let's import the `housing.csv` file in our data directory.
* If you don't have such a file, make sure to download the data from Kaggle:
* https://www.kaggle.com/camnugent/california-housing-prices/downloads/california-housing-prices.zip/1
* Or from the Crash Course GitHub repo:
* https://github.com/Data-Scholars-Discovery/Crash-Course-4-Practitioners

/* If you haven't used GitHub before, just click the green **Clone or Download**
button at the top right, then select **Download Zip**. 
GitHub is the standard open-source data sharing and file management system, 
built on its own programming language called Git. 
You don't need to know Git to use GitHub but eventually it will become necessary, 
so best to get in the practice of using GitHub now. 
For a basic intro to GitHub check out the GitHub Guides on their website:
https://guides.github.com/activities/hello-world/

Once the `housing.csv` file is in your "Data" folder we can import it as follows:*/

import delimited "housing.csv", clear

* `import` makes sense, `delimited` specifies that it is a 
* "comma delimited values" or CSV file, and the file name is in a text string.
* The final part, clear, is an option that clears out any previous data.

* You should now see variables in the global environment. If it didn't work,
* check to make sure you set the "Data" folder as your working directory.

* We can now examine the data inside the CSV using the `browse` command:

browse

* We can also examine all of the variables in the results window using `describe`:

describe

* This gives us the name, type, format, and label for each variable.
* We can also see the number of observations (obs) and variables (vars).


* Before we explore the data further, we have to talk about .dta files.
* Stata has its own data file type, which is quite useful as it stores formats,
* labels, and other helpful metadata all in one place, which a CSV would lose.

* It's common to use CSV files to transfer data to other programs like R,
* but when working within Stata we like to use .dta files, as they're faster.

* So let's save our data immediately as a .dta file:

save "housing.dta", replace

* Again, `save` is self-explanatory, then we make a file-name in a text string,
* and use the option (after the comma) `replace` to automatically overwrite
* other files that may have the same name.


* To open, or use, .dta files the command is simply `use` with similar options:

use "housing.dta", clear

* Now we have our data saved in a Stata format, but we can easily export as a CSV

export delimited "housing.csv", replace

/* Now you can import, export, save, and open the most common types of data!
There are plenty of other file types, such as .xls Excel files.
To work with them just use the `help import` or `help export` commands.
Or, if all else fails, use the "File" drop-down menu and "Import".
Just remember to copy the code into your do-file! */

*--------------------------------*
* Intermission: Finding New Data *
*--------------------------------*

/*
There is a lot of data out there but if you're interested in finding your own 
data we recommend searching through the following sources:

Kaggle Datasets: https://www.kaggle.com/datasets
re3data Resources by Subject: https://www.re3data.org/browse/by-subject/
World Health Organization Global Health Observatory: https://www.who.int/gho/database/en/
World Bank Open Data: https://data.worldbank.org/
Google Public Data: https://www.google.com/publicdata/directory
Harvard Dataverse: https://dataverse.harvard.edu/
*/

*--------------------------------------*
* 5. Creating a Dataframe and Indexing *
*--------------------------------------*

/* Most of your analysis will be on pre-existing data. It's rare to actually 
build a full data set using Stata, unless you automate it with a function. 
However, it's helpful to learn about making dataframes to better understand 
the structure and how the indexing system works. Stata is very different from
other languages like R or Python in this regard, in that the entire environment
is usually just a single dataframe, rather than containing multiple objects.

Generally speaking, in data science, dataframes are objects which can contain 
different types of data (numeric, string, logical, etc.) organized into columns. 
You can think of an Excel spreadsheet made up of rows and columns, where rows 
typically represent a single observation, while columns represent variables. 

Let's explore this by clearing our environment and creating a new dataframe. */

clear
set obs 3
gen city_names = "NA"

* We created a dataframe with three observations and one variable, `city_names`.
* We started by generating a variable with "NA" values in string form.

browse

/*In Stata, each observation is automatically assigned a row number, as in Excel.
Rows start at 1 and increase by 1 for each row, as you would expect, so the 300th
observation has a row number of 300. This is unlike Python, which starts at 0.

Unlike other programs, Stata doesn't have a simple way to refer to columns by
their number or position. It prefers the variable names. So if you want to select
a particular row or column to explore you have to use observation numbers or
variable names. We've already selected variable names for commands like `gen` and
`replace` simply by writing the name after the command. To specify the row, we 
use the qualifier `in` and a row number after our command and variable name.
However, to explore single values we usually don't use `display` or `describe`.

Instead, we use a command called `tabulate` or `tab` for short. 
By default, `tab` will print the value for every observation for a variable.
To select a single observation from a single variable, we can `tab` it and use
the qualifer `in` after the variable name, along with the row number.*/

tab city_names in 1

* This displays the value of "NA", under the variable name, and its frequency (1).
* The `in` qualifier can also be used to select multiple rows:

tab city_names in 1/3

* Now, since all of our values are "NA" it counts them up and gives the frequency.

* It's boring to have a dataset of all the same values though, so let's use
* the `in` qualifier to change each observation to a different city.

replace city_names = "San Francisco" in 1
replace city_names = "New York City" in 2
replace city_names = "Austin" in 3

* Now tab the entire variable to view all the values:

tab city_names

* Or use the `in` qualifier to select just the second row:

tab city_names in 2

* Great, we almost have a dataframe! Let's add another variable for population:

gen population = 0
replace population = 884363 in 1
replace population = 8623000 in 2
replace population = 950715 in 3

* Then we can describe the whole dataframe:

describe

/* Notice we have 3 observations and 2 variables. Also note that the storage 
type and display format are different for each. `city_names` is "str13" and 
"%13s" meaning it's a string with length of 13 characters, while `population` 
is a "float" with the format "%9.0g" meaning it is a numeric variable of the 
general format. The "9" means it has a overall width (number of character spaces)
of 9, the "." means it uses a period for a decimal rather than a comma, and the 
"0" means it displays no values after the decimal. Largely you won't need to 
worry about formatting but it's good to know about.*/


*------------------------------*
* Basic Descriptive Statistics *
*------------------------------*

/* The easiest way to get descriptive statistics on variables is, unsurprisingly,
the `summarize` function, or `sum` for short. Not to be confused with addition. 
Let's bring back our housing data so we have more data to work with.*/

use "housing.dta.", clear

summarize population

* Notice you automatically get the default of Obs, Mean, Std. Dev., Min, and Max
* To see even more statistics you can use the `detail` option after the comma

sum total_rooms, detail

* Now you get various percentiles, the smallest and largest 4 observations,
* Obs, Sum of Wgt (only for use with survey weights), Mean, Std. Dev., 
* Variance, Skewness, and Kurtosis. If you haven't heard of the last two it's 
* alright, they aren't commonly used (except in finance and hard sciences).

* We already introduced `tab` but we said the housing data has too many obs
* for it to be useful. So we'll introduce another generic dataset from the 
* standard Stata system library, with the `sysuse` command.

sysuse auto, clear

* Now that we have just 74 observations we can explore `tab` in more detail:

* Frequency Tables - One Way
tabulate mpg

* You see all the values in the dataset for the variable mpg on the left,
* the number of times they appear (frequency) next, then the percentage and
* cumulative percentage of the dataset they represent.

* You can also tab categories, like "Foreign vs Domestic" and summarize things

tab foreign, summarize(mpg)

* This produces a clean, useful table of summary stats based on all categories

* You can also `tab` two-ways, using one variable for rows and another for
* columns on the output table. This provides a lot of data so it's only useful
* for variables with just a few unique values.

* Frequency Tables - Two Way
tab mpg foreign

* You can also create "percentages" by row or column using the option `row` 
* or `column` after the comma. This can help compare very large or small values.

* The `row` option shows the percentage distribution of values in foreign
* for every value of mpg.

tab mpg foreign, row

* While `column` option is the opposite, values of mpg for each option in foreign

tab mpg foreign, column

* Finally, the `cell` option will give percentage values for each unique row-column

tab mpg foreign, cell


* The last command we will cover is the versatile `tabstat`, which--as it sounds--
* is a form of tabulating with more statistic options. `tabstat` lets you
* specify which statistics you want (like mean, var, or sd) in the options

tabstat mpg, s(mean)

* You can select multiple stats and also split the resulting table `by` a
* second variable, a quick way to make the exact summary table you need.

tabstat mpg, by(foreign) s(mean, p25, p75 p50, var, sd)


*-----------------------*
* Conclusion and Review *
*-----------------------*

/* This process of clearing the environment, setting the working directory, 
importing a dataset, and summarizing its variables is often the first part 
of every data analysis project you will do. 

Congratulations, you're officially doing data science!

To review, here are the functions we learned today:


* display
* generate
* set observations (set obs)
* browse
* replace
* clear
* help
* cls
* pwd
* cd
* dir
* global
* import
* describe
* export
* save
* use
* tabulate (tab)
* sysuse
* summarize (sum)
* tabstat (mean, p50, variance, sd)


If you don't recognize any of these or what they do please feel free to go back 
up and review. These are all "bread and butter" commands that you will be using 
quite a lot, so make sure to know what they are. If you want to explore them in 
even more detail you can also look them up using the `help` search command. 
The help-file for each function will give you a description, list of possible 
arguments and their default values, and some example code. It's always good to 
check the help-file whenever you are using a new function!


Again, welcome to the Stata community! Our next lesson will focus on basic 
data management and processing. Happy programming! */


