-   [PKP Github actions](#pkp-github-actions)
    -   [Usage](#usage)
        -   [Input variables](#input-variables)
    -   [Default configuration for
        OJS/OMP/OPS](#default-configuration-for-ojsompops)
        -   [Explanation](#explanation)
    -   [Example configuration for pkp-lib or
        plugins](#example-configuration-for-pkp-lib-or-plugins)
        -   [Explanation](#explanation-1)
    -   [Branch integration progress](#branch-integration-progress)
    -   [Next steps](#next-steps)
    -   [Acknowledgements](#acknowledgements)


# PKP Github actions 

The PKP GitHub Actions facilitate automated testing for continuous integration within OJS, OMP, and OPS.

Presently, PKP applications incorporate unit tests (PHPUnit) and integrated tests (Cypress), alongside upgrade tests.
These tests undergo automated execution within a virtual environment, serving to prevent regressions and ensure 
the functionality of tested workflow steps.

## Usage
GitHub Actions have been integrated into the main and latest stable branches of PKP applications, 
and their configuration can be found in the following file_path `.github/workflows/main.yml`.

### Input variables


| Variable     | Description                                                         | Default   |
|----------------|---------------------------------------------------------------------|-----------| 
| repository   | github repository name                                              | Current repository |
| application  | PKP Application (OJS\| OMP\| OPS)                                   | Current application |
| branch       | git branch                                                          | Current branch |
| validate     | run valiadtoin tests true\|false                                    | true      |
| test         | run unit and integration tests true\|false                          | true      |
| upgrade      | run upgrade tests , only for pull requests                          | true      |
| node_version | can be set manually for older versions eg. 16.1.0                   | 20        |
| reset_commit | Explicitly test a certain version of PKP Application                | -         |
| dataset_branch | Identify the OJS Version: eg.g 3_3_0, 3_4_0,main                    | -         |
| debug_in_tmate | When a test fails anywhere, opens a tmate session, with ssh-server. |          |



##  Default configuration for OJS/OMP/OPS
```yml
 1. on: [push, pull_request]
 2. name: main
 3. jobs:
 4.   main:
 5.     runs-on: ubuntu-latest
 6.     strategy:
 7.       fail-fast: false
 8.       matrix:
 9.         database: ['mysql','pgsql','mariadb']
 10.         php-version: [ '8.1','8.2']
 11.     name: main
 12.     steps:
 13.       - uses: pkp/pkp-github-actions@v1
 14.       with :  
 15          upgrade_test: 'stable-3_3_0,stable-3_4_0'
 16.         node_version: 20
 17.         dataset_branch: 'main'
 18.         DATASETS_ACCESS_KEY:  ${{secrets.DATASETS_ACCESS_KEY}}
 19.         DEBUG_IN_TMATE: false
                    
```
### Explanation
1. Github actions Runs on both `pull` and `pull requests`
2. name of the workflow
3. Defines the number of jobs , per action. We have one job , called main, run on 6 different settings, defined in the matrix. 
4. Name of the job
5. Runner Operating system: default Ubuntu and relies on the containers provided by github.com
6. defines the strategy of the current job
7. Run all the  jobs in matrix  independently
8. `matrix` configuration: defines the number of runners
9.  tested database types for pkp applications
10. Currently tested PHP versions. This may be different for different branches
11. name: of the action
12. General definition for steps.  
13. Default integration is pkp-github-actions for OJS/OMP/OPS applications , but e.g. plugins, may run  extra github actions steps or use external github actions.
14.  Additional configurations
15. to which versions the upgrade tests are running
16. node_version
17. For updating datasets, we have to define with ojs version, main / 3.4.0 / 3.3.0
18. Only needed if the datasets get updated.
19. This opens a tmate session, if any test fails
## Example configuration for pkp-lib or plugins

```yml
 1. on: [push, pull_request]
 2. name: pkp-lib
 3. jobs:
 4.   pkp-lib:
 5.     runs-on: ubuntu-latest
 6.     strategy:
 7.       fail-fast: false
 8.       matrix:
 9.         application: ['omp','ojs','ops']
 10.         database: ['pgsql','mysql','mariadb']
 11.         php-version: [ '8.1','8.2']
 12.     name: pkp-lib
 13.     steps:
 14.       - uses: pkp/pkp-github-actions@v1
 15.         with:
 16.           application:  ${{matrix.application}}
 17.           repository: pkp
 18.           branch: 'main'
 19.           validate: true
 20.           test: true
 21.           upgrade: true

```
### Explanation

Only additional steps from the app configuration are mentioned, for the missing descriptions, see the application example

9.  `matrix` is extended for testing applications. In pkp-lib, all the applications are tested. A plugin developer may exclude, some applications
16. Read the `application` variable from the matrix
17. `repository`: default for pkp-lib is pkp, developers may set their `own repository
18. `branch` : targeted branch of the pkp-application, e.g.main. 
19. `validate`: Option to disable validation to reduce test run-time 
19. `test`: Option to disable validation to reduce test run-time , must be only used to test validation or upgrade
19. `upgrade`: Option to disable upgrade to reduce test run-time 

## Branch integration progress
| Application | main | Stable-3_4_0 | Stable-3_3_0 |
|-------------|------|--------------|--------------| 
| OJS         | x    | x            |              | 
| OMP         | x    | x            |              | 
| OPS         | x    | x            |              | 
| pkp-lib     | x    | x            |              | 


## Next steps

- remove additional variables
- get rid of long variable combination e.g. ${{inputs.application || github.event.repository.name}}
- Find a github actions way to set the env variables better, in shell scripts we need them explicitly, creating duplication


### 3.4
| PHP Version | db                           |
|-------------|------------------------------|
| PHP: 8.0    | TEST=pgsql SAVE_BUILD=true   |
| PHP: 8.1.0  | TEST=pgsql                   |
| PHP: 8.0    | TEST=mariadb SAVE_BUILD=true |
| PHP: 8.1.0  | TEST=mysql SAVE_BUILD=true   |
| PHP: 8.2.0  | TEST=mysql                   |
| PHP: 8.2.0  | TEST=pgsql                   |
| PHP: 8.0    | TEST=mysql                   |


### 3.3

| PHP   | db                    |
|-------|-----------------------|
| 7.3   | pgsql                 |
| 7.3   | mysql                 |
| 7.4   | pgsql                 |
| 7.4   | mysql                 |
| 8.0   | validation            |
| 8.0   | pgsql SAVE_BUILD=true |
| 8.0   | mysql SAVE_BUILD=true |
| 8.1   | pgsql                 |
| 8.1   | mysql                 |
| 8.2.0 | mysql                 |
| 8.2.0 | pgsql                 |



## Development Scenarios

### Scenario 1: Only Application (ojs/omp/ops)

This scenario  assumes, you are only doing enhancements or bugfixes to ojs,omp or ops

1. Clone branch of  your pkp-application to your development environment
   `git clone -b stable-3_4_0  https://github.com/pkp/ojs  $MY_PATH/ojs`
2. Optional: update your pkp-lib and other sub-modules to keep up with changes and include in push commits
  ` git submodule update --init --recursive -f; git add lib/pkp; git commit -m "Submodule update"`
3. Commit and push to your local repository
  
###  Scenario 1: Only pkp-lib 

This scenario assumes, you are doing overall changes to the pkp-lib repository, which affects ojs, omp and ops.

1. In your application, navigate to the `lib/pkp` folder by running `cd lib/pkp`. After updating the git submodule, your remote source should be configured accordingly.
`  https://github.com/pkp/pkp-lib`
2. Add your repository "lib-pkp" as a source.
 `git remote add your_username https://github.com/your_username/pkp-lib`
 `git fetch origin stable-3_4_0` 
 `git checkout -b feature_branch refs/remotes/origin/stable-3_4_0 -f  `
3. Perform your modifications in the feature branch.
4.  Push the changes to your pkp-lib repository. Push triggers tests of your changes
 `git push your_username feature_branch `
This will trigger   tests against omp,ojs,ops automatically.If you would like to expand or reduce the tests , you can change the application matrix.
`https://github.com/your_username/pkp-lib/tree/feature_branch/.github/workflows`

 Info: your ojs, omp and ops tests are running against the selected pkp branch. 
 
### Scenatio 4: Application + pkp-lib

Here's the scenario breakdown for each approach:

### Scenario 1: Change GitHub workflow to target repository and branch

1. **Change GitHub Workflow File:**
   Modify the GitHub workflow file located at:
   ```
   https://github.com/your_username/pkp-lib/tree/feature_branch/.github/workflows/stable-3_4_0.yml
   ```
   to point  to your repository and the desired branch  is selected.


### Scenario 2: Modify .gitmodules file in the application folder of OJS, OMP, OPS

1. **Update .gitmodules File:**
   Modify the `.gitmodules` file within the application folder of OJS, OMP, OPS.   You would change the URL to point to your repository temporarily for testing purposes.
   ```
   [submodule "pkp-lib"]
       path = pkp-lib
       url = https://github.com/your_username/pkp-lib.git
   ```
   After testing the feature, ensue that you reset this change in final pull request     
Choose the one that suits your workflow and requirements best.

### Plugin development
 This is similar to scenario 2 Plugin deve














References
-  https://github.blog/2022-05-09-supercharging-github-actions-with-job-summaries/

## Acknowledgements
- During the development: chat.openai.com used as a help tool

