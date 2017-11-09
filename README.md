## "Function vs. interpretability of compound linking elements in German"

**Roland Schäfer¹ & Elizabeth Pankratz² (2017/2018)**

¹Freie Universität Berlin, ²Humboldt Universität zu Berlin

- **Paper website  http://rolandschaefer.net/?p=1532**
- **Data storage   https://github.com/rsling/linkingelements**
- **Contact email  mail@rolandschaefer.net**

This is the README file for data package and paper LaTeX/knitr sources.

1. To replicate the full analysis, you have to get some large data
   files (if you checked this out from Github). To download them,
   type the following in Bash (MacOS or GNU/Linux - or hypothetically
   Windows with Bash and POSIX tools) after descending to this
   folder:
```
   Data/get_bigfiles.sh
```
2. You can check how the count files and other data bases were
   generated by checking out the following Bash scripts:
``` 
   Data/Database/make_counts.sh
   Data/Database/make_data.sh
   Data/Database/make_real_blacklists.sh
```
   This is usually not required, however. The generated files
   are included in the distribution, and it takes a long time
   to re-generate them.

3. To see how we did the data generation for the corpus study
   and creation of stimuli, check the following file:
```
   Data/R/corpus.data.R
```
4. To check how we analysed the (manually annotated) corpus data
   in R, see this file:
```
   Data/R/corpus.analyse.R
```
5. To check how we analysed the split-100 experiment in R, see
   this file:
```
   Data/R/split100.analyse.R
```
6. The data from the experiment (including PsychPy files), which are
   analysed by the script in step 5 is located in
```
   Data/Split100/
```
7. To see how we integrated the data into the main paper, see
   the knitr sources including the make file:
```
   Paper/leglossa.Rnw
   Paper/Makefile
```
