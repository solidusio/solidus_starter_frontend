# Solidus Starter Frontend development information
This document aims to give some extra information for developers that are going 
to contribute to our `solidus_starter_frontend` component.

## Solidus Compare tool
`solidus_compare` is a tool that we created to keep track of the changes made to
[solidus_frontend](https://github.com/solidusio/solidus/tree/master/frontend), 
which we used as source project in the beginning.

It is connected to our CI; when a new PR is opened, if a change is detected on 
Solidus Frontend, the workflow will fail and it will report the files changed.

In that case, it is needed to evaluate those changes and eventually apply them 
to our component. After this step, it is possible to mark those changes as 
"managed".

In practical terms:
- run locally `bin/solidus_compare` in any branch;
- evaluate the diff of the changes shown in the console;
- apply the required changes (if they are useful to the project);
- run `bin/solidus_compare -u` which will update the hashes in the config file;
- commit the changes and check the CI.

The tool internally works in this way:
- configuration file is loaded (`config/solidus_compare.yml`);
- remote GIT source is updated using the parameters provided by the config file;
- compare process is executed and a hash for each file is calculated;
- if they match the hashes saved in the configuration there are no differences.
