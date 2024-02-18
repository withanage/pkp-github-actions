-   [PKP Github actions](#pkp-github-actions)
    -   [Usage](#usage)
        -   [Input variables](#input-variables)
    -   [Default configuration for
        OJS/OMP/OPS](#default-configuration-for-ojsompops)
        -   [Explanation](#explanation)
    -   [Example configuration for pkp-lib or
        plugins](#example-configuration-for-pkp-lib-or-plugins)
        -   [Explanation](#explanation-1)
        -   [pkp branch integration
            progress](#pkp-branch-integration-progress)
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


| Variable     | Description                                           | Default             |
|--------------|-------------------------------------------------------|---------------------| 
| repository   | github repository name                                | Current repository  |
| application  | PKP Application (OJS\| OMP\| OPS)                     | Current application |
| branch       | git branch                                            | Current branch      |
| validate     | run valiadtoin tests true\|false                      | true                |
| test         | run unit and integration tests true\|false            | true                |
| upgrade      | run upgrade tests , only for pull requests            | true                |
| node_version | can be set manually for older versions eg. 16.1.0     | 20.11.0             |
| reset_commit | Explicitly test a certain version of PKP Application  | -                   |



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

### pkp branch integration progress
| Application | main | Stable-3_4_0 | Stable-3_3_0 |
|-------------|------|--------------|--------------| 
| OJS         | x    |              |              | 
| OMP         | x    |              |              | 
| OPS         | x    |              |              | 
| pkp-lib     | x    |              |              | 


### Next steps

- remove additional variables
- get rid of long variable combination e.g. ${{inputs.application || github.event.repository.name}}
- Find a github actions way to set the env variables better, in shell scripts we need them explicitly, creating duplication

References
-  https://github.blog/2022-05-09-supercharging-github-actions-with-job-summaries/

### Acknowledgements
- During the development: chat.openai.com used as a help tool


