# Machine-learning-with-R-classifiers
- Done as an assignment in one of my degree's data science units
- "Defects.csv" is the dataset used in this project. It is the NASA Defects dataset, containing defects data from the NASA Metrics Data Program, see: http://mdp.ivv.nasa.gov.

### The project is done in the following steps:
- **Step 1 and 2: Data exploration and pre-processing**
- 
- **Step 3: Separating dataset into training and testing data**
- 
- **Step 4 and 5: Making and training classifiers, followed by testing**
  - created and tested classifiers are as follows:
  - 
• Decision Tree
• Naïve Bayes
• Bagging
• Boosting
• Random Forest
  
- **Step b - Complaint Parameter Analysis**
  - Extract unique issues
  - Plot histogram for:
    -  most common issues with all companies
    -  issues separated by sub-products
  - Findings are noted in report, backed by statistical tests done in R code

- **Part c - Activity and Complaint Over Time Analysis**
  - Plot time series graph for all issues, 
  - Plot time series graph for each issue separatedly
  - Find top 5 companies with most complaints, and plot them using heat map




<br /><br /><br /><br /><br />

###Data description
Description of the NASA Defect dataset.
Many researchers use static measures to guide software quality predictions. 
Verification and validation (V\&V) textbooks advise using static code complexity 
measures to decide which modules are worthy of manual inspections.
1. Title: Defect Prediction Dataset
2. Source Information [Obtained from PROMISE data set]
 [Originally attributed to as follows]
 
NASA, then the NASA Metrics Data Program, http://mdp.ivv.nasa.gov.
 For more information, contact Tim Menzies (tim@barmag.net)
3. Number of Instances: 1108
4. Number of Attributes: 21 + output attribute.
5. Attribute information:
Attribute1. loc : numeric % McCabe's line count of code
Attribute2. v(g) : numeric % McCabe "cyclomatic complexity"
Attribute3. ev(g) : numeric % McCabe "essential complexity"
Attribute4. iv(g) : numeric % McCabe "design complexity"
Attribute5. n : numeric % Halstead total operators + operands
Attribute6. v : numeric % Halstead "volume"
Attribute7. l : numeric % Halstead "program length"
Attribute8. d : numeric % Halstead "difficulty"
Attribute9. i : numeric % Halstead "intelligence"
Attribute10. e : numeric % Halstead "effort"
Attribute11. b : numeric % Halstead 
Attribute12. t : numeric % Halstead's time estimator
Attribute13. lOCode : numeric % Halstead's line count
Attribute14. lOComment : numeric % Halstead's count of lines of comments
Attribute15. lOBlank : numeric % Halstead's count of blank lines
Attribute16. lOCodeAndComment: numeric
Attribute17. uniq_Op : numeric % unique operators
Attribute18. uniq_Opnd : numeric % unique operands
Attribute19. total_Op : numeric % total operators
Attribute20. total_Opnd : numeric % total operands
Attribute21: branchCount : numeric % of the flow graph
Attribute22. defects : {FALSE,TRUE}% module has/has not one or more reported defect
