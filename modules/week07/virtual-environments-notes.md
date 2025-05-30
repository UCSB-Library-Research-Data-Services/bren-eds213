# Virtual Environments Notes


## Renv (Reproducible Environments) in R

![source: https://rstudio.github.io/renv/articles/renv.html](../../img/renv.png)

We are going to add renv to our shorebird data cleaning project. Make
sure you have the renv package installed:

```r
install.packages("renv")
```

You may also choose Tools>Project Options>Environments and check "use
renv for this project"

Or at the R console:

```r
renv::init( )
```

Let's check the new files that we have...

- Look at the .gitignore
- Look at the renv.lock file

Let's say we reworked our script and suppose we would need the
[naniar](https://cran.r-project.org/web/packages/naniar/vignettes/getting-started-w-naniar.html)
R package to deal with the NAs. Let's update or virtual environment:

```r
renv::install("naniar")
```
Add some R code using this package, for example

```r
library(naniar)

snowsurvey_csv %>% 
  miss_var_summary()
```

Alright, now that the installation is completed and we added this package to our code, we can save, and take a snapshot:

```r
renv::snapshot()
```

This action will update the lock file, and we will see naniar and all
its dependencies included.

Let's check. If updated, you should be good to go. If your attempts to
update packages introduced new problems, you may run `renv::restore()` to
revert to the previous state as encoded in the lockfile.

Use `.libPaths()` to confirm where package installations are located!


## Containers

### Binder

Transform your Github repository into a full computing environment: <https://mybinder.org/>

![Level up!](https://media.giphy.com/media/v1.Y2lkPTc5MGI3NjExemkwd3RnMzA4a3FocHZ2bWJscHgxNG9yaW4yeGZ6YzZpaXgzNHJhciZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/x2woMnCz4W0Vy/giphy.gif)



You need to add 2 files:

- runtime.txt
- install.R (spoiler it can leverage renv)


`runtime.txt` sets the R version, in our example:

```
r-4.3.3-2024-02-29
```


`install.R` provides the list of the necessary R packages to install or in our case the renv:

```
install.packages('renv')
renv::restore()
```


<hr>

## Venv Using pip 

### Open the Terminal in VS Code

**Checking our version:**

```bash
python --version
```

Venv comes installed in Python 3 and above.

**Checking what is in the system:**

```bash
pip list
```

A long list of packages, right? So assume we are working with only a few
and want to call the exact versions and dependencies we need. That can
be accomplished with venv.

**Create a new environment:**

-   Create a new folder, your project folder. I will use EDS213. Make
    sure you set the path to this folder.

-   Note: The environment will be created in the current version of
    Python that you are running (in Conda we can specify the version we
    want).

To create the environment: (second venv is the name of the environment)

```bash
python3 -m venv venv213
```

-   The `-m` flag makes sure you are creating a pip that is tied to the
    active Python executable

**Time to activate it:**

```bash
source venv213/bin/activate
```

You can tell it is activated because it shows (venv213) in the prompt.

Let's check which packages are there with a new `pip list`

Nothing, right? Only setup tools, and pip). Nothing to worry about, it
should be this way! Let's proceed.

**Install libraries:**

We will be installing two packages for this exercise.

First:

```bash
pip install numpy
```

And then:

```bash
pip install pandas
```

_This should take a little longer!_

Another `pip list`

Alright, the packages and dependencies installed are right there!


**Export and allow future replication of the environment:**

Let's save the packages and dependencies we have after the installs.

```bash
pip freeze
```

That should be stored in a `requirements.txt file

So let's get it redirected to the required file:

```bash
pip freeze > requirements.txt
```

Question: This file won't leave inside the venv folder, but rather in
the project root folder any idea why?

Well, you only need that file to reproduce the environment. And the venv
should be should throw away and be able to rebuild easily! So, do not
include any project file in that folder and treat that as disposable
after the pip freeze

To double-check if all is good, we can run the following command:

```bash
cat requirements.txt
```

This file should be included in your repository to let others
reinstall your packages and dependencies as needed.

**Deactivate**

If you are done with that, you should deactivate that environment by
typing:

```bash
deactivate
```

Then, you will see you no longer have the environment we created in our
prompt.

If you are willing to delete the environment altogether, you should
delete the directory for the virtual environment

Remove folder:

```bash
rm -rf venv213/
```

**Reusing the Requirements**

*Create a new project folder to reuse the requirements*

```bash
mkdir my-project
```

*Create a virtual env for it*

```bash
python3 -m venv my-project/venv
```

*Activate it*

```bash
source my-project/venv/bin/activate
```

*Install required packages*

```bash
pip install -r requirements.txt
```

-   Attention! Never include project files in the venv folder.

-   Do not commit your venv file to the environment itself to source
    control (git ignore)

-   You may install more packages and update the requirements.txt with
    the pip freeze command

-   You should commit /share only your requirements.txt file. That is
    all that others and your future self need to recreate the
    environment.

-   The environment should be something you should throw away and be
    able to rebuild easily.

-   Make sure to deactivate when done using it.


## Environments in Conda

**Checking what is in the system:**

conda list

To create the environment:

```bash
conda create --name env213
```

proceed (\[y\]/n)? y

Time to activate it

conda activate env213 only work on conda 4.6 and later versions. For
Conda versions prior to 4.6, run:

-   Windows: activate or Linux and macOS: source activate

You can tell it is activated because it shows (venv213) in the prompt.

You can also verify this

```bash
conda info --envs
```

Let's check which packages are there with a new 

```bash
conda list env213
```

Empty, right? Nothing to worry about, it should be this way! Let's
proceed.

**Install packages:**

We will be installing two packages for this exercise.

First:

```bash
conda install numpy
```

proceed (\[y\]/n)? y

And then, one more package:

```bash
conda install Pandas
```

proceed (\[y\]/n)? y

Now check which packages are in the specific environment we are working
on:

```bash
conda list
```

Alright, the packages and dependencies installed are right there!

**Export and allow future replication of the environment:**

Let's save the packages and dependencies we have after the installs.

```bash
conda list --export
```

That should be stored in a environments.yml file

So let's get it redirected to the required file:

```bash
conda list -e > environment.yml
```

This file should be included in your research compendium to let others
reinstall your packages and dependencies as needed.

**Deactivate it:**

If you are done with that, you should deactivate that environment by
typing:

```bash
conda deactivate
```

Note: only works on conda 4.6 and later versions. For conda
versions before 4.6, run:

Windows: `deactivate` or Linux and macOS: `source deactivate`

Then, you will see you no longer have the environment we created in our
prompt.

If you are willing to delete the environment altogether, you should
delete the directory for the virtual environment

**Back to base we can create a new environment based on the .yml
packages and dependencies by running (this is noted on top of the yml
file):**

```bash
conda create --name testenv --file environment.yml
```

proceed (\[y\]/n)? y

**Activate it:**

```bash
conda activate my-env (or see above if conda version \< 4.6)
```

proceed (\[y\]/n)? Y

**Check if packages are there:**

```bash
conda list
```
**Remember to deactivate it when done:**

```bash
conda deactivate (or see above if conda version \< 4.6)
```

Check all your environments `conda env list`

Remove unwanted environment

```python
 conda remove -n testenv --all
 ```

More info:
[[https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html]{.underline}](https://conda.io/projects/conda/en/latest/user-guide/tasks/manage-environments.html)
