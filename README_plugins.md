-   [Using pkp-github-actions in
    Plugins](#using-pkp-github-actions-in-plugins)
    -   [Plugin content](#plugin-content)
        -   [Running environments](#running-environments)
        -   [adding github action](#adding-github-action)
        - [List of plugins](#List-of-plugins)
-   [Custom tests](#custom-tests)

# Using pkp-github-actions in Plugins


To enable CI/Cd tests in your plugin please create a yml file in  the folder `.github/workflows`
Please note that you need to create the yml file in each branch for different major versions of OJS/OMP and OPS.

## Plugin content
The content of the yml file should look similar to the following content.

```
01: on: [push]
02: name: jobName
03: jobs:
04:   jobName:
05:     runs-on: ubuntu-latest
06:     strategy:
07:       fail-fast: false
08:       matrix:
09:         include:
10:           - application: ojs
11:             php-version: 8.3
12:             database: mysql
13:           - application: omp
14:             php-version: 8.2
15:             database: mysql
16:
17:     name: myplugin
18:     steps:
19:       - uses: pkp/pkp-github-actions@v1
20:         with:
21:           node_version: 20
22:           branch: main
23:           repository: pkp
24:           plugin: true
25:           dataset_inject: true # optional
```

Example
- https://github.com/pkp/pluginTemplate/blob/main/.github/workflows/main.yml

###  Running environments
To run your Github actions under different configurations, Github actions allow you to configure a matrix
In this matrix, you can specify the application, the PHP version and the database which your plugin should be running on.
in the above example, see the lines 10-15

### adding github action
- Line 19: adds the Github Action to the current plugin
- Line 21: which node version should be used. OJS 3.5 uses node 20, OJS 3.4 uses node 16 and OJS 3.3 uses node 12
- Line 22: the branch that the application is targeted at
- Line 23: the repository from which the OJS/OMP/OPS code is taken for testing. You can use your local repository, but pkp is recommended.
- Line 24: mandatory: says, that this is a plugin 
- Line 25: dataset_inject true, only if you need a complete working database, before testing.





## List of plugins


| Plugin              | Software | main                                                                                                                                                                                      | 3.4.0                                                                                                                                                                                                     | 3.3.0                                                                                                                                                                                               |
|---------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| classic  | OJS      | [![classic](https://github.com/pkp/classic/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/classic/actions/workflows/main.yml)                                  | ---                                                                                                                                                                                                       | [![classic](https://github.com/pkp/classic/actions/workflows/stable-3_3_0.yml/badge.svg)](https://github.com/pkp/classic/actions/workflows/stable-3_3_0.yml)                            |
| customBlockManager  | OJS      | [![customBlockManager](https://github.com/pkp/customBlockManager/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/customBlockManager/actions/workflows/main.yml) | [![customBlockManager](https://github.com/pkp/customBlockManager/actions/workflows/stable-3_4_0.yml/badge.svg)](https://github.com/pkp/customBlockManager/actions/workflows/stable-3_4_0.yml) | [![customBlockManager](https://github.com/pkp/customBlockManager/actions/workflows/stable-3_3_0.yml/badge.svg)](https://github.com/pkp/customBlockManager/actions/workflows/stable-3_3_0.yml) |
|customHeader  | OJS      | [![customHeader](https://github.com/pkp/customHeader/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/customHeader/actions/workflows/main.yml)                   | ---                                                                                                                                                                                                       | [![customHeader](https://github.com/pkp/customHeader/actions/workflows/stable-3_3_0.yml/badge.svg)](https://github.com/pkp/customHeader/actions/workflows/stable-3_3_0.yml)             |
| customLocale        | ALL      | [![customlocale](https://github.com/pkp/customlocale/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/customlocale/actions/workflows/main.yml)                   | [![customlocale](https://github.com/pkp/customlocale/actions/workflows/stable-3_4_0.yml/badge.svg)](https://github.com/pkp/customlocale/actions/workflows/stable-3_4_0.yml)                   | [![customlocale](https://github.com/pkp/customlocale/actions/workflows/stable-3_3_0.yml/badge.svg)](https://github.com/pkp/customlocale/actions/workflows/stable-3_3_0.yml)             |   
| defaultManuscript   | OJS     |  [![defaultManuscript](https://github.com/pkp/defaultManuscript/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/defaultManuscript/actions/workflows/main.yml)   | [![defaultManuscript](https://github.com/pkp/defaultManuscript/actions/workflows/stable-3_4_0.yml/badge.svg)](https://github.com/pkp/defaultManuscript/actions/workflows/stable-3_4_0.yml)                   | [![defaultManuscript](https://github.com/pkp/defaultManuscript/actions/workflows/stable-3_3_0.yml/badge.svg)](https://github.com/pkp/defaultManuscript/actions/workflows/stable-3_3_0.yml)             |                                                                                                                                                                                       | ---                                                                                                                                                                                                       | ---                                                                                                                                                                                                 
| healthSciences      | OJS      | [![healthSciences](https://github.com/pkp/healthSciences/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/healthSciences/actions/workflows/main.yml)             | [![healthSciences](https://github.com/pkp/healthSciences/actions/workflows/stable-3_4_0.yml/badge.svg)](https://github.com/pkp/healthSciences/actions/workflows/stable-3_4_0.yml)             | [![healthSciences](https://github.com/pkp/healthSciences/actions/workflows/stable-3_3_0.yml/badge.svg)](https://github.com/pkp/healthSciences/actions/workflows/stable-3_3_0.yml)       |
| immersion           | OJS      | [![immersion](https://github.com/pkp/immersion/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/immersion/actions/workflows/main.yml)                            | ---                                                                                                                                                                                                       | ---                                                                                                                                                                                                 |
| lucene              | OJS      | [![lucene](https://github.com/pkp/lucene/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/lucene/actions/workflows/main.yml)                                     | ---                                                                                                                                                                                                       | [![lucene](https://github.com/pkp/lucene/actions/workflows/stable-3_3_0.yml/badge.svg)](https://github.com/pkp/lucene/actions/workflows/stable-3_3_0.yml)                               |
| oaiJats             | OJS      | [![oaiJats](https://github.com/pkp/oaiJats/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/oaiJats/actions/workflows/main.yml)                                  | [![oaiJats](https://github.com/pkp/oaiJats/actions/workflows/stable-3_4_0.yml/badge.svg)](https://github.com/pkp/oaiJats/actions/workflows/stable-3_4_0.yml)                                  | [![oaiJats](https://github.com/pkp/oaiJats/actions/workflows/stable-3_3_0.yml/badge.svg)](https://github.com/pkp/oaiJats/actions/workflows/stable-3_3_0.yml)                            |
| pluginTemplate      | OJS      | [![pluginTemplate](https://github.com/pkp/pluginTemplate/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/pluginTemplate/actions/workflows/main.yml)             | [![pluginTemplate](https://github.com/pkp/pluginTemplate/actions/workflows/stable-3_4_0.yml/badge.svg)](https://github.com/pkp/pluginTemplate/actions/workflows/stable-3_4_0.yml)             | ---                                                                                                                                                                                                 |
| pragma              | OJS      | [![pragma](https://github.com/pkp/pragma/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/pragma/actions/workflows/main.yml)                                     |                                                                                                                                                                                                           | [![pragma](https://github.com/pkp/pragma/actions/workflows/stable-3_3_0.yml/badge.svg)](https://github.com/pkp/pragma/actions/workflows/stable-3_3_0.yml)       |                                                                                                                                                                                 | ---                                                                                                                                                                                                       | ---                                                                                                                                                                                                       |
| quickSubmit         | OJS      | [![quickSubmit](https://github.com/pkp/quickSubmit/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/quickSubmit/actions/workflows/main.yml)                      | [![quickSubmit](https://github.com/pkp/quickSubmit/actions/workflows/stable-3_4_0.yml/badge.svg)](https://github.com/pkp/quickSubmit/actions/workflows/stable-3_4_0.yml)                      | [![quickSubmit](https://github.com/pkp/quickSubmit/actions/workflows/stable-3_3_0.yml/badge.svg)](https://github.com/pkp/quickSubmit/actions/workflows/stable-3_3_0.yml)                |
| staticPages         | ALL      | [![staticPages](https://github.com/pkp/staticPages/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/staticPages/actions/workflows/main.yml)                      | [![staticPages](https://github.com/pkp/staticPages/actions/workflows/stable-3_4_0.yml/badge.svg)](https://github.com/pkp/staticPages/actions/workflows/stable-3_4_0.yml)                      | [![staticPages](https://github.com/pkp/staticPages/actions/workflows/stable-3_3_0.yml/badge.svg)](https://github.com/pkp/staticPages/actions/workflows/stable-3_3_0.yml)                |
| webFeed             | ALL      | [![webFeed](https://github.com/pkp/webFeed/actions/workflows/main.yml/badge.svg)](https://github.com/pkp/webFeed/actions/workflows/main.yml)                                  | [![webFeed](https://github.com/pkp/webFeed/actions/workflows/stable-3_4_0.yml/badge.svg)](https://github.com/pkp/webFeed/actions/workflows/stable-3_4_0.yml)                      |                |

# Custom tests
To run your plugin tests, you have to create a `tests.sh` file under the directory, `.github/actions`
The content is plugin dependent. See the following examples

Examples

- https://github.com/pkp/oaiJats/blob/main/.github/actions/tests.sh
- https://github.com/pkp/quickSubmit/blob/main/.github/actions/tests.sh
