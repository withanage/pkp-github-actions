
# Introduction


# PKP Github actions 

## Introduction
The PKP Github actions support automated tests for continuous integration in OJS, OMP and OPS.
Currently, the PKP applications include unit tests (PHPUnit) and integrated tests (Cypress) as well as upgrade tests.
These tests are automatically executed in a virtual environment to ensure that no regressions occur and functionality is guaranteed for tested workflow steps.



## Usage
Github actions  are included in main and  newer stable branches of PKP applications in following file
```bash
.github/workflows/main.yml
```
### Input variables
Input variables  control the way, github-actions are executed.
They provide the flexibility to run the tests on applications, plugins and pkp-lib.

| Variable     | Description                                       | Default             |
|--------------|---------------------------------------------------|---------------------| 
| repository   | github repository name                            | Current repository  |
| application  | PKP Application :OJS\| OMP\| OPS                  | Current application |
| branch       | git branch                                        | Current branch      |
| validate     | run valiadtoin tests true\|false                  | false               |
| test         | run unit and integation tests true\|false         | false               |
| upgrade      | run upgrade tests , only for pull requests        | false               |
| node_version | can be set manually for older versions eg. 16.1.0 | stable              |



## Example configuration  for OJS/OMP/OPS
```yml
on: [push, pull_request]
name: main
jobs:
  main:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
       database: ['mysql']
       php-version: [ '8.1','8.2']
    name: main
    steps:
      - uses: pkp/pkp-github-actions@v1
        with:
         repository: 'pkp'
         application: 'omp'
         branch: 'main'
         validate: true
         test: true
         upgrade: true
        
```

## Example configuration for pkp-plugins

```yml
on: [push, pull_request]
name: pkp-lib
jobs:
  pkp-lib:
    runs-on: ubuntu-latest
    strategy:
      fail-fast: false
      matrix:
        application: ['omp','ojs','ops']
        database: ['pgsql','mysql','mariadb']
        php-version: [ '8.1','8.2']

    name: pkp-lib
    steps:
      - uses: pkp/pkp-github-actions@v1
        with:
          application:  ${{matrix.application}}
          repository: pkp
          branch: 'main'
          validate: true
          test: true
          upgrade: true
```


## pkp branch integration progress
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
- global database user name for e.g. ojs-ci to reduce variabls
  https://github.blog/2022-05-09-supercharging-github-actions-with-job-summaries/


